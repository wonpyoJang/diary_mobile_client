import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:fpdart/fpdart.dart';

/// 복원 흐름의 저수준 책임.
///
/// 형식 감지, ZIP 해제, CSV 파싱, DB 트랜잭션, 미디어 파일 복사 등 IO 무거운
/// 작업을 모아둔다. Repository 계층은 이 Provider 위에서 흐름만 조립한다.
abstract class IBackupRestoreProvider {
  /// 파일 형식을 분석해 미리보기 객체를 만든다.
  /// [mode]가 [RestoreMode.merge]이면 충돌 시뮬레이션도 수행한다.
  Future<Either<RestoreFailure, RestorePreview>> analyzeBackup(
    String filePath, {
    RestoreMode? mode,
  });

  /// 미리보기를 토대로 실제 복원을 수행한다.
  Future<Either<RestoreFailure, Unit>> applyRestore({
    required RestorePreview preview,
    required RestoreMode mode,
  });
}
