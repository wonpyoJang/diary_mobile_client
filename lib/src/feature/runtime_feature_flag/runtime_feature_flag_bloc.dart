import 'package:diary_mobile_client/src/core/remote_config_client/remote_config_client.dart';
import 'package:diary_mobile_client/src/feature/runtime_feature_flag/runtime_feature_falg_event.dart';
import 'package:diary_mobile_client/src/feature/runtime_feature_flag/runtime_feature_flag_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class RuntimeFeatureFlagBloc
    extends HydratedBloc<RuntimeFeatureFlagEvent, RuntimeFeatureFlagState> {
  final RemoteConfigClient remoteConfigClient;

  RuntimeFeatureFlagBloc(this.remoteConfigClient)
      : super(RuntimeFeatureFlagState.initial()) {
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
  RuntimeFeatureFlagState? fromJson(Map<String, dynamic> json) {
    return RuntimeFeatureFlagState(
      isRecommendV2Enabled: json['isRecommendV2Enabled'] as bool,
      isExperimentalStatisticsEnabled:
          json['isExperimentalStatisticsEnabled'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(RuntimeFeatureFlagState state) {
    return {
      'isRecommendV2Enabled': state.isRecommendV2Enabled,
      'isExperimentalStatisticsEnabled': state.isExperimentalStatisticsEnabled,
    };
  }
}
