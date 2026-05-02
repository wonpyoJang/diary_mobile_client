import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/trigger_stat.dart';

/// 감정 트리거 분석에 사용되는 단일 일기 샘플.
/// 본문(reflection)과 그 일기의 우세 valence(긍정/부정/중립).
class MomentValenceSample {
  final String reflection;
  final TriggerValence valence;

  const MomentValenceSample({
    required this.reflection,
    required this.valence,
  });
}

/// 본문에서 키워드를 추출하고 감정과의 상관관계를 계산한다.
/// 모든 처리는 온디바이스(순수 함수, 외부 의존성 없음)에서 일어난다.
class TriggerAnalyzer {
  /// 키워드 토큰화에 사용하는 구분자 (공백 + 한글/영문 문장부호).
  static final RegExp _separator = RegExp(
    r'''[\s,.!?()\[\]{}"'`~@#$%^&*+=:;|<>/\\\-—–…·、。「」『』《》〈〉？！，．：；‘’“”]+''',
  );

  /// 너무 흔하거나 의미 없는 한국어/영어 표현. 트리거 후보에서 제외한다.
  /// 형태소 분석기를 쓰지 않으므로 어휘 단위 stopword 만 차단한다.
  static const Set<String> _stopwords = {
    // 한국어 — 대명사/지시어/시간/접속사/감탄
    '나는', '내가', '나의', '나를', '나도', '저는', '저의', '저를',
    '우리', '우리는', '우리가', '우리의',
    '너는', '너의', '너를', '너도', '당신', '그대',
    '그는', '그가', '그녀', '그녀는', '그녀가',
    '오늘', '어제', '내일', '지금', '아까', '방금', '요즘', '최근',
    '여기', '저기', '거기', '이곳', '그곳',
    '그리고', '그러나', '그래서', '하지만', '그런데', '따라서',
    '또한', '또는', '혹은', '그냥', '그저', '진짜', '정말', '너무', '아주', '매우',
    '많이', '조금', '약간', '계속', '항상', '자주', '가끔',
    '같은', '같이', '같다', '같아', '이런', '저런', '그런',
    '있는', '있다', '있어', '없는', '없다', '없어',
    '하는', '하다', '한다', '했다', '했어', '하면',
    '되는', '되다', '된다', '됐다', '됐어',
    '대한', '관한', '위한', '통해',
    '아니', '아니다', '아니라', '아닌',
    '입니다', '습니다', '입니까',
    // 영어 — 흔한 stopword
    'the', 'and', 'but', 'or', 'so', 'for', 'to', 'of', 'in', 'on', 'at',
    'is', 'am', 'are', 'was', 'were', 'be', 'been', 'being',
    'an', 'this', 'that', 'these', 'those',
    'me', 'my', 'we', 'our', 'you', 'your', 'he', 'she', 'they',
    'it', 'its', 'as', 'by', 'with', 'from', 'not', 'no',
    'do', 'does', 'did', 'have', 'has', 'had',
    'will', 'would', 'can', 'could', 'should',
    'just', 'really', 'very', 'too', 'also', 'still',
    'today', 'yesterday', 'tomorrow', 'now',
  };

  /// 노출 임계치: 등장한 일기 수가 이 값 미만이면 결과에서 제외.
  /// 표본 수가 적으면 통계적 의미가 없고 사용자 프라이버시 측면에서도 노출 회피.
  final int minOccurrences;

  /// 결과 상한.
  final int maxResults;

  /// 단어 최소 길이 (자/영문자 수). 한 글자 토큰은 노이즈가 많아 제외.
  final int minTokenLength;

  const TriggerAnalyzer({
    this.minOccurrences = 3,
    this.maxResults = 10,
    this.minTokenLength = 2,
  });

  /// 샘플들을 받아 키워드별 감정 분포를 계산한다.
  /// 정렬: 우세 valence 비율 내림차순 → totalCount 내림차순.
  List<TriggerStat> analyze(List<MomentValenceSample> samples) {
    if (samples.isEmpty) return const [];

    final agg = <String, _Bucket>{};
    for (final sample in samples) {
      final tokens = _tokenize(sample.reflection);
      // 같은 일기 내에서 같은 단어가 여러 번 나와도 1회만 카운트(일기 단위 빈도).
      for (final token in tokens) {
        final bucket = agg.putIfAbsent(token, _Bucket.new);
        bucket.bump(sample.valence);
      }
    }

    final stats = <TriggerStat>[];
    agg.forEach((keyword, bucket) {
      if (bucket.total < minOccurrences) return;
      stats.add(TriggerStat(
        keyword: keyword,
        totalCount: bucket.total,
        positiveCount: bucket.positive,
        negativeCount: bucket.negative,
        neutralCount: bucket.neutral,
      ));
    });

    stats.sort((a, b) {
      final byRatio = b.dominantRatio.compareTo(a.dominantRatio);
      if (byRatio != 0) return byRatio;
      return b.totalCount.compareTo(a.totalCount);
    });

    if (stats.length <= maxResults) return stats;
    return stats.sublist(0, maxResults);
  }

  Set<String> _tokenize(String text) {
    if (text.isEmpty) return const {};
    final lowered = text.toLowerCase();
    final raw = lowered.split(_separator);
    final result = <String>{};
    for (final t in raw) {
      if (t.length < minTokenLength) continue;
      if (_isAllDigits(t)) continue;
      if (_stopwords.contains(t)) continue;
      result.add(t);
    }
    return result;
  }

  bool _isAllDigits(String s) {
    for (final code in s.codeUnits) {
      if (code < 0x30 || code > 0x39) return false;
    }
    return true;
  }
}

class _Bucket {
  int positive = 0;
  int negative = 0;
  int neutral = 0;

  int get total => positive + negative + neutral;

  void bump(TriggerValence v) {
    switch (v) {
      case TriggerValence.positive:
        positive++;
        break;
      case TriggerValence.negative:
        negative++;
        break;
      case TriggerValence.neutral:
        neutral++;
        break;
    }
  }
}
