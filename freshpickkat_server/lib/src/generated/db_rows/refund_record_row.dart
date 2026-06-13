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

abstract class RefundRecordRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  RefundRecordRow._({
    this.id,
    required this.orderId,
    required this.paymentTransactionId,
    required this.userId,
    this.gatewayRefundId,
    required this.amount,
    required this.refundStatus,
    String? source,
    String? reason,
    this.complaintId,
    this.failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : source = source ?? 'order',
       reason = reason ?? '',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory RefundRecordRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue paymentTransactionId,
    required _i1.UuidValue userId,
    String? gatewayRefundId,
    required double amount,
    required String refundStatus,
    String? source,
    String? reason,
    _i1.UuidValue? complaintId,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RefundRecordRowImpl;

  factory RefundRecordRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefundRecordRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      paymentTransactionId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['paymentTransactionId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      gatewayRefundId: jsonSerialization['gatewayRefundId'] as String?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      refundStatus: jsonSerialization['refundStatus'] as String,
      source: jsonSerialization['source'] as String?,
      reason: jsonSerialization['reason'] as String?,
      complaintId: jsonSerialization['complaintId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['complaintId'],
            ),
      failureReason: jsonSerialization['failureReason'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = RefundRecordRowTable();

  static const db = RefundRecordRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  _i1.UuidValue paymentTransactionId;

  _i1.UuidValue userId;

  String? gatewayRefundId;

  double amount;

  String refundStatus;

  String source;

  String reason;

  _i1.UuidValue? complaintId;

  String? failureReason;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RefundRecordRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefundRecordRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    _i1.UuidValue? paymentTransactionId,
    _i1.UuidValue? userId,
    String? gatewayRefundId,
    double? amount,
    String? refundStatus,
    String? source,
    String? reason,
    _i1.UuidValue? complaintId,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefundRecordRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'paymentTransactionId': paymentTransactionId.toJson(),
      'userId': userId.toJson(),
      if (gatewayRefundId != null) 'gatewayRefundId': gatewayRefundId,
      'amount': amount,
      'refundStatus': refundStatus,
      'source': source,
      'reason': reason,
      if (complaintId != null) 'complaintId': complaintId?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static RefundRecordRowInclude include() {
    return RefundRecordRowInclude._();
  }

  static RefundRecordRowIncludeList includeList({
    _i1.WhereExpressionBuilder<RefundRecordRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRecordRowTable>? orderByList,
    RefundRecordRowInclude? include,
  }) {
    return RefundRecordRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefundRecordRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RefundRecordRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefundRecordRowImpl extends RefundRecordRow {
  _RefundRecordRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue paymentTransactionId,
    required _i1.UuidValue userId,
    String? gatewayRefundId,
    required double amount,
    required String refundStatus,
    String? source,
    String? reason,
    _i1.UuidValue? complaintId,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         paymentTransactionId: paymentTransactionId,
         userId: userId,
         gatewayRefundId: gatewayRefundId,
         amount: amount,
         refundStatus: refundStatus,
         source: source,
         reason: reason,
         complaintId: complaintId,
         failureReason: failureReason,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RefundRecordRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefundRecordRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    _i1.UuidValue? paymentTransactionId,
    _i1.UuidValue? userId,
    Object? gatewayRefundId = _Undefined,
    double? amount,
    String? refundStatus,
    String? source,
    String? reason,
    Object? complaintId = _Undefined,
    Object? failureReason = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RefundRecordRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      userId: userId ?? this.userId,
      gatewayRefundId: gatewayRefundId is String?
          ? gatewayRefundId
          : this.gatewayRefundId,
      amount: amount ?? this.amount,
      refundStatus: refundStatus ?? this.refundStatus,
      source: source ?? this.source,
      reason: reason ?? this.reason,
      complaintId: complaintId is _i1.UuidValue?
          ? complaintId
          : this.complaintId,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RefundRecordRowUpdateTable extends _i1.UpdateTable<RefundRecordRowTable> {
  RefundRecordRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> paymentTransactionId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.paymentTransactionId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> gatewayRefundId(String? value) =>
      _i1.ColumnValue(
        table.gatewayRefundId,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> refundStatus(String value) => _i1.ColumnValue(
    table.refundStatus,
    value,
  );

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> complaintId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.complaintId,
    value,
  );

  _i1.ColumnValue<String, String> failureReason(String? value) =>
      _i1.ColumnValue(
        table.failureReason,
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

class RefundRecordRowTable extends _i1.Table<_i1.UuidValue?> {
  RefundRecordRowTable({super.tableRelation})
    : super(tableName: 'refund_record') {
    updateTable = RefundRecordRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    paymentTransactionId = _i1.ColumnUuid(
      'paymentTransactionId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    gatewayRefundId = _i1.ColumnString(
      'gatewayRefundId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    refundStatus = _i1.ColumnString(
      'refundStatus',
      this,
    );
    source = _i1.ColumnString(
      'source',
      this,
      hasDefault: true,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
      hasDefault: true,
    );
    complaintId = _i1.ColumnUuid(
      'complaintId',
      this,
    );
    failureReason = _i1.ColumnString(
      'failureReason',
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

  late final RefundRecordRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid paymentTransactionId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString gatewayRefundId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString refundStatus;

  late final _i1.ColumnString source;

  late final _i1.ColumnString reason;

  late final _i1.ColumnUuid complaintId;

  late final _i1.ColumnString failureReason;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    paymentTransactionId,
    userId,
    gatewayRefundId,
    amount,
    refundStatus,
    source,
    reason,
    complaintId,
    failureReason,
    createdAt,
    updatedAt,
  ];
}

class RefundRecordRowInclude extends _i1.IncludeObject {
  RefundRecordRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => RefundRecordRow.t;
}

class RefundRecordRowIncludeList extends _i1.IncludeList {
  RefundRecordRowIncludeList._({
    _i1.WhereExpressionBuilder<RefundRecordRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RefundRecordRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => RefundRecordRow.t;
}

class RefundRecordRowRepository {
  const RefundRecordRowRepository._();

  /// Returns a list of [RefundRecordRow]s matching the given query parameters.
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
  Future<List<RefundRecordRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRecordRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRecordRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RefundRecordRow>(
      where: where?.call(RefundRecordRow.t),
      orderBy: orderBy?.call(RefundRecordRow.t),
      orderByList: orderByList?.call(RefundRecordRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RefundRecordRow] matching the given query parameters.
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
  Future<RefundRecordRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRecordRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<RefundRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRecordRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RefundRecordRow>(
      where: where?.call(RefundRecordRow.t),
      orderBy: orderBy?.call(RefundRecordRow.t),
      orderByList: orderByList?.call(RefundRecordRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RefundRecordRow] by its [id] or null if no such row exists.
  Future<RefundRecordRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RefundRecordRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RefundRecordRow]s in the list and returns the inserted rows.
  ///
  /// The returned [RefundRecordRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RefundRecordRow>> insert(
    _i1.DatabaseSession session,
    List<RefundRecordRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RefundRecordRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RefundRecordRow] and returns the inserted row.
  ///
  /// The returned [RefundRecordRow] will have its `id` field set.
  Future<RefundRecordRow> insertRow(
    _i1.DatabaseSession session,
    RefundRecordRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefundRecordRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RefundRecordRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RefundRecordRow>> update(
    _i1.DatabaseSession session,
    List<RefundRecordRow> rows, {
    _i1.ColumnSelections<RefundRecordRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RefundRecordRow>(
      rows,
      columns: columns?.call(RefundRecordRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefundRecordRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RefundRecordRow> updateRow(
    _i1.DatabaseSession session,
    RefundRecordRow row, {
    _i1.ColumnSelections<RefundRecordRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefundRecordRow>(
      row,
      columns: columns?.call(RefundRecordRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefundRecordRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RefundRecordRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<RefundRecordRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RefundRecordRow>(
      id,
      columnValues: columnValues(RefundRecordRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RefundRecordRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RefundRecordRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RefundRecordRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RefundRecordRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRecordRowTable>? orderBy,
    _i1.OrderByListBuilder<RefundRecordRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RefundRecordRow>(
      columnValues: columnValues(RefundRecordRow.t.updateTable),
      where: where(RefundRecordRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefundRecordRow.t),
      orderByList: orderByList?.call(RefundRecordRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RefundRecordRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RefundRecordRow>> delete(
    _i1.DatabaseSession session,
    List<RefundRecordRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RefundRecordRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RefundRecordRow].
  Future<RefundRecordRow> deleteRow(
    _i1.DatabaseSession session,
    RefundRecordRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefundRecordRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RefundRecordRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefundRecordRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RefundRecordRow>(
      where: where(RefundRecordRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRecordRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RefundRecordRow>(
      where: where?.call(RefundRecordRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RefundRecordRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefundRecordRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RefundRecordRow>(
      where: where(RefundRecordRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
