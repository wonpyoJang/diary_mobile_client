import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/presentation/moment_calendar_page.dart';
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_bloc/flutter_bloc.dart';
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
      if ((context.read<LockCubit>().state is LockUnlocked) == false) {
        context.read<LockCubit>().authenticate();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MomentCalendarPage()));
      }
      AnalyticsManager.logEvent('splash_ended');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LockCubit, LockState>(
          listener: (context, state) {
            if (state is LockUnlocked) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MomentCalendarPage()));
            }
          },
        ),
      ],
      child: Material(
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
      ),
    );
  }
}
