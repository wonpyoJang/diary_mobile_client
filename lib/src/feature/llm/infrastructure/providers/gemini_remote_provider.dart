import 'dart:async';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/llm_failure.dart';
import '../../domain/i_llm_provider.dart';
import '../../domain/llm_request.dart';

/// Remote LLM provider backed by Firebase AI's Gemini model.
///
/// Mirrors the existing call pattern in `lib/src/core/llm/llm_service.dart`
/// (`Gemini.query()`), but speaks the new [ILlmProvider] contract.
@Named('gemini_remote')
@LazySingleton(as: ILlmProvider)
class GeminiRemoteProvider implements ILlmProvider {
  static final _model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

  @override
  String get providerId => 'gemini_remote';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Either<LlmFailure, String>> generateText(LlmRequest request) async {
    final parts = <Part>[];
    if (request.systemInstruction != null &&
        request.systemInstruction!.isNotEmpty) {
      parts.add(TextPart(request.systemInstruction!));
    }
    parts.add(TextPart(request.prompt));

    final content = [Content.multi(parts)];

    GenerateContentResponse result;
    try {
      result = await _model.generateContent(content);
    } on PlatformException catch (e) {
      return left(LlmFailure(
        message: '[AI] 플랫폼 오류가 발생했습니다. 다시 시도해주세요. (${e.message ?? e.code})',
        kind: LlmFailureKind.networkError,
      ));
    } on TimeoutException {
      return left(const LlmFailure(
        message: '[AI] AI 응답이 지연되고 있습니다. 네트워크 상태를 확인해주세요.',
        kind: LlmFailureKind.networkError,
      ));
    } on SocketException {
      return left(const LlmFailure(
        message: '[AI] 네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.',
        kind: LlmFailureKind.networkError,
      ));
    } on Exception catch (e) {
      return left(LlmFailure(
        message: '[AI] AI 요청 중 알 수 없는 오류: $e',
        kind: LlmFailureKind.generationError,
      ));
    } on Error catch (e) {
      return left(LlmFailure(
        message: '[AI] AI 요청 중 치명적 오류: $e',
        kind: LlmFailureKind.generationError,
      ));
    }

    final text = result.text;
    if (text == null || text.isEmpty) {
      return left(const LlmFailure(
        message: '[AI] 응답의 내용이 빈 값입니다.',
        kind: LlmFailureKind.generationError,
      ));
    }

    return right(text);
  }
}
