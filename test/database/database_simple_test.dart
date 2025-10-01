@Tags(['no-hook'])
import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';

void main() {
  group('Database Simple Tests', () {
    late Database database;

    setUp(() async {
      const dbName = ':memory:';
      database = Database(dbName);
    });

    tearDown(() async {
      await database.close();
    });

    test('데이터베이스 생성 테스트', () {
      expect(database, isNotNull);
      expect(database.schemaVersion, equals(2));
    });

    test('MomentTable 기본 테스트', () async {
      const momentId = 'simple_test_moment';
      final testDate = DateTime(2024, 1, 1);
      const testReflection = '간단한 테스트 일기';

      // 데이터 삽입
      await database.into(database.momentTable).insert(
            MomentTableCompanion.insert(
              id: momentId,
              reflection: testReflection,
              date: testDate,
              modifiedAt: testDate,
            ),
          );

      // 데이터 조회
      final insertedMoment =
          await database.select(database.momentTable).getSingle();

      expect(insertedMoment.id, equals(momentId));
      expect(insertedMoment.reflection, equals(testReflection));
      expect(insertedMoment.date, equals(testDate));

      // 데이터 삭제
      await (database.delete(database.momentTable)
            ..where((tbl) => tbl.id.equals(momentId)))
          .go();

      final deletedMoment =
          await database.select(database.momentTable).getSingleOrNull();

      expect(deletedMoment, isNull);
    });

    test('데이터베이스 연결 종료 테스트', () async {
      // 데이터베이스가 정상적으로 닫히는지 확인
      expect(() => database.close(), returnsNormally);
    });
  });
}
