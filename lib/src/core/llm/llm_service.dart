import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:diary_mobile_client/main.dart';
import 'package:diary_mobile_client/src/core/llm/llm_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_query.dart';
import 'package:diary_mobile_client/src/core/llm/llm_response.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_ai/firebase_ai.dart';

class LLMService {
  static const platform = MethodChannel('com.example.llm');

  Future<String> generateResponse(String prompt) async {
    final response =
        await platform.invokeMethod('generateResponse', {'prompt': prompt});
    return response;
  }
}

/// Legacy direct entry point to Firebase AI's Gemini model.
///
/// Prefer the new `ILlmProvider` abstraction at
/// `lib/src/feature/llm/` (specifically `LlmRouter` for text generation
/// and `LlmRouter.generateWithImages` while multimodal support is being
/// designed). This class is retained only because [LlmRouter.generateWithImages]
/// still delegates here for image/inline-data inputs.
///
/// TODO(track-a): Remove once [LlmRequest] supports multimodal inputs and
/// `WriteMomentExternalProvider` no longer needs the legacy entry point.
@Deprecated('Use LlmRouter / ILlmProvider via lib/src/feature/llm instead.')
@singleton
class Gemini {
  static final model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

  @Deprecated('Use query() instead')
  static Future<String> oldQuery({required String prompt}) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? "응닶이 없습니다.";
  }

  static Future<Either<LLMFailure, LLMResponse>> query(
      {required LLMQuery query}) async {
    final prompt = TextPart(query.toPrompt());

    List<InlineDataPart> imageParts = [];
    try {
      imageParts = await query.getImageParts();
    } on PlatformException {
      return left(const LLMFailure(
          message: '[AI] 이미지 처리 중 플랫폼 오류가 발생했습니다. 다시 시도해주세요.'));
    } on TimeoutException {
      return left(const LLMFailure(
          message: '[AI] 이미지 처리 중 타임아웃이 발생했습니다. 네트워크 상태를 확인해주세요.'));
    } on SocketException {
      return left(const LLMFailure(
          message: '[AI] 이미지 처리 중 네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.'));
    } on Exception catch (e) {
      return left(LLMFailure(message: '[AI] 이미지 처리 중 알 수 없는 오류: $e'));
    } on Error catch (e) {
      return left(LLMFailure(message: '[AI] 이미지 처리 중 치명적 오류: $e'));
    }

    final content = [
      Content.multi([
        prompt,
        ...imageParts,
      ])
    ];

    GenerateContentResponse result;

    logger.d("[prompt]\n");
    logger.d(prompt.text);
    for (var i = 0; i < imageParts.length; i++) {
      logger.d(
        "[image $i] path: ",
      );
      logger.d(query.medias[i].path);
    }

    try {
      result = await model.generateContent(content);
    } on PlatformException {
      return left(const LLMFailure(message: '[AI] 플랫폼 오류가 발생했습니다. 다시 시도해주세요.'));
    } on TimeoutException {
      return left(
          const LLMFailure(message: '[AI] AI 응답이 지연되고 있습니다. 네트워크 상태를 확인해주세요.'));
    } on SocketException {
      return left(
          const LLMFailure(message: '[AI] 네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.'));
    } on Exception catch (e) {
      return left(LLMFailure(message: '[AI] AI 요청 중 알 수 없는 오류: $e'));
    } on Error catch (e) {
      return left(LLMFailure(message: '[AI] AI 요청 중 치명적 오류: $e'));
    }

    logger.d("[response]\n");
    logger.d(result.text);

    if (result.text == null) {
      return left(const LLMFailure(message: "[AI] 응답의 내용이 빈 값입니다."));
    }

    final response = result.text!;

    final isValidJson = response.trim().startsWith('```json\n') &&
        response.trim().endsWith('\n```');

    if (!isValidJson) {
      return left(const LLMFailure(
          message: "[AI] 응답이 JSON 형식임을 확인할 수 없어요. 다시 시도해주세요."));
    }

    final responseWithoutNotation =
        response.trim().replaceFirst('```json\n', '').replaceFirst('\n```', '');

    Map<String, dynamic>? json;

    try {
      json = jsonDecode(responseWithoutNotation);
    } on FormatException {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환하는데 실패했어요. 다시 시도해주세요."));
    } on Exception catch (e) {
      return left(LLMFailure(message: '[AI] JSON 파싱 중 알 수 없는 오류: $e'));
    } on Error catch (e) {
      return left(LLMFailure(message: '[AI] JSON 파싱 중 치명적 오류: $e'));
    }

    if (json == null) {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환했는데 결과값이 빈 값이에요. 다시 시도해주세요."));
    }

    if (json.isEmpty) {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환했는데 결과값이 빈 값이에요. 다시 시도해주세요."));
    }

    return right(LLMResponse(prompt: prompt.text, response: json));
  }
}
