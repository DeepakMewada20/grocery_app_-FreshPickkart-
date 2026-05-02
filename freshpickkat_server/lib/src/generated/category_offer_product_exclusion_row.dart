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

abstract class CategoryOfferProductExclusionRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CategoryOfferProductExclusionRow._({
    this.id,
    required this.categoryOfferId,
    required this.productId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CategoryOfferProductExclusionRow({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryOfferId,
    required _i1.UuidValue productId,
    DateTime? createdAt,
  }) = _CategoryOfferProductExclusionRowImpl;

  factory CategoryOfferProductExclusionRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CategoryOfferProductExclusionRow(
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

  static final t = CategoryOfferProductExclusionRowTable();

  static const db = CategoryOfferProductExclusionRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue categoryOfferId;

  _i1.UuidValue productId;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CategoryOfferProductExclusionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryOfferProductExclusionRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? categoryOfferId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryOfferProductExclusionRow',
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

  static CategoryOfferProductExclusionRowInclude include() {
    return CategoryOfferProductExclusionRowInclude._();
  }

  static CategoryOfferProductExclusionRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductExclusionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductExclusionRowTable>? orderByList,
    CategoryOfferProductExclusionRowInclude? include,
  }) {
    return CategoryOfferProductExclusionRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferProductExclusionRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CategoryOfferProductExclusionRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryOfferProductExclusionRowImpl
    extends CategoryOfferProductExclusionRow {
  _CategoryOfferProductExclusionRowImpl({
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

  /// Returns a shallow copy of this [CategoryOfferProductExclusionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryOfferProductExclusionRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? categoryOfferId,
    _i1.UuidValue? productId,
    DateTime? createdAt,
  }) {
    return CategoryOfferProductExclusionRow(
      id: id is _i1.UuidValue? ? id : this.id,
      categoryOfferId: categoryOfferId ?? this.categoryOfferId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CategoryOfferProductExclusionRowUpdateTable
    extends _i1.UpdateTable<CategoryOfferProductExclusionRowTable> {
  CategoryOfferProductExclusionRowUpdateTable(super.table);

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

class CategoryOfferProductExclusionRowTable extends _i1.Table<_i1.UuidValue?> {
  CategoryOfferProductExclusionRowTable({super.tableRelation})
    : super(tableName: 'category_offer_product_exclusion') {
    updateTable = CategoryOfferProductExclusionRowUpdateTable(this);
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

  late final CategoryOfferProductExclusionRowUpdateTable updateTable;

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

class CategoryOfferProductExclusionRowInclude extends _i1.IncludeObject {
  CategoryOfferProductExclusionRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferProductExclusionRow.t;
}

class CategoryOfferProductExclusionRowIncludeList extends _i1.IncludeList {
  CategoryOfferProductExclusionRowIncludeList._({
    _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CategoryOfferProductExclusionRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferProductExclusionRow.t;
}

class CategoryOfferProductExclusionRowRepository {
  const CategoryOfferProductExclusionRowRepository._();

  /// Returns a list of [CategoryOfferProductExclusionRow]s matching the given query parameters.
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
  Future<List<CategoryOfferProductExclusionRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductExclusionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductExclusionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CategoryOfferProductExclusionRow>(
      where: where?.call(CategoryOfferProductExclusionRow.t),
      orderBy: orderBy?.call(CategoryOfferProductExclusionRow.t),
      orderByList: orderByList?.call(CategoryOfferProductExclusionRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CategoryOfferProductExclusionRow] matching the given query parameters.
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
  Future<CategoryOfferProductExclusionRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductExclusionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferProductExclusionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CategoryOfferProductExclusionRow>(
      where: where?.call(CategoryOfferProductExclusionRow.t),
      orderBy: orderBy?.call(CategoryOfferProductExclusionRow.t),
      orderByList: orderByList?.call(CategoryOfferProductExclusionRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CategoryOfferProductExclusionRow] by its [id] or null if no such row exists.
  Future<CategoryOfferProductExclusionRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CategoryOfferProductExclusionRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CategoryOfferProductExclusionRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CategoryOfferProductExclusionRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CategoryOfferProductExclusionRow>> insert(
    _i1.DatabaseSession session,
    List<CategoryOfferProductExclusionRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CategoryOfferProductExclusionRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CategoryOfferProductExclusionRow] and returns the inserted row.
  ///
  /// The returned [CategoryOfferProductExclusionRow] will have its `id` field set.
  Future<CategoryOfferProductExclusionRow> insertRow(
    _i1.DatabaseSession session,
    CategoryOfferProductExclusionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CategoryOfferProductExclusionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferProductExclusionRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CategoryOfferProductExclusionRow>> update(
    _i1.DatabaseSession session,
    List<CategoryOfferProductExclusionRow> rows, {
    _i1.ColumnSelections<CategoryOfferProductExclusionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CategoryOfferProductExclusionRow>(
      rows,
      columns: columns?.call(CategoryOfferProductExclusionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferProductExclusionRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CategoryOfferProductExclusionRow> updateRow(
    _i1.DatabaseSession session,
    CategoryOfferProductExclusionRow row, {
    _i1.ColumnSelections<CategoryOfferProductExclusionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CategoryOfferProductExclusionRow>(
      row,
      columns: columns?.call(CategoryOfferProductExclusionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferProductExclusionRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CategoryOfferProductExclusionRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<
      CategoryOfferProductExclusionRowUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CategoryOfferProductExclusionRow>(
      id,
      columnValues: columnValues(
        CategoryOfferProductExclusionRow.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferProductExclusionRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CategoryOfferProductExclusionRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      CategoryOfferProductExclusionRowUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferProductExclusionRowTable>? orderBy,
    _i1.OrderByListBuilder<CategoryOfferProductExclusionRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CategoryOfferProductExclusionRow>(
      columnValues: columnValues(
        CategoryOfferProductExclusionRow.t.updateTable,
      ),
      where: where(CategoryOfferProductExclusionRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferProductExclusionRow.t),
      orderByList: orderByList?.call(CategoryOfferProductExclusionRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CategoryOfferProductExclusionRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CategoryOfferProductExclusionRow>> delete(
    _i1.DatabaseSession session,
    List<CategoryOfferProductExclusionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CategoryOfferProductExclusionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CategoryOfferProductExclusionRow].
  Future<CategoryOfferProductExclusionRow> deleteRow(
    _i1.DatabaseSession session,
    CategoryOfferProductExclusionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CategoryOfferProductExclusionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CategoryOfferProductExclusionRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CategoryOfferProductExclusionRow>(
      where: where(CategoryOfferProductExclusionRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CategoryOfferProductExclusionRow>(
      where: where?.call(CategoryOfferProductExclusionRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CategoryOfferProductExclusionRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferProductExclusionRowTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CategoryOfferProductExclusionRow>(
      where: where(CategoryOfferProductExclusionRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
