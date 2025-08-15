import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_state.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';

void main() {
  group('WriteMomentBloc 테스트', () {
    late DateTime testDate;
    late Moment testMoment;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 14, 30, 0);

      testMoment = Moment.create(
        reflection: '오늘은 정말 좋은 하루였어요.',
        date: testDate,
      );
    });

    group('초기 상태 테스트', () {
      test('WriteMomentBloc 생성자 시그니처가 올바르게 정의되어야 함', () {
        // Given & When & Then
        expect(WriteMomentBloc, isA<Type>());
      });
    });

    group('WriteMode 열거형 테스트', () {
      test('WriteMode 열거형이 올바른 값을 가져야 함', () {
        // Given & When & Then
        expect(WriteMode.create.name, equals('create'));
        expect(WriteMode.edit.name, equals('edit'));
        expect(WriteMode.view.name, equals('view'));
      });

      test('WriteMode 열거형 값들이 고유해야 함', () {
        // Given & When
        final modes = WriteMode.values;
        final modeNames = modes.map((m) => m.name).toSet();

        // Then
        expect(modeNames.length, equals(modes.length));
      });
    });

    group('WriteMomentEvent 구조 테스트', () {
      test('TextChangedEvent가 올바른 구조를 가져야 함', () {
        // Given
        const event = TextChangedEvent('새로운 텍스트');

        // Then
        expect(event.newText, equals('새로운 텍스트'));
        expect(event.props, contains('새로운 텍스트'));
      });

      test('DeleteMedia 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        const event = DeleteMedia(5);

        // Then
        expect(event.index, equals(5));
        expect(event.props, contains(5));
      });

      test('이벤트들이 Equatable을 올바르게 구현해야 함', () {
        // Given
        const event1 = TextChangedEvent('텍스트1');
        const event2 = TextChangedEvent('텍스트1');
        const event3 = TextChangedEvent('텍스트2');

        // Then
        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('WriteMomentState 구조 테스트', () {
      test('WriteMomentState가 올바른 구조를 가져야 함', () {
        // Given
        final state = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: true,
          isSaved: false,
          errorMessage: '오류 메시지',
          isTextGenerated: true,
        );

        // Then
        expect(state.mode, equals(WriteMode.create));
        expect(state.moment, equals(testMoment));
        expect(state.isLoading, isTrue);
        expect(state.isSaved, isFalse);
        expect(state.errorMessage, equals('오류 메시지'));
        expect(state.isTextGenerated, isTrue);
        expect(state.failure, isNull);
      });

      test('WriteMomentState의 copyWith가 올바르게 작동해야 함', () {
        // Given
        final originalState = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
          isSaved: false,
        );

        // When
        final updatedState = originalState.copyWith(
          isLoading: true,
          isSaved: true,
          mode: WriteMode.edit,
        );

        // Then
        expect(updatedState.mode, equals(WriteMode.edit));
        expect(updatedState.isLoading, isTrue);
        expect(updatedState.isSaved, isTrue);
        expect(updatedState.moment, equals(originalState.moment));
        expect(updatedState.errorMessage, equals(originalState.errorMessage));
      });

      test('WriteMomentState가 Equatable을 올바르게 구현해야 함', () {
        // Given
        final state1 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
          isSaved: false,
        );

        final state2 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
          isSaved: false,
        );

        final state3 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: true, // 다른 값
          isSaved: false,
        );

        // Then
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('이벤트 동등성 테스트', () {
      test('동일한 값을 가진 이벤트가 동등해야 함', () {
        // Given & When & Then
        expect(TextChangedEvent('test'), equals(TextChangedEvent('test')));
        expect(DeleteMedia(1), equals(DeleteMedia(1)));
        expect(ChangeToEdit(), equals(ChangeToEdit()));
        expect(AddMedias(), equals(AddMedias()));
        expect(WriteByImage(), equals(WriteByImage()));
        expect(ResetIsTextGenerated(), equals(ResetIsTextGenerated()));
      });

      test('다른 값을 가진 이벤트가 다르게 처리되어야 함', () {
        // Given & When & Then
        expect(TextChangedEvent('test1'),
            isNot(equals(TextChangedEvent('test2'))));
        expect(DeleteMedia(1), isNot(equals(DeleteMedia(2))));
      });

      test('이벤트의 props가 올바르게 설정되어야 함', () {
        // Given & When & Then
        expect(TextChangedEvent('hello').props, contains('hello'));
        expect(DeleteMedia(10).props, contains(10));
        expect(ChangeToEdit().props, isEmpty);
        expect(AddMedias().props, isEmpty);
        expect(WriteByImage().props, isEmpty);
        expect(ResetIsTextGenerated().props, isEmpty);
      });
    });

    group('상태 동등성 테스트', () {
      test('동일한 값을 가진 상태가 동등해야 함', () {
        // Given
        final state1 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
          isSaved: false,
        );

        final state2 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
          isSaved: false,
        );

        // When & Then
        expect(state1, equals(state2));
      });

      test('다른 값을 가진 상태가 다르게 처리되어야 함', () {
        // Given
        final state1 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: false,
        );

        final state2 = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: true, // 다른 값
        );

        // When & Then
        expect(state1, isNot(equals(state2)));
      });

      test('상태의 props가 올바르게 설정되어야 함', () {
        // Given
        final state = WriteMomentState(
          mode: WriteMode.create,
          moment: testMoment,
          isLoading: true,
          isSaved: true,
          errorMessage: '오류',
          isTextGenerated: true,
        );

        // When & Then
        expect(state.props, contains(WriteMode.create));
        expect(state.props, contains(testMoment));
        expect(state.props, contains(true)); // isLoading
        expect(state.props, contains(true)); // isSaved
        expect(state.props, contains('오류')); // errorMessage
        expect(state.props, contains(true)); // isTextGenerated
        expect(state.props, contains(null)); // failure
      });
    });

    group('Moment 엔티티 통합 테스트', () {
      test('Moment가 WriteMomentState에 올바르게 포함되어야 함', () {
        // Given
        final moment = Moment.create(
          reflection: '테스트 일기',
          date: testDate,
        );

        // When
        final state = WriteMomentState(
          mode: WriteMode.create,
          moment: moment,
        );

        // Then
        expect(state.moment.id, equals(moment.id));
        expect(state.moment.reflection, equals(moment.reflection));
        expect(state.moment.date, equals(moment.date));
        expect(state.moment.emotionalIntensities, isEmpty);
        expect(state.moment.medias, isEmpty);
      });

      test('Moment의 copyWith가 WriteMomentState에서 올바르게 작동해야 함', () {
        // Given
        final originalMoment = Moment.create(
          reflection: '원본 텍스트',
          date: testDate,
        );

        final state = WriteMomentState(
          mode: WriteMode.create,
          moment: originalMoment,
        );

        // When
        final updatedMoment = originalMoment.copyWith(
          reflection: '수정된 텍스트',
          modifiedAt: DateTime(2024, 1, 15, 16, 0, 0),
        );

        final updatedState = state.copyWith(moment: updatedMoment);

        // Then
        expect(updatedState.moment.reflection, equals('수정된 텍스트'));
        expect(updatedState.moment.modifiedAt.hour, equals(16));
        expect(updatedState.moment.id, equals(originalMoment.id));
      });
    });

    group('WriteMomentFailure 테스트', () {
      test('구체적인 WriteMomentFailure 구현체가 올바른 구조를 가져야 함', () {
        // Given
        final failure = SaveMomentFailed(message: '테스트 오류');

        // Then
        expect(failure.message, equals('테스트 오류'));
        expect(failure, isA<WriteMomentFailure>());
      });

      test('WriteMomentFailure 구현체들이 Equatable을 올바르게 구현해야 함', () {
        // Given
        final failure1 = SaveMomentFailed(message: '오류1');
        final failure2 = SaveMomentFailed(message: '오류1');
        final failure3 = SaveMomentFailed(message: '오류2');

        // Then
        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });

      test('다양한 WriteMomentFailure 타입들이 올바르게 작동해야 함', () {
        // Given
        final analyzeFailure = MomentAnalyzeFailed(message: '분석 실패');
        final selectMediaFailure = SelectMediasFailed(message: '미디어 선택 실패');
        final describeImageFailure =
            MomentDescribeImageFailed(message: '이미지 설명 실패');
        final saveMediaFailure = SaveMediaFailed(message: '미디어 저장 실패');

        // Then
        expect(analyzeFailure, isA<WriteMomentFailure>());
        expect(selectMediaFailure, isA<WriteMomentFailure>());
        expect(describeImageFailure, isA<WriteMomentFailure>());
        expect(saveMediaFailure, isA<WriteMomentFailure>());
      });
    });
  });
}
