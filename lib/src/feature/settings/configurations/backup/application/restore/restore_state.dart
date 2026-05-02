import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:equatable/equatable.dart';

/// 복원 페이지의 단계.
///
/// 페이지의 단계 인디케이터(1/3, 2/3, 3/3)와 직접적으로 연결되지는 않는다.
/// idle → previewing → ready → applying → done 의 흐름을 갖고,
/// 어느 단계에서든 error로 빠질 수 있다.
enum RestorePhase {
  idle,
  previewing,
  ready,
  applying,
  done,
  error,
}

class RestoreState extends Equatable {
  final RestorePhase phase;
  final RestorePreview? preview;
  final RestoreMode? selectedMode;
  final RestoreFailure? failure;
  final String? successMessage;
  final bool isLoading;

  /// SQLite 덮어쓰기 직후 true. 페이지에서 재시작 안내 다이얼로그를 띄운다.
  final bool requiresRestart;

  const RestoreState({
    this.phase = RestorePhase.idle,
    this.preview,
    this.selectedMode,
    this.failure,
    this.successMessage,
    this.isLoading = false,
    this.requiresRestart = false,
  });

  /// sentinel 패턴: failure/successMessage를 명시적으로 null로 만들고 싶을 때
  /// `clearFailure: true`/`clearSuccess: true`를 주면 된다.
  RestoreState copyWith({
    RestorePhase? phase,
    RestorePreview? preview,
    bool clearPreview = false,
    RestoreMode? selectedMode,
    bool clearSelectedMode = false,
    RestoreFailure? failure,
    bool clearFailure = false,
    String? successMessage,
    bool clearSuccess = false,
    bool? isLoading,
    bool? requiresRestart,
  }) {
    return RestoreState(
      phase: phase ?? this.phase,
      preview: clearPreview ? null : (preview ?? this.preview),
      selectedMode:
          clearSelectedMode ? null : (selectedMode ?? this.selectedMode),
      failure: clearFailure ? null : (failure ?? this.failure),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      isLoading: isLoading ?? this.isLoading,
      requiresRestart: requiresRestart ?? this.requiresRestart,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        preview,
        selectedMode,
        failure,
        successMessage,
        isLoading,
        requiresRestart,
      ];
}
