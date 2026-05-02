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

abstract class OrderAddressRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  OrderAddressRow._({
    this.id,
    required this.orderId,
    this.recipientName,
    this.phoneNumber,
    required this.streetLine1,
    this.streetLine2,
    this.landmark,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderAddressRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    String? recipientName,
    String? phoneNumber,
    required String streetLine1,
    String? streetLine2,
    String? landmark,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) = _OrderAddressRowImpl;

  factory OrderAddressRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderAddressRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      recipientName: jsonSerialization['recipientName'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      streetLine1: jsonSerialization['streetLine1'] as String,
      streetLine2: jsonSerialization['streetLine2'] as String?,
      landmark: jsonSerialization['landmark'] as String?,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String,
      postalCode: jsonSerialization['postalCode'] as String,
      country: jsonSerialization['country'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = OrderAddressRowTable();

  static const db = OrderAddressRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  String? recipientName;

  String? phoneNumber;

  String streetLine1;

  String? streetLine2;

  String? landmark;

  String city;

  String state;

  String postalCode;

  String country;

  double? latitude;

  double? longitude;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OrderAddressRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderAddressRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    String? recipientName,
    String? phoneNumber,
    String? streetLine1,
    String? streetLine2,
    String? landmark,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderAddressRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      if (recipientName != null) 'recipientName': recipientName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'streetLine1': streetLine1,
      if (streetLine2 != null) 'streetLine2': streetLine2,
      if (landmark != null) 'landmark': landmark,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static OrderAddressRowInclude include() {
    return OrderAddressRowInclude._();
  }

  static OrderAddressRowIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderAddressRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderAddressRowTable>? orderByList,
    OrderAddressRowInclude? include,
  }) {
    return OrderAddressRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderAddressRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderAddressRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderAddressRowImpl extends OrderAddressRow {
  _OrderAddressRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    String? recipientName,
    String? phoneNumber,
    required String streetLine1,
    String? streetLine2,
    String? landmark,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         recipientName: recipientName,
         phoneNumber: phoneNumber,
         streetLine1: streetLine1,
         streetLine2: streetLine2,
         landmark: landmark,
         city: city,
         state: state,
         postalCode: postalCode,
         country: country,
         latitude: latitude,
         longitude: longitude,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OrderAddressRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderAddressRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    Object? recipientName = _Undefined,
    Object? phoneNumber = _Undefined,
    String? streetLine1,
    Object? streetLine2 = _Undefined,
    Object? landmark = _Undefined,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    DateTime? createdAt,
  }) {
    return OrderAddressRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      recipientName: recipientName is String?
          ? recipientName
          : this.recipientName,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      streetLine1: streetLine1 ?? this.streetLine1,
      streetLine2: streetLine2 is String? ? streetLine2 : this.streetLine2,
      landmark: landmark is String? ? landmark : this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrderAddressRowUpdateTable extends _i1.UpdateTable<OrderAddressRowTable> {
  OrderAddressRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<String, String> recipientName(String? value) =>
      _i1.ColumnValue(
        table.recipientName,
        value,
      );

  _i1.ColumnValue<String, String> phoneNumber(String? value) => _i1.ColumnValue(
    table.phoneNumber,
    value,
  );

  _i1.ColumnValue<String, String> streetLine1(String value) => _i1.ColumnValue(
    table.streetLine1,
    value,
  );

  _i1.ColumnValue<String, String> streetLine2(String? value) => _i1.ColumnValue(
    table.streetLine2,
    value,
  );

  _i1.ColumnValue<String, String> landmark(String? value) => _i1.ColumnValue(
    table.landmark,
    value,
  );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> state(String value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<String, String> postalCode(String value) => _i1.ColumnValue(
    table.postalCode,
    value,
  );

  _i1.ColumnValue<String, String> country(String value) => _i1.ColumnValue(
    table.country,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class OrderAddressRowTable extends _i1.Table<_i1.UuidValue?> {
  OrderAddressRowTable({super.tableRelation})
    : super(tableName: 'order_address') {
    updateTable = OrderAddressRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    recipientName = _i1.ColumnString(
      'recipientName',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    streetLine1 = _i1.ColumnString(
      'streetLine1',
      this,
    );
    streetLine2 = _i1.ColumnString(
      'streetLine2',
      this,
    );
    landmark = _i1.ColumnString(
      'landmark',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    postalCode = _i1.ColumnString(
      'postalCode',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final OrderAddressRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnString recipientName;

  late final _i1.ColumnString phoneNumber;

  late final _i1.ColumnString streetLine1;

  late final _i1.ColumnString streetLine2;

  late final _i1.ColumnString landmark;

  late final _i1.ColumnString city;

  late final _i1.ColumnString state;

  late final _i1.ColumnString postalCode;

  late final _i1.ColumnString country;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    recipientName,
    phoneNumber,
    streetLine1,
    streetLine2,
    landmark,
    city,
    state,
    postalCode,
    country,
    latitude,
    longitude,
    createdAt,
  ];
}

class OrderAddressRowInclude extends _i1.IncludeObject {
  OrderAddressRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderAddressRow.t;
}

class OrderAddressRowIncludeList extends _i1.IncludeList {
  OrderAddressRowIncludeList._({
    _i1.WhereExpressionBuilder<OrderAddressRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderAddressRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderAddressRow.t;
}

class OrderAddressRowRepository {
  const OrderAddressRowRepository._();

  /// Returns a list of [OrderAddressRow]s matching the given query parameters.
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
  Future<List<OrderAddressRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderAddressRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderAddressRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderAddressRow>(
      where: where?.call(OrderAddressRow.t),
      orderBy: orderBy?.call(OrderAddressRow.t),
      orderByList: orderByList?.call(OrderAddressRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderAddressRow] matching the given query parameters.
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
  Future<OrderAddressRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderAddressRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderAddressRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderAddressRow>(
      where: where?.call(OrderAddressRow.t),
      orderBy: orderBy?.call(OrderAddressRow.t),
      orderByList: orderByList?.call(OrderAddressRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderAddressRow] by its [id] or null if no such row exists.
  Future<OrderAddressRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderAddressRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderAddressRow]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderAddressRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderAddressRow>> insert(
    _i1.DatabaseSession session,
    List<OrderAddressRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderAddressRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderAddressRow] and returns the inserted row.
  ///
  /// The returned [OrderAddressRow] will have its `id` field set.
  Future<OrderAddressRow> insertRow(
    _i1.DatabaseSession session,
    OrderAddressRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderAddressRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderAddressRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderAddressRow>> update(
    _i1.DatabaseSession session,
    List<OrderAddressRow> rows, {
    _i1.ColumnSelections<OrderAddressRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderAddressRow>(
      rows,
      columns: columns?.call(OrderAddressRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderAddressRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderAddressRow> updateRow(
    _i1.DatabaseSession session,
    OrderAddressRow row, {
    _i1.ColumnSelections<OrderAddressRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderAddressRow>(
      row,
      columns: columns?.call(OrderAddressRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderAddressRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderAddressRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<OrderAddressRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderAddressRow>(
      id,
      columnValues: columnValues(OrderAddressRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderAddressRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderAddressRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderAddressRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderAddressRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderAddressRowTable>? orderBy,
    _i1.OrderByListBuilder<OrderAddressRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderAddressRow>(
      columnValues: columnValues(OrderAddressRow.t.updateTable),
      where: where(OrderAddressRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderAddressRow.t),
      orderByList: orderByList?.call(OrderAddressRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderAddressRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderAddressRow>> delete(
    _i1.DatabaseSession session,
    List<OrderAddressRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderAddressRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderAddressRow].
  Future<OrderAddressRow> deleteRow(
    _i1.DatabaseSession session,
    OrderAddressRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderAddressRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderAddressRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderAddressRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderAddressRow>(
      where: where(OrderAddressRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderAddressRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderAddressRow>(
      where: where?.call(OrderAddressRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderAddressRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderAddressRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderAddressRow>(
      where: where(OrderAddressRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
