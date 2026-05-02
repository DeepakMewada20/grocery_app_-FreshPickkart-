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

abstract class CouponProductScopeRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CouponProductScopeRow._({
    this.id,
    required this.couponId,
    required this.productId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CouponProductScopeRow({
    _i1.UuidValue? id,
    required _i1.UuidValue couponId,
    required _i1.UuidValue productId,
    DateTime? createdAt,
  }) = _CouponProductScopeRowImpl;

  factory CouponProductScopeRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CouponProductScopeRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      couponId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['couponId'],
      ),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CouponProductScopeRowTable();

  static const db = CouponProductScopeRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue couponId;

  _i1.UuidValue productId;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CouponProductScopeRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponProductScopeRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? couponId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponProductScopeRow',
      if (id != null) 'id': id?.toJson(),
      'couponId': couponId.toJson(),
      'productId': productId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CouponProductScopeRowInclude include() {
    return CouponProductScopeRowInclude._();
  }

  static CouponProductScopeRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CouponProductScopeRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponProductScopeRowTable>? orderByList,
    CouponProductScopeRowInclude? include,
  }) {
    return CouponProductScopeRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CouponProductScopeRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CouponProductScopeRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CouponProductScopeRowImpl extends CouponProductScopeRow {
  _CouponProductScopeRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue couponId,
    required _i1.UuidValue productId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         couponId: couponId,
         productId: productId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CouponProductScopeRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CouponProductScopeRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? couponId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  }) {
    return CouponProductScopeRow(
      id: id is _i1.UuidValue? ? id : this.id,
      couponId: couponId ?? this.couponId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CouponProductScopeRowUpdateTable
    extends _i1.UpdateTable<CouponProductScopeRowTable> {
  CouponProductScopeRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> couponId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.couponId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CouponProductScopeRowTable extends _i1.Table<_i1.UuidValue?> {
  CouponProductScopeRowTable({super.tableRelation})
    : super(tableName: 'coupon_product_scope') {
    updateTable = CouponProductScopeRowUpdateTable(this);
    couponId = _i1.ColumnUuid(
      'couponId',
      this,
    );
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CouponProductScopeRowUpdateTable updateTable;

  late final _i1.ColumnUuid couponId;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    couponId,
    productId,
    createdAt,
  ];
}

class CouponProductScopeRowInclude extends _i1.IncludeObject {
  CouponProductScopeRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CouponProductScopeRow.t;
}

class CouponProductScopeRowIncludeList extends _i1.IncludeList {
  CouponProductScopeRowIncludeList._({
    _i1.WhereExpressionBuilder<CouponProductScopeRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CouponProductScopeRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CouponProductScopeRow.t;
}

class CouponProductScopeRowRepository {
  const CouponProductScopeRowRepository._();

  /// Returns a list of [CouponProductScopeRow]s matching the given query parameters.
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
  Future<List<CouponProductScopeRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponProductScopeRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponProductScopeRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CouponProductScopeRow>(
      where: where?.call(CouponProductScopeRow.t),
      orderBy: orderBy?.call(CouponProductScopeRow.t),
      orderByList: orderByList?.call(CouponProductScopeRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CouponProductScopeRow] matching the given query parameters.
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
  Future<CouponProductScopeRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponProductScopeRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CouponProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponProductScopeRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CouponProductScopeRow>(
      where: where?.call(CouponProductScopeRow.t),
      orderBy: orderBy?.call(CouponProductScopeRow.t),
      orderByList: orderByList?.call(CouponProductScopeRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CouponProductScopeRow] by its [id] or null if no such row exists.
  Future<CouponProductScopeRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CouponProductScopeRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CouponProductScopeRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CouponProductScopeRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CouponProductScopeRow>> insert(
    _i1.DatabaseSession session,
    List<CouponProductScopeRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CouponProductScopeRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CouponProductScopeRow] and returns the inserted row.
  ///
  /// The returned [CouponProductScopeRow] will have its `id` field set.
  Future<CouponProductScopeRow> insertRow(
    _i1.DatabaseSession session,
    CouponProductScopeRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CouponProductScopeRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CouponProductScopeRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CouponProductScopeRow>> update(
    _i1.DatabaseSession session,
    List<CouponProductScopeRow> rows, {
    _i1.ColumnSelections<CouponProductScopeRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CouponProductScopeRow>(
      rows,
      columns: columns?.call(CouponProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CouponProductScopeRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CouponProductScopeRow> updateRow(
    _i1.DatabaseSession session,
    CouponProductScopeRow row, {
    _i1.ColumnSelections<CouponProductScopeRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CouponProductScopeRow>(
      row,
      columns: columns?.call(CouponProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CouponProductScopeRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CouponProductScopeRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CouponProductScopeRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CouponProductScopeRow>(
      id,
      columnValues: columnValues(CouponProductScopeRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CouponProductScopeRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CouponProductScopeRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CouponProductScopeRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CouponProductScopeRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponProductScopeRowTable>? orderBy,
    _i1.OrderByListBuilder<CouponProductScopeRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CouponProductScopeRow>(
      columnValues: columnValues(CouponProductScopeRow.t.updateTable),
      where: where(CouponProductScopeRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CouponProductScopeRow.t),
      orderByList: orderByList?.call(CouponProductScopeRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CouponProductScopeRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CouponProductScopeRow>> delete(
    _i1.DatabaseSession session,
    List<CouponProductScopeRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CouponProductScopeRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CouponProductScopeRow].
  Future<CouponProductScopeRow> deleteRow(
    _i1.DatabaseSession session,
    CouponProductScopeRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CouponProductScopeRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CouponProductScopeRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CouponProductScopeRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CouponProductScopeRow>(
      where: where(CouponProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponProductScopeRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CouponProductScopeRow>(
      where: where?.call(CouponProductScopeRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CouponProductScopeRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CouponProductScopeRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CouponProductScopeRow>(
      where: where(CouponProductScopeRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
