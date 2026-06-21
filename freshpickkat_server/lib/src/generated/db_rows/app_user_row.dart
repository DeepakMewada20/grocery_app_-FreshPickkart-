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

abstract class AppUserRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AppUserRow._({
    this.id,
    this.firebaseUid,
    required this.phoneNumber,
    this.name,
    this.email,
    String? role,
    this.fcmToken,
    String? status,
    this.deactivatedAt,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : role = role ?? 'customer',
       status = status ?? 'active',
       currentFreshPoints = currentFreshPoints ?? 0,
       totalEarned = totalEarned ?? 0,
       totalRedeemed = totalRedeemed ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AppUserRow({
    _i1.UuidValue? id,
    String? firebaseUid,
    required String phoneNumber,
    String? name,
    String? email,
    String? role,
    String? fcmToken,
    String? status,
    DateTime? deactivatedAt,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUserRowImpl;

  factory AppUserRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      firebaseUid: jsonSerialization['firebaseUid'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      name: jsonSerialization['name'] as String?,
      email: jsonSerialization['email'] as String?,
      role: jsonSerialization['role'] as String?,
      fcmToken: jsonSerialization['fcmToken'] as String?,
      status: jsonSerialization['status'] as String?,
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deactivatedAt'],
            ),
      currentFreshPoints: jsonSerialization['currentFreshPoints'] as int?,
      totalEarned: jsonSerialization['totalEarned'] as int?,
      totalRedeemed: jsonSerialization['totalRedeemed'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AppUserRowTable();

  static const db = AppUserRowRepository._();

  @override
  _i1.UuidValue? id;

  String? firebaseUid;

  String phoneNumber;

  String? name;

  String? email;

  String role;

  String? fcmToken;

  String status;

  DateTime? deactivatedAt;

  int currentFreshPoints;

  int totalEarned;

  int totalRedeemed;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AppUserRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUserRow copyWith({
    _i1.UuidValue? id,
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    String? email,
    String? role,
    String? fcmToken,
    String? status,
    DateTime? deactivatedAt,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserRow',
      if (id != null) 'id': id?.toJson(),
      if (firebaseUid != null) 'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      'role': role,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'currentFreshPoints': currentFreshPoints,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AppUserRowInclude include() {
    return AppUserRowInclude._();
  }

  static AppUserRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AppUserRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserRowTable>? orderByList,
    AppUserRowInclude? include,
  }) {
    return AppUserRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppUserRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserRowImpl extends AppUserRow {
  _AppUserRowImpl({
    _i1.UuidValue? id,
    String? firebaseUid,
    required String phoneNumber,
    String? name,
    String? email,
    String? role,
    String? fcmToken,
    String? status,
    DateTime? deactivatedAt,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         firebaseUid: firebaseUid,
         phoneNumber: phoneNumber,
         name: name,
         email: email,
         role: role,
         fcmToken: fcmToken,
         status: status,
         deactivatedAt: deactivatedAt,
         currentFreshPoints: currentFreshPoints,
         totalEarned: totalEarned,
         totalRedeemed: totalRedeemed,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppUserRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUserRow copyWith({
    Object? id = _Undefined,
    Object? firebaseUid = _Undefined,
    String? phoneNumber,
    Object? name = _Undefined,
    Object? email = _Undefined,
    String? role,
    Object? fcmToken = _Undefined,
    String? status,
    Object? deactivatedAt = _Undefined,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserRow(
      id: id is _i1.UuidValue? ? id : this.id,
      firebaseUid: firebaseUid is String? ? firebaseUid : this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name is String? ? name : this.name,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      fcmToken: fcmToken is String? ? fcmToken : this.fcmToken,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      currentFreshPoints: currentFreshPoints ?? this.currentFreshPoints,
      totalEarned: totalEarned ?? this.totalEarned,
      totalRedeemed: totalRedeemed ?? this.totalRedeemed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AppUserRowUpdateTable extends _i1.UpdateTable<AppUserRowTable> {
  AppUserRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> firebaseUid(String? value) => _i1.ColumnValue(
    table.firebaseUid,
    value,
  );

  _i1.ColumnValue<String, String> phoneNumber(String value) => _i1.ColumnValue(
    table.phoneNumber,
    value,
  );

  _i1.ColumnValue<String, String> name(String? value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<String, String> fcmToken(String? value) => _i1.ColumnValue(
    table.fcmToken,
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

  _i1.ColumnValue<int, int> currentFreshPoints(int value) => _i1.ColumnValue(
    table.currentFreshPoints,
    value,
  );

  _i1.ColumnValue<int, int> totalEarned(int value) => _i1.ColumnValue(
    table.totalEarned,
    value,
  );

  _i1.ColumnValue<int, int> totalRedeemed(int value) => _i1.ColumnValue(
    table.totalRedeemed,
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

class AppUserRowTable extends _i1.Table<_i1.UuidValue?> {
  AppUserRowTable({super.tableRelation}) : super(tableName: 'app_user') {
    updateTable = AppUserRowUpdateTable(this);
    firebaseUid = _i1.ColumnString(
      'firebaseUid',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
      hasDefault: true,
    );
    fcmToken = _i1.ColumnString(
      'fcmToken',
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
    currentFreshPoints = _i1.ColumnInt(
      'currentFreshPoints',
      this,
      hasDefault: true,
    );
    totalEarned = _i1.ColumnInt(
      'totalEarned',
      this,
      hasDefault: true,
    );
    totalRedeemed = _i1.ColumnInt(
      'totalRedeemed',
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

  late final AppUserRowUpdateTable updateTable;

  late final _i1.ColumnString firebaseUid;

  late final _i1.ColumnString phoneNumber;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString role;

  late final _i1.ColumnString fcmToken;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnInt currentFreshPoints;

  late final _i1.ColumnInt totalEarned;

  late final _i1.ColumnInt totalRedeemed;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    firebaseUid,
    phoneNumber,
    name,
    email,
    role,
    fcmToken,
    status,
    deactivatedAt,
    currentFreshPoints,
    totalEarned,
    totalRedeemed,
    createdAt,
    updatedAt,
  ];
}

class AppUserRowInclude extends _i1.IncludeObject {
  AppUserRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserRow.t;
}

class AppUserRowIncludeList extends _i1.IncludeList {
  AppUserRowIncludeList._({
    _i1.WhereExpressionBuilder<AppUserRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUserRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserRow.t;
}

class AppUserRowRepository {
  const AppUserRowRepository._();

  /// Returns a list of [AppUserRow]s matching the given query parameters.
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
  Future<List<AppUserRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppUserRow>(
      where: where?.call(AppUserRow.t),
      orderBy: orderBy?.call(AppUserRow.t),
      orderByList: orderByList?.call(AppUserRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppUserRow] matching the given query parameters.
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
  Future<AppUserRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppUserRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppUserRow>(
      where: where?.call(AppUserRow.t),
      orderBy: orderBy?.call(AppUserRow.t),
      orderByList: orderByList?.call(AppUserRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppUserRow] by its [id] or null if no such row exists.
  Future<AppUserRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppUserRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppUserRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUserRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AppUserRow>> insert(
    _i1.DatabaseSession session,
    List<AppUserRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AppUserRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AppUserRow] and returns the inserted row.
  ///
  /// The returned [AppUserRow] will have its `id` field set.
  Future<AppUserRow> insertRow(
    _i1.DatabaseSession session,
    AppUserRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUserRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppUserRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppUserRow>> update(
    _i1.DatabaseSession session,
    List<AppUserRow> rows, {
    _i1.ColumnSelections<AppUserRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppUserRow>(
      rows,
      columns: columns?.call(AppUserRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUserRow> updateRow(
    _i1.DatabaseSession session,
    AppUserRow row, {
    _i1.ColumnSelections<AppUserRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUserRow>(
      row,
      columns: columns?.call(AppUserRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUserRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AppUserRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUserRow>(
      id,
      columnValues: columnValues(AppUserRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUserRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppUserRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppUserRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppUserRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserRowTable>? orderBy,
    _i1.OrderByListBuilder<AppUserRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppUserRow>(
      columnValues: columnValues(AppUserRow.t.updateTable),
      where: where(AppUserRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserRow.t),
      orderByList: orderByList?.call(AppUserRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppUserRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppUserRow>> delete(
    _i1.DatabaseSession session,
    List<AppUserRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppUserRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppUserRow].
  Future<AppUserRow> deleteRow(
    _i1.DatabaseSession session,
    AppUserRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUserRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppUserRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppUserRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppUserRow>(
      where: where(AppUserRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppUserRow>(
      where: where?.call(AppUserRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppUserRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppUserRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppUserRow>(
      where: where(AppUserRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
