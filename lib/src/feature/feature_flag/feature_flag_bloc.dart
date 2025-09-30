import 'package:diary_mobile_client/src/core/remote_config_client/remote_config_client.dart';
import 'package:diary_mobile_client/src/feature/feature_flag/feature_falg_event.dart';
import 'package:diary_mobile_client/src/feature/feature_flag/feature_flag_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FeatureFlagBloc extends HydratedBloc<FeatureFlagEvent, FeatureFlagState> {
  final RemoteConfigClient remoteConfigClient;

  FeatureFlagBloc(this.remoteConfigClient) : super(FeatureFlagState.initial()) {
    on<LoadFeatureFlag>((event, emit) async {
      final isRecommendV2Enabled =
          await remoteConfigClient.isRecommendV2Enabled();
      final isExperimentalStatisticsEnabled =
          await remoteConfigClient.isExperimentalStatisticsEnabled();
      emit(state.copyWith(
        isRecommendV2Enabled:
            isRecommendV2Enabled.fold((failure) => false, (value) => value),
        isExperimentalStatisticsEnabled: isExperimentalStatisticsEnabled.fold(
            (failure) => false, (value) => value),
      ));
    });
  }

  @override
  FeatureFlagState? fromJson(Map<String, dynamic> json) {
    return FeatureFlagState(
      isRecommendV2Enabled: json['isRecommendV2Enabled'] as bool,
      isExperimentalStatisticsEnabled:
          json['isExperimentalStatisticsEnabled'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(FeatureFlagState state) {
    return {
      'isRecommendV2Enabled': state.isRecommendV2Enabled,
      'isExperimentalStatisticsEnabled': state.isExperimentalStatisticsEnabled,
    };
  }
}
