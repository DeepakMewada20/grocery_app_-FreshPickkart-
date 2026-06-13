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

abstract class IdempotencyRecordRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  IdempotencyRecordRow._({
    this.id,
    required this.scope,
    required this.idempotencyKey,
    this.userId,
    this.orderId,
    this.paymentTransactionId,
    this.requestHash,
    this.responseReference,
    DateTime? createdAt,
    this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory IdempotencyRecordRow({
    _i1.UuidValue? id,
    required String scope,
    required String idempotencyKey,
    _i1.UuidValue? userId,
    _i1.UuidValue? orderId,
    _i1.UuidValue? paymentTransactionId,
    String? requestHash,
    String? responseReference,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) = _IdempotencyRecordRowImpl;

  factory IdempotencyRecordRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IdempotencyRecordRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      scope: jsonSerialization['scope'] as String,
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      userId: jsonSerialization['userId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      orderId: jsonSerialization['orderId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['orderId']),
      paymentTransactionId: jsonSerialization['paymentTransactionId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['paymentTransactionId'],
            ),
      requestHash: jsonSerialization['requestHash'] as String?,
      responseReference: jsonSerialization['responseReference'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  static final t = IdempotencyRecordRowTable();

  static const db = IdempotencyRecordRowRepository._();

  @override
  _i1.UuidValue? id;

  String scope;

  String idempotencyKey;

  _i1.UuidValue? userId;

  _i1.UuidValue? orderId;

  _i1.UuidValue? paymentTransactionId;

  String? requestHash;

  String? responseReference;

  DateTime createdAt;

  DateTime? expiresAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [IdempotencyRecordRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IdempotencyRecordRow copyWith({
    _i1.UuidValue? id,
    String? scope,
    String? idempotencyKey,
    _i1.UuidValue? userId,
    _i1.UuidValue? orderId,
    _i1.UuidValue? paymentTransactionId,
    String? requestHash,
    String? responseReference,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdempotencyRecordRow',
      if (id != null) 'id': id?.toJson(),
      'scope': scope,
      'idempotencyKey': idempotencyKey,
      if (userId != null) 'userId': userId?.toJson(),
      if (orderId != null) 'orderId': orderId?.toJson(),
      if (paymentTransactionId != null)
        'paymentTransactionId': paymentTransactionId?.toJson(),
      if (requestHash != null) 'requestHash': requestHash,
      if (responseReference != null) 'responseReference': responseReference,
      'createdAt': createdAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static IdempotencyRecordRowInclude include() {
    return IdempotencyRecordRowInclude._();
  }

  static IdempotencyRecordRowIncludeList includeList({
    _i1.WhereExpressionBuilder<IdempotencyRecordRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyRecordRowTable>? orderByList,
    IdempotencyRecordRowInclude? include,
  }) {
    return IdempotencyRecordRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyRecordRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IdempotencyRecordRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdempotencyRecordRowImpl extends IdempotencyRecordRow {
  _IdempotencyRecordRowImpl({
    _i1.UuidValue? id,
    required String scope,
    required String idempotencyKey,
    _i1.UuidValue? userId,
    _i1.UuidValue? orderId,
    _i1.UuidValue? paymentTransactionId,
    String? requestHash,
    String? responseReference,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) : super._(
         id: id,
         scope: scope,
         idempotencyKey: idempotencyKey,
         userId: userId,
         orderId: orderId,
         paymentTransactionId: paymentTransactionId,
         requestHash: requestHash,
         responseReference: responseReference,
         createdAt: createdAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [IdempotencyRecordRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IdempotencyRecordRow copyWith({
    Object? id = _Undefined,
    String? scope,
    String? idempotencyKey,
    Object? userId = _Undefined,
    Object? orderId = _Undefined,
    Object? paymentTransactionId = _Undefined,
    Object? requestHash = _Undefined,
    Object? responseReference = _Undefined,
    DateTime? createdAt,
    Object? expiresAt = _Undefined,
  }) {
    return IdempotencyRecordRow(
      id: id is _i1.UuidValue? ? id : this.id,
      scope: scope ?? this.scope,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      userId: userId is _i1.UuidValue? ? userId : this.userId,
      orderId: orderId is _i1.UuidValue? ? orderId : this.orderId,
      paymentTransactionId: paymentTransactionId is _i1.UuidValue?
          ? paymentTransactionId
          : this.paymentTransactionId,
      requestHash: requestHash is String? ? requestHash : this.requestHash,
      responseReference: responseReference is String?
          ? responseReference
          : this.responseReference,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
    );
  }
}

class IdempotencyRecordRowUpdateTable
    extends _i1.UpdateTable<IdempotencyRecordRowTable> {
  IdempotencyRecordRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> scope(String value) => _i1.ColumnValue(
    table.scope,
    value,
  );

  _i1.ColumnValue<String, String> idempotencyKey(String value) =>
      _i1.ColumnValue(
        table.idempotencyKey,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue? value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue? value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> paymentTransactionId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.paymentTransactionId,
    value,
  );

  _i1.ColumnValue<String, String> requestHash(String? value) => _i1.ColumnValue(
    table.requestHash,
    value,
  );

  _i1.ColumnValue<String, String> responseReference(String? value) =>
      _i1.ColumnValue(
        table.responseReference,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );
}

class IdempotencyRecordRowTable extends _i1.Table<_i1.UuidValue?> {
  IdempotencyRecordRowTable({super.tableRelation})
    : super(tableName: 'idempotency_record') {
    updateTable = IdempotencyRecordRowUpdateTable(this);
    scope = _i1.ColumnString(
      'scope',
      this,
    );
    idempotencyKey = _i1.ColumnString(
      'idempotencyKey',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    paymentTransactionId = _i1.ColumnUuid(
      'paymentTransactionId',
      this,
    );
    requestHash = _i1.ColumnString(
      'requestHash',
      this,
    );
    responseReference = _i1.ColumnString(
      'responseReference',
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
  }

  late final IdempotencyRecordRowUpdateTable updateTable;

  late final _i1.ColumnString scope;

  late final _i1.ColumnString idempotencyKey;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid paymentTransactionId;

  late final _i1.ColumnString requestHash;

  late final _i1.ColumnString responseReference;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime expiresAt;

  @override
  List<_i1.Column> get columns => [
    id,
    scope,
    idempotencyKey,
    userId,
    orderId,
    paymentTransactionId,
    requestHash,
    responseReference,
    createdAt,
    expiresAt,
  ];
}

class IdempotencyRecordRowInclude extends _i1.IncludeObject {
  IdempotencyRecordRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => IdempotencyRecordRow.t;
}

class IdempotencyRecordRowIncludeList extends _i1.IncludeList {
  IdempotencyRecordRowIncludeList._({
    _i1.WhereExpressionBuilder<IdempotencyRecordRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IdempotencyRecordRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => IdempotencyRecordRow.t;
}

class IdempotencyRecordRowRepository {
  const IdempotencyRecordRowRepository._();

  /// Returns a list of [IdempotencyRecordRow]s matching the given query parameters.
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
  Future<List<IdempotencyRecordRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IdempotencyRecordRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyRecordRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IdempotencyRecordRow>(
      where: where?.call(IdempotencyRecordRow.t),
      orderBy: orderBy?.call(IdempotencyRecordRow.t),
      orderByList: orderByList?.call(IdempotencyRecordRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IdempotencyRecordRow] matching the given query parameters.
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
  Future<IdempotencyRecordRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IdempotencyRecordRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<IdempotencyRecordRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IdempotencyRecordRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IdempotencyRecordRow>(
      where: where?.call(IdempotencyRecordRow.t),
      orderBy: orderBy?.call(IdempotencyRecordRow.t),
      orderByList: orderByList?.call(IdempotencyRecordRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IdempotencyRecordRow] by its [id] or null if no such row exists.
  Future<IdempotencyRecordRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IdempotencyRecordRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IdempotencyRecordRow]s in the list and returns the inserted rows.
  ///
  /// The returned [IdempotencyRecordRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<IdempotencyRecordRow>> insert(
    _i1.DatabaseSession session,
    List<IdempotencyRecordRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<IdempotencyRecordRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [IdempotencyRecordRow] and returns the inserted row.
  ///
  /// The returned [IdempotencyRecordRow] will have its `id` field set.
  Future<IdempotencyRecordRow> insertRow(
    _i1.DatabaseSession session,
    IdempotencyRecordRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IdempotencyRecordRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyRecordRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IdempotencyRecordRow>> update(
    _i1.DatabaseSession session,
    List<IdempotencyRecordRow> rows, {
    _i1.ColumnSelections<IdempotencyRecordRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IdempotencyRecordRow>(
      rows,
      columns: columns?.call(IdempotencyRecordRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IdempotencyRecordRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IdempotencyRecordRow> updateRow(
    _i1.DatabaseSession session,
    IdempotencyRecordRow row, {
    _i1.ColumnSelections<IdempotencyRecordRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IdempotencyRecordRow>(
      row,
      columns: columns?.call(IdempotencyRecordRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IdempotencyRecordRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IdempotencyRecordRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<IdempotencyRecordRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IdempotencyRecordRow>(
      id,
      columnValues: columnValues(IdempotencyRecordRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyRecordRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IdempotencyRecordRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<IdempotencyRecordRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<IdempotencyRecordRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IdempotencyRecordRowTable>? orderBy,
    _i1.OrderByListBuilder<IdempotencyRecordRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IdempotencyRecordRow>(
      columnValues: columnValues(IdempotencyRecordRow.t.updateTable),
      where: where(IdempotencyRecordRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyRecordRow.t),
      orderByList: orderByList?.call(IdempotencyRecordRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IdempotencyRecordRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IdempotencyRecordRow>> delete(
    _i1.DatabaseSession session,
    List<IdempotencyRecordRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IdempotencyRecordRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IdempotencyRecordRow].
  Future<IdempotencyRecordRow> deleteRow(
    _i1.DatabaseSession session,
    IdempotencyRecordRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IdempotencyRecordRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IdempotencyRecordRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IdempotencyRecordRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IdempotencyRecordRow>(
      where: where(IdempotencyRecordRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IdempotencyRecordRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IdempotencyRecordRow>(
      where: where?.call(IdempotencyRecordRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IdempotencyRecordRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IdempotencyRecordRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IdempotencyRecordRow>(
      where: where(IdempotencyRecordRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
