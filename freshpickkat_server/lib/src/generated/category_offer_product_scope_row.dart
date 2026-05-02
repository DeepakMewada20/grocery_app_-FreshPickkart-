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

abstract class CategoryOfferProductScopeRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CategoryOfferProductScopeRow._({
    this.id,
    required this.categoryOfferId,
    required this.productId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CategoryOfferProductScopeRow({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryOfferId,
    required _i1.UuidValue productId,
    DateTime? createdAt,
  }) = _CategoryOfferProductScopeRowImpl;

  factory CategoryOfferProductScopeRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CategoryOfferProductScopeRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      categoryOfferId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['categoryOfferId'],
      ),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CategoryOfferProductScopeRowTable();

  static const db = CategoryOfferProductScopeRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue categoryOfferId;

  _i1.UuidValue productId;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CategoryOfferProductScopeRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryOfferProductScopeRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? categoryOfferId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryOfferProductScopeRow',
      if (id != null) 'id': id?.toJson(),
      'categoryOfferId': categoryOfferId.toJson(),
      'productId': productId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CategoryOfferProductScopeRowInclude include() {
    return CategoryOfferProductScopeRowInclude._();
  }

  static CategoryOfferProductScopeRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductScopeRowTable>? orderByList,
    CategoryOfferProductScopeRowInclude? include,
  }) {
    return CategoryOfferProductScopeRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferProductScopeRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CategoryOfferProductScopeRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryOfferProductScopeRowImpl extends CategoryOfferProductScopeRow {
  _CategoryOfferProductScopeRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryOfferId,
    required _i1.UuidValue productId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         categoryOfferId: categoryOfferId,
         productId: productId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CategoryOfferProductScopeRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryOfferProductScopeRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? categoryOfferId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  }) {
    return CategoryOfferProductScopeRow(
      id: id is _i1.UuidValue? ? id : this.id,
      categoryOfferId: categoryOfferId ?? this.categoryOfferId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CategoryOfferProductScopeRowUpdateTable
    extends _i1.UpdateTable<CategoryOfferProductScopeRowTable> {
  CategoryOfferProductScopeRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> categoryOfferId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.categoryOfferId,
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

class CategoryOfferProductScopeRowTable extends _i1.Table<_i1.UuidValue?> {
  CategoryOfferProductScopeRowTable({super.tableRelation})
    : super(tableName: 'category_offer_product_scope') {
    updateTable = CategoryOfferProductScopeRowUpdateTable(this);
    categoryOfferId = _i1.ColumnUuid(
      'categoryOfferId',
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

  late final CategoryOfferProductScopeRowUpdateTable updateTable;

  late final _i1.ColumnUuid categoryOfferId;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    categoryOfferId,
    productId,
    createdAt,
  ];
}

class CategoryOfferProductScopeRowInclude extends _i1.IncludeObject {
  CategoryOfferProductScopeRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferProductScopeRow.t;
}

class CategoryOfferProductScopeRowIncludeList extends _i1.IncludeList {
  CategoryOfferProductScopeRowIncludeList._({
    _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CategoryOfferProductScopeRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferProductScopeRow.t;
}

class CategoryOfferProductScopeRowRepository {
  const CategoryOfferProductScopeRowRepository._();

  /// Returns a list of [CategoryOfferProductScopeRow]s matching the given query parameters.
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
  Future<List<CategoryOfferProductScopeRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductScopeRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CategoryOfferProductScopeRow>(
      where: where?.call(CategoryOfferProductScopeRow.t),
      orderBy: orderBy?.call(CategoryOfferProductScopeRow.t),
      orderByList: orderByList?.call(CategoryOfferProductScopeRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CategoryOfferProductScopeRow] matching the given query parameters.
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
  Future<CategoryOfferProductScopeRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductScopeRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductScopeRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CategoryOfferProductScopeRow>(
      where: where?.call(CategoryOfferProductScopeRow.t),
      orderBy: orderBy?.call(CategoryOfferProductScopeRow.t),
      orderByList: orderByList?.call(CategoryOfferProductScopeRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CategoryOfferProductScopeRow] by its [id] or null if no such row exists.
  Future<CategoryOfferProductScopeRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CategoryOfferProductScopeRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CategoryOfferProductScopeRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CategoryOfferProductScopeRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CategoryOfferProductScopeRow>> insert(
    _i1.DatabaseSession session,
    List<CategoryOfferProductScopeRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CategoryOfferProductScopeRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CategoryOfferProductScopeRow] and returns the inserted row.
  ///
  /// The returned [CategoryOfferProductScopeRow] will have its `id` field set.
  Future<CategoryOfferProductScopeRow> insertRow(
    _i1.DatabaseSession session,
    CategoryOfferProductScopeRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CategoryOfferProductScopeRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferProductScopeRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CategoryOfferProductScopeRow>> update(
    _i1.DatabaseSession session,
    List<CategoryOfferProductScopeRow> rows, {
    _i1.ColumnSelections<CategoryOfferProductScopeRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CategoryOfferProductScopeRow>(
      rows,
      columns: columns?.call(CategoryOfferProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferProductScopeRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CategoryOfferProductScopeRow> updateRow(
    _i1.DatabaseSession session,
    CategoryOfferProductScopeRow row, {
    _i1.ColumnSelections<CategoryOfferProductScopeRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CategoryOfferProductScopeRow>(
      row,
      columns: columns?.call(CategoryOfferProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferProductScopeRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CategoryOfferProductScopeRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CategoryOfferProductScopeRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CategoryOfferProductScopeRow>(
      id,
      columnValues: columnValues(CategoryOfferProductScopeRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferProductScopeRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CategoryOfferProductScopeRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CategoryOfferProductScopeRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductScopeRowTable>? orderBy,
    _i1.OrderByListBuilder<CategoryOfferProductScopeRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CategoryOfferProductScopeRow>(
      columnValues: columnValues(CategoryOfferProductScopeRow.t.updateTable),
      where: where(CategoryOfferProductScopeRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferProductScopeRow.t),
      orderByList: orderByList?.call(CategoryOfferProductScopeRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CategoryOfferProductScopeRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CategoryOfferProductScopeRow>> delete(
    _i1.DatabaseSession session,
    List<CategoryOfferProductScopeRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CategoryOfferProductScopeRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CategoryOfferProductScopeRow].
  Future<CategoryOfferProductScopeRow> deleteRow(
    _i1.DatabaseSession session,
    CategoryOfferProductScopeRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CategoryOfferProductScopeRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CategoryOfferProductScopeRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CategoryOfferProductScopeRow>(
      where: where(CategoryOfferProductScopeRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CategoryOfferProductScopeRow>(
      where: where?.call(CategoryOfferProductScopeRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CategoryOfferProductScopeRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferProductScopeRowTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CategoryOfferProductScopeRow>(
      where: where(CategoryOfferProductScopeRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
