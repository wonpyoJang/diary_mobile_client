import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/trigger_stat.dart';

class DiaryStatistics {
  /// 총 작성된 일기(moment) 개수.
  final int totalMoments;

  /// 감정별 집계 (count 내림차순).
  final List<EmotionStats> emotionStats;

  /// 최근 N일 일별 작성 수 (날짜 → count). 일기가 0인 날도 0으로 포함.
  final Map<DateTime, int> dailyMomentCounts;

  /// 본문에서 추출한 키워드별 감정 분포. 표본 수가 부족하거나
  /// 분석할 일기가 없으면 빈 리스트.
  final List<TriggerStat> triggerStats;

  const DiaryStatistics({
    required this.totalMoments,
    required this.emotionStats,
    required this.dailyMomentCounts,
    this.triggerStats = const [],
  });

  static const empty = DiaryStatistics(
    totalMoments: 0,
    emotionStats: [],
    dailyMomentCounts: {},
    triggerStats: [],
  );

  bool get isEmpty => totalMoments == 0;

  int get totalEmotionEntries =>
      emotionStats.fold(0, (sum, e) => sum + e.count);

  int get positiveEmotionCount => emotionStats
      .where((e) => e.emotion.isPositive)
      .fold(0, (sum, e) => sum + e.count);

  int get negativeEmotionCount => emotionStats
      .where((e) => e.emotion.isNegative)
      .fold(0, (sum, e) => sum + e.count);

  int get neutralEmotionCount =>
      totalEmotionEntries - positiveEmotionCount - negativeEmotionCount;

  /// 가장 많이 기록된 감정 5개 (count 내림차순).
  List<EmotionStats> get topEmotions => emotionStats.take(5).toList();

  /// 일기 1편당 평균 감정 수.
  double get avgEmotionsPerMoment =>
      totalMoments == 0 ? 0 : totalEmotionEntries / totalMoments;

  /// 최근 30일 중 일기를 작성한 일자 수.
  int get activeDaysInWindow =>
      dailyMomentCounts.values.where((c) => c > 0).length;

  /// 가장 자주 등장한 단일 감정.
  Emotion? get dominantEmotion =>
      emotionStats.isEmpty ? null : emotionStats.first.emotion;
}
