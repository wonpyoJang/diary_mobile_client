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

## AI 도구 설정 (저장소로 관리)

팀·CI와 동일한 가이드를 쓰려면 아래는 **반드시 커밋**한다. 로컬 전용 캐시는 `.gitignore`로 제외한다.

| 구분 | 경로 | 설명 |
|------|------|------|
| **Cursor Rules** | `.cursor/rules/*.mdc` | 에디터 규칙(토큰·레이트·로컬 모델 우선 등). 새 규칙 추가 시 이 디렉터리에 두고 커밋. |
| **Cursor 서브에이전트** | `.cursor/agents/*.md` | 프로젝트 전용 서브에이전트. |
| **Claude Code 서브에이전트** | `.claude/agents/*.md` | Cursor와 **동일 역할**을 두 도구에서 쓰도록 내용을 맞춘다. |

- 역할 인덱스: [`.claude/agents/business-team.md`](.claude/agents/business-team.md) — marketer, business-strategist, product-planner 요약 및 관련 이슈 링크.
- GitHub 직군 소통(이슈 템플릿·`role/*` 라벨): [`.github/COMMUNICATION.md`](.github/COMMUNICATION.md)
- **제외**: `.claude/worktrees/`는 Claude Code 로컬 워크트리로, 저장소에 넣지 않음.

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

## 로컬 모델 우선

- **원칙**: 로컬(또는 온디바이스) 모델로도 **목표 품질까지 도달할 수 있는** 작업이면, 클라우드·고급 모델보다 **로컬·경량 모델을 먼저** 쓰는 것을 권장한다(한도·비용·지연·프라이버시).
- **로컬에 잘 맞는 예**: 소규모 수정·규칙 기반 리팩터·린트/포맷·저장소 검색으로 답 가능한 질문·이미 프로젝트 패턴이 분명한 반복 작업.
- **고급 모델이 유리한 예**: 큰 설계·모호한 디버깅·초대형 컨텍스트 비교, 사용자가 명시적으로 고급 모델을 요청한 경우.
- Cursor 에이전트 세부 문구는 `.cursor/rules/local-model-preference.mdc`와 동일 계열로 맞춘다. 특정 로컬 모델명·하드웨어 요구는 단정하지 않는다.

## 토큰·레이트 리밋 (효율·예측)

- **효율**: 불필요한 전체 파일 읽기·중복 도구 호출을 피하고, 긴 출력은 요약·부분 인용.
- **한도 도달 시점 추정** (사용자가 `R` 남은 토큰, `U` 시간당 소비, `T_avg` 턴당 소비를 알려주면):
  - 시간 기준: 대략 `R / U` (최근 소비율이 유지된다는 가정).
  - 턴 기준: 대략 `R / T_avg`.
  - 플랜별 수치는 공식 UI 기준; 고정 숫자로 단정하지 않음.
- Cursor에서는 `.cursor/rules/token-rate-limit-awareness.mdc`, `.cursor/rules/local-model-preference.mdc`와 함께 적용.

## 알려진 함정
- `lib/main.dart`는 사용자가 자주 WIP 코드를 둘 수 있는 파일. 자동 편집 시 의도치 않은 hunk가 끼지 않았는지 diff 단계에서 특히 주의 (커밋 8b3db8c 사례).
- iOS 디바이스명은 `"iPhone 16 Pro"` (Makefile / 설정 참조).
- `pubspec.yaml`의 `firebase_ai`, `flutter_bloc 9.x`, `hydrated_bloc 10.x`는 메이저 버전 차이 큼 — 마이그레이션 가이드 확인 후 수정.
