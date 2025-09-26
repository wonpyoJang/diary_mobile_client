import 'package:drift/drift.dart';

@DataClassName('UserTableData')
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get profileImageUrl => text()();
  TextColumn get email => text()();

  @override
  Set<Column> get primaryKey => {id};
}
