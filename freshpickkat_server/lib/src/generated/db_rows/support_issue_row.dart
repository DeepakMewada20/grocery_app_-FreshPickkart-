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

abstract class SupportIssueRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SupportIssueRow._({
    this.id,
    required this.userId,
    required this.issueType,
    required this.title,
    required this.description,
    this.screenshotUrl,
    required this.appVersion,
    required this.buildNumber,
    required this.deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'Pending',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SupportIssueRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SupportIssueRowImpl;

  factory SupportIssueRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportIssueRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      issueType: jsonSerialization['issueType'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      screenshotUrl: jsonSerialization['screenshotUrl'] as String?,
      appVersion: jsonSerialization['appVersion'] as String,
      buildNumber: jsonSerialization['buildNumber'] as String,
      deviceInfo: jsonSerialization['deviceInfo'] as String,
      status: jsonSerialization['status'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = SupportIssueRowTable();

  static const db = SupportIssueRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String issueType;

  String title;

  String description;

  String? screenshotUrl;

  String appVersion;

  String buildNumber;

  String deviceInfo;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SupportIssueRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SupportIssueRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? issueType,
    String? title,
    String? description,
    String? screenshotUrl,
    String? appVersion,
    String? buildNumber,
    String? deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportIssueRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'issueType': issueType,
      'title': title,
      'description': description,
      if (screenshotUrl != null) 'screenshotUrl': screenshotUrl,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'deviceInfo': deviceInfo,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SupportIssueRowInclude include() {
    return SupportIssueRowInclude._();
  }

  static SupportIssueRowIncludeList includeList({
    _i1.WhereExpressionBuilder<SupportIssueRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportIssueRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportIssueRowTable>? orderByList,
    SupportIssueRowInclude? include,
  }) {
    return SupportIssueRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportIssueRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SupportIssueRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportIssueRowImpl extends SupportIssueRow {
  _SupportIssueRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         issueType: issueType,
         title: title,
         description: description,
         screenshotUrl: screenshotUrl,
         appVersion: appVersion,
         buildNumber: buildNumber,
         deviceInfo: deviceInfo,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SupportIssueRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SupportIssueRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? issueType,
    String? title,
    String? description,
    Object? screenshotUrl = _Undefined,
    String? appVersion,
    String? buildNumber,
    String? deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportIssueRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      issueType: issueType ?? this.issueType,
      title: title ?? this.title,
      description: description ?? this.description,
      screenshotUrl: screenshotUrl is String?
          ? screenshotUrl
          : this.screenshotUrl,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SupportIssueRowUpdateTable extends _i1.UpdateTable<SupportIssueRowTable> {
  SupportIssueRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> issueType(String value) => _i1.ColumnValue(
    table.issueType,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> screenshotUrl(String? value) =>
      _i1.ColumnValue(
        table.screenshotUrl,
        value,
      );

  _i1.ColumnValue<String, String> appVersion(String value) => _i1.ColumnValue(
    table.appVersion,
    value,
  );

  _i1.ColumnValue<String, String> buildNumber(String value) => _i1.ColumnValue(
    table.buildNumber,
    value,
  );

  _i1.ColumnValue<String, String> deviceInfo(String value) => _i1.ColumnValue(
    table.deviceInfo,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

class SupportIssueRowTable extends _i1.Table<_i1.UuidValue?> {
  SupportIssueRowTable({super.tableRelation})
    : super(tableName: 'support_issue') {
    updateTable = SupportIssueRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    issueType = _i1.ColumnString(
      'issueType',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    screenshotUrl = _i1.ColumnString(
      'screenshotUrl',
      this,
    );
    appVersion = _i1.ColumnString(
      'appVersion',
      this,
    );
    buildNumber = _i1.ColumnString(
      'buildNumber',
      this,
    );
    deviceInfo = _i1.ColumnString(
      'deviceInfo',
      this,
    );
    status = _i1.ColumnString(
      'status',
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

  late final SupportIssueRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString issueType;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString screenshotUrl;

  late final _i1.ColumnString appVersion;

  late final _i1.ColumnString buildNumber;

  late final _i1.ColumnString deviceInfo;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    issueType,
    title,
    description,
    screenshotUrl,
    appVersion,
    buildNumber,
    deviceInfo,
    status,
    createdAt,
    updatedAt,
  ];
}

class SupportIssueRowInclude extends _i1.IncludeObject {
  SupportIssueRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SupportIssueRow.t;
}

class SupportIssueRowIncludeList extends _i1.IncludeList {
  SupportIssueRowIncludeList._({
    _i1.WhereExpressionBuilder<SupportIssueRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SupportIssueRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SupportIssueRow.t;
}

class SupportIssueRowRepository {
  const SupportIssueRowRepository._();

  /// Returns a list of [SupportIssueRow]s matching the given query parameters.
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
  Future<List<SupportIssueRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportIssueRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportIssueRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportIssueRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SupportIssueRow>(
      where: where?.call(SupportIssueRow.t),
      orderBy: orderBy?.call(SupportIssueRow.t),
      orderByList: orderByList?.call(SupportIssueRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SupportIssueRow] matching the given query parameters.
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
  Future<SupportIssueRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportIssueRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<SupportIssueRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportIssueRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SupportIssueRow>(
      where: where?.call(SupportIssueRow.t),
      orderBy: orderBy?.call(SupportIssueRow.t),
      orderByList: orderByList?.call(SupportIssueRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SupportIssueRow] by its [id] or null if no such row exists.
  Future<SupportIssueRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SupportIssueRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SupportIssueRow]s in the list and returns the inserted rows.
  ///
  /// The returned [SupportIssueRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SupportIssueRow>> insert(
    _i1.DatabaseSession session,
    List<SupportIssueRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SupportIssueRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SupportIssueRow] and returns the inserted row.
  ///
  /// The returned [SupportIssueRow] will have its `id` field set.
  Future<SupportIssueRow> insertRow(
    _i1.DatabaseSession session,
    SupportIssueRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SupportIssueRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SupportIssueRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SupportIssueRow>> update(
    _i1.DatabaseSession session,
    List<SupportIssueRow> rows, {
    _i1.ColumnSelections<SupportIssueRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SupportIssueRow>(
      rows,
      columns: columns?.call(SupportIssueRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportIssueRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SupportIssueRow> updateRow(
    _i1.DatabaseSession session,
    SupportIssueRow row, {
    _i1.ColumnSelections<SupportIssueRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SupportIssueRow>(
      row,
      columns: columns?.call(SupportIssueRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportIssueRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SupportIssueRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SupportIssueRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SupportIssueRow>(
      id,
      columnValues: columnValues(SupportIssueRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SupportIssueRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SupportIssueRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SupportIssueRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SupportIssueRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportIssueRowTable>? orderBy,
    _i1.OrderByListBuilder<SupportIssueRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SupportIssueRow>(
      columnValues: columnValues(SupportIssueRow.t.updateTable),
      where: where(SupportIssueRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportIssueRow.t),
      orderByList: orderByList?.call(SupportIssueRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SupportIssueRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SupportIssueRow>> delete(
    _i1.DatabaseSession session,
    List<SupportIssueRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SupportIssueRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SupportIssueRow].
  Future<SupportIssueRow> deleteRow(
    _i1.DatabaseSession session,
    SupportIssueRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SupportIssueRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SupportIssueRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SupportIssueRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SupportIssueRow>(
      where: where(SupportIssueRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportIssueRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SupportIssueRow>(
      where: where?.call(SupportIssueRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SupportIssueRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SupportIssueRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SupportIssueRow>(
      where: where(SupportIssueRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
