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

abstract class ProductSearchRebuildJobRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ProductSearchRebuildJobRow._({
    this.id,
    required this.productId,
    required this.reason,
    String? jobStatus,
    int? attemptCount,
    DateTime? scheduledAt,
    this.startedAt,
    this.finishedAt,
    this.lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : jobStatus = jobStatus ?? 'pending',
       attemptCount = attemptCount ?? 0,
       scheduledAt = scheduledAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProductSearchRebuildJobRow({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String reason,
    String? jobStatus,
    int? attemptCount,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductSearchRebuildJobRowImpl;

  factory ProductSearchRebuildJobRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProductSearchRebuildJobRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      reason: jsonSerialization['reason'] as String,
      jobStatus: jsonSerialization['jobStatus'] as String?,
      attemptCount: jsonSerialization['attemptCount'] as int?,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      lastError: jsonSerialization['lastError'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProductSearchRebuildJobRowTable();

  static const db = ProductSearchRebuildJobRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue productId;

  String reason;

  String jobStatus;

  int attemptCount;

  DateTime scheduledAt;

  DateTime? startedAt;

  DateTime? finishedAt;

  String? lastError;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductSearchRebuildJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductSearchRebuildJobRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? productId,
    String? reason,
    String? jobStatus,
    int? attemptCount,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSearchRebuildJobRow',
      if (id != null) 'id': id?.toJson(),
      'productId': productId.toJson(),
      'reason': reason,
      'jobStatus': jobStatus,
      'attemptCount': attemptCount,
      'scheduledAt': scheduledAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProductSearchRebuildJobRowInclude include() {
    return ProductSearchRebuildJobRowInclude._();
  }

  static ProductSearchRebuildJobRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchRebuildJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchRebuildJobRowTable>? orderByList,
    ProductSearchRebuildJobRowInclude? include,
  }) {
    return ProductSearchRebuildJobRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSearchRebuildJobRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProductSearchRebuildJobRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductSearchRebuildJobRowImpl extends ProductSearchRebuildJobRow {
  _ProductSearchRebuildJobRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String reason,
    String? jobStatus,
    int? attemptCount,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         productId: productId,
         reason: reason,
         jobStatus: jobStatus,
         attemptCount: attemptCount,
         scheduledAt: scheduledAt,
         startedAt: startedAt,
         finishedAt: finishedAt,
         lastError: lastError,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProductSearchRebuildJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductSearchRebuildJobRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? productId,
    String? reason,
    String? jobStatus,
    int? attemptCount,
    DateTime? scheduledAt,
    Object? startedAt = _Undefined,
    Object? finishedAt = _Undefined,
    Object? lastError = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductSearchRebuildJobRow(
      id: id is _i1.UuidValue? ? id : this.id,
      productId: productId ?? this.productId,
      reason: reason ?? this.reason,
      jobStatus: jobStatus ?? this.jobStatus,
      attemptCount: attemptCount ?? this.attemptCount,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      lastError: lastError is String? ? lastError : this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProductSearchRebuildJobRowUpdateTable
    extends _i1.UpdateTable<ProductSearchRebuildJobRowTable> {
  ProductSearchRebuildJobRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> jobStatus(String value) => _i1.ColumnValue(
    table.jobStatus,
    value,
  );

  _i1.ColumnValue<int, int> attemptCount(int value) => _i1.ColumnValue(
    table.attemptCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.startedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.finishedAt,
        value,
      );

  _i1.ColumnValue<String, String> lastError(String? value) => _i1.ColumnValue(
    table.lastError,
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

class ProductSearchRebuildJobRowTable extends _i1.Table<_i1.UuidValue?> {
  ProductSearchRebuildJobRowTable({super.tableRelation})
    : super(tableName: 'product_search_rebuild_job') {
    updateTable = ProductSearchRebuildJobRowUpdateTable(this);
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    jobStatus = _i1.ColumnString(
      'jobStatus',
      this,
      hasDefault: true,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
      this,
      hasDefault: true,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
      hasDefault: true,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
    );
    finishedAt = _i1.ColumnDateTime(
      'finishedAt',
      this,
    );
    lastError = _i1.ColumnString(
      'lastError',
      this,
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

  late final ProductSearchRebuildJobRowUpdateTable updateTable;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString jobStatus;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnDateTime scheduledAt;

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnDateTime finishedAt;

  late final _i1.ColumnString lastError;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    reason,
    jobStatus,
    attemptCount,
    scheduledAt,
    startedAt,
    finishedAt,
    lastError,
    createdAt,
    updatedAt,
  ];
}

class ProductSearchRebuildJobRowInclude extends _i1.IncludeObject {
  ProductSearchRebuildJobRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSearchRebuildJobRow.t;
}

class ProductSearchRebuildJobRowIncludeList extends _i1.IncludeList {
  ProductSearchRebuildJobRowIncludeList._({
    _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductSearchRebuildJobRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSearchRebuildJobRow.t;
}

class ProductSearchRebuildJobRowRepository {
  const ProductSearchRebuildJobRowRepository._();

  /// Returns a list of [ProductSearchRebuildJobRow]s matching the given query parameters.
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
  Future<List<ProductSearchRebuildJobRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchRebuildJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchRebuildJobRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductSearchRebuildJobRow>(
      where: where?.call(ProductSearchRebuildJobRow.t),
      orderBy: orderBy?.call(ProductSearchRebuildJobRow.t),
      orderByList: orderByList?.call(ProductSearchRebuildJobRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductSearchRebuildJobRow] matching the given query parameters.
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
  Future<ProductSearchRebuildJobRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductSearchRebuildJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchRebuildJobRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductSearchRebuildJobRow>(
      where: where?.call(ProductSearchRebuildJobRow.t),
      orderBy: orderBy?.call(ProductSearchRebuildJobRow.t),
      orderByList: orderByList?.call(ProductSearchRebuildJobRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductSearchRebuildJobRow] by its [id] or null if no such row exists.
  Future<ProductSearchRebuildJobRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductSearchRebuildJobRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductSearchRebuildJobRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductSearchRebuildJobRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProductSearchRebuildJobRow>> insert(
    _i1.DatabaseSession session,
    List<ProductSearchRebuildJobRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProductSearchRebuildJobRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProductSearchRebuildJobRow] and returns the inserted row.
  ///
  /// The returned [ProductSearchRebuildJobRow] will have its `id` field set.
  Future<ProductSearchRebuildJobRow> insertRow(
    _i1.DatabaseSession session,
    ProductSearchRebuildJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductSearchRebuildJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProductSearchRebuildJobRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProductSearchRebuildJobRow>> update(
    _i1.DatabaseSession session,
    List<ProductSearchRebuildJobRow> rows, {
    _i1.ColumnSelections<ProductSearchRebuildJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProductSearchRebuildJobRow>(
      rows,
      columns: columns?.call(ProductSearchRebuildJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSearchRebuildJobRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductSearchRebuildJobRow> updateRow(
    _i1.DatabaseSession session,
    ProductSearchRebuildJobRow row, {
    _i1.ColumnSelections<ProductSearchRebuildJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductSearchRebuildJobRow>(
      row,
      columns: columns?.call(ProductSearchRebuildJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSearchRebuildJobRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductSearchRebuildJobRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ProductSearchRebuildJobRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductSearchRebuildJobRow>(
      id,
      columnValues: columnValues(ProductSearchRebuildJobRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductSearchRebuildJobRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProductSearchRebuildJobRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductSearchRebuildJobRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchRebuildJobRowTable>? orderBy,
    _i1.OrderByListBuilder<ProductSearchRebuildJobRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProductSearchRebuildJobRow>(
      columnValues: columnValues(ProductSearchRebuildJobRow.t.updateTable),
      where: where(ProductSearchRebuildJobRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSearchRebuildJobRow.t),
      orderByList: orderByList?.call(ProductSearchRebuildJobRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProductSearchRebuildJobRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProductSearchRebuildJobRow>> delete(
    _i1.DatabaseSession session,
    List<ProductSearchRebuildJobRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProductSearchRebuildJobRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProductSearchRebuildJobRow].
  Future<ProductSearchRebuildJobRow> deleteRow(
    _i1.DatabaseSession session,
    ProductSearchRebuildJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductSearchRebuildJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProductSearchRebuildJobRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProductSearchRebuildJobRow>(
      where: where(ProductSearchRebuildJobRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProductSearchRebuildJobRow>(
      where: where?.call(ProductSearchRebuildJobRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductSearchRebuildJobRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSearchRebuildJobRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductSearchRebuildJobRow>(
      where: where(ProductSearchRebuildJobRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
