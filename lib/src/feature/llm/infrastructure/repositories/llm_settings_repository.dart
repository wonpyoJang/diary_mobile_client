// MERGE NOTE: Track A creates `DefaultLlmSettingsRepository` as a stub also annotated
// `@LazySingleton(as: ILlmSettingsRepository)`. During merge, delete Track A's stub
// (lib/src/feature/llm/infrastructure/repositories/default_llm_settings_repository.dart
// or similar) so this Hive-backed implementation is the only registered binding for
// `ILlmSettingsRepository`. Without this cleanup, injectable codegen will fail with
// duplicate-binding errors.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/i_llm_settings_repository.dart';
import '../../domain/llm_settings.dart';

@LazySingleton(as: ILlmSettingsRepository)
class LlmSettingsRepository implements ILlmSettingsRepository {
  static const String _boxName = 'llm_settings';
  static const String _kMode = 'mode';
  static const String _kOnDeviceBackend = 'on_device_backend';
  static const String _kHasSeenDialog = 'has_seen_dialog';

  static const String _modeRemote = 'remote';
  static const String _modeOnDevice = 'onDevice';
  static const String _backendDownloaded = 'downloadedModel';
  static const String _backendNative = 'platformNative';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }
    return Hive.openBox<dynamic>(_boxName);
  }

  @override
  Future<LlmMode> getMode() async {
    final box = await _openBox();
    final value = box.get(_kMode);
    if (value == _modeOnDevice) return LlmMode.onDevice;
    return LlmMode.remote;
  }

  @override
  Future<OnDeviceBackend?> getOnDeviceBackend() async {
    final box = await _openBox();
    final value = box.get(_kOnDeviceBackend);
    if (value == _backendDownloaded) return OnDeviceBackend.downloadedModel;
    if (value == _backendNative) return OnDeviceBackend.platformNative;
    return null;
  }

  @override
  Future<void> setMode(LlmMode mode) async {
    final box = await _openBox();
    await box.put(
      _kMode,
      mode == LlmMode.onDevice ? _modeOnDevice : _modeRemote,
    );
  }

  @override
  Future<void> setOnDeviceBackend(OnDeviceBackend? backend) async {
    final box = await _openBox();
    if (backend == null) {
      await box.delete(_kOnDeviceBackend);
      return;
    }
    await box.put(
      _kOnDeviceBackend,
      backend == OnDeviceBackend.downloadedModel
          ? _backendDownloaded
          : _backendNative,
    );
  }

  @override
  Future<bool> hasSeenOptInDialog() async {
    final box = await _openBox();
    final value = box.get(_kHasSeenDialog);
    if (value is bool) return value;
    return false;
  }

  @override
  Future<void> markOptInDialogSeen() async {
    final box = await _openBox();
    await box.put(_kHasSeenDialog, true);
  }
}
