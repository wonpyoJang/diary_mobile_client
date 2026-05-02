import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_restore_repository.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_restore_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

/// 복원 리포지토리.
///
/// 현재는 단일 Provider를 그대로 위임하지만, 향후 원격 백업 다운로드 단계가
/// 끼면 이 계층에서 두 Provider를 합치게 된다.
@LazySingleton(as: IRestoreRepository)
class RestoreRepository implements IRestoreRepository {
  final IBackupRestoreProvider _provider;

  RestoreRepository(this._provider);

  @override
  Future<Either<RestoreFailure, RestorePreview>> previewBackup(
    String filePath, {
    RestoreMode? mode,
  }) {
    return _provider.analyzeBackup(filePath, mode: mode);
  }

  @override
  Future<Either<RestoreFailure, Unit>> applyRestore({
    required RestorePreview preview,
    required RestoreMode mode,
  }) {
    return _provider.applyRestore(preview: preview, mode: mode);
  }
}
