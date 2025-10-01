import 'package:diary_mobile_client/src/database/tables/media_table.dart';
import 'package:diary_mobile_client/src/database/tables/user_table.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:drift/drift.dart';
import 'package:diary_mobile_client/src/database/tables/emotional_intensity_table.dart';
import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:drift/native.dart';
import 'dart:io';

import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

@DriftDatabase(
    tables: [MomentTable, EmotionalIntensityTable, MediaTable, UserTable])
@singleton
class Database extends _$Database {
  Database(String dbPath) : super(_openConnection(dbPath));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 -> v2: MediaTable의 blob 컬럼(data) 제거, path(text) 컬럼 추가
            // 1) 임시 테이블 생성
            await customStatement('''
              CREATE TABLE IF NOT EXISTS media_table_new (
                id TEXT NOT NULL,
                moment_id TEXT NOT NULL,
                path TEXT NOT NULL,
                mime_type TEXT NOT NULL,
                created_at INTEGER NOT NULL,
                PRIMARY KEY (id),
                FOREIGN KEY (moment_id) REFERENCES moment_table (id)
              );
            ''');

            // 2) 기존 테이블에서 메타데이터만 복사 (path는 일단 빈 문자열)
            await customStatement('''
              INSERT INTO media_table_new (id, moment_id, path, mime_type, created_at)
              SELECT id, moment_id, '' as path, mime_type, created_at FROM media_table;
            ''');

            // 3) 기존 테이블 삭제 후 이름 변경
            await customStatement('DROP TABLE media_table;');
            await customStatement(
                'ALTER TABLE media_table_new RENAME TO media_table;');
          }
        },
      );
}

LazyDatabase _openConnection(String dbPath) {
  return LazyDatabase(() async {
    final file = File(dbPath);
    if (!file.parent.existsSync()) {
      await file.parent.create(recursive: true);
    }
    return NativeDatabase.createInBackground(file);
  });
}
