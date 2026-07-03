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

abstract class CodFailureRecord
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CodFailureRecord._({
    this.id,
    required this.orderId,
    required this.userId,
    required this.reason,
    this.failureNote,
    this.recordedBy,
    DateTime? recordedAt,
  }) : recordedAt = recordedAt ?? DateTime.now();

  factory CodFailureRecord({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue userId,
    required String reason,
    String? failureNote,
    String? recordedBy,
    DateTime? recordedAt,
  }) = _CodFailureRecordImpl;

  factory CodFailureRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return CodFailureRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      reason: jsonSerialization['reason'] as String,
      failureNote: jsonSerialization['failureNote'] as String?,
      recordedBy: jsonSerialization['recordedBy'] as String?,
      recordedAt: jsonSerialization['recordedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['recordedAt']),
    );
  }

  static final t = CodFailureRecordTable();

  static const db = CodFailureRecordRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  _i1.UuidValue userId;

  String reason;

  String? failureNote;

  String? recordedBy;

  DateTime recordedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CodFailureRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CodFailureRecord copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    _i1.UuidValue? userId,
    String? reason,
    String? failureNote,
    String? recordedBy,
    DateTime? recordedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CodFailureRecord',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'userId': userId.toJson(),
      'reason': reason,
      if (failureNote != null) 'failureNote': failureNote,
      if (recordedBy != null) 'recordedBy': recordedBy,
      'recordedAt': recordedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CodFailureRecordInclude include() {
    return CodFailureRecordInclude._();
  }

  static CodFailureRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<CodFailureRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodFailureRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodFailureRecordTable>? orderByList,
    CodFailureRecordInclude? include,
  }) {
    return CodFailureRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodFailureRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CodFailureRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CodFailureRecordImpl extends CodFailureRecord {
  _CodFailureRecordImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue userId,
    required String reason,
    String? failureNote,
    String? recordedBy,
    DateTime? recordedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         userId: userId,
         reason: reason,
         failureNote: failureNote,
         recordedBy: recordedBy,
         recordedAt: recordedAt,
       );

  /// Returns a shallow copy of this [CodFailureRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CodFailureRecord copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    _i1.UuidValue? userId,
    String? reason,
    Object? failureNote = _Undefined,
    Object? recordedBy = _Undefined,
    DateTime? recordedAt,
  }) {
    return CodFailureRecord(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      reason: reason ?? this.reason,
      failureNote: failureNote is String? ? failureNote : this.failureNote,
      recordedBy: recordedBy is String? ? recordedBy : this.recordedBy,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}

class CodFailureRecordUpdateTable
    extends _i1.UpdateTable<CodFailureRecordTable> {
  CodFailureRecordUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> failureNote(String? value) => _i1.ColumnValue(
    table.failureNote,
    value,
  );

  _i1.ColumnValue<String, String> recordedBy(String? value) => _i1.ColumnValue(
    table.recordedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> recordedAt(DateTime value) =>
      _i1.ColumnValue(
        table.recordedAt,
        value,
      );
}

class CodFailureRecordTable extends _i1.Table<_i1.UuidValue?> {
  CodFailureRecordTable({super.tableRelation})
    : super(tableName: 'cod_failure_record') {
    updateTable = CodFailureRecordUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    failureNote = _i1.ColumnString(
      'failureNote',
      this,
    );
    recordedBy = _i1.ColumnString(
      'recordedBy',
      this,
    );
    recordedAt = _i1.ColumnDateTime(
      'recordedAt',
      this,
      hasDefault: true,
    );
  }

  late final CodFailureRecordUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString failureNote;

  late final _i1.ColumnString recordedBy;

  late final _i1.ColumnDateTime recordedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    userId,
    reason,
    failureNote,
    recordedBy,
    recordedAt,
  ];
}

class CodFailureRecordInclude extends _i1.IncludeObject {
  CodFailureRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CodFailureRecord.t;
}

class CodFailureRecordIncludeList extends _i1.IncludeList {
  CodFailureRecordIncludeList._({
    _i1.WhereExpressionBuilder<CodFailureRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CodFailureRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CodFailureRecord.t;
}

class CodFailureRecordRepository {
  const CodFailureRecordRepository._();

  /// Returns a list of [CodFailureRecord]s matching the given query parameters.
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
  Future<List<CodFailureRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodFailureRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodFailureRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodFailureRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CodFailureRecord>(
      where: where?.call(CodFailureRecord.t),
      orderBy: orderBy?.call(CodFailureRecord.t),
      orderByList: orderByList?.call(CodFailureRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CodFailureRecord] matching the given query parameters.
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
  Future<CodFailureRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodFailureRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<CodFailureRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodFailureRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CodFailureRecord>(
      where: where?.call(CodFailureRecord.t),
      orderBy: orderBy?.call(CodFailureRecord.t),
      orderByList: orderByList?.call(CodFailureRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CodFailureRecord] by its [id] or null if no such row exists.
  Future<CodFailureRecord?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CodFailureRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CodFailureRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CodFailureRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CodFailureRecord>> insert(
    _i1.DatabaseSession session,
    List<CodFailureRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CodFailureRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CodFailureRecord] and returns the inserted row.
  ///
  /// The returned [CodFailureRecord] will have its `id` field set.
  Future<CodFailureRecord> insertRow(
    _i1.DatabaseSession session,
    CodFailureRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CodFailureRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CodFailureRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CodFailureRecord>> update(
    _i1.DatabaseSession session,
    List<CodFailureRecord> rows, {
    _i1.ColumnSelections<CodFailureRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CodFailureRecord>(
      rows,
      columns: columns?.call(CodFailureRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodFailureRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CodFailureRecord> updateRow(
    _i1.DatabaseSession session,
    CodFailureRecord row, {
    _i1.ColumnSelections<CodFailureRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CodFailureRecord>(
      row,
      columns: columns?.call(CodFailureRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodFailureRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CodFailureRecord?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CodFailureRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CodFailureRecord>(
      id,
      columnValues: columnValues(CodFailureRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CodFailureRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CodFailureRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CodFailureRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CodFailureRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodFailureRecordTable>? orderBy,
    _i1.OrderByListBuilder<CodFailureRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CodFailureRecord>(
      columnValues: columnValues(CodFailureRecord.t.updateTable),
      where: where(CodFailureRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodFailureRecord.t),
      orderByList: orderByList?.call(CodFailureRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CodFailureRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CodFailureRecord>> delete(
    _i1.DatabaseSession session,
    List<CodFailureRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CodFailureRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CodFailureRecord].
  Future<CodFailureRecord> deleteRow(
    _i1.DatabaseSession session,
    CodFailureRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CodFailureRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CodFailureRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CodFailureRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CodFailureRecord>(
      where: where(CodFailureRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodFailureRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CodFailureRecord>(
      where: where?.call(CodFailureRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CodFailureRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CodFailureRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CodFailureRecord>(
      where: where(CodFailureRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
