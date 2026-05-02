import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:fpdart/fpdart.dart';

abstract class IEmotionStatisticsRepository {
  Future<Either<LocalFailure, List<EmotionStats>>> getEmotionStatistics();

  /// 풍부한 통계 (총 일기 수, 감정 분포, 일별 작성량 포함).
  Future<Either<LocalFailure, DiaryStatistics>> getDiaryStatistics({
    int dailyWindowDays = 30,
  });
}
