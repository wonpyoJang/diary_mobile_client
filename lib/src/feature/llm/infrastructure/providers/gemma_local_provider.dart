import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/llm_failure.dart';
import '../../domain/i_llm_provider.dart';
import '../../domain/llm_request.dart';
import '../services/gemma_model_download_manager.dart';

/// On-device LLM provider backed by `flutter_gemma`.
///
/// The actual model initialization and inference calls are intentionally
/// stubbed with TODOs because the flutter_gemma init API takes several
/// not-yet-decided parameters (model path resolution, supported model
/// type enum, max-tokens, GPU/CPU backend selection). The structure here
/// is enough to compile and to be wired into DI; the inference body is
/// the only piece that needs filling in once the API is locked.
@Named('gemma_local')
@LazySingleton(as: ILlmProvider)
class GemmaLocalProvider implements ILlmProvider {
  GemmaLocalProvider(this._downloadManager);

  final GemmaModelDownloadManager _downloadManager;

  // Lazily-initialized flutter_gemma model handle. Kept as `dynamic` to
  // avoid hard-coupling to a specific flutter_gemma type until we settle
  // on the init API shape.
  // TODO(track-b): Replace `dynamic` with the concrete flutter_gemma
  // inference model type once the init signature is finalized.
  Object? _model;

  @override
  String get providerId => 'gemma_2b_local';

  @override
  Future<bool> isAvailable() => _downloadManager.isDownloaded();

  @override
  Future<Either<LlmFailure, String>> generateText(LlmRequest request) async {
    if (request.images != null && request.images!.isNotEmpty) {
      return const Left(
        LlmFailure(
          kind: LlmFailureKind.deviceNotSupported,
          message: '온디바이스 모델은 이미지를 지원하지 않습니다',
        ),
      );
    }

    final downloaded = await _downloadManager.isDownloaded();
    if (!downloaded) {
      return const Left(
        LlmFailure(
          kind: LlmFailureKind.modelNotDownloaded,
          message: 'Gemma 2B 모델이 다운로드되지 않았습니다. 모델을 먼저 다운로드해주세요.',
        ),
      );
    }

    try {
      await _ensureModelInitialized();
      final output = await _runInference(request);
      return Right(output);
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

    // TODO(track-b): Initialize flutter_gemma with the downloaded model file.
    // Pseudocode (the exact API depends on flutter_gemma 0.11.x):
    //
    //   final modelPath = await _downloadManager.modelFilePath();
    //   final plugin = FlutterGemmaPlugin.instance;
    //   await plugin.modelManager.setModelPath(modelPath);
    //   _model = await plugin.createModel(
    //     modelType: ModelType.gemmaIt,
    //     maxTokens: request.maxTokens ?? 1024,
    //     preferredBackend: PreferredBackend.gpu,
    //   );
    //
    // For now we just mark the model as "initialized" so the rest of the
    // structure compiles cleanly and behaves consistently.
    _model = const Object();
  }

  Future<String> _runInference(LlmRequest request) async {
    // TODO(track-b): Run real inference via flutter_gemma once
    // _ensureModelInitialized is wired up. Should respect:
    //   - request.systemInstruction (if non-null, prepend)
    //   - request.maxTokens
    //   - request.temperature
    // and return the generated string.
    throw UnimplementedError(
      'flutter_gemma inference is not yet wired up. '
      'See TODO in GemmaLocalProvider._runInference.',
    );
  }
}
