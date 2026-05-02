import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';

/// 홈 화면 위젯(home_widget)용 상수. iOS App Group / UserDefaults 키와 맞춘다.
abstract final class DiaryHomeWidgetConfig {
  /// Runner·위젯 익스텐션에 동일한 App Group을 넣어야 Flutter ↔ 위젯 데이터가 공유된다.
  static const String iOSAppGroupId = 'group.com.crepas.diary';

  static const String dataKeyStreak = 'crepas_streak';
  static const String dataKeyToday = 'crepas_today';
  static const String dataKeyWeek = 'crepas_week_json';

  /// 위젯에서 탭 시 열 딥링크 (빠른 감정 기록).
  static String quickEmotionUrl(Emotion e) =>
      'cassette-diary://widget/quick-emotion?emotion=${e.name}';

  /// 빠른 기록에 쓰는 감정 6종 (이슈: 4~6개).
  static const List<Emotion> quickEmotions = [
    Emotion.happiness,
    Emotion.calmness,
    Emotion.sadness,
    Emotion.anger,
    Emotion.warmth,
    Emotion.hope,
  ];
}
