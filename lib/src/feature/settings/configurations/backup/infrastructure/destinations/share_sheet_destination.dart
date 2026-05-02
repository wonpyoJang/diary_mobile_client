import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

/// 시스템 공유 시트(Share Sheet)를 통해 백업 파일을 외부 앱(Google Drive,
/// Dropbox, AirDrop 등)으로 보내는 destination.
///
/// 목록/삭제는 공유 시트 특성상 지원하지 않는다.
@injectable
class ShareSheetDestination implements BackupDestination {
  @override
  BackupDestinationKind get kind => BackupDestinationKind.shareSheet;

  @override
  Future<bool> get isAvailable async => true;

  @override
  Future<Either<BackupFailure, Unit>> sendFile(
    String filePath,
    String suggestedFileName,
  ) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath, name: suggestedFileName)],
        subject: '백업 파일 공유',
      );
      return right(unit);
    } catch (e) {
      return left(BackupFailure(message: '공유 시트 호출 실패: $e'));
    }
  }

  @override
  Future<Either<BackupFailure, List<String>>> listFiles() async {
    return right(const <String>[]);
  }

  @override
  Future<Either<BackupFailure, Unit>> deleteFile(String fileName) async {
    return left(const BackupFailure(
      message: '공유 시트는 파일 삭제를 지원하지 않습니다',
    ));
  }

  @override
  bool get supportsListing => false;

  @override
  bool get supportsDelete => false;
}
