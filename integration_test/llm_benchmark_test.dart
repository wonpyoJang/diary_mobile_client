// Automated benchmark harness for LLM providers (issue #34).
//
// Iterates the registered [ILlmProvider] instances (Gemini remote / Gemma
// local / Apple Foundation), runs four canned scenarios, and writes both a
// JSON report and a Markdown summary to the writable application directory.
//
// What this harness measures:
//   - latencyMs (per iteration; reported as p50 / p95)
//   - outputLengthChars + outputTokensApprox (length / 4)
//   - qualityScore (fraction of `expectedKeywords` that appear in the output)
//   - peakHeapBytes (best-effort via `ProcessInfo.currentRss`)
//   - coldStartLatencyMs (separate scenario for the very first call)
//
// What is intentionally OUT of scope:
//   - Real-device battery / thermal throttling — tracked by issue #26.
//   - Gemma model download/inference wiring — tracked by issues #31, #32.
//
// Cannot be executed in a headless CI without a device/simulator, since
// `integration_test` requires a Flutter binding host. See README.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:diary_mobile_client/firebase_options.dart';
import 'package:diary_mobile_client/src/feature/llm/domain/failures/llm_failure.dart';
import 'package:diary_mobile_client/src/feature/llm/domain/i_llm_provider.dart';
import 'package:diary_mobile_client/src/feature/llm/domain/llm_request.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A single benchmark scenario.
@immutable
class BenchmarkScenario {
  const BenchmarkScenario({
    required this.name,
    required this.prompt,
    required this.expectedKeywords,
    this.iterations = 3,
  });

  final String name;
  final String prompt;
  final List<String> expectedKeywords;
  final int iterations;
}

/// Result of running one scenario against one provider.
class ScenarioResult {
  ScenarioResult({
    required this.name,
    required this.iterations,
    required this.latencyMsP50,
    required this.latencyMsP95,
    required this.outputLengthChars,
    required this.outputTokensApprox,
    required this.qualityScore,
    required this.peakHeapBytes,
    required this.errors,
    this.coldStartLatencyMs,
  });

  final String name;
  final int iterations;
  final int latencyMsP50;
  final int latencyMsP95;
  final int outputLengthChars;
  final int outputTokensApprox;
  final double qualityScore;
  final int? peakHeapBytes;
  final int errors;
  final int? coldStartLatencyMs;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'iterations': iterations,
        'latencyMsP50': latencyMsP50,
        'latencyMsP95': latencyMsP95,
        'outputLengthChars': outputLengthChars,
        'outputTokensApprox': outputTokensApprox,
        'qualityScore': double.parse(qualityScore.toStringAsFixed(3)),
        'peakHeapBytes': peakHeapBytes,
        'errors': errors,
        if (coldStartLatencyMs != null) 'coldStartLatencyMs': coldStartLatencyMs,
      };
}

/// Aggregated result for one provider.
class ProviderResult {
  ProviderResult({
    required this.providerId,
    required this.available,
    required this.scenarios,
    this.skipReason,
  });

  final String providerId;
  final bool available;
  final List<ScenarioResult> scenarios;
  final String? skipReason;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'providerId': providerId,
        'available': available,
        if (skipReason != null) 'skipReason': skipReason,
        'scenarios': scenarios.map((s) => s.toJson()).toList(),
      };
}

// --- Korean diary fixtures (small, deterministic). ---

const String _shortDiary = '''
오늘 오랜만에 친구를 만나서 카페에서 두 시간 동안 수다를 떨었다.
요즘 회사 일이 너무 바빠서 지쳐 있었는데, 친구의 농담과 따뜻한
응원 덕분에 마음이 한결 가벼워졌다. 집에 돌아오는 길 발걸음이 가벼웠다.
''';

const List<String> _weekEntries = <String>[
  '월요일: 새 프로젝트 킥오프 미팅. 일정이 빡빡해서 마음이 무겁다.',
  '화요일: 야근. 동료가 도와줘서 그래도 진도가 나갔다.',
  '수요일: 점심에 동료들과 라멘. 이런 사소한 시간이 위로가 된다.',
  '목요일: 코드 리뷰에서 지적이 많아 살짝 위축됐다.',
  '금요일: 마침내 PR 머지. 기쁨이 컸다.',
  '토요일: 늦잠 자고 산책. 햇살이 좋았다.',
  '일요일: 가족과 저녁. 다음 주는 좀 더 차분하게 보내고 싶다.',
];

const List<String> _triggerEntries = <String>[
  '회사에서 야근하다 화가 나서 밤늦게 라면을 먹었다.',
  '상사의 피드백에 위축되어 카페인을 너무 많이 마셨다.',
  '주말에 잠을 못 자서 머리가 아팠고, 결국 약을 먹었다.',
  '회의가 길어져서 점심을 거르고 저녁에 폭식했다.',
  '동료와의 갈등으로 스트레스를 받아 밤에 잠들기 힘들었다.',
];

const List<BenchmarkScenario> _scenarios = <BenchmarkScenario>[
  BenchmarkScenario(
    name: 'emotion_classify_short',
    prompt: '''
다음 일기의 감정을 {기쁨, 슬픔, 분노, 평온, 불안, 기대} 중 하나로 분류해줘.
한 단어만 답해.

일기:
$_shortDiary
''',
    expectedKeywords: <String>['기쁨'],
    iterations: 3,
  ),
  BenchmarkScenario(
    name: 'weekly_summary_long',
    prompt: '''
다음은 한 사람이 일주일 동안 작성한 짧은 일기 7편이다. 전체를 읽고
이 사람의 한 주를 3개의 불릿(•)으로 요약해줘. 각 불릿은 한 문장.

${_weekEntries.join('\n')}
''',
    expectedKeywords: <String>['프로젝트', '동료', '주말'],
    iterations: 3,
  ),
  BenchmarkScenario(
    name: 'trigger_extraction',
    prompt: '''
다음은 일기 5편이다. 부정적 감정과 가장 강하게 연관된 키워드를
정확히 3개 뽑아줘. 콤마로 구분된 한 줄로만 답해.

${_triggerEntries.join('\n')}
''',
    expectedKeywords: <String>['야근', '스트레스', '갈등', '피드백', '폭식'],
    iterations: 3,
  ),
  BenchmarkScenario(
    name: 'cold_start_first_call',
    prompt: '''
다음 일기의 감정을 {기쁨, 슬픔, 분노, 평온, 불안, 기대} 중 하나로 분류해줘.
한 단어만 답해.

일기:
$_shortDiary
''',
    expectedKeywords: <String>['기쁨'],
    iterations: 1,
  ),
];

const List<String> _providerNames = <String>[
  'gemini_remote',
  'gemma_local',
  'apple_foundation',
];

// --- Bootstrap (mirrors the existing backup_and_stats_e2e_test.dart). ---

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qnpolyxygqnismrzvklz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFucG9seXh5Z3FuaXNtcnp2a2x6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU0MzAzNzIsImV4cCI6MjA3MTAwNjM3Mn0.1qmqNbZmxhmRa5AJ-b6D7OmuUXuXSWyNnL8c9VmKJwo',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureDependencies();

  debugPrint('[llm_benchmark] bootstrap complete');
}

// --- Helpers. ---

int _percentile(List<int> sortedValues, double p) {
  if (sortedValues.isEmpty) return 0;
  if (sortedValues.length == 1) return sortedValues.first;
  // Nearest-rank percentile.
  final rank = (p * (sortedValues.length - 1)).round();
  return sortedValues[rank.clamp(0, sortedValues.length - 1)];
}

double _qualityScore(String output, List<String> keywords) {
  if (keywords.isEmpty) return 0;
  final lower = output.toLowerCase();
  var hits = 0;
  for (final kw in keywords) {
    if (lower.contains(kw.toLowerCase())) hits++;
  }
  return hits / keywords.length;
}

int? _currentRssBytes() {
  try {
    return ProcessInfo.currentRss;
  } catch (_) {
    return null;
  }
}

ILlmProvider? _resolveProvider(String name) {
  try {
    return getIt<ILlmProvider>(instanceName: name);
  } catch (_) {
    return null;
  }
}

Future<ScenarioResult> _runScenario(
  ILlmProvider provider,
  BenchmarkScenario scenario,
) async {
  final latencies = <int>[];
  var totalChars = 0;
  var totalQuality = 0.0;
  var errors = 0;
  var peakRss = _currentRssBytes() ?? 0;

  for (var i = 0; i < scenario.iterations; i++) {
    final sw = Stopwatch()..start();
    final result = await provider.generateText(LlmRequest(prompt: scenario.prompt));
    sw.stop();

    final ms = sw.elapsedMilliseconds;
    final rss = _currentRssBytes();
    if (rss != null && rss > peakRss) peakRss = rss;

    result.match(
      (LlmFailure f) {
        errors++;
        debugPrint(
          '[llm_benchmark] ${provider.providerId} / ${scenario.name} '
          'iter=$i FAIL kind=${f.kind} msg=${f.message}',
        );
      },
      (String text) {
        latencies.add(ms);
        totalChars += text.length;
        totalQuality += _qualityScore(text, scenario.expectedKeywords);
      },
    );
  }

  final sorted = List<int>.from(latencies)..sort();
  final completed = latencies.length;
  final avgChars = completed == 0 ? 0 : (totalChars / completed).round();
  final avgQuality = completed == 0 ? 0.0 : (totalQuality / completed);

  return ScenarioResult(
    name: scenario.name,
    iterations: scenario.iterations,
    latencyMsP50: _percentile(sorted, 0.5),
    latencyMsP95: _percentile(sorted, 0.95),
    outputLengthChars: avgChars,
    outputTokensApprox: (avgChars / 4).round(),
    qualityScore: avgQuality,
    peakHeapBytes: peakRss > 0 ? peakRss : null,
    errors: errors,
    coldStartLatencyMs:
        scenario.name == 'cold_start_first_call' && latencies.isNotEmpty
            ? latencies.first
            : null,
  );
}

Future<ProviderResult> _benchmarkProvider(String name) async {
  final provider = _resolveProvider(name);
  if (provider == null) {
    debugPrint('[llm_benchmark] $name not registered, skipping');
    return ProviderResult(
      providerId: name,
      available: false,
      scenarios: const <ScenarioResult>[],
      skipReason: 'not registered in DI',
    );
  }

  bool available;
  try {
    available = await provider.isAvailable();
  } catch (e) {
    available = false;
    debugPrint('[llm_benchmark] $name isAvailable() threw: $e');
  }

  if (!available) {
    debugPrint('[llm_benchmark] ${provider.providerId} not available, skipping');
    return ProviderResult(
      providerId: provider.providerId,
      available: false,
      scenarios: const <ScenarioResult>[],
      skipReason: 'isAvailable() returned false',
    );
  }

  final results = <ScenarioResult>[];
  for (final scenario in _scenarios) {
    debugPrint(
      '[llm_benchmark] running ${provider.providerId} / ${scenario.name}',
    );
    try {
      results.add(await _runScenario(provider, scenario));
    } catch (e, st) {
      debugPrint('[llm_benchmark] scenario ${scenario.name} crashed: $e\n$st');
      results.add(ScenarioResult(
        name: scenario.name,
        iterations: scenario.iterations,
        latencyMsP50: 0,
        latencyMsP95: 0,
        outputLengthChars: 0,
        outputTokensApprox: 0,
        qualityScore: 0,
        peakHeapBytes: null,
        errors: scenario.iterations,
      ));
    }
  }

  return ProviderResult(
    providerId: provider.providerId,
    available: true,
    scenarios: results,
  );
}

// --- Output writers. ---

Future<Directory> _resolveOutputDir() async {
  // Prefer build/ when running on a host (ProcessInfo gives us cwd via env);
  // fall back to the platform-writable application docs directory.
  try {
    final cwd = Directory.current.path;
    final buildDir = Directory('$cwd/build');
    if (buildDir.existsSync()) {
      return buildDir;
    }
    // Try to create build/ if cwd is writable (host runs).
    try {
      buildDir.createSync(recursive: true);
      return buildDir;
    } catch (_) {
      // Fall through to docs dir.
    }
  } catch (_) {
    // ignore
  }
  return getApplicationDocumentsDirectory();
}

Future<void> _writeReports(List<ProviderResult> results) async {
  final dir = await _resolveOutputDir();
  final now = DateTime.now().toUtc().toIso8601String();
  final device = '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';

  final json = <String, dynamic>{
    'timestamp': now,
    'device': device,
    'providers': results.map((r) => r.toJson()).toList(),
  };

  final jsonFile = File('${dir.path}/llm_benchmark_results.json');
  await jsonFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(json),
  );
  debugPrint('[llm_benchmark] wrote ${jsonFile.path}');

  final md = StringBuffer()
    ..writeln('# LLM Benchmark Results')
    ..writeln()
    ..writeln('- timestamp: `$now`')
    ..writeln('- device: `$device`')
    ..writeln();

  for (final p in results) {
    md
      ..writeln('## ${p.providerId} '
          '(${p.available ? "available" : "skipped"})')
      ..writeln();
    if (!p.available) {
      md
        ..writeln('Skipped: ${p.skipReason ?? "unavailable"}')
        ..writeln();
      continue;
    }
    md
      ..writeln('| Scenario | Iter | p50 (ms) | p95 (ms) | '
          'Tokens~ | Quality | Errors |')
      ..writeln('| --- | --- | --- | --- | --- | --- | --- |');
    for (final s in p.scenarios) {
      md.writeln(
        '| ${s.name} | ${s.iterations} | ${s.latencyMsP50} | '
        '${s.latencyMsP95} | ${s.outputTokensApprox} | '
        '${s.qualityScore.toStringAsFixed(2)} | ${s.errors} |',
      );
    }
    md.writeln();
  }

  final mdFile = File('${dir.path}/llm_benchmark_summary.md');
  await mdFile.writeAsString(md.toString());
  debugPrint('[llm_benchmark] wrote ${mdFile.path}');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _bootstrap();
  });

  testWidgets('llm_benchmark_all_providers', (tester) async {
    // Make sure the framework has had a frame so that any pending
    // microtasks during DI registration have flushed.
    await tester.pump();

    final results = <ProviderResult>[];
    for (final name in _providerNames) {
      results.add(await _benchmarkProvider(name));
    }

    await _writeReports(results);

    // The benchmark itself does not assert correctness — quality is reported,
    // not enforced. We only assert that we attempted every provider.
    expect(results.length, _providerNames.length);
  }, timeout: const Timeout(Duration(minutes: 10)));
}
