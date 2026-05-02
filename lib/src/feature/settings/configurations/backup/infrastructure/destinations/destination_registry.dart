import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/destinations/icloud_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/destinations/local_folder_destination.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/destinations/share_sheet_destination.dart';
import 'package:injectable/injectable.dart';

/// 모든 [BackupDestination] 구현을 보관하는 레지스트리.
///
/// UI에서는 [available]을 통해 현재 플랫폼에서 사용 가능한 destination만 추려서
/// 보여주고, 액션 dispatch에서는 [findByKind]로 호출한다.
@LazySingleton()
class BackupDestinationRegistry {
  final ICloudDestination _icloud;
  final LocalFolderDestination _localFolder;
  final ShareSheetDestination _shareSheet;

  BackupDestinationRegistry(
    this._icloud,
    this._localFolder,
    this._shareSheet,
  );

  /// 등록된 모든 destination (사용 가능 여부와 무관)
  List<BackupDestination> get all => <BackupDestination>[
        _icloud,
        _localFolder,
        _shareSheet,
      ];

  /// 현재 플랫폼/환경에서 사용 가능한 destination만 추린 리스트
  Future<List<BackupDestination>> get available async {
    final result = <BackupDestination>[];
    for (final dest in all) {
      if (await dest.isAvailable) {
        result.add(dest);
      }
    }
    return result;
  }

  /// kind로 단일 destination을 찾는다.
  BackupDestination? findByKind(BackupDestinationKind kind) {
    for (final d in all) {
      if (d.kind == kind) return d;
    }
    return null;
  }
}
