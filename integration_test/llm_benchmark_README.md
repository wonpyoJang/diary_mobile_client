# LLM Benchmark Harness

자동 벤치마크 (issue #34). 등록된 모든 `ILlmProvider`에 대해 4개 시나리오를 돌려 latency, 출력 길이, 키워드 매칭 기반 품질, 메모리(best-effort)를 측정한다.

## 실행

기기/시뮬레이터가 있어야 한다 (`integration_test`는 Flutter 호스트 필요):

```bash
# iOS 시뮬레이터
flutter test integration_test/llm_benchmark_test.dart -d "iPhone 16 Pro"

# Android 에뮬레이터
flutter test integration_test/llm_benchmark_test.dart -d <device-id>
```

결과는 앱의 documents 디렉터리에 두 파일로 저장된다:
- `llm_benchmark_results.json` — 구조화된 측정값
- `llm_benchmark_summary.md` — provider별 표 형식 요약

iOS 시뮬레이터 경로 예: `~/Library/Developer/CoreSimulator/Devices/<device>/data/Containers/Data/Application/<app>/Documents/`

## 시나리오

| 이름 | 입력 | 측정 의도 |
|---|---|---|
| `emotion_classify_short` | 50자 일기 한 편 → 감정 분류 | 짧은 입력 latency |
| `weekly_summary_long` | 7일치 일기 → 3-bullet 요약 | 긴 컨텍스트 처리 |
| `trigger_extraction` | 5편 → 부정 감정 키워드 top 3 | 정보 추출 정확도 |
| `cold_start_first_call` | 시나리오 1과 동일하지만 첫 호출만 | 콜드 스타트 지연 |

## 메트릭

- `latencyMs` — 반복당 wall-clock; **p50 / p95** 보고
- `outputLengthChars` / `outputTokensApprox` (≈ chars/4)
- `qualityScore` — `expectedKeywords` 출현 비율 (0.0–1.0). 거친 신호 — 품질이 0이면 모델 응답이 시나리오와 무관하다는 뜻
- `peakHeapBytes` — `ProcessInfo.currentRss` (가능한 환경에서만)
- `coldStartLatencyMs` — 콜드 시나리오 전용

## 제외 항목 (별도 이슈)

| 이슈 | 내용 |
|---|---|
| #26 | 실기기 배터리 / 발열 / throttling — 자동화 불가 |
| #31 | Gemma 모델 다운로드 URL/파일명 — 미해결 시 GemmaLocalProvider는 `isAvailable() == false`로 자동 스킵 |
| #32 | Gemma 실제 추론 코드 — placeholder 상태 |

## 한계

- `qualityScore`는 키워드 매칭 기반. LLM-as-judge는 추가 API 호출이 필요해 v1에서 제외.
- `expect()`로 정답을 강제하지 않는다 — 품질은 보고용. 테스트 통과 조건은 "모든 provider에 대해 시도했는가"만 확인.
- 시뮬레이터 latency는 실기기와 다를 수 있다. 추세 비교용으로 활용.
