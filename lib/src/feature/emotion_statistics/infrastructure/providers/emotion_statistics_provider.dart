import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/dtos/emotion_stats_dto.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/providers/interfaces/i_emotion_statistics_provider.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IEmotionStatisticsProvider)
class EmotionStatisticsProvider implements IEmotionStatisticsProvider {
  final DriftClient _driftClient;

  EmotionStatisticsProvider(this._driftClient);

  @override
  Future<Either<LocalFailure, List<EmotionStatsDto>>>
      getEmotionStatistics() async {
    return await _driftClient.runQuery<List<EmotionStatsDto>>((db) async {
      final query = db.selectOnly(db.emotionalIntensityTable)
        ..addColumns([
          db.emotionalIntensityTable.emotion,
          db.emotionalIntensityTable.intensity.count(),
          db.emotionalIntensityTable.intensity.avg(),
          db.emotionalIntensityTable.intensity.max(),
          db.emotionalIntensityTable.intensity.min(),
          db.emotionalIntensityTable.intensity.sum(),
        ])
        ..groupBy([db.emotionalIntensityTable.emotion])
        ..orderBy(
            [OrderingTerm.desc(db.emotionalIntensityTable.intensity.count())]);

      final results = await query.get();

      final stats = results
          .map((row) => EmotionStatsDto(
                emotion: row.read(db.emotionalIntensityTable.emotion)!,
                count: row.read(db.emotionalIntensityTable.intensity.count())!,
                avgIntensity:
                    row.read(db.emotionalIntensityTable.intensity.avg())!,
                maxIntensity:
                    row.read(db.emotionalIntensityTable.intensity.max())!,
                minIntensity:
                    row.read(db.emotionalIntensityTable.intensity.min())!,
                totalIntensity:
                    row.read(db.emotionalIntensityTable.intensity.sum())!,
              ))
          .toList();

      return stats;
    }, description: 'getEmotionStatistics');
  }
}
