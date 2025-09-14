import 'dart:convert';

import 'package:diary_mobile_client/firebase_options.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/injection.dart';
import 'src/feature/settings/settings_controller.dart';
import 'src/database/app_database.dart';

import 'src/app.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qnpolyxygqnismrzvklz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFucG9seXh5Z3FuaXNtcnp2a2x6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU0MzAzNzIsImV4cCI6MjA3MTAwNjM3Mn0.1qmqNbZmxhmRa5AJ-b6D7OmuUXuXSWyNnL8c9VmKJwo',
  );

  // 의존성 주입 설정
  await configureDependencies();

  await getIt<HiveClient>().initialize();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0fe47ef991f8086b23902a62d982e3f2@o4508755775848448.ingest.us.sentry.io/4508755779584000';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions   for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      const password = 'xxeozn';
      final byteskey = sha256.convert(utf8.encode(password)).bytes;

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory(
                (await getApplicationDocumentsDirectory()).path),
        encryptionCipher: HydratedAesCipher(byteskey),
      );

      // 데이터베이스 인스턴스 가져오기 (의존성 주입 후)
      final database = getIt<Database>();
      logger.i('데이터베이스가 초기화되었습니다.');

      // 앱이 종료될 때 데이터베이스를 닫도록 설정
      WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(
          detachedCallBack: () async {
            try {
              await database.close();
              logger.i('데이터베이스가 종료되었습니다.');
            } catch (e) {
              logger.e('데이터베이스 종료 중 오류 발생: $e');
            }
          },
        ),
      );

      // Load the user's preferred theme while the splash screen is displayed.
      // This prevents a sudden theme change when the app is first displayed.
      await getIt<SettingsController>().loadSettings();

      // Run the app and pass in the SettingsController. The app listens to the
      // SettingsController for changes, then passes it further down to the
      // SettingsView.
      runApp(const MyApp());
    },
  );
}

// 앱 생명주기 이벤트를 처리하는 클래스
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detachedCallBack;

  LifecycleEventHandler({
    this.detachedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        if (detachedCallBack != null) {
          await detachedCallBack!();
        }
        break;
      default:
        break;
    }
  }
}
