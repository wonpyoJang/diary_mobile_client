import 'package:fpdart/fpdart.dart';
import '../failure/local_failure.dart';
import 'hive_client.dart';
import 'hive_box_names.dart';

/// Hive 클라이언트 확장 메서드들
extension HiveClientExtensions on HiveClient {
  /// 사용자 설정 저장
  Future<Either<LocalFailure, Unit>> saveUserSetting<T>(
    String key,
    T value,
  ) async {
    return put<T>(HiveBoxNames.userSettings, key, value);
  }

  /// 사용자 설정 조회
  Future<Either<LocalFailure, T?>> getUserSetting<T>(String key) async {
    return get<T>(HiveBoxNames.userSettings, key);
  }

  /// 앱 설정 저장
  Future<Either<LocalFailure, Unit>> saveAppPreference<T>(
    String key,
    T value,
  ) async {
    return put<T>(HiveBoxNames.appPreferences, key, value);
  }

  /// 앱 설정 조회
  Future<Either<LocalFailure, T?>> getAppPreference<T>(String key) async {
    return get<T>(HiveBoxNames.appPreferences, key);
  }

  /// 테마 설정 저장
  Future<Either<LocalFailure, Unit>> saveThemeSetting<T>(
    String key,
    T value,
  ) async {
    return put<T>(HiveBoxNames.themeSettings, key, value);
  }

  /// 테마 설정 조회
  Future<Either<LocalFailure, T?>> getThemeSetting<T>(String key) async {
    return get<T>(HiveBoxNames.themeSettings, key);
  }

  /// 이미지 캐시 저장
  Future<Either<LocalFailure, Unit>> saveImageCache(
    String key,
    List<int> imageData,
  ) async {
    return put<List<int>>(HiveBoxNames.imageCache, key, imageData);
  }

  /// 이미지 캐시 조회
  Future<Either<LocalFailure, List<int>?>> getImageCache(String key) async {
    return get<List<int>>(HiveBoxNames.imageCache, key);
  }

  /// 데이터 캐시 저장
  Future<Either<LocalFailure, Unit>> saveDataCache<T>(
    String key,
    T data,
  ) async {
    return put<T>(HiveBoxNames.dataCache, key, data);
  }

  /// 데이터 캐시 조회
  Future<Either<LocalFailure, T?>> getDataCache<T>(String key) async {
    return get<T>(HiveBoxNames.dataCache, key);
  }

  /// API 캐시 저장
  Future<Either<LocalFailure, Unit>> saveApiCache<T>(
    String key,
    T response,
  ) async {
    return put<T>(HiveBoxNames.apiCache, key, response);
  }

  /// API 캐시 조회
  Future<Either<LocalFailure, T?>> getApiCache<T>(String key) async {
    return get<T>(HiveBoxNames.apiCache, key);
  }

  /// 임시 데이터 저장
  Future<Either<LocalFailure, Unit>> saveTempData<T>(
    String key,
    T data,
  ) async {
    return put<T>(HiveBoxNames.tempData, key, data);
  }

  /// 임시 데이터 조회
  Future<Either<LocalFailure, T?>> getTempData<T>(String key) async {
    return get<T>(HiveBoxNames.tempData, key);
  }

  /// 임시 데이터 삭제
  Future<Either<LocalFailure, Unit>> deleteTempData(String key) async {
    return delete(HiveBoxNames.tempData, key);
  }

  /// 임시 데이터 전체 삭제
  Future<Either<LocalFailure, Unit>> clearTempData() async {
    return clearBox(HiveBoxNames.tempData);
  }

  /// 초안 데이터 저장
  Future<Either<LocalFailure, Unit>> saveDraftData<T>(
    String key,
    T data,
  ) async {
    return put<T>(HiveBoxNames.draftData, key, data);
  }

  /// 초안 데이터 조회
  Future<Either<LocalFailure, T?>> getDraftData<T>(String key) async {
    return get<T>(HiveBoxNames.draftData, key);
  }

  /// 초안 데이터 삭제
  Future<Either<LocalFailure, Unit>> deleteDraftData(String key) async {
    return delete(HiveBoxNames.draftData, key);
  }

  /// 세션 데이터 저장
  Future<Either<LocalFailure, Unit>> saveSessionData<T>(
    String key,
    T data,
  ) async {
    return put<T>(HiveBoxNames.sessionData, key, data);
  }

  /// 세션 데이터 조회
  Future<Either<LocalFailure, T?>> getSessionData<T>(String key) async {
    return get<T>(HiveBoxNames.sessionData, key);
  }

  /// 세션 데이터 삭제
  Future<Either<LocalFailure, Unit>> deleteSessionData(String key) async {
    return delete(HiveBoxNames.sessionData, key);
  }

  /// 세션 데이터 전체 삭제
  Future<Either<LocalFailure, Unit>> clearSessionData() async {
    return clearBox(HiveBoxNames.sessionData);
  }

  /// 앱 로그 저장
  Future<Either<LocalFailure, Unit>> saveAppLog(String key, String log) async {
    return put<String>(HiveBoxNames.appLogs, key, log);
  }

  /// 앱 로그 조회
  Future<Either<LocalFailure, String?>> getAppLog(String key) async {
    return get<String>(HiveBoxNames.appLogs, key);
  }

  /// 에러 로그 저장
  Future<Either<LocalFailure, Unit>> saveErrorLog(
      String key, String error) async {
    return put<String>(HiveBoxNames.errorLogs, key, error);
  }

  /// 에러 로그 조회
  Future<Either<LocalFailure, String?>> getErrorLog(String key) async {
    return get<String>(HiveBoxNames.errorLogs, key);
  }

  /// 알림 데이터 저장
  Future<Either<LocalFailure, Unit>> saveNotification<T>(
    String key,
    T notification,
  ) async {
    return put<T>(HiveBoxNames.notifications, key, notification);
  }

  /// 알림 데이터 조회
  Future<Either<LocalFailure, T?>> getNotification<T>(String key) async {
    return get<T>(HiveBoxNames.notifications, key);
  }

  /// 분석 데이터 저장
  Future<Either<LocalFailure, Unit>> saveAnalytics<T>(
    String key,
    T analytics,
  ) async {
    return put<T>(HiveBoxNames.analytics, key, analytics);
  }

  /// 분석 데이터 조회
  Future<Either<LocalFailure, T?>> getAnalytics<T>(String key) async {
    return get<T>(HiveBoxNames.analytics, key);
  }

  /// 보안 데이터 저장
  Future<Either<LocalFailure, Unit>> saveSecurityData<T>(
    String key,
    T securityData,
  ) async {
    return put<T>(HiveBoxNames.security, key, securityData);
  }

  /// 보안 데이터 조회
  Future<Either<LocalFailure, T?>> getSecurityData<T>(String key) async {
    return get<T>(HiveBoxNames.security, key);
  }

  /// 보안 데이터 삭제
  Future<Either<LocalFailure, Unit>> deleteSecurityData(String key) async {
    return delete(HiveBoxNames.security, key);
  }

  /// 모든 캐시 데이터 삭제
  Future<Either<LocalFailure, Unit>> clearAllCache() async {
    try {
      await clearBox(HiveBoxNames.imageCache);
      await clearBox(HiveBoxNames.dataCache);
      await clearBox(HiveBoxNames.apiCache);
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '캐시 데이터 삭제 실패',
        code: 'HIVE_CLEAR_CACHE_ERROR',
        details: e.toString(),
      ));
    }
  }

  /// 모든 임시 데이터 삭제
  Future<Either<LocalFailure, Unit>> clearAllTempData() async {
    try {
      await clearBox(HiveBoxNames.tempData);
      await clearBox(HiveBoxNames.draftData);
      await clearBox(HiveBoxNames.sessionData);
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '임시 데이터 삭제 실패',
        code: 'HIVE_CLEAR_TEMP_ERROR',
        details: e.toString(),
      ));
    }
  }

  /// 모든 로그 데이터 삭제
  Future<Either<LocalFailure, Unit>> clearAllLogs() async {
    try {
      await clearBox(HiveBoxNames.appLogs);
      await clearBox(HiveBoxNames.errorLogs);
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '로그 데이터 삭제 실패',
        code: 'HIVE_CLEAR_LOGS_ERROR',
        details: e.toString(),
      ));
    }
  }
}
