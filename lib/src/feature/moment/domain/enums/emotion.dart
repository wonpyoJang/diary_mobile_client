import 'package:flutter/widgets.dart'; // Added for BuildContext
import 'package:diary_mobile_client/l10n/app_localizations.dart';

/// A placeholder class that represents an entity or model.

enum Emotion {
  warmth(
    color: Color(0xFFE4CAE0),
    nameKey: 'emotion_warmth_name',
    explanationKey: 'emotion_warmth_explanation',
    enName: 'Warmth',
  ),
  happiness(
    color: Color(0xFFD7E5CD),
    nameKey: 'emotion_happiness_name',
    explanationKey: 'emotion_happiness_explanation',
    enName: 'Happiness',
  ),
  calmness(
    color: Color(0xFFB5BDFA),
    nameKey: 'emotion_calmness_name',
    explanationKey: 'emotion_calmness_explanation',
    enName: 'Calmness',
  ),
  hope(
    color: Color(0xFFDFECB4),
    nameKey: 'emotion_hope_name',
    explanationKey: 'emotion_hope_explanation',
    enName: 'Hope',
  ),
  mystery(
    color: Color(0xFFE9E1FD),
    nameKey: 'emotion_mystery_name',
    explanationKey: 'emotion_mystery_explanation',
    enName: 'Mystery',
  ),
  stability(
    color: Color(0xFFEDEBEB),
    nameKey: 'emotion_stability_name',
    explanationKey: 'emotion_stability_explanation',
    enName: 'Stability',
  ),
  gentleness(
    color: Color(0xFFFBE6CF),
    nameKey: 'emotion_gentleness_name',
    explanationKey: 'emotion_gentleness_explanation',
    enName: 'Gentleness',
  ),
  freshness(
    color: Color(0xFFCCF2F2),
    nameKey: 'emotion_freshness_name',
    explanationKey: 'emotion_freshness_explanation',
    enName: 'Freshness',
  ),
  boredom(
    color: Color(0xFFD3D3D3),
    nameKey: 'emotion_boredom_name',
    explanationKey: 'emotion_boredom_explanation',
    enName: 'Boredom',
  ),
  anger(
    color: Color(0xFFFF0000),
    nameKey: 'emotion_anger_name',
    explanationKey: 'emotion_anger_explanation',
    enName: 'Anger',
  ),
  excitement(
    color: Color(0xFFEDDBA0),
    nameKey: 'emotion_excitement_name',
    explanationKey: 'emotion_excitement_explanation',
    enName: 'Excitement',
  ),
  sadness(
    color: Color(0xFFBAC8D4),
    nameKey: 'emotion_sadness_name',
    explanationKey: 'emotion_sadness_explanation',
    enName: 'Sadness',
  ),
  fear(
    color: Color(0xFF800080),
    nameKey: 'emotion_fear_name',
    explanationKey: 'emotion_fear_explanation',
    enName: 'Fear',
  ),
  surprise(
    color: Color(0xFFFFFF00),
    nameKey: 'emotion_surprise_name',
    explanationKey: 'emotion_surprise_explanation',
    enName: 'Surprise',
  ),
  disgust(
    color: Color(0xFF008000),
    nameKey: 'emotion_disgust_name',
    explanationKey: 'emotion_disgust_explanation',
    enName: 'Disgust',
  ),
  love(
    color: Color(0xFFFFC0CB),
    nameKey: 'emotion_love_name',
    explanationKey: 'emotion_love_explanation',
    enName: 'Love',
  ),
  pride(
    color: Color(0xFFDAA520),
    nameKey: 'emotion_pride_name',
    explanationKey: 'emotion_pride_explanation',
    enName: 'Pride',
  ),
  shame(
    color: Color(0xFF8B0000),
    nameKey: 'emotion_shame_name',
    explanationKey: 'emotion_shame_explanation',
    enName: 'Shame',
  ),
  guilt(
    color: Color(0xFF808080),
    nameKey: 'emotion_guilt_name',
    explanationKey: 'emotion_guilt_explanation',
    enName: 'Guilt',
  ),
  envy(
    color: Color(0xFF00FF00),
    nameKey: 'emotion_envy_name',
    explanationKey: 'emotion_envy_explanation',
    enName: 'Envy',
  ),
  jealousy(
    color: Color(0xFF7FFF00),
    nameKey: 'emotion_jealousy_name',
    explanationKey: 'emotion_jealousy_explanation',
    enName: 'Jealousy',
  ),
  contentment(
    color: Color(0xFFECCEAA),
    nameKey: 'emotion_contentment_name',
    explanationKey: 'emotion_contentment_explanation',
    enName: 'Contentment',
  ),
  gratitude(
    color: Color(0xFFFFD700),
    nameKey: 'emotion_gratitude_name',
    explanationKey: 'emotion_gratitude_explanation',
    enName: 'Gratitude',
  ),
  nostalgia(
    color: Color(0xFFFAF0E6),
    nameKey: 'emotion_nostalgia_name',
    explanationKey: 'emotion_nostalgia_explanation',
    enName: 'Nostalgia',
  ),
  loneliness(
    color: Color(0xFF708090),
    nameKey: 'emotion_loneliness_name',
    explanationKey: 'emotion_loneliness_explanation',
    enName: 'Loneliness',
  ),
  frustration(
    color: Color(0xFFFF6347),
    nameKey: 'emotion_frustration_name',
    explanationKey: 'emotion_frustration_explanation',
    enName: 'Frustration',
  ),
  awe(
    color: Color(0xFF4682B4),
    nameKey: 'emotion_awe_name',
    explanationKey: 'emotion_awe_explanation',
    enName: 'Awe',
  ),
  amusement(
    color: Color(0xFFFFE4B5),
    nameKey: 'emotion_amusement_name',
    explanationKey: 'emotion_amusement_explanation',
    enName: 'Amusement',
  ),
  relief(
    color: Color(0xFF98FB98),
    nameKey: 'emotion_relief_name',
    explanationKey: 'emotion_relief_explanation',
    enName: 'Relief',
  ),
  curiosity(
    color: Color(0xFFAFEEEE),
    nameKey: 'emotion_curiosity_name',
    explanationKey: 'emotion_curiosity_explanation',
    enName: 'Curiosity',
  ),
  desire(
    color: Color(0xFFFF4500),
    nameKey: 'emotion_desire_name',
    explanationKey: 'emotion_desire_explanation',
    enName: 'Desire',
  ),
  confusion(
    color: Color(0xFFB0C4DE),
    nameKey: 'emotion_confusion_name',
    explanationKey: 'emotion_confusion_explanation',
    enName: 'Confusion',
  ),
  doubt(
    color: Color(0xFF808080),
    nameKey: 'emotion_doubt_name',
    explanationKey: 'emotion_doubt_explanation',
    enName: 'Doubt',
  ),
  comfort(
    color: Color(0xFFE4CAE0),
    nameKey: 'emotion_comfort_name',
    explanationKey: 'emotion_comfort_explanation',
    enName: 'Comfort',
  ),
  joy(
    color: Color(0xFFD7E5CD),
    nameKey: 'emotion_joy_name',
    explanationKey: 'emotion_joy_explanation',
    enName: 'Joy',
  ),
  affection(
    color: Color(0xFFE8C8C3),
    nameKey: 'emotion_affection_name',
    explanationKey: 'emotion_affection_explanation',
    enName: 'Affection',
  ),
  excitementNew(
    color: Color(0xFFEDDBA0),
    nameKey: 'emotion_excitementNew_name',
    explanationKey: 'emotion_excitementNew_explanation',
    enName: 'Thrill',
  ),
  anxiety(
    color: Color(0xFFCAE1E0),
    nameKey: 'emotion_anxiety_name',
    explanationKey: 'emotion_anxiety_explanation',
    enName: 'Anxiety',
  ),
  tension(
    color: Color(0xFFC4BAD8),
    nameKey: 'emotion_tension_name',
    explanationKey: 'emotion_tension_explanation',
    enName: 'Tension',
  ),
  depression(
    color: Color(0xFFCBCBCB),
    nameKey: 'emotion_depression_name',
    explanationKey: 'emotion_depression_explanation',
    enName: 'Depression',
  );

  final Color color;
  final String nameKey;
  final String explanationKey;
  final String enName;

  const Emotion({
    required this.color,
    required this.nameKey,
    required this.explanationKey,
    required this.enName,
  });

  static Emotion findByName(String name) {
    return Emotion.values.firstWhere((emotion) => emotion.name == name,
        orElse: () => throw ArgumentError('Invalid emotion name: $name'));
  }

  static Map<Emotion, String?> buildNameMap(AppLocalizations? loc) => {
        Emotion.warmth: loc?.emotion_warmth_name,
        Emotion.happiness: loc?.emotion_happiness_name,
        Emotion.calmness: loc?.emotion_calmness_name,
        Emotion.hope: loc?.emotion_hope_name,
        Emotion.mystery: loc?.emotion_mystery_name,
        Emotion.stability: loc?.emotion_stability_name,
        Emotion.gentleness: loc?.emotion_gentleness_name,
        Emotion.freshness: loc?.emotion_freshness_name,
        Emotion.boredom: loc?.emotion_boredom_name,
        Emotion.anger: loc?.emotion_anger_name,
        Emotion.excitement: loc?.emotion_excitement_name,
        Emotion.sadness: loc?.emotion_sadness_name,
        Emotion.fear: loc?.emotion_fear_name,
        Emotion.surprise: loc?.emotion_surprise_name,
        Emotion.disgust: loc?.emotion_disgust_name,
        Emotion.love: loc?.emotion_love_name,
        Emotion.pride: loc?.emotion_pride_name,
        Emotion.shame: loc?.emotion_shame_name,
        Emotion.guilt: loc?.emotion_guilt_name,
        Emotion.envy: loc?.emotion_envy_name,
        Emotion.jealousy: loc?.emotion_jealousy_name,
        Emotion.contentment: loc?.emotion_contentment_name,
        Emotion.gratitude: loc?.emotion_gratitude_name,
        Emotion.nostalgia: loc?.emotion_nostalgia_name,
        Emotion.loneliness: loc?.emotion_loneliness_name,
        Emotion.frustration: loc?.emotion_frustration_name,
        Emotion.curiosity: loc?.emotion_curiosity_name,
        Emotion.desire: loc?.emotion_desire_name,
        Emotion.confusion: loc?.emotion_confusion_name,
        Emotion.doubt: loc?.emotion_doubt_name,
        Emotion.comfort: loc?.emotion_comfort_name,
        Emotion.joy: loc?.emotion_joy_name,
        Emotion.affection: loc?.emotion_affection_name,
        Emotion.excitementNew: loc?.emotion_excitementNew_name,
        Emotion.anxiety: loc?.emotion_anxiety_name,
        Emotion.tension: loc?.emotion_tension_name,
        Emotion.depression: loc?.emotion_depression_name,
        Emotion.relief: loc?.emotion_relief_name,
        Emotion.amusement: loc?.emotion_amusement_name,
        Emotion.awe: loc?.emotion_awe_name,
      };

  static Map<Emotion, String?> buildExplanationMap(AppLocalizations? loc) => {
        Emotion.warmth: loc?.emotion_warmth_explanation,
        Emotion.happiness: loc?.emotion_happiness_explanation,
        Emotion.calmness: loc?.emotion_calmness_explanation,
        Emotion.hope: loc?.emotion_hope_explanation,
        Emotion.mystery: loc?.emotion_mystery_explanation,
        Emotion.stability: loc?.emotion_stability_explanation,
        Emotion.gentleness: loc?.emotion_gentleness_explanation,
        Emotion.freshness: loc?.emotion_freshness_explanation,
        Emotion.boredom: loc?.emotion_boredom_explanation,
        Emotion.anger: loc?.emotion_anger_explanation,
        Emotion.excitement: loc?.emotion_excitement_explanation,
        Emotion.sadness: loc?.emotion_sadness_explanation,
        Emotion.fear: loc?.emotion_fear_explanation,
        Emotion.surprise: loc?.emotion_surprise_explanation,
        Emotion.disgust: loc?.emotion_disgust_explanation,
        Emotion.love: loc?.emotion_love_explanation,
        Emotion.pride: loc?.emotion_pride_explanation,
        Emotion.shame: loc?.emotion_shame_explanation,
        Emotion.guilt: loc?.emotion_guilt_explanation,
        Emotion.envy: loc?.emotion_envy_explanation,
        Emotion.jealousy: loc?.emotion_jealousy_explanation,
        Emotion.contentment: loc?.emotion_contentment_explanation,
        Emotion.gratitude: loc?.emotion_gratitude_explanation,
        Emotion.nostalgia: loc?.emotion_nostalgia_explanation,
        Emotion.loneliness: loc?.emotion_loneliness_explanation,
        Emotion.frustration: loc?.emotion_frustration_explanation,
        Emotion.curiosity: loc?.emotion_curiosity_explanation,
        Emotion.desire: loc?.emotion_desire_explanation,
        Emotion.confusion: loc?.emotion_confusion_explanation,
        Emotion.doubt: loc?.emotion_doubt_explanation,
        Emotion.comfort: loc?.emotion_comfort_explanation,
        Emotion.joy: loc?.emotion_joy_explanation,
        Emotion.affection: loc?.emotion_affection_explanation,
        Emotion.excitementNew: loc?.emotion_excitementNew_explanation,
        Emotion.anxiety: loc?.emotion_anxiety_explanation,
        Emotion.tension: loc?.emotion_tension_explanation,
        Emotion.depression: loc?.emotion_depression_explanation,
        Emotion.relief: loc?.emotion_relief_explanation,
        Emotion.amusement: loc?.emotion_amusement_explanation,
        Emotion.awe: loc?.emotion_awe_explanation,
      };

  String localizedName(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final nameMap = buildNameMap(loc);
    return nameMap[this] ?? nameKey;
  }

  String localizedExplanation(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final explanationMap = buildExplanationMap(loc);
    return explanationMap[this] ?? explanationKey;
  }
}
