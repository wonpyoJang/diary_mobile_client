import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'deep_link_service.dart';

// 딥링크 상태 정의
abstract class DeepLinkState extends Equatable {
  const DeepLinkState();

  @override
  List<Object?> get props => [];
}

// 초기 상태
class DeepLinkInitial extends DeepLinkState {}

// Navigator가 준비된 상태
class DeepLinkNavigatorReady extends DeepLinkState {
  const DeepLinkNavigatorReady();
}

// 딥링크 수신 상태
class DeepLinkReceived extends DeepLinkState {
  final String link;
  final DateTime timestamp;

  const DeepLinkReceived(this.link, this.timestamp);

  @override
  List<Object?> get props => [link, timestamp];
}

// 로그인 콜백 처리 상태
class LoginCallbackReceived extends DeepLinkState {
  final String code;
  final String? state;
  final DateTime timestamp;
  final bool isFromBackground; // 백그라운드에서 온 딥링크인지 여부

  const LoginCallbackReceived(this.code, this.state, this.timestamp,
      {this.isFromBackground = false});

  @override
  List<Object?> get props => [code, state, timestamp, isFromBackground];
}

// 딥링크 오류 상태
class DeepLinkError extends DeepLinkState {
  final String error;
  final DateTime timestamp;

  const DeepLinkError(this.error, this.timestamp);

  @override
  List<Object?> get props => [error, timestamp];
}

@injectable
class DeepLinkCubit extends Cubit<DeepLinkState> {
  final DeepLinkService _deepLinkService;
  StreamSubscription? _subscription;

  DeepLinkCubit(this._deepLinkService) : super(DeepLinkInitial()) {
    _initializeDeepLinkListener();
  }

  void _initializeDeepLinkListener() {
    if (kDebugMode) {
      debugPrint('=== 딥링크 리스너 초기화 시작 ===');
    }

    // 초기 딥링크는 Navigator가 준비된 후에 처리하도록 지연
    _subscription = _deepLinkService.deepLinkStream.listen(
      (link) {
        if (kDebugMode) {
          debugPrint('=== 딥링크 스트림에서 수신 ===');
          debugPrint('수신된 링크: $link');
          debugPrint(
              '링크 타입: ${link.startsWith('cassette-diary://login-callback') ? '로그인 콜백' : '일반 딥링크'}');
        }

        if (link.startsWith('cassette-diary://login-callback')) {
          if (kDebugMode) {
            debugPrint('로그인 콜백 딥링크 처리 시작');
          }
          _handleLoginCallback(link, isFromBackground: false);
        } else {
          if (kDebugMode) {
            debugPrint('일반 딥링크 상태로 전환');
          }
          emit(DeepLinkReceived(link, DateTime.now()));
        }
      },
      onError: (error) {
        if (kDebugMode) {
          debugPrint('=== 딥링크 스트림 오류 ===');
          debugPrint('오류 내용: $error');
          debugPrint('오류 타입: ${error.runtimeType}');
        }
        emit(DeepLinkError(error.toString(), DateTime.now()));
      },
    );

    if (kDebugMode) {
      debugPrint('딥링크 리스너 초기화 완료');
    }
  }

  /// 초기 딥링크 처리 (Navigator가 준비된 후 호출)
  void processInitialDeepLink() {
    if (kDebugMode) {
      debugPrint('=== 초기 딥링크 처리 시작 ===');
      debugPrint('초기 딥링크 존재 여부: ${_deepLinkService.initialDeepLink != null}');
    }

    final initialDeepLink = _deepLinkService.initialDeepLink;
    if (initialDeepLink != null) {
      if (kDebugMode) {
        debugPrint('초기 딥링크 처리: $initialDeepLink');
        debugPrint(
            '딥링크 타입: ${initialDeepLink.startsWith('cassette-diary://login-callback') ? '로그인 콜백' : '일반 딥링크'}');
      }

      if (initialDeepLink.startsWith('cassette-diary://login-callback')) {
        if (kDebugMode) {
          debugPrint('백그라운드에서 온 로그인 콜백 처리');
        }
        _handleLoginCallback(initialDeepLink, isFromBackground: true);
      } else {
        if (kDebugMode) {
          debugPrint('백그라운드에서 온 일반 딥링크 처리');
        }
        emit(DeepLinkReceived(initialDeepLink, DateTime.now()));
      }
    } else {
      if (kDebugMode) {
        debugPrint('초기 딥링크가 없습니다');
      }
    }
  }

  void _handleLoginCallback(String link, {bool isFromBackground = false}) {
    if (kDebugMode) {
      debugPrint('=== 로그인 콜백 처리 시작 ===');
      debugPrint('링크: $link');
      debugPrint('백그라운드에서 온 것: $isFromBackground');
    }

    try {
      final uri = Uri.parse(link);
      final queryParams = uri.queryParameters;

      if (kDebugMode) {
        debugPrint('URI 파싱 결과:');
        debugPrint('  - 전체 URI: $uri');
        debugPrint('  - 쿼리 파라미터: $queryParams');
      }

      final code = queryParams['code'];
      final state = queryParams['state'];

      if (kDebugMode) {
        debugPrint('파싱된 파라미터:');
        debugPrint('  - code: $code');
        debugPrint('  - state: $state');
      }

      if (code != null) {
        if (kDebugMode) {
          debugPrint('로그인 콜백 상태로 전환');
        }
        emit(LoginCallbackReceived(code, state, DateTime.now(),
            isFromBackground: isFromBackground));

        if (kDebugMode) {
          debugPrint(
              '로그인 콜백 처리: code=$code, isFromBackground=$isFromBackground');
        }
      } else {
        if (kDebugMode) {
          debugPrint('인증 코드가 없어 오류 상태로 전환');
        }
        emit(DeepLinkError('인증 코드가 없습니다', DateTime.now()));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('로그인 콜백 파싱 중 오류 발생: $e');
        debugPrint('오류 타입: ${e.runtimeType}');
      }
      emit(DeepLinkError('로그인 콜백 파싱 오류: $e', DateTime.now()));
    }
  }

  /// Navigator가 준비되었음을 알림
  void notifyNavigatorReady() {
    if (kDebugMode) {
      debugPrint('=== Navigator 준비 완료 알림 ===');
    }
    emit(const DeepLinkNavigatorReady());
  }

  /// 딥링크에 따른 라우트 생성
  Route<dynamic>? generateRouteFromDeepLink(String link) {
    if (kDebugMode) {
      debugPrint('=== 딥링크 라우트 생성 시작 ===');
      debugPrint('링크: $link');
    }

    final route = _deepLinkService.generateRouteFromDeepLink(link);

    if (kDebugMode) {
      if (route != null) {
        debugPrint('라우트 생성 성공: ${route.settings.name}');
        debugPrint('라우트 설정: ${route.settings}');
      } else {
        debugPrint('라우트 생성 실패: 지원하지 않는 딥링크 패턴');
      }
    }

    return route;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
