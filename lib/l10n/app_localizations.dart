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

  /// No description provided for @emotion_warmth_name.
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get emotion_warmth_name;

  /// No description provided for @emotion_warmth_explanation.
  ///
  /// In en, this message translates to:
  /// **'A warm and cozy feeling, like being wrapped in a blanket on a winter day. Often experienced through closeness and love.'**
  String get emotion_warmth_explanation;

  /// No description provided for @emotion_happiness_name.
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get emotion_happiness_name;

  /// No description provided for @emotion_happiness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of joy and satisfaction, felt in small moments and achievements. Brings positive energy and improves quality of life.'**
  String get emotion_happiness_explanation;

  /// No description provided for @emotion_calmness_name.
  ///
  /// In en, this message translates to:
  /// **'Calmness'**
  String get emotion_calmness_name;

  /// No description provided for @emotion_calmness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A peaceful and stable state, free from noise and stress. Often found in meditation or nature.'**
  String get emotion_calmness_explanation;

  /// No description provided for @emotion_hope_name.
  ///
  /// In en, this message translates to:
  /// **'Hope'**
  String get emotion_hope_name;

  /// No description provided for @emotion_hope_explanation.
  ///
  /// In en, this message translates to:
  /// **'A positive expectation for the future, giving strength to move forward even in difficult times. The driving force of life.'**
  String get emotion_hope_explanation;

  /// No description provided for @emotion_mystery_name.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get emotion_mystery_name;

  /// No description provided for @emotion_mystery_explanation.
  ///
  /// In en, this message translates to:
  /// **'A sense of wonder and curiosity about the unknown. Stimulates imagination and creativity.'**
  String get emotion_mystery_explanation;

  /// No description provided for @emotion_stability_name.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get emotion_stability_name;

  /// No description provided for @emotion_stability_explanation.
  ///
  /// In en, this message translates to:
  /// **'A stable and unchanging state, felt when life is predictable and secure. Provides psychological safety and reduces stress.'**
  String get emotion_stability_explanation;

  /// No description provided for @emotion_gentleness_name.
  ///
  /// In en, this message translates to:
  /// **'Gentleness'**
  String get emotion_gentleness_name;

  /// No description provided for @emotion_gentleness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A soft and kind feeling, experienced when being considerate and caring. Smooths relationships and increases understanding.'**
  String get emotion_gentleness_explanation;

  /// No description provided for @emotion_freshness_name.
  ///
  /// In en, this message translates to:
  /// **'Freshness'**
  String get emotion_freshness_name;

  /// No description provided for @emotion_freshness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A new and refreshing feeling, often felt at the start of something new or during change. Brings vitality to daily life.'**
  String get emotion_freshness_explanation;

  /// No description provided for @emotion_boredom_name.
  ///
  /// In en, this message translates to:
  /// **'Boredom'**
  String get emotion_boredom_name;

  /// No description provided for @emotion_boredom_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of disinterest and monotony, often felt in repetitive situations. Can motivate the search for new stimulation.'**
  String get emotion_boredom_explanation;

  /// No description provided for @emotion_anger_name.
  ///
  /// In en, this message translates to:
  /// **'Anger'**
  String get emotion_anger_name;

  /// No description provided for @emotion_anger_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of rage, often felt in unfair situations. Sometimes a strong motivator for change.'**
  String get emotion_anger_explanation;

  /// No description provided for @emotion_excitement_name.
  ///
  /// In en, this message translates to:
  /// **'Excitement'**
  String get emotion_excitement_name;

  /// No description provided for @emotion_excitement_explanation.
  ///
  /// In en, this message translates to:
  /// **'A lively and energetic state, felt before special events or achievements. Boosts energy and positive actions.'**
  String get emotion_excitement_explanation;

  /// No description provided for @emotion_sadness_name.
  ///
  /// In en, this message translates to:
  /// **'Sadness'**
  String get emotion_sadness_name;

  /// No description provided for @emotion_sadness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of pain and depression, felt after loss or disappointment. Helps deepen empathy and understanding.'**
  String get emotion_sadness_explanation;

  /// No description provided for @emotion_fear_name.
  ///
  /// In en, this message translates to:
  /// **'Fear'**
  String get emotion_fear_name;

  /// No description provided for @emotion_fear_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of anxiety and threat, experienced when sensing danger. Helps survival and avoiding risks.'**
  String get emotion_fear_explanation;

  /// No description provided for @emotion_surprise_name.
  ///
  /// In en, this message translates to:
  /// **'Surprise'**
  String get emotion_surprise_name;

  /// No description provided for @emotion_surprise_explanation.
  ///
  /// In en, this message translates to:
  /// **'A reaction to the unexpected, felt instantly in both positive and negative events. Increases focus and learning.'**
  String get emotion_surprise_explanation;

  /// No description provided for @emotion_disgust_name.
  ///
  /// In en, this message translates to:
  /// **'Disgust'**
  String get emotion_disgust_name;

  /// No description provided for @emotion_disgust_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of dislike and discomfort, a reaction to unpleasant situations or substances. Instinctive for health and safety.'**
  String get emotion_disgust_explanation;

  /// No description provided for @emotion_love_name.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get emotion_love_name;

  /// No description provided for @emotion_love_explanation.
  ///
  /// In en, this message translates to:
  /// **'A deep feeling of affection and attachment, experienced in close relationships. Strengthens bonds and gives meaning to life.'**
  String get emotion_love_explanation;

  /// No description provided for @emotion_pride_name.
  ///
  /// In en, this message translates to:
  /// **'Pride'**
  String get emotion_pride_name;

  /// No description provided for @emotion_pride_explanation.
  ///
  /// In en, this message translates to:
  /// **'A positive sense of self, felt through achievement or ability. Increases confidence and encourages challenge.'**
  String get emotion_pride_explanation;

  /// No description provided for @emotion_shame_name.
  ///
  /// In en, this message translates to:
  /// **'Shame'**
  String get emotion_shame_name;

  /// No description provided for @emotion_shame_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of embarrassment, experienced when violating social norms. Promotes reflection and improvement.'**
  String get emotion_shame_explanation;

  /// No description provided for @emotion_guilt_name.
  ///
  /// In en, this message translates to:
  /// **'Guilt'**
  String get emotion_guilt_name;

  /// No description provided for @emotion_guilt_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of regret and responsibility for wrongdoing. Encourages moral reflection and relationship recovery.'**
  String get emotion_guilt_explanation;

  /// No description provided for @emotion_envy_name.
  ///
  /// In en, this message translates to:
  /// **'Envy'**
  String get emotion_envy_name;

  /// No description provided for @emotion_envy_explanation.
  ///
  /// In en, this message translates to:
  /// **'A desire for what others have, felt when admiring others\' success or possessions. Can be a source of motivation.'**
  String get emotion_envy_explanation;

  /// No description provided for @emotion_jealousy_name.
  ///
  /// In en, this message translates to:
  /// **'Jealousy'**
  String get emotion_jealousy_name;

  /// No description provided for @emotion_jealousy_explanation.
  ///
  /// In en, this message translates to:
  /// **'A fear of losing something precious to others\' success or happiness. Instinctive for protecting relationships.'**
  String get emotion_jealousy_explanation;

  /// No description provided for @emotion_contentment_name.
  ///
  /// In en, this message translates to:
  /// **'Contentment'**
  String get emotion_contentment_name;

  /// No description provided for @emotion_contentment_explanation.
  ///
  /// In en, this message translates to:
  /// **'A sense of satisfaction with the present, felt when life is balanced and harmonious. Provides psychological stability and reduces stress.'**
  String get emotion_contentment_explanation;

  /// No description provided for @emotion_gratitude_name.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get emotion_gratitude_name;

  /// No description provided for @emotion_gratitude_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of thankfulness, experienced for others\' help or kindness. Builds positive relationships and increases happiness.'**
  String get emotion_gratitude_explanation;

  /// No description provided for @emotion_nostalgia_name.
  ///
  /// In en, this message translates to:
  /// **'Nostalgia'**
  String get emotion_nostalgia_name;

  /// No description provided for @emotion_nostalgia_explanation.
  ///
  /// In en, this message translates to:
  /// **'A longing for the past, felt when recalling childhood or special moments. Cherishes past experiences and enriches the present.'**
  String get emotion_nostalgia_explanation;

  /// No description provided for @emotion_loneliness_name.
  ///
  /// In en, this message translates to:
  /// **'Loneliness'**
  String get emotion_loneliness_name;

  /// No description provided for @emotion_loneliness_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of being alone and isolated, experienced when lacking social connection. Reminds the importance of relationships and motivates new connections.'**
  String get emotion_loneliness_explanation;

  /// No description provided for @emotion_frustration_name.
  ///
  /// In en, this message translates to:
  /// **'Frustration'**
  String get emotion_frustration_name;

  /// No description provided for @emotion_frustration_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of disappointment from not reaching a goal. Motivates new strategies and growth.'**
  String get emotion_frustration_explanation;

  /// No description provided for @emotion_awe_name.
  ///
  /// In en, this message translates to:
  /// **'Awe'**
  String get emotion_awe_name;

  /// No description provided for @emotion_awe_explanation.
  ///
  /// In en, this message translates to:
  /// **'A sense of wonder at greatness, felt in nature or human achievements. Inspires humility and creativity.'**
  String get emotion_awe_explanation;

  /// No description provided for @emotion_amusement_name.
  ///
  /// In en, this message translates to:
  /// **'Amusement'**
  String get emotion_amusement_name;

  /// No description provided for @emotion_amusement_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of fun and enjoyment, felt through humor or entertainment. Relieves stress and provides positive energy.'**
  String get emotion_amusement_explanation;

  /// No description provided for @emotion_relief_name.
  ///
  /// In en, this message translates to:
  /// **'Relief'**
  String get emotion_relief_name;

  /// No description provided for @emotion_relief_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of comfort after worry disappears, felt when tension is resolved. Brings psychological stability and positive change.'**
  String get emotion_relief_explanation;

  /// No description provided for @emotion_curiosity_name.
  ///
  /// In en, this message translates to:
  /// **'Curiosity'**
  String get emotion_curiosity_name;

  /// No description provided for @emotion_curiosity_explanation.
  ///
  /// In en, this message translates to:
  /// **'An interest in new things, a desire to explore the unknown. Drives learning and discovery.'**
  String get emotion_curiosity_explanation;

  /// No description provided for @emotion_desire_name.
  ///
  /// In en, this message translates to:
  /// **'Desire'**
  String get emotion_desire_name;

  /// No description provided for @emotion_desire_explanation.
  ///
  /// In en, this message translates to:
  /// **'A strong wish for something, motivating progress toward goals. Promotes achievement and growth.'**
  String get emotion_desire_explanation;

  /// No description provided for @emotion_confusion_name.
  ///
  /// In en, this message translates to:
  /// **'Confusion'**
  String get emotion_confusion_name;

  /// No description provided for @emotion_confusion_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of uncertainty, felt when information is unclear or contradictory. Motivates new approaches to problem-solving.'**
  String get emotion_confusion_explanation;

  /// No description provided for @emotion_doubt_name.
  ///
  /// In en, this message translates to:
  /// **'Doubt'**
  String get emotion_doubt_name;

  /// No description provided for @emotion_doubt_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of uncertainty, experienced when facing unreliable situations. Increases focus and logical thinking.'**
  String get emotion_doubt_explanation;

  /// No description provided for @emotion_comfort_name.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get emotion_comfort_name;

  /// No description provided for @emotion_comfort_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of comfort and stability, felt when free from stress and worry. Provides psychological stability and improves quality of life.'**
  String get emotion_comfort_explanation;

  /// No description provided for @emotion_joy_name.
  ///
  /// In en, this message translates to:
  /// **'Joy'**
  String get emotion_joy_name;

  /// No description provided for @emotion_joy_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of happiness and delight, felt through good events or achievements. Brings positive energy and vitality.'**
  String get emotion_joy_explanation;

  /// No description provided for @emotion_affection_name.
  ///
  /// In en, this message translates to:
  /// **'Affection'**
  String get emotion_affection_name;

  /// No description provided for @emotion_affection_explanation.
  ///
  /// In en, this message translates to:
  /// **'A deep feeling of fondness and attachment, experienced in close relationships. Strengthens bonds and gives meaning to life.'**
  String get emotion_affection_explanation;

  /// No description provided for @emotion_excitementNew_name.
  ///
  /// In en, this message translates to:
  /// **'Thrill'**
  String get emotion_excitementNew_name;

  /// No description provided for @emotion_excitementNew_explanation.
  ///
  /// In en, this message translates to:
  /// **'A lively and energetic state, felt before special events or achievements. Boosts energy and positive actions.'**
  String get emotion_excitementNew_explanation;

  /// No description provided for @emotion_anxiety_name.
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get emotion_anxiety_name;

  /// No description provided for @emotion_anxiety_explanation.
  ///
  /// In en, this message translates to:
  /// **'A feeling of fear and unease, experienced when sensing danger or threat. Helps survival and avoiding risks.'**
  String get emotion_anxiety_explanation;

  /// No description provided for @emotion_tension_name.
  ///
  /// In en, this message translates to:
  /// **'Tension'**
  String get emotion_tension_name;

  /// No description provided for @emotion_tension_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of nervousness and anxiety, felt when facing important tasks or challenges. Increases focus and problem-solving.'**
  String get emotion_tension_explanation;

  /// No description provided for @emotion_depression_name.
  ///
  /// In en, this message translates to:
  /// **'Depression'**
  String get emotion_depression_name;

  /// No description provided for @emotion_depression_explanation.
  ///
  /// In en, this message translates to:
  /// **'A state of pain and depression, felt after loss or disappointment. Helps deepen empathy and understanding.'**
  String get emotion_depression_explanation;
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
