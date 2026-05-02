import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:equatable/equatable.dart';

abstract class RestoreEvent extends Equatable {
  const RestoreEvent();

  @override
  List<Object?> get props => [];
}

/// file_picker로 파일을 고르고 미리보기까지 한 번에 수행한다.
class PickRestoreFile extends RestoreEvent {
  const PickRestoreFile();
}

/// 라디오에서 모드를 바꾸면 발사. 병합인 경우 충돌 시뮬레이션을 다시 돌릴
/// 수도 있지만, 현재 구현은 분석 단계에서 한 번만 계산한다.
class SelectRestoreMode extends RestoreEvent {
  final RestoreMode mode;
  const SelectRestoreMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// 사용자가 확인 다이얼로그에서 최종 승인했을 때.
class ConfirmRestore extends RestoreEvent {
  const ConfirmRestore();
}

/// 페이지 재진입 시 상태를 초기화.
class ResetRestore extends RestoreEvent {
  const ResetRestore();
}

/// SnackBar 표시 후 메시지를 클리어할 때.
class ClearRestoreMessage extends RestoreEvent {
  const ClearRestoreMessage();
}
