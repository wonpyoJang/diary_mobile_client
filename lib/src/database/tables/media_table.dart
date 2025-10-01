import 'package:drift/drift.dart';
import 'moment_table.dart';

@DataClassName('MediaTableData')
class MediaTable extends Table {
  TextColumn get id => text()();
  TextColumn get momentId => text().references(MomentTable, #id)();
  // 파일 시스템 상의 실제 파일 경로를 저장
  TextColumn get path => text()();
  TextColumn get mimeType => text()(); // image/jpeg, image/png 등
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
