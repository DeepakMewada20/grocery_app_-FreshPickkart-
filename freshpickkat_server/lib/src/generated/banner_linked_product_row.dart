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

abstract class BannerLinkedProductRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  BannerLinkedProductRow._({
    this.id,
    required this.bannerId,
    required this.productId,
    int? sortOrder,
    DateTime? createdAt,
  }) : sortOrder = sortOrder ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory BannerLinkedProductRow({
    _i1.UuidValue? id,
    required _i1.UuidValue bannerId,
    required _i1.UuidValue productId,
    int? sortOrder,
    DateTime? createdAt,
  }) = _BannerLinkedProductRowImpl;

  factory BannerLinkedProductRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BannerLinkedProductRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      bannerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['bannerId'],
      ),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BannerLinkedProductRowTable();

  static const db = BannerLinkedProductRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue bannerId;

  _i1.UuidValue productId;

  int sortOrder;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [BannerLinkedProductRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BannerLinkedProductRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? bannerId,
    _i1.UuidValue? productId,
    int? sortOrder,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BannerLinkedProductRow',
      if (id != null) 'id': id?.toJson(),
      'bannerId': bannerId.toJson(),
      'productId': productId.toJson(),
      'sortOrder': sortOrder,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BannerLinkedProductRowInclude include() {
    return BannerLinkedProductRowInclude._();
  }

  static BannerLinkedProductRowIncludeList includeList({
    _i1.WhereExpressionBuilder<BannerLinkedProductRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerLinkedProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerLinkedProductRowTable>? orderByList,
    BannerLinkedProductRowInclude? include,
  }) {
    return BannerLinkedProductRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerLinkedProductRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BannerLinkedProductRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BannerLinkedProductRowImpl extends BannerLinkedProductRow {
  _BannerLinkedProductRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue bannerId,
    required _i1.UuidValue productId,
    int? sortOrder,
    DateTime? createdAt,
  }) : super._(
         id: id,
         bannerId: bannerId,
         productId: productId,
         sortOrder: sortOrder,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BannerLinkedProductRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BannerLinkedProductRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? bannerId,
    _i1.UuidValue? productId,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return BannerLinkedProductRow(
      id: id is _i1.UuidValue? ? id : this.id,
      bannerId: bannerId ?? this.bannerId,
      productId: productId ?? this.productId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BannerLinkedProductRowUpdateTable
    extends _i1.UpdateTable<BannerLinkedProductRowTable> {
  BannerLinkedProductRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> bannerId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.bannerId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class BannerLinkedProductRowTable extends _i1.Table<_i1.UuidValue?> {
  BannerLinkedProductRowTable({super.tableRelation})
    : super(tableName: 'banner_linked_product') {
    updateTable = BannerLinkedProductRowUpdateTable(this);
    bannerId = _i1.ColumnUuid(
      'bannerId',
      this,
    );
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final BannerLinkedProductRowUpdateTable updateTable;

  late final _i1.ColumnUuid bannerId;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnInt sortOrder;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    bannerId,
    productId,
    sortOrder,
    createdAt,
  ];
}

class BannerLinkedProductRowInclude extends _i1.IncludeObject {
  BannerLinkedProductRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerLinkedProductRow.t;
}

class BannerLinkedProductRowIncludeList extends _i1.IncludeList {
  BannerLinkedProductRowIncludeList._({
    _i1.WhereExpressionBuilder<BannerLinkedProductRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BannerLinkedProductRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerLinkedProductRow.t;
}

class BannerLinkedProductRowRepository {
  const BannerLinkedProductRowRepository._();

  /// Returns a list of [BannerLinkedProductRow]s matching the given query parameters.
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
  Future<List<BannerLinkedProductRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerLinkedProductRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerLinkedProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerLinkedProductRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BannerLinkedProductRow>(
      where: where?.call(BannerLinkedProductRow.t),
      orderBy: orderBy?.call(BannerLinkedProductRow.t),
      orderByList: orderByList?.call(BannerLinkedProductRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BannerLinkedProductRow] matching the given query parameters.
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
  Future<BannerLinkedProductRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerLinkedProductRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<BannerLinkedProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerLinkedProductRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BannerLinkedProductRow>(
      where: where?.call(BannerLinkedProductRow.t),
      orderBy: orderBy?.call(BannerLinkedProductRow.t),
      orderByList: orderByList?.call(BannerLinkedProductRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BannerLinkedProductRow] by its [id] or null if no such row exists.
  Future<BannerLinkedProductRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BannerLinkedProductRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BannerLinkedProductRow]s in the list and returns the inserted rows.
  ///
  /// The returned [BannerLinkedProductRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BannerLinkedProductRow>> insert(
    _i1.DatabaseSession session,
    List<BannerLinkedProductRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BannerLinkedProductRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BannerLinkedProductRow] and returns the inserted row.
  ///
  /// The returned [BannerLinkedProductRow] will have its `id` field set.
  Future<BannerLinkedProductRow> insertRow(
    _i1.DatabaseSession session,
    BannerLinkedProductRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BannerLinkedProductRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BannerLinkedProductRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BannerLinkedProductRow>> update(
    _i1.DatabaseSession session,
    List<BannerLinkedProductRow> rows, {
    _i1.ColumnSelections<BannerLinkedProductRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BannerLinkedProductRow>(
      rows,
      columns: columns?.call(BannerLinkedProductRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerLinkedProductRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BannerLinkedProductRow> updateRow(
    _i1.DatabaseSession session,
    BannerLinkedProductRow row, {
    _i1.ColumnSelections<BannerLinkedProductRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BannerLinkedProductRow>(
      row,
      columns: columns?.call(BannerLinkedProductRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerLinkedProductRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BannerLinkedProductRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BannerLinkedProductRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BannerLinkedProductRow>(
      id,
      columnValues: columnValues(BannerLinkedProductRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BannerLinkedProductRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BannerLinkedProductRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BannerLinkedProductRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BannerLinkedProductRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerLinkedProductRowTable>? orderBy,
    _i1.OrderByListBuilder<BannerLinkedProductRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BannerLinkedProductRow>(
      columnValues: columnValues(BannerLinkedProductRow.t.updateTable),
      where: where(BannerLinkedProductRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerLinkedProductRow.t),
      orderByList: orderByList?.call(BannerLinkedProductRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BannerLinkedProductRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BannerLinkedProductRow>> delete(
    _i1.DatabaseSession session,
    List<BannerLinkedProductRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BannerLinkedProductRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BannerLinkedProductRow].
  Future<BannerLinkedProductRow> deleteRow(
    _i1.DatabaseSession session,
    BannerLinkedProductRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BannerLinkedProductRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BannerLinkedProductRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerLinkedProductRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BannerLinkedProductRow>(
      where: where(BannerLinkedProductRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerLinkedProductRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BannerLinkedProductRow>(
      where: where?.call(BannerLinkedProductRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BannerLinkedProductRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerLinkedProductRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BannerLinkedProductRow>(
      where: where(BannerLinkedProductRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
