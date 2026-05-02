import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../domain/failures/llm_failure.dart';
import '../domain/i_llm_provider.dart';
import '../domain/i_llm_settings_repository.dart';
import '../domain/llm_request.dart';
import '../domain/llm_settings.dart';

/// Routes [LlmRequest]s to the appropriate [ILlmProvider] based on the
/// user's settings.
///
/// The Gemini remote provider (Track A) is always required and injected
/// via the named binding `gemini_remote`. Optional on-device providers
/// from Track B (`gemma_local`) and Track C (`apple_native`) are resolved
/// lazily through [GetIt] with try/catch since they may not be present
/// in every build.
@LazySingleton()
class LlmRouter {
  final ILlmProvider _gemini;
  final ILlmSettingsRepository _settings;

  LlmRouter(
    @Named('gemini_remote') this._gemini,
    this._settings,
  );

  ILlmProvider? _tryResolve(String name) {
    try {
      return GetIt.instance<ILlmProvider>(instanceName: name);
    } catch (_) {
      return null;
    }
  }

  /// Selects a provider based on the current user [LlmMode] / [OnDeviceBackend].
  ///
  /// Falls back to the Gemini remote provider when on-device mode is
  /// requested but the relevant provider isn't registered, returning
  /// [LlmFailureKind.unavailable] so callers can surface the issue.
  Future<Either<LlmFailure, String>> generate(LlmRequest request) async {
    final mode = await _settings.getMode();

    if (mode == LlmMode.remote) {
      return _gemini.generateText(request);
    }

    final backend = await _settings.getOnDeviceBackend();
    final providerName = switch (backend) {
      OnDeviceBackend.downloadedModel => 'gemma_local',
      OnDeviceBackend.platformNative => 'apple_native',
      null => null,
    };

    if (providerName == null) {
      return left(const LlmFailure(
        message: '[AI] 온디바이스 모델이 선택되지 않았습니다.',
        kind: LlmFailureKind.unavailable,
      ));
    }

    final provider = _tryResolve(providerName);
    if (provider == null) {
      return left(LlmFailure(
        message: '[AI] 요청한 온디바이스 모델($providerName)이 등록되지 않았습니다.',
        kind: LlmFailureKind.unavailable,
      ));
    }

    if (!await provider.isAvailable()) {
      return left(LlmFailure(
        message: '[AI] 온디바이스 모델($providerName)을 현재 사용할 수 없습니다.',
        kind: LlmFailureKind.unavailable,
      ));
    }

    return provider.generateText(request);
  }
}
