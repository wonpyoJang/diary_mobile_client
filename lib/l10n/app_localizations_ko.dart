// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '크레파스 감정일기';

  @override
  String get myMemories => '나의 기억들';

  @override
  String get registerNewDiary => '새로운 일기를 등록해보세요!';

  @override
  String get imageLoadError => '이미지를 불러올 수 없습니다';

  @override
  String get shareFeaturePreparing => '공유 기능은 준비 중입니다';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get notification => '알림';

  @override
  String get confirm => '확인';

  @override
  String get download => '다운로드';

  @override
  String get noEmotion => '드러난 감정이 없습니다.';

  @override
  String get writeAtLeast20 => '일기를 20자 이상 작성해주세요';

  @override
  String get pleaseWait => '조금만 기다려주세요. 분석중입니다.';

  @override
  String get todayEmotion => '오늘의 감정';

  @override
  String get isThisAnalysisCorrect => '이 분석이 맞나요?';

  @override
  String get notMatch => '달라요 👎';

  @override
  String get match => '맞아요 👍';

  @override
  String get extractingEmotion => '감정 추출 중';

  @override
  String get settings => 'Settings';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get lab => '실험실';

  @override
  String get calendarMode => '캘린더 모드';

  @override
  String get addDiary => '일기 추가하기';
}
