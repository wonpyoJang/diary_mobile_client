import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/restore/restore_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/restore/restore_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_restore_repository.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_format.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// 복원 페이지 전용 Bloc.
///
/// 복원은 한 번 들어가서 한 번 끝내고 나오는 흐름이라 영속화하지 않는다.
@injectable
class RestoreBloc extends Bloc<RestoreEvent, RestoreState> {
  final IRestoreRepository _repository;

  RestoreBloc(this._repository) : super(const RestoreState()) {
    on<PickRestoreFile>(_onPick);
    on<SelectRestoreMode>(_onSelectMode);
    on<ConfirmRestore>(_onConfirm);
    on<ResetRestore>(_onReset);
    on<ClearRestoreMessage>(_onClearMessage);
  }

  Future<void> _onPick(
    PickRestoreFile event,
    Emitter<RestoreState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      phase: RestorePhase.previewing,
      clearFailure: true,
      clearSuccess: true,
      clearPreview: true,
      clearSelectedMode: true,
      requiresRestart: false,
    ));

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['sqlite', 'db', 'zip', 'csv'],
      withData: false,
    );
    final path = picked?.files.single.path;
    if (path == null) {
      // 사용자가 취소 — 조용히 idle로 복귀
      emit(state.copyWith(isLoading: false, phase: RestorePhase.idle));
      return;
    }

    final result = await _repository.previewBackup(path);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        phase: RestorePhase.error,
        failure: failure,
      )),
      (preview) {
        // 기본 모드: 가능한 모드 중 첫 번째 — 보통 overwrite가 선택됨
        // (UI에서 사용자가 골라야 하므로 미리 골라두지 않는 옵션도 있지만,
        // 명확성을 위해 디폴트를 잡아둔다)
        final defaultMode = preview.supportedModes.isEmpty
            ? null
            : preview.supportedModes.first;
        emit(state.copyWith(
          isLoading: false,
          phase: RestorePhase.ready,
          preview: preview,
          selectedMode: defaultMode,
        ));
      },
    );
  }

  void _onSelectMode(
    SelectRestoreMode event,
    Emitter<RestoreState> emit,
  ) {
    final preview = state.preview;
    if (preview == null) return;
    if (!preview.supportedModes.contains(event.mode)) return;
    emit(state.copyWith(selectedMode: event.mode));
  }

  Future<void> _onConfirm(
    ConfirmRestore event,
    Emitter<RestoreState> emit,
  ) async {
    final preview = state.preview;
    final mode = state.selectedMode;
    if (preview == null || mode == null) {
      emit(state.copyWith(
        phase: RestorePhase.error,
        failure: const RestoreFailure(message: '복원할 파일과 모드를 먼저 선택해주세요'),
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      phase: RestorePhase.applying,
      clearFailure: true,
      clearSuccess: true,
    ));

    final result = await _repository.applyRestore(
      preview: preview,
      mode: mode,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        phase: RestorePhase.error,
        failure: failure,
      )),
      (_) {
        final isSqliteOverwrite = mode == RestoreMode.overwrite &&
            (preview.format == RestoreFormat.sqlite ||
                preview.format == RestoreFormat.sqliteZip);
        emit(state.copyWith(
          isLoading: false,
          phase: RestorePhase.done,
          successMessage: '복원이 완료되었습니다',
          requiresRestart: isSqliteOverwrite,
        ));
      },
    );
  }

  void _onReset(ResetRestore event, Emitter<RestoreState> emit) {
    emit(const RestoreState());
  }

  void _onClearMessage(
    ClearRestoreMessage event,
    Emitter<RestoreState> emit,
  ) {
    emit(state.copyWith(clearFailure: true, clearSuccess: true));
  }
}
