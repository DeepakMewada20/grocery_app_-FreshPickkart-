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

abstract class ReferralRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ReferralRow._({
    this.id,
    required this.referrerUserId,
    this.inviteeUserId,
    required this.inviteePhone,
    required this.referralCodeUsed,
    String? status,
    this.qualifyingOrderId,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    bool? inviteeCouponIssued,
    this.rewardIssuedAt,
    this.fraudNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'LINK_SHARED',
       qualifyingOrderAmount = qualifyingOrderAmount ?? 0.0,
       rewardPointsIssued = rewardPointsIssued ?? 0,
       inviteeCouponIssued = inviteeCouponIssued ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ReferralRow({
    _i1.UuidValue? id,
    required _i1.UuidValue referrerUserId,
    _i1.UuidValue? inviteeUserId,
    required String inviteePhone,
    required String referralCodeUsed,
    String? status,
    _i1.UuidValue? qualifyingOrderId,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    bool? inviteeCouponIssued,
    DateTime? rewardIssuedAt,
    String? fraudNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReferralRowImpl;

  factory ReferralRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      referrerUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['referrerUserId'],
      ),
      inviteeUserId: jsonSerialization['inviteeUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['inviteeUserId'],
            ),
      inviteePhone: jsonSerialization['inviteePhone'] as String,
      referralCodeUsed: jsonSerialization['referralCodeUsed'] as String,
      status: jsonSerialization['status'] as String?,
      qualifyingOrderId: jsonSerialization['qualifyingOrderId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['qualifyingOrderId'],
            ),
      qualifyingOrderAmount:
          (jsonSerialization['qualifyingOrderAmount'] as num?)?.toDouble(),
      rewardPointsIssued: jsonSerialization['rewardPointsIssued'] as int?,
      inviteeCouponIssued: jsonSerialization['inviteeCouponIssued'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['inviteeCouponIssued'],
            ),
      rewardIssuedAt: jsonSerialization['rewardIssuedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['rewardIssuedAt'],
            ),
      fraudNotes: jsonSerialization['fraudNotes'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ReferralRowTable();

  static const db = ReferralRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue referrerUserId;

  _i1.UuidValue? inviteeUserId;

  String inviteePhone;

  String referralCodeUsed;

  String status;

  _i1.UuidValue? qualifyingOrderId;

  double qualifyingOrderAmount;

  int rewardPointsIssued;

  bool inviteeCouponIssued;

  DateTime? rewardIssuedAt;

  String? fraudNotes;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReferralRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? referrerUserId,
    _i1.UuidValue? inviteeUserId,
    String? inviteePhone,
    String? referralCodeUsed,
    String? status,
    _i1.UuidValue? qualifyingOrderId,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    bool? inviteeCouponIssued,
    DateTime? rewardIssuedAt,
    String? fraudNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralRow',
      if (id != null) 'id': id?.toJson(),
      'referrerUserId': referrerUserId.toJson(),
      if (inviteeUserId != null) 'inviteeUserId': inviteeUserId?.toJson(),
      'inviteePhone': inviteePhone,
      'referralCodeUsed': referralCodeUsed,
      'status': status,
      if (qualifyingOrderId != null)
        'qualifyingOrderId': qualifyingOrderId?.toJson(),
      'qualifyingOrderAmount': qualifyingOrderAmount,
      'rewardPointsIssued': rewardPointsIssued,
      'inviteeCouponIssued': inviteeCouponIssued,
      if (rewardIssuedAt != null) 'rewardIssuedAt': rewardIssuedAt?.toJson(),
      if (fraudNotes != null) 'fraudNotes': fraudNotes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ReferralRowInclude include() {
    return ReferralRowInclude._();
  }

  static ReferralRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ReferralRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralRowTable>? orderByList,
    ReferralRowInclude? include,
  }) {
    return ReferralRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReferralRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReferralRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralRowImpl extends ReferralRow {
  _ReferralRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue referrerUserId,
    _i1.UuidValue? inviteeUserId,
    required String inviteePhone,
    required String referralCodeUsed,
    String? status,
    _i1.UuidValue? qualifyingOrderId,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    bool? inviteeCouponIssued,
    DateTime? rewardIssuedAt,
    String? fraudNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         referrerUserId: referrerUserId,
         inviteeUserId: inviteeUserId,
         inviteePhone: inviteePhone,
         referralCodeUsed: referralCodeUsed,
         status: status,
         qualifyingOrderId: qualifyingOrderId,
         qualifyingOrderAmount: qualifyingOrderAmount,
         rewardPointsIssued: rewardPointsIssued,
         inviteeCouponIssued: inviteeCouponIssued,
         rewardIssuedAt: rewardIssuedAt,
         fraudNotes: fraudNotes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ReferralRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? referrerUserId,
    Object? inviteeUserId = _Undefined,
    String? inviteePhone,
    String? referralCodeUsed,
    String? status,
    Object? qualifyingOrderId = _Undefined,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    bool? inviteeCouponIssued,
    Object? rewardIssuedAt = _Undefined,
    Object? fraudNotes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReferralRow(
      id: id is _i1.UuidValue? ? id : this.id,
      referrerUserId: referrerUserId ?? this.referrerUserId,
      inviteeUserId: inviteeUserId is _i1.UuidValue?
          ? inviteeUserId
          : this.inviteeUserId,
      inviteePhone: inviteePhone ?? this.inviteePhone,
      referralCodeUsed: referralCodeUsed ?? this.referralCodeUsed,
      status: status ?? this.status,
      qualifyingOrderId: qualifyingOrderId is _i1.UuidValue?
          ? qualifyingOrderId
          : this.qualifyingOrderId,
      qualifyingOrderAmount:
          qualifyingOrderAmount ?? this.qualifyingOrderAmount,
      rewardPointsIssued: rewardPointsIssued ?? this.rewardPointsIssued,
      inviteeCouponIssued: inviteeCouponIssued ?? this.inviteeCouponIssued,
      rewardIssuedAt: rewardIssuedAt is DateTime?
          ? rewardIssuedAt
          : this.rewardIssuedAt,
      fraudNotes: fraudNotes is String? ? fraudNotes : this.fraudNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReferralRowUpdateTable extends _i1.UpdateTable<ReferralRowTable> {
  ReferralRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> referrerUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.referrerUserId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> inviteeUserId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.inviteeUserId,
    value,
  );

  _i1.ColumnValue<String, String> inviteePhone(String value) => _i1.ColumnValue(
    table.inviteePhone,
    value,
  );

  _i1.ColumnValue<String, String> referralCodeUsed(String value) =>
      _i1.ColumnValue(
        table.referralCodeUsed,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> qualifyingOrderId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.qualifyingOrderId,
    value,
  );

  _i1.ColumnValue<double, double> qualifyingOrderAmount(double value) =>
      _i1.ColumnValue(
        table.qualifyingOrderAmount,
        value,
      );

  _i1.ColumnValue<int, int> rewardPointsIssued(int value) => _i1.ColumnValue(
    table.rewardPointsIssued,
    value,
  );

  _i1.ColumnValue<bool, bool> inviteeCouponIssued(bool value) =>
      _i1.ColumnValue(
        table.inviteeCouponIssued,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> rewardIssuedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.rewardIssuedAt,
        value,
      );

  _i1.ColumnValue<String, String> fraudNotes(String? value) => _i1.ColumnValue(
    table.fraudNotes,
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

class ReferralRowTable extends _i1.Table<_i1.UuidValue?> {
  ReferralRowTable({super.tableRelation}) : super(tableName: 'referral') {
    updateTable = ReferralRowUpdateTable(this);
    referrerUserId = _i1.ColumnUuid(
      'referrerUserId',
      this,
    );
    inviteeUserId = _i1.ColumnUuid(
      'inviteeUserId',
      this,
    );
    inviteePhone = _i1.ColumnString(
      'inviteePhone',
      this,
    );
    referralCodeUsed = _i1.ColumnString(
      'referralCodeUsed',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    qualifyingOrderId = _i1.ColumnUuid(
      'qualifyingOrderId',
      this,
    );
    qualifyingOrderAmount = _i1.ColumnDouble(
      'qualifyingOrderAmount',
      this,
      hasDefault: true,
    );
    rewardPointsIssued = _i1.ColumnInt(
      'rewardPointsIssued',
      this,
      hasDefault: true,
    );
    inviteeCouponIssued = _i1.ColumnBool(
      'inviteeCouponIssued',
      this,
      hasDefault: true,
    );
    rewardIssuedAt = _i1.ColumnDateTime(
      'rewardIssuedAt',
      this,
    );
    fraudNotes = _i1.ColumnString(
      'fraudNotes',
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

  late final ReferralRowUpdateTable updateTable;

  late final _i1.ColumnUuid referrerUserId;

  late final _i1.ColumnUuid inviteeUserId;

  late final _i1.ColumnString inviteePhone;

  late final _i1.ColumnString referralCodeUsed;

  late final _i1.ColumnString status;

  late final _i1.ColumnUuid qualifyingOrderId;

  late final _i1.ColumnDouble qualifyingOrderAmount;

  late final _i1.ColumnInt rewardPointsIssued;

  late final _i1.ColumnBool inviteeCouponIssued;

  late final _i1.ColumnDateTime rewardIssuedAt;

  late final _i1.ColumnString fraudNotes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    referrerUserId,
    inviteeUserId,
    inviteePhone,
    referralCodeUsed,
    status,
    qualifyingOrderId,
    qualifyingOrderAmount,
    rewardPointsIssued,
    inviteeCouponIssued,
    rewardIssuedAt,
    fraudNotes,
    createdAt,
    updatedAt,
  ];
}

class ReferralRowInclude extends _i1.IncludeObject {
  ReferralRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ReferralRow.t;
}

class ReferralRowIncludeList extends _i1.IncludeList {
  ReferralRowIncludeList._({
    _i1.WhereExpressionBuilder<ReferralRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReferralRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ReferralRow.t;
}

class ReferralRowRepository {
  const ReferralRowRepository._();

  /// Returns a list of [ReferralRow]s matching the given query parameters.
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
  Future<List<ReferralRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReferralRow>(
      where: where?.call(ReferralRow.t),
      orderBy: orderBy?.call(ReferralRow.t),
      orderByList: orderByList?.call(ReferralRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReferralRow] matching the given query parameters.
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
  Future<ReferralRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReferralRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReferralRow>(
      where: where?.call(ReferralRow.t),
      orderBy: orderBy?.call(ReferralRow.t),
      orderByList: orderByList?.call(ReferralRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReferralRow] by its [id] or null if no such row exists.
  Future<ReferralRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReferralRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReferralRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ReferralRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ReferralRow>> insert(
    _i1.DatabaseSession session,
    List<ReferralRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ReferralRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ReferralRow] and returns the inserted row.
  ///
  /// The returned [ReferralRow] will have its `id` field set.
  Future<ReferralRow> insertRow(
    _i1.DatabaseSession session,
    ReferralRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReferralRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReferralRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReferralRow>> update(
    _i1.DatabaseSession session,
    List<ReferralRow> rows, {
    _i1.ColumnSelections<ReferralRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReferralRow>(
      rows,
      columns: columns?.call(ReferralRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReferralRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReferralRow> updateRow(
    _i1.DatabaseSession session,
    ReferralRow row, {
    _i1.ColumnSelections<ReferralRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReferralRow>(
      row,
      columns: columns?.call(ReferralRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReferralRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReferralRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ReferralRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReferralRow>(
      id,
      columnValues: columnValues(ReferralRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReferralRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReferralRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReferralRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReferralRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralRowTable>? orderBy,
    _i1.OrderByListBuilder<ReferralRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReferralRow>(
      columnValues: columnValues(ReferralRow.t.updateTable),
      where: where(ReferralRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReferralRow.t),
      orderByList: orderByList?.call(ReferralRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReferralRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReferralRow>> delete(
    _i1.DatabaseSession session,
    List<ReferralRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReferralRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReferralRow].
  Future<ReferralRow> deleteRow(
    _i1.DatabaseSession session,
    ReferralRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReferralRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReferralRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReferralRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReferralRow>(
      where: where(ReferralRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReferralRow>(
      where: where?.call(ReferralRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReferralRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReferralRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReferralRow>(
      where: where(ReferralRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
