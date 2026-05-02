import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/services/trigger_analyzer.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/trigger_stat.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/infrastructure/providers/interfaces/i_emotion_statistics_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IEmotionStatisticsRepository)
class EmotionStatisticsRepository implements IEmotionStatisticsRepository {
  final IEmotionStatisticsProvider provider;
  final TriggerAnalyzer _triggerAnalyzer;

  EmotionStatisticsRepository(this.provider)
      : _triggerAnalyzer = const TriggerAnalyzer();

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

  @override
  Future<Either<LocalFailure, DiaryStatistics>> getDiaryStatistics({
    int dailyWindowDays = 30,
  }) async {
    final emotionResult = await provider.getEmotionStatistics();
    if (emotionResult.isLeft()) {
      return left(emotionResult.fold((l) => l, (_) => throw StateError('')));
    }
    final emotionStats = emotionResult
        .getRight()
        .getOrElse(() => [])
        .map((e) => e.toDomain())
        .toList();

    final totalResult = await provider.getTotalMomentCount();
    if (totalResult.isLeft()) {
      return left(totalResult.fold((l) => l, (_) => throw StateError('')));
    }
    final totalMoments = totalResult.getRight().getOrElse(() => 0);

    final dailyResult = await provider.getDailyMomentCounts(dailyWindowDays);
    if (dailyResult.isLeft()) {
      return left(dailyResult.fold((l) => l, (_) => throw StateError('')));
    }
    final rawDaily = dailyResult.getRight().getOrElse(() => {});

    // 빠진 날짜를 0으로 채워 연속된 N일 시리즈로 만든다.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final filled = <DateTime, int>{};
    for (var i = dailyWindowDays - 1; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      filled[d] = rawDaily[d] ?? 0;
    }

    // 트리거 분석은 본문 데이터가 있어야 의미가 있으므로 실패해도
    // 전체 통계 페이지가 죽지 않도록 빈 리스트로 폴백한다.
    final List<TriggerStat> triggerStats;
    final samplesResult = await provider.getMomentValenceSamples();
    triggerStats = samplesResult.fold(
      (_) => const <TriggerStat>[],
      (samples) => _triggerAnalyzer.analyze(samples),
    );

    return right(DiaryStatistics(
      totalMoments: totalMoments,
      emotionStats: emotionStats,
      dailyMomentCounts: filled,
      triggerStats: triggerStats,
    ));
  }
}
