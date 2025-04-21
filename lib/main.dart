import 'dart:convert';

import 'package:diary_mobile_client/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/injection.dart';
import 'src/feature/settings/settings_controller.dart';
import 'src/feature/settings/settings_service.dart';

import 'src/app.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
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
      WidgetsFlutterBinding.ensureInitialized();
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

      await configureDependencies();

      // Set up the SettingsController, which will glue user settings to multiple
      // Flutter Widgets.
      final settingsController = SettingsController(SettingsService());

      // Load the user's preferred theme while the splash screen is displayed.
      // This prevents a sudden theme change when the app is first displayed.
      await settingsController.loadSettings();

      // Run the app and pass in the SettingsController. The app listens to the
      // SettingsController for changes, then passes it further down to the
      // SettingsView.
      runApp(MyApp(settingsController: settingsController));
    },
  );
}
