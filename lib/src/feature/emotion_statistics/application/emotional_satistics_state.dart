import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:equatable/equatable.dart';

enum EmotionalStatisticsStatus { initial, loading, ready, error }

class EmotionalStatisticsState extends Equatable {
  final EmotionalStatisticsStatus status;
  final List<EmotionStats> emotionStats;
  final DiaryStatistics diaryStatistics;
  final LocalFailure? failure;

  const EmotionalStatisticsState({
    this.status = EmotionalStatisticsStatus.initial,
    this.emotionStats = const [],
    this.diaryStatistics = DiaryStatistics.empty,
    this.failure,
  });

  @override
  List<Object?> get props =>
      [status, emotionStats, diaryStatistics, failure];

  EmotionalStatisticsState copyWith({
    EmotionalStatisticsStatus? status,
    List<EmotionStats>? emotionStats,
    DiaryStatistics? diaryStatistics,
    LocalFailure? failure,
  }) {
    return EmotionalStatisticsState(
      status: status ?? this.status,
      emotionStats: emotionStats ?? this.emotionStats,
      diaryStatistics: diaryStatistics ?? this.diaryStatistics,
      failure: failure ?? this.failure,
    );
  }
}
