import 'dart:io';

import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 앱의 documents 디렉터리 안 `backups/` 폴더에 백업 파일을 보관하는 destination.
///
/// 모든 플랫폼에서 사용 가능하며 목록/삭제 모두 지원한다.
@injectable
class LocalFolderDestination implements BackupDestination {
  static const String _folderName = 'backups';

  /// `backups/` 디렉터리를 보장하고 [Directory] 핸들을 반환한다.
  Future<Directory> _ensureBackupDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _folderName));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  BackupDestinationKind get kind => BackupDestinationKind.localFolder;

  @override
  Future<bool> get isAvailable async => true;

  @override
  Future<Either<BackupFailure, Unit>> sendFile(
    String filePath,
    String suggestedFileName,
  ) async {
    try {
      final source = File(filePath);
      if (!await source.exists()) {
        return left(BackupFailure(message: '백업 파일을 찾을 수 없습니다: $filePath'));
      }
      final dir = await _ensureBackupDir();
      final dest = File(p.join(dir.path, suggestedFileName));
      await source.copy(dest.path);
      return right(unit);
    } catch (e) {
      return left(BackupFailure(message: '로컬 폴더 저장 실패: $e'));
    }
  }

  @override
  Future<Either<BackupFailure, List<String>>> listFiles() async {
    try {
      final dir = await _ensureBackupDir();
      final entries = await dir.list().toList();
      final files = entries.whereType<File>().toList();
      // 파일명에 포함된 'yyyy-MM-dd_HHmmss' 패턴 기준으로 최신 우선 정렬
      files.sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));
      return right(files.map((f) => p.basename(f.path)).toList());
    } catch (e) {
      return left(BackupFailure(message: '로컬 폴더 목록 조회 실패: $e'));
    }
  }

  @override
  Future<Either<BackupFailure, Unit>> deleteFile(String fileName) async {
    try {
      final dir = await _ensureBackupDir();
      final target = File(p.join(dir.path, fileName));
      if (!await target.exists()) {
        return left(BackupFailure(message: '삭제할 파일을 찾을 수 없습니다: $fileName'));
      }
      await target.delete();
      return right(unit);
    } catch (e) {
      return left(BackupFailure(message: '로컬 파일 삭제 실패: $e'));
    }
  }

  @override
  bool get supportsListing => true;

  @override
  bool get supportsDelete => true;
}
