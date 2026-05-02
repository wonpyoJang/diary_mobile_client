import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
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
}
