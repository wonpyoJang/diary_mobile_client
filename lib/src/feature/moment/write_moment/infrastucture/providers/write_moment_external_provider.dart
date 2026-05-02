import 'dart:convert';

import 'package:diary_mobile_client/src/core/firebase/firebase_client.dart';
import 'package:diary_mobile_client/src/core/firebase/firebase_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_query.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/llm/application/llm_router.dart';
import 'package:diary_mobile_client/src/feature/llm/domain/llm_request.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWriteMomentExternalProvider)
class WriteMomentExternalProvider implements IWriteMomentExternalProvider {
  final LlmRouter llmRouter;
  final FirebaseClient firebaseClient;

  WriteMomentExternalProvider(this.llmRouter, this.firebaseClient);

  @override
  Future<Either<FirebaseFailure, String>> getFirebaseId() async {
    final fid = await firebaseClient.getFirebaseId();
    if (fid == null) {
      return left(const FirebaseFailure(message: "Firebase ID를 가져오는데 실패했습니다."));
    }
    return right(fid);
  }

  @override
  Future<Either<LLMFailure, List<EmotionalIntensityDto>>> analyze(
      MomentDto moment) async {
    // NOTE: Migrated from `Gemini.query()` to the new `LlmRouter` abstraction.
    // `LlmRequest` does not yet model multimodal/image inputs, so this path is
    // text-only — the previous behavior of also forwarding `moment.medias` to
    // the model is intentionally dropped here. Image-aware analysis can return
    // once `LlmRequest` gains an `images:` field (TODO track-a multimodal).
    const systemInstruction = "아래 일기를 쓴 사람에 드러난 감정을 감정의 세기와 함께 알려줘.\n"
        "출력 형식은 리스트에 문자열로 담아줘, 코드가 아닌 문자열 형식으로 출력해줘. "
        "intensity는 0~1 사이의 값으로 출력해줘. intensity의 합은 1이 되도록 출력해줘.";

    final prompt = """
[컨텍스트]
감정의 종류는 다음과 같아
${Emotion.values.map((e) => e.name).toList().join(',')}

[입력 데이터]
[일기]
${moment.reflection}

[출력 예시]
CASE1:
{
  "emotions": [
      {"emotion":"happiness", "intensity": 0.5},
      {"emotion":"freshness", "intensity": 0.3},
      {"emotion":"warmth", "intensity": 0.2}
    ]
}
CASE2:
{
  "emotions": []
}
""";

    final result = await llmRouter.generate(LlmRequest(
      prompt: prompt,
      systemInstruction: systemInstruction,
      temperature: 0.7,
    ));

    return result.match(
      (failure) => left(LLMFailure(message: failure.message)),
      (text) => _parseEmotions(text),
    );
  }

  Either<LLMFailure, List<EmotionalIntensityDto>> _parseEmotions(String text) {
    final trimmed = text.trim();
    final isJsonFence =
        trimmed.startsWith('```json\n') && trimmed.endsWith('\n```');
    final jsonString = isJsonFence
        ? trimmed.replaceFirst('```json\n', '').replaceFirst('\n```', '')
        : trimmed;

    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        json = decoded;
      }
    } on FormatException {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환하는데 실패했어요. 다시 시도해주세요."));
    } on Exception catch (e) {
      return left(LLMFailure(message: '[AI] JSON 파싱 중 알 수 없는 오류: $e'));
    }

    if (json == null || json.isEmpty) {
      return left(const LLMFailure(
          message: "[AI] 응답을 JSON 형식으로 변환했는데 결과값이 빈 값이에요. 다시 시도해주세요."));
    }

    final emotions = json['emotions'];
    if (emotions is! List) {
      return left(
          const LLMFailure(message: "[AI] 응답에 'emotions' 필드가 없어요. 다시 시도해주세요."));
    }

    final List<EmotionalIntensityDto> emotionalIntensities = emotions
        .map((emotion) => EmotionalIntensityDto.fromJson(emotion))
        .toList();
    return right(emotionalIntensities);
  }

  @override
  Future<Either<LLMFailure, String>> describeImage(MomentDto moment) async {
    // Multimodal call (image + prompt). `LlmRequest` does not yet model image
    // inputs, so we use `LlmRouter.generateWithImages` — Track A's escape
    // hatch that always routes to the remote Gemini backend regardless of the
    // user's selected mode (on-device providers are text-only for MVP).
    //
    // TODO(track-a): Once `LlmRequest` gains first-class multimodal support,
    // migrate this to `llmRouter.generate(...)` like `analyze()` above.
    final result = await llmRouter.generateWithImages(
      query: LLMQuery(
          direction: "아래 이미지를 바탕으로 일기를 작성해줘. 인스타그래머블하게 작성해줘.",
          outputDirection: "출력 형식은 문자열로 출력해줘",
          data: "",
          medias: moment.medias,
          context: "",
          outputExample: """
      CASE1:
      {
        "reflection" :
          🌙\n오늘은 좀… 조용한 하루였다.\n사람 많은 카페에 앉아 혼자 창밖만 오래 바라봤다.\n음악은 잔잔했고, 커피는 미지근했다.\n\n요즘은\n누가 나한테 진심으로 말을 걸어줬으면 좋겠다는\n생각을 자주 한다.\n\n괜찮냐는 말보다\n진짜 괜찮아지고 싶다.\n\n누군가에게 너무 이해받고 싶은 날이었다.\n괜히 울컥한 감정,\n괜히 쓸쓸한 밤.\n\n근데 또 이상하게,\n이런 감정들도\n조금은 예쁘다고 느껴졌다.\n\n아무것도 안 해도 괜찮은 하루였으니까.\n\n🩶
      }
      CASE2:
      {
        "reflection": "오늘은 카페에 앉아 창밖을 바라봤다. 음악이 나왔고, 커피를 마셨다. 특별한 대화 없이 시간을 보냈다. 하루가 조용히 지나갔다."
      }
      """),
    );

    return result.match(
      (failure) => left(failure),
      (result) => right(result.response['reflection']),
    );
  }
}
