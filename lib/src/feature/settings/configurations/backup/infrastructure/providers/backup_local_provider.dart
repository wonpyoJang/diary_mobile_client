import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:archive/archive.dart';

@LazySingleton(as: IBackupLocalProvider)
class BackupLocalProvider implements IBackupLocalProvider {
  final Database _database;

  BackupLocalProvider(this._database, DriftClient _);
  @override
  Future<Either<LocalFailure, File>> exportDriftDatabase() async {
    // 앱의 DB 파일 위치 가져오기
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbDir.path, dbName)); // 네 DB 이름 확인!

    // 백업용 임시 디렉토리 생성
    final tmpDir = await getTemporaryDirectory();
    final now = DateTime.now();

    final formattedDate = DateFormat('yyyy-MM-dd_HHmmss').format(now);
    final backupFile = File(p.join(
      tmpDir.path,
      'crepas_backup_$formattedDate.sqlite',
    ));

    // 파일 복사
    await dbFile.copy(backupFile.path);
    return right(backupFile);
  }

  @override
  Future<Either<LocalFailure, File>> exportMomentsCsv() async {
    try {
      // 1) 모든 모먼트 로드
      final momentRows = await _database.select(_database.momentTable).get();

      // 2) 각 모먼트에 대한 감정 강도와 미디어 수 로드
      final buffer = StringBuffer();
      // 헤더 작성
      buffer.writeln([
        'id',
        'date',
        'modifiedAt',
        'reflection',
        'emotions', // "emotion:intensity" 콤마 연결
        'mediaCount',
      ].map(_escapeCsv).join(','));

      for (final m in momentRows) {
        final intensities =
            await (_database.select(_database.emotionalIntensityTable)
                  ..where((tbl) => tbl.momentId.equals(m.id)))
                .get();
        final medias = await (_database.select(_database.mediaTable)
              ..where((tbl) => tbl.momentId.equals(m.id)))
            .get();

        final emotionsJoined = intensities
            .map((e) => '${e.emotion.name}:${e.intensity.toStringAsFixed(3)}')
            .join('|');

        buffer.writeln([
          m.id,
          m.date.toUtc().toIso8601String(),
          m.modifiedAt.toUtc().toIso8601String(),
          m.reflection,
          emotionsJoined,
          medias.length.toString(),
        ].map(_escapeCsv).join(','));
      }

      // 3) 임시 파일로 저장
      final tmpDir = await getTemporaryDirectory();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd_HHmmss').format(now);
      final file =
          File(p.join(tmpDir.path, 'crepas_moments_$formattedDate.csv'));
      await file.writeAsString(buffer.toString(), flush: true);
      return right(file);
    } catch (e) {
      return left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<LocalFailure, File>> exportMomentsCsvWithMediaZip() async {
    try {
      // CSV 파일 준비
      final csvResult = await exportMomentsCsv();
      final csvFile =
          csvResult.fold<File>((l) => throw Exception(l.message), (r) => r);

      // ZIP 구성: CSV + 각 모먼트의 미디어 원본 파일
      final archive = Archive();
      final csvBytes = await csvFile.readAsBytes();
      archive.addFile(ArchiveFile('moments.csv', csvBytes.length, csvBytes));

      // 모든 미디어 경로를 조회하여 추가 (경로 리매핑 포함)
      final mediaRows = await _database.select(_database.mediaTable).get();
      final documentsDir = await getApplicationDocumentsDirectory();
      final currentDocsPath = documentsDir.path;
      for (final media in mediaRows) {
        final resolvedPath = _remapToCurrentDocumentsPath(
          storedPath: media.path,
          currentDocumentsPath: currentDocsPath,
        );
        final file = File(resolvedPath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          // ZIP 내 경로: medias/<momentId>/<filename>
          final baseName = p.basename(file.path);
          final zipPath =
              p.join('medias', media.momentId, baseName).replaceAll('\\', '/');
          archive.addFile(ArchiveFile(zipPath, bytes.length, bytes));
        }
      }

      final encoded = ZipEncoder().encode(archive);

      final tmpDir = await getTemporaryDirectory();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd_HHmmss').format(now);
      final zipPath = p.join(tmpDir.path, 'crepas_export_$formattedDate.zip');
      final outFile = File(zipPath);
      await outFile.writeAsBytes(encoded, flush: true);
      return right(outFile);
    } catch (e) {
      return left(LocalFailure(message: e.toString()));
    }
  }
}

String _escapeCsv(String raw) {
  // RFC 4180: 필드에 콤마, 따옴표, 줄바꿈이 있으면 따옴표로 감싸고 내부 따옴표는 이스케이프
  final needsQuote = raw.contains(',') ||
      raw.contains('"') ||
      raw.contains('\n') ||
      raw.contains('\r');
  var value = raw.replaceAll('"', '""');
  return needsQuote ? '"$value"' : value;
}

String _remapToCurrentDocumentsPath({
  required String storedPath,
  required String currentDocumentsPath,
}) {
  try {
    if (storedPath.isEmpty) return storedPath;
    const documentsSegment = '/Documents/';
    final idx = storedPath.indexOf(documentsSegment);
    if (idx == -1) {
      return storedPath;
    }
    final relative = storedPath.substring(idx + documentsSegment.length);
    return '$currentDocumentsPath/$relative';
  } catch (_) {
    return storedPath;
  }
}
