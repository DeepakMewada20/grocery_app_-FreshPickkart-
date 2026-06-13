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

abstract class ComboOfferItemRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ComboOfferItemRow._({
    this.id,
    required this.comboOfferId,
    required this.productId,
    this.productVariantId,
    required this.quantity,
    int? sortOrder,
    DateTime? createdAt,
  }) : sortOrder = sortOrder ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory ComboOfferItemRow({
    _i1.UuidValue? id,
    required _i1.UuidValue comboOfferId,
    required _i1.UuidValue productId,
    _i1.UuidValue? productVariantId,
    required int quantity,
    int? sortOrder,
    DateTime? createdAt,
  }) = _ComboOfferItemRowImpl;

  factory ComboOfferItemRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComboOfferItemRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      comboOfferId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['comboOfferId'],
      ),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      productVariantId: jsonSerialization['productVariantId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['productVariantId'],
            ),
      quantity: jsonSerialization['quantity'] as int,
      sortOrder: jsonSerialization['sortOrder'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ComboOfferItemRowTable();

  static const db = ComboOfferItemRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue comboOfferId;

  _i1.UuidValue productId;

  _i1.UuidValue? productVariantId;

  int quantity;

  int sortOrder;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ComboOfferItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComboOfferItemRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? productId,
    _i1.UuidValue? productVariantId,
    int? quantity,
    int? sortOrder,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComboOfferItemRow',
      if (id != null) 'id': id?.toJson(),
      'comboOfferId': comboOfferId.toJson(),
      'productId': productId.toJson(),
      if (productVariantId != null)
        'productVariantId': productVariantId?.toJson(),
      'quantity': quantity,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ComboOfferItemRowInclude include() {
    return ComboOfferItemRowInclude._();
  }

  static ComboOfferItemRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ComboOfferItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferItemRowTable>? orderByList,
    ComboOfferItemRowInclude? include,
  }) {
    return ComboOfferItemRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComboOfferItemRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ComboOfferItemRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComboOfferItemRowImpl extends ComboOfferItemRow {
  _ComboOfferItemRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue comboOfferId,
    required _i1.UuidValue productId,
    _i1.UuidValue? productVariantId,
    required int quantity,
    int? sortOrder,
    DateTime? createdAt,
  }) : super._(
         id: id,
         comboOfferId: comboOfferId,
         productId: productId,
         productVariantId: productVariantId,
         quantity: quantity,
         sortOrder: sortOrder,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ComboOfferItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComboOfferItemRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? productId,
    Object? productVariantId = _Undefined,
    int? quantity,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return ComboOfferItemRow(
      id: id is _i1.UuidValue? ? id : this.id,
      comboOfferId: comboOfferId ?? this.comboOfferId,
      productId: productId ?? this.productId,
      productVariantId: productVariantId is _i1.UuidValue?
          ? productVariantId
          : this.productVariantId,
      quantity: quantity ?? this.quantity,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ComboOfferItemRowUpdateTable
    extends _i1.UpdateTable<ComboOfferItemRowTable> {
  ComboOfferItemRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> comboOfferId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.comboOfferId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productVariantId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.productVariantId,
    value,
  );

  _i1.ColumnValue<int, int> quantity(int value) => _i1.ColumnValue(
    table.quantity,
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

class ComboOfferItemRowTable extends _i1.Table<_i1.UuidValue?> {
  ComboOfferItemRowTable({super.tableRelation})
    : super(tableName: 'combo_offer_item') {
    updateTable = ComboOfferItemRowUpdateTable(this);
    comboOfferId = _i1.ColumnUuid(
      'comboOfferId',
      this,
    );
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    productVariantId = _i1.ColumnUuid(
      'productVariantId',
      this,
    );
    quantity = _i1.ColumnInt(
      'quantity',
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

  late final ComboOfferItemRowUpdateTable updateTable;

  late final _i1.ColumnUuid comboOfferId;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnUuid productVariantId;

  late final _i1.ColumnInt quantity;

  late final _i1.ColumnInt sortOrder;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    comboOfferId,
    productId,
    productVariantId,
    quantity,
    sortOrder,
    createdAt,
  ];
}

class ComboOfferItemRowInclude extends _i1.IncludeObject {
  ComboOfferItemRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComboOfferItemRow.t;
}

class ComboOfferItemRowIncludeList extends _i1.IncludeList {
  ComboOfferItemRowIncludeList._({
    _i1.WhereExpressionBuilder<ComboOfferItemRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ComboOfferItemRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComboOfferItemRow.t;
}

class ComboOfferItemRowRepository {
  const ComboOfferItemRowRepository._();

  /// Returns a list of [ComboOfferItemRow]s matching the given query parameters.
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
  Future<List<ComboOfferItemRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ComboOfferItemRow>(
      where: where?.call(ComboOfferItemRow.t),
      orderBy: orderBy?.call(ComboOfferItemRow.t),
      orderByList: orderByList?.call(ComboOfferItemRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ComboOfferItemRow] matching the given query parameters.
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
  Future<ComboOfferItemRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferItemRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComboOfferItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ComboOfferItemRow>(
      where: where?.call(ComboOfferItemRow.t),
      orderBy: orderBy?.call(ComboOfferItemRow.t),
      orderByList: orderByList?.call(ComboOfferItemRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ComboOfferItemRow] by its [id] or null if no such row exists.
  Future<ComboOfferItemRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ComboOfferItemRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ComboOfferItemRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ComboOfferItemRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ComboOfferItemRow>> insert(
    _i1.DatabaseSession session,
    List<ComboOfferItemRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ComboOfferItemRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ComboOfferItemRow] and returns the inserted row.
  ///
  /// The returned [ComboOfferItemRow] will have its `id` field set.
  Future<ComboOfferItemRow> insertRow(
    _i1.DatabaseSession session,
    ComboOfferItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ComboOfferItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ComboOfferItemRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ComboOfferItemRow>> update(
    _i1.DatabaseSession session,
    List<ComboOfferItemRow> rows, {
    _i1.ColumnSelections<ComboOfferItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ComboOfferItemRow>(
      rows,
      columns: columns?.call(ComboOfferItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComboOfferItemRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ComboOfferItemRow> updateRow(
    _i1.DatabaseSession session,
    ComboOfferItemRow row, {
    _i1.ColumnSelections<ComboOfferItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ComboOfferItemRow>(
      row,
      columns: columns?.call(ComboOfferItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComboOfferItemRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ComboOfferItemRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ComboOfferItemRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ComboOfferItemRow>(
      id,
      columnValues: columnValues(ComboOfferItemRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ComboOfferItemRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ComboOfferItemRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ComboOfferItemRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ComboOfferItemRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferItemRowTable>? orderBy,
    _i1.OrderByListBuilder<ComboOfferItemRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ComboOfferItemRow>(
      columnValues: columnValues(ComboOfferItemRow.t.updateTable),
      where: where(ComboOfferItemRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComboOfferItemRow.t),
      orderByList: orderByList?.call(ComboOfferItemRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ComboOfferItemRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ComboOfferItemRow>> delete(
    _i1.DatabaseSession session,
    List<ComboOfferItemRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ComboOfferItemRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ComboOfferItemRow].
  Future<ComboOfferItemRow> deleteRow(
    _i1.DatabaseSession session,
    ComboOfferItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ComboOfferItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ComboOfferItemRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComboOfferItemRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ComboOfferItemRow>(
      where: where(ComboOfferItemRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferItemRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ComboOfferItemRow>(
      where: where?.call(ComboOfferItemRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ComboOfferItemRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComboOfferItemRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ComboOfferItemRow>(
      where: where(ComboOfferItemRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
