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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

abstract class AdminAuditLogRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AdminAuditLogRow._({
    this.id,
    this.actorUserId,
    required this.action,
    required this.entityType,
    this.entityId,
    this.metadata,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AdminAuditLogRow({
    _i1.UuidValue? id,
    _i1.UuidValue? actorUserId,
    required String action,
    required String entityType,
    _i1.UuidValue? entityId,
    Map<String, String>? metadata,
    DateTime? createdAt,
  }) = _AdminAuditLogRowImpl;

  factory AdminAuditLogRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLogRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actorUserId: jsonSerialization['actorUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['actorUserId'],
            ),
      action: jsonSerialization['action'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['entityId']),
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AdminAuditLogRowTable();

  static const db = AdminAuditLogRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue? actorUserId;

  String action;

  String entityType;

  _i1.UuidValue? entityId;

  Map<String, String>? metadata;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AdminAuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLogRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? actorUserId,
    String? action,
    String? entityType,
    _i1.UuidValue? entityId,
    Map<String, String>? metadata,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLogRow',
      if (id != null) 'id': id?.toJson(),
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      'action': action,
      'entityType': entityType,
      if (entityId != null) 'entityId': entityId?.toJson(),
      if (metadata != null) 'metadata': metadata?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AdminAuditLogRowInclude include() {
    return AdminAuditLogRowInclude._();
  }

  static AdminAuditLogRowIncludeList includeList({
    _i1.WhereExpressionBuilder<AdminAuditLogRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRowTable>? orderByList,
    AdminAuditLogRowInclude? include,
  }) {
    return AdminAuditLogRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLogRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AdminAuditLogRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogRowImpl extends AdminAuditLogRow {
  _AdminAuditLogRowImpl({
    _i1.UuidValue? id,
    _i1.UuidValue? actorUserId,
    required String action,
    required String entityType,
    _i1.UuidValue? entityId,
    Map<String, String>? metadata,
    DateTime? createdAt,
  }) : super._(
         id: id,
         actorUserId: actorUserId,
         action: action,
         entityType: entityType,
         entityId: entityId,
         metadata: metadata,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLogRow copyWith({
    Object? id = _Undefined,
    Object? actorUserId = _Undefined,
    String? action,
    String? entityType,
    Object? entityId = _Undefined,
    Object? metadata = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminAuditLogRow(
      id: id is _i1.UuidValue? ? id : this.id,
      actorUserId: actorUserId is _i1.UuidValue?
          ? actorUserId
          : this.actorUserId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId is _i1.UuidValue? ? entityId : this.entityId,
      metadata: metadata is Map<String, String>?
          ? metadata
          : this.metadata?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminAuditLogRowUpdateTable
    extends _i1.UpdateTable<AdminAuditLogRowTable> {
  AdminAuditLogRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> actorUserId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.actorUserId,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<String, String> entityType(String value) => _i1.ColumnValue(
    table.entityType,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> entityId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.entityId,
    value,
  );

  _i1.ColumnValue<Map<String, String>, Map<String, String>> metadata(
    Map<String, String>? value,
  ) => _i1.ColumnValue(
    table.metadata,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminAuditLogRowTable extends _i1.Table<_i1.UuidValue?> {
  AdminAuditLogRowTable({super.tableRelation})
    : super(tableName: 'admin_audit_log') {
    updateTable = AdminAuditLogRowUpdateTable(this);
    actorUserId = _i1.ColumnUuid(
      'actorUserId',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    entityType = _i1.ColumnString(
      'entityType',
      this,
    );
    entityId = _i1.ColumnUuid(
      'entityId',
      this,
    );
    metadata = _i1.ColumnSerializable<Map<String, String>>(
      'metadata',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AdminAuditLogRowUpdateTable updateTable;

  late final _i1.ColumnUuid actorUserId;

  late final _i1.ColumnString action;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnUuid entityId;

  late final _i1.ColumnSerializable<Map<String, String>> metadata;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    actorUserId,
    action,
    entityType,
    entityId,
    metadata,
    createdAt,
  ];
}

class AdminAuditLogRowInclude extends _i1.IncludeObject {
  AdminAuditLogRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminAuditLogRow.t;
}

class AdminAuditLogRowIncludeList extends _i1.IncludeList {
  AdminAuditLogRowIncludeList._({
    _i1.WhereExpressionBuilder<AdminAuditLogRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminAuditLogRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminAuditLogRow.t;
}

class AdminAuditLogRowRepository {
  const AdminAuditLogRowRepository._();

  /// Returns a list of [AdminAuditLogRow]s matching the given query parameters.
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
  Future<List<AdminAuditLogRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminAuditLogRow>(
      where: where?.call(AdminAuditLogRow.t),
      orderBy: orderBy?.call(AdminAuditLogRow.t),
      orderByList: orderByList?.call(AdminAuditLogRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AdminAuditLogRow] matching the given query parameters.
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
  Future<AdminAuditLogRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminAuditLogRow>(
      where: where?.call(AdminAuditLogRow.t),
      orderBy: orderBy?.call(AdminAuditLogRow.t),
      orderByList: orderByList?.call(AdminAuditLogRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminAuditLogRow] by its [id] or null if no such row exists.
  Future<AdminAuditLogRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminAuditLogRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminAuditLogRow]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminAuditLogRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AdminAuditLogRow>> insert(
    _i1.DatabaseSession session,
    List<AdminAuditLogRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AdminAuditLogRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AdminAuditLogRow] and returns the inserted row.
  ///
  /// The returned [AdminAuditLogRow] will have its `id` field set.
  Future<AdminAuditLogRow> insertRow(
    _i1.DatabaseSession session,
    AdminAuditLogRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminAuditLogRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLogRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AdminAuditLogRow>> update(
    _i1.DatabaseSession session,
    List<AdminAuditLogRow> rows, {
    _i1.ColumnSelections<AdminAuditLogRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AdminAuditLogRow>(
      rows,
      columns: columns?.call(AdminAuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLogRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminAuditLogRow> updateRow(
    _i1.DatabaseSession session,
    AdminAuditLogRow row, {
    _i1.ColumnSelections<AdminAuditLogRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminAuditLogRow>(
      row,
      columns: columns?.call(AdminAuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLogRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminAuditLogRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AdminAuditLogRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminAuditLogRow>(
      id,
      columnValues: columnValues(AdminAuditLogRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLogRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AdminAuditLogRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AdminAuditLogRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AdminAuditLogRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRowTable>? orderBy,
    _i1.OrderByListBuilder<AdminAuditLogRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AdminAuditLogRow>(
      columnValues: columnValues(AdminAuditLogRow.t.updateTable),
      where: where(AdminAuditLogRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLogRow.t),
      orderByList: orderByList?.call(AdminAuditLogRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AdminAuditLogRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AdminAuditLogRow>> delete(
    _i1.DatabaseSession session,
    List<AdminAuditLogRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AdminAuditLogRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AdminAuditLogRow].
  Future<AdminAuditLogRow> deleteRow(
    _i1.DatabaseSession session,
    AdminAuditLogRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminAuditLogRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AdminAuditLogRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AdminAuditLogRow>(
      where: where(AdminAuditLogRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AdminAuditLogRow>(
      where: where?.call(AdminAuditLogRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminAuditLogRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminAuditLogRow>(
      where: where(AdminAuditLogRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
