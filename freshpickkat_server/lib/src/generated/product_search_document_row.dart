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

abstract class ProductSearchDocumentRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ProductSearchDocumentRow._({
    this.id,
    required this.productId,
    required this.searchText,
    DateTime? builtAt,
    required this.sourceCreatedAt,
    required this.sourceUpdatedAt,
  }) : builtAt = builtAt ?? DateTime.now();

  factory ProductSearchDocumentRow({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String searchText,
    DateTime? builtAt,
    required DateTime sourceCreatedAt,
    required DateTime sourceUpdatedAt,
  }) = _ProductSearchDocumentRowImpl;

  factory ProductSearchDocumentRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProductSearchDocumentRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      searchText: jsonSerialization['searchText'] as String,
      builtAt: jsonSerialization['builtAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['builtAt']),
      sourceCreatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['sourceCreatedAt'],
      ),
      sourceUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['sourceUpdatedAt'],
      ),
    );
  }

  static final t = ProductSearchDocumentRowTable();

  static const db = ProductSearchDocumentRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue productId;

  String searchText;

  DateTime builtAt;

  DateTime sourceCreatedAt;

  DateTime sourceUpdatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductSearchDocumentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductSearchDocumentRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? productId,
    String? searchText,
    DateTime? builtAt,
    DateTime? sourceCreatedAt,
    DateTime? sourceUpdatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSearchDocumentRow',
      if (id != null) 'id': id?.toJson(),
      'productId': productId.toJson(),
      'searchText': searchText,
      'builtAt': builtAt.toJson(),
      'sourceCreatedAt': sourceCreatedAt.toJson(),
      'sourceUpdatedAt': sourceUpdatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProductSearchDocumentRowInclude include() {
    return ProductSearchDocumentRowInclude._();
  }

  static ProductSearchDocumentRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchDocumentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchDocumentRowTable>? orderByList,
    ProductSearchDocumentRowInclude? include,
  }) {
    return ProductSearchDocumentRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSearchDocumentRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProductSearchDocumentRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductSearchDocumentRowImpl extends ProductSearchDocumentRow {
  _ProductSearchDocumentRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String searchText,
    DateTime? builtAt,
    required DateTime sourceCreatedAt,
    required DateTime sourceUpdatedAt,
  }) : super._(
         id: id,
         productId: productId,
         searchText: searchText,
         builtAt: builtAt,
         sourceCreatedAt: sourceCreatedAt,
         sourceUpdatedAt: sourceUpdatedAt,
       );

  /// Returns a shallow copy of this [ProductSearchDocumentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductSearchDocumentRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? productId,
    String? searchText,
    DateTime? builtAt,
    DateTime? sourceCreatedAt,
    DateTime? sourceUpdatedAt,
  }) {
    return ProductSearchDocumentRow(
      id: id is _i1.UuidValue? ? id : this.id,
      productId: productId ?? this.productId,
      searchText: searchText ?? this.searchText,
      builtAt: builtAt ?? this.builtAt,
      sourceCreatedAt: sourceCreatedAt ?? this.sourceCreatedAt,
      sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
    );
  }
}

class ProductSearchDocumentRowUpdateTable
    extends _i1.UpdateTable<ProductSearchDocumentRowTable> {
  ProductSearchDocumentRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> searchText(String value) => _i1.ColumnValue(
    table.searchText,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> builtAt(DateTime value) =>
      _i1.ColumnValue(
        table.builtAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> sourceCreatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.sourceCreatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> sourceUpdatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.sourceUpdatedAt,
        value,
      );
}

class ProductSearchDocumentRowTable extends _i1.Table<_i1.UuidValue?> {
  ProductSearchDocumentRowTable({super.tableRelation})
    : super(tableName: 'product_search_document') {
    updateTable = ProductSearchDocumentRowUpdateTable(this);
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    searchText = _i1.ColumnString(
      'searchText',
      this,
    );
    builtAt = _i1.ColumnDateTime(
      'builtAt',
      this,
      hasDefault: true,
    );
    sourceCreatedAt = _i1.ColumnDateTime(
      'sourceCreatedAt',
      this,
    );
    sourceUpdatedAt = _i1.ColumnDateTime(
      'sourceUpdatedAt',
      this,
    );
  }

  late final ProductSearchDocumentRowUpdateTable updateTable;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnString searchText;

  late final _i1.ColumnDateTime builtAt;

  late final _i1.ColumnDateTime sourceCreatedAt;

  late final _i1.ColumnDateTime sourceUpdatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    searchText,
    builtAt,
    sourceCreatedAt,
    sourceUpdatedAt,
  ];
}

class ProductSearchDocumentRowInclude extends _i1.IncludeObject {
  ProductSearchDocumentRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSearchDocumentRow.t;
}

class ProductSearchDocumentRowIncludeList extends _i1.IncludeList {
  ProductSearchDocumentRowIncludeList._({
    _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductSearchDocumentRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductSearchDocumentRow.t;
}

class ProductSearchDocumentRowRepository {
  const ProductSearchDocumentRowRepository._();

  /// Returns a list of [ProductSearchDocumentRow]s matching the given query parameters.
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
  Future<List<ProductSearchDocumentRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchDocumentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchDocumentRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductSearchDocumentRow>(
      where: where?.call(ProductSearchDocumentRow.t),
      orderBy: orderBy?.call(ProductSearchDocumentRow.t),
      orderByList: orderByList?.call(ProductSearchDocumentRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductSearchDocumentRow] matching the given query parameters.
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
  Future<ProductSearchDocumentRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductSearchDocumentRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductSearchDocumentRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductSearchDocumentRow>(
      where: where?.call(ProductSearchDocumentRow.t),
      orderBy: orderBy?.call(ProductSearchDocumentRow.t),
      orderByList: orderByList?.call(ProductSearchDocumentRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductSearchDocumentRow] by its [id] or null if no such row exists.
  Future<ProductSearchDocumentRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductSearchDocumentRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductSearchDocumentRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductSearchDocumentRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProductSearchDocumentRow>> insert(
    _i1.DatabaseSession session,
    List<ProductSearchDocumentRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProductSearchDocumentRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProductSearchDocumentRow] and returns the inserted row.
  ///
  /// The returned [ProductSearchDocumentRow] will have its `id` field set.
  Future<ProductSearchDocumentRow> insertRow(
    _i1.DatabaseSession session,
    ProductSearchDocumentRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductSearchDocumentRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProductSearchDocumentRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProductSearchDocumentRow>> update(
    _i1.DatabaseSession session,
    List<ProductSearchDocumentRow> rows, {
    _i1.ColumnSelections<ProductSearchDocumentRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProductSearchDocumentRow>(
      rows,
      columns: columns?.call(ProductSearchDocumentRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSearchDocumentRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductSearchDocumentRow> updateRow(
    _i1.DatabaseSession session,
    ProductSearchDocumentRow row, {
    _i1.ColumnSelections<ProductSearchDocumentRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductSearchDocumentRow>(
      row,
      columns: columns?.call(ProductSearchDocumentRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductSearchDocumentRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductSearchDocumentRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ProductSearchDocumentRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductSearchDocumentRow>(
      id,
      columnValues: columnValues(ProductSearchDocumentRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductSearchDocumentRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProductSearchDocumentRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductSearchDocumentRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductSearchDocumentRowTable>? orderBy,
    _i1.OrderByListBuilder<ProductSearchDocumentRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProductSearchDocumentRow>(
      columnValues: columnValues(ProductSearchDocumentRow.t.updateTable),
      where: where(ProductSearchDocumentRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductSearchDocumentRow.t),
      orderByList: orderByList?.call(ProductSearchDocumentRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProductSearchDocumentRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProductSearchDocumentRow>> delete(
    _i1.DatabaseSession session,
    List<ProductSearchDocumentRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProductSearchDocumentRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProductSearchDocumentRow].
  Future<ProductSearchDocumentRow> deleteRow(
    _i1.DatabaseSession session,
    ProductSearchDocumentRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductSearchDocumentRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProductSearchDocumentRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProductSearchDocumentRow>(
      where: where(ProductSearchDocumentRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProductSearchDocumentRow>(
      where: where?.call(ProductSearchDocumentRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductSearchDocumentRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductSearchDocumentRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductSearchDocumentRow>(
      where: where(ProductSearchDocumentRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
