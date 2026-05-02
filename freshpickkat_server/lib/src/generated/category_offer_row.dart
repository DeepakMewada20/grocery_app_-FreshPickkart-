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

abstract class CategoryOfferRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CategoryOfferRow._({
    this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    this.minOrderAmount,
    int? priority,
    required this.startsAt,
    required this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : priority = priority ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CategoryOfferRow({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    String? description,
    required String discountType,
    required double discountValue,
    double? maxDiscountAmount,
    double? minOrderAmount,
    int? priority,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CategoryOfferRowImpl;

  factory CategoryOfferRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryOfferRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      categoryId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['categoryId'],
      ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      discountType: jsonSerialization['discountType'] as String,
      discountValue: (jsonSerialization['discountValue'] as num).toDouble(),
      maxDiscountAmount: (jsonSerialization['maxDiscountAmount'] as num?)
          ?.toDouble(),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num?)?.toDouble(),
      priority: jsonSerialization['priority'] as int?,
      startsAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      endsAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      status: jsonSerialization['status'] as String?,
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deactivatedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CategoryOfferRowTable();

  static const db = CategoryOfferRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue categoryId;

  String name;

  String? description;

  String discountType;

  double discountValue;

  double? maxDiscountAmount;

  double? minOrderAmount;

  int priority;

  DateTime startsAt;

  DateTime endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CategoryOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryOfferRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? categoryId,
    String? name,
    String? description,
    String? discountType,
    double? discountValue,
    double? maxDiscountAmount,
    double? minOrderAmount,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryOfferRow',
      if (id != null) 'id': id?.toJson(),
      'categoryId': categoryId.toJson(),
      'name': name,
      if (description != null) 'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
      'priority': priority,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CategoryOfferRowInclude include() {
    return CategoryOfferRowInclude._();
  }

  static CategoryOfferRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CategoryOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferRowTable>? orderByList,
    CategoryOfferRowInclude? include,
  }) {
    return CategoryOfferRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CategoryOfferRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryOfferRowImpl extends CategoryOfferRow {
  _CategoryOfferRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    String? description,
    required String discountType,
    required double discountValue,
    double? maxDiscountAmount,
    double? minOrderAmount,
    int? priority,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         categoryId: categoryId,
         name: name,
         description: description,
         discountType: discountType,
         discountValue: discountValue,
         maxDiscountAmount: maxDiscountAmount,
         minOrderAmount: minOrderAmount,
         priority: priority,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CategoryOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryOfferRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? categoryId,
    String? name,
    Object? description = _Undefined,
    String? discountType,
    double? discountValue,
    Object? maxDiscountAmount = _Undefined,
    Object? minOrderAmount = _Undefined,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryOfferRow(
      id: id is _i1.UuidValue? ? id : this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxDiscountAmount: maxDiscountAmount is double?
          ? maxDiscountAmount
          : this.maxDiscountAmount,
      minOrderAmount: minOrderAmount is double?
          ? minOrderAmount
          : this.minOrderAmount,
      priority: priority ?? this.priority,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CategoryOfferRowUpdateTable
    extends _i1.UpdateTable<CategoryOfferRowTable> {
  CategoryOfferRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> categoryId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> discountType(String value) => _i1.ColumnValue(
    table.discountType,
    value,
  );

  _i1.ColumnValue<double, double> discountValue(double value) =>
      _i1.ColumnValue(
        table.discountValue,
        value,
      );

  _i1.ColumnValue<double, double> maxDiscountAmount(double? value) =>
      _i1.ColumnValue(
        table.maxDiscountAmount,
        value,
      );

  _i1.ColumnValue<double, double> minOrderAmount(double? value) =>
      _i1.ColumnValue(
        table.minOrderAmount,
        value,
      );

  _i1.ColumnValue<int, int> priority(int value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startsAt(DateTime value) =>
      _i1.ColumnValue(
        table.startsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endsAt(DateTime value) => _i1.ColumnValue(
    table.endsAt,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deactivatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deactivatedAt,
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

class CategoryOfferRowTable extends _i1.Table<_i1.UuidValue?> {
  CategoryOfferRowTable({super.tableRelation})
    : super(tableName: 'category_offer') {
    updateTable = CategoryOfferRowUpdateTable(this);
    categoryId = _i1.ColumnUuid(
      'categoryId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    discountType = _i1.ColumnString(
      'discountType',
      this,
    );
    discountValue = _i1.ColumnDouble(
      'discountValue',
      this,
    );
    maxDiscountAmount = _i1.ColumnDouble(
      'maxDiscountAmount',
      this,
    );
    minOrderAmount = _i1.ColumnDouble(
      'minOrderAmount',
      this,
    );
    priority = _i1.ColumnInt(
      'priority',
      this,
      hasDefault: true,
    );
    startsAt = _i1.ColumnDateTime(
      'startsAt',
      this,
    );
    endsAt = _i1.ColumnDateTime(
      'endsAt',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    deactivatedAt = _i1.ColumnDateTime(
      'deactivatedAt',
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

  late final CategoryOfferRowUpdateTable updateTable;

  late final _i1.ColumnUuid categoryId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString discountType;

  late final _i1.ColumnDouble discountValue;

  late final _i1.ColumnDouble maxDiscountAmount;

  late final _i1.ColumnDouble minOrderAmount;

  late final _i1.ColumnInt priority;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    categoryId,
    name,
    description,
    discountType,
    discountValue,
    maxDiscountAmount,
    minOrderAmount,
    priority,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class CategoryOfferRowInclude extends _i1.IncludeObject {
  CategoryOfferRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferRow.t;
}

class CategoryOfferRowIncludeList extends _i1.IncludeList {
  CategoryOfferRowIncludeList._({
    _i1.WhereExpressionBuilder<CategoryOfferRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CategoryOfferRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CategoryOfferRow.t;
}

class CategoryOfferRowRepository {
  const CategoryOfferRowRepository._();

  /// Returns a list of [CategoryOfferRow]s matching the given query parameters.
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
  Future<List<CategoryOfferRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CategoryOfferRow>(
      where: where?.call(CategoryOfferRow.t),
      orderBy: orderBy?.call(CategoryOfferRow.t),
      orderByList: orderByList?.call(CategoryOfferRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CategoryOfferRow] matching the given query parameters.
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
  Future<CategoryOfferRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CategoryOfferRow>(
      where: where?.call(CategoryOfferRow.t),
      orderBy: orderBy?.call(CategoryOfferRow.t),
      orderByList: orderByList?.call(CategoryOfferRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CategoryOfferRow] by its [id] or null if no such row exists.
  Future<CategoryOfferRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CategoryOfferRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CategoryOfferRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CategoryOfferRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CategoryOfferRow>> insert(
    _i1.DatabaseSession session,
    List<CategoryOfferRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CategoryOfferRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CategoryOfferRow] and returns the inserted row.
  ///
  /// The returned [CategoryOfferRow] will have its `id` field set.
  Future<CategoryOfferRow> insertRow(
    _i1.DatabaseSession session,
    CategoryOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CategoryOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CategoryOfferRow>> update(
    _i1.DatabaseSession session,
    List<CategoryOfferRow> rows, {
    _i1.ColumnSelections<CategoryOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CategoryOfferRow>(
      rows,
      columns: columns?.call(CategoryOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CategoryOfferRow> updateRow(
    _i1.DatabaseSession session,
    CategoryOfferRow row, {
    _i1.ColumnSelections<CategoryOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CategoryOfferRow>(
      row,
      columns: columns?.call(CategoryOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryOfferRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CategoryOfferRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CategoryOfferRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CategoryOfferRow>(
      id,
      columnValues: columnValues(CategoryOfferRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CategoryOfferRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CategoryOfferRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CategoryOfferRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CategoryOfferRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryOfferRowTable>? orderBy,
    _i1.OrderByListBuilder<CategoryOfferRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CategoryOfferRow>(
      columnValues: columnValues(CategoryOfferRow.t.updateTable),
      where: where(CategoryOfferRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryOfferRow.t),
      orderByList: orderByList?.call(CategoryOfferRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CategoryOfferRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CategoryOfferRow>> delete(
    _i1.DatabaseSession session,
    List<CategoryOfferRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CategoryOfferRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CategoryOfferRow].
  Future<CategoryOfferRow> deleteRow(
    _i1.DatabaseSession session,
    CategoryOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CategoryOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CategoryOfferRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CategoryOfferRow>(
      where: where(CategoryOfferRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryOfferRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CategoryOfferRow>(
      where: where?.call(CategoryOfferRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CategoryOfferRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryOfferRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CategoryOfferRow>(
      where: where(CategoryOfferRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
