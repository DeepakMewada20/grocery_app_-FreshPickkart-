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

abstract class NotificationUserStateRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  NotificationUserStateRow._({
    this.id,
    required this.campaignId,
    required this.userId,
    bool? isRead,
    bool? isDeleted,
    this.readAt,
    this.deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isRead = isRead ?? false,
       isDeleted = isDeleted ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationUserStateRow({
    _i1.UuidValue? id,
    required _i1.UuidValue campaignId,
    required _i1.UuidValue userId,
    bool? isRead,
    bool? isDeleted,
    DateTime? readAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationUserStateRowImpl;

  factory NotificationUserStateRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationUserStateRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      campaignId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['campaignId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotificationUserStateRowTable();

  static const db = NotificationUserStateRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue campaignId;

  _i1.UuidValue userId;

  bool isRead;

  bool isDeleted;

  DateTime? readAt;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotificationUserStateRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationUserStateRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? campaignId,
    _i1.UuidValue? userId,
    bool? isRead,
    bool? isDeleted,
    DateTime? readAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationUserStateRow',
      if (id != null) 'id': id?.toJson(),
      'campaignId': campaignId.toJson(),
      'userId': userId.toJson(),
      'isRead': isRead,
      'isDeleted': isDeleted,
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotificationUserStateRowInclude include() {
    return NotificationUserStateRowInclude._();
  }

  static NotificationUserStateRowIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationUserStateRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationUserStateRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationUserStateRowTable>? orderByList,
    NotificationUserStateRowInclude? include,
  }) {
    return NotificationUserStateRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationUserStateRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationUserStateRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationUserStateRowImpl extends NotificationUserStateRow {
  _NotificationUserStateRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue campaignId,
    required _i1.UuidValue userId,
    bool? isRead,
    bool? isDeleted,
    DateTime? readAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         campaignId: campaignId,
         userId: userId,
         isRead: isRead,
         isDeleted: isDeleted,
         readAt: readAt,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationUserStateRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationUserStateRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? campaignId,
    _i1.UuidValue? userId,
    bool? isRead,
    bool? isDeleted,
    Object? readAt = _Undefined,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationUserStateRow(
      id: id is _i1.UuidValue? ? id : this.id,
      campaignId: campaignId ?? this.campaignId,
      userId: userId ?? this.userId,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationUserStateRowUpdateTable
    extends _i1.UpdateTable<NotificationUserStateRowTable> {
  NotificationUserStateRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> campaignId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.campaignId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<bool, bool> isDeleted(bool value) => _i1.ColumnValue(
    table.isDeleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _i1.ColumnValue(
        table.readAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
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

class NotificationUserStateRowTable extends _i1.Table<_i1.UuidValue?> {
  NotificationUserStateRowTable({super.tableRelation})
    : super(tableName: 'notification_user_state') {
    updateTable = NotificationUserStateRowUpdateTable(this);
    campaignId = _i1.ColumnUuid(
      'campaignId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
      hasDefault: true,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
      hasDefault: true,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
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

  late final NotificationUserStateRowUpdateTable updateTable;

  late final _i1.ColumnUuid campaignId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime readAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    campaignId,
    userId,
    isRead,
    isDeleted,
    readAt,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class NotificationUserStateRowInclude extends _i1.IncludeObject {
  NotificationUserStateRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationUserStateRow.t;
}

class NotificationUserStateRowIncludeList extends _i1.IncludeList {
  NotificationUserStateRowIncludeList._({
    _i1.WhereExpressionBuilder<NotificationUserStateRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationUserStateRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationUserStateRow.t;
}

class NotificationUserStateRowRepository {
  const NotificationUserStateRowRepository._();

  /// Returns a list of [NotificationUserStateRow]s matching the given query parameters.
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
  Future<List<NotificationUserStateRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationUserStateRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationUserStateRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationUserStateRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationUserStateRow>(
      where: where?.call(NotificationUserStateRow.t),
      orderBy: orderBy?.call(NotificationUserStateRow.t),
      orderByList: orderByList?.call(NotificationUserStateRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationUserStateRow] matching the given query parameters.
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
  Future<NotificationUserStateRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationUserStateRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationUserStateRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationUserStateRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationUserStateRow>(
      where: where?.call(NotificationUserStateRow.t),
      orderBy: orderBy?.call(NotificationUserStateRow.t),
      orderByList: orderByList?.call(NotificationUserStateRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationUserStateRow] by its [id] or null if no such row exists.
  Future<NotificationUserStateRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationUserStateRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationUserStateRow]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationUserStateRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationUserStateRow>> insert(
    _i1.DatabaseSession session,
    List<NotificationUserStateRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationUserStateRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationUserStateRow] and returns the inserted row.
  ///
  /// The returned [NotificationUserStateRow] will have its `id` field set.
  Future<NotificationUserStateRow> insertRow(
    _i1.DatabaseSession session,
    NotificationUserStateRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationUserStateRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationUserStateRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationUserStateRow>> update(
    _i1.DatabaseSession session,
    List<NotificationUserStateRow> rows, {
    _i1.ColumnSelections<NotificationUserStateRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationUserStateRow>(
      rows,
      columns: columns?.call(NotificationUserStateRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationUserStateRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationUserStateRow> updateRow(
    _i1.DatabaseSession session,
    NotificationUserStateRow row, {
    _i1.ColumnSelections<NotificationUserStateRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationUserStateRow>(
      row,
      columns: columns?.call(NotificationUserStateRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationUserStateRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationUserStateRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<NotificationUserStateRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationUserStateRow>(
      id,
      columnValues: columnValues(NotificationUserStateRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationUserStateRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationUserStateRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NotificationUserStateRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationUserStateRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationUserStateRowTable>? orderBy,
    _i1.OrderByListBuilder<NotificationUserStateRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationUserStateRow>(
      columnValues: columnValues(NotificationUserStateRow.t.updateTable),
      where: where(NotificationUserStateRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationUserStateRow.t),
      orderByList: orderByList?.call(NotificationUserStateRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationUserStateRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationUserStateRow>> delete(
    _i1.DatabaseSession session,
    List<NotificationUserStateRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationUserStateRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationUserStateRow].
  Future<NotificationUserStateRow> deleteRow(
    _i1.DatabaseSession session,
    NotificationUserStateRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationUserStateRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationUserStateRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationUserStateRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationUserStateRow>(
      where: where(NotificationUserStateRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationUserStateRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationUserStateRow>(
      where: where?.call(NotificationUserStateRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationUserStateRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationUserStateRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationUserStateRow>(
      where: where(NotificationUserStateRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
