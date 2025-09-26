import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:fpdart/fpdart.dart';

abstract class IEmotionStatisticsRepository {
  Future<Either<LocalFailure, List<EmotionStats>>> getEmotionStatistics();
}
