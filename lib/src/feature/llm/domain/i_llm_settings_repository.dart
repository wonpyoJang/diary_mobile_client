import 'llm_settings.dart';

abstract class ILlmSettingsRepository {
  Future<LlmMode> getMode();
  Future<OnDeviceBackend?> getOnDeviceBackend();
  Future<void> setMode(LlmMode mode);
  Future<void> setOnDeviceBackend(OnDeviceBackend? backend);
  Future<bool> hasSeenOptInDialog();
  Future<void> markOptInDialogSeen();
}
