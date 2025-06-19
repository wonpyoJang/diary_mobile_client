import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/presentation/moment_calendar_page.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/presentation/moment_list_page.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.logEvent('splash_viewed');
    Timer(const Duration(seconds: 3), () {
      final settingsBloc = getIt<SettingsBloc>();

      if (settingsBloc.state.isCalendarMode) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MomentCalendarPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MomentListPage()));
      }
      AnalyticsManager.logEvent('splash_ended');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, double opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFBE7DC), Color(0xFFCCE3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 64, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      "Emotion Diary",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
