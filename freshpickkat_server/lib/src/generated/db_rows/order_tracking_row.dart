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

abstract class OrderTrackingRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  OrderTrackingRow._({
    this.id,
    required this.orderId,
    bool? trackingEnabled,
    this.userLatitude,
    this.userLongitude,
    this.userAddress,
    this.userLocationType,
    this.riderLatitude,
    this.riderLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : trackingEnabled = trackingEnabled ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory OrderTrackingRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    bool? trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrderTrackingRowImpl;

  factory OrderTrackingRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderTrackingRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      trackingEnabled: jsonSerialization['trackingEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['trackingEnabled'],
            ),
      userLatitude: (jsonSerialization['userLatitude'] as num?)?.toDouble(),
      userLongitude: (jsonSerialization['userLongitude'] as num?)?.toDouble(),
      userAddress: jsonSerialization['userAddress'] as String?,
      userLocationType: jsonSerialization['userLocationType'] as String?,
      riderLatitude: (jsonSerialization['riderLatitude'] as num?)?.toDouble(),
      riderLongitude: (jsonSerialization['riderLongitude'] as num?)?.toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = OrderTrackingRowTable();

  static const db = OrderTrackingRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  bool trackingEnabled;

  double? userLatitude;

  double? userLongitude;

  String? userAddress;

  String? userLocationType;

  double? riderLatitude;

  double? riderLongitude;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OrderTrackingRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderTrackingRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    bool? trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderTrackingRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'trackingEnabled': trackingEnabled,
      if (userLatitude != null) 'userLatitude': userLatitude,
      if (userLongitude != null) 'userLongitude': userLongitude,
      if (userAddress != null) 'userAddress': userAddress,
      if (userLocationType != null) 'userLocationType': userLocationType,
      if (riderLatitude != null) 'riderLatitude': riderLatitude,
      if (riderLongitude != null) 'riderLongitude': riderLongitude,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static OrderTrackingRowInclude include() {
    return OrderTrackingRowInclude._();
  }

  static OrderTrackingRowIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderTrackingRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderTrackingRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTrackingRowTable>? orderByList,
    OrderTrackingRowInclude? include,
  }) {
    return OrderTrackingRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderTrackingRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderTrackingRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderTrackingRowImpl extends OrderTrackingRow {
  _OrderTrackingRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    bool? trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         trackingEnabled: trackingEnabled,
         userLatitude: userLatitude,
         userLongitude: userLongitude,
         userAddress: userAddress,
         userLocationType: userLocationType,
         riderLatitude: riderLatitude,
         riderLongitude: riderLongitude,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OrderTrackingRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderTrackingRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    bool? trackingEnabled,
    Object? userLatitude = _Undefined,
    Object? userLongitude = _Undefined,
    Object? userAddress = _Undefined,
    Object? userLocationType = _Undefined,
    Object? riderLatitude = _Undefined,
    Object? riderLongitude = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderTrackingRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      trackingEnabled: trackingEnabled ?? this.trackingEnabled,
      userLatitude: userLatitude is double? ? userLatitude : this.userLatitude,
      userLongitude: userLongitude is double?
          ? userLongitude
          : this.userLongitude,
      userAddress: userAddress is String? ? userAddress : this.userAddress,
      userLocationType: userLocationType is String?
          ? userLocationType
          : this.userLocationType,
      riderLatitude: riderLatitude is double?
          ? riderLatitude
          : this.riderLatitude,
      riderLongitude: riderLongitude is double?
          ? riderLongitude
          : this.riderLongitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderTrackingRowUpdateTable
    extends _i1.UpdateTable<OrderTrackingRowTable> {
  OrderTrackingRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<bool, bool> trackingEnabled(bool value) => _i1.ColumnValue(
    table.trackingEnabled,
    value,
  );

  _i1.ColumnValue<double, double> userLatitude(double? value) =>
      _i1.ColumnValue(
        table.userLatitude,
        value,
      );

  _i1.ColumnValue<double, double> userLongitude(double? value) =>
      _i1.ColumnValue(
        table.userLongitude,
        value,
      );

  _i1.ColumnValue<String, String> userAddress(String? value) => _i1.ColumnValue(
    table.userAddress,
    value,
  );

  _i1.ColumnValue<String, String> userLocationType(String? value) =>
      _i1.ColumnValue(
        table.userLocationType,
        value,
      );

  _i1.ColumnValue<double, double> riderLatitude(double? value) =>
      _i1.ColumnValue(
        table.riderLatitude,
        value,
      );

  _i1.ColumnValue<double, double> riderLongitude(double? value) =>
      _i1.ColumnValue(
        table.riderLongitude,
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

class OrderTrackingRowTable extends _i1.Table<_i1.UuidValue?> {
  OrderTrackingRowTable({super.tableRelation})
    : super(tableName: 'order_tracking') {
    updateTable = OrderTrackingRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    trackingEnabled = _i1.ColumnBool(
      'trackingEnabled',
      this,
      hasDefault: true,
    );
    userLatitude = _i1.ColumnDouble(
      'userLatitude',
      this,
    );
    userLongitude = _i1.ColumnDouble(
      'userLongitude',
      this,
    );
    userAddress = _i1.ColumnString(
      'userAddress',
      this,
    );
    userLocationType = _i1.ColumnString(
      'userLocationType',
      this,
    );
    riderLatitude = _i1.ColumnDouble(
      'riderLatitude',
      this,
    );
    riderLongitude = _i1.ColumnDouble(
      'riderLongitude',
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

  late final OrderTrackingRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnBool trackingEnabled;

  late final _i1.ColumnDouble userLatitude;

  late final _i1.ColumnDouble userLongitude;

  late final _i1.ColumnString userAddress;

  late final _i1.ColumnString userLocationType;

  late final _i1.ColumnDouble riderLatitude;

  late final _i1.ColumnDouble riderLongitude;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    trackingEnabled,
    userLatitude,
    userLongitude,
    userAddress,
    userLocationType,
    riderLatitude,
    riderLongitude,
    createdAt,
    updatedAt,
  ];
}

class OrderTrackingRowInclude extends _i1.IncludeObject {
  OrderTrackingRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderTrackingRow.t;
}

class OrderTrackingRowIncludeList extends _i1.IncludeList {
  OrderTrackingRowIncludeList._({
    _i1.WhereExpressionBuilder<OrderTrackingRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderTrackingRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderTrackingRow.t;
}

class OrderTrackingRowRepository {
  const OrderTrackingRowRepository._();

  /// Returns a list of [OrderTrackingRow]s matching the given query parameters.
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
  Future<List<OrderTrackingRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderTrackingRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderTrackingRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTrackingRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderTrackingRow>(
      where: where?.call(OrderTrackingRow.t),
      orderBy: orderBy?.call(OrderTrackingRow.t),
      orderByList: orderByList?.call(OrderTrackingRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderTrackingRow] matching the given query parameters.
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
  Future<OrderTrackingRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderTrackingRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderTrackingRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTrackingRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderTrackingRow>(
      where: where?.call(OrderTrackingRow.t),
      orderBy: orderBy?.call(OrderTrackingRow.t),
      orderByList: orderByList?.call(OrderTrackingRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderTrackingRow] by its [id] or null if no such row exists.
  Future<OrderTrackingRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderTrackingRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderTrackingRow]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderTrackingRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderTrackingRow>> insert(
    _i1.DatabaseSession session,
    List<OrderTrackingRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderTrackingRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderTrackingRow] and returns the inserted row.
  ///
  /// The returned [OrderTrackingRow] will have its `id` field set.
  Future<OrderTrackingRow> insertRow(
    _i1.DatabaseSession session,
    OrderTrackingRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderTrackingRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderTrackingRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderTrackingRow>> update(
    _i1.DatabaseSession session,
    List<OrderTrackingRow> rows, {
    _i1.ColumnSelections<OrderTrackingRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderTrackingRow>(
      rows,
      columns: columns?.call(OrderTrackingRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderTrackingRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderTrackingRow> updateRow(
    _i1.DatabaseSession session,
    OrderTrackingRow row, {
    _i1.ColumnSelections<OrderTrackingRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderTrackingRow>(
      row,
      columns: columns?.call(OrderTrackingRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderTrackingRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderTrackingRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<OrderTrackingRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderTrackingRow>(
      id,
      columnValues: columnValues(OrderTrackingRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderTrackingRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderTrackingRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderTrackingRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderTrackingRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderTrackingRowTable>? orderBy,
    _i1.OrderByListBuilder<OrderTrackingRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderTrackingRow>(
      columnValues: columnValues(OrderTrackingRow.t.updateTable),
      where: where(OrderTrackingRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderTrackingRow.t),
      orderByList: orderByList?.call(OrderTrackingRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderTrackingRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderTrackingRow>> delete(
    _i1.DatabaseSession session,
    List<OrderTrackingRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderTrackingRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderTrackingRow].
  Future<OrderTrackingRow> deleteRow(
    _i1.DatabaseSession session,
    OrderTrackingRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderTrackingRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderTrackingRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderTrackingRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderTrackingRow>(
      where: where(OrderTrackingRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderTrackingRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderTrackingRow>(
      where: where?.call(OrderTrackingRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderTrackingRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderTrackingRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderTrackingRow>(
      where: where(OrderTrackingRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
