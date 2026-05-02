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

abstract class UserCartItemRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserCartItemRow._({
    this.id,
    required this.userId,
    required this.productId,
    this.variantId,
    required this.quantity,
    this.bogoFreeProductId,
    this.comboId,
    this.comboName,
    this.comboDiscountType,
    this.comboDiscountValue,
    this.comboItemQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UserCartItemRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String productId,
    String? variantId,
    required int quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserCartItemRowImpl;

  factory UserCartItemRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserCartItemRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      bogoFreeProductId: jsonSerialization['bogoFreeProductId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      comboName: jsonSerialization['comboName'] as String?,
      comboDiscountType: jsonSerialization['comboDiscountType'] as String?,
      comboDiscountValue: (jsonSerialization['comboDiscountValue'] as num?)
          ?.toDouble(),
      comboItemQuantity: jsonSerialization['comboItemQuantity'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserCartItemRowTable();

  static const db = UserCartItemRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String productId;

  String? variantId;

  int quantity;

  String? bogoFreeProductId;

  String? comboId;

  String? comboName;

  String? comboDiscountType;

  double? comboDiscountValue;

  int? comboItemQuantity;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserCartItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserCartItemRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? productId,
    String? variantId,
    int? quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserCartItemRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'quantity': quantity,
      if (bogoFreeProductId != null) 'bogoFreeProductId': bogoFreeProductId,
      if (comboId != null) 'comboId': comboId,
      if (comboName != null) 'comboName': comboName,
      if (comboDiscountType != null) 'comboDiscountType': comboDiscountType,
      if (comboDiscountValue != null) 'comboDiscountValue': comboDiscountValue,
      if (comboItemQuantity != null) 'comboItemQuantity': comboItemQuantity,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UserCartItemRowInclude include() {
    return UserCartItemRowInclude._();
  }

  static UserCartItemRowIncludeList includeList({
    _i1.WhereExpressionBuilder<UserCartItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserCartItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCartItemRowTable>? orderByList,
    UserCartItemRowInclude? include,
  }) {
    return UserCartItemRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserCartItemRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserCartItemRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserCartItemRowImpl extends UserCartItemRow {
  _UserCartItemRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String productId,
    String? variantId,
    required int quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         productId: productId,
         variantId: variantId,
         quantity: quantity,
         bogoFreeProductId: bogoFreeProductId,
         comboId: comboId,
         comboName: comboName,
         comboDiscountType: comboDiscountType,
         comboDiscountValue: comboDiscountValue,
         comboItemQuantity: comboItemQuantity,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserCartItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserCartItemRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? productId,
    Object? variantId = _Undefined,
    int? quantity,
    Object? bogoFreeProductId = _Undefined,
    Object? comboId = _Undefined,
    Object? comboName = _Undefined,
    Object? comboDiscountType = _Undefined,
    Object? comboDiscountValue = _Undefined,
    Object? comboItemQuantity = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserCartItemRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      quantity: quantity ?? this.quantity,
      bogoFreeProductId: bogoFreeProductId is String?
          ? bogoFreeProductId
          : this.bogoFreeProductId,
      comboId: comboId is String? ? comboId : this.comboId,
      comboName: comboName is String? ? comboName : this.comboName,
      comboDiscountType: comboDiscountType is String?
          ? comboDiscountType
          : this.comboDiscountType,
      comboDiscountValue: comboDiscountValue is double?
          ? comboDiscountValue
          : this.comboDiscountValue,
      comboItemQuantity: comboItemQuantity is int?
          ? comboItemQuantity
          : this.comboItemQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserCartItemRowUpdateTable extends _i1.UpdateTable<UserCartItemRowTable> {
  UserCartItemRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> productId(String value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> variantId(String? value) => _i1.ColumnValue(
    table.variantId,
    value,
  );

  _i1.ColumnValue<int, int> quantity(int value) => _i1.ColumnValue(
    table.quantity,
    value,
  );

  _i1.ColumnValue<String, String> bogoFreeProductId(String? value) =>
      _i1.ColumnValue(
        table.bogoFreeProductId,
        value,
      );

  _i1.ColumnValue<String, String> comboId(String? value) => _i1.ColumnValue(
    table.comboId,
    value,
  );

  _i1.ColumnValue<String, String> comboName(String? value) => _i1.ColumnValue(
    table.comboName,
    value,
  );

  _i1.ColumnValue<String, String> comboDiscountType(String? value) =>
      _i1.ColumnValue(
        table.comboDiscountType,
        value,
      );

  _i1.ColumnValue<double, double> comboDiscountValue(double? value) =>
      _i1.ColumnValue(
        table.comboDiscountValue,
        value,
      );

  _i1.ColumnValue<int, int> comboItemQuantity(int? value) => _i1.ColumnValue(
    table.comboItemQuantity,
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

class UserCartItemRowTable extends _i1.Table<_i1.UuidValue?> {
  UserCartItemRowTable({super.tableRelation})
    : super(tableName: 'user_cart_item') {
    updateTable = UserCartItemRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    productId = _i1.ColumnString(
      'productId',
      this,
    );
    variantId = _i1.ColumnString(
      'variantId',
      this,
    );
    quantity = _i1.ColumnInt(
      'quantity',
      this,
    );
    bogoFreeProductId = _i1.ColumnString(
      'bogoFreeProductId',
      this,
    );
    comboId = _i1.ColumnString(
      'comboId',
      this,
    );
    comboName = _i1.ColumnString(
      'comboName',
      this,
    );
    comboDiscountType = _i1.ColumnString(
      'comboDiscountType',
      this,
    );
    comboDiscountValue = _i1.ColumnDouble(
      'comboDiscountValue',
      this,
    );
    comboItemQuantity = _i1.ColumnInt(
      'comboItemQuantity',
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

  late final UserCartItemRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString productId;

  late final _i1.ColumnString variantId;

  late final _i1.ColumnInt quantity;

  late final _i1.ColumnString bogoFreeProductId;

  late final _i1.ColumnString comboId;

  late final _i1.ColumnString comboName;

  late final _i1.ColumnString comboDiscountType;

  late final _i1.ColumnDouble comboDiscountValue;

  late final _i1.ColumnInt comboItemQuantity;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    productId,
    variantId,
    quantity,
    bogoFreeProductId,
    comboId,
    comboName,
    comboDiscountType,
    comboDiscountValue,
    comboItemQuantity,
    createdAt,
    updatedAt,
  ];
}

class UserCartItemRowInclude extends _i1.IncludeObject {
  UserCartItemRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserCartItemRow.t;
}

class UserCartItemRowIncludeList extends _i1.IncludeList {
  UserCartItemRowIncludeList._({
    _i1.WhereExpressionBuilder<UserCartItemRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserCartItemRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserCartItemRow.t;
}

class UserCartItemRowRepository {
  const UserCartItemRowRepository._();

  /// Returns a list of [UserCartItemRow]s matching the given query parameters.
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
  Future<List<UserCartItemRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserCartItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserCartItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCartItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserCartItemRow>(
      where: where?.call(UserCartItemRow.t),
      orderBy: orderBy?.call(UserCartItemRow.t),
      orderByList: orderByList?.call(UserCartItemRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserCartItemRow] matching the given query parameters.
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
  Future<UserCartItemRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserCartItemRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserCartItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCartItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserCartItemRow>(
      where: where?.call(UserCartItemRow.t),
      orderBy: orderBy?.call(UserCartItemRow.t),
      orderByList: orderByList?.call(UserCartItemRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserCartItemRow] by its [id] or null if no such row exists.
  Future<UserCartItemRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserCartItemRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserCartItemRow]s in the list and returns the inserted rows.
  ///
  /// The returned [UserCartItemRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserCartItemRow>> insert(
    _i1.DatabaseSession session,
    List<UserCartItemRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserCartItemRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserCartItemRow] and returns the inserted row.
  ///
  /// The returned [UserCartItemRow] will have its `id` field set.
  Future<UserCartItemRow> insertRow(
    _i1.DatabaseSession session,
    UserCartItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserCartItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserCartItemRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserCartItemRow>> update(
    _i1.DatabaseSession session,
    List<UserCartItemRow> rows, {
    _i1.ColumnSelections<UserCartItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserCartItemRow>(
      rows,
      columns: columns?.call(UserCartItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserCartItemRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserCartItemRow> updateRow(
    _i1.DatabaseSession session,
    UserCartItemRow row, {
    _i1.ColumnSelections<UserCartItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserCartItemRow>(
      row,
      columns: columns?.call(UserCartItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserCartItemRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserCartItemRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserCartItemRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserCartItemRow>(
      id,
      columnValues: columnValues(UserCartItemRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserCartItemRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserCartItemRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserCartItemRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserCartItemRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserCartItemRowTable>? orderBy,
    _i1.OrderByListBuilder<UserCartItemRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserCartItemRow>(
      columnValues: columnValues(UserCartItemRow.t.updateTable),
      where: where(UserCartItemRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserCartItemRow.t),
      orderByList: orderByList?.call(UserCartItemRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserCartItemRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserCartItemRow>> delete(
    _i1.DatabaseSession session,
    List<UserCartItemRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserCartItemRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserCartItemRow].
  Future<UserCartItemRow> deleteRow(
    _i1.DatabaseSession session,
    UserCartItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserCartItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserCartItemRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserCartItemRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserCartItemRow>(
      where: where(UserCartItemRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserCartItemRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserCartItemRow>(
      where: where?.call(UserCartItemRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserCartItemRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserCartItemRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserCartItemRow>(
      where: where(UserCartItemRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
