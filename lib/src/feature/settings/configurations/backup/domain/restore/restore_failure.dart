import 'package:diary_mobile_client/src/core/failure/failure.dart';

/// 복원 도메인에서 발생하는 실패.
///
/// 기존 [BackupFailure]와 분리한 이유는 — 호출 측이 백업/복원 흐름을 별도로
/// 다루도록 강제하기 위해서. (UX 메시지/회복 동작이 서로 다름)
class RestoreFailure extends Failure {
  const RestoreFailure({required super.message, super.code, super.details});
}
