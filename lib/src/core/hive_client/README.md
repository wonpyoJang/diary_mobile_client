# Hive 클라이언트

이 프로젝트의 Hive 클라이언트는 로컬 데이터 저장을 위한 키-값 저장소입니다. Hive는 Flutter에서 사용할 수 있는 빠르고 가벼운 NoSQL 데이터베이스입니다.

## 주요 기능

- **빠른 키-값 저장**: Hive의 빠른 성능을 활용한 데이터 저장
- **타입 안전성**: 제네릭을 사용한 타입 안전한 데이터 접근
- **에러 처리**: Either 타입을 사용한 함수형 에러 처리
- **로깅**: 상세한 로깅을 통한 디버깅 지원
- **박스 관리**: 여러 박스를 통한 데이터 분리 관리
- **확장 메서드**: 편의를 위한 확장 메서드 제공

## 파일 구조

```
lib/src/core/hive_client/
├── hive_client.dart              # Hive 클라이언트 인터페이스 및 구현체
├── hive_box_names.dart           # 박스 이름 상수 정의
├── hive_client_extensions.dart   # 확장 메서드들
└── hive_client_example.dart      # 사용 예제
```

## 설치

`pubspec.yaml`에 다음 의존성을 추가하세요:

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

## 기본 사용법

### 1. Hive 초기화

```dart
final hiveClient = GetIt.instance<HiveClient>();
await hiveClient.initialize();
```

### 2. 기본 CRUD 작업

```dart
// 데이터 저장
await hiveClient.put<String>('my_box', 'key', 'value');

// 데이터 조회
final result = await hiveClient.get<String>('my_box', 'key');
final value = result.fold((l) => null, (r) => r);

// 데이터 삭제
await hiveClient.delete('my_box', 'key');

// 박스 초기화
await hiveClient.clearBox('my_box');
```

### 3. 확장 메서드 사용

```dart
// 사용자 설정 저장/조회
await hiveClient.saveUserSetting('theme_mode', 'dark');
final theme = await hiveClient.getUserSetting<String>('theme_mode');

// 앱 설정 저장/조회
await hiveClient.saveAppPreference('language', 'ko');
final language = await hiveClient.getAppPreference<String>('language');

// 이미지 캐시 저장/조회
await hiveClient.saveImageCache('profile_image', imageData);
final image = await hiveClient.getImageCache('profile_image');

// 임시 데이터 저장/조회
await hiveClient.saveTempData('draft_form', formData);
final draft = await hiveClient.getTempData<Map<String, dynamic>>('draft_form');
```

## 박스 종류

### 사용자 설정 관련
- `user_settings`: 사용자 개인 설정
- `app_preferences`: 앱 전체 설정
- `theme_settings`: 테마 관련 설정

### 캐시 관련
- `image_cache`: 이미지 캐시 데이터
- `data_cache`: 일반 데이터 캐시
- `api_cache`: API 응답 캐시

### 임시 데이터 관련
- `temp_data`: 임시 데이터
- `draft_data`: 초안 데이터
- `session_data`: 세션 데이터

### 로그 관련
- `app_logs`: 앱 로그
- `error_logs`: 에러 로그

### 기타
- `notifications`: 알림 데이터
- `analytics`: 분석 데이터
- `security`: 보안 데이터

## 고급 사용법

### 1. 박스 정보 조회

```dart
// 박스 길이 조회
final length = await hiveClient.getBoxLength('my_box');

// 박스가 비어있는지 확인
final isEmpty = await hiveClient.isBoxEmpty('my_box');

// 키 존재 확인
final hasKey = await hiveClient.containsKey('my_box', 'key');

// 모든 키 조회
final keys = await hiveClient.getAllKeys('my_box');

// 모든 값 조회
final values = await hiveClient.getAllValues<String>('my_box');
```

### 2. 데이터 정리

```dart
// 모든 캐시 데이터 삭제
await hiveClient.clearAllCache();

// 모든 임시 데이터 삭제
await hiveClient.clearAllTempData();

// 모든 로그 데이터 삭제
await hiveClient.clearAllLogs();
```

### 3. 박스 관리

```dart
// 박스 열기
final box = await hiveClient.openBox<String>('my_box');

// 박스 닫기
await hiveClient.closeBox('my_box');

// 모든 박스 닫기
await hiveClient.closeAllBoxes();
```

## 에러 처리

모든 메서드는 `Either<LocalFailure, T>` 타입을 반환합니다:

```dart
final result = await hiveClient.get<String>('my_box', 'key');

result.fold(
  (failure) {
    // 에러 처리
    print('에러: ${failure.message}');
  },
  (value) {
    // 성공 처리
    print('값: $value');
  },
);
```

## 성능 최적화

### 1. 박스 재사용
박스를 한 번 열면 내부적으로 캐시되므로 재사용됩니다.

### 2. 배치 작업
여러 데이터를 저장할 때는 개별적으로 호출하는 것보다 배치로 처리하세요.

### 3. 적절한 데이터 타입 사용
큰 데이터는 바이너리로 저장하고, 작은 데이터는 JSON으로 저장하세요.

## 테스트

테스트 파일은 `test/hive_client/hive_client_test.dart`에 있습니다:

```bash
# 특정 테스트 실행
flutter test test/hive_client/hive_client_test.dart

# 모든 테스트 실행
flutter test
```

## 주의사항

1. **초기화**: 앱 시작 시 반드시 `initialize()`를 호출하세요.
2. **박스 이름**: 박스 이름은 고유해야 합니다.
3. **타입 안전성**: 저장할 때와 조회할 때 같은 타입을 사용하세요.
4. **메모리 관리**: 사용하지 않는 박스는 닫아주세요.
5. **데이터 크기**: 너무 큰 데이터는 성능에 영향을 줄 수 있습니다.

## 예제 실행

```dart
final example = HiveClientExample();
await example.runAllExamples();
```

## 의존성 주입

`injectable` 패키지를 사용하여 의존성 주입이 설정되어 있습니다:

```dart
// 의존성 주입 설정 후
final hiveClient = GetIt.instance<HiveClient>();
```

## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.

