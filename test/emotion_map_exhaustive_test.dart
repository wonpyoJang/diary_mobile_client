import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';

void main() {
  test('buildNameMap이 모든 Emotion 값을 포함하는지 테스트', () {
    final keys = Emotion.buildNameMap(null).keys.toSet();
    expect(keys, Emotion.values.toSet());
  });

  test('buildExplanationMap이 모든 Emotion 값을 포함하는지 테스트', () {
    final keys = Emotion.buildExplanationMap(null).keys.toSet();
    expect(keys, Emotion.values.toSet());
  });
}
