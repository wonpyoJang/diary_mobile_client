import 'dart:io';

import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:diary_mobile_client/src/native/icloud/icloud_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

/// iCloud 컨테이너에 직접 저장하는 destination (iOS 전용).
///
/// iOS의 [ICloudService]를 래핑하여 동일한 [BackupDestination] 인터페이스로
/// 노출한다. iCloud는 파일 목록 조회는 지원하지만 삭제는 지원하지 않는다.
@injectable
class ICloudDestination implements BackupDestination {
  final ICloudService _icloudService;

  ICloudDestination(this._icloudService);

  @override
  BackupDestinationKind get kind => BackupDestinationKind.icloud;

  @override
  Future<bool> get isAvailable async => Platform.isIOS;

  @override
  Future<Either<BackupFailure, Unit>> sendFile(
    String filePath,
    String suggestedFileName,
  ) async {
    if (!Platform.isIOS) {
      return left(const BackupFailure(
        message: 'iCloud는 iOS에서만 사용할 수 있습니다',
      ));
    }
    try {
      final ok = await _icloudService.saveToICloud(filePath);
      if (ok) {
        return right(unit);
      }
      return left(const BackupFailure(message: 'iCloud 저장에 실패했습니다'));
    } catch (e) {
      return left(BackupFailure(message: 'iCloud 저장 중 오류: $e'));
    }
  }

  @override
  Future<Either<BackupFailure, List<String>>> listFiles() async {
    if (!Platform.isIOS) {
      return right(const <String>[]);
    }
    try {
      final files = await _icloudService.listICloudFiles();
      return right(files);
    } catch (e) {
      return left(BackupFailure(message: 'iCloud 파일 목록 조회 실패: $e'));
    }
  }

  @override
  Future<Either<BackupFailure, Unit>> deleteFile(String fileName) async {
    return left(const BackupFailure(
      message: 'iCloud에서는 앱 안에서 직접 삭제할 수 없습니다',
    ));
  }

  @override
  bool get supportsListing => true;

  @override
  bool get supportsDelete => false;
}
