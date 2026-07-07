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

abstract class PaymentSessionRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PaymentSessionRow._({
    this.id,
    required this.orderId,
    required this.customerId,
    required this.createdByAdminId,
    String? paymentMethod,
    String? collectionMode,
    required this.amount,
    String? currency,
    required this.status,
    this.razorpayQrId,
    this.qrImageUrl,
    this.gatewayPaymentId,
    this.gatewaySignature,
    this.gatewayTransactionReference,
    this.notes,
    DateTime? createdAt,
    required this.expiresAt,
    this.paidAt,
    this.expiredAt,
    this.cancelledAt,
    DateTime? updatedAt,
  }) : paymentMethod = paymentMethod ?? 'cod_online',
       collectionMode = collectionMode ?? 'upi_qr',
       currency = currency ?? 'INR',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PaymentSessionRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue customerId,
    required String createdByAdminId,
    String? paymentMethod,
    String? collectionMode,
    required double amount,
    String? currency,
    required String status,
    String? razorpayQrId,
    String? qrImageUrl,
    String? gatewayPaymentId,
    String? gatewaySignature,
    String? gatewayTransactionReference,
    String? notes,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? paidAt,
    DateTime? expiredAt,
    DateTime? cancelledAt,
    DateTime? updatedAt,
  }) = _PaymentSessionRowImpl;

  factory PaymentSessionRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentSessionRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      customerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['customerId'],
      ),
      createdByAdminId: jsonSerialization['createdByAdminId'] as String,
      paymentMethod: jsonSerialization['paymentMethod'] as String?,
      collectionMode: jsonSerialization['collectionMode'] as String?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String?,
      status: jsonSerialization['status'] as String,
      razorpayQrId: jsonSerialization['razorpayQrId'] as String?,
      qrImageUrl: jsonSerialization['qrImageUrl'] as String?,
      gatewayPaymentId: jsonSerialization['gatewayPaymentId'] as String?,
      gatewaySignature: jsonSerialization['gatewaySignature'] as String?,
      gatewayTransactionReference:
          jsonSerialization['gatewayTransactionReference'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      expiredAt: jsonSerialization['expiredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiredAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PaymentSessionRowTable();

  static const db = PaymentSessionRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  _i1.UuidValue customerId;

  String createdByAdminId;

  String paymentMethod;

  String collectionMode;

  double amount;

  String currency;

  String status;

  String? razorpayQrId;

  String? qrImageUrl;

  String? gatewayPaymentId;

  String? gatewaySignature;

  String? gatewayTransactionReference;

  String? notes;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime? paidAt;

  DateTime? expiredAt;

  DateTime? cancelledAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PaymentSessionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentSessionRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    _i1.UuidValue? customerId,
    String? createdByAdminId,
    String? paymentMethod,
    String? collectionMode,
    double? amount,
    String? currency,
    String? status,
    String? razorpayQrId,
    String? qrImageUrl,
    String? gatewayPaymentId,
    String? gatewaySignature,
    String? gatewayTransactionReference,
    String? notes,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? paidAt,
    DateTime? expiredAt,
    DateTime? cancelledAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentSessionRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'customerId': customerId.toJson(),
      'createdByAdminId': createdByAdminId,
      'paymentMethod': paymentMethod,
      'collectionMode': collectionMode,
      'amount': amount,
      'currency': currency,
      'status': status,
      if (razorpayQrId != null) 'razorpayQrId': razorpayQrId,
      if (qrImageUrl != null) 'qrImageUrl': qrImageUrl,
      if (gatewayPaymentId != null) 'gatewayPaymentId': gatewayPaymentId,
      if (gatewaySignature != null) 'gatewaySignature': gatewaySignature,
      if (gatewayTransactionReference != null)
        'gatewayTransactionReference': gatewayTransactionReference,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (expiredAt != null) 'expiredAt': expiredAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PaymentSessionRowInclude include() {
    return PaymentSessionRowInclude._();
  }

  static PaymentSessionRowIncludeList includeList({
    _i1.WhereExpressionBuilder<PaymentSessionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentSessionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentSessionRowTable>? orderByList,
    PaymentSessionRowInclude? include,
  }) {
    return PaymentSessionRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentSessionRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PaymentSessionRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentSessionRowImpl extends PaymentSessionRow {
  _PaymentSessionRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue customerId,
    required String createdByAdminId,
    String? paymentMethod,
    String? collectionMode,
    required double amount,
    String? currency,
    required String status,
    String? razorpayQrId,
    String? qrImageUrl,
    String? gatewayPaymentId,
    String? gatewaySignature,
    String? gatewayTransactionReference,
    String? notes,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? paidAt,
    DateTime? expiredAt,
    DateTime? cancelledAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         customerId: customerId,
         createdByAdminId: createdByAdminId,
         paymentMethod: paymentMethod,
         collectionMode: collectionMode,
         amount: amount,
         currency: currency,
         status: status,
         razorpayQrId: razorpayQrId,
         qrImageUrl: qrImageUrl,
         gatewayPaymentId: gatewayPaymentId,
         gatewaySignature: gatewaySignature,
         gatewayTransactionReference: gatewayTransactionReference,
         notes: notes,
         createdAt: createdAt,
         expiresAt: expiresAt,
         paidAt: paidAt,
         expiredAt: expiredAt,
         cancelledAt: cancelledAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PaymentSessionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentSessionRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    _i1.UuidValue? customerId,
    String? createdByAdminId,
    String? paymentMethod,
    String? collectionMode,
    double? amount,
    String? currency,
    String? status,
    Object? razorpayQrId = _Undefined,
    Object? qrImageUrl = _Undefined,
    Object? gatewayPaymentId = _Undefined,
    Object? gatewaySignature = _Undefined,
    Object? gatewayTransactionReference = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? paidAt = _Undefined,
    Object? expiredAt = _Undefined,
    Object? cancelledAt = _Undefined,
    DateTime? updatedAt,
  }) {
    return PaymentSessionRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      createdByAdminId: createdByAdminId ?? this.createdByAdminId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      collectionMode: collectionMode ?? this.collectionMode,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      razorpayQrId: razorpayQrId is String? ? razorpayQrId : this.razorpayQrId,
      qrImageUrl: qrImageUrl is String? ? qrImageUrl : this.qrImageUrl,
      gatewayPaymentId: gatewayPaymentId is String?
          ? gatewayPaymentId
          : this.gatewayPaymentId,
      gatewaySignature: gatewaySignature is String?
          ? gatewaySignature
          : this.gatewaySignature,
      gatewayTransactionReference: gatewayTransactionReference is String?
          ? gatewayTransactionReference
          : this.gatewayTransactionReference,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      expiredAt: expiredAt is DateTime? ? expiredAt : this.expiredAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PaymentSessionRowUpdateTable
    extends _i1.UpdateTable<PaymentSessionRowTable> {
  PaymentSessionRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> customerId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> createdByAdminId(String value) =>
      _i1.ColumnValue(
        table.createdByAdminId,
        value,
      );

  _i1.ColumnValue<String, String> paymentMethod(String value) =>
      _i1.ColumnValue(
        table.paymentMethod,
        value,
      );

  _i1.ColumnValue<String, String> collectionMode(String value) =>
      _i1.ColumnValue(
        table.collectionMode,
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

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> razorpayQrId(String? value) =>
      _i1.ColumnValue(
        table.razorpayQrId,
        value,
      );

  _i1.ColumnValue<String, String> qrImageUrl(String? value) => _i1.ColumnValue(
    table.qrImageUrl,
    value,
  );

  _i1.ColumnValue<String, String> gatewayPaymentId(String? value) =>
      _i1.ColumnValue(
        table.gatewayPaymentId,
        value,
      );

  _i1.ColumnValue<String, String> gatewaySignature(String? value) =>
      _i1.ColumnValue(
        table.gatewaySignature,
        value,
      );

  _i1.ColumnValue<String, String> gatewayTransactionReference(String? value) =>
      _i1.ColumnValue(
        table.gatewayTransactionReference,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> paidAt(DateTime? value) =>
      _i1.ColumnValue(
        table.paidAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiredAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiredAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> cancelledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.cancelledAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class PaymentSessionRowTable extends _i1.Table<_i1.UuidValue?> {
  PaymentSessionRowTable({super.tableRelation})
    : super(tableName: 'payment_session') {
    updateTable = PaymentSessionRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    customerId = _i1.ColumnUuid(
      'customerId',
      this,
    );
    createdByAdminId = _i1.ColumnString(
      'createdByAdminId',
      this,
    );
    paymentMethod = _i1.ColumnString(
      'paymentMethod',
      this,
      hasDefault: true,
    );
    collectionMode = _i1.ColumnString(
      'collectionMode',
      this,
      hasDefault: true,
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
    status = _i1.ColumnString(
      'status',
      this,
    );
    razorpayQrId = _i1.ColumnString(
      'razorpayQrId',
      this,
    );
    qrImageUrl = _i1.ColumnString(
      'qrImageUrl',
      this,
    );
    gatewayPaymentId = _i1.ColumnString(
      'gatewayPaymentId',
      this,
    );
    gatewaySignature = _i1.ColumnString(
      'gatewaySignature',
      this,
    );
    gatewayTransactionReference = _i1.ColumnString(
      'gatewayTransactionReference',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    paidAt = _i1.ColumnDateTime(
      'paidAt',
      this,
    );
    expiredAt = _i1.ColumnDateTime(
      'expiredAt',
      this,
    );
    cancelledAt = _i1.ColumnDateTime(
      'cancelledAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final PaymentSessionRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid customerId;

  late final _i1.ColumnString createdByAdminId;

  late final _i1.ColumnString paymentMethod;

  late final _i1.ColumnString collectionMode;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString currency;

  late final _i1.ColumnString status;

  late final _i1.ColumnString razorpayQrId;

  late final _i1.ColumnString qrImageUrl;

  late final _i1.ColumnString gatewayPaymentId;

  late final _i1.ColumnString gatewaySignature;

  late final _i1.ColumnString gatewayTransactionReference;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime paidAt;

  late final _i1.ColumnDateTime expiredAt;

  late final _i1.ColumnDateTime cancelledAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    customerId,
    createdByAdminId,
    paymentMethod,
    collectionMode,
    amount,
    currency,
    status,
    razorpayQrId,
    qrImageUrl,
    gatewayPaymentId,
    gatewaySignature,
    gatewayTransactionReference,
    notes,
    createdAt,
    expiresAt,
    paidAt,
    expiredAt,
    cancelledAt,
    updatedAt,
  ];
}

class PaymentSessionRowInclude extends _i1.IncludeObject {
  PaymentSessionRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentSessionRow.t;
}

class PaymentSessionRowIncludeList extends _i1.IncludeList {
  PaymentSessionRowIncludeList._({
    _i1.WhereExpressionBuilder<PaymentSessionRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PaymentSessionRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentSessionRow.t;
}

class PaymentSessionRowRepository {
  const PaymentSessionRowRepository._();

  /// Returns a list of [PaymentSessionRow]s matching the given query parameters.
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
  Future<List<PaymentSessionRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentSessionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentSessionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentSessionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PaymentSessionRow>(
      where: where?.call(PaymentSessionRow.t),
      orderBy: orderBy?.call(PaymentSessionRow.t),
      orderByList: orderByList?.call(PaymentSessionRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PaymentSessionRow] matching the given query parameters.
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
  Future<PaymentSessionRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentSessionRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaymentSessionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentSessionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PaymentSessionRow>(
      where: where?.call(PaymentSessionRow.t),
      orderBy: orderBy?.call(PaymentSessionRow.t),
      orderByList: orderByList?.call(PaymentSessionRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PaymentSessionRow] by its [id] or null if no such row exists.
  Future<PaymentSessionRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PaymentSessionRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PaymentSessionRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PaymentSessionRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PaymentSessionRow>> insert(
    _i1.DatabaseSession session,
    List<PaymentSessionRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PaymentSessionRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PaymentSessionRow] and returns the inserted row.
  ///
  /// The returned [PaymentSessionRow] will have its `id` field set.
  Future<PaymentSessionRow> insertRow(
    _i1.DatabaseSession session,
    PaymentSessionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PaymentSessionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PaymentSessionRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PaymentSessionRow>> update(
    _i1.DatabaseSession session,
    List<PaymentSessionRow> rows, {
    _i1.ColumnSelections<PaymentSessionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PaymentSessionRow>(
      rows,
      columns: columns?.call(PaymentSessionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentSessionRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PaymentSessionRow> updateRow(
    _i1.DatabaseSession session,
    PaymentSessionRow row, {
    _i1.ColumnSelections<PaymentSessionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PaymentSessionRow>(
      row,
      columns: columns?.call(PaymentSessionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentSessionRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PaymentSessionRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PaymentSessionRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PaymentSessionRow>(
      id,
      columnValues: columnValues(PaymentSessionRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentSessionRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PaymentSessionRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PaymentSessionRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PaymentSessionRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentSessionRowTable>? orderBy,
    _i1.OrderByListBuilder<PaymentSessionRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PaymentSessionRow>(
      columnValues: columnValues(PaymentSessionRow.t.updateTable),
      where: where(PaymentSessionRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentSessionRow.t),
      orderByList: orderByList?.call(PaymentSessionRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PaymentSessionRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PaymentSessionRow>> delete(
    _i1.DatabaseSession session,
    List<PaymentSessionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PaymentSessionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PaymentSessionRow].
  Future<PaymentSessionRow> deleteRow(
    _i1.DatabaseSession session,
    PaymentSessionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PaymentSessionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PaymentSessionRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentSessionRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PaymentSessionRow>(
      where: where(PaymentSessionRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentSessionRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PaymentSessionRow>(
      where: where?.call(PaymentSessionRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PaymentSessionRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentSessionRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PaymentSessionRow>(
      where: where(PaymentSessionRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
