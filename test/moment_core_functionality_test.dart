import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('Moment 핵심 기능 테스트', () {
    late DateTime testDate;
    late String testReflection;

    setUpAll(() async {
      await initializeDateFormatting('ko_KR');
    });

    setUp(() {
      testDate = DateTime(2024, 1, 15, 14, 30, 0);
      testReflection = '오늘은 정말 좋은 하루였어요. 친구들과 함께 맛있는 음식을 먹고 즐거운 시간을 보냈습니다.';
    });

    test('Moment.create() 팩토리 메서드로 새로운 Moment 생성', () {
      // Given
      final moment = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      // Then
      expect(moment.id, isNotEmpty);
      expect(moment.id.startsWith('moment'), isTrue);
      expect(moment.reflection, equals(testReflection));
      expect(moment.date, equals(testDate));
      expect(moment.emotionalIntensities, isEmpty);
      expect(moment.medias, isEmpty);
      expect(moment.modifiedAt.isAfter(testDate), isTrue);
    });

    test('Moment의 날짜 포맷팅 기능', () {
      // Given
      final moment = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      // When
      final formattedDateTimeKo = moment.getFormattedDateTime(locale: 'ko_KR');
      final formattedDayKo = moment.getFormattedDay(locale: 'ko_KR');
      final formattedDateTimeEn = moment.getFormattedDateTime(locale: 'en_US');
      final formattedDayEn = moment.getFormattedDay(locale: 'en_US');

      // Then
      // 한국어
      expect(formattedDateTimeKo, contains('2024년 01월 15일'));
      expect(formattedDateTimeKo, contains('02시 30분'));
      expect(formattedDateTimeKo, contains('오후'));
      expect(formattedDayKo, contains('2024년 01월 15일'));
      expect(formattedDayKo, contains('월요일'));
      // 영어
      expect(formattedDateTimeEn, contains('2024'));
      expect(formattedDateTimeEn, contains('02:30:00 PM'));
      expect(formattedDateTimeEn, contains('PM'));
      expect(formattedDayEn, contains('2024'));
      expect(formattedDayEn.toLowerCase(), contains('monday'));
    });

    test('Moment의 감정 강도 추가 및 수정', () {
      // Given
      final moment = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      // When - 감정 강도 추가
      final emotionalIntensities = [
        const EmotionalIntensity(emotion: Emotion.joy, intensity: 0.8),
        const EmotionalIntensity(emotion: Emotion.gratitude, intensity: 0.6),
      ];

      final updatedMoment = moment.copyWith(
        emotionalIntensities: emotionalIntensities,
      );

      // Then
      expect(updatedMoment.emotionalIntensities, hasLength(2));
      expect(
          updatedMoment.emotionalIntensities[0].emotion, equals(Emotion.joy));
      expect(updatedMoment.emotionalIntensities[0].intensity, equals(0.8));
      expect(updatedMoment.emotionalIntensities[1].emotion,
          equals(Emotion.gratitude));
      expect(updatedMoment.emotionalIntensities[1].intensity, equals(0.6));
    });

    test('Moment의 미디어 첨부 및 제거', () {
      // Given
      final moment = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      // When - 미디어 추가
      final testMedias = [
        File('/path/to/image1.jpg'),
        File('/path/to/image2.png'),
      ];

      final momentWithMedias = moment.copyWith(medias: testMedias);

      // Then
      expect(momentWithMedias.medias, hasLength(2));
      expect(momentWithMedias.medias[0].path, equals('/path/to/image1.jpg'));
      expect(momentWithMedias.medias[1].path, equals('/path/to/image2.png'));

      // When - 미디어 제거
      final momentWithoutMedias = momentWithMedias.copyWith(medias: []);

      // Then
      expect(momentWithoutMedias.medias, isEmpty);
    });

    test('Moment의 JSON 직렬화/역직렬화', () {
      // Given
      final emotionalIntensities = [
        const EmotionalIntensity(emotion: Emotion.joy, intensity: 0.8),
        const EmotionalIntensity(emotion: Emotion.gratitude, intensity: 0.6),
      ];

      final moment = Moment.create(
        reflection: testReflection,
        date: testDate,
      ).copyWith(
        emotionalIntensities: emotionalIntensities,
      );

      // When
      final json = moment.toJson();
      final recreatedMoment = Moment.fromJson(json);

      // Then
      expect(recreatedMoment.id, equals(moment.id));
      expect(recreatedMoment.reflection, equals(moment.reflection));
      expect(recreatedMoment.date.year, equals(moment.date.year));
      expect(recreatedMoment.date.month, equals(moment.date.month));
      expect(recreatedMoment.date.day, equals(moment.date.day));
      expect(recreatedMoment.emotionalIntensities, hasLength(2));
      expect(
          recreatedMoment.emotionalIntensities[0].emotion, equals(Emotion.joy));
      expect(recreatedMoment.emotionalIntensities[0].intensity, equals(0.8));
      expect(recreatedMoment.emotionalIntensities[1].emotion,
          equals(Emotion.gratitude));
      expect(recreatedMoment.emotionalIntensities[1].intensity, equals(0.6));
    });

    test('Moment의 copyWith 메서드로 부분 업데이트', () {
      // Given
      final originalMoment = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      // When
      final updatedMoment = originalMoment.copyWith(
        reflection: '수정된 일기 내용입니다.',
        modifiedAt: DateTime(2024, 1, 15, 16, 0, 0),
      );

      // Then
      expect(updatedMoment.id, equals(originalMoment.id));
      expect(updatedMoment.reflection, equals('수정된 일기 내용입니다.'));
      expect(updatedMoment.date, equals(originalMoment.date));
      expect(updatedMoment.modifiedAt.hour, equals(16));
      expect(updatedMoment.emotionalIntensities,
          equals(originalMoment.emotionalIntensities));
      expect(updatedMoment.medias, equals(originalMoment.medias));
    });

    test('Moment의 Equatable 기능', () {
      // Given
      final moment1 = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      final moment2 = Moment.create(
        reflection: testReflection,
        date: testDate,
      );

      final moment3 = Moment.create(
        reflection: '다른 내용의 일기',
        date: testDate,
      );

      // Then
      expect(moment1, isNot(equals(moment2))); // ID가 다르므로 다른 객체
      expect(moment1, isNot(equals(moment3))); // 내용이 다르므로 다른 객체
      expect(moment1, equals(moment1)); // 같은 객체는 같음
    });

    test('감정 강도 유효성 검증', () {
      // Given & When
      const validIntensity = EmotionalIntensity(
        emotion: Emotion.joy,
        intensity: 0.5,
      );

      const maxIntensity = EmotionalIntensity(
        emotion: Emotion.joy,
        intensity: 1.0,
      );

      const minIntensity = EmotionalIntensity(
        emotion: Emotion.joy,
        intensity: 0.0,
      );

      // Then
      expect(validIntensity.intensity, greaterThanOrEqualTo(0.0));
      expect(validIntensity.intensity, lessThanOrEqualTo(1.0));
      expect(maxIntensity.intensity, equals(1.0));
      expect(minIntensity.intensity, equals(0.0));
    });

    test('감정 열거형 값 검증', () {
      // Given & When
      const joyEmotion = Emotion.joy;
      const sadnessEmotion = Emotion.sadness;
      const angerEmotion = Emotion.anger;

      // Then
      expect(joyEmotion.name, equals('joy'));
      expect(sadnessEmotion.name, equals('sadness'));
      expect(angerEmotion.name, equals('anger'));
      expect(Emotion.values,
          containsAll([joyEmotion, sadnessEmotion, angerEmotion]));
    });
  });
}
