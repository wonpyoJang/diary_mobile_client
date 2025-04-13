import 'package:diary_mobile_client/src/core/firebase/firebase_client.dart';
import 'package:diary_mobile_client/src/core/firebase/firebase_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_query.dart';
import 'package:diary_mobile_client/src/core/llm/llm_service.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWriteMomentExternalProvider)
class WriteMomentExternalProvider implements IWriteMomentExternalProvider {
  final Gemini gemini;
  final FirebaseClient firebaseClient;

  WriteMomentExternalProvider(this.gemini, this.firebaseClient);

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
      MomentDto text) async {
    final resultOrFailure = await Gemini.query(
      query: LLMQuery(
          direction: "아래 일기를 쓴 사람에 드러난 감정을 감정의 세기와 함께 알려줘",
          outputDirection:
              "출력 형식은 리스트에 문자열로 담아줘, 코드가 아닌 문자열 형식으로 출력해줘. intensity는 0~1 사이의 값으로 출력해줘. intensity의 합은 1이 되도록 출력해줘.",
          context:
              "감정의 종류는 다음과 같아\n${Emotion.values.map((e) => e.name).toList().join(',')}",
          data: "[일기]\n${text.reflection}",
          outputExample: """
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
      """),
    );

    return resultOrFailure.match(
      (failure) => left(failure),
      (result) {
        final List<EmotionalIntensityDto> emotionalIntensities =
            (result.response['emotions'] as List)
                .map((emotion) => EmotionalIntensityDto.fromJson(emotion))
                .toList();

        return right(emotionalIntensities);
      },
    );
  }
}
