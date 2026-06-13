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

abstract class OrderNotificationOutboxRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  OrderNotificationOutboxRow._({
    this.id,
    required this.dedupeKey,
    required this.eventType,
    required this.orderId,
    this.userId,
    this.status,
    required this.payloadJson,
    int? attemptCount,
    this.lastError,
    this.processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : attemptCount = attemptCount ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory OrderNotificationOutboxRow({
    _i1.UuidValue? id,
    required String dedupeKey,
    required String eventType,
    required String orderId,
    String? userId,
    String? status,
    required String payloadJson,
    int? attemptCount,
    String? lastError,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrderNotificationOutboxRowImpl;

  factory OrderNotificationOutboxRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrderNotificationOutboxRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      eventType: jsonSerialization['eventType'] as String,
      orderId: jsonSerialization['orderId'] as String,
      userId: jsonSerialization['userId'] as String?,
      status: jsonSerialization['status'] as String?,
      payloadJson: jsonSerialization['payloadJson'] as String,
      attemptCount: jsonSerialization['attemptCount'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      processedAt: jsonSerialization['processedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['processedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = OrderNotificationOutboxRowTable();

  static const db = OrderNotificationOutboxRowRepository._();

  @override
  _i1.UuidValue? id;

  String dedupeKey;

  String eventType;

  String orderId;

  String? userId;

  String? status;

  String payloadJson;

  int attemptCount;

  String? lastError;

  DateTime? processedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OrderNotificationOutboxRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderNotificationOutboxRow copyWith({
    _i1.UuidValue? id,
    String? dedupeKey,
    String? eventType,
    String? orderId,
    String? userId,
    String? status,
    String? payloadJson,
    int? attemptCount,
    String? lastError,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderNotificationOutboxRow',
      if (id != null) 'id': id?.toJson(),
      'dedupeKey': dedupeKey,
      'eventType': eventType,
      'orderId': orderId,
      if (userId != null) 'userId': userId,
      if (status != null) 'status': status,
      'payloadJson': payloadJson,
      'attemptCount': attemptCount,
      if (lastError != null) 'lastError': lastError,
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static OrderNotificationOutboxRowInclude include() {
    return OrderNotificationOutboxRowInclude._();
  }

  static OrderNotificationOutboxRowIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderNotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderNotificationOutboxRowTable>? orderByList,
    OrderNotificationOutboxRowInclude? include,
  }) {
    return OrderNotificationOutboxRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderNotificationOutboxRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderNotificationOutboxRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderNotificationOutboxRowImpl extends OrderNotificationOutboxRow {
  _OrderNotificationOutboxRowImpl({
    _i1.UuidValue? id,
    required String dedupeKey,
    required String eventType,
    required String orderId,
    String? userId,
    String? status,
    required String payloadJson,
    int? attemptCount,
    String? lastError,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         dedupeKey: dedupeKey,
         eventType: eventType,
         orderId: orderId,
         userId: userId,
         status: status,
         payloadJson: payloadJson,
         attemptCount: attemptCount,
         lastError: lastError,
         processedAt: processedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OrderNotificationOutboxRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderNotificationOutboxRow copyWith({
    Object? id = _Undefined,
    String? dedupeKey,
    String? eventType,
    String? orderId,
    Object? userId = _Undefined,
    Object? status = _Undefined,
    String? payloadJson,
    int? attemptCount,
    Object? lastError = _Undefined,
    Object? processedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderNotificationOutboxRow(
      id: id is _i1.UuidValue? ? id : this.id,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      eventType: eventType ?? this.eventType,
      orderId: orderId ?? this.orderId,
      userId: userId is String? ? userId : this.userId,
      status: status is String? ? status : this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError is String? ? lastError : this.lastError,
      processedAt: processedAt is DateTime? ? processedAt : this.processedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderNotificationOutboxRowUpdateTable
    extends _i1.UpdateTable<OrderNotificationOutboxRowTable> {
  OrderNotificationOutboxRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> dedupeKey(String value) => _i1.ColumnValue(
    table.dedupeKey,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> orderId(String value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> status(String? value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );

  _i1.ColumnValue<int, int> attemptCount(int value) => _i1.ColumnValue(
    table.attemptCount,
    value,
  );

  _i1.ColumnValue<String, String> lastError(String? value) => _i1.ColumnValue(
    table.lastError,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> processedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.processedAt,
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

class OrderNotificationOutboxRowTable extends _i1.Table<_i1.UuidValue?> {
  OrderNotificationOutboxRowTable({super.tableRelation})
    : super(tableName: 'order_notification_outbox') {
    updateTable = OrderNotificationOutboxRowUpdateTable(this);
    dedupeKey = _i1.ColumnString(
      'dedupeKey',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    orderId = _i1.ColumnString(
      'orderId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
      this,
      hasDefault: true,
    );
    lastError = _i1.ColumnString(
      'lastError',
      this,
    );
    processedAt = _i1.ColumnDateTime(
      'processedAt',
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

  late final OrderNotificationOutboxRowUpdateTable updateTable;

  late final _i1.ColumnString dedupeKey;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString orderId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString status;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnString lastError;

  late final _i1.ColumnDateTime processedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    dedupeKey,
    eventType,
    orderId,
    userId,
    status,
    payloadJson,
    attemptCount,
    lastError,
    processedAt,
    createdAt,
    updatedAt,
  ];
}

class OrderNotificationOutboxRowInclude extends _i1.IncludeObject {
  OrderNotificationOutboxRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderNotificationOutboxRow.t;
}

class OrderNotificationOutboxRowIncludeList extends _i1.IncludeList {
  OrderNotificationOutboxRowIncludeList._({
    _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderNotificationOutboxRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderNotificationOutboxRow.t;
}

class OrderNotificationOutboxRowRepository {
  const OrderNotificationOutboxRowRepository._();

  /// Returns a list of [OrderNotificationOutboxRow]s matching the given query parameters.
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
  Future<List<OrderNotificationOutboxRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderNotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderNotificationOutboxRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderNotificationOutboxRow>(
      where: where?.call(OrderNotificationOutboxRow.t),
      orderBy: orderBy?.call(OrderNotificationOutboxRow.t),
      orderByList: orderByList?.call(OrderNotificationOutboxRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderNotificationOutboxRow] matching the given query parameters.
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
  Future<OrderNotificationOutboxRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderNotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderNotificationOutboxRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderNotificationOutboxRow>(
      where: where?.call(OrderNotificationOutboxRow.t),
      orderBy: orderBy?.call(OrderNotificationOutboxRow.t),
      orderByList: orderByList?.call(OrderNotificationOutboxRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderNotificationOutboxRow] by its [id] or null if no such row exists.
  Future<OrderNotificationOutboxRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderNotificationOutboxRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderNotificationOutboxRow]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderNotificationOutboxRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderNotificationOutboxRow>> insert(
    _i1.DatabaseSession session,
    List<OrderNotificationOutboxRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderNotificationOutboxRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderNotificationOutboxRow] and returns the inserted row.
  ///
  /// The returned [OrderNotificationOutboxRow] will have its `id` field set.
  Future<OrderNotificationOutboxRow> insertRow(
    _i1.DatabaseSession session,
    OrderNotificationOutboxRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderNotificationOutboxRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderNotificationOutboxRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderNotificationOutboxRow>> update(
    _i1.DatabaseSession session,
    List<OrderNotificationOutboxRow> rows, {
    _i1.ColumnSelections<OrderNotificationOutboxRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderNotificationOutboxRow>(
      rows,
      columns: columns?.call(OrderNotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderNotificationOutboxRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderNotificationOutboxRow> updateRow(
    _i1.DatabaseSession session,
    OrderNotificationOutboxRow row, {
    _i1.ColumnSelections<OrderNotificationOutboxRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderNotificationOutboxRow>(
      row,
      columns: columns?.call(OrderNotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderNotificationOutboxRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderNotificationOutboxRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<OrderNotificationOutboxRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderNotificationOutboxRow>(
      id,
      columnValues: columnValues(OrderNotificationOutboxRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderNotificationOutboxRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderNotificationOutboxRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderNotificationOutboxRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderNotificationOutboxRowTable>? orderBy,
    _i1.OrderByListBuilder<OrderNotificationOutboxRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderNotificationOutboxRow>(
      columnValues: columnValues(OrderNotificationOutboxRow.t.updateTable),
      where: where(OrderNotificationOutboxRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderNotificationOutboxRow.t),
      orderByList: orderByList?.call(OrderNotificationOutboxRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderNotificationOutboxRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderNotificationOutboxRow>> delete(
    _i1.DatabaseSession session,
    List<OrderNotificationOutboxRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderNotificationOutboxRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderNotificationOutboxRow].
  Future<OrderNotificationOutboxRow> deleteRow(
    _i1.DatabaseSession session,
    OrderNotificationOutboxRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderNotificationOutboxRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderNotificationOutboxRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderNotificationOutboxRow>(
      where: where(OrderNotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderNotificationOutboxRow>(
      where: where?.call(OrderNotificationOutboxRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderNotificationOutboxRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderNotificationOutboxRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderNotificationOutboxRow>(
      where: where(OrderNotificationOutboxRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
