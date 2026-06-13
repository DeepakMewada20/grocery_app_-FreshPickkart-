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

abstract class DeliverySlabRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  DeliverySlabRow._({
    this.id,
    required this.configId,
    required this.minOrderAmount,
    required this.maxOrderAmount,
    required this.fee,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : sortOrder = sortOrder ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory DeliverySlabRow({
    _i1.UuidValue? id,
    required _i1.UuidValue configId,
    required double minOrderAmount,
    required double maxOrderAmount,
    required double fee,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeliverySlabRowImpl;

  factory DeliverySlabRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliverySlabRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      configId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['configId'],
      ),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxOrderAmount: (jsonSerialization['maxOrderAmount'] as num).toDouble(),
      fee: (jsonSerialization['fee'] as num).toDouble(),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeliverySlabRowTable();

  static const db = DeliverySlabRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue configId;

  double minOrderAmount;

  double maxOrderAmount;

  double fee;

  int sortOrder;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeliverySlabRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliverySlabRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? configId,
    double? minOrderAmount,
    double? maxOrderAmount,
    double? fee,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliverySlabRow',
      if (id != null) 'id': id?.toJson(),
      'configId': configId.toJson(),
      'minOrderAmount': minOrderAmount,
      'maxOrderAmount': maxOrderAmount,
      'fee': fee,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static DeliverySlabRowInclude include() {
    return DeliverySlabRowInclude._();
  }

  static DeliverySlabRowIncludeList includeList({
    _i1.WhereExpressionBuilder<DeliverySlabRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySlabRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySlabRowTable>? orderByList,
    DeliverySlabRowInclude? include,
  }) {
    return DeliverySlabRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliverySlabRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeliverySlabRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliverySlabRowImpl extends DeliverySlabRow {
  _DeliverySlabRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue configId,
    required double minOrderAmount,
    required double maxOrderAmount,
    required double fee,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         configId: configId,
         minOrderAmount: minOrderAmount,
         maxOrderAmount: maxOrderAmount,
         fee: fee,
         sortOrder: sortOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliverySlabRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliverySlabRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? configId,
    double? minOrderAmount,
    double? maxOrderAmount,
    double? fee,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliverySlabRow(
      id: id is _i1.UuidValue? ? id : this.id,
      configId: configId ?? this.configId,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxOrderAmount: maxOrderAmount ?? this.maxOrderAmount,
      fee: fee ?? this.fee,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DeliverySlabRowUpdateTable extends _i1.UpdateTable<DeliverySlabRowTable> {
  DeliverySlabRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> configId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.configId,
        value,
      );

  _i1.ColumnValue<double, double> minOrderAmount(double value) =>
      _i1.ColumnValue(
        table.minOrderAmount,
        value,
      );

  _i1.ColumnValue<double, double> maxOrderAmount(double value) =>
      _i1.ColumnValue(
        table.maxOrderAmount,
        value,
      );

  _i1.ColumnValue<double, double> fee(double value) => _i1.ColumnValue(
    table.fee,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
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

class DeliverySlabRowTable extends _i1.Table<_i1.UuidValue?> {
  DeliverySlabRowTable({super.tableRelation})
    : super(tableName: 'delivery_slab') {
    updateTable = DeliverySlabRowUpdateTable(this);
    configId = _i1.ColumnUuid(
      'configId',
      this,
    );
    minOrderAmount = _i1.ColumnDouble(
      'minOrderAmount',
      this,
    );
    maxOrderAmount = _i1.ColumnDouble(
      'maxOrderAmount',
      this,
    );
    fee = _i1.ColumnDouble(
      'fee',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
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

  late final DeliverySlabRowUpdateTable updateTable;

  late final _i1.ColumnUuid configId;

  late final _i1.ColumnDouble minOrderAmount;

  late final _i1.ColumnDouble maxOrderAmount;

  late final _i1.ColumnDouble fee;

  late final _i1.ColumnInt sortOrder;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    configId,
    minOrderAmount,
    maxOrderAmount,
    fee,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}

class DeliverySlabRowInclude extends _i1.IncludeObject {
  DeliverySlabRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliverySlabRow.t;
}

class DeliverySlabRowIncludeList extends _i1.IncludeList {
  DeliverySlabRowIncludeList._({
    _i1.WhereExpressionBuilder<DeliverySlabRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeliverySlabRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliverySlabRow.t;
}

class DeliverySlabRowRepository {
  const DeliverySlabRowRepository._();

  /// Returns a list of [DeliverySlabRow]s matching the given query parameters.
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
  Future<List<DeliverySlabRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySlabRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySlabRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySlabRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeliverySlabRow>(
      where: where?.call(DeliverySlabRow.t),
      orderBy: orderBy?.call(DeliverySlabRow.t),
      orderByList: orderByList?.call(DeliverySlabRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeliverySlabRow] matching the given query parameters.
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
  Future<DeliverySlabRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySlabRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeliverySlabRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySlabRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeliverySlabRow>(
      where: where?.call(DeliverySlabRow.t),
      orderBy: orderBy?.call(DeliverySlabRow.t),
      orderByList: orderByList?.call(DeliverySlabRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeliverySlabRow] by its [id] or null if no such row exists.
  Future<DeliverySlabRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeliverySlabRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeliverySlabRow]s in the list and returns the inserted rows.
  ///
  /// The returned [DeliverySlabRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeliverySlabRow>> insert(
    _i1.DatabaseSession session,
    List<DeliverySlabRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeliverySlabRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeliverySlabRow] and returns the inserted row.
  ///
  /// The returned [DeliverySlabRow] will have its `id` field set.
  Future<DeliverySlabRow> insertRow(
    _i1.DatabaseSession session,
    DeliverySlabRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeliverySlabRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeliverySlabRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeliverySlabRow>> update(
    _i1.DatabaseSession session,
    List<DeliverySlabRow> rows, {
    _i1.ColumnSelections<DeliverySlabRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeliverySlabRow>(
      rows,
      columns: columns?.call(DeliverySlabRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliverySlabRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeliverySlabRow> updateRow(
    _i1.DatabaseSession session,
    DeliverySlabRow row, {
    _i1.ColumnSelections<DeliverySlabRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeliverySlabRow>(
      row,
      columns: columns?.call(DeliverySlabRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliverySlabRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeliverySlabRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DeliverySlabRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeliverySlabRow>(
      id,
      columnValues: columnValues(DeliverySlabRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeliverySlabRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeliverySlabRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeliverySlabRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeliverySlabRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySlabRowTable>? orderBy,
    _i1.OrderByListBuilder<DeliverySlabRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeliverySlabRow>(
      columnValues: columnValues(DeliverySlabRow.t.updateTable),
      where: where(DeliverySlabRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliverySlabRow.t),
      orderByList: orderByList?.call(DeliverySlabRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeliverySlabRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeliverySlabRow>> delete(
    _i1.DatabaseSession session,
    List<DeliverySlabRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeliverySlabRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeliverySlabRow].
  Future<DeliverySlabRow> deleteRow(
    _i1.DatabaseSession session,
    DeliverySlabRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeliverySlabRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeliverySlabRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliverySlabRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeliverySlabRow>(
      where: where(DeliverySlabRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySlabRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeliverySlabRow>(
      where: where?.call(DeliverySlabRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeliverySlabRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliverySlabRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeliverySlabRow>(
      where: where(DeliverySlabRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
