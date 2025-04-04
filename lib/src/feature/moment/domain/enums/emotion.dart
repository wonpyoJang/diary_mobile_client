import 'dart:ui';

/// A placeholder class that represents an entity or model.

enum Emotion {
  warmth(
    color: Color(0xFFE4CAE0),
    koName: '따뜻함',
    explanation:
        '마음이 따뜻하고 포근한 느낌으로, 마치 겨울날 따뜻한 이불 속에 들어가 있는 듯한 안락함을 주는 감정입니다. 이 감정은 사람들 간의 친밀함과 사랑을 느낄 때 자주 경험됩니다.',
  ),
  happiness(
    color: Color(0xFFD7E5CD),
    koName: '행복',
    explanation:
        '기쁘고 만족스러운 상태로, 삶의 작은 순간들에서 오는 기쁨과 성취감을 느낄 때 경험하는 감정입니다. 이 감정은 긍정적인 에너지를 주고 삶의 질을 높여줍니다.',
  ),
  calmness(
    color: Color(0xFFB5BDFA),
    koName: '평온',
    explanation:
        '마음이 차분하고 안정된 상태로, 외부의 소음과 스트레스로부터 벗어나 내면의 평화를 찾았을 때 느끼는 감정입니다. 명상이나 자연 속에서 자주 경험할 수 있습니다.',
  ),
  hope(
    color: Color(0xFFDFECB4),
    koName: '희망',
    explanation:
        '미래에 대한 긍정적인 기대감으로, 어려운 상황에서도 더 나은 내일을 꿈꾸며 앞으로 나아갈 수 있는 힘을 주는 감정입니다. 희망은 삶의 원동력이 됩니다.',
  ),
  mystery(
    color: Color(0xFFE9E1FD),
    koName: '신비',
    explanation:
        '알 수 없는 신비로운 느낌으로, 미지의 세계에 대한 호기심과 경이로움을 느낄 때 경험하는 감정입니다. 이 감정은 상상력을 자극하고 창의성을 높여줍니다.',
  ),
  stability(
    color: Color(0xFFEDEBEB),
    koName: '안정',
    explanation:
        '안정적이고 변함없는 상태로, 삶의 기반이 튼튼하고 예측 가능한 상황에서 느끼는 감정입니다. 안정은 심리적 안전감을 주고 스트레스를 줄여줍니다.',
  ),
  gentleness(
    color: Color(0xFFFBE6CF),
    koName: '부드러움',
    explanation:
        '부드럽고 온화한 느낌으로, 타인에게 친절하고 배려할 때 느끼는 감정입니다. 이 감정은 인간관계를 부드럽게 하고 상호 이해를 높여줍니다.',
  ),
  freshness(
    color: Color(0xFFCCF2F2),
    koName: '신선함',
    explanation:
        '새롭고 상쾌한 느낌으로, 새로운 시작이나 변화의 순간에 느끼는 감정입니다. 신선함은 활력을 주고 일상에 활기를 불어넣습니다.',
  ),
  boredom(
    color: Color(0xFFD3D3D3),
    koName: '지루함',
    explanation:
        '흥미가 없고 지루한 상태로, 반복적이고 단조로운 상황에서 자주 느끼는 감정입니다. 이 감정은 새로운 자극을 찾고자 하는 동기를 부여할 수 있습니다.',
  ),
  anger(
    color: Color(0xFFFF0000),
    koName: '분노',
    explanation:
        '화가 나고 격분한 상태로, 부당한 대우나 불공평한 상황에서 자주 느끼는 감정입니다. 분노는 때로는 변화를 위한 강력한 동기가 될 수 있습니다.',
  ),
  excitement(
    color: Color(0xFFEDDBA0),
    koName: '흥분',
    explanation:
        '기대감에 가득 차고 활기찬 상태로, 특별한 이벤트나 성취를 앞두고 느끼는 감정입니다. 흥분은 에너지를 높이고 긍정적인 행동을 촉진합니다.',
  ),
  sadness(
    color: Color(0xFFBAC8D4),
    koName: '슬픔',
    explanation:
        '마음이 아프고 우울한 상태로, 상실이나 실망을 경험할 때 느끼는 감정입니다. 슬픔은 감정의 깊이를 이해하고 공감을 높이는 데 도움을 줍니다.',
  ),
  fear(
    color: Color(0xFF800080),
    koName: '두려움',
    explanation:
        '무섭고 불안한 느낌으로, 위험이나 위협을 감지할 때 느끼는 감정입니다. 두려움은 생존 본능을 자극하고 위험을 피하는 데 도움을 줍니다.',
  ),
  surprise(
    color: Color(0xFFFFFF00),
    koName: '놀라움',
    explanation:
        '예상치 못한 일에 대한 놀라운 반응으로, 긍정적이거나 부정적인 사건에 대해 즉각적으로 느끼는 감정입니다. 놀라움은 주의를 집중시키고 학습을 촉진합니다.',
  ),
  disgust(
    color: Color(0xFF008000),
    koName: '혐오',
    explanation:
        '싫고 불쾌한 느낌으로, 불쾌한 상황이나 물질에 대한 반응으로 나타나는 감정입니다. 혐오는 건강과 안전을 지키기 위한 본능적인 반응입니다.',
  ),
  love(
    color: Color(0xFFFFC0CB),
    koName: '사랑',
    explanation:
        '깊은 애정과 애착의 감정으로, 타인과의 친밀한 관계에서 느끼는 감정입니다. 사랑은 인간관계를 강화하고 삶의 의미를 부여합니다.',
  ),
  pride(
    color: Color(0xFFDAA520),
    koName: '자부심',
    explanation:
        '자신에 대한 긍정적인 자부심으로, 성취나 능력에 대한 만족감을 느낄 때 경험하는 감정입니다. 자부심은 자신감을 높이고 도전을 장려합니다.',
  ),
  shame(
    color: Color(0xFF8B0000),
    koName: '수치심',
    explanation:
        '부끄럽고 창피한 느낌으로, 사회적 규범을 위반했을 때 느끼는 감정입니다. 수치심은 행동을 반성하고 개선하는 데 도움을 줍니다.',
  ),
  guilt(
    color: Color(0xFF808080),
    koName: '죄책감',
    explanation:
        '잘못에 대한 후회와 책임감으로, 타인에게 해를 끼쳤을 때 느끼는 감정입니다. 죄책감은 도덕적 성찰을 촉진하고 관계 회복을 도모합니다.',
  ),
  envy(
    color: Color(0xFF00FF00),
    koName: '부러움',
    explanation:
        '다른 사람의 것을 갖고 싶어하는 마음으로, 타인의 성공이나 소유물을 부러워할 때 느끼는 감정입니다. 부러움은 동기 부여의 원천이 될 수 있습니다.',
  ),
  jealousy(
    color: Color(0xFF7FFF00),
    koName: '질투',
    explanation:
        '다른 사람의 성공이나 행복에 대한 질투로, 자신이 소중히 여기는 것을 잃을까 두려워할 때 느끼는 감정입니다. 질투는 관계를 보호하려는 본능적 반응입니다.',
  ),
  contentment(
    color: Color(0xFFECCEAA),
    koName: '만족',
    explanation:
        '현재 상태에 대한 만족감으로, 삶의 균형과 조화를 이룬 상태에서 느끼는 감정입니다. 만족은 심리적 안정감을 주고 스트레스를 줄여줍니다.',
  ),
  gratitude(
    color: Color(0xFFFFD700),
    koName: '감사',
    explanation:
        '고마운 마음과 감사의 표현으로, 타인의 도움이나 호의에 대해 느끼는 감정입니다. 감사는 긍정적인 관계를 형성하고 행복감을 증진시킵니다.',
  ),
  nostalgia(
    color: Color(0xFFFAF0E6),
    koName: '향수',
    explanation:
        '과거에 대한 그리움과 회상으로, 어린 시절이나 특별한 순간을 떠올릴 때 느끼는 감정입니다. 향수는 과거의 경험을 소중히 여기고 현재를 풍요롭게 합니다.',
  ),
  loneliness(
    color: Color(0xFF708090),
    koName: '외로움',
    explanation:
        '혼자라는 느낌과 고독감으로, 사회적 연결이 부족할 때 느끼는 감정입니다. 외로움은 사회적 관계의 중요성을 일깨우고 새로운 연결을 찾도록 자극합니다.',
  ),
  frustration(
    color: Color(0xFFFF6347),
    koName: '좌절',
    explanation:
        '목표에 도달하지 못한 실망감으로, 노력에도 불구하고 원하는 결과를 얻지 못할 때 느끼는 감정입니다. 좌절은 새로운 전략을 모색하고 성장의 기회를 제공합니다.',
  ),
  awe(
    color: Color(0xFF4682B4),
    koName: '경외',
    explanation:
        '위대함에 대한 경외심으로, 자연의 경이로움이나 인간의 위대한 업적을 마주할 때 느끼는 감정입니다. 경외는 겸손함을 일깨우고 영감을 줍니다.',
  ),
  amusement(
    color: Color(0xFFFFE4B5),
    koName: '즐거움',
    explanation:
        '재미있고 즐거운 상태로, 유머나 오락을 통해 느끼는 감정입니다. 즐거움은 스트레스를 해소하고 긍정적인 에너지를 제공합니다.',
  ),
  relief(
    color: Color(0xFF98FB98),
    koName: '안도',
    explanation:
        '걱정이 사라지고 편안한 상태로, 긴장된 상황이 해결되었을 때 느끼는 감정입니다. 안도는 심리적 안정감을 주고 긍정적인 변화를 촉진합니다.',
  ),
  curiosity(
    color: Color(0xFFAFEEEE),
    koName: '호기심',
    explanation:
        '새로운 것에 대한 관심과 탐구심으로, 미지의 세계를 탐험하고자 할 때 느끼는 감정입니다. 호기심은 학습과 발견의 원동력이 됩니다.',
  ),
  desire(
    color: Color(0xFFFF4500),
    koName: '욕망',
    explanation:
        '무언가를 강하게 원하고 바라는 감정으로, 목표를 향해 나아가고자 하는 동기를 제공합니다. 욕망은 개인의 성취와 발전을 촉진합니다.',
  ),
  confusion(
    color: Color(0xFFB0C4DE),
    koName: '혼란',
    explanation:
        '상황이나 정보가 명확하지 않아 이해하기 어려운 상태로, 여러 가지 가능성이나 모순된 정보로 인해 느끼는 감정입니다. 혼란은 문제 해결을 위한 새로운 접근 방식을 모색하게 합니다.',
  ),
  doubt(
    color: Color(0xFF808080),
    koName: '의심',
    explanation:
        '불확실한 상황이나 정보에 대한 의심으로, 믿을 수 없는 상황을 마주할 때 느끼는 감정입니다. 의심은 주의를 집중시키고 논리적 사고를 촉진합니다.',
  ),
  comfort(
    color: Color(0xFFE4CAE0),
    koName: '편안',
    explanation:
        '마음이 편안하고 안정된 상태로, 스트레스와 걱정에서 벗어나 평온함을 느낄 때 경험하는 감정입니다. 편안함은 심리적 안정감을 주고 삶의 질을 높여줍니다.',
  ),
  joy(
    color: Color(0xFFD7E5CD),
    koName: '기쁨',
    explanation:
        '기쁘고 즐거운 상태로, 좋은 일이나 성취를 경험할 때 느끼는 감정입니다. 기쁨은 긍정적인 에너지를 주고 삶의 활력을 높여줍니다.',
  ),
  affection(
    color: Color(0xFFE8C8C3),
    koName: '애정',
    explanation:
        '깊은 애정과 애착의 감정으로, 타인과의 친밀한 관계에서 느끼는 감정입니다. 애정은 인간관계를 강화하고 삶의 의미를 부여합니다.',
  ),
  excitementNew(
    color: Color(0xFFEDDBA0),
    koName: '신남',
    explanation:
        '기대감에 가득 차고 활기찬 상태로, 특별한 이벤트나 성취를 앞두고 느끼는 감정입니다. 신남은 에너지를 높이고 긍정적인 행동을 촉진합니다.',
  ),
  anxiety(
    color: Color(0xFFCAE1E0),
    koName: '불안',
    explanation:
        '무섭고 불안한 느낌으로, 위험이나 위협을 감지할 때 느끼는 감정입니다. 불안은 생존 본능을 자극하고 위험을 피하는 데 도움을 줍니다.',
  ),
  tension(
    color: Color(0xFFC4BAD8),
    koName: '긴장',
    explanation:
        '긴장되고 불안한 상태로, 중요한 일이나 도전에 직면할 때 느끼는 감정입니다. 긴장은 주의를 집중시키고 문제 해결을 촉진합니다.',
  ),
  depression(
    color: Color(0xFFCBCBCB),
    koName: '우울',
    explanation:
        '마음이 아프고 우울한 상태로, 상실이나 실망을 경험할 때 느끼는 감정입니다. 우울은 감정의 깊이를 이해하고 공감을 높이는 데 도움을 줍니다.',
  );

  final Color color;
  final String koName;
  final String explanation;

  const Emotion(
      {required this.color, required this.koName, required this.explanation});

  static Emotion findByName(String name) {
    return Emotion.values.firstWhere((emotion) => emotion.name == name,
        orElse: () => throw ArgumentError('Invalid emotion name: $name'));
  }
}
