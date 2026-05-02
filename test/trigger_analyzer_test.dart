import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/services/trigger_analyzer.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/trigger_stat.dart';
import 'package:flutter_test/flutter_test.dart';

MomentValenceSample _s(String text, TriggerValence v) =>
    MomentValenceSample(reflection: text, valence: v);

void main() {
  group('TriggerAnalyzer.analyze', () {
    test('빈 입력은 빈 결과를 반환한다', () {
      const analyzer = TriggerAnalyzer();
      expect(analyzer.analyze(const []), isEmpty);
    });

    test('minOccurrences 미만으로 등장한 키워드는 제외된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 3);
      // "회사" 가 2번만 등장 → 임계치 3 미만이므로 결과에 없어야 함.
      final result = analyzer.analyze([
        _s('오늘 회사에서 힘들었다', TriggerValence.negative),
        _s('회사 점심이 맛있었다', TriggerValence.positive),
      ]);
      expect(result, isEmpty);
    });

    test('동일 일기 내 반복은 1회로만 카운트된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 1);
      // "회사" 가 한 일기에서 3번 나와도 1로 카운트 → totalCount = 1.
      final result = analyzer.analyze([
        _s('회사 회사 회사', TriggerValence.negative),
      ]);
      final company = result.firstWhere((e) => e.keyword == '회사');
      expect(company.totalCount, 1);
    });

    test('우세 valence 와 비율이 정확하게 계산된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 3);
      final result = analyzer.analyze([
        _s('오늘 회사 일이 많았다', TriggerValence.negative),
        _s('회사 회의 너무 길었다', TriggerValence.negative),
        _s('회사 동료가 도와줬다', TriggerValence.negative),
        _s('회사 동료와 점심', TriggerValence.positive),
      ]);
      final company = result.firstWhere((e) => e.keyword == '회사');
      expect(company.totalCount, 4);
      expect(company.negativeCount, 3);
      expect(company.positiveCount, 1);
      expect(company.dominantValence, TriggerValence.negative);
      expect(company.negativeRatio, closeTo(0.75, 1e-9));
    });

    test('stopword 는 결과에서 제외된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 1);
      final result = analyzer.analyze([
        _s('오늘 그리고 그래서', TriggerValence.neutral),
      ]);
      expect(result.any((e) => e.keyword == '오늘'), isFalse);
      expect(result.any((e) => e.keyword == '그리고'), isFalse);
      expect(result.any((e) => e.keyword == '그래서'), isFalse);
    });

    test('한 글자 토큰은 minTokenLength 로 차단된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 1, minTokenLength: 2);
      final result = analyzer.analyze([
        _s('a 가 나 다 라', TriggerValence.neutral),
      ]);
      expect(result, isEmpty);
    });

    test('영문은 소문자로 정규화된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 2);
      final result = analyzer.analyze([
        _s('Coffee was great', TriggerValence.positive),
        _s('coffee with mom', TriggerValence.positive),
      ]);
      expect(result.any((e) => e.keyword == 'coffee'), isTrue);
      // 'Coffee' 와 'coffee' 가 별개로 잡히면 totalCount=1 이 되어
      // minOccurrences=2 에 걸려 빠진다 — 통합되어야 totalCount=2.
      final coffee = result.firstWhere((e) => e.keyword == 'coffee');
      expect(coffee.totalCount, 2);
    });

    test('숫자만으로 이루어진 토큰은 제외된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 1);
      final result = analyzer.analyze([
        _s('123 456 789', TriggerValence.neutral),
      ]);
      expect(result, isEmpty);
    });

    test('maxResults 로 결과 개수가 제한된다', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 1, maxResults: 2);
      final result = analyzer.analyze([
        _s('알파 베타 감마 델타 입실론', TriggerValence.positive),
      ]);
      expect(result.length, 2);
    });

    test('정렬: 우세 비율 내림차순, 동률이면 totalCount 내림차순', () {
      const analyzer = TriggerAnalyzer(minOccurrences: 2, maxResults: 10);
      // 'aaaa' 는 100% positive (2/2)
      // 'bbbb' 는 67% positive (2/3)
      // 'cccc' 는 100% positive (3/3)
      final result = analyzer.analyze([
        _s('aaaa cccc', TriggerValence.positive),
        _s('aaaa cccc', TriggerValence.positive),
        _s('bbbb cccc', TriggerValence.positive),
        _s('bbbb', TriggerValence.positive),
        _s('bbbb', TriggerValence.negative),
      ]);
      // 100% 가 두 개 (cccc, aaaa) → totalCount 큰 cccc 가 먼저.
      expect(result[0].keyword, 'cccc');
      expect(result[1].keyword, 'aaaa');
      expect(result[2].keyword, 'bbbb');
    });
  });
}
