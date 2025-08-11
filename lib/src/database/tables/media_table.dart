import 'package:drift/drift.dart';
import 'moment_table.dart';

@DataClassName('MediaTableData')
class MediaTable extends Table {
  TextColumn get id => text()();
  TextColumn get momentId => text().references(MomentTable, #id)();
  BlobColumn get data => blob()();
  TextColumn get mimeType => text()(); // image/jpeg, image/png 등
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
