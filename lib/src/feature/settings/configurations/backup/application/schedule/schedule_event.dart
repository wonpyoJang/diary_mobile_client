import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_frequency.dart';
import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// 페이지 진입 시 호출. HydratedBloc이 자동 복원하므로
/// 현재 상태를 그대로 emit하는 트리거 역할만 한다.
class LoadSchedule extends ScheduleEvent {
  const LoadSchedule();
}

class ChangeFrequency extends ScheduleEvent {
  final BackupFrequency frequency;
  const ChangeFrequency(this.frequency);

  @override
  List<Object?> get props => [frequency];
}

class ChangePreferredHour extends ScheduleEvent {
  final int hour;
  const ChangePreferredHour(this.hour);

  @override
  List<Object?> get props => [hour];
}

/// 앱 진입/페이지 진입 훅에서 호출. due일 때만 백업 실행.
class RunDueCheck extends ScheduleEvent {
  const RunDueCheck();
}

/// 사용자가 "지금 백업하기" 버튼을 눌렀을 때.
class RunBackupNow extends ScheduleEvent {
  const RunBackupNow();
}

class ClearScheduleMessage extends ScheduleEvent {
  const ClearScheduleMessage();
}
