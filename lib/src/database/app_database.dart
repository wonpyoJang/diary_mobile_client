import 'package:diary_mobile_client/src/database/tables/media_table.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:drift/drift.dart';
import 'package:diary_mobile_client/src/database/tables/emotional_intensity_table.dart';
import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MomentTable, EmotionalIntensityTable, MediaTable])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
