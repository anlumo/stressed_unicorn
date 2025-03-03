// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StressItemsTable extends StressItems
    with TableInfo<$StressItemsTable, StressItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StressItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _stressTypeMeta = const VerificationMeta(
    'stressType',
  );
  @override
  late final GeneratedColumnWithTypeConverter<StressType, int> stressType =
      GeneratedColumn<int>(
        'stress_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StressType>($StressItemsTable.$converterstressType);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, stressType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stress_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StressItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_stressTypeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StressItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StressItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      stressType: $StressItemsTable.$converterstressType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}stress_type'],
        )!,
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $StressItemsTable createAlias(String alias) {
    return $StressItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StressType, int, int> $converterstressType =
      const EnumIndexConverter<StressType>(StressType.values);
}

class StressItem extends DataClass implements Insertable<StressItem> {
  final int id;
  final StressType stressType;
  final DateTime createdAt;
  const StressItem({
    required this.id,
    required this.stressType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['stress_type'] = Variable<int>(
        $StressItemsTable.$converterstressType.toSql(stressType),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StressItemsCompanion toCompanion(bool nullToAbsent) {
    return StressItemsCompanion(
      id: Value(id),
      stressType: Value(stressType),
      createdAt: Value(createdAt),
    );
  }

  factory StressItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StressItem(
      id: serializer.fromJson<int>(json['id']),
      stressType: $StressItemsTable.$converterstressType.fromJson(
        serializer.fromJson<int>(json['stressType']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stressType': serializer.toJson<int>(
        $StressItemsTable.$converterstressType.toJson(stressType),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StressItem copyWith({int? id, StressType? stressType, DateTime? createdAt}) =>
      StressItem(
        id: id ?? this.id,
        stressType: stressType ?? this.stressType,
        createdAt: createdAt ?? this.createdAt,
      );
  StressItem copyWithCompanion(StressItemsCompanion data) {
    return StressItem(
      id: data.id.present ? data.id.value : this.id,
      stressType:
          data.stressType.present ? data.stressType.value : this.stressType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StressItem(')
          ..write('id: $id, ')
          ..write('stressType: $stressType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stressType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StressItem &&
          other.id == this.id &&
          other.stressType == this.stressType &&
          other.createdAt == this.createdAt);
}

class StressItemsCompanion extends UpdateCompanion<StressItem> {
  final Value<int> id;
  final Value<StressType> stressType;
  final Value<DateTime> createdAt;
  const StressItemsCompanion({
    this.id = const Value.absent(),
    this.stressType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StressItemsCompanion.insert({
    this.id = const Value.absent(),
    required StressType stressType,
    required DateTime createdAt,
  }) : stressType = Value(stressType),
       createdAt = Value(createdAt);
  static Insertable<StressItem> custom({
    Expression<int>? id,
    Expression<int>? stressType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stressType != null) 'stress_type': stressType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StressItemsCompanion copyWith({
    Value<int>? id,
    Value<StressType>? stressType,
    Value<DateTime>? createdAt,
  }) {
    return StressItemsCompanion(
      id: id ?? this.id,
      stressType: stressType ?? this.stressType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stressType.present) {
      map['stress_type'] = Variable<int>(
        $StressItemsTable.$converterstressType.toSql(stressType.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StressItemsCompanion(')
          ..write('id: $id, ')
          ..write('stressType: $stressType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StressItemsTable stressItems = $StressItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [stressItems];
}

typedef $$StressItemsTableCreateCompanionBuilder =
    StressItemsCompanion Function({
      Value<int> id,
      required StressType stressType,
      required DateTime createdAt,
    });
typedef $$StressItemsTableUpdateCompanionBuilder =
    StressItemsCompanion Function({
      Value<int> id,
      Value<StressType> stressType,
      Value<DateTime> createdAt,
    });

class $$StressItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StressItemsTable> {
  $$StressItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StressType, StressType, int> get stressType =>
      $composableBuilder(
        column: $table.stressType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StressItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StressItemsTable> {
  $$StressItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressType => $composableBuilder(
    column: $table.stressType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StressItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StressItemsTable> {
  $$StressItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StressType, int> get stressType =>
      $composableBuilder(
        column: $table.stressType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StressItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StressItemsTable,
          StressItem,
          $$StressItemsTableFilterComposer,
          $$StressItemsTableOrderingComposer,
          $$StressItemsTableAnnotationComposer,
          $$StressItemsTableCreateCompanionBuilder,
          $$StressItemsTableUpdateCompanionBuilder,
          (
            StressItem,
            BaseReferences<_$AppDatabase, $StressItemsTable, StressItem>,
          ),
          StressItem,
          PrefetchHooks Function()
        > {
  $$StressItemsTableTableManager(_$AppDatabase db, $StressItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StressItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StressItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$StressItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<StressType> stressType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StressItemsCompanion(
                id: id,
                stressType: stressType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required StressType stressType,
                required DateTime createdAt,
              }) => StressItemsCompanion.insert(
                id: id,
                stressType: stressType,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StressItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StressItemsTable,
      StressItem,
      $$StressItemsTableFilterComposer,
      $$StressItemsTableOrderingComposer,
      $$StressItemsTableAnnotationComposer,
      $$StressItemsTableCreateCompanionBuilder,
      $$StressItemsTableUpdateCompanionBuilder,
      (
        StressItem,
        BaseReferences<_$AppDatabase, $StressItemsTable, StressItem>,
      ),
      StressItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StressItemsTableTableManager get stressItems =>
      $$StressItemsTableTableManager(_db, _db.stressItems);
}
