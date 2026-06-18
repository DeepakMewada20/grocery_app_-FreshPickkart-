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

abstract class AutoRefundJobRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AutoRefundJobRow._({
    this.id,
    required this.orderId,
    required this.orderNumber,
    required this.customerId,
    required this.gatewayPaymentId,
    required this.paymentTransactionId,
    this.gatewayOrderId,
    required this.amount,
    String? currency,
    String? jobStatus,
    int? attemptCount,
    this.nextRetryAt,
    this.lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.processedAt,
  }) : currency = currency ?? 'INR',
       jobStatus = jobStatus ?? 'PENDING',
       attemptCount = attemptCount ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AutoRefundJobRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String orderNumber,
    required _i1.UuidValue customerId,
    required String gatewayPaymentId,
    required _i1.UuidValue paymentTransactionId,
    String? gatewayOrderId,
    required double amount,
    String? currency,
    String? jobStatus,
    int? attemptCount,
    DateTime? nextRetryAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? processedAt,
  }) = _AutoRefundJobRowImpl;

  factory AutoRefundJobRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AutoRefundJobRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      orderNumber: jsonSerialization['orderNumber'] as String,
      customerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['customerId'],
      ),
      gatewayPaymentId: jsonSerialization['gatewayPaymentId'] as String,
      paymentTransactionId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['paymentTransactionId'],
      ),
      gatewayOrderId: jsonSerialization['gatewayOrderId'] as String?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String?,
      jobStatus: jsonSerialization['jobStatus'] as String?,
      attemptCount: jsonSerialization['attemptCount'] as int?,
      nextRetryAt: jsonSerialization['nextRetryAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextRetryAt'],
            ),
      lastError: jsonSerialization['lastError'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      processedAt: jsonSerialization['processedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['processedAt'],
            ),
    );
  }

  static final t = AutoRefundJobRowTable();

  static const db = AutoRefundJobRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  String orderNumber;

  _i1.UuidValue customerId;

  String gatewayPaymentId;

  _i1.UuidValue paymentTransactionId;

  String? gatewayOrderId;

  double amount;

  String currency;

  String jobStatus;

  int attemptCount;

  DateTime? nextRetryAt;

  String? lastError;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? processedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AutoRefundJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AutoRefundJobRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    String? orderNumber,
    _i1.UuidValue? customerId,
    String? gatewayPaymentId,
    _i1.UuidValue? paymentTransactionId,
    String? gatewayOrderId,
    double? amount,
    String? currency,
    String? jobStatus,
    int? attemptCount,
    DateTime? nextRetryAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? processedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AutoRefundJobRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'orderNumber': orderNumber,
      'customerId': customerId.toJson(),
      'gatewayPaymentId': gatewayPaymentId,
      'paymentTransactionId': paymentTransactionId.toJson(),
      if (gatewayOrderId != null) 'gatewayOrderId': gatewayOrderId,
      'amount': amount,
      'currency': currency,
      'jobStatus': jobStatus,
      'attemptCount': attemptCount,
      if (nextRetryAt != null) 'nextRetryAt': nextRetryAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AutoRefundJobRowInclude include() {
    return AutoRefundJobRowInclude._();
  }

  static AutoRefundJobRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AutoRefundJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoRefundJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoRefundJobRowTable>? orderByList,
    AutoRefundJobRowInclude? include,
  }) {
    return AutoRefundJobRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoRefundJobRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AutoRefundJobRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AutoRefundJobRowImpl extends AutoRefundJobRow {
  _AutoRefundJobRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String orderNumber,
    required _i1.UuidValue customerId,
    required String gatewayPaymentId,
    required _i1.UuidValue paymentTransactionId,
    String? gatewayOrderId,
    required double amount,
    String? currency,
    String? jobStatus,
    int? attemptCount,
    DateTime? nextRetryAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? processedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         orderNumber: orderNumber,
         customerId: customerId,
         gatewayPaymentId: gatewayPaymentId,
         paymentTransactionId: paymentTransactionId,
         gatewayOrderId: gatewayOrderId,
         amount: amount,
         currency: currency,
         jobStatus: jobStatus,
         attemptCount: attemptCount,
         nextRetryAt: nextRetryAt,
         lastError: lastError,
         createdAt: createdAt,
         updatedAt: updatedAt,
         processedAt: processedAt,
       );

  /// Returns a shallow copy of this [AutoRefundJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AutoRefundJobRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    String? orderNumber,
    _i1.UuidValue? customerId,
    String? gatewayPaymentId,
    _i1.UuidValue? paymentTransactionId,
    Object? gatewayOrderId = _Undefined,
    double? amount,
    String? currency,
    String? jobStatus,
    int? attemptCount,
    Object? nextRetryAt = _Undefined,
    Object? lastError = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? processedAt = _Undefined,
  }) {
    return AutoRefundJobRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      gatewayPaymentId: gatewayPaymentId ?? this.gatewayPaymentId,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      gatewayOrderId: gatewayOrderId is String?
          ? gatewayOrderId
          : this.gatewayOrderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      jobStatus: jobStatus ?? this.jobStatus,
      attemptCount: attemptCount ?? this.attemptCount,
      nextRetryAt: nextRetryAt is DateTime? ? nextRetryAt : this.nextRetryAt,
      lastError: lastError is String? ? lastError : this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      processedAt: processedAt is DateTime? ? processedAt : this.processedAt,
    );
  }
}

class AutoRefundJobRowUpdateTable
    extends _i1.UpdateTable<AutoRefundJobRowTable> {
  AutoRefundJobRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<String, String> orderNumber(String value) => _i1.ColumnValue(
    table.orderNumber,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> customerId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> gatewayPaymentId(String value) =>
      _i1.ColumnValue(
        table.gatewayPaymentId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> paymentTransactionId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.paymentTransactionId,
    value,
  );

  _i1.ColumnValue<String, String> gatewayOrderId(String? value) =>
      _i1.ColumnValue(
        table.gatewayOrderId,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
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

  _i1.ColumnValue<DateTime, DateTime> nextRetryAt(DateTime? value) =>
      _i1.ColumnValue(
        table.nextRetryAt,
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

  _i1.ColumnValue<DateTime, DateTime> processedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.processedAt,
        value,
      );
}

class AutoRefundJobRowTable extends _i1.Table<_i1.UuidValue?> {
  AutoRefundJobRowTable({super.tableRelation})
    : super(tableName: 'auto_refund_job') {
    updateTable = AutoRefundJobRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    orderNumber = _i1.ColumnString(
      'orderNumber',
      this,
    );
    customerId = _i1.ColumnUuid(
      'customerId',
      this,
    );
    gatewayPaymentId = _i1.ColumnString(
      'gatewayPaymentId',
      this,
    );
    paymentTransactionId = _i1.ColumnUuid(
      'paymentTransactionId',
      this,
    );
    gatewayOrderId = _i1.ColumnString(
      'gatewayOrderId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
      hasDefault: true,
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
    nextRetryAt = _i1.ColumnDateTime(
      'nextRetryAt',
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
    processedAt = _i1.ColumnDateTime(
      'processedAt',
      this,
    );
  }

  late final AutoRefundJobRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnString orderNumber;

  late final _i1.ColumnUuid customerId;

  late final _i1.ColumnString gatewayPaymentId;

  late final _i1.ColumnUuid paymentTransactionId;

  late final _i1.ColumnString gatewayOrderId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString currency;

  late final _i1.ColumnString jobStatus;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnDateTime nextRetryAt;

  late final _i1.ColumnString lastError;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime processedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    orderNumber,
    customerId,
    gatewayPaymentId,
    paymentTransactionId,
    gatewayOrderId,
    amount,
    currency,
    jobStatus,
    attemptCount,
    nextRetryAt,
    lastError,
    createdAt,
    updatedAt,
    processedAt,
  ];
}

class AutoRefundJobRowInclude extends _i1.IncludeObject {
  AutoRefundJobRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AutoRefundJobRow.t;
}

class AutoRefundJobRowIncludeList extends _i1.IncludeList {
  AutoRefundJobRowIncludeList._({
    _i1.WhereExpressionBuilder<AutoRefundJobRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AutoRefundJobRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AutoRefundJobRow.t;
}

class AutoRefundJobRowRepository {
  const AutoRefundJobRowRepository._();

  /// Returns a list of [AutoRefundJobRow]s matching the given query parameters.
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
  Future<List<AutoRefundJobRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AutoRefundJobRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoRefundJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoRefundJobRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AutoRefundJobRow>(
      where: where?.call(AutoRefundJobRow.t),
      orderBy: orderBy?.call(AutoRefundJobRow.t),
      orderByList: orderByList?.call(AutoRefundJobRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AutoRefundJobRow] matching the given query parameters.
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
  Future<AutoRefundJobRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AutoRefundJobRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AutoRefundJobRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoRefundJobRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AutoRefundJobRow>(
      where: where?.call(AutoRefundJobRow.t),
      orderBy: orderBy?.call(AutoRefundJobRow.t),
      orderByList: orderByList?.call(AutoRefundJobRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AutoRefundJobRow] by its [id] or null if no such row exists.
  Future<AutoRefundJobRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AutoRefundJobRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AutoRefundJobRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AutoRefundJobRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AutoRefundJobRow>> insert(
    _i1.DatabaseSession session,
    List<AutoRefundJobRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AutoRefundJobRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AutoRefundJobRow] and returns the inserted row.
  ///
  /// The returned [AutoRefundJobRow] will have its `id` field set.
  Future<AutoRefundJobRow> insertRow(
    _i1.DatabaseSession session,
    AutoRefundJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AutoRefundJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AutoRefundJobRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AutoRefundJobRow>> update(
    _i1.DatabaseSession session,
    List<AutoRefundJobRow> rows, {
    _i1.ColumnSelections<AutoRefundJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AutoRefundJobRow>(
      rows,
      columns: columns?.call(AutoRefundJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoRefundJobRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AutoRefundJobRow> updateRow(
    _i1.DatabaseSession session,
    AutoRefundJobRow row, {
    _i1.ColumnSelections<AutoRefundJobRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AutoRefundJobRow>(
      row,
      columns: columns?.call(AutoRefundJobRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoRefundJobRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AutoRefundJobRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AutoRefundJobRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AutoRefundJobRow>(
      id,
      columnValues: columnValues(AutoRefundJobRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AutoRefundJobRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AutoRefundJobRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AutoRefundJobRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AutoRefundJobRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoRefundJobRowTable>? orderBy,
    _i1.OrderByListBuilder<AutoRefundJobRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AutoRefundJobRow>(
      columnValues: columnValues(AutoRefundJobRow.t.updateTable),
      where: where(AutoRefundJobRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoRefundJobRow.t),
      orderByList: orderByList?.call(AutoRefundJobRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AutoRefundJobRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AutoRefundJobRow>> delete(
    _i1.DatabaseSession session,
    List<AutoRefundJobRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AutoRefundJobRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AutoRefundJobRow].
  Future<AutoRefundJobRow> deleteRow(
    _i1.DatabaseSession session,
    AutoRefundJobRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AutoRefundJobRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AutoRefundJobRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AutoRefundJobRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AutoRefundJobRow>(
      where: where(AutoRefundJobRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AutoRefundJobRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AutoRefundJobRow>(
      where: where?.call(AutoRefundJobRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AutoRefundJobRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AutoRefundJobRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AutoRefundJobRow>(
      where: where(AutoRefundJobRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
