import 'package:flutter/widgets.dart'; // Added for BuildContext
import 'package:diary_mobile_client/l10n/app_localizations.dart';

/// A placeholder class that represents an entity or model.

// 색상 심리 표 기반의 색상 그룹
enum EmotionColorGroup {
  maroon(Color(0xFF7D1D7B)), // 자주
  red(Color(0xFFFF0000)), // 빨강
  orange(Color(0xFFFFA500)), // 주황
  yellow(Color(0xFFFFFF00)), // 노랑
  lightGreen(Color(0xFFADFF2F)), // 연두
  green(Color(0xFF008000)), // 초록
  teal(Color(0xFF008080)), // 청록
  cyan(Color(0xFFB2EBF2)), // 사이언
  blue(Color(0xFF4169E1)), // 파랑
  indigo(Color(0xFF4B0082)), // 청자/남보라
  purple(Color(0xFF6A0DAD)), // 보라
  white(Color(0xFFFFFFFF)), // 흰색
  gray(Color(0xFFA9A9A9)), // 회색
  black(Color(0xFF000000)); // 검정

  final Color color;
  const EmotionColorGroup(this.color);
}

enum Emotion {
  warmth(
    group: EmotionColorGroup.orange,
    nameKey: 'emotion_warmth_name',
    explanationKey: 'emotion_warmth_explanation',
    enName: 'Warmth',
  ),
  happiness(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_happiness_name',
    explanationKey: 'emotion_happiness_explanation',
    enName: 'Happiness',
  ),
  calmness(
    group: EmotionColorGroup.blue,
    nameKey: 'emotion_calmness_name',
    explanationKey: 'emotion_calmness_explanation',
    enName: 'Calmness',
  ),
  hope(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_hope_name',
    explanationKey: 'emotion_hope_explanation',
    enName: 'Hope',
  ),
  mystery(
    group: EmotionColorGroup.purple,
    nameKey: 'emotion_mystery_name',
    explanationKey: 'emotion_mystery_explanation',
    enName: 'Mystery',
  ),
  stability(
    group: EmotionColorGroup.green,
    nameKey: 'emotion_stability_name',
    explanationKey: 'emotion_stability_explanation',
    enName: 'Stability',
  ),
  gentleness(
    group: EmotionColorGroup.lightGreen,
    nameKey: 'emotion_gentleness_name',
    explanationKey: 'emotion_gentleness_explanation',
    enName: 'Gentleness',
  ),
  freshness(
    group: EmotionColorGroup.lightGreen,
    nameKey: 'emotion_freshness_name',
    explanationKey: 'emotion_freshness_explanation',
    enName: 'Freshness',
  ),
  boredom(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_boredom_name',
    explanationKey: 'emotion_boredom_explanation',
    enName: 'Boredom',
  ),
  anger(
    group: EmotionColorGroup.red,
    nameKey: 'emotion_anger_name',
    explanationKey: 'emotion_anger_explanation',
    enName: 'Anger',
  ),
  excitement(
    group: EmotionColorGroup.orange,
    nameKey: 'emotion_excitement_name',
    explanationKey: 'emotion_excitement_explanation',
    enName: 'Excitement',
  ),
  sadness(
    group: EmotionColorGroup.blue,
    nameKey: 'emotion_sadness_name',
    explanationKey: 'emotion_sadness_explanation',
    enName: 'Sadness',
  ),
  fear(
    group: EmotionColorGroup.black,
    nameKey: 'emotion_fear_name',
    explanationKey: 'emotion_fear_explanation',
    enName: 'Fear',
  ),
  surprise(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_surprise_name',
    explanationKey: 'emotion_surprise_explanation',
    enName: 'Surprise',
  ),
  disgust(
    group: EmotionColorGroup.green,
    nameKey: 'emotion_disgust_name',
    explanationKey: 'emotion_disgust_explanation',
    enName: 'Disgust',
  ),
  love(
    group: EmotionColorGroup.maroon,
    nameKey: 'emotion_love_name',
    explanationKey: 'emotion_love_explanation',
    enName: 'Love',
  ),
  pride(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_pride_name',
    explanationKey: 'emotion_pride_explanation',
    enName: 'Pride',
  ),
  shame(
    group: EmotionColorGroup.black,
    nameKey: 'emotion_shame_name',
    explanationKey: 'emotion_shame_explanation',
    enName: 'Shame',
  ),
  guilt(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_guilt_name',
    explanationKey: 'emotion_guilt_explanation',
    enName: 'Guilt',
  ),
  envy(
    group: EmotionColorGroup.green,
    nameKey: 'emotion_envy_name',
    explanationKey: 'emotion_envy_explanation',
    enName: 'Envy',
  ),
  jealousy(
    group: EmotionColorGroup.green,
    nameKey: 'emotion_jealousy_name',
    explanationKey: 'emotion_jealousy_explanation',
    enName: 'Jealousy',
  ),
  contentment(
    group: EmotionColorGroup.orange,
    nameKey: 'emotion_contentment_name',
    explanationKey: 'emotion_contentment_explanation',
    enName: 'Contentment',
  ),
  gratitude(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_gratitude_name',
    explanationKey: 'emotion_gratitude_explanation',
    enName: 'Gratitude',
  ),
  nostalgia(
    group: EmotionColorGroup.orange,
    nameKey: 'emotion_nostalgia_name',
    explanationKey: 'emotion_nostalgia_explanation',
    enName: 'Nostalgia',
  ),
  loneliness(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_loneliness_name',
    explanationKey: 'emotion_loneliness_explanation',
    enName: 'Loneliness',
  ),
  frustration(
    group: EmotionColorGroup.red,
    nameKey: 'emotion_frustration_name',
    explanationKey: 'emotion_frustration_explanation',
    enName: 'Frustration',
  ),
  awe(
    group: EmotionColorGroup.indigo,
    nameKey: 'emotion_awe_name',
    explanationKey: 'emotion_awe_explanation',
    enName: 'Awe',
  ),
  amusement(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_amusement_name',
    explanationKey: 'emotion_amusement_explanation',
    enName: 'Amusement',
  ),
  relief(
    group: EmotionColorGroup.lightGreen,
    nameKey: 'emotion_relief_name',
    explanationKey: 'emotion_relief_explanation',
    enName: 'Relief',
  ),
  curiosity(
    group: EmotionColorGroup.cyan,
    nameKey: 'emotion_curiosity_name',
    explanationKey: 'emotion_curiosity_explanation',
    enName: 'Curiosity',
  ),
  desire(
    group: EmotionColorGroup.red,
    nameKey: 'emotion_desire_name',
    explanationKey: 'emotion_desire_explanation',
    enName: 'Desire',
  ),
  confusion(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_confusion_name',
    explanationKey: 'emotion_confusion_explanation',
    enName: 'Confusion',
  ),
  doubt(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_doubt_name',
    explanationKey: 'emotion_doubt_explanation',
    enName: 'Doubt',
  ),
  comfort(
    group: EmotionColorGroup.lightGreen,
    nameKey: 'emotion_comfort_name',
    explanationKey: 'emotion_comfort_explanation',
    enName: 'Comfort',
  ),
  joy(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_joy_name',
    explanationKey: 'emotion_joy_explanation',
    enName: 'Joy',
  ),
  affection(
    group: EmotionColorGroup.maroon,
    nameKey: 'emotion_affection_name',
    explanationKey: 'emotion_affection_explanation',
    enName: 'Affection',
  ),
  excitementNew(
    group: EmotionColorGroup.orange,
    nameKey: 'emotion_excitementNew_name',
    explanationKey: 'emotion_excitementNew_explanation',
    enName: 'Thrill',
  ),
  anxiety(
    group: EmotionColorGroup.cyan,
    nameKey: 'emotion_anxiety_name',
    explanationKey: 'emotion_anxiety_explanation',
    enName: 'Anxiety',
  ),
  tension(
    group: EmotionColorGroup.purple,
    nameKey: 'emotion_tension_name',
    explanationKey: 'emotion_tension_explanation',
    enName: 'Tension',
  ),
  depression(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_depression_name',
    explanationKey: 'emotion_depression_explanation',
    enName: 'Depression',
  ),
  // 추가: 표에 있는 누락 감정들
  passion(
    group: EmotionColorGroup.red,
    nameKey: 'emotion_passion_name',
    explanationKey: 'emotion_passion_explanation',
    enName: 'Passion',
  ),
  cheerfulness(
    group: EmotionColorGroup.yellow,
    nameKey: 'emotion_cheerfulness_name',
    explanationKey: 'emotion_cheerfulness_explanation',
    enName: 'Cheerfulness',
  ),
  peace(
    group: EmotionColorGroup.green,
    nameKey: 'emotion_peace_name',
    explanationKey: 'emotion_peace_explanation',
    enName: 'Peace',
  ),
  composure(
    group: EmotionColorGroup.blue,
    nameKey: 'emotion_composure_name',
    explanationKey: 'emotion_composure_explanation',
    enName: 'Composure',
  ),
  indifference(
    group: EmotionColorGroup.cyan,
    nameKey: 'emotion_indifference_name',
    explanationKey: 'emotion_indifference_explanation',
    enName: 'Indifference',
  ),
  compassion(
    group: EmotionColorGroup.cyan,
    nameKey: 'emotion_compassion_name',
    explanationKey: 'emotion_compassion_explanation',
    enName: 'Compassion',
  ),
  grief(
    group: EmotionColorGroup.black,
    nameKey: 'emotion_grief_name',
    explanationKey: 'emotion_grief_explanation',
    enName: 'Grief',
  ),
  despair(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_despair_name',
    explanationKey: 'emotion_despair_explanation',
    enName: 'Despair',
  ),
  emptiness(
    group: EmotionColorGroup.purple,
    nameKey: 'emotion_emptiness_name',
    explanationKey: 'emotion_emptiness_explanation',
    enName: 'Emptiness',
  ),
  apathy(
    group: EmotionColorGroup.gray,
    nameKey: 'emotion_apathy_name',
    explanationKey: 'emotion_apathy_explanation',
    enName: 'Apathy',
  ),
  purity(
    group: EmotionColorGroup.white,
    nameKey: 'emotion_purity_name',
    explanationKey: 'emotion_purity_explanation',
    enName: 'Purity',
  );

  final EmotionColorGroup group;
  Color get color => group.color;
  final String nameKey;
  final String explanationKey;
  final String enName;

  const Emotion({
    required this.group,
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
        Emotion.passion: loc?.emotion_passion_name,
        Emotion.cheerfulness: loc?.emotion_cheerfulness_name,
        Emotion.peace: loc?.emotion_peace_name,
        Emotion.composure: loc?.emotion_composure_name,
        Emotion.indifference: loc?.emotion_indifference_name,
        Emotion.compassion: loc?.emotion_compassion_name,
        Emotion.grief: loc?.emotion_grief_name,
        Emotion.despair: loc?.emotion_despair_name,
        Emotion.emptiness: loc?.emotion_emptiness_name,
        Emotion.apathy: loc?.emotion_apathy_name,
        Emotion.purity: loc?.emotion_purity_name,
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
        Emotion.passion: loc?.emotion_passion_explanation,
        Emotion.cheerfulness: loc?.emotion_cheerfulness_explanation,
        Emotion.peace: loc?.emotion_peace_explanation,
        Emotion.composure: loc?.emotion_composure_explanation,
        Emotion.indifference: loc?.emotion_indifference_explanation,
        Emotion.compassion: loc?.emotion_compassion_explanation,
        Emotion.grief: loc?.emotion_grief_explanation,
        Emotion.despair: loc?.emotion_despair_explanation,
        Emotion.emptiness: loc?.emotion_emptiness_explanation,
        Emotion.apathy: loc?.emotion_apathy_explanation,
        Emotion.purity: loc?.emotion_purity_explanation,
      };

  // 색상 그룹별로 감정 목록을 반환
  static Map<EmotionColorGroup, List<Emotion>> groupedByColor() => {
        EmotionColorGroup.maroon: [Emotion.love, Emotion.affection],
        EmotionColorGroup.red: [
          Emotion.anger,
          Emotion.frustration,
          Emotion.desire,
          Emotion.passion,
        ],
        EmotionColorGroup.orange: [
          Emotion.warmth,
          Emotion.excitement,
          Emotion.excitementNew,
          Emotion.contentment,
          Emotion.nostalgia,
        ],
        EmotionColorGroup.yellow: [
          Emotion.happiness,
          Emotion.joy,
          Emotion.hope,
          Emotion.surprise,
          Emotion.gratitude,
          Emotion.amusement,
          Emotion.pride,
          Emotion.cheerfulness,
        ],
        EmotionColorGroup.lightGreen: [
          Emotion.gentleness,
          Emotion.freshness,
          Emotion.relief,
          Emotion.comfort
        ],
        EmotionColorGroup.green: [
          Emotion.stability,
          Emotion.disgust,
          Emotion.envy,
          Emotion.jealousy,
          Emotion.peace,
        ],
        EmotionColorGroup.cyan: [
          Emotion.curiosity,
          Emotion.anxiety,
          Emotion.indifference,
          Emotion.compassion,
        ],
        EmotionColorGroup.blue: [
          Emotion.calmness,
          Emotion.sadness,
          Emotion.composure
        ],
        EmotionColorGroup.indigo: [Emotion.awe],
        EmotionColorGroup.purple: [
          Emotion.mystery,
          Emotion.tension,
          Emotion.emptiness
        ],
        EmotionColorGroup.gray: [
          Emotion.boredom,
          Emotion.guilt,
          Emotion.confusion,
          Emotion.doubt,
          Emotion.depression,
          Emotion.loneliness,
          Emotion.apathy,
          Emotion.despair,
        ],
        EmotionColorGroup.black: [Emotion.fear, Emotion.shame, Emotion.grief],
        EmotionColorGroup.white: [Emotion.purity],
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
