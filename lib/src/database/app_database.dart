import 'package:diary_mobile_client/src/database/tables/media_table.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:drift/drift.dart';
import 'package:diary_mobile_client/src/database/tables/emotional_intensity_table.dart';
import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MomentTable, EmotionalIntensityTable, MediaTable])
@singleton
class Database extends _$Database {
  Database(String dbPath) : super(_openConnection(dbPath));

  @override
  int get schemaVersion => 1;
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
