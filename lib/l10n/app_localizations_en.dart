// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crepas Emotion Diary';

  @override
  String get myMemories => 'My Memories';

  @override
  String get registerNewDiary => 'Register a new diary!';

  @override
  String get imageLoadError => 'Cannot load image';

  @override
  String get shareFeaturePreparing => 'Share feature is preparing';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get notification => 'Notification';

  @override
  String get confirm => 'Confirm';

  @override
  String get download => 'Download';

  @override
  String get noEmotion => 'No emotion detected.';

  @override
  String get writeAtLeast20 => 'Please write at least 20 characters in your diary.';

  @override
  String get pleaseWait => 'Please wait a moment. Analyzing...';

  @override
  String get todayEmotion => 'Today\'s Emotion';

  @override
  String get isThisAnalysisCorrect => 'Is this analysis correct?';

  @override
  String get notMatch => 'No 👎';

  @override
  String get match => 'Yes 👍';

  @override
  String get extractingEmotion => 'Extracting emotion';

  @override
  String get settings => 'Settings';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get lab => 'Lab';

  @override
  String get calendarMode => 'Calendar Mode';

  @override
  String get addDiary => 'Add Diary';
}
