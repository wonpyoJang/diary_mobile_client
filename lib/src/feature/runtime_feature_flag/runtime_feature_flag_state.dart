import 'package:equatable/equatable.dart';

class RuntimeFeatureFlagState extends Equatable {
  final bool isRecommendV2Enabled;
  final bool isExperimentalStatisticsEnabled;

  const RuntimeFeatureFlagState({
    required this.isRecommendV2Enabled,
    required this.isExperimentalStatisticsEnabled,
  });

  @override
  List<Object?> get props =>
      [isRecommendV2Enabled, isExperimentalStatisticsEnabled];

  RuntimeFeatureFlagState copyWith({
    bool? isRecommendV2Enabled,
    bool? isExperimentalStatisticsEnabled,
  }) {
    return RuntimeFeatureFlagState(
      isRecommendV2Enabled: isRecommendV2Enabled ?? this.isRecommendV2Enabled,
      isExperimentalStatisticsEnabled: isExperimentalStatisticsEnabled ??
          this.isExperimentalStatisticsEnabled,
    );
  }

  factory RuntimeFeatureFlagState.initial() => const RuntimeFeatureFlagState(
        isRecommendV2Enabled: false,
        isExperimentalStatisticsEnabled: false,
      );
}
