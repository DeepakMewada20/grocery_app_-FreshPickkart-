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

abstract class NotificationOutboxRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  NotificationOutboxRow._({
    this.id,
    required this.dedupeKey,
    required this.campaignId,
    required this.payloadJson,
    String? status,
    int? attemptCount,
    int? maxAttempts,
    this.lastError,
    this.nextAttemptAt,
    this.processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'queued',
       attemptCount = attemptCount ?? 0,
       maxAttempts = maxAttempts ?? 5,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationOutboxRow({
    _i1.UuidValue? id,
    required String dedupeKey,
    required _i1.UuidValue campaignId,
    required String payloadJson,
    String? status,
    int? attemptCount,
    int? maxAttempts,
    String? lastError,
    DateTime? nextAttemptAt,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationOutboxRowImpl;

  factory NotificationOutboxRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationOutboxRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      campaignId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['campaignId'],
      ),
      payloadJson: jsonSerialization['payloadJson'] as String,
      status: jsonSerialization['status'] as String?,
      attemptCount: jsonSerialization['attemptCount'] as int?,
      maxAttempts: jsonSerialization['maxAttempts'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      nextAttemptAt: jsonSerialization['nextAttemptAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextAttemptAt'],
            ),
      processedAt: jsonSerialization['processedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['processedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotificationOutboxRowTable();

  static const db = NotificationOutboxRowRepository._();

  @override
  _i1.UuidValue? id;

  String dedupeKey;

  _i1.UuidValue campaignId;

  String payloadJson;

  String status;

  int attemptCount;

  int maxAttempts;

  String? lastError;

  DateTime? nextAttemptAt;

  DateTime? processedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotificationOutboxRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationOutboxRow copyWith({
    _i1.UuidValue? id,
    String? dedupeKey,
    _i1.UuidValue? campaignId,
    String? payloadJson,
    String? status,
    int? attemptCount,
    int? maxAttempts,
    String? lastError,
    DateTime? nextAttemptAt,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationOutboxRow',
      if (id != null) 'id': id?.toJson(),
      'dedupeKey': dedupeKey,
      'campaignId': campaignId.toJson(),
      'payloadJson': payloadJson,
      'status': status,
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      if (lastError != null) 'lastError': lastError,
      if (nextAttemptAt != null) 'nextAttemptAt': nextAttemptAt?.toJson(),
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotificationOutboxRowInclude include() {
    return NotificationOutboxRowInclude._();
  }

  static NotificationOutboxRowIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationOutboxRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationOutboxRowTable>? orderByList,
    NotificationOutboxRowInclude? include,
  }) {
    return NotificationOutboxRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationOutboxRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationOutboxRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationOutboxRowImpl extends NotificationOutboxRow {
  _NotificationOutboxRowImpl({
    _i1.UuidValue? id,
    required String dedupeKey,
    required _i1.UuidValue campaignId,
    required String payloadJson,
    String? status,
    int? attemptCount,
    int? maxAttempts,
    String? lastError,
    DateTime? nextAttemptAt,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         dedupeKey: dedupeKey,
         campaignId: campaignId,
         payloadJson: payloadJson,
         status: status,
         attemptCount: attemptCount,
         maxAttempts: maxAttempts,
         lastError: lastError,
         nextAttemptAt: nextAttemptAt,
         processedAt: processedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationOutboxRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationOutboxRow copyWith({
    Object? id = _Undefined,
    String? dedupeKey,
    _i1.UuidValue? campaignId,
    String? payloadJson,
    String? status,
    int? attemptCount,
    int? maxAttempts,
    Object? lastError = _Undefined,
    Object? nextAttemptAt = _Undefined,
    Object? processedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationOutboxRow(
      id: id is _i1.UuidValue? ? id : this.id,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      campaignId: campaignId ?? this.campaignId,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lastError: lastError is String? ? lastError : this.lastError,
      nextAttemptAt: nextAttemptAt is DateTime?
          ? nextAttemptAt
          : this.nextAttemptAt,
      processedAt: processedAt is DateTime? ? processedAt : this.processedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationOutboxRowUpdateTable
    extends _i1.UpdateTable<NotificationOutboxRowTable> {
  NotificationOutboxRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> dedupeKey(String value) => _i1.ColumnValue(
    table.dedupeKey,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> campaignId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.campaignId,
    value,
  );

  _i1.ColumnValue<String, String> payloadJson(String value) => _i1.ColumnValue(
    table.payloadJson,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> attemptCount(int value) => _i1.ColumnValue(
    table.attemptCount,
    value,
  );

  _i1.ColumnValue<int, int> maxAttempts(int value) => _i1.ColumnValue(
    table.maxAttempts,
    value,
  );

  _i1.ColumnValue<String, String> lastError(String? value) => _i1.ColumnValue(
    table.lastError,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> nextAttemptAt(DateTime? value) =>
      _i1.ColumnValue(
        table.nextAttemptAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> processedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.processedAt,
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

class NotificationOutboxRowTable extends _i1.Table<_i1.UuidValue?> {
  NotificationOutboxRowTable({super.tableRelation})
    : super(tableName: 'notification_outbox') {
    updateTable = NotificationOutboxRowUpdateTable(this);
    dedupeKey = _i1.ColumnString(
      'dedupeKey',
      this,
    );
    campaignId = _i1.ColumnUuid(
      'campaignId',
      this,
    );
    payloadJson = _i1.ColumnString(
      'payloadJson',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
      this,
      hasDefault: true,
    );
    maxAttempts = _i1.ColumnInt(
      'maxAttempts',
      this,
      hasDefault: true,
    );
    lastError = _i1.ColumnString(
      'lastError',
      this,
    );
    nextAttemptAt = _i1.ColumnDateTime(
      'nextAttemptAt',
      this,
    );
    processedAt = _i1.ColumnDateTime(
      'processedAt',
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

  late final NotificationOutboxRowUpdateTable updateTable;

  late final _i1.ColumnString dedupeKey;

  late final _i1.ColumnUuid campaignId;

  late final _i1.ColumnString payloadJson;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnInt maxAttempts;

  late final _i1.ColumnString lastError;

  late final _i1.ColumnDateTime nextAttemptAt;

  late final _i1.ColumnDateTime processedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    dedupeKey,
    campaignId,
    payloadJson,
    status,
    attemptCount,
    maxAttempts,
    lastError,
    nextAttemptAt,
    processedAt,
    createdAt,
    updatedAt,
  ];
}

class NotificationOutboxRowInclude extends _i1.IncludeObject {
  NotificationOutboxRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationOutboxRow.t;
}

class NotificationOutboxRowIncludeList extends _i1.IncludeList {
  NotificationOutboxRowIncludeList._({
    _i1.WhereExpressionBuilder<NotificationOutboxRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationOutboxRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationOutboxRow.t;
}

class NotificationOutboxRowRepository {
  const NotificationOutboxRowRepository._();

  /// Returns a list of [NotificationOutboxRow]s matching the given query parameters.
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
  Future<List<NotificationOutboxRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationOutboxRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationOutboxRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationOutboxRow>(
      where: where?.call(NotificationOutboxRow.t),
      orderBy: orderBy?.call(NotificationOutboxRow.t),
      orderByList: orderByList?.call(NotificationOutboxRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationOutboxRow] matching the given query parameters.
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
  Future<NotificationOutboxRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationOutboxRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationOutboxRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationOutboxRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationOutboxRow>(
      where: where?.call(NotificationOutboxRow.t),
      orderBy: orderBy?.call(NotificationOutboxRow.t),
      orderByList: orderByList?.call(NotificationOutboxRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationOutboxRow] by its [id] or null if no such row exists.
  Future<NotificationOutboxRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationOutboxRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationOutboxRow]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationOutboxRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationOutboxRow>> insert(
    _i1.DatabaseSession session,
    List<NotificationOutboxRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationOutboxRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationOutboxRow] and returns the inserted row.
  ///
  /// The returned [NotificationOutboxRow] will have its `id` field set.
  Future<NotificationOutboxRow> insertRow(
    _i1.DatabaseSession session,
    NotificationOutboxRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationOutboxRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationOutboxRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationOutboxRow>> update(
    _i1.DatabaseSession session,
    List<NotificationOutboxRow> rows, {
    _i1.ColumnSelections<NotificationOutboxRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationOutboxRow>(
      rows,
      columns: columns?.call(NotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationOutboxRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationOutboxRow> updateRow(
    _i1.DatabaseSession session,
    NotificationOutboxRow row, {
    _i1.ColumnSelections<NotificationOutboxRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationOutboxRow>(
      row,
      columns: columns?.call(NotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationOutboxRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationOutboxRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<NotificationOutboxRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationOutboxRow>(
      id,
      columnValues: columnValues(NotificationOutboxRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationOutboxRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationOutboxRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NotificationOutboxRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationOutboxRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationOutboxRowTable>? orderBy,
    _i1.OrderByListBuilder<NotificationOutboxRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationOutboxRow>(
      columnValues: columnValues(NotificationOutboxRow.t.updateTable),
      where: where(NotificationOutboxRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationOutboxRow.t),
      orderByList: orderByList?.call(NotificationOutboxRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationOutboxRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationOutboxRow>> delete(
    _i1.DatabaseSession session,
    List<NotificationOutboxRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationOutboxRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationOutboxRow].
  Future<NotificationOutboxRow> deleteRow(
    _i1.DatabaseSession session,
    NotificationOutboxRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationOutboxRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationOutboxRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationOutboxRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationOutboxRow>(
      where: where(NotificationOutboxRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationOutboxRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationOutboxRow>(
      where: where?.call(NotificationOutboxRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationOutboxRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationOutboxRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationOutboxRow>(
      where: where(NotificationOutboxRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
