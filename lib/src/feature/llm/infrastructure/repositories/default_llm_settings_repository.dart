import 'package:injectable/injectable.dart';

import '../../domain/i_llm_settings_repository.dart';
import '../../domain/llm_settings.dart';

/// Default in-memory stub implementation of [ILlmSettingsRepository].
///
/// This implementation always reports remote mode with no on-device backend
/// and acts as a no-op for writes, so it's safe to use before Track D's
/// Hive-backed implementation is merged. Track D will replace this binding
/// during merge.
@LazySingleton(as: ILlmSettingsRepository)
class DefaultLlmSettingsRepository implements ILlmSettingsRepository {
  @override
  Future<LlmMode> getMode() async => LlmMode.remote;

  @override
  Future<OnDeviceBackend?> getOnDeviceBackend() async => null;

  @override
  Future<void> setMode(LlmMode mode) async {
    // no-op stub
  }

  @override
  Future<void> setOnDeviceBackend(OnDeviceBackend? backend) async {
    // no-op stub
  }

  @override
  Future<bool> hasSeenOptInDialog() async => false;

  @override
  Future<void> markOptInDialogSeen() async {
    // no-op stub
  }
}
