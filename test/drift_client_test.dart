import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'dart:io';

void main() {
  late Database database;
  late DriftClientImpl driftClient;
  late String dbPath;

  setUp(() async {
    dbPath =
        'test_drift_client_${DateTime.now().microsecondsSinceEpoch}.sqlite';
    database = Database(dbPath);
    driftClient = DriftClientImpl(database);
  });

  tearDown(() async {
    await database.close();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  test('runQuery 성공 케이스: moment insert & select', () async {
    // insert
    final insertResult = await driftClient.runQuery((db) async {
      await db.into(db.momentTable).insert(
            MomentTableCompanion.insert(
              id: 'test_id',
              reflection: '테스트',
              date: DateTime.now(),
              modifiedAt: DateTime.now(),
            ),
          );
      return 1;
    }, description: 'insert moment');
    expect(insertResult.isRight(), true);

    // select
    final selectResult = await driftClient.runQuery((db) async {
      return await db.select(db.momentTable).getSingle();
    }, description: 'select moment');
    expect(selectResult.isRight(), true);
    selectResult.match(
      (l) => fail('select 실패: ${l.message}'),
      (moment) {
        expect(moment.id, 'test_id');
        expect(moment.reflection, '테스트');
      },
    );
  });

  test('runQuery 실패 케이스: 예외 발생 시 LocalFailure 반환', () async {
    final result = await driftClient.runQuery((db) async {
      throw Exception('테스트 예외');
    }, description: '예외 발생');
    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l.message, contains('Drift 쿼리 실행 중 오류 발생')),
      (_) => fail('예외가 발생해야 합니다.'),
    );
  });
}
