import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../domain/i_llm_capability_probe.dart';
import '../domain/i_llm_settings_repository.dart';
import '../domain/llm_settings.dart';

abstract class LlmSettingsEvent extends Equatable {
  const LlmSettingsEvent();

  @override
  List<Object?> get props => const [];
}

class LoadSettings extends LlmSettingsEvent {
  const LoadSettings();
}

class ChangeMode extends LlmSettingsEvent {
  final LlmMode mode;

  const ChangeMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ChangeOnDeviceBackend extends LlmSettingsEvent {
  final OnDeviceBackend backend;

  const ChangeOnDeviceBackend(this.backend);

  @override
  List<Object?> get props => [backend];
}

class LlmSettingsState extends Equatable {
  final LlmMode mode;
  final OnDeviceBackend? backend;
  final bool gemmaDownloaded;
  final bool appleAvailable;
  final bool isLoading;

  const LlmSettingsState({
    this.mode = LlmMode.remote,
    this.backend,
    this.gemmaDownloaded = false,
    this.appleAvailable = false,
    this.isLoading = false,
  });

  LlmSettingsState copyWith({
    LlmMode? mode,
    OnDeviceBackend? backend,
    bool clearBackend = false,
    bool? gemmaDownloaded,
    bool? appleAvailable,
    bool? isLoading,
  }) {
    return LlmSettingsState(
      mode: mode ?? this.mode,
      backend: clearBackend ? null : (backend ?? this.backend),
      gemmaDownloaded: gemmaDownloaded ?? this.gemmaDownloaded,
      appleAvailable: appleAvailable ?? this.appleAvailable,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [mode, backend, gemmaDownloaded, appleAvailable, isLoading];
}

@injectable
class LlmSettingsBloc extends Bloc<LlmSettingsEvent, LlmSettingsState> {
  final ILlmSettingsRepository _repository;
  final ILlmCapabilityProbe _capabilityProbe;

  LlmSettingsBloc(this._repository, this._capabilityProbe)
      : super(const LlmSettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeMode>(_onChangeMode);
    on<ChangeOnDeviceBackend>(_onChangeOnDeviceBackend);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<LlmSettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final mode = await _repository.getMode();
    final backend = await _repository.getOnDeviceBackend();
    final gemmaDownloaded = await _capabilityProbe.canRunGemmaLocal();
    final appleAvailable = await _capabilityProbe.canRunAppleFoundation();
    emit(LlmSettingsState(
      mode: mode,
      backend: backend,
      gemmaDownloaded: gemmaDownloaded,
      appleAvailable: appleAvailable,
      isLoading: false,
    ));
  }

  Future<void> _onChangeMode(
    ChangeMode event,
    Emitter<LlmSettingsState> emit,
  ) async {
    await _repository.setMode(event.mode);
    if (event.mode == LlmMode.remote) {
      // Clear backend selection when switching back to remote.
      await _repository.setOnDeviceBackend(null);
      emit(state.copyWith(mode: event.mode, clearBackend: true));
    } else {
      emit(state.copyWith(mode: event.mode));
    }
  }

  Future<void> _onChangeOnDeviceBackend(
    ChangeOnDeviceBackend event,
    Emitter<LlmSettingsState> emit,
  ) async {
    await _repository.setOnDeviceBackend(event.backend);
    emit(state.copyWith(backend: event.backend));
  }
}
