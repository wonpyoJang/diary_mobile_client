import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';

void main() {
  group('날짜 관련 로직 테스트', () {
    group('LinkedHashMap 날짜 키 동작 테스트', () {
      test('LinkedHashMap이 날짜 키를 올바르게 처리해야 함', () {
        // Given
        final map = LinkedHashMap<DateTime, List<Moment>>(
          equals: isSameDay,
          hashCode: getHashCode,
        );

        // When
        final moment1 = _createTestMoment(DateTime(2024, 3, 20, 10, 30));
        final moment2 = _createTestMoment(DateTime(2024, 3, 20, 15, 45));
        final moment3 = _createTestMoment(DateTime(2024, 3, 21));

        map[DateTime(2024, 3, 20, 10, 30)] = [moment1];
        map[DateTime(2024, 3, 20, 15, 45)] = [moment2];
        map[DateTime(2024, 3, 21)] = [moment3];

        // Then
        expect(map.length, equals(2)); // 같은 날짜는 하나로 처리
        expect(map[DateTime(2024, 3, 20)]?.length, equals(1)); // 마지막에 설정된 값
        expect(map[DateTime(2024, 3, 21)]?.length, equals(1));
      });

      test('LinkedHashMap에서 날짜 키로 값을 찾을 수 있어야 함', () {
        // Given
        final map = LinkedHashMap<DateTime, List<Moment>>(
          equals: isSameDay,
          hashCode: getHashCode,
        );

        // When
        final moment = _createTestMoment(DateTime(2024, 3, 20, 10, 30));
        final searchDate = DateTime(2024, 3, 20, 15, 45);

        map[DateTime(2024, 3, 20, 10, 30)] = [moment];

        // Then
        expect(map.containsKey(searchDate), isTrue);
        expect(map[searchDate]?.first, equals(moment));
      });
    });

    group('첫 번째 날짜 계산 로직 테스트', () {
      test('빈 리스트에서 null을 반환해야 함', () {
        // Given
        final moments = <DateTime, List<Moment>>{};

        // When
        final firstDay = _calculateFirstDay(moments);

        // Then
        expect(firstDay, isNull);
      });

      test('단일 moment에서 올바른 첫 번째 날짜를 반환해야 함', () {
        // Given
        final moment = _createTestMoment(DateTime(2024, 3, 20));
        final moments = <DateTime, List<Moment>>{
          DateTime(2024, 3, 20): [moment],
        };

        // When
        final firstDay = _calculateFirstDay(moments);

        // Then
        expect(firstDay, equals(DateTime(2024, 3, 20)));
      });

      test('여러 moment에서 가장 이른 날짜를 반환해야 함', () {
        // Given
        final moment1 = _createTestMoment(DateTime(2024, 3, 20));
        final moment2 = _createTestMoment(DateTime(2024, 3, 15));
        final moment3 = _createTestMoment(DateTime(2024, 3, 25));

        final moments = <DateTime, List<Moment>>{
          DateTime(2024, 3, 20): [moment1],
          DateTime(2024, 3, 15): [moment2],
          DateTime(2024, 3, 25): [moment3],
        };

        // When
        final firstDay = _calculateFirstDay(moments);

        // Then
        expect(firstDay, equals(DateTime(2024, 3, 15)));
      });

      test('같은 날짜의 여러 moment에서 올바른 첫 번째 날짜를 반환해야 함', () {
        // Given
        final moment1 = _createTestMoment(DateTime(2024, 3, 20));
        final moment2 = _createTestMoment(DateTime(2024, 3, 20));
        final moment3 = _createTestMoment(DateTime(2024, 3, 15));

        final moments = <DateTime, List<Moment>>{
          DateTime(2024, 3, 20): [moment1, moment2],
          DateTime(2024, 3, 15): [moment3],
        };

        // When
        final firstDay = _calculateFirstDay(moments);

        // Then
        expect(firstDay, equals(DateTime(2024, 3, 15)));
      });

      test('윤년과 평년을 올바르게 처리해야 함', () {
        // Given
        final moment1 = _createTestMoment(DateTime(2024, 2, 29)); // 윤년
        final moment2 = _createTestMoment(DateTime(2023, 3, 1)); // 평년

        final moments = <DateTime, List<Moment>>{
          DateTime(2024, 2, 29): [moment1],
          DateTime(2023, 3, 1): [moment2],
        };

        // When
        final firstDay = _calculateFirstDay(moments);

        // Then
        expect(firstDay, equals(DateTime(2023, 3, 1)));
      });
    });
  });
}

// 테스트용 Moment 객체 생성 헬퍼 함수
Moment _createTestMoment(DateTime date) {
  return Moment(
    id: 'test_id_${date.millisecondsSinceEpoch}',
    reflection: '테스트 일기 내용',
    date: date,
    modifiedAt: date,
    emotionalIntensities: const [
      EmotionalIntensity(
        emotion: Emotion.joy,
        intensity: 0.8,
      ),
    ],
    medias: const [],
  );
}

// 테스트를 위한 _calculateFirstDay 함수 (실제 구현과 동일)
DateTime? _calculateFirstDay(Map<DateTime, List<Moment>> moments) {
  if (moments.isEmpty) return null;

  DateTime? firstDay;

  // 모든 moment의 date 중 가장 이른 날짜를 찾습니다
  for (final entry in moments.entries) {
    final momentList = entry.value;

    for (final moment in momentList) {
      if (firstDay == null || moment.date.isBefore(firstDay)) {
        firstDay = moment.date;
      }
    }
  }

  return firstDay;
}
