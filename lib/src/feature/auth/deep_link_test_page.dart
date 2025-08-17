import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepLinkTestPage extends StatelessWidget {
  static const routeName = '/deep-link-test';

  const DeepLinkTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('=== 딥링크 테스트 페이지 빌드 ===');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('딥링크 테스트'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '딥링크 테스트',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '아래 버튼을 눌러 딥링크가 제대로 작동하는지 테스트해보세요.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _testDeepLink(context,
                  'cassette-diary://login-callback?code=test123&state=test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '로그인 콜백 딥링크 테스트',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _testDeepLink(context,
                  'cassette-diary://login-callback?code=success456&state=success'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '성공 케이스 테스트',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _testDeepLink(context, 'cassette-diary://login-callback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '파라미터 없는 딥링크 테스트',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              '테스트 결과는 콘솔에서 확인할 수 있습니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testDeepLink(BuildContext context, String url) async {
    if (kDebugMode) {
      debugPrint('=== 딥링크 테스트 시작 ===');
      debugPrint('테스트할 URL: $url');
    }

    try {
      final uri = Uri.parse(url);
      if (kDebugMode) {
        debugPrint('URI 파싱 결과:');
        debugPrint('  - 전체 URI: $uri');
        debugPrint('  - 스킴: ${uri.scheme}');
        debugPrint('  - 호스트: ${uri.host}');
        debugPrint('  - 경로: ${uri.path}');
        debugPrint('  - 쿼리: ${uri.query}');
        debugPrint('  - 쿼리 파라미터: ${uri.queryParameters}');
      }

      if (await canLaunchUrl(uri)) {
        if (kDebugMode) {
          debugPrint('딥링크 실행 가능 - launchUrl 호출');
        }

        await launchUrl(uri);

        if (kDebugMode) {
          debugPrint('딥링크 실행 완료');
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('딥링크 실행: $url'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        if (kDebugMode) {
          debugPrint('딥링크 실행 불가능');
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('딥링크를 실행할 수 없습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('=== 딥링크 테스트 오류 ===');
        debugPrint('오류 내용: $e');
        debugPrint('오류 타입: ${e.runtimeType}');
        debugPrint('스택 트레이스: ${StackTrace.current}');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('딥링크 실행 오류: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (kDebugMode) {
      debugPrint('딥링크 테스트 완료');
    }
  }
}
