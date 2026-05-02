import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/services/trigger_analyzer.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/dtos/emotion_stats_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IEmotionStatisticsProvider {
  Future<Either<LocalFailure, List<EmotionStatsDto>>> getEmotionStatistics();

  /// 총 일기(moment) 개수.
  Future<Either<LocalFailure, int>> getTotalMomentCount();

  /// 최근 [days] 일간 날짜별 일기 작성 수. (일기가 0인 날은 결과에 포함되지 않음 — 호출 측에서 채움)
  Future<Either<LocalFailure, Map<DateTime, int>>> getDailyMomentCounts(
    int days,
  );

  /// 일기 본문 + 그 일기의 우세 valence(긍정/부정/중립) 샘플.
  /// 트리거 분석에 사용된다. 본문이 비어 있는 일기는 제외.
  Future<Either<LocalFailure, List<MomentValenceSample>>>
      getMomentValenceSamples();
}
