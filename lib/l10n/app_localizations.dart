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

  /// Edit menu
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete menu and button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Add photo menu
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// Share menu
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Delete confirm message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get deleteConfirm;

  /// Write with photo confirm message
  ///
  /// In en, this message translates to:
  /// **'Write with the added photo?'**
  String get addImageToWrite;

  /// Web not supported notice
  ///
  /// In en, this message translates to:
  /// **'This feature is not supported on web.'**
  String get webNotSupported;

  /// App download link notice
  ///
  /// In en, this message translates to:
  /// **'App download link: https://testflight.apple.com/join/9Z7cKQSj'**
  String get appDownloadLink;

  /// Emotion share text
  ///
  /// In en, this message translates to:
  /// **'Sharing today\'s emotion.'**
  String get shareEmotion;

  /// Diary reflection label
  ///
  /// In en, this message translates to:
  /// **'[Diary]'**
  String get diaryReflection;

  /// Image save success notice
  ///
  /// In en, this message translates to:
  /// **'Image saved successfully.'**
  String get imageSaved;

  /// Image save error notice
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the image.'**
  String get imageSaveError;

  /// Gallery permission notice
  ///
  /// In en, this message translates to:
  /// **'Gallery write permission is required.'**
  String get galleryPermission;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Analysis result confirmation question
  ///
  /// In en, this message translates to:
  /// **'Is this analysis correct?'**
  String get analysisCorrect;

  /// Guide message for writing a diary and checking today's emotion
  ///
  /// In en, this message translates to:
  /// **'Write a diary and check today\'s emotion\nright now!'**
  String get writeDiaryGuide;

  /// Hint message for writing a diary
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get writeDiaryHint;

  /// Diary hint 1
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get writeDiaryHint1;

  /// Diary hint 2
  ///
  /// In en, this message translates to:
  /// **'Express your feelings honestly today'**
  String get writeDiaryHint2;

  /// Diary hint 3
  ///
  /// In en, this message translates to:
  /// **'Record the precious moments of your day'**
  String get writeDiaryHint3;

  /// Diary hint 4
  ///
  /// In en, this message translates to:
  /// **'Write down the stories in your heart'**
  String get writeDiaryHint4;

  /// Diary hint 5
  ///
  /// In en, this message translates to:
  /// **'Share your true feelings today'**
  String get writeDiaryHint5;

  /// Diary hint 6
  ///
  /// In en, this message translates to:
  /// **'At the end of the day, share your thoughts'**
  String get writeDiaryHint6;

  /// Diary hint 7
  ///
  /// In en, this message translates to:
  /// **'Organize your feelings through today\'s diary'**
  String get writeDiaryHint7;

  /// Diary hint 8
  ///
  /// In en, this message translates to:
  /// **'Leave your precious memories'**
  String get writeDiaryHint8;

  /// Diary hint 9
  ///
  /// In en, this message translates to:
  /// **'Make your day special'**
  String get writeDiaryHint9;

  /// Diary hint 10
  ///
  /// In en, this message translates to:
  /// **'Express your inner stories in writing'**
  String get writeDiaryHint10;

  /// Diary hint 11
  ///
  /// In en, this message translates to:
  /// **'Leave today\'s feelings in writing'**
  String get writeDiaryHint11;
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
