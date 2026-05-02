import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_schedule.dart';
import 'package:equatable/equatable.dart';

class ScheduleState extends Equatable {
  final BackupSchedule schedule;
  final bool isLoading;
  final BackupFailure? failure;
  final String? successMessage;
  final DateTime? lastRunAt;

  const ScheduleState({
    this.schedule = const BackupSchedule(),
    this.isLoading = false,
    this.failure,
    this.successMessage,
    this.lastRunAt,
  });

  ScheduleState copyWith({
    BackupSchedule? schedule,
    bool? isLoading,
    BackupFailure? failure,
    bool clearFailure = false,
    String? successMessage,
    bool clearSuccess = false,
    DateTime? lastRunAt,
  }) {
    return ScheduleState(
      schedule: schedule ?? this.schedule,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }

  @override
  List<Object?> get props =>
      [schedule, isLoading, failure, successMessage, lastRunAt];
}
