import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:diary_mobile_client/firebase_options.dart';
import 'package:diary_mobile_client/src/app.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:diary_mobile_client/src/feature/dev_tools/presentation/dev_tools_page.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/presentation/emotion_statistics_page.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/backup_page.dart';
import 'package:diary_mobile_client/src/feature/settings/settings_controller.dart';
import 'package:diary_mobile_client/src/feature/settings/settings_view.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  await getIt<HiveClient>().initialize();

  const password = 'xxeozn';
  final byteskey = sha256.convert(utf8.encode(password)).bytes;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
    encryptionCipher: HydratedAesCipher(byteskey),
  );
  await HydratedBloc.storage.clear();

  await getIt<SettingsController>().loadSettings();

  debugPrint('[backup_and_stats_e2e] bootstrap complete');
}

Future<void> _settleAfterSplash(WidgetTester tester) async {
  // 스플래시 ~3초 + 여유. screenshot_test.dart 와 동일 패턴.
  await tester.pump();
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _bootstrap();
  });

  testWidgets('e2e_01_settings_navigation', (tester) async {
    await tester.pumpWidget(const MyApp());
    await _settleAfterSplash(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pushNamed(SettingsView.routeName);
    await _settleAfterSplash(tester);

    expect(find.text('백업 설정'), findsOneWidget);
  });

  testWidgets('e2e_02_emotion_statistics_page', (tester) async {
    await tester.pumpWidget(const MyApp());
    await _settleAfterSplash(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pushNamed(EmotionStatisticsPage.routeName);

    // 페이지가 마운트되고 BlocBuilder 가 첫 프레임을 그릴 때까지 충분히 대기.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }

    expect(find.text('감정 통계'), findsOneWidget);

    // 데이터 유무에 따라 결과가 달라지므로 OR 검증.
    final hasContent = find.text('감정 분포').evaluate().isNotEmpty;
    final hasEmpty =
        find.textContaining('아직 작성된 일기가 없어요').evaluate().isNotEmpty;
    final hasLoading =
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    expect(hasContent || hasEmpty || hasLoading, isTrue);
  });

  testWidgets('e2e_03_dev_tools_page', (tester) async {
    if (!kDebugMode) return; // release 빌드에서는 의미 없음.
    await tester.pumpWidget(const MyApp());
    await _settleAfterSplash(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pushNamed(DevToolsPage.routeName);
    await _settleAfterSplash(tester);

    expect(find.text('개발자 도구'), findsOneWidget);
    expect(find.text('더미 일기 100편 추가'), findsOneWidget);
    expect(find.text('전체 데이터 삭제'), findsOneWidget);
  });

  testWidgets('e2e_04_backup_page', (tester) async {
    await tester.pumpWidget(const MyApp());
    await _settleAfterSplash(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.push(MaterialPageRoute<void>(
      builder: (_) => const BackupPage(),
    ));
    await _settleAfterSplash(tester);

    // BackupPage 자체가 렌더되는지만 확인. 실제 백업/복원/스케줄 액션은
    // 시스템 권한이 필요해 e2e 에서 호출하지 않는다.
    final backupPageFinder = find.byType(BackupPage);
    expect(backupPageFinder, findsOneWidget);
  });

  testWidgets('e2e_05_clear_backup_message_safe', (tester) async {
    // ClearBackupMessage 는 비파괴적 — 로컬 상태만 초기화.
    await tester.pumpWidget(const MyApp());
    await _settleAfterSplash(tester);

    final bloc = getIt<BackupBloc>();
    bloc.add(ClearBackupMessage());
    await tester.pump(const Duration(milliseconds: 200));

    expect(bloc.state.failure, isNull);
    expect(bloc.state.successMessage, isNull);
  });
}
