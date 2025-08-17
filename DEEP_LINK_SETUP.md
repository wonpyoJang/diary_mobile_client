# 딥링크 설정 가이드

이 문서는 `cassette-diary://login-callback` 딥링크를 설정하는 방법을 설명합니다.

## 설정된 딥링크

- **스키마**: `cassette-diary`
- **패턴**: `cassette-diary://login-callback`
- **용도**: OAuth 로그인 콜백 처리

## 플랫폼별 설정

### Android

`android/app/src/main/AndroidManifest.xml`에 다음 설정이 추가되었습니다:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cassette-diary" />
</intent-filter>
```

### iOS

`ios/Runner/Info.plist`에 다음 설정이 추가되었습니다:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>cassette-diary</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>cassette-diary</string>
        </array>
    </dict>
</array>
```

## Flutter 앱 설정

### 1. 패키지 추가

`pubspec.yaml`에 다음 패키지가 추가되었습니다:

```yaml
dependencies:
  app_links: ^3.4.5
```

### 2. 딥링크 서비스

`lib/src/core/deep_link/deep_link_service.dart`에서 딥링크를 처리합니다.

### 3. 딥링크 상태 관리

`lib/src/core/deep_link/deep_link_cubit.dart`에서 딥링크 상태를 관리합니다.

### 4. 앱 초기화

`lib/src/app.dart`에서 딥링크 서비스를 초기화합니다.

## 사용법

### 1. 딥링크 수신

앱이 실행 중일 때 `cassette-diary://login-callback?code=ABC123&state=xyz` 형태의 딥링크를 받으면 자동으로 처리됩니다.

### 2. 로그인 콜백 처리

```dart
BlocListener<DeepLinkCubit, DeepLinkState>(
  listener: (context, state) {
    if (state is LoginCallbackReceived) {
      // 로그인 성공 처리
      final code = state.code;
      final stateParam = state.state;
      // 인증 코드로 토큰 교환 등 처리
    }
  },
)
```

### 3. 테스트

디버그 모드에서 스플래시 화면에 "딥링크 테스트" 버튼이 표시됩니다. 이 버튼을 눌러 딥링크를 테스트할 수 있습니다.

또는 직접 URL을 실행할 수 있습니다:

```bash
# Android
adb shell am start -W -a android.intent.action.VIEW -d "cassette-diary://login-callback?code=test123&state=test" com.example.app

# iOS Simulator
xcrun simctl openurl booted "cassette-diary://login-callback?code=test123&state=test"
```


1. **딥링크 수신**: `DeepLinkService`가 딥링크를 감지
2. **파싱**: URL 파라미터를 파싱하여 `code`와 `state` 추출
3. **상태 업데이트**: `DeepLinkCubit`에서 상태 업데이트
4. **UI 반응**: `BlocListener`에서 상태 변화를 감지하여 적절한 처리

## 주의사항

- 딥링크는 앱이 백그라운드에 있거나 종료된 상태에서도 작동합니다.
- Android에서는 `android:autoVerify="true"`를 통해 앱 링크 검증을 지원합니다.
- iOS에서는 `CFBundleURLTypes`를 통해 커스텀 URL 스키마를 등록합니다.

## 문제 해결

### 딥링크가 작동하지 않는 경우

1. **패키지 재설치**: `flutter clean && flutter pub get`
2. **앱 재빌드**: `flutter run`
3. **플랫폼별 설정 확인**: AndroidManifest.xml과 Info.plist 확인
4. **로그 확인**: 콘솔에서 딥링크 관련 로그 확인

### 테스트 시 주의사항

- 실제 기기에서 테스트하는 것이 좋습니다.
- 에뮬레이터에서는 일부 기능이 제한될 수 있습니다.
- 딥링크 테스트 후 앱을 완전히 종료하고 다시 테스트해보세요.
