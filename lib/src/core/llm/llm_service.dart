import 'dart:convert';

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

    final imageParts = await query.getImageParts();

    final content = [
      Content.multi([
        prompt,
        ...imageParts,
      ])
    ];

    GenerateContentResponse result;

    logger.d("[prompt]\n${prompt.text}");
    for (var i = 0; i < imageParts.length; i++) {
      logger.d("[image $i] path: ${query.medias[i].path}");
    }

    try {
      result = await model.generateContent(content);
    } catch (e) {
      return left(LLMFailure(message: "[AI] $e"));
    }

    logger.d("[response]\n${result.text}");

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
    } catch (e) {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환하는데 실패했어요. 다시 시도해주세요."));
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
