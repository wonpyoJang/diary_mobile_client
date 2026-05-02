import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:flutter_test/flutter_test.dart';

EmotionStats _stat(Emotion e, int count) => EmotionStats(
      emotion: e,
      count: count,
      avgIntensity: 50,
      maxIntensity: 80,
      minIntensity: 20,
      totalIntensity: count * 50.0,
    );

void main() {
  group('Emotion 의 valenceWeight 와 isPositive/isNegative', () {
    test('valenceWeight > 0 인 감정은 isPositive', () {
      expect(Emotion.happiness.isPositive, isTrue);
      expect(Emotion.happiness.isNegative, isFalse);
    });

    test('valenceWeight < 0 인 감정은 isNegative', () {
      expect(Emotion.sadness.isNegative, isTrue);
      expect(Emotion.sadness.isPositive, isFalse);
    });

    test('valenceWeight == 0 인 감정은 양쪽 모두 false', () {
      expect(Emotion.mystery.isPositive, isFalse);
      expect(Emotion.mystery.isNegative, isFalse);
    });
  });

  group('DiaryStatistics — empty 상수', () {
    test('empty 는 totalMoments == 0 이고 isEmpty == true', () {
      expect(DiaryStatistics.empty.totalMoments, 0);
      expect(DiaryStatistics.empty.isEmpty, isTrue);
    });

    test('empty 는 emotionStats / dailyMomentCounts 가 비어 있어야 함', () {
      expect(DiaryStatistics.empty.emotionStats, isEmpty);
      expect(DiaryStatistics.empty.dailyMomentCounts, isEmpty);
    });
  });

  group('DiaryStatistics — 집계 getter', () {
    test('totalEmotionEntries 는 모든 EmotionStats.count 의 합', () {
      final stats = DiaryStatistics(
        totalMoments: 10,
        emotionStats: [
          _stat(Emotion.happiness, 5),
          _stat(Emotion.sadness, 3),
          _stat(Emotion.mystery, 2),
        ],
        dailyMomentCounts: const {},
      );
      expect(stats.totalEmotionEntries, 10);
    });

    test('positive/negative/neutral 분류가 valence 에 따라 정확해야 함', () {
      final stats = DiaryStatistics(
        totalMoments: 12,
        emotionStats: [
          _stat(Emotion.happiness, 5), // positive
          _stat(Emotion.sadness, 4),   // negative
          _stat(Emotion.mystery, 3),   // neutral (valence 0)
        ],
        dailyMomentCounts: const {},
      );
      expect(stats.positiveEmotionCount, 5);
      expect(stats.negativeEmotionCount, 4);
      expect(stats.neutralEmotionCount, 3);
    });

    test('avgEmotionsPerMoment 는 totalMoments == 0 일 때 0', () {
      const empty = DiaryStatistics.empty;
      expect(empty.avgEmotionsPerMoment, 0);
    });

    test('avgEmotionsPerMoment 는 entries / totalMoments', () {
      final stats = DiaryStatistics(
        totalMoments: 4,
        emotionStats: [_stat(Emotion.happiness, 8)],
        dailyMomentCounts: const {},
      );
      expect(stats.avgEmotionsPerMoment, 2.0);
    });

    test('topEmotions 는 최대 5개까지 반환해야 함', () {
      final stats = DiaryStatistics(
        totalMoments: 30,
        emotionStats: [
          _stat(Emotion.happiness, 10),
          _stat(Emotion.calmness, 8),
          _stat(Emotion.sadness, 6),
          _stat(Emotion.anger, 4),
          _stat(Emotion.fear, 3),
          _stat(Emotion.surprise, 2),
          _stat(Emotion.disgust, 1),
        ],
        dailyMomentCounts: const {},
      );
      expect(stats.topEmotions.length, 5);
      expect(stats.topEmotions.first.emotion, Emotion.happiness);
    });

    test('emotionStats 가 5개 미만이면 그대로 반환', () {
      final stats = DiaryStatistics(
        totalMoments: 6,
        emotionStats: [
          _stat(Emotion.happiness, 3),
          _stat(Emotion.sadness, 3),
        ],
        dailyMomentCounts: const {},
      );
      expect(stats.topEmotions.length, 2);
    });

    test('activeDaysInWindow 는 count > 0 인 날짜의 개수', () {
      final stats = DiaryStatistics(
        totalMoments: 5,
        emotionStats: const [],
        dailyMomentCounts: {
          DateTime(2026, 5, 1): 1,
          DateTime(2026, 5, 2): 0,
          DateTime(2026, 5, 3): 3,
          DateTime(2026, 5, 4): 0,
          DateTime(2026, 5, 5): 1,
        },
      );
      expect(stats.activeDaysInWindow, 3);
    });

    test('dominantEmotion 은 emotionStats 가 비어 있으면 null', () {
      expect(DiaryStatistics.empty.dominantEmotion, isNull);
    });

    test('dominantEmotion 은 emotionStats.first.emotion', () {
      final stats = DiaryStatistics(
        totalMoments: 5,
        emotionStats: [
          _stat(Emotion.happiness, 3),
          _stat(Emotion.sadness, 2),
        ],
        dailyMomentCounts: const {},
      );
      expect(stats.dominantEmotion, Emotion.happiness);
    });
  });
}
