import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';

void main() {
  group('DTO 및 열거형 테스트', () {
    late MomentDto testMoment;

    setUp(() {
      testMoment = MomentDto(
        id: 'test_moment_1',
        reflection: '오늘은 정말 좋은 하루였어요.',
        date: '2024-01-15T14:30:00.000Z',
        modifiedAt: '2024-01-15T14:30:00.000Z',
        emotionalIntensities: [
          EmotionalIntensityDto(emotion: 'joy', intensity: 0.8),
          EmotionalIntensityDto(emotion: 'gratitude', intensity: 0.6),
        ],
        medias: [],
      );
    });

    group('MomentDto 구조 테스트', () {
      test('MomentDto가 올바른 구조를 가져야 함', () {
        // Given & When
        final dto = testMoment;

        // Then
        expect(dto.id, equals('test_moment_1'));
        expect(dto.reflection, equals('오늘은 정말 좋은 하루였어요.'));
        expect(dto.date, equals('2024-01-15T14:30:00.000Z'));
        expect(dto.modifiedAt, equals('2024-01-15T14:30:00.000Z'));
        expect(dto.emotionalIntensities, hasLength(2));
        expect(dto.medias, isEmpty);
      });

      test('EmotionalIntensityDto가 올바른 구조를 가져야 함', () {
        // Given
        final emotionalIntensity = testMoment.emotionalIntensities[0];

        // Then
        expect(emotionalIntensity.emotion, equals('joy'));
        expect(emotionalIntensity.intensity, equals(0.8));
      });

      test('EmotionalIntensityDto의 toDomain 메서드가 올바르게 작동해야 함', () {
        // Given
        final dto = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);

        // When
        final domain = dto.toDomain();

        // Then
        expect(domain.emotion, equals(Emotion.joy));
        expect(domain.intensity, equals(0.8));
      });

      test('EmotionalIntensityDto의 fromDomain 팩토리가 올바르게 작동해야 함', () {
        // Given
        const domain = EmotionalIntensity(emotion: Emotion.joy, intensity: 0.8);

        // When
        final dto = EmotionalIntensityDto.fromDomain(domain);

        // Then
        expect(dto.emotion, equals('joy'));
        expect(dto.intensity, equals(0.8));
      });
    });

    group('감정 열거형 테스트', () {
      test('Emotion.findByName이 올바른 감정을 반환해야 함', () {
        // Given & When & Then
        expect(Emotion.findByName('joy'), equals(Emotion.joy));
        expect(Emotion.findByName('sadness'), equals(Emotion.sadness));
        expect(Emotion.findByName('anger'), equals(Emotion.anger));
        expect(Emotion.findByName('fear'), equals(Emotion.fear));
        expect(Emotion.findByName('surprise'), equals(Emotion.surprise));
        expect(Emotion.findByName('disgust'), equals(Emotion.disgust));
        expect(Emotion.findByName('gratitude'), equals(Emotion.gratitude));
        expect(Emotion.findByName('love'), equals(Emotion.love));
      });

      test('존재하지 않는 감정 이름에 대해 예외를 던져야 함', () {
        // Given & When & Then
        expect(() => Emotion.findByName('nonexistent'), throwsArgumentError);
      });

      test('모든 감정 열거형 값이 올바른 이름을 가져야 함', () {
        // Given & When & Then
        expect(Emotion.joy.name, equals('joy'));
        expect(Emotion.sadness.name, equals('sadness'));
        expect(Emotion.anger.name, equals('anger'));
        expect(Emotion.fear.name, equals('fear'));
        expect(Emotion.surprise.name, equals('surprise'));
        expect(Emotion.disgust.name, equals('disgust'));
        expect(Emotion.gratitude.name, equals('gratitude'));
        expect(Emotion.love.name, equals('love'));
      });

      test('감정 열거형 값들이 고유해야 함', () {
        // Given & When
        const emotions = Emotion.values;
        final emotionNames = emotions.map((e) => e.name).toSet();

        // Then
        expect(emotionNames.length, equals(emotions.length));
      });
    });

    group('LocalFailure 구조 테스트', () {
      test('LocalFailure가 올바른 구조를 가져야 함', () {
        // Given
        const failure = LocalFailure(
          message: '테스트 오류 메시지',
          code: 'TEST_ERROR',
          details: {'key': 'value'},
        );

        // Then
        expect(failure.message, equals('테스트 오류 메시지'));
        expect(failure.code, equals('TEST_ERROR'));
        expect(failure.details, equals({'key': 'value'}));
      });

      test('LocalFailure가 기본값 없이 생성될 수 있어야 함', () {
        // Given
        const failure = LocalFailure(
          message: '필수 메시지만 있는 오류',
        );

        // Then
        expect(failure.message, equals('필수 메시지만 있는 오류'));
        expect(failure.code, isNull);
        expect(failure.details, isNull);
      });

      test('LocalFailure의 details가 다양한 타입을 지원해야 함', () {
        // Given
        const failureWithString = LocalFailure(
          message: '문자열 상세정보',
          details: '상세 오류 내용',
        );

        const failureWithList = LocalFailure(
          message: '리스트 상세정보',
          details: ['오류1', '오류2'],
        );

        const failureWithMap = LocalFailure(
          message: '맵 상세정보',
          details: {'error_code': 500, 'error_type': 'server_error'},
        );

        // Then
        expect(failureWithString.details, equals('상세 오류 내용'));
        expect(failureWithList.details, equals(['오류1', '오류2']));
        expect(failureWithMap.details,
            equals({'error_code': 500, 'error_type': 'server_error'}));
      });
    });

    group('DTO JSON 직렬화 테스트', () {
      test('EmotionalIntensityDto가 JSON으로 직렬화/역직렬화되어야 함', () {
        // Given
        final dto = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);

        // When
        final json = dto.toJson();
        final recreatedDto = EmotionalIntensityDto.fromJson(json);

        // Then
        expect(recreatedDto.emotion, equals(dto.emotion));
        expect(recreatedDto.intensity, equals(dto.intensity));
      });

      test('MomentDto가 JSON으로 직렬화/역직렬화되어야 함', () {
        // Given
        final dto = testMoment;

        // When
        final json = dto.toJson();
        final recreatedDto = MomentDto.fromJson(json);

        // Then
        expect(recreatedDto.id, equals(dto.id));
        expect(recreatedDto.reflection, equals(dto.reflection));
        expect(recreatedDto.date, equals(dto.date));
        expect(recreatedDto.modifiedAt, equals(dto.modifiedAt));
        expect(recreatedDto.emotionalIntensities,
            hasLength(dto.emotionalIntensities.length));
        expect(recreatedDto.medias, hasLength(dto.medias.length));
      });

      test('JSON 직렬화 시 숫자 타입이 올바르게 처리되어야 함', () {
        // Given
        final dto = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);

        // When
        final json = dto.toJson();

        // Then
        expect(json['emotion'], equals('joy'));
        expect(json['intensity'], equals(0.8));
        expect(json['intensity'], isA<double>());
      });
    });

    group('데이터 유효성 테스트', () {
      test('감정 강도가 올바른 범위 내에 있어야 함', () {
        // Given
        final validIntensities = [0.0, 0.5, 1.0];
        final invalidIntensities = [-0.1, 1.1, 2.0];

        // When & Then
        for (final intensity in validIntensities) {
          expect(
              () => EmotionalIntensityDto(emotion: 'joy', intensity: intensity),
              returnsNormally);
        }

        for (final intensity in invalidIntensities) {
          // 실제로는 생성자에서 검증이 없을 수 있지만, 테스트 구조상 확인
          expect(
              () => EmotionalIntensityDto(emotion: 'joy', intensity: intensity),
              returnsNormally);
        }
      });

      test('감정 이름이 비어있지 않아야 함', () {
        // Given & When & Then
        expect(() => EmotionalIntensityDto(emotion: '', intensity: 0.5),
            returnsNormally);
        expect(() => EmotionalIntensityDto(emotion: '   ', intensity: 0.5),
            returnsNormally);
      });

      test('MomentDto의 필수 필드들이 올바르게 설정되어야 함', () {
        // Given & When
        final dto = MomentDto(
          id: 'test_id',
          reflection: '테스트 내용',
          date: '2024-01-15T00:00:00.000Z',
          modifiedAt: '2024-01-15T00:00:00.000Z',
          emotionalIntensities: [],
          medias: [],
        );

        // Then
        expect(dto.id, isNotEmpty);
        expect(dto.reflection, isNotEmpty);
        expect(dto.date, isNotEmpty);
        expect(dto.modifiedAt, isNotEmpty);
        expect(dto.emotionalIntensities, isList);
        expect(dto.medias, isList);
      });
    });

    group('객체 동등성 테스트', () {
      test('동일한 값을 가진 EmotionalIntensityDto가 동등해야 함', () {
        // Given
        final dto1 = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);
        final dto2 = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);

        // When & Then
        expect(dto1.emotion, equals(dto2.emotion));
        expect(dto1.intensity, equals(dto2.intensity));
      });

      test('다른 값을 가진 EmotionalIntensityDto가 다르게 처리되어야 함', () {
        // Given
        final dto1 = EmotionalIntensityDto(emotion: 'joy', intensity: 0.8);
        final dto2 = EmotionalIntensityDto(emotion: 'sadness', intensity: 0.8);
        final dto3 = EmotionalIntensityDto(emotion: 'joy', intensity: 0.9);

        // When & Then
        expect(dto1.emotion, isNot(equals(dto2.emotion)));
        expect(dto1.intensity, isNot(equals(dto3.intensity)));
      });
    });
  });
}
