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

abstract class DeliveryRuleRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  DeliveryRuleRow._({
    this.id,
    required this.name,
    this.description,
    required this.deliveryFee,
    int? sortOrder,
    this.targetUserType,
    this.targetOrderCount,
    this.startsAt,
    this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : sortOrder = sortOrder ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory DeliveryRuleRow({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required double deliveryFee,
    int? sortOrder,
    String? targetUserType,
    int? targetOrderCount,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeliveryRuleRowImpl;

  factory DeliveryRuleRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryRuleRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      targetUserType: jsonSerialization['targetUserType'] as String?,
      targetOrderCount: jsonSerialization['targetOrderCount'] as int?,
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

  static final t = DeliveryRuleRowTable();

  static const db = DeliveryRuleRowRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  String? description;

  double deliveryFee;

  int sortOrder;

  String? targetUserType;

  int? targetOrderCount;

  DateTime? startsAt;

  DateTime? endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeliveryRuleRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryRuleRow copyWith({
    _i1.UuidValue? id,
    String? name,
    String? description,
    double? deliveryFee,
    int? sortOrder,
    String? targetUserType,
    int? targetOrderCount,
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
      '__className__': 'DeliveryRuleRow',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (description != null) 'description': description,
      'deliveryFee': deliveryFee,
      'sortOrder': sortOrder,
      if (targetUserType != null) 'targetUserType': targetUserType,
      if (targetOrderCount != null) 'targetOrderCount': targetOrderCount,
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

  static DeliveryRuleRowInclude include() {
    return DeliveryRuleRowInclude._();
  }

  static DeliveryRuleRowIncludeList includeList({
    _i1.WhereExpressionBuilder<DeliveryRuleRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryRuleRowTable>? orderByList,
    DeliveryRuleRowInclude? include,
  }) {
    return DeliveryRuleRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryRuleRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeliveryRuleRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryRuleRowImpl extends DeliveryRuleRow {
  _DeliveryRuleRowImpl({
    _i1.UuidValue? id,
    required String name,
    String? description,
    required double deliveryFee,
    int? sortOrder,
    String? targetUserType,
    int? targetOrderCount,
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
         deliveryFee: deliveryFee,
         sortOrder: sortOrder,
         targetUserType: targetUserType,
         targetOrderCount: targetOrderCount,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliveryRuleRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryRuleRow copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    double? deliveryFee,
    int? sortOrder,
    Object? targetUserType = _Undefined,
    Object? targetOrderCount = _Undefined,
    Object? startsAt = _Undefined,
    Object? endsAt = _Undefined,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryRuleRow(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      sortOrder: sortOrder ?? this.sortOrder,
      targetUserType: targetUserType is String?
          ? targetUserType
          : this.targetUserType,
      targetOrderCount: targetOrderCount is int?
          ? targetOrderCount
          : this.targetOrderCount,
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

class DeliveryRuleRowUpdateTable extends _i1.UpdateTable<DeliveryRuleRowTable> {
  DeliveryRuleRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> deliveryFee(double value) => _i1.ColumnValue(
    table.deliveryFee,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
    value,
  );

  _i1.ColumnValue<String, String> targetUserType(String? value) =>
      _i1.ColumnValue(
        table.targetUserType,
        value,
      );

  _i1.ColumnValue<int, int> targetOrderCount(int? value) => _i1.ColumnValue(
    table.targetOrderCount,
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

class DeliveryRuleRowTable extends _i1.Table<_i1.UuidValue?> {
  DeliveryRuleRowTable({super.tableRelation})
    : super(tableName: 'delivery_rule') {
    updateTable = DeliveryRuleRowUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    deliveryFee = _i1.ColumnDouble(
      'deliveryFee',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
    targetUserType = _i1.ColumnString(
      'targetUserType',
      this,
    );
    targetOrderCount = _i1.ColumnInt(
      'targetOrderCount',
      this,
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

  late final DeliveryRuleRowUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble deliveryFee;

  late final _i1.ColumnInt sortOrder;

  late final _i1.ColumnString targetUserType;

  late final _i1.ColumnInt targetOrderCount;

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
    deliveryFee,
    sortOrder,
    targetUserType,
    targetOrderCount,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class DeliveryRuleRowInclude extends _i1.IncludeObject {
  DeliveryRuleRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryRuleRow.t;
}

class DeliveryRuleRowIncludeList extends _i1.IncludeList {
  DeliveryRuleRowIncludeList._({
    _i1.WhereExpressionBuilder<DeliveryRuleRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeliveryRuleRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliveryRuleRow.t;
}

class DeliveryRuleRowRepository {
  const DeliveryRuleRowRepository._();

  /// Returns a list of [DeliveryRuleRow]s matching the given query parameters.
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
  Future<List<DeliveryRuleRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryRuleRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryRuleRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeliveryRuleRow>(
      where: where?.call(DeliveryRuleRow.t),
      orderBy: orderBy?.call(DeliveryRuleRow.t),
      orderByList: orderByList?.call(DeliveryRuleRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeliveryRuleRow] matching the given query parameters.
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
  Future<DeliveryRuleRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryRuleRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeliveryRuleRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliveryRuleRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeliveryRuleRow>(
      where: where?.call(DeliveryRuleRow.t),
      orderBy: orderBy?.call(DeliveryRuleRow.t),
      orderByList: orderByList?.call(DeliveryRuleRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeliveryRuleRow] by its [id] or null if no such row exists.
  Future<DeliveryRuleRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeliveryRuleRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeliveryRuleRow]s in the list and returns the inserted rows.
  ///
  /// The returned [DeliveryRuleRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeliveryRuleRow>> insert(
    _i1.DatabaseSession session,
    List<DeliveryRuleRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeliveryRuleRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeliveryRuleRow] and returns the inserted row.
  ///
  /// The returned [DeliveryRuleRow] will have its `id` field set.
  Future<DeliveryRuleRow> insertRow(
    _i1.DatabaseSession session,
    DeliveryRuleRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeliveryRuleRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryRuleRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeliveryRuleRow>> update(
    _i1.DatabaseSession session,
    List<DeliveryRuleRow> rows, {
    _i1.ColumnSelections<DeliveryRuleRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeliveryRuleRow>(
      rows,
      columns: columns?.call(DeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryRuleRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeliveryRuleRow> updateRow(
    _i1.DatabaseSession session,
    DeliveryRuleRow row, {
    _i1.ColumnSelections<DeliveryRuleRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeliveryRuleRow>(
      row,
      columns: columns?.call(DeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliveryRuleRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeliveryRuleRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DeliveryRuleRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeliveryRuleRow>(
      id,
      columnValues: columnValues(DeliveryRuleRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeliveryRuleRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeliveryRuleRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeliveryRuleRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeliveryRuleRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliveryRuleRowTable>? orderBy,
    _i1.OrderByListBuilder<DeliveryRuleRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeliveryRuleRow>(
      columnValues: columnValues(DeliveryRuleRow.t.updateTable),
      where: where(DeliveryRuleRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliveryRuleRow.t),
      orderByList: orderByList?.call(DeliveryRuleRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeliveryRuleRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeliveryRuleRow>> delete(
    _i1.DatabaseSession session,
    List<DeliveryRuleRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeliveryRuleRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeliveryRuleRow].
  Future<DeliveryRuleRow> deleteRow(
    _i1.DatabaseSession session,
    DeliveryRuleRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeliveryRuleRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeliveryRuleRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryRuleRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeliveryRuleRow>(
      where: where(DeliveryRuleRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliveryRuleRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeliveryRuleRow>(
      where: where?.call(DeliveryRuleRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeliveryRuleRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliveryRuleRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeliveryRuleRow>(
      where: where(DeliveryRuleRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
