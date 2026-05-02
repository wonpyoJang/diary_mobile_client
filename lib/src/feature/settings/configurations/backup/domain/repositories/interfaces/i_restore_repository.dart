import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:fpdart/fpdart.dart';

abstract class IRestoreRepository {
  /// 사용자가 고른 파일을 분석해 형식/카운트/충돌 시뮬레이션을 모두 마친
  /// [RestorePreview]를 반환한다.
  ///
  /// [mode]가 주어지면 그 모드 기준으로만 충돌 시뮬레이션을 수행한다(병합인 경우).
  /// 생략하면 가능한 모드들을 모두 추론하고, 병합 가능 시 그쪽 시뮬레이션을 수행한다.
  Future<Either<RestoreFailure, RestorePreview>> previewBackup(
    String filePath, {
    RestoreMode? mode,
  });

  /// 미리보기에 담긴 [RestorePreview.sourcePath]를 사용해 실제 복원을 적용한다.
  ///
  /// SQLite 덮어쓰기 모드의 경우, 이 메서드는 DB 파일만 교체하고 끝난다.
  /// 호출 측에서 사용자에게 재시작을 안내해야 한다.
  Future<Either<RestoreFailure, Unit>> applyRestore({
    required RestorePreview preview,
    required RestoreMode mode,
  });
}
