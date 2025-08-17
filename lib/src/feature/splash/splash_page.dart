import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/presentation/moment_calendar_page.dart';
import 'package:diary_mobile_client/src/core/deep_link/deep_link_cubit.dart';
import 'package:diary_mobile_client/src/feature/auth/login_callback_page.dart';
import 'package:diary_mobile_client/src/feature/signin/presentation/signin_page.dart';
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter/foundation.dart';
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

    // Navigator가 준비되었음을 알림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DeepLinkCubit>().notifyNavigatorReady();
      }
    });

    Timer(const Duration(seconds: 3), () {
      if (context.read<LockCubit>().state.isLockEnabled == true) {
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
            if (state.status == LockStatus.unlocked) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MomentCalendarPage()));
            }
          },
        ),
        BlocListener<DeepLinkCubit, DeepLinkState>(
          listener: (context, state) {
            if (state is DeepLinkNavigatorReady) {
              // Navigator가 준비됨 - 초기 딥링크 처리
              if (kDebugMode) {
                debugPrint('Navigator 준비됨 - 초기 딥링크 처리 시작');
              }
              // 초기 딥링크가 있다면 처리
              context.read<DeepLinkCubit>().processInitialDeepLink();
            } else if (state is LoginCallbackReceived) {
              // 로그인 콜백 처리
              if (kDebugMode) {
                debugPrint('로그인 콜백 수신: ${state.code}');
              }
              // 로그인 콜백 페이지로 이동
              Navigator.of(context)
                  .pushReplacementNamed(LoginCallbackPage.routeName);
            } else if (state is DeepLinkError) {
              if (kDebugMode) {
                debugPrint('딥링크 오류: ${state.error}');
              }
              // 오류 발생 시 로그인 페이지로 이동
              Navigator.of(context).pushReplacementNamed(SignInPage.routeName);
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
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 64, color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        "Emotion Diary",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (kDebugMode)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/deep-link-test');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                          ),
                          child: const Text('딥링크 테스트'),
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
