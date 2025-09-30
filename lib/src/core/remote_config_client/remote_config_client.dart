import 'package:diary_mobile_client/src/core/remote_config_client/remote_config_failure.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

enum FeatureFlagKey {
  // 여기에 실제로 사용하는 플래그 키를 정의하세요.
  // 예) 신규 추천 알고리즘 토글
  recommendV2Enabled,
  // 예) 실험적 통계 화면
  experimentalStatistics,
}

extension FeatureFlagKeyExt on FeatureFlagKey {
  String get wireKey {
    switch (this) {
      case FeatureFlagKey.recommendV2Enabled:
        return 'feature_recommend_v2_enabled';
      case FeatureFlagKey.experimentalStatistics:
        return 'feature_experimental_statistics';
    }
  }
}

@singleton
class RemoteConfigClient {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigClient(this._remoteConfig);

  /// 앱 시작 시 Composition Root에서 1회 호출 권장
  /// 예: `await getIt<RemoteConfigClient>().initialize();`
  Future<Either<RemoteConfigFailure, Unit>> initialize(
      {Duration fetchTimeout = const Duration(seconds: 10),
      Duration minimumFetchInterval = const Duration(minutes: 5)}) async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ));
      // 기본 플래그 디폴트 값 등록 (서버 값이 없을 때 안전한 동작 보장)
      await _remoteConfig.setDefaults({
        for (final key in FeatureFlagKey.values) key.wireKey: false,
      });
      await _remoteConfig.ensureInitialized();
      await _remoteConfig.fetchAndActivate();
      return right(unit);
    } catch (e) {
      return left(RemoteConfigFailure(
          message: '원격 설정 초기화 실패', code: 'RC_INIT_FAILED', details: e));
    }
  }

  Future<Either<RemoteConfigFailure, bool>> getFlag(
    FeatureFlagKey key, {
    bool fallback = false,
  }) async {
    try {
      final value = _remoteConfig.getBool(key.wireKey);
      return right(value);
    } catch (e) {
      return left(RemoteConfigFailure(
          message: '플래그 조회 실패', code: 'RC_GET_FLAG_FAILED', details: e));
    }
  }

  // 편의 게터: 도메인에서 명시적으로 사용하기 쉬운 래퍼
  Future<Either<RemoteConfigFailure, bool>> isRecommendV2Enabled() =>
      getFlag(FeatureFlagKey.recommendV2Enabled);

  Future<Either<RemoteConfigFailure, bool>> isExperimentalStatisticsEnabled() =>
      getFlag(FeatureFlagKey.experimentalStatistics);

  // 필요 시 문자열/정수 값도 노출
  Future<Either<RemoteConfigFailure, String>> getString(String key,
      {String fallback = ''}) async {
    try {
      final value = _remoteConfig.getString(key);
      return right(value.isEmpty ? fallback : value);
    } catch (e) {
      return left(RemoteConfigFailure(
          message: '문자열 조회 실패', code: 'RC_GET_STRING_FAILED', details: e));
    }
  }

  Future<Either<RemoteConfigFailure, int>> getInt(String key,
      {int fallback = 0}) async {
    try {
      final value = _remoteConfig.getInt(key);
      return right(value);
    } catch (e) {
      return left(RemoteConfigFailure(
          message: '정수 조회 실패', code: 'RC_GET_INT_FAILED', details: e));
    }
  }
}
