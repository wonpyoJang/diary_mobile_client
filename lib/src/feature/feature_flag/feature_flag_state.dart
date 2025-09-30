import 'package:equatable/equatable.dart';

class FeatureFlagState extends Equatable {
  final bool isRecommendV2Enabled;
  final bool isExperimentalStatisticsEnabled;

  const FeatureFlagState({
    required this.isRecommendV2Enabled,
    required this.isExperimentalStatisticsEnabled,
  });

  @override
  List<Object?> get props =>
      [isRecommendV2Enabled, isExperimentalStatisticsEnabled];

  FeatureFlagState copyWith({
    bool? isRecommendV2Enabled,
    bool? isExperimentalStatisticsEnabled,
  }) {
    return FeatureFlagState(
      isRecommendV2Enabled: isRecommendV2Enabled ?? this.isRecommendV2Enabled,
      isExperimentalStatisticsEnabled: isExperimentalStatisticsEnabled ??
          this.isExperimentalStatisticsEnabled,
    );
  }

  factory FeatureFlagState.initial() => const FeatureFlagState(
        isRecommendV2Enabled: false,
        isExperimentalStatisticsEnabled: false,
      );
}
