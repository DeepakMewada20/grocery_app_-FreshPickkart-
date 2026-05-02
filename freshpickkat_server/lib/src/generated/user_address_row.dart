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

abstract class UserAddressRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserAddressRow._({
    this.id,
    required this.userId,
    this.label,
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
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isDefault = isDefault ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UserAddressRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    String? label,
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
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserAddressRowImpl;

  factory UserAddressRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAddressRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      label: jsonSerialization['label'] as String?,
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
      isDefault: jsonSerialization['isDefault'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDefault']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserAddressRowTable();

  static const db = UserAddressRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String? label;

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

  bool isDefault;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserAddressRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAddressRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? label,
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
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAddressRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (label != null) 'label': label,
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
      'isDefault': isDefault,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UserAddressRowInclude include() {
    return UserAddressRowInclude._();
  }

  static UserAddressRowIncludeList includeList({
    _i1.WhereExpressionBuilder<UserAddressRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAddressRowTable>? orderByList,
    UserAddressRowInclude? include,
  }) {
    return UserAddressRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAddressRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserAddressRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAddressRowImpl extends UserAddressRow {
  _UserAddressRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    String? label,
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
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         label: label,
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
         isDefault: isDefault,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserAddressRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAddressRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? label = _Undefined,
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
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAddressRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      label: label is String? ? label : this.label,
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
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserAddressRowUpdateTable extends _i1.UpdateTable<UserAddressRowTable> {
  UserAddressRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> label(String? value) => _i1.ColumnValue(
    table.label,
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

  _i1.ColumnValue<bool, bool> isDefault(bool value) => _i1.ColumnValue(
    table.isDefault,
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

class UserAddressRowTable extends _i1.Table<_i1.UuidValue?> {
  UserAddressRowTable({super.tableRelation})
    : super(tableName: 'user_address') {
    updateTable = UserAddressRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    label = _i1.ColumnString(
      'label',
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
    isDefault = _i1.ColumnBool(
      'isDefault',
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

  late final UserAddressRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString label;

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

  late final _i1.ColumnBool isDefault;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    label,
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
    isDefault,
    createdAt,
    updatedAt,
  ];
}

class UserAddressRowInclude extends _i1.IncludeObject {
  UserAddressRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserAddressRow.t;
}

class UserAddressRowIncludeList extends _i1.IncludeList {
  UserAddressRowIncludeList._({
    _i1.WhereExpressionBuilder<UserAddressRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserAddressRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserAddressRow.t;
}

class UserAddressRowRepository {
  const UserAddressRowRepository._();

  /// Returns a list of [UserAddressRow]s matching the given query parameters.
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
  Future<List<UserAddressRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserAddressRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAddressRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserAddressRow>(
      where: where?.call(UserAddressRow.t),
      orderBy: orderBy?.call(UserAddressRow.t),
      orderByList: orderByList?.call(UserAddressRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserAddressRow] matching the given query parameters.
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
  Future<UserAddressRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserAddressRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserAddressRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAddressRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserAddressRow>(
      where: where?.call(UserAddressRow.t),
      orderBy: orderBy?.call(UserAddressRow.t),
      orderByList: orderByList?.call(UserAddressRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserAddressRow] by its [id] or null if no such row exists.
  Future<UserAddressRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserAddressRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserAddressRow]s in the list and returns the inserted rows.
  ///
  /// The returned [UserAddressRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserAddressRow>> insert(
    _i1.DatabaseSession session,
    List<UserAddressRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserAddressRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserAddressRow] and returns the inserted row.
  ///
  /// The returned [UserAddressRow] will have its `id` field set.
  Future<UserAddressRow> insertRow(
    _i1.DatabaseSession session,
    UserAddressRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserAddressRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserAddressRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserAddressRow>> update(
    _i1.DatabaseSession session,
    List<UserAddressRow> rows, {
    _i1.ColumnSelections<UserAddressRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserAddressRow>(
      rows,
      columns: columns?.call(UserAddressRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserAddressRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserAddressRow> updateRow(
    _i1.DatabaseSession session,
    UserAddressRow row, {
    _i1.ColumnSelections<UserAddressRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserAddressRow>(
      row,
      columns: columns?.call(UserAddressRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserAddressRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserAddressRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserAddressRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserAddressRow>(
      id,
      columnValues: columnValues(UserAddressRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserAddressRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserAddressRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserAddressRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserAddressRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAddressRowTable>? orderBy,
    _i1.OrderByListBuilder<UserAddressRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserAddressRow>(
      columnValues: columnValues(UserAddressRow.t.updateTable),
      where: where(UserAddressRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAddressRow.t),
      orderByList: orderByList?.call(UserAddressRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserAddressRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserAddressRow>> delete(
    _i1.DatabaseSession session,
    List<UserAddressRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserAddressRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserAddressRow].
  Future<UserAddressRow> deleteRow(
    _i1.DatabaseSession session,
    UserAddressRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserAddressRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserAddressRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserAddressRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserAddressRow>(
      where: where(UserAddressRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserAddressRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserAddressRow>(
      where: where?.call(UserAddressRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserAddressRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserAddressRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserAddressRow>(
      where: where(UserAddressRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
