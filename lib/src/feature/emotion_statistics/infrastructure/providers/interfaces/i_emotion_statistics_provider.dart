import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/dtos/emotion_stats_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IEmotionStatisticsProvider {
  Future<Either<LocalFailure, List<EmotionStatsDto>>> getEmotionStatistics();
}
