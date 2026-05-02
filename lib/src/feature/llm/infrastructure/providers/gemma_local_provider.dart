import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/llm_failure.dart';
import '../../domain/i_llm_provider.dart';
import '../../domain/llm_request.dart';
import '../services/gemma_model_download_manager.dart';

/// Sentinel exception used internally to signal that the model file is
/// missing on disk; mapped to [LlmFailureKind.modelNotDownloaded] by
/// [generateText].
class _ModelNotDownloadedException implements Exception {
  const _ModelNotDownloadedException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// On-device LLM provider backed by `flutter_gemma`.
///
/// Wires the canonical flutter_gemma 0.11.x init/inference flow:
///   1. `FlutterGemmaPlugin.instance.modelManager.setModelPath(...)`
///   2. `plugin.createModel(...)` → cached [InferenceModel]
///   3. Per-request `model.createSession(...)` → `addQueryChunk` →
///      `getResponse` → `session.close()`
///
/// The model URL/filename are still placeholders (issue #31), so this
/// provider compiles and is wired into DI but cannot actually run inference
/// until that lands.
@Named('gemma_local')
@LazySingleton(as: ILlmProvider)
class GemmaLocalProvider implements ILlmProvider {
  GemmaLocalProvider(this._downloadManager);

  final GemmaModelDownloadManager _downloadManager;

  InferenceModel? _model;

  @override
  String get providerId => 'gemma_2b_local';

  @override
  Future<bool> isAvailable() => _downloadManager.isDownloaded();

  @override
  Future<Either<LlmFailure, String>> generateText(LlmRequest request) async {
    try {
      await _ensureModelInitialized();
      final output = await _runInference(request);
      return Right(output);
    } on _ModelNotDownloadedException catch (e) {
      return Left(
        LlmFailure(
          kind: LlmFailureKind.modelNotDownloaded,
          message: e.message,
        ),
      );
    } catch (e) {
      return Left(
        LlmFailure(
          kind: LlmFailureKind.generationError,
          message: 'Gemma 추론 실패: $e',
        ),
      );
    }
  }

  Future<void> _ensureModelInitialized() async {
    if (_model != null) return;

    final downloaded = await _downloadManager.isDownloaded();
    if (!downloaded) {
      throw const _ModelNotDownloadedException(
        'Gemma 2B 모델이 다운로드되지 않았습니다. 모델을 먼저 다운로드해주세요.',
      );
    }

    final modelPath = await _downloadManager.getModelPath();
    final plugin = FlutterGemmaPlugin.instance;
    await plugin.modelManager.setModelPath(modelPath);

    _model = await plugin.createModel(
      modelType: ModelType.gemmaIt,
      preferredBackend: PreferredBackend.cpu,
      maxTokens: 512,
      supportImage: false,
    );
  }

  Future<String> _runInference(LlmRequest request) async {
    final model = _model;
    if (model == null) {
      // Should be unreachable because _ensureModelInitialized assigns _model
      // before _runInference is called, but guard defensively.
      throw StateError('GemmaLocalProvider: model not initialized.');
    }

    final session = await model.createSession(
      temperature: request.temperature ?? 0.7,
      topK: 40,
      randomSeed: 42,
    );

    try {
      final fullPrompt = request.systemInstruction == null
          ? request.prompt
          : '${request.systemInstruction}\n\n${request.prompt}';
      await session.addQueryChunk(Message.text(text: fullPrompt));
      return await session.getResponse();
    } finally {
      await session.close();
    }
  }

  /// Releases the cached [InferenceModel]. Safe to call multiple times.
  Future<void> dispose() async {
    final model = _model;
    _model = null;
    if (model != null) {
      await model.close();
    }
  }
}
