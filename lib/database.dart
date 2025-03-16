import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stressed_unicorn/stress_definition.dart';

part 'database.g.dart';

class StressItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get stressType => intEnum<StressType>()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [StressItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'stressed_unicorn',
      native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
    );
  }
}
