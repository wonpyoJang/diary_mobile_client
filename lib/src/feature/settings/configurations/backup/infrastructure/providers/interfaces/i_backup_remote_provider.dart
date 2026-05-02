import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IBackupRemoteProvider {
  Future<Either<LocalFailure, Unit>> uploadBackup(
      {required String fileName, required String content});
  Future<Either<LocalFailure, Unit>> saveToICloud(String filePath);
  Future<Either<LocalFailure, Unit>> downloadFromICloud(String fileName);
  Future<Either<LocalFailure, List<String>>> listICloudFiles();
  Future<Either<LocalFailure, Unit>> exportToUserICloud(String filePath);
}
