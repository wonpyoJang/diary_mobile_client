import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client_extensions.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_box_names.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
// injectable의 test 심볼 충돌 방지: 불필요 import 제거

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HiveClient Tests', () {
    late HiveClient hiveClient;

    setUp(() {
      hiveClient = HiveClientImpl();
    });

    tearDown(() async {
      await hiveClient.closeAllBoxes();
    });

    test('Hive 초기화 테스트', () async {
      final result = await hiveClient.initialize();
      expect(result.isRight(), isTrue);
    });

    test('박스 열기 테스트', () async {
      await hiveClient.initialize();
      final result = await hiveClient.openBox<String>('test_box');
      expect(result.isRight(), isTrue);
    });

    test('데이터 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const testKey = 'test_key';
      const testValue = 'test_value';

      // 데이터 저장
      final saveResult =
          await hiveClient.put<String>('test_box', testKey, testValue);
      expect(saveResult.isRight(), isTrue);

      // 데이터 조회
      final getResult = await hiveClient.get<String>('test_box', testKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(testValue));
    });

    test('데이터 삭제 테스트', () async {
      await hiveClient.initialize();
      const testKey = 'test_key';
      const testValue = 'test_value';

      // 데이터 저장
      await hiveClient.put<String>('test_box', testKey, testValue);

      // 데이터 삭제
      final deleteResult = await hiveClient.delete('test_box', testKey);
      expect(deleteResult.isRight(), isTrue);

      // 삭제 확인
      final getResult = await hiveClient.get<String>('test_box', testKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, isNull);
    });

    test('박스 초기화 테스트', () async {
      await hiveClient.initialize();
      const testKey1 = 'test_key_1';
      const testKey2 = 'test_key_2';
      const testValue = 'test_value';

      // 데이터 저장
      await hiveClient.put<String>('test_box', testKey1, testValue);
      await hiveClient.put<String>('test_box', testKey2, testValue);

      // 박스 초기화
      final clearResult = await hiveClient.clearBox('test_box');
      expect(clearResult.isRight(), isTrue);

      // 초기화 확인
      final lengthResult = await hiveClient.getBoxLength('test_box');
      expect(lengthResult.isRight(), isTrue);
      expect(lengthResult.right, equals(0));
    });

    test('키 존재 확인 테스트', () async {
      await hiveClient.initialize();
      const testKey = 'test_key';
      const testValue = 'test_value';

      // 키가 존재하지 않는 경우
      final containsResult1 = await hiveClient.containsKey('test_box', testKey);
      expect(containsResult1.isRight(), isTrue);
      expect(containsResult1.right, isFalse);

      // 데이터 저장
      await hiveClient.put<String>('test_box', testKey, testValue);

      // 키가 존재하는 경우
      final containsResult2 = await hiveClient.containsKey('test_box', testKey);
      expect(containsResult2.isRight(), isTrue);
      expect(containsResult2.right, isTrue);
    });

    test('모든 키 조회 테스트', () async {
      await hiveClient.initialize();
      const testKeys = ['key1', 'key2', 'key3'];
      const testValue = 'test_value';

      // 데이터 저장
      for (final key in testKeys) {
        await hiveClient.put<String>('test_box', key, testValue);
      }

      // 모든 키 조회
      final keysResult = await hiveClient.getAllKeys('test_box');
      expect(keysResult.isRight(), isTrue);
      expect(keysResult.right!.length, equals(testKeys.length));
      for (final key in testKeys) {
        expect(keysResult.right!.contains(key), isTrue);
      }
    });

    test('모든 값 조회 테스트', () async {
      await hiveClient.initialize();
      const testValues = ['value1', 'value2', 'value3'];

      // 데이터 저장
      for (int i = 0; i < testValues.length; i++) {
        await hiveClient.put<String>('test_box', 'key$i', testValues[i]);
      }

      // 모든 값 조회
      final valuesResult = await hiveClient.getAllValues<String>('test_box');
      expect(valuesResult.isRight(), isTrue);
      expect(valuesResult.right!.length, equals(testValues.length));
      for (final value in testValues) {
        expect(valuesResult.right!.contains(value), isTrue);
      }
    });

    test('박스 비어있음 확인 테스트', () async {
      await hiveClient.initialize();

      // 빈 박스 확인
      final isEmptyResult1 = await hiveClient.isBoxEmpty('test_box');
      expect(isEmptyResult1.isRight(), isTrue);
      expect(isEmptyResult1.right, isTrue);

      // 데이터 저장
      await hiveClient.put<String>('test_box', 'test_key', 'test_value');

      // 데이터가 있는 박스 확인
      final isEmptyResult2 = await hiveClient.isBoxEmpty('test_box');
      expect(isEmptyResult2.isRight(), isTrue);
      expect(isEmptyResult2.right, isFalse);
    });
  });

  group('HiveClient Extensions Tests', () {
    late HiveClient hiveClient;

    setUp(() {
      hiveClient = HiveClientImpl();
    });

    tearDown(() async {
      await hiveClient.closeAllBoxes();
    });

    test('사용자 설정 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const settingKey = 'theme_mode';
      const settingValue = 'dark';

      // 설정 저장
      final saveResult =
          await hiveClient.saveUserSetting(settingKey, settingValue);
      expect(saveResult.isRight(), isTrue);

      // 설정 조회
      final getResult = await hiveClient.getUserSetting<String>(settingKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(settingValue));
    });

    test('앱 설정 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const preferenceKey = 'language';
      const preferenceValue = 'ko';

      // 설정 저장
      final saveResult =
          await hiveClient.saveAppPreference(preferenceKey, preferenceValue);
      expect(saveResult.isRight(), isTrue);

      // 설정 조회
      final getResult =
          await hiveClient.getAppPreference<String>(preferenceKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(preferenceValue));
    });

    test('이미지 캐시 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const imageKey = 'profile_image';
      final imageData = List<int>.generate(100, (index) => index);

      // 이미지 캐시 저장
      final saveResult = await hiveClient.saveImageCache(imageKey, imageData);
      expect(saveResult.isRight(), isTrue);

      // 이미지 캐시 조회
      final getResult = await hiveClient.getImageCache(imageKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(imageData));
    });

    test('임시 데이터 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const tempKey = 'temp_form_data';
      final tempData = {'name': 'test', 'email': 'test@example.com'};

      // 임시 데이터 저장
      final saveResult = await hiveClient.saveTempData(tempKey, tempData);
      expect(saveResult.isRight(), isTrue);

      // 임시 데이터 조회
      final getResult =
          await hiveClient.getTempData<Map<String, dynamic>>(tempKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(tempData));
    });

    test('임시 데이터 삭제 테스트', () async {
      await hiveClient.initialize();
      const tempKey = 'temp_form_data';
      final tempData = {'name': 'test'};

      // 임시 데이터 저장
      await hiveClient.saveTempData(tempKey, tempData);

      // 임시 데이터 삭제
      final deleteResult = await hiveClient.deleteTempData(tempKey);
      expect(deleteResult.isRight(), isTrue);

      // 삭제 확인
      final getResult =
          await hiveClient.getTempData<Map<String, dynamic>>(tempKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, isNull);
    });

    test('임시 데이터 전체 삭제 테스트', () async {
      await hiveClient.initialize();
      const tempKeys = ['key1', 'key2', 'key3'];
      const tempValue = 'temp_value';

      // 임시 데이터 저장
      for (final key in tempKeys) {
        await hiveClient.saveTempData(key, tempValue);
      }

      // 임시 데이터 전체 삭제
      final clearResult = await hiveClient.clearTempData();
      expect(clearResult.isRight(), isTrue);

      // 삭제 확인
      for (final key in tempKeys) {
        final getResult = await hiveClient.getTempData<String>(key);
        expect(getResult.isRight(), isTrue);
        expect(getResult.right, isNull);
      }
    });

    test('세션 데이터 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const sessionKey = 'user_session';
      final sessionData = {
        'userId': '123',
        'token': 'abc123',
        'expiresAt': DateTime.now().toIso8601String(),
      };

      // 세션 데이터 저장
      final saveResult =
          await hiveClient.saveSessionData(sessionKey, sessionData);
      expect(saveResult.isRight(), isTrue);

      // 세션 데이터 조회
      final getResult =
          await hiveClient.getSessionData<Map<String, dynamic>>(sessionKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(sessionData));
    });

    test('앱 로그 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const logKey = 'app_start_log';
      const logMessage = '앱이 시작되었습니다.';

      // 로그 저장
      final saveResult = await hiveClient.saveAppLog(logKey, logMessage);
      expect(saveResult.isRight(), isTrue);

      // 로그 조회
      final getResult = await hiveClient.getAppLog(logKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(logMessage));
    });

    test('에러 로그 저장 및 조회 테스트', () async {
      await hiveClient.initialize();
      const errorKey = 'api_error_log';
      const errorMessage = 'API 호출 중 오류가 발생했습니다.';

      // 에러 로그 저장
      final saveResult = await hiveClient.saveErrorLog(errorKey, errorMessage);
      expect(saveResult.isRight(), isTrue);

      // 에러 로그 조회
      final getResult = await hiveClient.getErrorLog(errorKey);
      expect(getResult.isRight(), isTrue);
      expect(getResult.right, equals(errorMessage));
    });

    test('모든 캐시 데이터 삭제 테스트', () async {
      await hiveClient.initialize();
      const cacheKeys = ['cache1', 'cache2', 'cache3'];
      const cacheValue = 'cached_data';

      // 캐시 데이터 저장
      for (final key in cacheKeys) {
        await hiveClient.saveDataCache(key, cacheValue);
      }

      // 모든 캐시 데이터 삭제
      final clearResult = await hiveClient.clearAllCache();
      expect(clearResult.isRight(), isTrue);

      // 삭제 확인
      for (final key in cacheKeys) {
        final getResult = await hiveClient.getDataCache<String>(key);
        expect(getResult.isRight(), isTrue);
        expect(getResult.right, isNull);
      }
    });

    test('모든 임시 데이터 삭제 테스트', () async {
      await hiveClient.initialize();
      const tempKeys = ['temp1', 'temp2', 'temp3'];
      const tempValue = 'temp_data';

      // 임시 데이터 저장
      for (final key in tempKeys) {
        await hiveClient.saveTempData(key, tempValue);
      }

      // 모든 임시 데이터 삭제
      final clearResult = await hiveClient.clearAllTempData();
      expect(clearResult.isRight(), isTrue);

      // 삭제 확인
      for (final key in tempKeys) {
        final getResult = await hiveClient.getTempData<String>(key);
        expect(getResult.isRight(), isTrue);
        expect(getResult.right, isNull);
      }
    });
  });
}
