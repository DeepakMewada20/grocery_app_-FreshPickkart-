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

abstract class FreeDeliveryRuleRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  FreeDeliveryRuleRow._({
    this.id,
    required this.name,
    this.description,
    required this.ruleType,
    this.minOrderAmount,
    this.minItemsCount,
    this.couponId,
    this.userId,
    double? waivedAmount,
    required this.startsAt,
    required this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : waivedAmount = waivedAmount ?? 0.0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory FreeDeliveryRuleRow({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required String ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    _i1.UuidValue? couponId,
    _i1.UuidValue? userId,
    double? waivedAmount,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FreeDeliveryRuleRowImpl;

  factory FreeDeliveryRuleRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FreeDeliveryRuleRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      ruleType: jsonSerialization['ruleType'] as String,
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num?)?.toDouble(),
      minItemsCount: jsonSerialization['minItemsCount'] as int?,
      couponId: jsonSerialization['couponId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['couponId']),
      userId: jsonSerialization['userId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      waivedAmount: (jsonSerialization['waivedAmount'] as num?)?.toDouble(),
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

  static final t = FreeDeliveryRuleRowTable();

  static const db = FreeDeliveryRuleRowRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  String? description;

  String ruleType;

  double? minOrderAmount;

  int? minItemsCount;

  _i1.UuidValue? couponId;

  _i1.UuidValue? userId;

  double waivedAmount;

  DateTime startsAt;

  DateTime endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FreeDeliveryRuleRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreeDeliveryRuleRow copyWith({
    _i1.UuidValue? id,
    String? name,
    String? description,
    String? ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    _i1.UuidValue? couponId,
    _i1.UuidValue? userId,
    double? waivedAmount,
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
      '__className__': 'FreeDeliveryRuleRow',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (description != null) 'description': description,
      'ruleType': ruleType,
      if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
      if (minItemsCount != null) 'minItemsCount': minItemsCount,
      if (couponId != null) 'couponId': couponId?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      'waivedAmount': waivedAmount,
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

  static FreeDeliveryRuleRowInclude include() {
    return FreeDeliveryRuleRowInclude._();
  }

  static FreeDeliveryRuleRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreeDeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreeDeliveryRuleRowTable>? orderByList,
    FreeDeliveryRuleRowInclude? include,
  }) {
    return FreeDeliveryRuleRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreeDeliveryRuleRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FreeDeliveryRuleRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreeDeliveryRuleRowImpl extends FreeDeliveryRuleRow {
  _FreeDeliveryRuleRowImpl({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required String ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    _i1.UuidValue? couponId,
    _i1.UuidValue? userId,
    double? waivedAmount,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         ruleType: ruleType,
         minOrderAmount: minOrderAmount,
         minItemsCount: minItemsCount,
         couponId: couponId,
         userId: userId,
         waivedAmount: waivedAmount,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FreeDeliveryRuleRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreeDeliveryRuleRow copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? ruleType,
    Object? minOrderAmount = _Undefined,
    Object? minItemsCount = _Undefined,
    Object? couponId = _Undefined,
    Object? userId = _Undefined,
    double? waivedAmount,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FreeDeliveryRuleRow(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      ruleType: ruleType ?? this.ruleType,
      minOrderAmount: minOrderAmount is double?
          ? minOrderAmount
          : this.minOrderAmount,
      minItemsCount: minItemsCount is int? ? minItemsCount : this.minItemsCount,
      couponId: couponId is _i1.UuidValue? ? couponId : this.couponId,
      userId: userId is _i1.UuidValue? ? userId : this.userId,
      waivedAmount: waivedAmount ?? this.waivedAmount,
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

class FreeDeliveryRuleRowUpdateTable
    extends _i1.UpdateTable<FreeDeliveryRuleRowTable> {
  FreeDeliveryRuleRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> ruleType(String value) => _i1.ColumnValue(
    table.ruleType,
    value,
  );

  _i1.ColumnValue<double, double> minOrderAmount(double? value) =>
      _i1.ColumnValue(
        table.minOrderAmount,
        value,
      );

  _i1.ColumnValue<int, int> minItemsCount(int? value) => _i1.ColumnValue(
    table.minItemsCount,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> couponId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.couponId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue? value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<double, double> waivedAmount(double value) => _i1.ColumnValue(
    table.waivedAmount,
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

class FreeDeliveryRuleRowTable extends _i1.Table<_i1.UuidValue?> {
  FreeDeliveryRuleRowTable({super.tableRelation})
    : super(tableName: 'free_delivery_rule') {
    updateTable = FreeDeliveryRuleRowUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    ruleType = _i1.ColumnString(
      'ruleType',
      this,
    );
    minOrderAmount = _i1.ColumnDouble(
      'minOrderAmount',
      this,
    );
    minItemsCount = _i1.ColumnInt(
      'minItemsCount',
      this,
    );
    couponId = _i1.ColumnUuid(
      'couponId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    waivedAmount = _i1.ColumnDouble(
      'waivedAmount',
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

  late final FreeDeliveryRuleRowUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString ruleType;

  late final _i1.ColumnDouble minOrderAmount;

  late final _i1.ColumnInt minItemsCount;

  late final _i1.ColumnUuid couponId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnDouble waivedAmount;

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
    ruleType,
    minOrderAmount,
    minItemsCount,
    couponId,
    userId,
    waivedAmount,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class FreeDeliveryRuleRowInclude extends _i1.IncludeObject {
  FreeDeliveryRuleRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreeDeliveryRuleRow.t;
}

class FreeDeliveryRuleRowIncludeList extends _i1.IncludeList {
  FreeDeliveryRuleRowIncludeList._({
    _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FreeDeliveryRuleRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreeDeliveryRuleRow.t;
}

class FreeDeliveryRuleRowRepository {
  const FreeDeliveryRuleRowRepository._();

  /// Returns a list of [FreeDeliveryRuleRow]s matching the given query parameters.
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
  Future<List<FreeDeliveryRuleRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreeDeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreeDeliveryRuleRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FreeDeliveryRuleRow>(
      where: where?.call(FreeDeliveryRuleRow.t),
      orderBy: orderBy?.call(FreeDeliveryRuleRow.t),
      orderByList: orderByList?.call(FreeDeliveryRuleRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FreeDeliveryRuleRow] matching the given query parameters.
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
  Future<FreeDeliveryRuleRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FreeDeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreeDeliveryRuleRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FreeDeliveryRuleRow>(
      where: where?.call(FreeDeliveryRuleRow.t),
      orderBy: orderBy?.call(FreeDeliveryRuleRow.t),
      orderByList: orderByList?.call(FreeDeliveryRuleRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FreeDeliveryRuleRow] by its [id] or null if no such row exists.
  Future<FreeDeliveryRuleRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FreeDeliveryRuleRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FreeDeliveryRuleRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FreeDeliveryRuleRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FreeDeliveryRuleRow>> insert(
    _i1.DatabaseSession session,
    List<FreeDeliveryRuleRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FreeDeliveryRuleRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FreeDeliveryRuleRow] and returns the inserted row.
  ///
  /// The returned [FreeDeliveryRuleRow] will have its `id` field set.
  Future<FreeDeliveryRuleRow> insertRow(
    _i1.DatabaseSession session,
    FreeDeliveryRuleRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FreeDeliveryRuleRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FreeDeliveryRuleRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FreeDeliveryRuleRow>> update(
    _i1.DatabaseSession session,
    List<FreeDeliveryRuleRow> rows, {
    _i1.ColumnSelections<FreeDeliveryRuleRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FreeDeliveryRuleRow>(
      rows,
      columns: columns?.call(FreeDeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreeDeliveryRuleRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FreeDeliveryRuleRow> updateRow(
    _i1.DatabaseSession session,
    FreeDeliveryRuleRow row, {
    _i1.ColumnSelections<FreeDeliveryRuleRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FreeDeliveryRuleRow>(
      row,
      columns: columns?.call(FreeDeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreeDeliveryRuleRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FreeDeliveryRuleRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<FreeDeliveryRuleRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FreeDeliveryRuleRow>(
      id,
      columnValues: columnValues(FreeDeliveryRuleRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FreeDeliveryRuleRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FreeDeliveryRuleRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FreeDeliveryRuleRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreeDeliveryRuleRowTable>? orderBy,
    _i1.OrderByListBuilder<FreeDeliveryRuleRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FreeDeliveryRuleRow>(
      columnValues: columnValues(FreeDeliveryRuleRow.t.updateTable),
      where: where(FreeDeliveryRuleRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreeDeliveryRuleRow.t),
      orderByList: orderByList?.call(FreeDeliveryRuleRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FreeDeliveryRuleRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FreeDeliveryRuleRow>> delete(
    _i1.DatabaseSession session,
    List<FreeDeliveryRuleRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FreeDeliveryRuleRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FreeDeliveryRuleRow].
  Future<FreeDeliveryRuleRow> deleteRow(
    _i1.DatabaseSession session,
    FreeDeliveryRuleRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FreeDeliveryRuleRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FreeDeliveryRuleRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FreeDeliveryRuleRow>(
      where: where(FreeDeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FreeDeliveryRuleRow>(
      where: where?.call(FreeDeliveryRuleRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FreeDeliveryRuleRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreeDeliveryRuleRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FreeDeliveryRuleRow>(
      where: where(FreeDeliveryRuleRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
