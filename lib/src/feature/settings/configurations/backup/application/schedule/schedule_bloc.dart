import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/schedule/schedule_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/schedule/schedule_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_backup_repository.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_frequency.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_schedule.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/backup_notifier.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

/// 자동 백업 스케줄을 관리하는 BLoC.
///
/// `BackupBloc`과 storage key는 클래스명 기반으로 분리되므로 충돌하지 않는다.
/// 영속화 대상은 [BackupSchedule] (빈도, 선호 시각, 마지막 성공 시각).
@injectable
class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  final IBackupRepository _repository;
  final BackupNotifier _notifier;

  ScheduleBloc(
    this._repository,
    this._notifier,
  ) : super(const ScheduleState()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<ChangeFrequency>(_onChangeFrequency);
    on<ChangePreferredHour>(_onChangePreferredHour);
    on<RunDueCheck>(_onRunDueCheck);
    on<RunBackupNow>(_onRunBackupNow);
    on<ClearScheduleMessage>(_onClearScheduleMessage);
  }

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    // HydratedBloc이 자동 복원하므로 메시지만 비우고 현재 상태 그대로 emit.
    emit(state.copyWith(clearFailure: true, clearSuccess: true));
  }

  Future<void> _onChangeFrequency(
    ChangeFrequency event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(
      schedule: state.schedule.copyWith(frequency: event.frequency),
      clearFailure: true,
      clearSuccess: true,
    ));
  }

  Future<void> _onChangePreferredHour(
    ChangePreferredHour event,
    Emitter<ScheduleState> emit,
  ) async {
    final clamped = event.hour.clamp(0, 23);
    emit(state.copyWith(
      schedule: state.schedule.copyWith(preferredHour: clamped),
      clearFailure: true,
      clearSuccess: true,
    ));
  }

  Future<void> _onRunDueCheck(
    RunDueCheck event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.schedule.isDue(DateTime.now())) {
      await _runBackup(emit);
    }
  }

  Future<void> _onRunBackupNow(
    RunBackupNow event,
    Emitter<ScheduleState> emit,
  ) async {
    await _runBackup(emit);
  }

  Future<void> _runBackup(Emitter<ScheduleState> emit) async {
    if (state.isLoading) return;

    emit(state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearSuccess: true,
    ));

    final result = await _repository.uploadDatabase();
    final now = DateTime.now();

    await result.fold(
      (failure) async {
        await _notifier.notifyBackupFailed(failure.message);
        emit(state.copyWith(
          isLoading: false,
          failure: failure,
          lastRunAt: now,
        ));
      },
      (_) async {
        await _notifier.notifyBackupSuccess(now);
        emit(state.copyWith(
          isLoading: false,
          schedule: state.schedule.copyWith(lastSuccessAt: now),
          successMessage: '자동 백업이 완료되었습니다',
          lastRunAt: now,
        ));
      },
    );
  }

  Future<void> _onClearScheduleMessage(
    ClearScheduleMessage event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(clearFailure: true, clearSuccess: true));
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) {
    try {
      final scheduleJson = json['schedule'];
      if (scheduleJson is Map<String, dynamic>) {
        return ScheduleState(
          schedule: BackupSchedule.fromJson(scheduleJson),
        );
      }
      // 구버전 호환: 단일 필드만 저장돼 있을 수도 있음.
      final freqRaw = json['frequency'];
      if (freqRaw is String) {
        final frequency = BackupFrequency.values.firstWhere(
          (f) => f.name == freqRaw,
          orElse: () => BackupFrequency.off,
        );
        return ScheduleState(
          schedule: BackupSchedule(frequency: frequency),
        );
      }
    } catch (_) {
      // 복원 실패 시 기본 상태로 폴백.
    }
    return const ScheduleState();
  }

  @override
  Map<String, dynamic>? toJson(ScheduleState state) {
    return {
      'schedule': state.schedule.toJson(),
    };
  }
}
