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

abstract class NotificationPreferenceRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  NotificationPreferenceRow._({
    this.id,
    required this.userId,
    required this.firebaseUid,
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : trackOrderNotifications = trackOrderNotifications ?? true,
       couponNotifications = couponNotifications ?? true,
       offerNotifications = offerNotifications ?? true,
       announcementNotifications = announcementNotifications ?? true,
       importantAlerts = importantAlerts ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationPreferenceRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String firebaseUid,
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationPreferenceRowImpl;

  factory NotificationPreferenceRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreferenceRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      trackOrderNotifications:
          jsonSerialization['trackOrderNotifications'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['trackOrderNotifications'],
            ),
      couponNotifications: jsonSerialization['couponNotifications'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['couponNotifications'],
            ),
      offerNotifications: jsonSerialization['offerNotifications'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['offerNotifications'],
            ),
      announcementNotifications:
          jsonSerialization['announcementNotifications'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['announcementNotifications'],
            ),
      importantAlerts: jsonSerialization['importantAlerts'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['importantAlerts'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotificationPreferenceRowTable();

  static const db = NotificationPreferenceRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String firebaseUid;

  bool trackOrderNotifications;

  bool couponNotifications;

  bool offerNotifications;

  bool announcementNotifications;

  bool importantAlerts;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreferenceRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? firebaseUid,
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreferenceRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'firebaseUid': firebaseUid,
      'trackOrderNotifications': trackOrderNotifications,
      'couponNotifications': couponNotifications,
      'offerNotifications': offerNotifications,
      'announcementNotifications': announcementNotifications,
      'importantAlerts': importantAlerts,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotificationPreferenceRowInclude include() {
    return NotificationPreferenceRowInclude._();
  }

  static NotificationPreferenceRowIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    NotificationPreferenceRowInclude? include,
  }) {
    return NotificationPreferenceRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceRowImpl extends NotificationPreferenceRow {
  _NotificationPreferenceRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String firebaseUid,
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         firebaseUid: firebaseUid,
         trackOrderNotifications: trackOrderNotifications,
         couponNotifications: couponNotifications,
         offerNotifications: offerNotifications,
         announcementNotifications: announcementNotifications,
         importantAlerts: importantAlerts,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreferenceRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? firebaseUid,
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPreferenceRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      trackOrderNotifications:
          trackOrderNotifications ?? this.trackOrderNotifications,
      couponNotifications: couponNotifications ?? this.couponNotifications,
      offerNotifications: offerNotifications ?? this.offerNotifications,
      announcementNotifications:
          announcementNotifications ?? this.announcementNotifications,
      importantAlerts: importantAlerts ?? this.importantAlerts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationPreferenceRowUpdateTable
    extends _i1.UpdateTable<NotificationPreferenceRowTable> {
  NotificationPreferenceRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> firebaseUid(String value) => _i1.ColumnValue(
    table.firebaseUid,
    value,
  );

  _i1.ColumnValue<bool, bool> trackOrderNotifications(bool value) =>
      _i1.ColumnValue(
        table.trackOrderNotifications,
        value,
      );

  _i1.ColumnValue<bool, bool> couponNotifications(bool value) =>
      _i1.ColumnValue(
        table.couponNotifications,
        value,
      );

  _i1.ColumnValue<bool, bool> offerNotifications(bool value) => _i1.ColumnValue(
    table.offerNotifications,
    value,
  );

  _i1.ColumnValue<bool, bool> announcementNotifications(bool value) =>
      _i1.ColumnValue(
        table.announcementNotifications,
        value,
      );

  _i1.ColumnValue<bool, bool> importantAlerts(bool value) => _i1.ColumnValue(
    table.importantAlerts,
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

class NotificationPreferenceRowTable extends _i1.Table<_i1.UuidValue?> {
  NotificationPreferenceRowTable({super.tableRelation})
    : super(tableName: 'notification_preference') {
    updateTable = NotificationPreferenceRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    firebaseUid = _i1.ColumnString(
      'firebaseUid',
      this,
    );
    trackOrderNotifications = _i1.ColumnBool(
      'trackOrderNotifications',
      this,
      hasDefault: true,
    );
    couponNotifications = _i1.ColumnBool(
      'couponNotifications',
      this,
      hasDefault: true,
    );
    offerNotifications = _i1.ColumnBool(
      'offerNotifications',
      this,
      hasDefault: true,
    );
    announcementNotifications = _i1.ColumnBool(
      'announcementNotifications',
      this,
      hasDefault: true,
    );
    importantAlerts = _i1.ColumnBool(
      'importantAlerts',
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

  late final NotificationPreferenceRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString firebaseUid;

  late final _i1.ColumnBool trackOrderNotifications;

  late final _i1.ColumnBool couponNotifications;

  late final _i1.ColumnBool offerNotifications;

  late final _i1.ColumnBool announcementNotifications;

  late final _i1.ColumnBool importantAlerts;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    firebaseUid,
    trackOrderNotifications,
    couponNotifications,
    offerNotifications,
    announcementNotifications,
    importantAlerts,
    createdAt,
    updatedAt,
  ];
}

class NotificationPreferenceRowInclude extends _i1.IncludeObject {
  NotificationPreferenceRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationPreferenceRow.t;
}

class NotificationPreferenceRowIncludeList extends _i1.IncludeList {
  NotificationPreferenceRowIncludeList._({
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationPreferenceRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationPreferenceRow.t;
}

class NotificationPreferenceRowRepository {
  const NotificationPreferenceRowRepository._();

  /// Returns a list of [NotificationPreferenceRow]s matching the given query parameters.
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
  Future<List<NotificationPreferenceRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationPreferenceRow] matching the given query parameters.
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
  Future<NotificationPreferenceRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationPreferenceRow] by its [id] or null if no such row exists.
  Future<NotificationPreferenceRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationPreferenceRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationPreferenceRow]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationPreferenceRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationPreferenceRow>> insert(
    _i1.DatabaseSession session,
    List<NotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationPreferenceRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationPreferenceRow] and returns the inserted row.
  ///
  /// The returned [NotificationPreferenceRow] will have its `id` field set.
  Future<NotificationPreferenceRow> insertRow(
    _i1.DatabaseSession session,
    NotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreferenceRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationPreferenceRow>> update(
    _i1.DatabaseSession session,
    List<NotificationPreferenceRow> rows, {
    _i1.ColumnSelections<NotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationPreferenceRow>(
      rows,
      columns: columns?.call(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreferenceRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationPreferenceRow> updateRow(
    _i1.DatabaseSession session,
    NotificationPreferenceRow row, {
    _i1.ColumnSelections<NotificationPreferenceRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationPreferenceRow>(
      row,
      columns: columns?.call(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreferenceRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationPreferenceRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<NotificationPreferenceRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationPreferenceRow>(
      id,
      columnValues: columnValues(NotificationPreferenceRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreferenceRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationPreferenceRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NotificationPreferenceRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationPreferenceRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationPreferenceRowTable>? orderBy,
    _i1.OrderByListBuilder<NotificationPreferenceRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationPreferenceRow>(
      columnValues: columnValues(NotificationPreferenceRow.t.updateTable),
      where: where(NotificationPreferenceRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreferenceRow.t),
      orderByList: orderByList?.call(NotificationPreferenceRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationPreferenceRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationPreferenceRow>> delete(
    _i1.DatabaseSession session,
    List<NotificationPreferenceRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationPreferenceRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationPreferenceRow].
  Future<NotificationPreferenceRow> deleteRow(
    _i1.DatabaseSession session,
    NotificationPreferenceRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationPreferenceRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationPreferenceRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationPreferenceRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationPreferenceRow>(
      where: where(NotificationPreferenceRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationPreferenceRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationPreferenceRow>(
      where: where?.call(NotificationPreferenceRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationPreferenceRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationPreferenceRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationPreferenceRow>(
      where: where(NotificationPreferenceRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
