import 'package:diary_mobile_client/src/core/dev/moment_seeder.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/dev_tools/presentation/dev_tools_page.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _UnusedDriftClient implements DriftClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw StateError(
        '_UnusedDriftClient should not be invoked: ${invocation.memberName}');
  }
}

class _FakeMomentSeeder extends MomentSeeder {
  Future<Either<LocalFailure, int>> Function()? onSeed;
  Future<Either<LocalFailure, Unit>> Function()? onClearAll;
  Future<Either<LocalFailure, int>> Function()? onCount;

  _FakeMomentSeeder() : super(_UnusedDriftClient());

  @override
  Future<Either<LocalFailure, int>> seedNow({
    int count = MomentSeeder.defaultSeedCount,
  }) =>
      onSeed?.call() ?? Future.value(right(count));

  @override
  Future<Either<LocalFailure, Unit>> clearAll() =>
      onClearAll?.call() ?? Future.value(right(unit));

  @override
  Future<Either<LocalFailure, int>> getCurrentMomentCount() =>
      onCount?.call() ?? Future.value(right(0));
}

void _registerSeeder(_FakeMomentSeeder seeder) {
  if (getIt.isRegistered<MomentSeeder>()) {
    getIt.unregister<MomentSeeder>();
  }
  getIt.registerSingleton<MomentSeeder>(seeder);
}

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    if (getIt.isRegistered<MomentSeeder>()) {
      getIt.unregister<MomentSeeder>();
    }
  });

  // kDebugMode 는 테스트 실행 시 true 이므로 본 위젯이 정상 렌더링됨.
  // (release 빌드 fallback 분기는 위젯 테스트에서 검증 불가 — 스킵)
  testWidgets('AppBar 에 "개발자 도구" 와 뒤로가기 버튼이 있어야 함', (tester) async {
    if (!kDebugMode) return; // safety guard
    _registerSeeder(_FakeMomentSeeder()..onCount = () async => right(7));

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    expect(find.text('개발자 도구'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
  });

  testWidgets('현재 저장된 일기 수가 화면에 표시되어야 함', (tester) async {
    if (!kDebugMode) return;
    _registerSeeder(_FakeMomentSeeder()..onCount = () async => right(42));

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    // 카운트는 RichText 의 TextSpan 으로 렌더되므로 plain Text finder 가 안 됨.
    // '편의 일기' 라벨을 포함하는 RichText 를 골라 누적 텍스트에 '42' 가 있는지 검증.
    final countFinder = find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('편의 일기'));
    expect(countFinder, findsOneWidget);
    final plain = tester.widget<RichText>(countFinder).text.toPlainText();
    expect(plain, contains('42'));
  });

  testWidgets('카운트 조회 실패 시 상태 배너에 에러가 표시되어야 함', (tester) async {
    if (!kDebugMode) return;
    _registerSeeder(_FakeMomentSeeder()
      ..onCount = () async => left(const LocalFailure(message: 'DB 닫힘')));

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('개수 조회 실패'), findsOneWidget);
    expect(find.textContaining('DB 닫힘'), findsOneWidget);
  });

  testWidgets('"추가" 버튼 탭 시 seedNow 가 호출되고 성공 메시지가 표시됨', (tester) async {
    if (!kDebugMode) return;
    int seedCalls = 0;
    final seeder = _FakeMomentSeeder();
    seeder.onCount = () async => right(0);
    seeder.onSeed = () async {
      seedCalls++;
      return right(100);
    };
    _registerSeeder(seeder);

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, '추가'));
    await tester.pumpAndSettle();

    expect(seedCalls, 1);
    expect(find.textContaining('100편의 더미 일기를 추가'), findsOneWidget);
  });

  testWidgets('seedNow 실패 시 에러 배너 표시', (tester) async {
    if (!kDebugMode) return;
    final seeder = _FakeMomentSeeder();
    seeder.onCount = () async => right(0);
    seeder.onSeed = () async => left(const LocalFailure(message: '디스크 부족'));
    _registerSeeder(seeder);

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, '추가'));
    await tester.pumpAndSettle();

    expect(find.textContaining('시드 실패'), findsOneWidget);
    expect(find.textContaining('디스크 부족'), findsOneWidget);
  });

  testWidgets('"삭제" 탭 → 확인 다이얼로그 → "취소" 누르면 clearAll 호출되지 않음', (tester) async {
    if (!kDebugMode) return;
    int clearCalls = 0;
    final seeder = _FakeMomentSeeder();
    seeder.onCount = () async => right(5);
    seeder.onClearAll = () async {
      clearCalls++;
      return right(unit);
    };
    _registerSeeder(seeder);

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, '삭제'));
    await tester.pumpAndSettle();

    // 확인 다이얼로그가 떠야 함 — 다이얼로그 내부에서만 검증.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('전체 데이터 삭제'),
      ),
      findsOneWidget,
    );
    expect(find.text('취소'), findsOneWidget);

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(clearCalls, 0);
  });

  testWidgets('"삭제" 탭 → 다이얼로그 "삭제" 확정 시 clearAll 호출 + 성공 메시지', (tester) async {
    if (!kDebugMode) return;
    int clearCalls = 0;
    final seeder = _FakeMomentSeeder();
    seeder.onCount = () async => right(5);
    seeder.onClearAll = () async {
      clearCalls++;
      return right(unit);
    };
    _registerSeeder(seeder);

    await tester.pumpWidget(_wrap(const DevToolsPage()));
    await tester.pumpAndSettle();

    // 화면의 "삭제" 액션 버튼 탭
    await tester.tap(find.widgetWithText(TextButton, '삭제').first);
    await tester.pumpAndSettle();

    // 다이얼로그 안의 "삭제" 확정 버튼 탭 — 마지막에 위치한 것이 다이얼로그 액션
    final confirmButtons = find.widgetWithText(TextButton, '삭제');
    await tester.tap(confirmButtons.last);
    await tester.pumpAndSettle();

    expect(clearCalls, 1);
    expect(find.textContaining('모든 데이터를 삭제'), findsOneWidget);
  });
}
