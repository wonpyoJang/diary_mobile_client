import 'package:equatable/equatable.dart';

enum TriggerValence { positive, negative, neutral }

/// 본문에서 추출한 키워드와 그 키워드가 등장한 일기들의 감정 분포.
/// "'회사' 언급 시 부정 감정 72%" 같은 인사이트의 원천 데이터.
class TriggerStat extends Equatable {
  /// 추출된 키워드 (소문자/원형은 호출 측에서 처리).
  final String keyword;

  /// 이 키워드가 등장한 일기(moment) 수.
  final int totalCount;

  /// 그 중 긍정 감정이 우세했던 일기 수.
  final int positiveCount;

  /// 그 중 부정 감정이 우세했던 일기 수.
  final int negativeCount;

  /// 그 중 중립이었던 일기 수.
  final int neutralCount;

  const TriggerStat({
    required this.keyword,
    required this.totalCount,
    required this.positiveCount,
    required this.negativeCount,
    required this.neutralCount,
  });

  double get positiveRatio => totalCount == 0 ? 0 : positiveCount / totalCount;
  double get negativeRatio => totalCount == 0 ? 0 : negativeCount / totalCount;
  double get neutralRatio => totalCount == 0 ? 0 : neutralCount / totalCount;

  /// 가장 비중이 큰 valence.
  TriggerValence get dominantValence {
    if (positiveCount >= negativeCount && positiveCount >= neutralCount) {
      return TriggerValence.positive;
    }
    if (negativeCount >= neutralCount) {
      return TriggerValence.negative;
    }
    return TriggerValence.neutral;
  }

  /// 우세 valence 의 비율 (0.0 ~ 1.0).
  double get dominantRatio {
    switch (dominantValence) {
      case TriggerValence.positive:
        return positiveRatio;
      case TriggerValence.negative:
        return negativeRatio;
      case TriggerValence.neutral:
        return neutralRatio;
    }
  }

  @override
  List<Object?> get props =>
      [keyword, totalCount, positiveCount, negativeCount, neutralCount];
}
