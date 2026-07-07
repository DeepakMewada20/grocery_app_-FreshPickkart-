/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class DeliveryConfigRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  DeliveryConfigRow._({
    this.id,
    required this.configKey,
    required this.baseDeliveryFee,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory DeliveryConfigRow({
    _i1.UuidValue? id,
    required String configKey,
    required double baseDeliveryFee,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeliveryConfigRowImpl;

  factory DeliveryConfigRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryConfigRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      configKey: jsonSerialization['configKey'] as String,
      baseDeliveryFee: (jsonSerialization['baseDeliveryFee'] as num).toDouble(),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeliveryConfigRowTable();

  static const db = DeliveryConfigRowRepository._();

  @override
  _i1.UuidValue? id;

  String configKey;

  double baseDeliveryFee;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeliveryConfigRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryConfigRow copyWith({
    _i1.UuidValue? id,
    String? configKey,
    double? baseDeliveryFee,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryConfigRow',
      if (id != null) 'id': id?.toJson(),
      'configKey': configKey,
      'baseDeliveryFee': baseDeliveryFee,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static DeliveryConfigRowInclude include() {
    return DeliveryConfigRowInclude._();
  }

  static DeliveryConfigRowIncludeList includeList({
    _i1.WhereExpressionBuilder<DeliveryConfigRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryConfigRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryConfigRowTable>? orderByList,
    DeliveryConfigRowInclude? include,
  }) {
    return DeliveryConfigRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryConfigRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeliveryConfigRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryConfigRowImpl extends DeliveryConfigRow {
  _DeliveryConfigRowImpl({
    _i1.UuidValue? id,
    required String configKey,
    required double baseDeliveryFee,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         configKey: configKey,
         baseDeliveryFee: baseDeliveryFee,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliveryConfigRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryConfigRow copyWith({
    Object? id = _Undefined,
    String? configKey,
    double? baseDeliveryFee,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryConfigRow(
      id: id is _i1.UuidValue? ? id : this.id,
      configKey: configKey ?? this.configKey,
      baseDeliveryFee: baseDeliveryFee ?? this.baseDeliveryFee,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DeliveryConfigRowUpdateTable
    extends _i1.UpdateTable<DeliveryConfigRowTable> {
  DeliveryConfigRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> configKey(String value) => _i1.ColumnValue(
    table.configKey,
    value,
  );

  _i1.ColumnValue<double, double> baseDeliveryFee(double value) =>
      _i1.ColumnValue(
        table.baseDeliveryFee,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class DeliveryConfigRowTable extends _i1.Table<_i1.UuidValue?> {
  DeliveryConfigRowTable({super.tableRelation})
    : super(tableName: 'delivery_config') {
    updateTable = DeliveryConfigRowUpdateTable(this);
    configKey = _i1.ColumnString(
      'configKey',
      this,
    );
    baseDeliveryFee = _i1.ColumnDouble(
      'baseDeliveryFee',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final DeliveryConfigRowUpdateTable updateTable;

  late final _i1.ColumnString configKey;

  late final _i1.ColumnDouble baseDeliveryFee;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    configKey,
    baseDeliveryFee,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class DeliveryConfigRowInclude extends _i1.IncludeObject {
  DeliveryConfigRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryConfigRow.t;
}

class DeliveryConfigRowIncludeList extends _i1.IncludeList {
  DeliveryConfigRowIncludeList._({
    _i1.WhereExpressionBuilder<DeliveryConfigRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeliveryConfigRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryConfigRow.t;
}

class DeliveryConfigRowRepository {
  const DeliveryConfigRowRepository._();

  /// Returns a list of [DeliveryConfigRow]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DeliveryConfigRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryConfigRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryConfigRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryConfigRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeliveryConfigRow>(
      where: where?.call(DeliveryConfigRow.t),
      orderBy: orderBy?.call(DeliveryConfigRow.t),
      orderByList: orderByList?.call(DeliveryConfigRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeliveryConfigRow] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DeliveryConfigRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryConfigRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeliveryConfigRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryConfigRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeliveryConfigRow>(
      where: where?.call(DeliveryConfigRow.t),
      orderBy: orderBy?.call(DeliveryConfigRow.t),
      orderByList: orderByList?.call(DeliveryConfigRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeliveryConfigRow] by its [id] or null if no such row exists.
  Future<DeliveryConfigRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeliveryConfigRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeliveryConfigRow]s in the list and returns the inserted rows.
  ///
  /// The returned [DeliveryConfigRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeliveryConfigRow>> insert(
    _i1.DatabaseSession session,
    List<DeliveryConfigRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeliveryConfigRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeliveryConfigRow] and returns the inserted row.
  ///
  /// The returned [DeliveryConfigRow] will have its `id` field set.
  Future<DeliveryConfigRow> insertRow(
    _i1.DatabaseSession session,
    DeliveryConfigRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeliveryConfigRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryConfigRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeliveryConfigRow>> update(
    _i1.DatabaseSession session,
    List<DeliveryConfigRow> rows, {
    _i1.ColumnSelections<DeliveryConfigRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeliveryConfigRow>(
      rows,
      columns: columns?.call(DeliveryConfigRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryConfigRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeliveryConfigRow> updateRow(
    _i1.DatabaseSession session,
    DeliveryConfigRow row, {
    _i1.ColumnSelections<DeliveryConfigRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeliveryConfigRow>(
      row,
      columns: columns?.call(DeliveryConfigRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryConfigRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeliveryConfigRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DeliveryConfigRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeliveryConfigRow>(
      id,
      columnValues: columnValues(DeliveryConfigRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryConfigRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeliveryConfigRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeliveryConfigRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeliveryConfigRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryConfigRowTable>? orderBy,
    _i1.OrderByListBuilder<DeliveryConfigRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeliveryConfigRow>(
      columnValues: columnValues(DeliveryConfigRow.t.updateTable),
      where: where(DeliveryConfigRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryConfigRow.t),
      orderByList: orderByList?.call(DeliveryConfigRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeliveryConfigRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeliveryConfigRow>> delete(
    _i1.DatabaseSession session,
    List<DeliveryConfigRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeliveryConfigRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeliveryConfigRow].
  Future<DeliveryConfigRow> deleteRow(
    _i1.DatabaseSession session,
    DeliveryConfigRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeliveryConfigRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeliveryConfigRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryConfigRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeliveryConfigRow>(
      where: where(DeliveryConfigRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryConfigRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeliveryConfigRow>(
      where: where?.call(DeliveryConfigRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeliveryConfigRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryConfigRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeliveryConfigRow>(
      where: where(DeliveryConfigRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
