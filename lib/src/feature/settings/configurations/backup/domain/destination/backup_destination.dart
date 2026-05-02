import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:fpdart/fpdart.dart';

/// 백업 파일을 어디로든 보낼 수 있게 추상화한 인터페이스.
///
/// 각 destination(iCloud, 로컬 폴더, 공유 시트)은 이 인터페이스를 구현하여
/// 동일한 방식으로 호출되도록 한다.
abstract class BackupDestination {
  /// destination 종류
  BackupDestinationKind get kind;

  /// 현재 플랫폼/환경에서 사용 가능한지 여부.
  ///
  /// 예: iCloud destination은 iOS에서만 true를 반환한다.
  Future<bool> get isAvailable;

  /// 파일을 destination으로 보낸다.
  ///
  /// [filePath]는 로컬 파일 시스템 상의 절대 경로,
  /// [suggestedFileName]은 destination 측에 저장될 때 권장되는 파일명이다.
  Future<Either<BackupFailure, Unit>> sendFile(
    String filePath,
    String suggestedFileName,
  );

  /// destination에 저장된 백업 파일 목록을 반환한다.
  ///
  /// 목록 조회를 지원하지 않는 destination은 `right(<String>[])`을 반환한다.
  Future<Either<BackupFailure, List<String>>> listFiles();

  /// destination에서 [fileName]에 해당하는 파일을 삭제한다.
  ///
  /// 삭제를 지원하지 않으면 `left(BackupFailure)`를 반환한다.
  Future<Either<BackupFailure, Unit>> deleteFile(String fileName);

  /// 이 destination이 listFiles를 의미 있게 지원하는지 여부 (UI 분기에 사용)
  bool get supportsListing;

  /// 이 destination이 deleteFile을 지원하는지 여부 (UI 분기에 사용)
  bool get supportsDelete;
}
