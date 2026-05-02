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

abstract class ProductSubCategoryRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ProductSubCategoryRow._({
    this.id,
    required this.productId,
    required this.subCategoryId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProductSubCategoryRow({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required _i1.UuidValue subCategoryId,
    DateTime? createdAt,
  }) = _ProductSubCategoryRowImpl;

  factory ProductSubCategoryRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProductSubCategoryRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      subCategoryId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['subCategoryId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ProductSubCategoryRowTable();

  static const db = ProductSubCategoryRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue productId;

  _i1.UuidValue subCategoryId;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductSubCategoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductSubCategoryRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? productId,
    _i1.UuidValue? subCategoryId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSubCategoryRow',
      if (id != null) 'id': id?.toJson(),
      'productId': productId.toJson(),
      'subCategoryId': subCategoryId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProductSubCategoryRowInclude include() {
    return ProductSubCategoryRowInclude._();
  }

  static ProductSubCategoryRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductSubCategoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSubCategoryRowTable>? orderByList,
    ProductSubCategoryRowInclude? include,
  }) {
    return ProductSubCategoryRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSubCategoryRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProductSubCategoryRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductSubCategoryRowImpl extends ProductSubCategoryRow {
  _ProductSubCategoryRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required _i1.UuidValue subCategoryId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         productId: productId,
         subCategoryId: subCategoryId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ProductSubCategoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductSubCategoryRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? productId,
    _i1.UuidValue? subCategoryId,
    DateTime? createdAt,
  }) {
    return ProductSubCategoryRow(
      id: id is _i1.UuidValue? ? id : this.id,
      productId: productId ?? this.productId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProductSubCategoryRowUpdateTable
    extends _i1.UpdateTable<ProductSubCategoryRowTable> {
  ProductSubCategoryRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> subCategoryId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.subCategoryId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ProductSubCategoryRowTable extends _i1.Table<_i1.UuidValue?> {
  ProductSubCategoryRowTable({super.tableRelation})
    : super(tableName: 'product_sub_category') {
    updateTable = ProductSubCategoryRowUpdateTable(this);
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    subCategoryId = _i1.ColumnUuid(
      'subCategoryId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductSubCategoryRowUpdateTable updateTable;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnUuid subCategoryId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    subCategoryId,
    createdAt,
  ];
}

class ProductSubCategoryRowInclude extends _i1.IncludeObject {
  ProductSubCategoryRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSubCategoryRow.t;
}

class ProductSubCategoryRowIncludeList extends _i1.IncludeList {
  ProductSubCategoryRowIncludeList._({
    _i1.WhereExpressionBuilder<ProductSubCategoryRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductSubCategoryRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSubCategoryRow.t;
}

class ProductSubCategoryRowRepository {
  const ProductSubCategoryRowRepository._();

  /// Returns a list of [ProductSubCategoryRow]s matching the given query parameters.
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
  Future<List<ProductSubCategoryRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSubCategoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSubCategoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductSubCategoryRow>(
      where: where?.call(ProductSubCategoryRow.t),
      orderBy: orderBy?.call(ProductSubCategoryRow.t),
      orderByList: orderByList?.call(ProductSubCategoryRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductSubCategoryRow] matching the given query parameters.
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
  Future<ProductSubCategoryRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSubCategoryRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductSubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSubCategoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductSubCategoryRow>(
      where: where?.call(ProductSubCategoryRow.t),
      orderBy: orderBy?.call(ProductSubCategoryRow.t),
      orderByList: orderByList?.call(ProductSubCategoryRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductSubCategoryRow] by its [id] or null if no such row exists.
  Future<ProductSubCategoryRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductSubCategoryRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductSubCategoryRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductSubCategoryRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProductSubCategoryRow>> insert(
    _i1.DatabaseSession session,
    List<ProductSubCategoryRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProductSubCategoryRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProductSubCategoryRow] and returns the inserted row.
  ///
  /// The returned [ProductSubCategoryRow] will have its `id` field set.
  Future<ProductSubCategoryRow> insertRow(
    _i1.DatabaseSession session,
    ProductSubCategoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductSubCategoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProductSubCategoryRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProductSubCategoryRow>> update(
    _i1.DatabaseSession session,
    List<ProductSubCategoryRow> rows, {
    _i1.ColumnSelections<ProductSubCategoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProductSubCategoryRow>(
      rows,
      columns: columns?.call(ProductSubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSubCategoryRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductSubCategoryRow> updateRow(
    _i1.DatabaseSession session,
    ProductSubCategoryRow row, {
    _i1.ColumnSelections<ProductSubCategoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductSubCategoryRow>(
      row,
      columns: columns?.call(ProductSubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSubCategoryRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductSubCategoryRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ProductSubCategoryRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductSubCategoryRow>(
      id,
      columnValues: columnValues(ProductSubCategoryRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductSubCategoryRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProductSubCategoryRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductSubCategoryRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProductSubCategoryRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSubCategoryRowTable>? orderBy,
    _i1.OrderByListBuilder<ProductSubCategoryRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProductSubCategoryRow>(
      columnValues: columnValues(ProductSubCategoryRow.t.updateTable),
      where: where(ProductSubCategoryRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSubCategoryRow.t),
      orderByList: orderByList?.call(ProductSubCategoryRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProductSubCategoryRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProductSubCategoryRow>> delete(
    _i1.DatabaseSession session,
    List<ProductSubCategoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProductSubCategoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProductSubCategoryRow].
  Future<ProductSubCategoryRow> deleteRow(
    _i1.DatabaseSession session,
    ProductSubCategoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductSubCategoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProductSubCategoryRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSubCategoryRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProductSubCategoryRow>(
      where: where(ProductSubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSubCategoryRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProductSubCategoryRow>(
      where: where?.call(ProductSubCategoryRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductSubCategoryRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSubCategoryRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductSubCategoryRow>(
      where: where(ProductSubCategoryRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
