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

abstract class BogoOfferRewardRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  BogoOfferRewardRow._({
    this.id,
    required this.bogoOfferId,
    required this.rewardProductId,
    this.rewardVariantId,
    int? freeQuantity,
    DateTime? createdAt,
  }) : freeQuantity = freeQuantity ?? 1,
       createdAt = createdAt ?? DateTime.now();

  factory BogoOfferRewardRow({
    _i1.UuidValue? id,
    required _i1.UuidValue bogoOfferId,
    required _i1.UuidValue rewardProductId,
    _i1.UuidValue? rewardVariantId,
    int? freeQuantity,
    DateTime? createdAt,
  }) = _BogoOfferRewardRowImpl;

  factory BogoOfferRewardRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return BogoOfferRewardRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      bogoOfferId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['bogoOfferId'],
      ),
      rewardProductId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['rewardProductId'],
      ),
      rewardVariantId: jsonSerialization['rewardVariantId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['rewardVariantId'],
            ),
      freeQuantity: jsonSerialization['freeQuantity'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BogoOfferRewardRowTable();

  static const db = BogoOfferRewardRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue bogoOfferId;

  _i1.UuidValue rewardProductId;

  _i1.UuidValue? rewardVariantId;

  int freeQuantity;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [BogoOfferRewardRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BogoOfferRewardRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? bogoOfferId,
    _i1.UuidValue? rewardProductId,
    _i1.UuidValue? rewardVariantId,
    int? freeQuantity,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BogoOfferRewardRow',
      if (id != null) 'id': id?.toJson(),
      'bogoOfferId': bogoOfferId.toJson(),
      'rewardProductId': rewardProductId.toJson(),
      if (rewardVariantId != null) 'rewardVariantId': rewardVariantId?.toJson(),
      'freeQuantity': freeQuantity,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BogoOfferRewardRowInclude include() {
    return BogoOfferRewardRowInclude._();
  }

  static BogoOfferRewardRowIncludeList includeList({
    _i1.WhereExpressionBuilder<BogoOfferRewardRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRewardRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRewardRowTable>? orderByList,
    BogoOfferRewardRowInclude? include,
  }) {
    return BogoOfferRewardRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BogoOfferRewardRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BogoOfferRewardRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BogoOfferRewardRowImpl extends BogoOfferRewardRow {
  _BogoOfferRewardRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue bogoOfferId,
    required _i1.UuidValue rewardProductId,
    _i1.UuidValue? rewardVariantId,
    int? freeQuantity,
    DateTime? createdAt,
  }) : super._(
         id: id,
         bogoOfferId: bogoOfferId,
         rewardProductId: rewardProductId,
         rewardVariantId: rewardVariantId,
         freeQuantity: freeQuantity,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BogoOfferRewardRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BogoOfferRewardRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? bogoOfferId,
    _i1.UuidValue? rewardProductId,
    Object? rewardVariantId = _Undefined,
    int? freeQuantity,
    DateTime? createdAt,
  }) {
    return BogoOfferRewardRow(
      id: id is _i1.UuidValue? ? id : this.id,
      bogoOfferId: bogoOfferId ?? this.bogoOfferId,
      rewardProductId: rewardProductId ?? this.rewardProductId,
      rewardVariantId: rewardVariantId is _i1.UuidValue?
          ? rewardVariantId
          : this.rewardVariantId,
      freeQuantity: freeQuantity ?? this.freeQuantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BogoOfferRewardRowUpdateTable
    extends _i1.UpdateTable<BogoOfferRewardRowTable> {
  BogoOfferRewardRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> bogoOfferId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.bogoOfferId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> rewardProductId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.rewardProductId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> rewardVariantId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.rewardVariantId,
    value,
  );

  _i1.ColumnValue<int, int> freeQuantity(int value) => _i1.ColumnValue(
    table.freeQuantity,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class BogoOfferRewardRowTable extends _i1.Table<_i1.UuidValue?> {
  BogoOfferRewardRowTable({super.tableRelation})
    : super(tableName: 'bogo_offer_reward') {
    updateTable = BogoOfferRewardRowUpdateTable(this);
    bogoOfferId = _i1.ColumnUuid(
      'bogoOfferId',
      this,
    );
    rewardProductId = _i1.ColumnUuid(
      'rewardProductId',
      this,
    );
    rewardVariantId = _i1.ColumnUuid(
      'rewardVariantId',
      this,
    );
    freeQuantity = _i1.ColumnInt(
      'freeQuantity',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final BogoOfferRewardRowUpdateTable updateTable;

  late final _i1.ColumnUuid bogoOfferId;

  late final _i1.ColumnUuid rewardProductId;

  late final _i1.ColumnUuid rewardVariantId;

  late final _i1.ColumnInt freeQuantity;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    bogoOfferId,
    rewardProductId,
    rewardVariantId,
    freeQuantity,
    createdAt,
  ];
}

class BogoOfferRewardRowInclude extends _i1.IncludeObject {
  BogoOfferRewardRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BogoOfferRewardRow.t;
}

class BogoOfferRewardRowIncludeList extends _i1.IncludeList {
  BogoOfferRewardRowIncludeList._({
    _i1.WhereExpressionBuilder<BogoOfferRewardRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BogoOfferRewardRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BogoOfferRewardRow.t;
}

class BogoOfferRewardRowRepository {
  const BogoOfferRewardRowRepository._();

  /// Returns a list of [BogoOfferRewardRow]s matching the given query parameters.
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
  Future<List<BogoOfferRewardRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRewardRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRewardRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRewardRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BogoOfferRewardRow>(
      where: where?.call(BogoOfferRewardRow.t),
      orderBy: orderBy?.call(BogoOfferRewardRow.t),
      orderByList: orderByList?.call(BogoOfferRewardRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BogoOfferRewardRow] matching the given query parameters.
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
  Future<BogoOfferRewardRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRewardRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRewardRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRewardRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BogoOfferRewardRow>(
      where: where?.call(BogoOfferRewardRow.t),
      orderBy: orderBy?.call(BogoOfferRewardRow.t),
      orderByList: orderByList?.call(BogoOfferRewardRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BogoOfferRewardRow] by its [id] or null if no such row exists.
  Future<BogoOfferRewardRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BogoOfferRewardRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BogoOfferRewardRow]s in the list and returns the inserted rows.
  ///
  /// The returned [BogoOfferRewardRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BogoOfferRewardRow>> insert(
    _i1.DatabaseSession session,
    List<BogoOfferRewardRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BogoOfferRewardRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BogoOfferRewardRow] and returns the inserted row.
  ///
  /// The returned [BogoOfferRewardRow] will have its `id` field set.
  Future<BogoOfferRewardRow> insertRow(
    _i1.DatabaseSession session,
    BogoOfferRewardRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BogoOfferRewardRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BogoOfferRewardRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BogoOfferRewardRow>> update(
    _i1.DatabaseSession session,
    List<BogoOfferRewardRow> rows, {
    _i1.ColumnSelections<BogoOfferRewardRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BogoOfferRewardRow>(
      rows,
      columns: columns?.call(BogoOfferRewardRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BogoOfferRewardRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BogoOfferRewardRow> updateRow(
    _i1.DatabaseSession session,
    BogoOfferRewardRow row, {
    _i1.ColumnSelections<BogoOfferRewardRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BogoOfferRewardRow>(
      row,
      columns: columns?.call(BogoOfferRewardRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BogoOfferRewardRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BogoOfferRewardRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BogoOfferRewardRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BogoOfferRewardRow>(
      id,
      columnValues: columnValues(BogoOfferRewardRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BogoOfferRewardRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BogoOfferRewardRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BogoOfferRewardRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BogoOfferRewardRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRewardRowTable>? orderBy,
    _i1.OrderByListBuilder<BogoOfferRewardRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BogoOfferRewardRow>(
      columnValues: columnValues(BogoOfferRewardRow.t.updateTable),
      where: where(BogoOfferRewardRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BogoOfferRewardRow.t),
      orderByList: orderByList?.call(BogoOfferRewardRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BogoOfferRewardRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BogoOfferRewardRow>> delete(
    _i1.DatabaseSession session,
    List<BogoOfferRewardRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BogoOfferRewardRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BogoOfferRewardRow].
  Future<BogoOfferRewardRow> deleteRow(
    _i1.DatabaseSession session,
    BogoOfferRewardRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BogoOfferRewardRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BogoOfferRewardRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BogoOfferRewardRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BogoOfferRewardRow>(
      where: where(BogoOfferRewardRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRewardRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BogoOfferRewardRow>(
      where: where?.call(BogoOfferRewardRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BogoOfferRewardRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BogoOfferRewardRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BogoOfferRewardRow>(
      where: where(BogoOfferRewardRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
