import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/i_llm_capability_probe.dart';
import '../../domain/i_llm_provider.dart';

// TODO(merge): Track D creates i_llm_capability_probe.dart with same interface.
// Deduplicate during merge.
@LazySingleton(as: ILlmCapabilityProbe)
class DeviceCapabilityDetector implements ILlmCapabilityProbe {
  /// Minimum free storage required to download/run the on-device Gemma model.
  static const int _minFreeStorageBytes = 2 * 1024 * 1024 * 1024; // 2 GB

  final ILlmProvider _appleFoundationProvider;

  DeviceCapabilityDetector(
    @Named('apple_foundation') this._appleFoundationProvider,
  );

  @override
  Future<bool> canRunAppleFoundation() {
    return _appleFoundationProvider.isAvailable();
  }

  @override
  Future<bool> canRunGemmaLocal() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final freeBytes = _freeStorageBytes(dir.path);
      if (freeBytes == null) {
        // Could not determine free storage; be permissive and let downstream
        // surface failures.
        return true;
      }
      return freeBytes >= _minFreeStorageBytes;
    } catch (_) {
      // If we can't probe storage, default to allowing the user to attempt.
      return true;
    }
  }

  /// Returns free storage in bytes for the volume containing [path], or null
  /// if it cannot be determined on the current platform.
  int? _freeStorageBytes(String path) {
    try {
      // dart:io exposes `statSync` for file system entries but not for free
      // space. Use the platform statvfs via Process when available — fall
      // back to `null` when unsupported.
      if (Platform.isIOS || Platform.isMacOS || Platform.isLinux) {
        final result = Process.runSync('df', <String>['-k', path]);
        if (result.exitCode != 0) return null;
        final lines = (result.stdout as String).trim().split('\n');
        if (lines.length < 2) return null;
        // Typical df -k output (POSIX): Filesystem 1024-blocks Used Available ...
        final parts = lines.last.split(RegExp(r'\s+'));
        if (parts.length < 4) return null;
        final availableKb = int.tryParse(parts[3]);
        if (availableKb == null) return null;
        return availableKb * 1024;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
