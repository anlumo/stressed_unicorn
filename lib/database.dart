import 'dart:convert';

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

  Future<String> exportJson() async {
    final queryFuture = select(stressItems)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    final query = await queryFuture.get();
    return jsonEncode(
      query
          .map((row) => {'stressType': row.stressType.name, 'createdAt': row.createdAt.toIso8601String()})
          .toList(growable: false),
    );
  }

  Future<int> importJson(String jsonText) async {
    final json = jsonDecode(jsonText) as List<dynamic>;

    await batch((batch) {
      batch.insertAll(
        stressItems,
        json.map((row) {
          final stressRow = row as Map<String, dynamic>;
          return StressItemsCompanion.insert(
            stressType: StressType.values.firstWhere((stressType) => stressType.name == stressRow['stressType']),
            createdAt: DateTime.parse(stressRow['createdAt']),
          );
        }),
      );
    });
    return json.length;
  }

  Future<int> clear() {
    return delete(stressItems).go();
  }
}
