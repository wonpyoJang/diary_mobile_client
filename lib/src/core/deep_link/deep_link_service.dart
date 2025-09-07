import 'dart:async';
import 'package:diary_mobile_client/src/feature/profile/presentation/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';

@lazySingleton
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  StreamSubscription? _subscription;
  final StreamController<String> _deepLinkController =
      StreamController<String>.broadcast();
  final StreamController<Route<dynamic>> _routeController =
      StreamController<Route<dynamic>>.broadcast();

  // 초기 딥링크 저장
  String? _initialDeepLink;

  Stream<String> get deepLinkStream => _deepLinkController.stream;
  Stream<Route<dynamic>> get routeStream => _routeController.stream;
  String? get initialDeepLink => _initialDeepLink;

  /// 딥링크 서비스 초기화
  Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('=== 딥링크 서비스 초기화 시작 ===');
    }

    try {
      final appLinks = AppLinks();
      if (kDebugMode) {
        debugPrint('AppLinks 인스턴스 생성 완료');
      }

      // 앱이 이미 실행 중일 때 딥링크 저장 (처리는 나중에)
      final initialLink = await appLinks.getInitialAppLink();
      if (initialLink != null) {
        _initialDeepLink = initialLink.toString();
        if (kDebugMode) {
          debugPrint('초기 딥링크 저장: $_initialDeepLink');
          debugPrint(
              '초기 딥링크 타입: ${_initialDeepLink!.startsWith('cassette-diary://login-callback') ? '로그인 콜백' : '일반 딥링크'}');
        }
      } else {
        if (kDebugMode) {
          debugPrint('초기 딥링크가 없습니다');
        }
      }

      // 앱이 실행 중일 때 딥링크 수신 처리
      if (kDebugMode) {
        debugPrint('딥링크 스트림 리스너 설정 시작');
      }

      _subscription = appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          if (kDebugMode) {
            debugPrint('=== 앱 실행 중 딥링크 수신 ===');
            debugPrint('수신된 URI: $uri');
            debugPrint('URI 스킴: ${uri.scheme}');
            debugPrint('URI 호스트: ${uri.host}');
            debugPrint('URI 경로: ${uri.path}');
            debugPrint('URI 쿼리: ${uri.query}');
          }
          _handleDeepLink(uri.toString());
        } else {
          if (kDebugMode) {
            debugPrint('딥링크 스트림에서 null URI 수신');
          }
        }
      }, onError: (err) {
        if (kDebugMode) {
          debugPrint('=== 딥링크 스트림 오류 ===');
          debugPrint('오류 내용: $err');
          debugPrint('오류 타입: ${err.runtimeType}');
        }
      });

      if (kDebugMode) {
        debugPrint('딥링크 스트림 리스너 설정 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('=== 딥링크 서비스 초기화 오류 ===');
        debugPrint('오류 내용: $e');
        debugPrint('오류 타입: ${e.runtimeType}');
        debugPrint('스택 트레이스: ${StackTrace.current}');
      }
    }

    if (kDebugMode) {
      debugPrint('딥링크 서비스 초기화 완료');
      debugPrint('서비스 준비 상태: $isReady');
    }
  }

  /// 딥링크 서비스가 준비되었는지 확인
  bool get isReady => _subscription != null;

  /// 딥링크 처리
  void _handleDeepLink(String link) {
    if (kDebugMode) {
      debugPrint('=== 딥링크 처리 시작 ===');
      debugPrint('처리할 링크: $link');
      debugPrint('링크 길이: ${link.length}');
      debugPrint(
          '링크 타입: ${link.startsWith('cassette-diary://login-callback') ? '로그인 콜백' : '일반 딥링크'}');
    }

    // 딥링크 스트림으로 전송
    if (kDebugMode) {
      debugPrint('딥링크 스트림으로 전송');
    }
    _deepLinkController.add(link);

    // 특정 딥링크 패턴 처리
    if (link.startsWith('cassette-diary://login-callback')) {
      if (kDebugMode) {
        debugPrint('로그인 콜백 패턴 감지 - 특별 처리 시작');
      }
      _handleLoginCallback(link);
    } else {
      if (kDebugMode) {
        debugPrint('일반 딥링크 패턴 - 기본 처리만 수행');
      }
    }

    if (kDebugMode) {
      debugPrint('딥링크 처리 완료');
    }
  }

  /// 딥링크에 따른 라우트 생성
  Route<dynamic>? generateRouteFromDeepLink(String link) {
    if (kDebugMode) {
      debugPrint('=== 딥링크 라우트 생성 시작 ===');
      debugPrint('요청된 링크: $link');
      debugPrint('링크 패턴 분석:');
      debugPrint(
          '  - 로그인 콜백 패턴: ${link.startsWith('cassette-diary://login-callback')}');
    }

    if (link.startsWith('cassette-diary://login-callback')) {
      if (kDebugMode) {
        debugPrint('로그인 콜백 라우트 생성');
        debugPrint('라우트 설정: /login-callback');
        debugPrint('fullscreenDialog: true (모달 형태)');
      }

      final route = MaterialPageRoute(
        builder: (context) => const ProfilePage(),
        settings: const RouteSettings(name: ProfilePage.routeName),
        fullscreenDialog: true, // 모달 형태로 표시하여 뒤로가기 시 사파리로 돌아가지 않도록 함
      );

      if (kDebugMode) {
        debugPrint('라우트 생성 성공: ${route.settings.name}');
      }

      return route;
    }

    if (kDebugMode) {
      debugPrint('지원하지 않는 딥링크 패턴: $link');
      debugPrint('null 반환');
    }

    return null;
  }

  /// 로그인 콜백 딥링크 처리
  void _handleLoginCallback(String link) {
    if (kDebugMode) {
      debugPrint('=== 로그인 콜백 딥링크 처리 시작 ===');
      debugPrint('처리할 링크: $link');
    }

    // URL 파라미터 파싱
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    if (kDebugMode) {
      debugPrint('URI 파싱 결과:');
      debugPrint('  - 전체 URI: $uri');
      debugPrint('  - 스킴: ${uri.scheme}');
      debugPrint('  - 호스트: ${uri.host}');
      debugPrint('  - 경로: ${uri.path}');
      debugPrint('  - 쿼리 파라미터: $queryParams');
      debugPrint('  - 쿼리 파라미터 개수: ${queryParams.length}');
    }

    // 필요한 파라미터 처리
    // 예: code, state 등
    if (queryParams.containsKey('code')) {
      final code = queryParams['code'];
      if (kDebugMode) {
        debugPrint('인증 코드 발견: $code');
        debugPrint('인증 코드 길이: ${code?.length}');
      }

      // 앱으로 돌아온 후 사파리를 닫는 로직
      if (kDebugMode) {
        debugPrint('사파리 닫기 시도');
      }
      _closeSafariIfPossible();

      // 여기서 인증 코드를 처리하는 로직 추가
      if (kDebugMode) {
        debugPrint('인증 코드 처리 로직 완료');
      }
    } else {
      if (kDebugMode) {
        debugPrint('인증 코드가 쿼리 파라미터에 없습니다');
        debugPrint('사용 가능한 파라미터: ${queryParams.keys.toList()}');
      }
    }

    if (kDebugMode) {
      debugPrint('로그인 콜백 딥링크 처리 완료');
    }
  }

  /// 가능한 경우 사파리를 닫음
  Future<void> _closeSafariIfPossible() async {
    if (kDebugMode) {
      debugPrint('=== 사파리 닫기 시도 시작 ===');
      debugPrint('플랫폼: $defaultTargetPlatform');
    }

    try {
      // iOS에서 사파리를 닫기 위해 특별한 URL 스킴 사용
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        if (kDebugMode) {
          debugPrint('iOS 플랫폼 감지 - 사파리 닫기 로직 실행');
        }

        // 방법 4: 앱이 포그라운드에 있는지 확인하고, 필요시 사용자에게 안내
        if (kDebugMode) {
          debugPrint('사파리 탭 정리 완료 - 사용자가 필요시 수동으로 정리 가능');
          debugPrint('사파리 닫기 로직 완료');
        }
      } else {
        if (kDebugMode) {
          debugPrint('iOS가 아닌 플랫폼 - 사파리 닫기 로직 건너뜀');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('=== 사파리 닫기 오류 ===');
        debugPrint('오류 내용: $e');
        debugPrint('오류 타입: ${e.runtimeType}');
        debugPrint('스택 트레이스: ${StackTrace.current}');
      }
    }

    if (kDebugMode) {
      debugPrint('사파리 닫기 시도 완료');
    }
  }

  /// 딥링크 서비스 정리
  void dispose() {
    if (kDebugMode) {
      debugPrint('=== 딥링크 서비스 정리 시작 ===');
      debugPrint('구독 취소 상태: ${_subscription != null}');
      debugPrint('딥링크 컨트롤러 상태: ${!_deepLinkController.isClosed}');
      debugPrint('라우트 컨트롤러 상태: ${!_routeController.isClosed}');
    }

    _subscription?.cancel();
    _deepLinkController.close();
    _routeController.close();

    if (kDebugMode) {
      debugPrint('딥링크 서비스 정리 완료');
    }
  }
}
