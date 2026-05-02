# diary_mobile_client (Flutter)

Flutter 모바일 앱. BLoC + injectable + hydrated_bloc 기반.

## 핵심 명령

| 목적 | 명령 |
|---|---|
| 정적 분석 | `flutter analyze` |
| 유닛/위젯 테스트 | `flutter test` |
| 통합 테스트 / 스크린샷 | `make screenshots-ios`, `make screenshots-android` |
| 코드 생성 (`*.g.dart`, `injection.config.dart`) | `dart run build_runner build --delete-conflicting-outputs` |
| 일괄 재생성 | `make regenerate` |
| 캐시까지 정리 | `make clean-all` |
| iOS 시뮬레이터 실행 | `flutter run -d "iPhone 16 Pro"` |

## 디렉토리 규약
- `lib/src/feature/<도메인>/` — 화면/위젯/BLoC 묶음 (auth, backup, emotion_statistics, dev_tools 등)
- `lib/src/core/` — 공용 유틸/모델
- `lib/src/database/` — Drift 등 DB 레이어 (`*.g.dart` 생성됨)
- `lib/src/injection.dart` (+ `.config.dart`) — DI 등록. 새 의존성 추가 시 build_runner 필수.

## Verify 체크리스트 (코드 변경 작업)

이 프로젝트에서 **완료 보고 전에 반드시 통과해야 하는 검증**:

1. **flutter analyze 0-error**
   - `flutter analyze` 실행 → 출력에 `error •` 패턴 매칭이 없어야 함
   - `info •`, `warning •`은 차단하지 않으나 별도 보고
2. **diff 의도 검증**
   - `git diff --stat` 후 의심 파일 `git diff <file>`
   - 모든 hunk가 현재 작업 목표에 직접 연결됨
3. **build_runner 의존성**
   - DI(`injection.dart`) 또는 어노테이션이 붙은 모델 변경 시 `dart run build_runner build --delete-conflicting-outputs` 실행
   - 합격 조건: 명령 종료 코드 0
4. **UI 변경 시뮬레이터 확인** (해당 시)
   - `lib/src/feature/**/*.dart` 중 위젯/페이지 파일 변경 시
   - 시뮬레이터에서 골든 패스 직접 동작 확인. 자동화 불가능하면 "시뮬레이터 확인 못 함"을 명시적으로 보고

각 검증의 상세 조건은 `~/.claude/projects/-Users-edjang-workplace-diary-diary-mobile-client/memory/feedback_*.md` 참고.

## 알려진 함정
- `lib/main.dart`는 사용자가 자주 WIP 코드를 둘 수 있는 파일. 자동 편집 시 의도치 않은 hunk가 끼지 않았는지 diff 단계에서 특히 주의 (커밋 8b3db8c 사례).
- iOS 디바이스명은 `"iPhone 16 Pro"` (Makefile / 설정 참조).
- `pubspec.yaml`의 `firebase_ai`, `flutter_bloc 9.x`, `hydrated_bloc 10.x`는 메이저 버전 차이 큼 — 마이그레이션 가이드 확인 후 수정.
