import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Manages download lifecycle for the on-device Gemma model file.
///
/// Responsibilities:
///  - Check whether the model is already downloaded.
///  - Verify there is enough free storage on the device.
///  - Download the model with progress reporting and cancellation support.
///  - Delete the local copy.
///
/// The actual model URL and exact filename expected by `flutter_gemma` are
/// left as TODOs and must be filled in once we settle on the model artifact
/// to host. See `_modelDownloadUrl` and `_modelFileName` below.
@LazySingleton()
class GemmaModelDownloadManager {
  GemmaModelDownloadManager(this._dio);

  final Dio _dio;

  // TODO(track-b): Replace with the real CDN URL hosting the Gemma 2B IT
  // (q4 quantized) model artifact compatible with flutter_gemma.
  static const String _modelDownloadUrl =
      'https://example.com/TODO-set-real-url/gemma-2b-it-q4.bin';

  // TODO(track-b): Confirm the exact filename flutter_gemma expects.
  // Using a placeholder name in the application documents directory until
  // the flutter_gemma init API requirements are finalized.
  static const String _modelFileName = 'gemma-2b-it-q4.bin';

  // ~1.5 GB. Used as a guard before kicking off the download.
  static const int _requiredSpaceBytes = 1500 * 1024 * 1024;

  /// Number of bytes the device should have free before attempting download.
  int get requiredSpaceBytes => _requiredSpaceBytes;

  Future<File> _modelFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _modelFileName));
  }

  /// Returns the on-disk path the model will / does live at.
  Future<String> modelFilePath() async => (await _modelFile()).path;

  /// Returns true if the model file already exists on disk.
  Future<bool> isDownloaded() async {
    final file = await _modelFile();
    return file.exists();
  }

  /// Returns true if there's enough free space on the documents volume to
  /// hold the model. Falls back to `true` if the platform does not expose
  /// free-space information (we still let the OS surface the failure later).
  Future<bool> hasEnoughStorage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final stat = await _statVfs(dir.path);
      if (stat == null) {
        return true;
      }
      return stat >= _requiredSpaceBytes;
    } catch (_) {
      return true;
    }
  }

  /// Best-effort free-space probe for the volume that holds [path].
  /// Returns null when free space cannot be determined on the host platform.
  Future<int?> _statVfs(String path) async {
    if (Platform.isMacOS || Platform.isLinux || Platform.isIOS) {
      try {
        // `df -k` works on macOS, Linux, and iOS (debug only). On real iOS
        // devices Process.run is restricted, so we tolerate failures.
        final result = await Process.run('df', ['-k', path]);
        if (result.exitCode != 0) return null;
        final lines = (result.stdout as String).trim().split('\n');
        if (lines.length < 2) return null;
        // Header: Filesystem 1024-blocks Used Available Capacity Mounted on
        final cols = lines[1].split(RegExp(r'\s+'));
        if (cols.length < 4) return null;
        final availableKb = int.tryParse(cols[3]);
        if (availableKb == null) return null;
        return availableKb * 1024;
      } catch (_) {
        return null;
      }
    }
    // Android / Windows: no portable hook here; defer to OS.
    return null;
  }

  /// Downloads the model file, reporting progress as a 0..1 ratio.
  /// Honours [cancelToken] for user-driven cancellation.
  Future<void> download({
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final file = await _modelFile();
    await file.parent.create(recursive: true);

    final tempPath = '${file.path}.part';
    try {
      await _dio.download(
        _modelDownloadUrl,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (onProgress == null) return;
          if (total <= 0) return;
          onProgress(received / total);
        },
      );
      // Atomic-ish swap so we never leave a partial file in the final path.
      final tempFile = File(tempPath);
      if (await file.exists()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
    } catch (_) {
      // Best-effort cleanup of partial download.
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      rethrow;
    }
  }

  /// Removes the on-disk model, if present.
  Future<void> delete() async {
    final file = await _modelFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
