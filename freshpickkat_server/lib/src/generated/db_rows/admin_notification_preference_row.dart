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

abstract class AdminNotificationPreferenceRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AdminNotificationPreferenceRow._({
    this.id,
    required this.adminUserId,
    required this.adminFirebaseUid,
    required this.preferenceKey,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : pushEnabled = pushEnabled ?? true,
       soundEnabled = soundEnabled ?? true,
       critical = critical ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AdminNotificationPreferenceRow({
    _i1.UuidValue? id,
    required _i1.UuidValue adminUserId,
    required String adminFirebaseUid,
    required String preferenceKey,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminNotificationPreferenceRowImpl;

  factory AdminNotificationPreferenceRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminNotificationPreferenceRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      adminUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['adminUserId'],
      ),
      adminFirebaseUid: jsonSerialization['adminFirebaseUid'] as String,
      preferenceKey: jsonSerialization['preferenceKey'] as String,
      pushEnabled: jsonSerialization['pushEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['pushEnabled']),
      soundEnabled: jsonSerialization['soundEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['soundEnabled']),
      critical: jsonSerialization['critical'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['critical']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AdminNotificationPreferenceRowTable();

  static const db = AdminNotificationPreferenceRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue adminUserId;

  String adminFirebaseUid;

  String preferenceKey;

  bool pushEnabled;

  bool soundEnabled;

  bool critical;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AdminNotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminNotificationPreferenceRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? adminUserId,
    String? adminFirebaseUid,
    String? preferenceKey,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminNotificationPreferenceRow',
      if (id != null) 'id': id?.toJson(),
      'adminUserId': adminUserId.toJson(),
      'adminFirebaseUid': adminFirebaseUid,
      'preferenceKey': preferenceKey,
      'pushEnabled': pushEnabled,
      'soundEnabled': soundEnabled,
      'critical': critical,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AdminNotificationPreferenceRowInclude include() {
    return AdminNotificationPreferenceRowInclude._();
  }

  static AdminNotificationPreferenceRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminNotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminNotificationPreferenceRowTable>? orderByList,
    AdminNotificationPreferenceRowInclude? include,
  }) {
    return AdminNotificationPreferenceRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminNotificationPreferenceRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AdminNotificationPreferenceRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminNotificationPreferenceRowImpl
    extends AdminNotificationPreferenceRow {
  _AdminNotificationPreferenceRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue adminUserId,
    required String adminFirebaseUid,
    required String preferenceKey,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         adminUserId: adminUserId,
         adminFirebaseUid: adminFirebaseUid,
         preferenceKey: preferenceKey,
         pushEnabled: pushEnabled,
         soundEnabled: soundEnabled,
         critical: critical,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AdminNotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminNotificationPreferenceRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? adminUserId,
    String? adminFirebaseUid,
    String? preferenceKey,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminNotificationPreferenceRow(
      id: id is _i1.UuidValue? ? id : this.id,
      adminUserId: adminUserId ?? this.adminUserId,
      adminFirebaseUid: adminFirebaseUid ?? this.adminFirebaseUid,
      preferenceKey: preferenceKey ?? this.preferenceKey,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      critical: critical ?? this.critical,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdminNotificationPreferenceRowUpdateTable
    extends _i1.UpdateTable<AdminNotificationPreferenceRowTable> {
  AdminNotificationPreferenceRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> adminUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.adminUserId,
    value,
  );

  _i1.ColumnValue<String, String> adminFirebaseUid(String value) =>
      _i1.ColumnValue(
        table.adminFirebaseUid,
        value,
      );

  _i1.ColumnValue<String, String> preferenceKey(String value) =>
      _i1.ColumnValue(
        table.preferenceKey,
        value,
      );

  _i1.ColumnValue<bool, bool> pushEnabled(bool value) => _i1.ColumnValue(
    table.pushEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> soundEnabled(bool value) => _i1.ColumnValue(
    table.soundEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> critical(bool value) => _i1.ColumnValue(
    table.critical,
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

class AdminNotificationPreferenceRowTable extends _i1.Table<_i1.UuidValue?> {
  AdminNotificationPreferenceRowTable({super.tableRelation})
    : super(tableName: 'admin_notification_preference') {
    updateTable = AdminNotificationPreferenceRowUpdateTable(this);
    adminUserId = _i1.ColumnUuid(
      'adminUserId',
      this,
    );
    adminFirebaseUid = _i1.ColumnString(
      'adminFirebaseUid',
      this,
    );
    preferenceKey = _i1.ColumnString(
      'preferenceKey',
      this,
    );
    pushEnabled = _i1.ColumnBool(
      'pushEnabled',
      this,
      hasDefault: true,
    );
    soundEnabled = _i1.ColumnBool(
      'soundEnabled',
      this,
      hasDefault: true,
    );
    critical = _i1.ColumnBool(
      'critical',
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

  late final AdminNotificationPreferenceRowUpdateTable updateTable;

  late final _i1.ColumnUuid adminUserId;

  late final _i1.ColumnString adminFirebaseUid;

  late final _i1.ColumnString preferenceKey;

  late final _i1.ColumnBool pushEnabled;

  late final _i1.ColumnBool soundEnabled;

  late final _i1.ColumnBool critical;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    adminUserId,
    adminFirebaseUid,
    preferenceKey,
    pushEnabled,
    soundEnabled,
    critical,
    createdAt,
    updatedAt,
  ];
}

class AdminNotificationPreferenceRowInclude extends _i1.IncludeObject {
  AdminNotificationPreferenceRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminNotificationPreferenceRow.t;
}

class AdminNotificationPreferenceRowIncludeList extends _i1.IncludeList {
  AdminNotificationPreferenceRowIncludeList._({
    _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminNotificationPreferenceRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminNotificationPreferenceRow.t;
}

class AdminNotificationPreferenceRowRepository {
  const AdminNotificationPreferenceRowRepository._();

  /// Returns a list of [AdminNotificationPreferenceRow]s matching the given query parameters.
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
  Future<List<AdminNotificationPreferenceRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminNotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminNotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminNotificationPreferenceRow>(
      where: where?.call(AdminNotificationPreferenceRow.t),
      orderBy: orderBy?.call(AdminNotificationPreferenceRow.t),
      orderByList: orderByList?.call(AdminNotificationPreferenceRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AdminNotificationPreferenceRow] matching the given query parameters.
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
  Future<AdminNotificationPreferenceRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AdminNotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminNotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminNotificationPreferenceRow>(
      where: where?.call(AdminNotificationPreferenceRow.t),
      orderBy: orderBy?.call(AdminNotificationPreferenceRow.t),
      orderByList: orderByList?.call(AdminNotificationPreferenceRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminNotificationPreferenceRow] by its [id] or null if no such row exists.
  Future<AdminNotificationPreferenceRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminNotificationPreferenceRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminNotificationPreferenceRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminNotificationPreferenceRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AdminNotificationPreferenceRow>> insert(
    _i1.DatabaseSession session,
    List<AdminNotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AdminNotificationPreferenceRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AdminNotificationPreferenceRow] and returns the inserted row.
  ///
  /// The returned [AdminNotificationPreferenceRow] will have its `id` field set.
  Future<AdminNotificationPreferenceRow> insertRow(
    _i1.DatabaseSession session,
    AdminNotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminNotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AdminNotificationPreferenceRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AdminNotificationPreferenceRow>> update(
    _i1.DatabaseSession session,
    List<AdminNotificationPreferenceRow> rows, {
    _i1.ColumnSelections<AdminNotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AdminNotificationPreferenceRow>(
      rows,
      columns: columns?.call(AdminNotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminNotificationPreferenceRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminNotificationPreferenceRow> updateRow(
    _i1.DatabaseSession session,
    AdminNotificationPreferenceRow row, {
    _i1.ColumnSelections<AdminNotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminNotificationPreferenceRow>(
      row,
      columns: columns?.call(AdminNotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminNotificationPreferenceRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminNotificationPreferenceRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<
      AdminNotificationPreferenceRowUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminNotificationPreferenceRow>(
      id,
      columnValues: columnValues(AdminNotificationPreferenceRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminNotificationPreferenceRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AdminNotificationPreferenceRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      AdminNotificationPreferenceRowUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminNotificationPreferenceRowTable>? orderBy,
    _i1.OrderByListBuilder<AdminNotificationPreferenceRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AdminNotificationPreferenceRow>(
      columnValues: columnValues(AdminNotificationPreferenceRow.t.updateTable),
      where: where(AdminNotificationPreferenceRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminNotificationPreferenceRow.t),
      orderByList: orderByList?.call(AdminNotificationPreferenceRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AdminNotificationPreferenceRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AdminNotificationPreferenceRow>> delete(
    _i1.DatabaseSession session,
    List<AdminNotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AdminNotificationPreferenceRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AdminNotificationPreferenceRow].
  Future<AdminNotificationPreferenceRow> deleteRow(
    _i1.DatabaseSession session,
    AdminNotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminNotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AdminNotificationPreferenceRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AdminNotificationPreferenceRow>(
      where: where(AdminNotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AdminNotificationPreferenceRow>(
      where: where?.call(AdminNotificationPreferenceRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminNotificationPreferenceRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminNotificationPreferenceRowTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminNotificationPreferenceRow>(
      where: where(AdminNotificationPreferenceRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
