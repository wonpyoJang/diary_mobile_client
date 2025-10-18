import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_remote_provider.dart';
import 'package:diary_mobile_client/src/native/icloud/icloud_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IBackupRemoteProvider)
class BackupRemoteProvider implements IBackupRemoteProvider {
  final ICloudService _icloudService;

  BackupRemoteProvider(
    this._icloudService,
  );
  @override
  Future<Either<LocalFailure, Unit>> uploadBackup(
      {required String fileName, required String content}) async {
    final ok = await _icloudService.uploadToICloud(fileName, content);
    return ok ? right(unit) : left(const LocalFailure(message: '백업 업로드 실패'));
  }

  @override
  Future<Either<LocalFailure, Unit>> saveToICloud(String filePath) async {
    final ok = await _icloudService.saveToICloud(filePath);
    return ok ? right(unit) : left(const LocalFailure(message: '백업 저장 실패'));
  }

  @override
  Future<Either<LocalFailure, Unit>> downloadFromICloud(String fileName) async {
    final ok = await _icloudService.downloadFromICloud(fileName);
    return ok != null
        ? right(unit)
        : left(const LocalFailure(message: '백업 다운로드 실패'));
  }

  @override
  Future<Either<LocalFailure, List<String>>> listICloudFiles() async {
    final files = await _icloudService.listICloudFiles();
    return right(files);
  }

  @override
  Future<Either<LocalFailure, Unit>> exportToUserICloud(String filePath) async {
    final ok = await _icloudService.exportToFiles(filePath);
    return ok ? right(unit) : left(const LocalFailure(message: '파일 내보내기 실패'));
  }
}
