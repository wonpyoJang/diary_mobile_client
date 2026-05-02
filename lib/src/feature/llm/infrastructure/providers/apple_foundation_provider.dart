import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/llm_failure.dart';
import '../../domain/i_llm_provider.dart';
import '../../domain/llm_request.dart';

@Named('apple_foundation')
@LazySingleton(as: ILlmProvider)
class AppleFoundationProvider implements ILlmProvider {
  static const MethodChannel _channel =
      MethodChannel('com.cassette.diary/apple_llm');

  @override
  String get providerId => 'apple_foundation';

  @override
  Future<bool> isAvailable() async {
    if (!Platform.isIOS) {
      return false;
    }
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<Either<LlmFailure, String>> generateText(LlmRequest request) async {
    if (request.images != null && request.images!.isNotEmpty) {
      return left(
        const LlmFailure(
          kind: LlmFailureKind.deviceNotSupported,
          message: 'Apple Foundation Models는 텍스트 전용입니다',
        ),
      );
    }

    if (!Platform.isIOS) {
      return left(
        const LlmFailure(
          message: 'Apple Foundation Models is only available on iOS',
          kind: LlmFailureKind.deviceNotSupported,
        ),
      );
    }

    try {
      final result = await _channel.invokeMethod<String>(
        'generate',
        <String, dynamic>{
          'prompt': request.prompt,
          if (request.systemInstruction != null)
            'systemInstruction': request.systemInstruction,
          if (request.maxTokens != null) 'maxTokens': request.maxTokens,
          if (request.temperature != null) 'temperature': request.temperature,
        },
      );
      if (result == null) {
        return left(
          const LlmFailure(
            message: 'Apple Foundation Models returned null response',
            kind: LlmFailureKind.generationError,
          ),
        );
      }
      return right(result);
    } on PlatformException catch (e) {
      return left(_mapPlatformException(e));
    } on MissingPluginException catch (e) {
      return left(
        LlmFailure(
          message:
              e.message ?? 'Apple Foundation Models channel not registered',
          kind: LlmFailureKind.unavailable,
        ),
      );
    }
  }

  LlmFailure _mapPlatformException(PlatformException e) {
    final message = e.message ?? e.code;
    switch (e.code) {
      case 'device_not_eligible':
      case 'intelligence_not_enabled':
        return LlmFailure(
          message: message,
          kind: LlmFailureKind.deviceNotSupported,
        );
      case 'model_not_ready':
        return LlmFailure(
          message: message,
          kind: LlmFailureKind.unavailable,
        );
      case 'generation_failed':
        return LlmFailure(
          message: message,
          kind: LlmFailureKind.generationError,
        );
      default:
        return LlmFailure(
          message: message,
          kind: LlmFailureKind.unknown,
        );
    }
  }
}
