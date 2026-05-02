import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 백업 결과를 사용자에게 로컬 알림으로 알려주는 래퍼.
///
/// 채널 ID: `crepas_backup`
@LazySingleton()
class BackupNotifier {
  static const String _channelId = 'crepas_backup';
  static const String _channelName = '백업 알림';
  static const String _channelDescription = '자동 백업 성공/실패를 알려주는 알림';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// 알림 플러그인을 초기화한다. 앱 시작 시 한 번만 호출하면 된다.
  ///
  /// - timezone DB 로드 + Asia/Seoul (또는 device timezone)으로 setLocalLocation
  /// - iOS/Android 권한 요청
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      tzdata.initializeTimeZones();
      // 한국 표준시를 기본 로컬 타임존으로 설정한다.
      // (디바이스 타임존을 가져오는 별도 패키지를 추가하지 않기 위해
      //  본 앱의 주요 사용처인 Asia/Seoul로 고정한다.)
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
      } catch (_) {
        // 위치 설정 실패 시에도 기본 UTC로 동작하도록 무시.
      }

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      );

      await _plugin.initialize(initSettings);

      // iOS 권한 요청 (initialize 시 옵션과 더불어 명시 호출)
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Android 13+ POST_NOTIFICATIONS 권한 요청
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();

      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('BackupNotifier 초기화 실패: $e');
      }
    }
  }

  /// 자동 백업 성공 알림.
  Future<void> notifyBackupSuccess(DateTime at) async {
    final formatted = DateFormat('yyyy년 MM월 dd일 HH:mm').format(at.toLocal());
    await _show(
      title: '백업 완료',
      body: '$formatted 자동 백업이 성공했습니다',
      id: 1001,
    );
  }

  /// 자동 백업 실패 알림.
  Future<void> notifyBackupFailed(String reason) async {
    await _show(
      title: '백업 실패',
      body: reason,
      id: 1002,
    );
  }

  Future<void> _show({
    required String title,
    required String body,
    required int id,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    try {
      await _plugin.show(id, title, body, details);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('BackupNotifier 알림 표시 실패: $e');
      }
    }
  }
}
