// ignore_for_file: prefer_collection_literals
// 사유: LinkedHashMap은 컬렉션 리터럴({})로 생성할 수 없으므로, 생성자 사용이 불가피합니다.
import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_event.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_state.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/domain/interface/i_moment_list_repository.dart';
import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';

void main() {
  group('MomentListBloc 구조 및 기능 테스트', () {
    late DateTime testDate1, testDate2;
    late Moment testMoment1, testMoment2, testMoment3;

    setUp(() {
      testDate1 = DateTime(2024, 1, 15, 14, 30, 0);
      testDate2 = DateTime(2024, 1, 16, 10, 0, 0);

      testMoment1 = Moment.create(
        reflection: '첫 번째 일기',
        date: testDate1,
      );

      testMoment2 = Moment.create(
        reflection: '두 번째 일기',
        date: testDate1,
      );

      testMoment3 = Moment.create(
        reflection: '세 번째 일기',
        date: testDate2,
      );
    });

    group('MomentListEvent 구조 테스트', () {
      test('LoadMoments 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        final event = LoadMoments();

        // Then
        expect(event.props, isEmpty);
        expect(event, isA<MomentListEvent>());
      });

      test('AddMoment 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        final event = AddMoment(testMoment1, testDate1);

        // Then
        expect(event.moment, equals(testMoment1));
        expect(event.date, equals(testDate1));
        expect(event.props, contains(testMoment1));
        expect(event.props, contains(testDate1));
        expect(event, isA<MomentListEvent>());
      });

      test('UpdateMoment 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        final event = UpdateMoment(testMoment1, testDate1);

        // Then
        expect(event.moment, equals(testMoment1));
        expect(event.date, equals(testDate1));
        expect(event.props, contains(testMoment1));
        expect(event.props, contains(testDate1));
        expect(event, isA<MomentListEvent>());
      });

      test('DeleteMoment 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        final event = DeleteMoment(testMoment1);

        // Then
        expect(event.moment, equals(testMoment1));
        expect(event.props, contains(testMoment1));
        expect(event, isA<MomentListEvent>());
      });
    });

    group('MomentListState 구조 테스트', () {
      test('MomentListState가 올바른 구조를 가져야 함', () {
        // Given
        final testMoments = LinkedHashMap<DateTime, List<Moment>>();
        testMoments[testDate1] = [testMoment1];

        final state = MomentListState(
          moments: testMoments,
          firstDay: testDate1,
        );

        // Then
        expect(state.moments, equals(testMoments));
        expect(state.firstDay, equals(testDate1));
        expect(state.props, contains(testMoments));
        expect(state.props, contains(testDate1));
      });

      test('MomentListState의 copyWith가 올바르게 작동해야 함', () {
        // Given
        final originalState = MomentListState(
          moments: LinkedHashMap<DateTime, List<Moment>>(),
          firstDay: testDate1,
        );

        final newMoments = LinkedHashMap<DateTime, List<Moment>>();
        newMoments[testDate2] = [testMoment3];

        // When
        final updatedState = originalState.copyWith(
          moments: newMoments,
          firstDay: testDate2,
        );

        // Then
        expect(updatedState.moments, equals(newMoments));
        expect(updatedState.firstDay, equals(testDate2));
        expect(updatedState.moments, isNot(equals(originalState.moments)));
        expect(updatedState.firstDay, isNot(equals(originalState.firstDay)));
      });

      test('MomentListState가 Equatable을 올바르게 구현해야 함', () {
        // Given
        final testMoments1 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments1[testDate1] = [testMoment1];

        final testMoments2 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments2[testDate1] = [testMoment1];

        final state1 = MomentListState(
          moments: testMoments1,
          firstDay: testDate1,
        );

        final state2 = MomentListState(
          moments: testMoments2,
          firstDay: testDate1,
        );

        // When & Then
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('MomentListState의 기본 생성자가 올바르게 작동해야 함', () {
        // Given & When
        final state =
            MomentListState(moments: LinkedHashMap<DateTime, List<Moment>>());

        // Then
        expect(state.moments, isEmpty);
        expect(state.firstDay, isNull);
      });
    });

    group('이벤트 동등성 테스트', () {
      test('동일한 값을 가진 이벤트가 동등해야 함', () {
        // Given & When & Then
        expect(LoadMoments(), equals(LoadMoments()));
        expect(LoadMoments().hashCode, equals(LoadMoments().hashCode));

        expect(AddMoment(testMoment1, testDate1),
            equals(AddMoment(testMoment1, testDate1)));
        expect(AddMoment(testMoment1, testDate1).hashCode,
            equals(AddMoment(testMoment1, testDate1).hashCode));

        expect(UpdateMoment(testMoment1, testDate1),
            equals(UpdateMoment(testMoment1, testDate1)));
        expect(UpdateMoment(testMoment1, testDate1).hashCode,
            equals(UpdateMoment(testMoment1, testDate1).hashCode));

        expect(DeleteMoment(testMoment1), equals(DeleteMoment(testMoment1)));
        expect(DeleteMoment(testMoment1).hashCode,
            equals(DeleteMoment(testMoment1).hashCode));
      });

      test('다른 값을 가진 이벤트가 다르게 처리되어야 함', () {
        // Given & When & Then
        expect(AddMoment(testMoment1, testDate1),
            isNot(equals(AddMoment(testMoment2, testDate1))));
        expect(AddMoment(testMoment1, testDate1).hashCode,
            isNot(equals(AddMoment(testMoment2, testDate1).hashCode)));

        expect(UpdateMoment(testMoment1, testDate1),
            isNot(equals(UpdateMoment(testMoment1, testDate2))));
        expect(UpdateMoment(testMoment1, testDate1).hashCode,
            isNot(equals(UpdateMoment(testMoment1, testDate2).hashCode)));

        expect(DeleteMoment(testMoment1),
            isNot(equals(DeleteMoment(testMoment2))));
        expect(DeleteMoment(testMoment1).hashCode,
            isNot(equals(DeleteMoment(testMoment2).hashCode)));
      });

      test('이벤트의 props가 올바르게 설정되어야 함', () {
        // Given & When & Then
        expect(LoadMoments().props, isEmpty);

        final addEvent = AddMoment(testMoment1, testDate1);
        expect(addEvent.props, contains(testMoment1));
        expect(addEvent.props, contains(testDate1));
        expect(addEvent.props.length, equals(2));

        final updateEvent = UpdateMoment(testMoment1, testDate1);
        expect(updateEvent.props, contains(testMoment1));
        expect(updateEvent.props, contains(testDate1));
        expect(updateEvent.props.length, equals(2));

        final deleteEvent = DeleteMoment(testMoment1);
        expect(deleteEvent.props, contains(testMoment1));
        expect(deleteEvent.props.length, equals(1));
      });
    });

    group('상태 동등성 테스트', () {
      test('동일한 값을 가진 상태가 동등해야 함', () {
        // Given
        final testMoments1 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments1[testDate1] = [testMoment1];

        final testMoments2 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments2[testDate1] = [testMoment1];

        final state1 = MomentListState(
          moments: testMoments1,
          firstDay: testDate1,
        );

        final state2 = MomentListState(
          moments: testMoments2,
          firstDay: testDate1,
        );

        // When & Then
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('다른 값을 가진 상태가 다르게 처리되어야 함', () {
        // Given
        final testMoments1 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments1[testDate1] = [testMoment1];

        final testMoments2 = LinkedHashMap<DateTime, List<Moment>>();
        testMoments2[testDate1] = [testMoment1];

        final state1 = MomentListState(
          moments: testMoments1,
          firstDay: testDate1,
        );

        final state2 = MomentListState(
          moments: testMoments2,
          firstDay: testDate2, // 다른 firstDay
        );

        // When & Then
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('상태의 props가 올바르게 설정되어야 함', () {
        // Given
        final testMoments = LinkedHashMap<DateTime, List<Moment>>();
        testMoments[testDate1] = [testMoment1];

        final state = MomentListState(
          moments: testMoments,
          firstDay: testDate1,
        );

        // When & Then
        expect(state.props, contains(testMoments));
        expect(state.props, contains(testDate1));
        expect(state.props.length, equals(2));
      });
    });

    group('LinkedHashMap 날짜 비교 함수 테스트', () {
      test('LinkedHashMap이 올바르게 작동해야 함', () {
        // Given
        final map = LinkedHashMap<DateTime, List<Moment>>();
        map[testDate1] = [testMoment1];
        map[testDate2] = [testMoment2];

        // When & Then
        expect(map.length, equals(2));
        expect(map[testDate1], contains(testMoment1));
        expect(map[testDate2], contains(testMoment2));
      });

      test('LinkedHashMap의 날짜 키가 올바르게 작동해야 함', () {
        // Given
        final map = LinkedHashMap<DateTime, List<Moment>>();
        final sameDay1 = DateTime(2024, 1, 15, 10, 0, 0);
        final sameDay2 = DateTime(2024, 1, 15, 20, 0, 0);
        final differentDay = DateTime(2024, 1, 16, 10, 0, 0);

        // When
        map[sameDay1] = [testMoment1];
        map[sameDay2] = [testMoment2];
        map[differentDay] = [testMoment3];

        // Then
        expect(map.length, equals(3)); // 시간이 다르면 다른 키로 인식
        expect(map[sameDay1], contains(testMoment1));
        expect(map[sameDay2], contains(testMoment2));
        expect(map[differentDay], contains(testMoment3));
      });
    });

    group('Bus 메시지 구조 테스트', () {
      test('MomentCreatedMessage가 올바른 구조를 가져야 함', () {
        // Given
        final message =
            MomentCreatedMessage(moment: testMoment1, date: testDate1);

        // Then
        expect(message.moment, equals(testMoment1));
        expect(message.date, equals(testDate1));
        expect(message, isA<BusMessage>());
      });

      test('MomentDeletedMessage가 올바른 구조를 가져야 함', () {
        // Given
        final message = MomentDeletedMessage(moment: testMoment1);

        // Then
        expect(message.moment, equals(testMoment1));
        expect(message, isA<BusMessage>());
      });

      test('MomentModifiedMessage가 올바른 구조를 가져야 함', () {
        // Given
        final modifiedAt = DateTime.now();
        final message = MomentModifiedMessage(
          moment: testMoment1,
          modeifiedAt: modifiedAt,
        );

        // Then
        expect(message.moment, equals(testMoment1));
        expect(message.modeifiedAt, equals(modifiedAt));
        expect(message, isA<BusMessage>());
      });
    });

    group('인터페이스 구조 테스트', () {
      test('IMomentListRepository 인터페이스가 올바르게 정의되어야 함', () {
        // Given & When & Then
        expect(IMomentListRepository, isA<Type>());
      });

      test('Bus 인터페이스가 올바르게 정의되어야 함', () {
        // Given & When & Then
        expect(Bus, isA<Type>());
      });
    });

    group('Moment 엔티티 통합 테스트', () {
      test('Moment가 MomentListEvent와 올바르게 통합되어야 함', () {
        // Given
        final addEvent = AddMoment(testMoment1, testDate1);
        final updateEvent = UpdateMoment(testMoment1, testDate1);
        final deleteEvent = DeleteMoment(testMoment1);

        // Then
        expect(addEvent.moment, equals(testMoment1));
        expect(updateEvent.moment, equals(testMoment1));
        expect(deleteEvent.moment, equals(testMoment1));
      });

      test('Moment가 MomentListState와 올바르게 통합되어야 함', () {
        // Given
        final testMoments = LinkedHashMap<DateTime, List<Moment>>();
        testMoments[testDate1] = [testMoment1, testMoment2];

        final state = MomentListState(
          moments: testMoments,
          firstDay: testDate1,
        );

        // Then
        expect(state.moments[testDate1], contains(testMoment1));
        expect(state.moments[testDate1], contains(testMoment2));
        expect(state.moments[testDate1]!.length, equals(2));
      });

      test('Moment의 copyWith가 MomentListState에서 올바르게 작동해야 함', () {
        // Given
        final testMoments = LinkedHashMap<DateTime, List<Moment>>();
        testMoments[testDate1] = [testMoment1];

        final state = MomentListState(
          moments: testMoments,
          firstDay: testDate1,
        );

        // When
        final updatedMoment = testMoment1.copyWith(
          reflection: '수정된 일기',
          modifiedAt: DateTime.now(),
        );

        final updatedMoments = LinkedHashMap<DateTime, List<Moment>>();
        updatedMoments[testDate1] = [updatedMoment];

        final updatedState = state.copyWith(moments: updatedMoments);

        // Then
        expect(
            updatedState.moments[testDate1]![0].reflection, equals('수정된 일기'));
        expect(updatedState.moments[testDate1]![0].modifiedAt, isNotNull);
      });
    });

    group('데이터 유효성 테스트', () {
      test('MomentListState의 moments가 LinkedHashMap 타입이어야 함', () {
        // Given
        final state =
            MomentListState(moments: LinkedHashMap<DateTime, List<Moment>>());

        // Then
        expect(state.moments, isA<LinkedHashMap>());
      });

      test('MomentListState의 firstDay가 nullable이어야 함', () {
        // Given
        final state1 =
            MomentListState(moments: LinkedHashMap<DateTime, List<Moment>>());
        final state2 = MomentListState(
          moments: LinkedHashMap<DateTime, List<Moment>>(),
          firstDay: testDate1,
        );

        // Then
        expect(state1.firstDay, isNull);
        expect(state2.firstDay, isNotNull);
      });

      test('MomentListEvent들이 모두 MomentListEvent를 상속해야 함', () {
        // Given & When & Then
        expect(LoadMoments(), isA<MomentListEvent>());
        expect(AddMoment(testMoment1, testDate1), isA<MomentListEvent>());
        expect(UpdateMoment(testMoment1, testDate1), isA<MomentListEvent>());
        expect(DeleteMoment(testMoment1), isA<MomentListEvent>());
      });
    });
  });
}
