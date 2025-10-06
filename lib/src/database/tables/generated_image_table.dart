import 'package:diary_mobile_client/src/database/tables/moment_table.dart';
import 'package:drift/drift.dart';

@DataClassName('GeneratedImageTableData')
class GeneratedImageTable extends Table {
  TextColumn get id => text()();
  TextColumn get momentId => text().references(MomentTable, #id)();
  // 파일 시스템 상의 실제 파일 경로를 저장
  TextColumn get path => text()();
  TextColumn get mimeType => text()(); // image/jpeg, image/png 등
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
