import 'dart:io';

import 'package:archive/archive.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_format.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_restore_provider.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// 한 모먼트와 부속 데이터를 메모리에 들고 있는 임시 컨테이너.
///
/// CSV/ZIP 파싱 결과와 DB upsert 사이의 중간 표현. 외부에 노출하지 않으므로
/// 별도 도메인 엔티티로 만들지 않고 파일 내부에 둔다.
class _ParsedMoment {
  final String id;
  final DateTime date;
  final DateTime modifiedAt;
  final String reflection;

  /// emotion enum과 0~1 강도. 파싱 실패한 항목은 미리 걸러낸 결과.
  final List<MapEntry<Emotion, double>> emotions;

  /// 미디어 파일 개수(헤더에 적힌 값). zip이 아니면 의미 없음.
  final int mediaCount;

  _ParsedMoment({
    required this.id,
    required this.date,
    required this.modifiedAt,
    required this.reflection,
    required this.emotions,
    required this.mediaCount,
  });
}

/// 형식 감지 + ZIP 해제 + CSV 파싱 + DB 적용을 한 곳에 모은 구현.
///
/// SQLite 덮어쓰기는 DB가 연결된 채로는 안전하지 않으므로 파일만 복사하고
/// 호출 측에서 재시작을 안내하도록 한다.
@LazySingleton(as: IBackupRestoreProvider)
class BackupRestoreProvider implements IBackupRestoreProvider {
  final Database _database;

  BackupRestoreProvider(this._database);

  @override
  Future<Either<RestoreFailure, RestorePreview>> analyzeBackup(
    String filePath, {
    RestoreMode? mode,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return left(const RestoreFailure(message: '파일을 찾을 수 없습니다'));
      }

      final format = await _detectFormat(file);
      if (format == RestoreFormat.unknown) {
        return left(
          const RestoreFailure(
              message: '지원하지 않는 형식입니다 (.sqlite, .zip, .csv 만 지원)'),
        );
      }

      final supportedModes = _supportedModesFor(format);

      // SQLite 류는 파일을 열어 모먼트 수를 세지 않는다 — Drift 인스턴스를
      // 추가로 띄우는 것은 비용이 큼. 파일 크기/생성시각만 보여준다.
      if (format == RestoreFormat.sqlite || format == RestoreFormat.sqliteZip) {
        final stat = await file.stat();
        return right(
          RestorePreview(
            format: format,
            sourcePath: filePath,
            momentCount: -1,
            mediaCount: 0,
            backupCreatedAt: stat.modified,
            conflictCount: 0,
            newCount: 0,
            supportedModes: supportedModes,
            fileSizeBytes: stat.size,
            fileName: p.basename(filePath),
          ),
        );
      }

      // CSV / CSV+media zip: 실제로 파싱해 카운트와 충돌 시뮬레이션 수행
      final csvBytes = await _readCsvBytesFromBackup(file, format);
      final parsed = _parseCsv(csvBytes);
      final mediaCountInZip = format == RestoreFormat.csvMediaZip
          ? await _countMediaEntriesInZip(file)
          : 0;

      // mode 명시가 없거나 merge면 충돌 시뮬레이션 수행
      final shouldSimulate =
          mode == RestoreMode.merge || mode == null;
      var conflict = 0;
      var fresh = 0;
      if (shouldSimulate && supportedModes.contains(RestoreMode.merge)) {
        final ids = parsed.map((m) => m.id).toList();
        final existingIds = await _existingMomentIds(ids);
        for (final m in parsed) {
          if (existingIds.contains(m.id)) {
            conflict++;
          } else {
            fresh++;
          }
        }
      }

      final stat = await file.stat();
      return right(
        RestorePreview(
          format: format,
          sourcePath: filePath,
          momentCount: parsed.length,
          mediaCount: mediaCountInZip,
          backupCreatedAt: stat.modified,
          conflictCount: conflict,
          newCount: fresh,
          supportedModes: supportedModes,
          fileSizeBytes: stat.size,
          fileName: p.basename(filePath),
        ),
      );
    } catch (e) {
      return left(RestoreFailure(message: '미리보기 실패: $e'));
    }
  }

  @override
  Future<Either<RestoreFailure, Unit>> applyRestore({
    required RestorePreview preview,
    required RestoreMode mode,
  }) async {
    try {
      if (!preview.supportedModes.contains(mode)) {
        return left(
          RestoreFailure(
              message: '이 형식은 ${_modeLabel(mode)} 모드를 지원하지 않습니다'),
        );
      }

      switch (preview.format) {
        case RestoreFormat.sqlite:
          return _applySqliteOverwrite(File(preview.sourcePath));
        case RestoreFormat.sqliteZip:
          return _applySqliteZipOverwrite(File(preview.sourcePath));
        case RestoreFormat.csv:
          return _applyCsvRestore(
            File(preview.sourcePath),
            mode: mode,
            mediaArchive: null,
          );
        case RestoreFormat.csvMediaZip:
          return _applyCsvMediaZipRestore(
            File(preview.sourcePath),
            mode: mode,
          );
        case RestoreFormat.unknown:
          return left(const RestoreFailure(message: '알 수 없는 형식입니다'));
      }
    } catch (e) {
      return left(RestoreFailure(message: '복원 실패: $e'));
    }
  }

  // ---------------------------------------------------------------------------
  // 형식 감지
  // ---------------------------------------------------------------------------

  /// 확장자 + ZIP 헤더 + CSV 헤더(첫 줄)까지 보고 종합적으로 결정.
  ///
  /// 단순히 확장자에만 의존하면 사용자가 이름을 바꿨을 때 잘못 분류될 수
  /// 있어서, 내용물도 함께 검사한다.
  Future<RestoreFormat> _detectFormat(File file) async {
    final ext = p.extension(file.path).toLowerCase();
    if (ext == '.sqlite' || ext == '.db') {
      return RestoreFormat.sqlite;
    }
    if (ext == '.csv') {
      return RestoreFormat.csv;
    }
    if (ext != '.zip') {
      return RestoreFormat.unknown;
    }
    // .zip — 안을 들여다보고 분기
    try {
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final hasCsv = archive.files.any(
        (f) => p.basename(f.name).toLowerCase() == 'moments.csv',
      );
      final hasMediaDir = archive.files.any(
        (f) => f.name.replaceAll('\\', '/').startsWith('medias/'),
      );
      if (hasCsv && hasMediaDir) return RestoreFormat.csvMediaZip;
      if (hasCsv) return RestoreFormat.csvMediaZip; // medias 비어있어도 같이 처리
      final hasSqlite = archive.files.any(
        (f) => p.extension(f.name).toLowerCase() == '.sqlite' ||
            p.extension(f.name).toLowerCase() == '.db',
      );
      if (hasSqlite) return RestoreFormat.sqliteZip;
      return RestoreFormat.unknown;
    } catch (_) {
      return RestoreFormat.unknown;
    }
  }

  List<RestoreMode> _supportedModesFor(RestoreFormat format) {
    switch (format) {
      case RestoreFormat.sqlite:
      case RestoreFormat.sqliteZip:
        return const [RestoreMode.overwrite];
      case RestoreFormat.csv:
      case RestoreFormat.csvMediaZip:
        return const [RestoreMode.overwrite, RestoreMode.merge];
      case RestoreFormat.unknown:
        return const [];
    }
  }

  String _modeLabel(RestoreMode mode) =>
      mode == RestoreMode.overwrite ? '덮어쓰기' : '병합';

  // ---------------------------------------------------------------------------
  // CSV 파싱
  // ---------------------------------------------------------------------------

  /// ZIP인 경우 ZIP에서 moments.csv 추출, 아니면 파일 직접 읽기.
  Future<List<int>> _readCsvBytesFromBackup(
    File file,
    RestoreFormat format,
  ) async {
    if (format == RestoreFormat.csv) {
      return file.readAsBytes();
    }
    final archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    final csvEntry = archive.files.firstWhere(
      (f) => p.basename(f.name).toLowerCase() == 'moments.csv',
      orElse: () => throw Exception('ZIP 안에 moments.csv가 없습니다'),
    );
    return csvEntry.content as List<int>;
  }

  Future<int> _countMediaEntriesInZip(File file) async {
    final archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    return archive.files
        .where(
          (f) =>
              !f.isDirectory &&
              f.name.replaceAll('\\', '/').startsWith('medias/'),
        )
        .length;
  }

  /// 헤더는 export 측 코드와 동일하다고 가정.
  /// `id,date,modifiedAt,reflection,emotions,mediaCount`
  List<_ParsedMoment> _parseCsv(List<int> bytes) {
    final text = String.fromCharCodes(bytes);
    final rows = _splitCsvRows(text);
    if (rows.isEmpty) return const [];

    // 헤더 매핑: 사용자가 손댔을 가능성에 대비해 인덱스 동적 결정
    final header = rows.first.map((c) => c.trim().toLowerCase()).toList();
    int idxOf(String name) => header.indexOf(name);
    final iId = idxOf('id');
    final iDate = idxOf('date');
    final iModified = idxOf('modifiedat');
    final iReflection = idxOf('reflection');
    final iEmotions = idxOf('emotions');
    final iMediaCount = idxOf('mediacount');
    if (iId < 0 || iDate < 0 || iReflection < 0) {
      throw Exception('CSV 헤더가 올바르지 않습니다');
    }

    final out = <_ParsedMoment>[];
    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.isEmpty || (row.length == 1 && row.first.trim().isEmpty)) {
        continue;
      }
      try {
        final id = row[iId];
        final date = DateTime.parse(row[iDate]).toLocal();
        final modifiedAt = iModified >= 0 && iModified < row.length
            ? DateTime.parse(row[iModified]).toLocal()
            : date;
        final reflection =
            iReflection < row.length ? row[iReflection] : '';
        final emotionsRaw =
            iEmotions >= 0 && iEmotions < row.length ? row[iEmotions] : '';
        final mediaCount = iMediaCount >= 0 && iMediaCount < row.length
            ? int.tryParse(row[iMediaCount]) ?? 0
            : 0;
        out.add(
          _ParsedMoment(
            id: id,
            date: date,
            modifiedAt: modifiedAt,
            reflection: reflection,
            emotions: _parseEmotions(emotionsRaw),
            mediaCount: mediaCount,
          ),
        );
      } catch (_) {
        // 손상된 한 행 때문에 전체를 막지 않는다 — 조용히 건너뛰고 계속
        continue;
      }
    }
    return out;
  }

  List<MapEntry<Emotion, double>> _parseEmotions(String raw) {
    if (raw.trim().isEmpty) return const [];
    final out = <MapEntry<Emotion, double>>[];
    for (final part in raw.split('|')) {
      final colon = part.indexOf(':');
      if (colon <= 0) continue;
      final name = part.substring(0, colon).trim();
      final value = double.tryParse(part.substring(colon + 1).trim());
      if (value == null) continue;
      try {
        final e = Emotion.findByName(name);
        out.add(MapEntry(e, value));
      } catch (_) {
        // 알 수 없는 감정 이름은 건너뛴다 (앱 버전이 다를 수 있음)
      }
    }
    return out;
  }

  /// RFC 4180 비슷하게 따옴표 안 개행/콤마를 보존하며 행/필드 분리.
  ///
  /// `_escapeCsv`의 역연산. 외부 패키지 없이 처리한다 — 우리가 만든 형식에만
  /// 맞추면 충분.
  List<List<String>> _splitCsvRows(String text) {
    final rows = <List<String>>[];
    var current = <String>[];
    final field = StringBuffer();
    var inQuotes = false;

    void endField() {
      current.add(field.toString());
      field.clear();
    }

    void endRow() {
      endField();
      rows.add(current);
      current = <String>[];
    }

    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (inQuotes) {
        if (c == '"') {
          // 다음 글자가 또 따옴표면 이스케이프된 따옴표
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          field.write(c);
        }
      } else {
        if (c == '"') {
          inQuotes = true;
        } else if (c == ',') {
          endField();
        } else if (c == '\r') {
          // CRLF 처리: 다음 \n은 함께 소비
          if (i + 1 < text.length && text[i + 1] == '\n') {
            i++;
          }
          endRow();
        } else if (c == '\n') {
          endRow();
        } else {
          field.write(c);
        }
      }
    }
    // 마지막 줄에 개행이 없는 경우도 행으로 처리 (단, 완전 빈 트레일링은 제외)
    if (field.isNotEmpty || current.isNotEmpty) {
      endRow();
    }
    return rows;
  }

  // ---------------------------------------------------------------------------
  // DB 조회/적용
  // ---------------------------------------------------------------------------

  Future<Set<String>> _existingMomentIds(List<String> ids) async {
    if (ids.isEmpty) return const <String>{};
    final query = _database.select(_database.momentTable)
      ..where((tbl) => tbl.id.isIn(ids));
    final rows = await query.get();
    return rows.map((r) => r.id).toSet();
  }

  // ---------------------------------------------------------------------------
  // SQLite 덮어쓰기
  // ---------------------------------------------------------------------------

  Future<Either<RestoreFailure, Unit>> _applySqliteOverwrite(
    File backupFile,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dir.path, dbName);
      // Drift가 살아있는 채로 덮어쓰기는 안전하지 않다.
      // 그냥 파일만 교체하고 호출자가 재시작 안내를 띄운다.
      await backupFile.copy(dbPath);
      return right(unit);
    } catch (e) {
      return left(RestoreFailure(message: 'DB 파일 교체 실패: $e'));
    }
  }

  Future<Either<RestoreFailure, Unit>> _applySqliteZipOverwrite(
    File zipFile,
  ) async {
    try {
      final archive = ZipDecoder().decodeBytes(await zipFile.readAsBytes());
      final sqliteEntry = archive.files.firstWhere(
        (f) =>
            !f.isDirectory &&
            (p.extension(f.name).toLowerCase() == '.sqlite' ||
                p.extension(f.name).toLowerCase() == '.db'),
        orElse: () => throw Exception('ZIP 안에 .sqlite 파일이 없습니다'),
      );
      // ZIP 콘텐츠를 임시 파일로 풀어 그대로 dbPath에 복사
      final tmpDir = await getTemporaryDirectory();
      final tmpPath = p.join(
        tmpDir.path,
        'restore_${DateTime.now().millisecondsSinceEpoch}.sqlite',
      );
      final tmp = File(tmpPath);
      await tmp.writeAsBytes(sqliteEntry.content as List<int>, flush: true);
      return _applySqliteOverwrite(tmp);
    } catch (e) {
      return left(RestoreFailure(message: 'ZIP 안의 SQLite 추출 실패: $e'));
    }
  }

  // ---------------------------------------------------------------------------
  // CSV / CSV+media 적용
  // ---------------------------------------------------------------------------

  Future<Either<RestoreFailure, Unit>> _applyCsvRestore(
    File csvFile, {
    required RestoreMode mode,
    required Archive? mediaArchive,
  }) async {
    try {
      final csvBytes = await csvFile.readAsBytes();
      final parsed = _parseCsv(csvBytes);

      // 미디어가 있으면 먼저 풀어서 새 디렉토리에 복사하고,
      // (momentId, basename) → 새 절대 경로 매핑을 만든다.
      String? extractRoot;
      Map<String, String> mediaPathByKey = const {};
      if (mediaArchive != null) {
        extractRoot = await _prepareMediaExtractionDir();
        mediaPathByKey = await _extractMediaArchive(mediaArchive, extractRoot);
      }

      await _database.transaction(() async {
        if (mode == RestoreMode.overwrite) {
          // 충돌 회피를 위해 자식 → 부모 순으로 삭제
          await _database.delete(_database.emotionalIntensityTable).go();
          await _database.delete(_database.mediaTable).go();
          await _database.delete(_database.momentTable).go();
        }

        for (final m in parsed) {
          await _upsertMoment(m, mode);
          await _upsertEmotions(m, mode);
        }

        if (mediaPathByKey.isNotEmpty) {
          await _upsertMediaFromMap(mediaPathByKey, mode);
        }
      });
      return right(unit);
    } catch (e) {
      return left(RestoreFailure(message: 'CSV 적용 실패: $e'));
    }
  }

  Future<Either<RestoreFailure, Unit>> _applyCsvMediaZipRestore(
    File zipFile, {
    required RestoreMode mode,
  }) async {
    try {
      final archive = ZipDecoder().decodeBytes(await zipFile.readAsBytes());
      // CSV 추출 → 임시 파일에 저장하고 _applyCsvRestore 재사용
      final csvEntry = archive.files.firstWhere(
        (f) => p.basename(f.name).toLowerCase() == 'moments.csv',
        orElse: () => throw Exception('ZIP 안에 moments.csv가 없습니다'),
      );
      final tmpDir = await getTemporaryDirectory();
      final tmpCsv = File(
        p.join(
          tmpDir.path,
          'restore_${DateTime.now().millisecondsSinceEpoch}.csv',
        ),
      );
      await tmpCsv.writeAsBytes(csvEntry.content as List<int>, flush: true);
      return _applyCsvRestore(tmpCsv, mode: mode, mediaArchive: archive);
    } catch (e) {
      return left(RestoreFailure(message: 'CSV+media ZIP 적용 실패: $e'));
    }
  }

  /// Documents 하위에 타임스탬프 디렉토리를 만들어 반환.
  Future<String> _prepareMediaExtractionDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final dir = Directory(p.join(docs.path, 'restored_media_$ts'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  /// ZIP 안 medias/<momentId>/<filename> 을 [destRoot] 로 풀고
  /// "<momentId>/<filename>" → 새 절대 경로 맵을 반환.
  Future<Map<String, String>> _extractMediaArchive(
    Archive archive,
    String destRoot,
  ) async {
    final out = <String, String>{};
    for (final entry in archive.files) {
      if (entry.isDirectory) continue;
      final normalized = entry.name.replaceAll('\\', '/');
      if (!normalized.startsWith('medias/')) continue;
      final rel = normalized.substring('medias/'.length);
      final parts = rel.split('/');
      if (parts.length < 2) continue; // medias/<momentId>/<filename> 만 허용
      final outPath = p.joinAll([destRoot, ...parts]);
      final outFile = File(outPath);
      if (!await outFile.parent.exists()) {
        await outFile.parent.create(recursive: true);
      }
      await outFile.writeAsBytes(entry.content as List<int>, flush: true);
      out[rel] = outPath;
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // upsert helpers
  // ---------------------------------------------------------------------------

  Future<void> _upsertMoment(_ParsedMoment m, RestoreMode mode) async {
    if (mode == RestoreMode.overwrite) {
      await _database.into(_database.momentTable).insertOnConflictUpdate(
            MomentTableCompanion.insert(
              id: m.id,
              reflection: m.reflection,
              date: m.date,
              modifiedAt: m.modifiedAt,
            ),
          );
      return;
    }
    // merge: 기존 modifiedAt과 비교 → 최신이 이김
    final existingQuery = _database.select(_database.momentTable)
      ..where((tbl) => tbl.id.equals(m.id));
    final existing = await existingQuery.getSingleOrNull();
    if (existing == null) {
      await _database.into(_database.momentTable).insert(
            MomentTableCompanion.insert(
              id: m.id,
              reflection: m.reflection,
              date: m.date,
              modifiedAt: m.modifiedAt,
            ),
          );
      return;
    }
    if (m.modifiedAt.isAfter(existing.modifiedAt)) {
      // 빈 reflection으로 의미 있는 데이터를 덮어쓰지 않는다
      final newReflection = m.reflection.trim().isEmpty
          ? existing.reflection
          : m.reflection;
      await (_database.update(_database.momentTable)
            ..where((tbl) => tbl.id.equals(m.id)))
          .write(
        MomentTableCompanion(
          reflection: Value(newReflection),
          date: Value(m.date),
          modifiedAt: Value(m.modifiedAt),
        ),
      );
    }
  }

  Future<void> _upsertEmotions(_ParsedMoment m, RestoreMode mode) async {
    if (m.emotions.isEmpty) return;

    if (mode == RestoreMode.overwrite) {
      // overwrite는 트랜잭션 도입부에서 전부 비웠으므로 단순 insert
      const uuid = Uuid();
      for (final e in m.emotions) {
        await _database.into(_database.emotionalIntensityTable).insert(
              EmotionalIntensityTableCompanion.insert(
                id: uuid.v4(),
                emotion: e.key,
                intensity: e.value,
                momentId: m.id,
              ),
            );
      }
      return;
    }

    // merge: 모먼트가 더 최신이면 기존 감정 강도를 교체. 그렇지 않으면 그대로 둔다.
    final existing = await (_database.select(_database.momentTable)
          ..where((tbl) => tbl.id.equals(m.id)))
        .getSingleOrNull();
    if (existing != null && !m.modifiedAt.isAfter(existing.modifiedAt)) {
      return; // 우리쪽이 더 오래됐으면 손대지 않는다
    }
    await (_database.delete(_database.emotionalIntensityTable)
          ..where((tbl) => tbl.momentId.equals(m.id)))
        .go();
    const uuid = Uuid();
    for (final e in m.emotions) {
      await _database.into(_database.emotionalIntensityTable).insert(
            EmotionalIntensityTableCompanion.insert(
              id: uuid.v4(),
              emotion: e.key,
              intensity: e.value,
              momentId: m.id,
            ),
          );
    }
  }

  Future<void> _upsertMediaFromMap(
    Map<String, String> mediaPathByKey,
    RestoreMode mode,
  ) async {
    const uuid = Uuid();
    for (final entry in mediaPathByKey.entries) {
      final parts = entry.key.split('/');
      if (parts.length < 2) continue;
      final momentId = parts.first;
      final fileName = parts.sublist(1).join('/');
      final newAbsPath = entry.value;

      // 부모 모먼트가 존재해야 FK가 만족된다 — 없으면 건너뛰고 로그성 무시
      final parent = await (_database.select(_database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .getSingleOrNull();
      if (parent == null) continue;

      // overwrite: 단순 insert (트랜잭션 시작 시 비웠음)
      if (mode == RestoreMode.overwrite) {
        await _database.into(_database.mediaTable).insert(
              MediaTableCompanion.insert(
                id: uuid.v4(),
                momentId: momentId,
                path: newAbsPath,
                mimeType: _guessMime(fileName),
                createdAt: DateTime.now(),
              ),
            );
        continue;
      }

      // merge: 같은 (momentId, basename)이 이미 있으면 mtime 비교 후 교체.
      // path는 절대 경로이므로 basename으로 매칭.
      final existingMedias = await (_database.select(_database.mediaTable)
            ..where((tbl) => tbl.momentId.equals(momentId)))
          .get();
      final newBase = p.basename(newAbsPath);
      final existing = existingMedias.firstWhere(
        (m) => p.basename(m.path) == newBase,
        orElse: () => MediaTableData(
          id: '',
          momentId: '',
          path: '',
          mimeType: '',
          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );
      if (existing.id.isEmpty) {
        await _database.into(_database.mediaTable).insert(
              MediaTableCompanion.insert(
                id: uuid.v4(),
                momentId: momentId,
                path: newAbsPath,
                mimeType: _guessMime(fileName),
                createdAt: DateTime.now(),
              ),
            );
      } else {
        // 더 최신인 쪽을 유지: 새 파일의 mtime vs 기존 파일의 mtime
        try {
          final existingMtime = await File(existing.path).stat();
          final newMtime = await File(newAbsPath).stat();
          if (newMtime.modified.isAfter(existingMtime.modified)) {
            await (_database.update(_database.mediaTable)
                  ..where((tbl) => tbl.id.equals(existing.id)))
                .write(
              MediaTableCompanion(
                path: Value(newAbsPath),
                createdAt: Value(DateTime.now()),
              ),
            );
          }
        } catch (_) {
          // 기존 파일이 사라진 경우에는 새 경로로 갱신
          await (_database.update(_database.mediaTable)
                ..where((tbl) => tbl.id.equals(existing.id)))
              .write(MediaTableCompanion(path: Value(newAbsPath)));
        }
      }
    }
  }

  String _guessMime(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
}
