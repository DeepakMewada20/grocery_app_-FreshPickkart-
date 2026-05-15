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

abstract class UserFcmTokenRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserFcmTokenRow._({
    this.id,
    required this.userId,
    required this.firebaseUid,
    required this.fcmToken,
    required this.deviceId,
    required this.platform,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UserFcmTokenRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String firebaseUid,
    required String fcmToken,
    required String deviceId,
    required String platform,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserFcmTokenRowImpl;

  factory UserFcmTokenRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFcmTokenRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      fcmToken: jsonSerialization['fcmToken'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      platform: jsonSerialization['platform'] as String,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserFcmTokenRowTable();

  static const db = UserFcmTokenRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String firebaseUid;

  String fcmToken;

  String deviceId;

  String platform;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserFcmTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserFcmTokenRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? firebaseUid,
    String? fcmToken,
    String? deviceId,
    String? platform,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserFcmTokenRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'firebaseUid': firebaseUid,
      'fcmToken': fcmToken,
      'deviceId': deviceId,
      'platform': platform,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UserFcmTokenRowInclude include() {
    return UserFcmTokenRowInclude._();
  }

  static UserFcmTokenRowIncludeList includeList({
    _i1.WhereExpressionBuilder<UserFcmTokenRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFcmTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFcmTokenRowTable>? orderByList,
    UserFcmTokenRowInclude? include,
  }) {
    return UserFcmTokenRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFcmTokenRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserFcmTokenRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFcmTokenRowImpl extends UserFcmTokenRow {
  _UserFcmTokenRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String firebaseUid,
    required String fcmToken,
    required String deviceId,
    required String platform,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         firebaseUid: firebaseUid,
         fcmToken: fcmToken,
         deviceId: deviceId,
         platform: platform,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserFcmTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserFcmTokenRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? firebaseUid,
    String? fcmToken,
    String? deviceId,
    String? platform,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserFcmTokenRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      fcmToken: fcmToken ?? this.fcmToken,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserFcmTokenRowUpdateTable extends _i1.UpdateTable<UserFcmTokenRowTable> {
  UserFcmTokenRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> firebaseUid(String value) => _i1.ColumnValue(
    table.firebaseUid,
    value,
  );

  _i1.ColumnValue<String, String> fcmToken(String value) => _i1.ColumnValue(
    table.fcmToken,
    value,
  );

  _i1.ColumnValue<String, String> deviceId(String value) => _i1.ColumnValue(
    table.deviceId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
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

class UserFcmTokenRowTable extends _i1.Table<_i1.UuidValue?> {
  UserFcmTokenRowTable({super.tableRelation})
    : super(tableName: 'user_fcm_token') {
    updateTable = UserFcmTokenRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    firebaseUid = _i1.ColumnString(
      'firebaseUid',
      this,
    );
    fcmToken = _i1.ColumnString(
      'fcmToken',
      this,
    );
    deviceId = _i1.ColumnString(
      'deviceId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
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

  late final UserFcmTokenRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString firebaseUid;

  late final _i1.ColumnString fcmToken;

  late final _i1.ColumnString deviceId;

  late final _i1.ColumnString platform;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    firebaseUid,
    fcmToken,
    deviceId,
    platform,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class UserFcmTokenRowInclude extends _i1.IncludeObject {
  UserFcmTokenRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserFcmTokenRow.t;
}

class UserFcmTokenRowIncludeList extends _i1.IncludeList {
  UserFcmTokenRowIncludeList._({
    _i1.WhereExpressionBuilder<UserFcmTokenRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserFcmTokenRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserFcmTokenRow.t;
}

class UserFcmTokenRowRepository {
  const UserFcmTokenRowRepository._();

  /// Returns a list of [UserFcmTokenRow]s matching the given query parameters.
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
  Future<List<UserFcmTokenRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserFcmTokenRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFcmTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFcmTokenRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserFcmTokenRow>(
      where: where?.call(UserFcmTokenRow.t),
      orderBy: orderBy?.call(UserFcmTokenRow.t),
      orderByList: orderByList?.call(UserFcmTokenRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserFcmTokenRow] matching the given query parameters.
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
  Future<UserFcmTokenRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserFcmTokenRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserFcmTokenRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFcmTokenRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserFcmTokenRow>(
      where: where?.call(UserFcmTokenRow.t),
      orderBy: orderBy?.call(UserFcmTokenRow.t),
      orderByList: orderByList?.call(UserFcmTokenRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserFcmTokenRow] by its [id] or null if no such row exists.
  Future<UserFcmTokenRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserFcmTokenRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserFcmTokenRow]s in the list and returns the inserted rows.
  ///
  /// The returned [UserFcmTokenRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserFcmTokenRow>> insert(
    _i1.DatabaseSession session,
    List<UserFcmTokenRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserFcmTokenRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserFcmTokenRow] and returns the inserted row.
  ///
  /// The returned [UserFcmTokenRow] will have its `id` field set.
  Future<UserFcmTokenRow> insertRow(
    _i1.DatabaseSession session,
    UserFcmTokenRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserFcmTokenRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserFcmTokenRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserFcmTokenRow>> update(
    _i1.DatabaseSession session,
    List<UserFcmTokenRow> rows, {
    _i1.ColumnSelections<UserFcmTokenRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserFcmTokenRow>(
      rows,
      columns: columns?.call(UserFcmTokenRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFcmTokenRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserFcmTokenRow> updateRow(
    _i1.DatabaseSession session,
    UserFcmTokenRow row, {
    _i1.ColumnSelections<UserFcmTokenRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserFcmTokenRow>(
      row,
      columns: columns?.call(UserFcmTokenRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFcmTokenRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserFcmTokenRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserFcmTokenRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserFcmTokenRow>(
      id,
      columnValues: columnValues(UserFcmTokenRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserFcmTokenRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserFcmTokenRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserFcmTokenRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserFcmTokenRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFcmTokenRowTable>? orderBy,
    _i1.OrderByListBuilder<UserFcmTokenRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserFcmTokenRow>(
      columnValues: columnValues(UserFcmTokenRow.t.updateTable),
      where: where(UserFcmTokenRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFcmTokenRow.t),
      orderByList: orderByList?.call(UserFcmTokenRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserFcmTokenRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserFcmTokenRow>> delete(
    _i1.DatabaseSession session,
    List<UserFcmTokenRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserFcmTokenRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserFcmTokenRow].
  Future<UserFcmTokenRow> deleteRow(
    _i1.DatabaseSession session,
    UserFcmTokenRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserFcmTokenRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserFcmTokenRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserFcmTokenRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserFcmTokenRow>(
      where: where(UserFcmTokenRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserFcmTokenRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserFcmTokenRow>(
      where: where?.call(UserFcmTokenRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserFcmTokenRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserFcmTokenRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserFcmTokenRow>(
      where: where(UserFcmTokenRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
