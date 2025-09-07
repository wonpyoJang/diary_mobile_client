import 'package:drift/drift.dart';
import 'moment_table.dart';
import '../../feature/common/moment/domain/enums/emotion.dart';

class EmotionalIntensityTable extends Table {
  TextColumn get id => text()();
  TextColumn get emotion => textEnum<Emotion>()();
  RealColumn get intensity => real()();
  TextColumn get momentId => text().references(MomentTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
