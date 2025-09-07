import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';

void main() {
  group('날짜 해시코드 테스트', () {
    test('getHashCode가 올바른 해시코드를 생성해야 함', () {
      // Given
      final date1 = DateTime(2024, 1, 15); // 2024년 1월 15일
      final date2 = DateTime(2024, 12, 31); // 2024년 12월 31일
      final date3 = DateTime(2023, 6, 1); // 2023년 6월 1일

      // When
      final hash1 = getHashCode(date1);
      final hash2 = getHashCode(date2);
      final hash3 = getHashCode(date3);

      // Then
      expect(hash1, equals(15 * 1000000 + 1 * 10000 + 2024));
      expect(hash1, equals(15012024));

      expect(hash2, equals(31 * 1000000 + 12 * 10000 + 2024));
      expect(hash2, equals(31122024));

      expect(hash3, equals(1 * 1000000 + 6 * 10000 + 2023));
      expect(hash3, equals(1062023));
    });

    test('같은 날짜는 같은 해시코드를 가져야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2024, 3, 20);

      // When
      final hash1 = getHashCode(date1);
      final hash2 = getHashCode(date2);

      // Then
      expect(hash1, equals(hash2));
    });

    test('시간이 다른 같은 날짜는 같은 해시코드를 가져야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20, 10, 30, 45);
      final date2 = DateTime(2024, 3, 20, 23, 59, 59);

      // When
      final hash1 = getHashCode(date1);
      final hash2 = getHashCode(date2);

      // Then
      expect(hash1, equals(hash2));
    });
  });

  group('isSameDay 테스트', () {
    test('같은 날짜는 true를 반환해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20, 10, 30);
      final date2 = DateTime(2024, 3, 20, 15, 45);

      // When & Then
      expect(isSameDay(date1, date2), isTrue);
    });

    test('다른 날짜는 false를 반환해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2024, 3, 21);

      // When & Then
      expect(isSameDay(date1, date2), isFalse);
    });

    test('다른 월은 false를 반환해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2024, 4, 20);

      // When & Then
      expect(isSameDay(date1, date2), isFalse);
    });

    test('다른 년도는 false를 반환해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2023, 3, 20);

      // When & Then
      expect(isSameDay(date1, date2), isFalse);
    });

    test('윤년과 평년의 같은 날짜는 false를 반환해야 함', () {
      // Given
      final date1 = DateTime(2024, 2, 29); // 윤년
      final date2 = DateTime(2023, 2, 29); // 평년 (존재하지 않는 날짜)

      // When & Then
      expect(isSameDay(date1, date2), isFalse);
    });
  });

  group('LinkedHashMap 날짜 키 테스트', () {
    test('LinkedHashMap이 날짜 키를 올바르게 처리해야 함', () {
      // Given
      final map = LinkedHashMap<DateTime, String>(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      // When
      final date1 = DateTime(2024, 3, 20, 10, 30);
      final date2 = DateTime(2024, 3, 20, 15, 45);
      final date3 = DateTime(2024, 3, 21);

      map[date1] = "첫 번째 값";
      map[date2] = "두 번째 값";
      map[date3] = "세 번째 값";

      // Then
      expect(map.length, equals(2)); // date1과 date2는 같은 날짜
      expect(map[date1], equals("두 번째 값")); // 마지막에 설정된 값
      expect(map[date3], equals("세 번째 값"));
    });

    test('LinkedHashMap에서 날짜 키로 값을 찾을 수 있어야 함', () {
      // Given
      final map = LinkedHashMap<DateTime, String>(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      // When
      final originalDate = DateTime(2024, 3, 20, 10, 30);
      final searchDate = DateTime(2024, 3, 20, 15, 45);

      map[originalDate] = "테스트 값";

      // Then
      expect(map.containsKey(searchDate), isTrue);
      expect(map[searchDate], equals("테스트 값"));
    });

    test('LinkedHashMap에서 날짜 키를 제거할 수 있어야 함', () {
      // Given
      final map = LinkedHashMap<DateTime, String>(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      // When
      final date1 = DateTime(2024, 3, 20, 10, 30);
      final date2 = DateTime(2024, 3, 20, 15, 45);

      map[date1] = "테스트 값";
      map.remove(date2);

      // Then
      expect(map.isEmpty, isTrue);
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

  group('날짜 범위 테스트', () {
    test('날짜 범위가 올바르게 계산되어야 함', () {
      // Given
      final startDate = DateTime(2024, 3, 1);
      final endDate = DateTime(2024, 3, 31);

      // When
      final daysInRange = endDate.difference(startDate).inDays + 1;

      // Then
      expect(daysInRange, equals(31));
    });

    test('월 경계를 넘는 날짜 범위가 올바르게 계산되어야 함', () {
      // Given
      final startDate = DateTime(2024, 3, 30);
      final endDate = DateTime(2024, 4, 2);

      // When
      final daysInRange = endDate.difference(startDate).inDays + 1;

      // Then
      expect(daysInRange, equals(4));
    });

    test('윤년의 2월이 올바르게 처리되어야 함', () {
      // Given
      final startDate = DateTime(2024, 2, 1);
      final endDate = DateTime(2024, 2, 29);

      // When
      final daysInRange = endDate.difference(startDate).inDays + 1;

      // Then
      expect(daysInRange, equals(29)); // 2024년은 윤년
    });

    test('평년의 2월이 올바르게 처리되어야 함', () {
      // Given
      final startDate = DateTime(2023, 2, 1);
      final endDate = DateTime(2023, 2, 28);

      // When
      final daysInRange = endDate.difference(startDate).inDays + 1;

      // Then
      expect(daysInRange, equals(28)); // 2023년은 평년
    });
  });

  group('날짜 비교 연산 테스트', () {
    test('isBefore가 올바르게 작동해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2024, 3, 21);

      // When & Then
      expect(date1.isBefore(date2), isTrue);
      expect(date2.isBefore(date1), isFalse);
    });

    test('isAfter가 올바르게 작동해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20);
      final date2 = DateTime(2024, 3, 21);

      // When & Then
      expect(date2.isAfter(date1), isTrue);
      expect(date1.isAfter(date2), isFalse);
    });

    test('isAtSameMomentAs가 올바르게 작동해야 함', () {
      // Given
      final date1 = DateTime(2024, 3, 20, 10, 30, 45, 123);
      final date2 = DateTime(2024, 3, 20, 10, 30, 45, 123);

      // When & Then
      expect(date1.isAtSameMomentAs(date2), isTrue);
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
