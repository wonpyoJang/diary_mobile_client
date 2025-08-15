import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// Write a diary and check your emotions.
  ///
  /// In en, this message translates to:
  /// **'Crepas Emotion Diary'**
  String get appTitle;

  /// Main screen top title
  ///
  /// In en, this message translates to:
  /// **'My Memories'**
  String get myMemories;

  /// Guide message when there is no diary
  ///
  /// In en, this message translates to:
  /// **'Register a new diary!'**
  String get registerNewDiary;

  /// Message when image fails to load
  ///
  /// In en, this message translates to:
  /// **'Cannot load image'**
  String get imageLoadError;

  /// Notice for share feature preparing
  ///
  /// In en, this message translates to:
  /// **'Share feature is preparing'**
  String get shareFeaturePreparing;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Notification dialog title
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No emotion analysis result guide
  ///
  /// In en, this message translates to:
  /// **'No emotion detected.'**
  String get noEmotion;

  /// Guide when less than 20 characters are written
  ///
  /// In en, this message translates to:
  /// **'Please write at least 20 characters in your diary.'**
  String get writeAtLeast20;

  /// Analyzing guide
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment. Analyzing...'**
  String get pleaseWait;

  /// Today's emotion dialog title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Emotion'**
  String get todayEmotion;

  /// Analysis result confirmation question
  ///
  /// In en, this message translates to:
  /// **'Is this analysis correct?'**
  String get isThisAnalysisCorrect;

  /// Analysis result not match option
  ///
  /// In en, this message translates to:
  /// **'No 👎'**
  String get notMatch;

  /// Analysis result match option
  ///
  /// In en, this message translates to:
  /// **'Yes 👍'**
  String get match;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Extracting emotion'**
  String get extractingEmotion;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Lab section title
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get lab;

  /// Calendar mode switch label
  ///
  /// In en, this message translates to:
  /// **'Calendar Mode'**
  String get calendarMode;

  /// Add diary button text
  ///
  /// In en, this message translates to:
  /// **'Add Diary'**
  String get addDiary;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
