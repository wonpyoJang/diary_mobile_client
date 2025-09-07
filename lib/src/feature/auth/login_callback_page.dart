import 'package:diary_mobile_client/src/feature/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diary_mobile_client/src/core/deep_link/deep_link_cubit.dart';
import 'package:flutter/foundation.dart';

class LoginCallbackPage extends StatelessWidget {
  static const routeName = '/login-callback';

  const LoginCallbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('=== 로그인 콜백 페이지 빌드 ===');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 처리 중'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
      ),
      body: BlocListener<DeepLinkCubit, DeepLinkState>(
        listener: (context, state) {
          if (kDebugMode) {
            debugPrint('=== DeepLinkCubit 상태 변경 감지 ===');
            debugPrint('새로운 상태: ${state.runtimeType}');
            debugPrint('상태 내용: $state');
          }

          if (state is LoginCallbackReceived) {
            if (kDebugMode) {
              debugPrint('로그인 콜백 수신 상태 감지');
            }
            _handleLoginSuccess(context, state);
          } else if (state is DeepLinkError) {
            if (kDebugMode) {
              debugPrint('딥링크 오류 상태 감지');
            }
            _handleLoginError(context, state);
          } else {
            if (kDebugMode) {
              debugPrint('기타 상태: ${state.runtimeType}');
            }
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                '로그인 처리 중...',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '잠시만 기다려주세요',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLoginSuccess(BuildContext context, LoginCallbackReceived state) {
    if (kDebugMode) {
      debugPrint('=== 로그인 성공 처리 시작 ===');
      debugPrint('상태 정보:');
      debugPrint('  - 코드: ${state.code}');
      debugPrint('  - 상태: ${state.state}');
      debugPrint('  - 타임스탬프: ${state.timestamp}');
      debugPrint('  - 백그라운드에서 온 것: ${state.isFromBackground}');
    }

    // 백그라운드에서 온 딥링크인 경우 즉시 처리
    if (state.isFromBackground) {
      if (kDebugMode) {
        debugPrint('백그라운드에서 온 로그인 콜백 처리');
        debugPrint('즉시 홈 화면으로 이동');
      }

      // 즉시 홈 화면으로 이동
      if (context.mounted) {
        Navigator.of(context).popAndPushNamed(ProfilePage.routeName);
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('포그라운드에서 온 로그인 콜백 처리');
      debugPrint('사용자에게 피드백 제공 후 홈 화면으로 이동');
    }

    // 포그라운드에서 온 딥링크인 경우 사용자에게 피드백 제공
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('로그인 성공! 잠시 후 홈 화면으로 이동합니다.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '웹뷰 정리 안내',
          textColor: Colors.white,
          onPressed: () {
            if (kDebugMode) {
              debugPrint('웹뷰 정리 안내 버튼 클릭');
            }
            _showWebViewCleanupGuide(context);
          },
        ),
      ),
    );
  }

  void _handleLoginError(BuildContext context, DeepLinkError state) {
    if (kDebugMode) {
      debugPrint('=== 로그인 오류 처리 시작 ===');
      debugPrint('오류 정보:');
      debugPrint('  - 오류 메시지: ${state.error}');
      debugPrint('  - 타임스탬프: ${state.timestamp}');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('로그인 오류: ${state.error}'),
        backgroundColor: Colors.red,
      ),
    );

    if (kDebugMode) {
      debugPrint('2초 후 로그인 화면으로 이동');
    }

    // 잠시 후 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        if (kDebugMode) {
          debugPrint('로그인 화면으로 이동 실행');
        }
        Navigator.of(context).pushReplacementNamed('/signin');
      }
    });
  }

  /// 웹뷰 정리 안내 다이얼로그 표시
  void _showWebViewCleanupGuide(BuildContext context) {
    if (kDebugMode) {
      debugPrint('=== 웹뷰 정리 안내 다이얼로그 표시 ===');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('웹뷰 정리 안내'),
        content: const Text(
          '로그인 완료 후 인앱 사파리가 백그라운드에 남아있을 수 있습니다.\n\n'
          '• iOS에서는 자동으로 정리되지만, 필요시 수동으로 정리할 수 있습니다\n'
          '• 앱 전환기에서 사파리 탭을 위로 스와이프하여 닫을 수 있습니다\n'
          '• 이는 정상적인 동작이며 앱 기능에는 영향을 주지 않습니다',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (kDebugMode) {
                debugPrint('웹뷰 정리 안내 다이얼로그 닫기');
              }
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
