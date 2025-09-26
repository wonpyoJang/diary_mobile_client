import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/providers/interfaces/i_emotion_statistics_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IEmotionStatisticsRepository)
class EmotionStatisticsRepository implements IEmotionStatisticsRepository {
  final IEmotionStatisticsProvider provider;

  EmotionStatisticsRepository(this.provider);

  @override
  Future<Either<LocalFailure, List<EmotionStats>>>
      getEmotionStatistics() async {
    return provider.getEmotionStatistics().then(
          (result) => result.fold(
            (failure) => left(failure),
            (stats) => right(stats.map((e) => e.toDomain()).toList()),
          ),
        );
  }
}
