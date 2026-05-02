import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IBackupRepository {
  Future<Either<BackupFailure, Unit>> uploadDatabase();
  Future<Either<BackupFailure, Unit>> downloadFromICloud(String fileName);
  Future<Either<BackupFailure, List<String>>> listICloudFiles();
  Future<Either<BackupFailure, Unit>> exportDatabaseZipToUserICloud();

  /// 모든 일기를 CSV로 내보내 사용자의 파일 앱을 통해 저장합니다
  Future<Either<BackupFailure, Unit>> exportMomentsCsvToUserICloud();

  /// CSV와 사진 파일을 함께 ZIP으로 내보내 파일 앱으로 저장합니다
  Future<Either<BackupFailure, Unit>>
      exportMomentsCsvWithMediaZipToUserICloud();
}
