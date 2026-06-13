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

abstract class DeliveryOtpRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  DeliveryOtpRow._({
    this.id,
    required this.orderId,
    required this.otpHash,
    required this.expiresAt,
    DateTime? createdAt,
    this.verifiedAt,
    int? resendCount,
    bool? isActive,
    this.generatedByAdminId,
    this.verifiedByAdminId,
  }) : createdAt = createdAt ?? DateTime.now(),
       resendCount = resendCount ?? 0,
       isActive = isActive ?? true;

  factory DeliveryOtpRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String otpHash,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    int? resendCount,
    bool? isActive,
    _i1.UuidValue? generatedByAdminId,
    _i1.UuidValue? verifiedByAdminId,
  }) = _DeliveryOtpRowImpl;

  factory DeliveryOtpRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryOtpRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      otpHash: jsonSerialization['otpHash'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      resendCount: jsonSerialization['resendCount'] as int?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      generatedByAdminId: jsonSerialization['generatedByAdminId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['generatedByAdminId'],
            ),
      verifiedByAdminId: jsonSerialization['verifiedByAdminId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['verifiedByAdminId'],
            ),
    );
  }

  static final t = DeliveryOtpRowTable();

  static const db = DeliveryOtpRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  String otpHash;

  DateTime expiresAt;

  DateTime createdAt;

  DateTime? verifiedAt;

  int resendCount;

  bool isActive;

  _i1.UuidValue? generatedByAdminId;

  _i1.UuidValue? verifiedByAdminId;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeliveryOtpRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryOtpRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    String? otpHash,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    int? resendCount,
    bool? isActive,
    _i1.UuidValue? generatedByAdminId,
    _i1.UuidValue? verifiedByAdminId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryOtpRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'otpHash': otpHash,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'resendCount': resendCount,
      'isActive': isActive,
      if (generatedByAdminId != null)
        'generatedByAdminId': generatedByAdminId?.toJson(),
      if (verifiedByAdminId != null)
        'verifiedByAdminId': verifiedByAdminId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static DeliveryOtpRowInclude include() {
    return DeliveryOtpRowInclude._();
  }

  static DeliveryOtpRowIncludeList includeList({
    _i1.WhereExpressionBuilder<DeliveryOtpRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryOtpRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryOtpRowTable>? orderByList,
    DeliveryOtpRowInclude? include,
  }) {
    return DeliveryOtpRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryOtpRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeliveryOtpRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryOtpRowImpl extends DeliveryOtpRow {
  _DeliveryOtpRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required String otpHash,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    int? resendCount,
    bool? isActive,
    _i1.UuidValue? generatedByAdminId,
    _i1.UuidValue? verifiedByAdminId,
  }) : super._(
         id: id,
         orderId: orderId,
         otpHash: otpHash,
         expiresAt: expiresAt,
         createdAt: createdAt,
         verifiedAt: verifiedAt,
         resendCount: resendCount,
         isActive: isActive,
         generatedByAdminId: generatedByAdminId,
         verifiedByAdminId: verifiedByAdminId,
       );

  /// Returns a shallow copy of this [DeliveryOtpRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryOtpRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    String? otpHash,
    DateTime? expiresAt,
    DateTime? createdAt,
    Object? verifiedAt = _Undefined,
    int? resendCount,
    bool? isActive,
    Object? generatedByAdminId = _Undefined,
    Object? verifiedByAdminId = _Undefined,
  }) {
    return DeliveryOtpRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      otpHash: otpHash ?? this.otpHash,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      resendCount: resendCount ?? this.resendCount,
      isActive: isActive ?? this.isActive,
      generatedByAdminId: generatedByAdminId is _i1.UuidValue?
          ? generatedByAdminId
          : this.generatedByAdminId,
      verifiedByAdminId: verifiedByAdminId is _i1.UuidValue?
          ? verifiedByAdminId
          : this.verifiedByAdminId,
    );
  }
}

class DeliveryOtpRowUpdateTable extends _i1.UpdateTable<DeliveryOtpRowTable> {
  DeliveryOtpRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<String, String> otpHash(String value) => _i1.ColumnValue(
    table.otpHash,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.verifiedAt,
        value,
      );

  _i1.ColumnValue<int, int> resendCount(int value) => _i1.ColumnValue(
    table.resendCount,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> generatedByAdminId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.generatedByAdminId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> verifiedByAdminId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.verifiedByAdminId,
    value,
  );
}

class DeliveryOtpRowTable extends _i1.Table<_i1.UuidValue?> {
  DeliveryOtpRowTable({super.tableRelation})
    : super(tableName: 'delivery_otp') {
    updateTable = DeliveryOtpRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    otpHash = _i1.ColumnString(
      'otpHash',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    verifiedAt = _i1.ColumnDateTime(
      'verifiedAt',
      this,
    );
    resendCount = _i1.ColumnInt(
      'resendCount',
      this,
      hasDefault: true,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    generatedByAdminId = _i1.ColumnUuid(
      'generatedByAdminId',
      this,
    );
    verifiedByAdminId = _i1.ColumnUuid(
      'verifiedByAdminId',
      this,
    );
  }

  late final DeliveryOtpRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnString otpHash;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime verifiedAt;

  late final _i1.ColumnInt resendCount;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnUuid generatedByAdminId;

  late final _i1.ColumnUuid verifiedByAdminId;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    otpHash,
    expiresAt,
    createdAt,
    verifiedAt,
    resendCount,
    isActive,
    generatedByAdminId,
    verifiedByAdminId,
  ];
}

class DeliveryOtpRowInclude extends _i1.IncludeObject {
  DeliveryOtpRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryOtpRow.t;
}

class DeliveryOtpRowIncludeList extends _i1.IncludeList {
  DeliveryOtpRowIncludeList._({
    _i1.WhereExpressionBuilder<DeliveryOtpRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeliveryOtpRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryOtpRow.t;
}

class DeliveryOtpRowRepository {
  const DeliveryOtpRowRepository._();

  /// Returns a list of [DeliveryOtpRow]s matching the given query parameters.
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
  Future<List<DeliveryOtpRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryOtpRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryOtpRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryOtpRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeliveryOtpRow>(
      where: where?.call(DeliveryOtpRow.t),
      orderBy: orderBy?.call(DeliveryOtpRow.t),
      orderByList: orderByList?.call(DeliveryOtpRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeliveryOtpRow] matching the given query parameters.
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
  Future<DeliveryOtpRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryOtpRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeliveryOtpRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryOtpRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeliveryOtpRow>(
      where: where?.call(DeliveryOtpRow.t),
      orderBy: orderBy?.call(DeliveryOtpRow.t),
      orderByList: orderByList?.call(DeliveryOtpRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeliveryOtpRow] by its [id] or null if no such row exists.
  Future<DeliveryOtpRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeliveryOtpRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeliveryOtpRow]s in the list and returns the inserted rows.
  ///
  /// The returned [DeliveryOtpRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeliveryOtpRow>> insert(
    _i1.DatabaseSession session,
    List<DeliveryOtpRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeliveryOtpRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeliveryOtpRow] and returns the inserted row.
  ///
  /// The returned [DeliveryOtpRow] will have its `id` field set.
  Future<DeliveryOtpRow> insertRow(
    _i1.DatabaseSession session,
    DeliveryOtpRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeliveryOtpRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryOtpRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeliveryOtpRow>> update(
    _i1.DatabaseSession session,
    List<DeliveryOtpRow> rows, {
    _i1.ColumnSelections<DeliveryOtpRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeliveryOtpRow>(
      rows,
      columns: columns?.call(DeliveryOtpRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryOtpRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeliveryOtpRow> updateRow(
    _i1.DatabaseSession session,
    DeliveryOtpRow row, {
    _i1.ColumnSelections<DeliveryOtpRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeliveryOtpRow>(
      row,
      columns: columns?.call(DeliveryOtpRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryOtpRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeliveryOtpRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DeliveryOtpRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeliveryOtpRow>(
      id,
      columnValues: columnValues(DeliveryOtpRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryOtpRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeliveryOtpRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeliveryOtpRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DeliveryOtpRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryOtpRowTable>? orderBy,
    _i1.OrderByListBuilder<DeliveryOtpRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeliveryOtpRow>(
      columnValues: columnValues(DeliveryOtpRow.t.updateTable),
      where: where(DeliveryOtpRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryOtpRow.t),
      orderByList: orderByList?.call(DeliveryOtpRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeliveryOtpRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeliveryOtpRow>> delete(
    _i1.DatabaseSession session,
    List<DeliveryOtpRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeliveryOtpRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeliveryOtpRow].
  Future<DeliveryOtpRow> deleteRow(
    _i1.DatabaseSession session,
    DeliveryOtpRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeliveryOtpRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeliveryOtpRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryOtpRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeliveryOtpRow>(
      where: where(DeliveryOtpRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryOtpRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeliveryOtpRow>(
      where: where?.call(DeliveryOtpRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeliveryOtpRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryOtpRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeliveryOtpRow>(
      where: where(DeliveryOtpRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
