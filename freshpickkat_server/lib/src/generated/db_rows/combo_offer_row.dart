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

abstract class ComboOfferRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ComboOfferRow._({
    this.id,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    int? minQuantityPerProduct,
    this.maxUsagePerUser,
    this.maxUsageTotal,
    int? usedCount,
    int? priority,
    this.startsAt,
    this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : minQuantityPerProduct = minQuantityPerProduct ?? 1,
       usedCount = usedCount ?? 0,
       priority = priority ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ComboOfferRow({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required String discountType,
    required double discountValue,
    int? minQuantityPerProduct,
    int? maxUsagePerUser,
    int? maxUsageTotal,
    int? usedCount,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ComboOfferRowImpl;

  factory ComboOfferRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComboOfferRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      discountType: jsonSerialization['discountType'] as String,
      discountValue: (jsonSerialization['discountValue'] as num).toDouble(),
      minQuantityPerProduct: jsonSerialization['minQuantityPerProduct'] as int?,
      maxUsagePerUser: jsonSerialization['maxUsagePerUser'] as int?,
      maxUsageTotal: jsonSerialization['maxUsageTotal'] as int?,
      usedCount: jsonSerialization['usedCount'] as int?,
      priority: jsonSerialization['priority'] as int?,
      startsAt: jsonSerialization['startsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startsAt']),
      endsAt: jsonSerialization['endsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
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

  static final t = ComboOfferRowTable();

  static const db = ComboOfferRowRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  String? description;

  String discountType;

  double discountValue;

  int minQuantityPerProduct;

  int? maxUsagePerUser;

  int? maxUsageTotal;

  int usedCount;

  int priority;

  DateTime? startsAt;

  DateTime? endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ComboOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComboOfferRow copyWith({
    _i1.UuidValue? id,
    String? name,
    String? description,
    String? discountType,
    double? discountValue,
    int? minQuantityPerProduct,
    int? maxUsagePerUser,
    int? maxUsageTotal,
    int? usedCount,
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
      '__className__': 'ComboOfferRow',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (description != null) 'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minQuantityPerProduct': minQuantityPerProduct,
      if (maxUsagePerUser != null) 'maxUsagePerUser': maxUsagePerUser,
      if (maxUsageTotal != null) 'maxUsageTotal': maxUsageTotal,
      'usedCount': usedCount,
      'priority': priority,
      if (startsAt != null) 'startsAt': startsAt?.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
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

  static ComboOfferRowInclude include() {
    return ComboOfferRowInclude._();
  }

  static ComboOfferRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ComboOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferRowTable>? orderByList,
    ComboOfferRowInclude? include,
  }) {
    return ComboOfferRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComboOfferRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ComboOfferRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComboOfferRowImpl extends ComboOfferRow {
  _ComboOfferRowImpl({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required String discountType,
    required double discountValue,
    int? minQuantityPerProduct,
    int? maxUsagePerUser,
    int? maxUsageTotal,
    int? usedCount,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         discountType: discountType,
         discountValue: discountValue,
         minQuantityPerProduct: minQuantityPerProduct,
         maxUsagePerUser: maxUsagePerUser,
         maxUsageTotal: maxUsageTotal,
         usedCount: usedCount,
         priority: priority,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ComboOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComboOfferRow copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? discountType,
    double? discountValue,
    int? minQuantityPerProduct,
    Object? maxUsagePerUser = _Undefined,
    Object? maxUsageTotal = _Undefined,
    int? usedCount,
    int? priority,
    Object? startsAt = _Undefined,
    Object? endsAt = _Undefined,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComboOfferRow(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minQuantityPerProduct:
          minQuantityPerProduct ?? this.minQuantityPerProduct,
      maxUsagePerUser: maxUsagePerUser is int?
          ? maxUsagePerUser
          : this.maxUsagePerUser,
      maxUsageTotal: maxUsageTotal is int? ? maxUsageTotal : this.maxUsageTotal,
      usedCount: usedCount ?? this.usedCount,
      priority: priority ?? this.priority,
      startsAt: startsAt is DateTime? ? startsAt : this.startsAt,
      endsAt: endsAt is DateTime? ? endsAt : this.endsAt,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComboOfferRowUpdateTable extends _i1.UpdateTable<ComboOfferRowTable> {
  ComboOfferRowUpdateTable(super.table);

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

  _i1.ColumnValue<int, int> minQuantityPerProduct(int value) => _i1.ColumnValue(
    table.minQuantityPerProduct,
    value,
  );

  _i1.ColumnValue<int, int> maxUsagePerUser(int? value) => _i1.ColumnValue(
    table.maxUsagePerUser,
    value,
  );

  _i1.ColumnValue<int, int> maxUsageTotal(int? value) => _i1.ColumnValue(
    table.maxUsageTotal,
    value,
  );

  _i1.ColumnValue<int, int> usedCount(int value) => _i1.ColumnValue(
    table.usedCount,
    value,
  );

  _i1.ColumnValue<int, int> priority(int value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startsAt(DateTime? value) =>
      _i1.ColumnValue(
        table.startsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endsAt(DateTime? value) =>
      _i1.ColumnValue(
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

class ComboOfferRowTable extends _i1.Table<_i1.UuidValue?> {
  ComboOfferRowTable({super.tableRelation}) : super(tableName: 'combo_offer') {
    updateTable = ComboOfferRowUpdateTable(this);
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
    minQuantityPerProduct = _i1.ColumnInt(
      'minQuantityPerProduct',
      this,
      hasDefault: true,
    );
    maxUsagePerUser = _i1.ColumnInt(
      'maxUsagePerUser',
      this,
    );
    maxUsageTotal = _i1.ColumnInt(
      'maxUsageTotal',
      this,
    );
    usedCount = _i1.ColumnInt(
      'usedCount',
      this,
      hasDefault: true,
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

  late final ComboOfferRowUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString discountType;

  late final _i1.ColumnDouble discountValue;

  late final _i1.ColumnInt minQuantityPerProduct;

  late final _i1.ColumnInt maxUsagePerUser;

  late final _i1.ColumnInt maxUsageTotal;

  late final _i1.ColumnInt usedCount;

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
    name,
    description,
    discountType,
    discountValue,
    minQuantityPerProduct,
    maxUsagePerUser,
    maxUsageTotal,
    usedCount,
    priority,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class ComboOfferRowInclude extends _i1.IncludeObject {
  ComboOfferRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComboOfferRow.t;
}

class ComboOfferRowIncludeList extends _i1.IncludeList {
  ComboOfferRowIncludeList._({
    _i1.WhereExpressionBuilder<ComboOfferRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ComboOfferRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComboOfferRow.t;
}

class ComboOfferRowRepository {
  const ComboOfferRowRepository._();

  /// Returns a list of [ComboOfferRow]s matching the given query parameters.
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
  Future<List<ComboOfferRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ComboOfferRow>(
      where: where?.call(ComboOfferRow.t),
      orderBy: orderBy?.call(ComboOfferRow.t),
      orderByList: orderByList?.call(ComboOfferRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ComboOfferRow] matching the given query parameters.
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
  Future<ComboOfferRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComboOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComboOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ComboOfferRow>(
      where: where?.call(ComboOfferRow.t),
      orderBy: orderBy?.call(ComboOfferRow.t),
      orderByList: orderByList?.call(ComboOfferRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ComboOfferRow] by its [id] or null if no such row exists.
  Future<ComboOfferRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ComboOfferRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ComboOfferRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ComboOfferRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ComboOfferRow>> insert(
    _i1.DatabaseSession session,
    List<ComboOfferRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ComboOfferRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ComboOfferRow] and returns the inserted row.
  ///
  /// The returned [ComboOfferRow] will have its `id` field set.
  Future<ComboOfferRow> insertRow(
    _i1.DatabaseSession session,
    ComboOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ComboOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ComboOfferRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ComboOfferRow>> update(
    _i1.DatabaseSession session,
    List<ComboOfferRow> rows, {
    _i1.ColumnSelections<ComboOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ComboOfferRow>(
      rows,
      columns: columns?.call(ComboOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComboOfferRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ComboOfferRow> updateRow(
    _i1.DatabaseSession session,
    ComboOfferRow row, {
    _i1.ColumnSelections<ComboOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ComboOfferRow>(
      row,
      columns: columns?.call(ComboOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComboOfferRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ComboOfferRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ComboOfferRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ComboOfferRow>(
      id,
      columnValues: columnValues(ComboOfferRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ComboOfferRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ComboOfferRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ComboOfferRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ComboOfferRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComboOfferRowTable>? orderBy,
    _i1.OrderByListBuilder<ComboOfferRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ComboOfferRow>(
      columnValues: columnValues(ComboOfferRow.t.updateTable),
      where: where(ComboOfferRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComboOfferRow.t),
      orderByList: orderByList?.call(ComboOfferRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ComboOfferRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ComboOfferRow>> delete(
    _i1.DatabaseSession session,
    List<ComboOfferRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ComboOfferRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ComboOfferRow].
  Future<ComboOfferRow> deleteRow(
    _i1.DatabaseSession session,
    ComboOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ComboOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ComboOfferRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComboOfferRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ComboOfferRow>(
      where: where(ComboOfferRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComboOfferRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ComboOfferRow>(
      where: where?.call(ComboOfferRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ComboOfferRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComboOfferRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ComboOfferRow>(
      where: where(ComboOfferRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
