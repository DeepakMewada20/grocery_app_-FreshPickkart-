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

abstract class ProductVariantRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ProductVariantRow._({
    this.id,
    required this.productId,
    required this.label,
    this.sku,
    required this.quantityValue,
    required this.quantityUnit,
    this.quantityDescription,
    required this.salePrice,
    required this.listPrice,
    bool? isAvailable,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isAvailable = isAvailable ?? true,
       isDefault = isDefault ?? false,
       sortOrder = sortOrder ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProductVariantRow({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String label,
    String? sku,
    required double quantityValue,
    required String quantityUnit,
    String? quantityDescription,
    required double salePrice,
    required double listPrice,
    bool? isAvailable,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductVariantRowImpl;

  factory ProductVariantRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductVariantRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      label: jsonSerialization['label'] as String,
      sku: jsonSerialization['sku'] as String?,
      quantityValue: (jsonSerialization['quantityValue'] as num).toDouble(),
      quantityUnit: jsonSerialization['quantityUnit'] as String,
      quantityDescription: jsonSerialization['quantityDescription'] as String?,
      salePrice: (jsonSerialization['salePrice'] as num).toDouble(),
      listPrice: (jsonSerialization['listPrice'] as num).toDouble(),
      isAvailable: jsonSerialization['isAvailable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isAvailable']),
      isDefault: jsonSerialization['isDefault'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDefault']),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProductVariantRowTable();

  static const db = ProductVariantRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue productId;

  String label;

  String? sku;

  double quantityValue;

  String quantityUnit;

  String? quantityDescription;

  double salePrice;

  double listPrice;

  bool isAvailable;

  bool isDefault;

  int sortOrder;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductVariantRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductVariantRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? productId,
    String? label,
    String? sku,
    double? quantityValue,
    String? quantityUnit,
    String? quantityDescription,
    double? salePrice,
    double? listPrice,
    bool? isAvailable,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductVariantRow',
      if (id != null) 'id': id?.toJson(),
      'productId': productId.toJson(),
      'label': label,
      if (sku != null) 'sku': sku,
      'quantityValue': quantityValue,
      'quantityUnit': quantityUnit,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      'salePrice': salePrice,
      'listPrice': listPrice,
      'isAvailable': isAvailable,
      'isDefault': isDefault,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProductVariantRowInclude include() {
    return ProductVariantRowInclude._();
  }

  static ProductVariantRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductVariantRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductVariantRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductVariantRowTable>? orderByList,
    ProductVariantRowInclude? include,
  }) {
    return ProductVariantRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductVariantRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProductVariantRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductVariantRowImpl extends ProductVariantRow {
  _ProductVariantRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue productId,
    required String label,
    String? sku,
    required double quantityValue,
    required String quantityUnit,
    String? quantityDescription,
    required double salePrice,
    required double listPrice,
    bool? isAvailable,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         productId: productId,
         label: label,
         sku: sku,
         quantityValue: quantityValue,
         quantityUnit: quantityUnit,
         quantityDescription: quantityDescription,
         salePrice: salePrice,
         listPrice: listPrice,
         isAvailable: isAvailable,
         isDefault: isDefault,
         sortOrder: sortOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProductVariantRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductVariantRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? productId,
    String? label,
    Object? sku = _Undefined,
    double? quantityValue,
    String? quantityUnit,
    Object? quantityDescription = _Undefined,
    double? salePrice,
    double? listPrice,
    bool? isAvailable,
    bool? isDefault,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariantRow(
      id: id is _i1.UuidValue? ? id : this.id,
      productId: productId ?? this.productId,
      label: label ?? this.label,
      sku: sku is String? ? sku : this.sku,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      quantityDescription: quantityDescription is String?
          ? quantityDescription
          : this.quantityDescription,
      salePrice: salePrice ?? this.salePrice,
      listPrice: listPrice ?? this.listPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProductVariantRowUpdateTable
    extends _i1.UpdateTable<ProductVariantRowTable> {
  ProductVariantRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> label(String value) => _i1.ColumnValue(
    table.label,
    value,
  );

  _i1.ColumnValue<String, String> sku(String? value) => _i1.ColumnValue(
    table.sku,
    value,
  );

  _i1.ColumnValue<double, double> quantityValue(double value) =>
      _i1.ColumnValue(
        table.quantityValue,
        value,
      );

  _i1.ColumnValue<String, String> quantityUnit(String value) => _i1.ColumnValue(
    table.quantityUnit,
    value,
  );

  _i1.ColumnValue<String, String> quantityDescription(String? value) =>
      _i1.ColumnValue(
        table.quantityDescription,
        value,
      );

  _i1.ColumnValue<double, double> salePrice(double value) => _i1.ColumnValue(
    table.salePrice,
    value,
  );

  _i1.ColumnValue<double, double> listPrice(double value) => _i1.ColumnValue(
    table.listPrice,
    value,
  );

  _i1.ColumnValue<bool, bool> isAvailable(bool value) => _i1.ColumnValue(
    table.isAvailable,
    value,
  );

  _i1.ColumnValue<bool, bool> isDefault(bool value) => _i1.ColumnValue(
    table.isDefault,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProductVariantRowTable extends _i1.Table<_i1.UuidValue?> {
  ProductVariantRowTable({super.tableRelation})
    : super(tableName: 'product_variant') {
    updateTable = ProductVariantRowUpdateTable(this);
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    label = _i1.ColumnString(
      'label',
      this,
    );
    sku = _i1.ColumnString(
      'sku',
      this,
    );
    quantityValue = _i1.ColumnDouble(
      'quantityValue',
      this,
    );
    quantityUnit = _i1.ColumnString(
      'quantityUnit',
      this,
    );
    quantityDescription = _i1.ColumnString(
      'quantityDescription',
      this,
    );
    salePrice = _i1.ColumnDouble(
      'salePrice',
      this,
    );
    listPrice = _i1.ColumnDouble(
      'listPrice',
      this,
    );
    isAvailable = _i1.ColumnBool(
      'isAvailable',
      this,
      hasDefault: true,
    );
    isDefault = _i1.ColumnBool(
      'isDefault',
      this,
      hasDefault: true,
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductVariantRowUpdateTable updateTable;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnString label;

  late final _i1.ColumnString sku;

  late final _i1.ColumnDouble quantityValue;

  late final _i1.ColumnString quantityUnit;

  late final _i1.ColumnString quantityDescription;

  late final _i1.ColumnDouble salePrice;

  late final _i1.ColumnDouble listPrice;

  late final _i1.ColumnBool isAvailable;

  late final _i1.ColumnBool isDefault;

  late final _i1.ColumnInt sortOrder;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    label,
    sku,
    quantityValue,
    quantityUnit,
    quantityDescription,
    salePrice,
    listPrice,
    isAvailable,
    isDefault,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}

class ProductVariantRowInclude extends _i1.IncludeObject {
  ProductVariantRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductVariantRow.t;
}

class ProductVariantRowIncludeList extends _i1.IncludeList {
  ProductVariantRowIncludeList._({
    _i1.WhereExpressionBuilder<ProductVariantRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductVariantRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductVariantRow.t;
}

class ProductVariantRowRepository {
  const ProductVariantRowRepository._();

  /// Returns a list of [ProductVariantRow]s matching the given query parameters.
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
  Future<List<ProductVariantRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductVariantRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductVariantRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductVariantRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductVariantRow>(
      where: where?.call(ProductVariantRow.t),
      orderBy: orderBy?.call(ProductVariantRow.t),
      orderByList: orderByList?.call(ProductVariantRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductVariantRow] matching the given query parameters.
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
  Future<ProductVariantRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductVariantRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductVariantRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductVariantRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductVariantRow>(
      where: where?.call(ProductVariantRow.t),
      orderBy: orderBy?.call(ProductVariantRow.t),
      orderByList: orderByList?.call(ProductVariantRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductVariantRow] by its [id] or null if no such row exists.
  Future<ProductVariantRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductVariantRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductVariantRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductVariantRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProductVariantRow>> insert(
    _i1.DatabaseSession session,
    List<ProductVariantRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProductVariantRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProductVariantRow] and returns the inserted row.
  ///
  /// The returned [ProductVariantRow] will have its `id` field set.
  Future<ProductVariantRow> insertRow(
    _i1.DatabaseSession session,
    ProductVariantRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductVariantRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProductVariantRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProductVariantRow>> update(
    _i1.DatabaseSession session,
    List<ProductVariantRow> rows, {
    _i1.ColumnSelections<ProductVariantRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProductVariantRow>(
      rows,
      columns: columns?.call(ProductVariantRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductVariantRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductVariantRow> updateRow(
    _i1.DatabaseSession session,
    ProductVariantRow row, {
    _i1.ColumnSelections<ProductVariantRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductVariantRow>(
      row,
      columns: columns?.call(ProductVariantRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductVariantRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductVariantRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ProductVariantRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductVariantRow>(
      id,
      columnValues: columnValues(ProductVariantRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductVariantRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProductVariantRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductVariantRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProductVariantRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductVariantRowTable>? orderBy,
    _i1.OrderByListBuilder<ProductVariantRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProductVariantRow>(
      columnValues: columnValues(ProductVariantRow.t.updateTable),
      where: where(ProductVariantRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductVariantRow.t),
      orderByList: orderByList?.call(ProductVariantRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProductVariantRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProductVariantRow>> delete(
    _i1.DatabaseSession session,
    List<ProductVariantRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProductVariantRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProductVariantRow].
  Future<ProductVariantRow> deleteRow(
    _i1.DatabaseSession session,
    ProductVariantRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductVariantRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProductVariantRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductVariantRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProductVariantRow>(
      where: where(ProductVariantRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductVariantRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProductVariantRow>(
      where: where?.call(ProductVariantRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductVariantRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductVariantRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductVariantRow>(
      where: where(ProductVariantRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
