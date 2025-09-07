import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client_extensions.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_box_names.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Hive 클라이언트 사용 예제
class HiveClientExample {
  final HiveClient _hiveClient = GetIt.instance<HiveClient>();

  /// 사용자 설정 관리 예제
  Future<void> manageUserSettings() async {
    // 테마 설정 저장
    await _hiveClient.saveUserSetting('theme_mode', 'dark');
    await _hiveClient.saveUserSetting('font_size', 16);
    await _hiveClient.saveUserSetting('notifications_enabled', true);

    // 테마 설정 조회
    final themeMode = await _hiveClient.getUserSetting<String>('theme_mode');
    final fontSize = await _hiveClient.getUserSetting<int>('font_size');
    final notificationsEnabled =
        await _hiveClient.getUserSetting<bool>('notifications_enabled');

    debugPrint('테마 모드: ${themeMode.fold((l) => null, (r) => r)}');
    debugPrint('폰트 크기: ${fontSize.fold((l) => null, (r) => r)}');
    debugPrint('알림 활성화: ${notificationsEnabled.fold((l) => null, (r) => r)}');
  }

  /// 앱 설정 관리 예제
  Future<void> manageAppPreferences() async {
    // 앱 설정 저장
    await _hiveClient.saveAppPreference('language', 'ko');
    await _hiveClient.saveAppPreference('auto_save', true);
    await _hiveClient.saveAppPreference('sync_interval', 30);

    // 앱 설정 조회
    final language = await _hiveClient.getAppPreference<String>('language');
    final autoSave = await _hiveClient.getAppPreference<bool>('auto_save');
    final syncInterval =
        await _hiveClient.getAppPreference<int>('sync_interval');

    debugPrint('언어: ${language.fold((l) => null, (r) => r)}');
    debugPrint('자동 저장: ${autoSave.fold((l) => null, (r) => r)}');
    debugPrint('동기화 간격: ${syncInterval.fold((l) => null, (r) => r)}분');
  }

  /// 이미지 캐시 관리 예제
  Future<void> manageImageCache() async {
    // 가상의 이미지 데이터
    final imageData = List<int>.generate(1024, (index) => index % 256);

    // 이미지 캐시 저장
    await _hiveClient.saveImageCache('profile_image', imageData);
    await _hiveClient.saveImageCache('background_image', imageData);

    // 이미지 캐시 조회
    final profileImage = await _hiveClient.getImageCache('profile_image');
    final backgroundImage = await _hiveClient.getImageCache('background_image');

    debugPrint(
        '프로필 이미지 크기: ${profileImage.fold((l) => 0, (r) => r?.length ?? 0)} bytes');
    debugPrint(
        '배경 이미지 크기: ${backgroundImage.fold((l) => 0, (r) => r?.length ?? 0)} bytes');
  }

  /// 데이터 캐시 관리 예제
  Future<void> manageDataCache() async {
    // API 응답 데이터 캐시 저장
    final apiResponse = {
      'status': 'success',
      'data': [
        {'id': 1, 'name': '일기 1'},
        {'id': 2, 'name': '일기 2'},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _hiveClient.saveApiCache('diary_list', apiResponse);

    // 캐시된 데이터 조회
    final cachedData =
        await _hiveClient.getApiCache<Map<String, dynamic>>('diary_list');
    debugPrint('캐시된 일기 목록: ${cachedData.fold((l) => null, (r) => r)}');
  }

  /// 임시 데이터 관리 예제
  Future<void> manageTempData() async {
    // 폼 임시 데이터 저장
    final formData = {
      'title': '오늘의 일기',
      'content': '오늘은 정말 좋은 하루였습니다...',
      'emotion': 'happy',
      'draft': true,
    };

    await _hiveClient.saveTempData('draft_diary', formData);

    // 임시 데이터 조회
    final draftData =
        await _hiveClient.getTempData<Map<String, dynamic>>('draft_diary');
    debugPrint('초안 데이터: ${draftData.fold((l) => null, (r) => r)}');

    // 임시 데이터 삭제
    await _hiveClient.deleteTempData('draft_diary');
  }

  /// 세션 데이터 관리 예제
  Future<void> manageSessionData() async {
    // 사용자 세션 정보 저장
    final sessionData = {
      'userId': 'user_123',
      'token': 'jwt_token_here',
      'refreshToken': 'refresh_token_here',
      'expiresAt':
          DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      'lastLogin': DateTime.now().toIso8601String(),
    };

    await _hiveClient.saveSessionData('user_session', sessionData);

    // 세션 데이터 조회
    final session =
        await _hiveClient.getSessionData<Map<String, dynamic>>('user_session');
    debugPrint('사용자 세션: ${session.fold((l) => null, (r) => r)}');
  }

  /// 로그 관리 예제
  Future<void> manageLogs() async {
    // 앱 로그 저장
    await _hiveClient.saveAppLog(
        'app_start_${DateTime.now().millisecondsSinceEpoch}',
        '앱이 시작되었습니다. - ${DateTime.now()}');
    await _hiveClient.saveAppLog(
        'user_action_${DateTime.now().millisecondsSinceEpoch}',
        '사용자가 일기를 작성했습니다. - ${DateTime.now()}');

    // 에러 로그 저장
    await _hiveClient.saveErrorLog(
        'api_error_${DateTime.now().millisecondsSinceEpoch}',
        'API 호출 중 오류가 발생했습니다: 500 Internal Server Error');

    // 로그 조회
    final appLogs =
        await _hiveClient.getAllValues<String>(HiveBoxNames.appLogs);
    final errorLogs =
        await _hiveClient.getAllValues<String>(HiveBoxNames.errorLogs);

    debugPrint('앱 로그 개수: ${appLogs.fold((l) => 0, (r) => r?.length ?? 0)}');
    debugPrint('에러 로그 개수: ${errorLogs.fold((l) => 0, (r) => r?.length ?? 0)}');
  }

  /// 데이터 정리 예제
  Future<void> cleanupData() async {
    // 모든 캐시 데이터 삭제
    await _hiveClient.clearAllCache();
    debugPrint('모든 캐시 데이터가 삭제되었습니다.');

    // 모든 임시 데이터 삭제
    await _hiveClient.clearAllTempData();
    debugPrint('모든 임시 데이터가 삭제되었습니다.');

    // 모든 로그 데이터 삭제
    await _hiveClient.clearAllLogs();
    debugPrint('모든 로그 데이터가 삭제되었습니다.');
  }

  /// 박스 정보 조회 예제
  Future<void> getBoxInfo() async {
    // 각 박스의 데이터 개수 조회
    final userSettingsCount =
        await _hiveClient.getBoxLength(HiveBoxNames.userSettings);
    final appPreferencesCount =
        await _hiveClient.getBoxLength(HiveBoxNames.appPreferences);
    final imageCacheCount =
        await _hiveClient.getBoxLength(HiveBoxNames.imageCache);
    final tempDataCount = await _hiveClient.getBoxLength(HiveBoxNames.tempData);

    debugPrint('사용자 설정 개수: ${userSettingsCount.fold((l) => 0, (r) => r)}');
    debugPrint('앱 설정 개수: ${appPreferencesCount.fold((l) => 0, (r) => r)}');
    debugPrint('이미지 캐시 개수: ${imageCacheCount.fold((l) => 0, (r) => r)}');
    debugPrint('임시 데이터 개수: ${tempDataCount.fold((l) => 0, (r) => r)}');

    // 박스가 비어있는지 확인
    final isUserSettingsEmpty =
        await _hiveClient.isBoxEmpty(HiveBoxNames.userSettings);
    final isTempDataEmpty = await _hiveClient.isBoxEmpty(HiveBoxNames.tempData);

    debugPrint(
        '사용자 설정 박스가 비어있음: ${isUserSettingsEmpty.fold((l) => true, (r) => r)}');
    debugPrint(
        '임시 데이터 박스가 비어있음: ${isTempDataEmpty.fold((l) => true, (r) => r)}');
  }

  /// 키 존재 확인 예제
  Future<void> checkKeyExistence() async {
    // 키 존재 확인
    final hasThemeSetting =
        await _hiveClient.containsKey(HiveBoxNames.userSettings, 'theme_mode');
    final hasNonExistentKey = await _hiveClient.containsKey(
        HiveBoxNames.userSettings, 'non_existent_key');

    debugPrint('테마 설정 키가 존재함: ${hasThemeSetting.fold((l) => false, (r) => r)}');
    debugPrint(
        '존재하지 않는 키가 존재함: ${hasNonExistentKey.fold((l) => false, (r) => r)}');
  }

  /// 모든 키 조회 예제
  Future<void> getAllKeys() async {
    // 사용자 설정의 모든 키 조회
    final userSettingKeys =
        await _hiveClient.getAllKeys(HiveBoxNames.userSettings);
    debugPrint(
        '사용자 설정 키들: ${userSettingKeys.fold((l) => <String>[], (r) => r ?? <String>[])}');

    // 앱 설정의 모든 키 조회
    final appPreferenceKeys =
        await _hiveClient.getAllKeys(HiveBoxNames.appPreferences);
    debugPrint(
        '앱 설정 키들: ${appPreferenceKeys.fold((l) => <String>[], (r) => r ?? <String>[])}');
  }

  /// 종합 예제 실행
  Future<void> runAllExamples() async {
    debugPrint('=== Hive 클라이언트 사용 예제 시작 ===\n');

    await manageUserSettings();
    debugPrint('');

    await manageAppPreferences();
    debugPrint('');

    await manageImageCache();
    debugPrint('');

    await manageDataCache();
    debugPrint('');

    await manageTempData();
    debugPrint('');

    await manageSessionData();
    debugPrint('');

    await manageLogs();
    debugPrint('');

    await getBoxInfo();
    debugPrint('');

    await checkKeyExistence();
    debugPrint('');

    await getAllKeys();
    debugPrint('');

    await cleanupData();
    debugPrint('');

    debugPrint('=== Hive 클라이언트 사용 예제 완료 ===');
  }
}
