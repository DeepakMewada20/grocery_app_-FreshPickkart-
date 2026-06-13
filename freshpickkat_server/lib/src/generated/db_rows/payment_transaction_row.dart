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

abstract class PaymentTransactionRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PaymentTransactionRow._({
    this.id,
    required this.orderId,
    required this.userId,
    required this.idempotencyKey,
    required this.gatewayName,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    required this.amount,
    String? currencyCode,
    required this.paymentStatus,
    this.gatewayStatus,
    this.failureReason,
    this.paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : currencyCode = currencyCode ?? 'INR',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PaymentTransactionRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue userId,
    required String idempotencyKey,
    required String gatewayName,
    String? gatewayOrderId,
    String? gatewayPaymentId,
    required double amount,
    String? currencyCode,
    required String paymentStatus,
    String? gatewayStatus,
    String? failureReason,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentTransactionRowImpl;

  factory PaymentTransactionRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PaymentTransactionRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      gatewayName: jsonSerialization['gatewayName'] as String,
      gatewayOrderId: jsonSerialization['gatewayOrderId'] as String?,
      gatewayPaymentId: jsonSerialization['gatewayPaymentId'] as String?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currencyCode: jsonSerialization['currencyCode'] as String?,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      gatewayStatus: jsonSerialization['gatewayStatus'] as String?,
      failureReason: jsonSerialization['failureReason'] as String?,
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PaymentTransactionRowTable();

  static const db = PaymentTransactionRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  _i1.UuidValue userId;

  String idempotencyKey;

  String gatewayName;

  String? gatewayOrderId;

  String? gatewayPaymentId;

  double amount;

  String currencyCode;

  String paymentStatus;

  String? gatewayStatus;

  String? failureReason;

  DateTime? paidAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PaymentTransactionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentTransactionRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    _i1.UuidValue? userId,
    String? idempotencyKey,
    String? gatewayName,
    String? gatewayOrderId,
    String? gatewayPaymentId,
    double? amount,
    String? currencyCode,
    String? paymentStatus,
    String? gatewayStatus,
    String? failureReason,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentTransactionRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'userId': userId.toJson(),
      'idempotencyKey': idempotencyKey,
      'gatewayName': gatewayName,
      if (gatewayOrderId != null) 'gatewayOrderId': gatewayOrderId,
      if (gatewayPaymentId != null) 'gatewayPaymentId': gatewayPaymentId,
      'amount': amount,
      'currencyCode': currencyCode,
      'paymentStatus': paymentStatus,
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (failureReason != null) 'failureReason': failureReason,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PaymentTransactionRowInclude include() {
    return PaymentTransactionRowInclude._();
  }

  static PaymentTransactionRowIncludeList includeList({
    _i1.WhereExpressionBuilder<PaymentTransactionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionRowTable>? orderByList,
    PaymentTransactionRowInclude? include,
  }) {
    return PaymentTransactionRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentTransactionRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PaymentTransactionRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentTransactionRowImpl extends PaymentTransactionRow {
  _PaymentTransactionRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue userId,
    required String idempotencyKey,
    required String gatewayName,
    String? gatewayOrderId,
    String? gatewayPaymentId,
    required double amount,
    String? currencyCode,
    required String paymentStatus,
    String? gatewayStatus,
    String? failureReason,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         userId: userId,
         idempotencyKey: idempotencyKey,
         gatewayName: gatewayName,
         gatewayOrderId: gatewayOrderId,
         gatewayPaymentId: gatewayPaymentId,
         amount: amount,
         currencyCode: currencyCode,
         paymentStatus: paymentStatus,
         gatewayStatus: gatewayStatus,
         failureReason: failureReason,
         paidAt: paidAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PaymentTransactionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentTransactionRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    _i1.UuidValue? userId,
    String? idempotencyKey,
    String? gatewayName,
    Object? gatewayOrderId = _Undefined,
    Object? gatewayPaymentId = _Undefined,
    double? amount,
    String? currencyCode,
    String? paymentStatus,
    Object? gatewayStatus = _Undefined,
    Object? failureReason = _Undefined,
    Object? paidAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentTransactionRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      gatewayName: gatewayName ?? this.gatewayName,
      gatewayOrderId: gatewayOrderId is String?
          ? gatewayOrderId
          : this.gatewayOrderId,
      gatewayPaymentId: gatewayPaymentId is String?
          ? gatewayPaymentId
          : this.gatewayPaymentId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      gatewayStatus: gatewayStatus is String?
          ? gatewayStatus
          : this.gatewayStatus,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PaymentTransactionRowUpdateTable
    extends _i1.UpdateTable<PaymentTransactionRowTable> {
  PaymentTransactionRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> idempotencyKey(String value) =>
      _i1.ColumnValue(
        table.idempotencyKey,
        value,
      );

  _i1.ColumnValue<String, String> gatewayName(String value) => _i1.ColumnValue(
    table.gatewayName,
    value,
  );

  _i1.ColumnValue<String, String> gatewayOrderId(String? value) =>
      _i1.ColumnValue(
        table.gatewayOrderId,
        value,
      );

  _i1.ColumnValue<String, String> gatewayPaymentId(String? value) =>
      _i1.ColumnValue(
        table.gatewayPaymentId,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> currencyCode(String value) => _i1.ColumnValue(
    table.currencyCode,
    value,
  );

  _i1.ColumnValue<String, String> paymentStatus(String value) =>
      _i1.ColumnValue(
        table.paymentStatus,
        value,
      );

  _i1.ColumnValue<String, String> gatewayStatus(String? value) =>
      _i1.ColumnValue(
        table.gatewayStatus,
        value,
      );

  _i1.ColumnValue<String, String> failureReason(String? value) =>
      _i1.ColumnValue(
        table.failureReason,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> paidAt(DateTime? value) =>
      _i1.ColumnValue(
        table.paidAt,
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

class PaymentTransactionRowTable extends _i1.Table<_i1.UuidValue?> {
  PaymentTransactionRowTable({super.tableRelation})
    : super(tableName: 'payment_transaction') {
    updateTable = PaymentTransactionRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    idempotencyKey = _i1.ColumnString(
      'idempotencyKey',
      this,
    );
    gatewayName = _i1.ColumnString(
      'gatewayName',
      this,
    );
    gatewayOrderId = _i1.ColumnString(
      'gatewayOrderId',
      this,
    );
    gatewayPaymentId = _i1.ColumnString(
      'gatewayPaymentId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    currencyCode = _i1.ColumnString(
      'currencyCode',
      this,
      hasDefault: true,
    );
    paymentStatus = _i1.ColumnString(
      'paymentStatus',
      this,
    );
    gatewayStatus = _i1.ColumnString(
      'gatewayStatus',
      this,
    );
    failureReason = _i1.ColumnString(
      'failureReason',
      this,
    );
    paidAt = _i1.ColumnDateTime(
      'paidAt',
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

  late final PaymentTransactionRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString idempotencyKey;

  late final _i1.ColumnString gatewayName;

  late final _i1.ColumnString gatewayOrderId;

  late final _i1.ColumnString gatewayPaymentId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString currencyCode;

  late final _i1.ColumnString paymentStatus;

  late final _i1.ColumnString gatewayStatus;

  late final _i1.ColumnString failureReason;

  late final _i1.ColumnDateTime paidAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    userId,
    idempotencyKey,
    gatewayName,
    gatewayOrderId,
    gatewayPaymentId,
    amount,
    currencyCode,
    paymentStatus,
    gatewayStatus,
    failureReason,
    paidAt,
    createdAt,
    updatedAt,
  ];
}

class PaymentTransactionRowInclude extends _i1.IncludeObject {
  PaymentTransactionRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentTransactionRow.t;
}

class PaymentTransactionRowIncludeList extends _i1.IncludeList {
  PaymentTransactionRowIncludeList._({
    _i1.WhereExpressionBuilder<PaymentTransactionRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PaymentTransactionRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentTransactionRow.t;
}

class PaymentTransactionRowRepository {
  const PaymentTransactionRowRepository._();

  /// Returns a list of [PaymentTransactionRow]s matching the given query parameters.
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
  Future<List<PaymentTransactionRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PaymentTransactionRow>(
      where: where?.call(PaymentTransactionRow.t),
      orderBy: orderBy?.call(PaymentTransactionRow.t),
      orderByList: orderByList?.call(PaymentTransactionRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PaymentTransactionRow] matching the given query parameters.
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
  Future<PaymentTransactionRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PaymentTransactionRow>(
      where: where?.call(PaymentTransactionRow.t),
      orderBy: orderBy?.call(PaymentTransactionRow.t),
      orderByList: orderByList?.call(PaymentTransactionRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PaymentTransactionRow] by its [id] or null if no such row exists.
  Future<PaymentTransactionRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PaymentTransactionRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PaymentTransactionRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PaymentTransactionRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PaymentTransactionRow>> insert(
    _i1.DatabaseSession session,
    List<PaymentTransactionRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PaymentTransactionRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PaymentTransactionRow] and returns the inserted row.
  ///
  /// The returned [PaymentTransactionRow] will have its `id` field set.
  Future<PaymentTransactionRow> insertRow(
    _i1.DatabaseSession session,
    PaymentTransactionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PaymentTransactionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PaymentTransactionRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PaymentTransactionRow>> update(
    _i1.DatabaseSession session,
    List<PaymentTransactionRow> rows, {
    _i1.ColumnSelections<PaymentTransactionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PaymentTransactionRow>(
      rows,
      columns: columns?.call(PaymentTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentTransactionRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PaymentTransactionRow> updateRow(
    _i1.DatabaseSession session,
    PaymentTransactionRow row, {
    _i1.ColumnSelections<PaymentTransactionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PaymentTransactionRow>(
      row,
      columns: columns?.call(PaymentTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentTransactionRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PaymentTransactionRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PaymentTransactionRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PaymentTransactionRow>(
      id,
      columnValues: columnValues(PaymentTransactionRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentTransactionRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PaymentTransactionRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PaymentTransactionRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PaymentTransactionRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionRowTable>? orderBy,
    _i1.OrderByListBuilder<PaymentTransactionRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PaymentTransactionRow>(
      columnValues: columnValues(PaymentTransactionRow.t.updateTable),
      where: where(PaymentTransactionRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentTransactionRow.t),
      orderByList: orderByList?.call(PaymentTransactionRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PaymentTransactionRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PaymentTransactionRow>> delete(
    _i1.DatabaseSession session,
    List<PaymentTransactionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PaymentTransactionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PaymentTransactionRow].
  Future<PaymentTransactionRow> deleteRow(
    _i1.DatabaseSession session,
    PaymentTransactionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PaymentTransactionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PaymentTransactionRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentTransactionRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PaymentTransactionRow>(
      where: where(PaymentTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PaymentTransactionRow>(
      where: where?.call(PaymentTransactionRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PaymentTransactionRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentTransactionRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PaymentTransactionRow>(
      where: where(PaymentTransactionRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
