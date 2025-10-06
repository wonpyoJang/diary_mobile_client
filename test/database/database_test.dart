import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:diary_mobile_client/src/database/tables/emotional_intensity_table.dart';
import 'package:diary_mobile_client/src/database/tables/media_table.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database Tests', () {
    test('데이터베이스 스키마 버전이 올바른지 확인', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      expect(database.schemaVersion, equals(3));
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('데이터베이스 테이블들이 올바르게 생성되었는지 확인', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      final tables = database.allTables;
      expect(tables, contains(isA<MomentTable>()));
      expect(tables, contains(isA<EmotionalIntensityTable>()));
      expect(tables, contains(isA<MediaTable>()));
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('MomentTable CRUD 작업 테스트', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      const momentId = 'test_moment_1';
      final testDate = DateTime(2024, 1, 1);
      const testReflection = '테스트 일기 내용입니다.';
      await database.into(database.momentTable).insert(
            MomentTableCompanion.insert(
              id: momentId,
              reflection: testReflection,
              date: testDate,
              modifiedAt: testDate,
            ),
          );
      final insertedMoment =
          await database.select(database.momentTable).getSingle();
      expect(insertedMoment.id, equals(momentId));
      expect(insertedMoment.reflection, equals(testReflection));
      expect(insertedMoment.date, equals(testDate));
      const updatedReflection = '수정된 일기 내용입니다.';
      await (database.update(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .write(MomentTableCompanion(
        reflection: const Value(updatedReflection),
        modifiedAt: Value(DateTime.now()),
      ));
      final updatedMoment =
          await database.select(database.momentTable).getSingle();
      expect(updatedMoment.reflection, equals(updatedReflection));
      await (database.delete(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .go();
      final deletedMoment =
          await database.select(database.momentTable).getSingleOrNull();
      expect(deletedMoment, isNull);
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('EmotionalIntensityTable CRUD 작업 테스트', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      const momentId = 'test_moment_2';
      await database.into(database.momentTable).insert(
            MomentTableCompanion.insert(
              id: momentId,
              reflection: '감정 테스트용 일기',
              date: DateTime.now(),
              modifiedAt: DateTime.now(),
            ),
          );
      const emotionId = 'test_emotion_1';
      const testEmotion = Emotion.joy;
      const testIntensity = 0.8;
      await database.into(database.emotionalIntensityTable).insert(
            EmotionalIntensityTableCompanion.insert(
              id: emotionId,
              emotion: testEmotion,
              intensity: testIntensity,
              momentId: momentId,
            ),
          );
      final insertedEmotion =
          await database.select(database.emotionalIntensityTable).getSingle();
      expect(insertedEmotion.id, equals(emotionId));
      expect(insertedEmotion.emotion, equals(testEmotion));
      expect(insertedEmotion.intensity, equals(testIntensity));
      expect(insertedEmotion.momentId, equals(momentId));
      const updatedIntensity = 0.9;
      await (database.update(database.emotionalIntensityTable)
            ..where((tbl) => tbl.id.equals(emotionId)))
          .write(const EmotionalIntensityTableCompanion(
        intensity: Value(updatedIntensity),
      ));
      final updatedEmotion =
          await database.select(database.emotionalIntensityTable).getSingle();
      expect(updatedEmotion.intensity, equals(updatedIntensity));
      await (database.delete(database.emotionalIntensityTable)
            ..where((tbl) => tbl.id.equals(emotionId)))
          .go();
      final deletedEmotion = await database
          .select(database.emotionalIntensityTable)
          .getSingleOrNull();
      expect(deletedEmotion, isNull);
      await (database.delete(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .go();
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('MediaTable CRUD 작업 테스트', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      const momentId = 'test_moment_3';
      await database.into(database.momentTable).insert(
            MomentTableCompanion.insert(
              id: momentId,
              reflection: '미디어 테스트용 일기',
              date: DateTime.now(),
              modifiedAt: DateTime.now(),
            ),
          );
      const mediaId = 'test_media_1';
      final testPath = '/tmp/test_image.jpg';
      const testMimeType = 'image/jpeg';
      final testCreatedAt = DateTime.now();
      await database.into(database.mediaTable).insert(
            MediaTableCompanion.insert(
              id: mediaId,
              momentId: momentId,
              path: testPath,
              mimeType: testMimeType,
              createdAt: testCreatedAt,
            ),
          );
      final insertedMedia =
          await database.select(database.mediaTable).getSingle();
      expect(insertedMedia.id, equals(mediaId));
      expect(insertedMedia.path, equals(testPath));
      expect(insertedMedia.mimeType, equals(testMimeType));
      expect(insertedMedia.momentId, equals(momentId));
      const updatedMimeType = 'image/png';
      await (database.update(database.mediaTable)
            ..where((tbl) => tbl.id.equals(mediaId)))
          .write(const MediaTableCompanion(
        mimeType: Value(updatedMimeType),
      ));
      final updatedMedia =
          await database.select(database.mediaTable).getSingle();
      expect(updatedMedia.mimeType, equals(updatedMimeType));
      await (database.delete(database.mediaTable)
            ..where((tbl) => tbl.id.equals(mediaId)))
          .go();
      final deletedMedia =
          await database.select(database.mediaTable).getSingleOrNull();
      expect(deletedMedia, isNull);
      await (database.delete(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .go();
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('외래 키 제약 조건 테스트', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      const nonExistentMomentId = 'non_existent_moment';
      await expectLater(
        () async {
          await database.into(database.emotionalIntensityTable).insert(
                EmotionalIntensityTableCompanion.insert(
                  id: 'test_emotion_2',
                  emotion: Emotion.joy,
                  intensity: 0.5,
                  momentId: nonExistentMomentId,
                ),
              );
        },
        throwsA(isA<Exception>()),
      );
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });

    test('복합 쿼리 테스트', () async {
      const dbName = 'test_db_main_1755240809684730.sqlite';
      final database = Database(dbName);
      await database.customStatement('PRAGMA foreign_keys = ON;');
      // 테스트 데이터 생성
      const momentId = 'test_moment_4';
      await database.into(database.momentTable).insert(
            MomentTableCompanion.insert(
              id: momentId,
              reflection: '복합 쿼리 테스트용 일기',
              date: DateTime(2024, 1, 1),
              modifiedAt: DateTime.now(),
            ),
          );

      await database.into(database.emotionalIntensityTable).insert(
            EmotionalIntensityTableCompanion.insert(
              id: 'emotion_1',
              emotion: Emotion.joy,
              intensity: 0.8,
              momentId: momentId,
            ),
          );

      await database.into(database.emotionalIntensityTable).insert(
            EmotionalIntensityTableCompanion.insert(
              id: 'emotion_2',
              emotion: Emotion.sadness,
              intensity: 0.3,
              momentId: momentId,
            ),
          );

      // JOIN 쿼리로 moment와 감정 데이터 함께 조회
      final query = database.select(database.momentTable).join([
        leftOuterJoin(
          database.emotionalIntensityTable,
          database.emotionalIntensityTable.momentId.equalsExp(
            database.momentTable.id,
          ),
        ),
      ]);

      final results = await query.get();

      expect(results.length, greaterThan(0));
      expect(
          results.first.readTable(database.momentTable).id, equals(momentId));

      // 감정 데이터가 있는 결과 확인
      final emotionResults = results
          .where((r) =>
              r.readTableOrNull(database.emotionalIntensityTable) != null)
          .toList();
      expect(emotionResults.length, equals(2));

      // 정리
      await (database.delete(database.emotionalIntensityTable)
            ..where((tbl) => tbl.momentId.equals(momentId)))
          .go();
      await (database.delete(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .go();
      await database.close();
      final file = File(dbName);
      if (await file.exists()) await file.delete();
    });
  });
}
