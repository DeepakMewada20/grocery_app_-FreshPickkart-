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

abstract class PaymentLinkRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PaymentLinkRow._({
    this.id,
    required this.orderId,
    required this.token,
    required this.expiresAt,
    bool? isUsed,
    this.usedAt,
    this.paidByName,
    this.paidByPhone,
    this.paidByEmail,
    this.razorpayPaymentLinkId,
    this.razorpayPaymentLinkUrl,
    String? linkType,
    String? linkStatus,
    this.generatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isUsed = isUsed ?? false,
       linkType = linkType ?? 'browser',
       linkStatus = linkStatus ?? 'ACTIVE',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PaymentLinkRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String token,
    required DateTime expiresAt,
    bool? isUsed,
    DateTime? usedAt,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    String? razorpayPaymentLinkId,
    String? razorpayPaymentLinkUrl,
    String? linkType,
    String? linkStatus,
    String? generatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentLinkRowImpl;

  factory PaymentLinkRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentLinkRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      token: jsonSerialization['token'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      isUsed: jsonSerialization['isUsed'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isUsed']),
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
      paidByName: jsonSerialization['paidByName'] as String?,
      paidByPhone: jsonSerialization['paidByPhone'] as String?,
      paidByEmail: jsonSerialization['paidByEmail'] as String?,
      razorpayPaymentLinkId:
          jsonSerialization['razorpayPaymentLinkId'] as String?,
      razorpayPaymentLinkUrl:
          jsonSerialization['razorpayPaymentLinkUrl'] as String?,
      linkType: jsonSerialization['linkType'] as String?,
      linkStatus: jsonSerialization['linkStatus'] as String?,
      generatedBy: jsonSerialization['generatedBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PaymentLinkRowTable();

  static const db = PaymentLinkRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  String token;

  DateTime expiresAt;

  bool isUsed;

  DateTime? usedAt;

  String? paidByName;

  String? paidByPhone;

  String? paidByEmail;

  String? razorpayPaymentLinkId;

  String? razorpayPaymentLinkUrl;

  String linkType;

  String linkStatus;

  String? generatedBy;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PaymentLinkRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentLinkRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    String? token,
    DateTime? expiresAt,
    bool? isUsed,
    DateTime? usedAt,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    String? razorpayPaymentLinkId,
    String? razorpayPaymentLinkUrl,
    String? linkType,
    String? linkStatus,
    String? generatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentLinkRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      'isUsed': isUsed,
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
      if (paidByName != null) 'paidByName': paidByName,
      if (paidByPhone != null) 'paidByPhone': paidByPhone,
      if (paidByEmail != null) 'paidByEmail': paidByEmail,
      if (razorpayPaymentLinkId != null)
        'razorpayPaymentLinkId': razorpayPaymentLinkId,
      if (razorpayPaymentLinkUrl != null)
        'razorpayPaymentLinkUrl': razorpayPaymentLinkUrl,
      'linkType': linkType,
      'linkStatus': linkStatus,
      if (generatedBy != null) 'generatedBy': generatedBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PaymentLinkRowInclude include() {
    return PaymentLinkRowInclude._();
  }

  static PaymentLinkRowIncludeList includeList({
    _i1.WhereExpressionBuilder<PaymentLinkRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentLinkRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentLinkRowTable>? orderByList,
    PaymentLinkRowInclude? include,
  }) {
    return PaymentLinkRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentLinkRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PaymentLinkRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentLinkRowImpl extends PaymentLinkRow {
  _PaymentLinkRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String token,
    required DateTime expiresAt,
    bool? isUsed,
    DateTime? usedAt,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    String? razorpayPaymentLinkId,
    String? razorpayPaymentLinkUrl,
    String? linkType,
    String? linkStatus,
    String? generatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         token: token,
         expiresAt: expiresAt,
         isUsed: isUsed,
         usedAt: usedAt,
         paidByName: paidByName,
         paidByPhone: paidByPhone,
         paidByEmail: paidByEmail,
         razorpayPaymentLinkId: razorpayPaymentLinkId,
         razorpayPaymentLinkUrl: razorpayPaymentLinkUrl,
         linkType: linkType,
         linkStatus: linkStatus,
         generatedBy: generatedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PaymentLinkRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentLinkRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    String? token,
    DateTime? expiresAt,
    bool? isUsed,
    Object? usedAt = _Undefined,
    Object? paidByName = _Undefined,
    Object? paidByPhone = _Undefined,
    Object? paidByEmail = _Undefined,
    Object? razorpayPaymentLinkId = _Undefined,
    Object? razorpayPaymentLinkUrl = _Undefined,
    String? linkType,
    String? linkStatus,
    Object? generatedBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentLinkRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt is DateTime? ? usedAt : this.usedAt,
      paidByName: paidByName is String? ? paidByName : this.paidByName,
      paidByPhone: paidByPhone is String? ? paidByPhone : this.paidByPhone,
      paidByEmail: paidByEmail is String? ? paidByEmail : this.paidByEmail,
      razorpayPaymentLinkId: razorpayPaymentLinkId is String?
          ? razorpayPaymentLinkId
          : this.razorpayPaymentLinkId,
      razorpayPaymentLinkUrl: razorpayPaymentLinkUrl is String?
          ? razorpayPaymentLinkUrl
          : this.razorpayPaymentLinkUrl,
      linkType: linkType ?? this.linkType,
      linkStatus: linkStatus ?? this.linkStatus,
      generatedBy: generatedBy is String? ? generatedBy : this.generatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PaymentLinkRowUpdateTable extends _i1.UpdateTable<PaymentLinkRowTable> {
  PaymentLinkRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isUsed(bool value) => _i1.ColumnValue(
    table.isUsed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> usedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.usedAt,
        value,
      );

  _i1.ColumnValue<String, String> paidByName(String? value) => _i1.ColumnValue(
    table.paidByName,
    value,
  );

  _i1.ColumnValue<String, String> paidByPhone(String? value) => _i1.ColumnValue(
    table.paidByPhone,
    value,
  );

  _i1.ColumnValue<String, String> paidByEmail(String? value) => _i1.ColumnValue(
    table.paidByEmail,
    value,
  );

  _i1.ColumnValue<String, String> razorpayPaymentLinkId(String? value) =>
      _i1.ColumnValue(
        table.razorpayPaymentLinkId,
        value,
      );

  _i1.ColumnValue<String, String> razorpayPaymentLinkUrl(String? value) =>
      _i1.ColumnValue(
        table.razorpayPaymentLinkUrl,
        value,
      );

  _i1.ColumnValue<String, String> linkType(String value) => _i1.ColumnValue(
    table.linkType,
    value,
  );

  _i1.ColumnValue<String, String> linkStatus(String value) => _i1.ColumnValue(
    table.linkStatus,
    value,
  );

  _i1.ColumnValue<String, String> generatedBy(String? value) => _i1.ColumnValue(
    table.generatedBy,
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

class PaymentLinkRowTable extends _i1.Table<_i1.UuidValue?> {
  PaymentLinkRowTable({super.tableRelation})
    : super(tableName: 'payment_link') {
    updateTable = PaymentLinkRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    isUsed = _i1.ColumnBool(
      'isUsed',
      this,
      hasDefault: true,
    );
    usedAt = _i1.ColumnDateTime(
      'usedAt',
      this,
    );
    paidByName = _i1.ColumnString(
      'paidByName',
      this,
    );
    paidByPhone = _i1.ColumnString(
      'paidByPhone',
      this,
    );
    paidByEmail = _i1.ColumnString(
      'paidByEmail',
      this,
    );
    razorpayPaymentLinkId = _i1.ColumnString(
      'razorpayPaymentLinkId',
      this,
    );
    razorpayPaymentLinkUrl = _i1.ColumnString(
      'razorpayPaymentLinkUrl',
      this,
    );
    linkType = _i1.ColumnString(
      'linkType',
      this,
      hasDefault: true,
    );
    linkStatus = _i1.ColumnString(
      'linkStatus',
      this,
      hasDefault: true,
    );
    generatedBy = _i1.ColumnString(
      'generatedBy',
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

  late final PaymentLinkRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnString token;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnBool isUsed;

  late final _i1.ColumnDateTime usedAt;

  late final _i1.ColumnString paidByName;

  late final _i1.ColumnString paidByPhone;

  late final _i1.ColumnString paidByEmail;

  late final _i1.ColumnString razorpayPaymentLinkId;

  late final _i1.ColumnString razorpayPaymentLinkUrl;

  late final _i1.ColumnString linkType;

  late final _i1.ColumnString linkStatus;

  late final _i1.ColumnString generatedBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    token,
    expiresAt,
    isUsed,
    usedAt,
    paidByName,
    paidByPhone,
    paidByEmail,
    razorpayPaymentLinkId,
    razorpayPaymentLinkUrl,
    linkType,
    linkStatus,
    generatedBy,
    createdAt,
    updatedAt,
  ];
}

class PaymentLinkRowInclude extends _i1.IncludeObject {
  PaymentLinkRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentLinkRow.t;
}

class PaymentLinkRowIncludeList extends _i1.IncludeList {
  PaymentLinkRowIncludeList._({
    _i1.WhereExpressionBuilder<PaymentLinkRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PaymentLinkRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PaymentLinkRow.t;
}

class PaymentLinkRowRepository {
  const PaymentLinkRowRepository._();

  /// Returns a list of [PaymentLinkRow]s matching the given query parameters.
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
  Future<List<PaymentLinkRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentLinkRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentLinkRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentLinkRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PaymentLinkRow>(
      where: where?.call(PaymentLinkRow.t),
      orderBy: orderBy?.call(PaymentLinkRow.t),
      orderByList: orderByList?.call(PaymentLinkRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PaymentLinkRow] matching the given query parameters.
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
  Future<PaymentLinkRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentLinkRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaymentLinkRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentLinkRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PaymentLinkRow>(
      where: where?.call(PaymentLinkRow.t),
      orderBy: orderBy?.call(PaymentLinkRow.t),
      orderByList: orderByList?.call(PaymentLinkRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PaymentLinkRow] by its [id] or null if no such row exists.
  Future<PaymentLinkRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PaymentLinkRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PaymentLinkRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PaymentLinkRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PaymentLinkRow>> insert(
    _i1.DatabaseSession session,
    List<PaymentLinkRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PaymentLinkRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PaymentLinkRow] and returns the inserted row.
  ///
  /// The returned [PaymentLinkRow] will have its `id` field set.
  Future<PaymentLinkRow> insertRow(
    _i1.DatabaseSession session,
    PaymentLinkRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PaymentLinkRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PaymentLinkRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PaymentLinkRow>> update(
    _i1.DatabaseSession session,
    List<PaymentLinkRow> rows, {
    _i1.ColumnSelections<PaymentLinkRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PaymentLinkRow>(
      rows,
      columns: columns?.call(PaymentLinkRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentLinkRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PaymentLinkRow> updateRow(
    _i1.DatabaseSession session,
    PaymentLinkRow row, {
    _i1.ColumnSelections<PaymentLinkRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PaymentLinkRow>(
      row,
      columns: columns?.call(PaymentLinkRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentLinkRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PaymentLinkRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PaymentLinkRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PaymentLinkRow>(
      id,
      columnValues: columnValues(PaymentLinkRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentLinkRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PaymentLinkRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PaymentLinkRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PaymentLinkRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentLinkRowTable>? orderBy,
    _i1.OrderByListBuilder<PaymentLinkRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PaymentLinkRow>(
      columnValues: columnValues(PaymentLinkRow.t.updateTable),
      where: where(PaymentLinkRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentLinkRow.t),
      orderByList: orderByList?.call(PaymentLinkRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PaymentLinkRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PaymentLinkRow>> delete(
    _i1.DatabaseSession session,
    List<PaymentLinkRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PaymentLinkRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PaymentLinkRow].
  Future<PaymentLinkRow> deleteRow(
    _i1.DatabaseSession session,
    PaymentLinkRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PaymentLinkRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PaymentLinkRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentLinkRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PaymentLinkRow>(
      where: where(PaymentLinkRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentLinkRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PaymentLinkRow>(
      where: where?.call(PaymentLinkRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PaymentLinkRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentLinkRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PaymentLinkRow>(
      where: where(PaymentLinkRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
