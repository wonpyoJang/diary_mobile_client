@Tags(['no-hook'])
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'dart:io';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:diary_mobile_client/src/database/tables/emotional_intensity_table.dart';
import 'package:diary_mobile_client/src/database/tables/media_table.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database Migration Tests', () {
    late String testDbPath;

    setUp(() async {
      testDbPath = ':memory:';
    });

    tearDown(() async {
      // 테스트 DB 파일 정리
      final testFile = File(testDbPath);
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('데이터베이스 스키마 버전이 올바르게 설정됐는지 확인', () async {
      final dbPath =
          'test_db_migration_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final database = Database(dbPath);
      try {
        expect(database.schemaVersion, equals(1));
      } finally {
        await database.close();
        final file = File(dbPath);
        if (await file.exists()) await file.delete();
      }
    });

    test('테이블 스키마가 올바르게 생성됐는지 확인', () async {
      final dbPath =
          'test_db_migration_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final database = Database(dbPath);
      try {
        // 모든 테이블 조회
        final tables = await database.allTables;

        // MomentTable 스키마 확인
        final momentTable =
            tables.firstWhere((t) => t is MomentTable) as MomentTable;
        expect(momentTable.id.name, equals('id'));
        expect(momentTable.reflection.name, equals('reflection'));
        expect(momentTable.date.name, equals('date'));
        expect(momentTable.modifiedAt.name, equals('modified_at'));

        // EmotionalIntensityTable 스키마 확인
        final emotionTable =
            tables.firstWhere((t) => t is EmotionalIntensityTable)
                as EmotionalIntensityTable;
        expect(emotionTable.id.name, equals('id'));
        expect(emotionTable.emotion.name, equals('emotion'));
        expect(emotionTable.intensity.name, equals('intensity'));
        expect(emotionTable.momentId.name, equals('moment_id'));

        // MediaTable 스키마 확인
        final mediaTable =
            tables.firstWhere((t) => t is MediaTable) as MediaTable;
        expect(mediaTable.id.name, equals('id'));
        expect(mediaTable.momentId.name, equals('moment_id'));
        expect(mediaTable.data.name, equals('data'));
        expect(mediaTable.mimeType.name, equals('mime_type'));
        expect(mediaTable.createdAt.name, equals('created_at'));
      } finally {
        await database.close();
        final file = File(dbPath);
        if (await file.exists()) await file.delete();
      }
    });

    test('테이블 간 관계가 올바르게 설정됐는지 확인', () async {
      final dbPath =
          'test_db_migration_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final database = Database(dbPath);
      try {
        final tables = await database.allTables;

        // EmotionalIntensityTable과 MediaTable이 존재하는지 확인
        expect(tables.any((t) => t is EmotionalIntensityTable), isTrue);
        expect(tables.any((t) => t is MediaTable), isTrue);

        // 테이블 구조 확인
        final emotionTable =
            tables.firstWhere((t) => t is EmotionalIntensityTable)
                as EmotionalIntensityTable;
        expect(emotionTable.momentId.name, equals('moment_id'));

        final mediaTable =
            tables.firstWhere((t) => t is MediaTable) as MediaTable;
        expect(mediaTable.momentId.name, equals('moment_id'));
      } finally {
        await database.close();
        final file = File(dbPath);
        if (await file.exists()) await file.delete();
      }
    });

    test('데이터베이스 연결이 안전하게 닫히는지 확인', () async {
      final database = Database(testDbPath);

      // 데이터베이스 닫기
      await database.close();

      // 데이터베이스가 정상적으로 닫혔는지 확인 (예외가 발생하지 않아야 함)
      expect(() => database.close(), returnsNormally);
    });

    test('여러 데이터베이스 인스턴스가 독립적으로 작동하는지 확인', () async {
      final dbPath1 =
          'test_db_migration1_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final dbPath2 =
          'test_db_migration2_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final database1 = Database(dbPath1);
      final database2 = Database(dbPath2);

      try {
        // 각각 다른 데이터베이스 인스턴스인지 확인
        expect(database1, isNot(same(database2)));

        // 각각 독립적으로 작동하는지 확인
        await database1.transaction(() async {
          await database1.into(database1.momentTable).insert(
                MomentTableCompanion.insert(
                  id: 'test_moment_1',
                  reflection: '테스트 1',
                  date: DateTime.now(),
                  modifiedAt: DateTime.now(),
                ),
              );
        });

        await database2.transaction(() async {
          await database2.into(database2.momentTable).insert(
                MomentTableCompanion.insert(
                  id: 'test_moment_2',
                  reflection: '테스트 2',
                  date: DateTime.now(),
                  modifiedAt: DateTime.now(),
                ),
              );
        });

        // 각각 다른 데이터를 가지고 있는지 확인
        final moment1 = await database1.select(database1.momentTable).get();
        final moment2 = await database2.select(database2.momentTable).get();

        expect(moment1.length, equals(1));
        expect(moment2.length, equals(1));
        expect(moment1.first.id, equals('test_moment_1'));
        expect(moment2.first.id, equals('test_moment_2'));

        // 테스트 데이터 정리
        await (database1.delete(database1.momentTable)
              ..where((tbl) => tbl.id.equals('test_moment_1')))
            .go();
        await (database2.delete(database2.momentTable)
              ..where((tbl) => tbl.id.equals('test_moment_2')))
            .go();
      } finally {
        await database1.close();
        await database2.close();
        final file1 = File(dbPath1);
        if (await file1.exists()) await file1.delete();
        final file2 = File(dbPath2);
        if (await file2.exists()) await file2.delete();
      }
    });

    test('데이터베이스 트랜잭션 테스트', () async {
      final database = Database(testDbPath);

      try {
        await database.transaction(() async {
          // 트랜잭션 내에서 데이터 삽입
          await database.into(database.momentTable).insert(
                MomentTableCompanion.insert(
                  id: 'transaction_test_moment',
                  reflection: '트랜잭션 테스트용 일기',
                  date: DateTime.now(),
                  modifiedAt: DateTime.now(),
                ),
              );

          // 트랜잭션 내에서 데이터 조회
          final moment =
              await database.select(database.momentTable).getSingle();

          expect(moment.id, equals('transaction_test_moment'));
        });

        // 트랜잭션 완료 후 데이터가 실제로 저장되었는지 확인
        final savedMoment =
            await database.select(database.momentTable).getSingle();

        expect(savedMoment.id, equals('transaction_test_moment'));

        // 테스트 데이터 정리
        await (database.delete(database.momentTable)
              ..where((tbl) => tbl.id.equals('transaction_test_moment')))
            .go();
      } finally {
        await database.close();
      }
    });

    test('데이터베이스 롤백 테스트', () async {
      final database = Database(testDbPath);

      try {
        // 롤백될 데이터 삽입
        await database.transaction(() async {
          await database.into(database.momentTable).insert(
                MomentTableCompanion.insert(
                  id: 'rollback_test_moment',
                  reflection: '롤백 테스트용 일기',
                  date: DateTime.now(),
                  modifiedAt: DateTime.now(),
                ),
              );

          // 의도적으로 예외 발생시켜 롤백 유도
          throw Exception('롤백 테스트');
        });
      } catch (e) {
        // 예외가 발생했는지 확인
        expect(e, isA<Exception>());
        expect(e.toString(), contains('롤백 테스트'));
      }

      // 롤백 후 데이터가 존재하지 않는지 확인
      final rolledBackMoment =
          await database.select(database.momentTable).getSingleOrNull();

      expect(rolledBackMoment, isNull);

      await database.close();
    });

    test('데이터베이스 성능 테스트 - 대량 데이터 삽입', () async {
      final database = Database(testDbPath);

      try {
        final stopwatch = Stopwatch()..start();

        // 100개의 테스트 데이터 삽입
        for (int i = 0; i < 100; i++) {
          await database.into(database.momentTable).insert(
                MomentTableCompanion.insert(
                  id: 'performance_test_moment_$i',
                  reflection: '성능 테스트용 일기 $i',
                  date: DateTime.now(),
                  modifiedAt: DateTime.now(),
                ),
              );
        }

        stopwatch.stop();

        // 삽입된 데이터 수 확인
        final count = await database.select(database.momentTable).get();
        expect(count.length, equals(100));

        // 성능 기준 (100개 데이터 삽입이 5초 이내에 완료되어야 함)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));

        // 테스트 데이터 정리
        await (database.delete(database.momentTable)
              ..where((tbl) => tbl.id.contains('performance_test_moment')))
            .go();
      } finally {
        await database.close();
      }
    });
  });
}
