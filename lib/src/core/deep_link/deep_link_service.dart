import 'dart:async';
import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/core/home_widget/diary_home_widget_sync.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/interface/i_write_moment_repository.dart';
import 'package:diary_mobile_client/src/feature/profile/presentation/profile_page.dart';
import 'package:diary_mobile_client/src/feature/signin/application/messages.dart';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class DeepLinkService {
  DeepLinkService(
    this._writeMomentRepository,
    this._homeWidgetSync,
    this._bus,
  );

  final IWriteMomentRepository _writeMomentRepository;
  final DiaryHomeWidgetSync _homeWidgetSync;
  final Bus _bus;

  StreamSubscription? _subscription;
  final StreamController<String> _deepLinkController =
      StreamController<String>.broadcast();
  final StreamController<Route<dynamic>> _routeController =
      StreamController<Route<dynamic>>.broadcast();

  String? _initialDeepLink;

  Stream<String> get deepLinkStream => _deepLinkController.stream;
  Stream<Route<dynamic>> get routeStream => _routeController.stream;
  String? get initialDeepLink => _initialDeepLink;

  bool _isWidgetQuickEmotion(Uri uri) {
    return uri.scheme == 'cassette-diary' &&
        uri.host == 'widget' &&
        uri.path == '/quick-emotion';
  }

  Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('=== 딥링크 서비스 초기화 시작 ===');
    }

    try {
      final appLinks = AppLinks();

      final initialLink = await appLinks.getInitialAppLink();
      if (initialLink != null) {
        final uri = initialLink;
        if (_isWidgetQuickEmotion(uri)) {
          if (kDebugMode) {
            debugPrint('초기 딥링크: 위젯 빠른 감정 → 저장 후 스트림 생략');
          }
          await _handleWidgetQuickEmotionUri(uri);
          _initialDeepLink = null;
        } else {
          _initialDeepLink = uri.toString();
          if (kDebugMode) {
            debugPrint('초기 딥링크 저장: $_initialDeepLink');
          }
        }
      }

      _subscription = appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          if (kDebugMode) {
            debugPrint('=== 앱 실행 중 딥링크 수신 === $uri');
          }
          _handleDeepLink(uri.toString());
        }
      }, onError: (err) {
        if (kDebugMode) {
          debugPrint('딥링크 스트림 오류: $err');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('딥링크 서비스 초기화 오류: $e');
      }
    }

    if (kDebugMode) {
      debugPrint('딥링크 서비스 초기화 완료 (ready: $isReady)');
    }
  }

  bool get isReady => _subscription != null;

  Future<void> _handleWidgetQuickEmotionUri(Uri uri) async {
    final name = uri.queryParameters['emotion'];
    if (name == null) return;

    try {
      final emotion = Emotion.findByName(name);
      final now = DateTime.now();
      final day = DateTime(now.year, now.month, now.day);
      final moment = Moment.create(reflection: '', date: day).copyWith(
        modifiedAt: now,
        emotionalIntensities: [
          EmotionalIntensity(emotion: emotion, intensity: 1.0),
        ],
      );

      final result = await _writeMomentRepository.saveMoment(moment);
      result.fold(
        (failure) {
          if (kDebugMode) {
            debugPrint('위젯 빠른 저장 실패: ${failure.message}');
          }
        },
        (_) {
          _bus.publish(MomentCreatedMessage(moment: moment, date: day));
          unawaited(_homeWidgetSync.refresh());
        },
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('위젯 빠른 감정 처리 오류: $e\n$st');
      }
    }
  }

  void _handleDeepLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri != null && _isWidgetQuickEmotion(uri)) {
      unawaited(_handleWidgetQuickEmotionUri(uri));
      return;
    }

    if (kDebugMode) {
      debugPrint('딥링크 스트림으로 전송: $link');
    }
    _deepLinkController.add(link);

    if (link.startsWith('cassette-diary://login-callback')) {
      unawaited(_handleLoginCallback(link));
    }
  }

  Route<dynamic>? generateRouteFromDeepLink(String link) {
    if (link.startsWith('cassette-diary://login-callback')) {
      return MaterialPageRoute(
        builder: (context) => const ProfilePage(),
        settings: const RouteSettings(name: ProfilePage.routeName),
        fullscreenDialog: true,
      );
    }
    return null;
  }

  Future<void> _handleLoginCallback(String link) async {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    if (queryParams.containsKey('code')) {
      _closeSafariIfPossible();

      try {
        final supabase = Supabase.instance.client;
        final response = await supabase.auth.getSessionFromUrl(uri);
        final session = response.session;
        if (kDebugMode) {
          debugPrint('세션 복구 성공: ${session.user.email}');
        }
        _bus.publish(SignInSuccessMessage());
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('세션 복구 실패: $e\n$st');
        }
      }
    }
  }

  Future<void> _closeSafariIfPossible() async {
    if (defaultTargetPlatform == TargetPlatform.iOS && kDebugMode) {
      debugPrint('iOS 딥링크 복귀 (Safari 수동 정리 가능)');
    }
  }

  void dispose() {
    _subscription?.cancel();
    _deepLinkController.close();
    _routeController.close();
  }
}
