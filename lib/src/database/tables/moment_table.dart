import 'package:drift/drift.dart';

@DataClassName('MomentTableData')
class MomentTable extends Table {
  TextColumn get id => text()();
  TextColumn get reflection => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
