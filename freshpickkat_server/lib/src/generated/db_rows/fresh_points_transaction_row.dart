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

abstract class FreshPointsTransactionRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  FreshPointsTransactionRow._({
    this.id,
    required this.userId,
    required this.transactionType,
    required this.points,
    int? balanceBefore,
    int? balanceAfter,
    this.referenceType,
    this.referenceId,
    this.description,
    this.createdBy,
    DateTime? createdAt,
  }) : balanceBefore = balanceBefore ?? 0,
       balanceAfter = balanceAfter ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory FreshPointsTransactionRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String transactionType,
    required int points,
    int? balanceBefore,
    int? balanceAfter,
    String? referenceType,
    _i1.UuidValue? referenceId,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  }) = _FreshPointsTransactionRowImpl;

  factory FreshPointsTransactionRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FreshPointsTransactionRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      transactionType: jsonSerialization['transactionType'] as String,
      points: jsonSerialization['points'] as int,
      balanceBefore: jsonSerialization['balanceBefore'] as int?,
      balanceAfter: jsonSerialization['balanceAfter'] as int?,
      referenceType: jsonSerialization['referenceType'] as String?,
      referenceId: jsonSerialization['referenceId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['referenceId'],
            ),
      description: jsonSerialization['description'] as String?,
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = FreshPointsTransactionRowTable();

  static const db = FreshPointsTransactionRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String transactionType;

  int points;

  int balanceBefore;

  int balanceAfter;

  String? referenceType;

  _i1.UuidValue? referenceId;

  String? description;

  String? createdBy;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FreshPointsTransactionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsTransactionRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? transactionType,
    int? points,
    int? balanceBefore,
    int? balanceAfter,
    String? referenceType,
    _i1.UuidValue? referenceId,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsTransactionRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'transactionType': transactionType,
      'points': points,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      if (referenceType != null) 'referenceType': referenceType,
      if (referenceId != null) 'referenceId': referenceId?.toJson(),
      if (description != null) 'description': description,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FreshPointsTransactionRowInclude include() {
    return FreshPointsTransactionRowInclude._();
  }

  static FreshPointsTransactionRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsTransactionRowTable>? orderByList,
    FreshPointsTransactionRowInclude? include,
  }) {
    return FreshPointsTransactionRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreshPointsTransactionRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FreshPointsTransactionRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreshPointsTransactionRowImpl extends FreshPointsTransactionRow {
  _FreshPointsTransactionRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String transactionType,
    required int points,
    int? balanceBefore,
    int? balanceAfter,
    String? referenceType,
    _i1.UuidValue? referenceId,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         transactionType: transactionType,
         points: points,
         balanceBefore: balanceBefore,
         balanceAfter: balanceAfter,
         referenceType: referenceType,
         referenceId: referenceId,
         description: description,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FreshPointsTransactionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsTransactionRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? transactionType,
    int? points,
    int? balanceBefore,
    int? balanceAfter,
    Object? referenceType = _Undefined,
    Object? referenceId = _Undefined,
    Object? description = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return FreshPointsTransactionRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      transactionType: transactionType ?? this.transactionType,
      points: points ?? this.points,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      referenceType: referenceType is String?
          ? referenceType
          : this.referenceType,
      referenceId: referenceId is _i1.UuidValue?
          ? referenceId
          : this.referenceId,
      description: description is String? ? description : this.description,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FreshPointsTransactionRowUpdateTable
    extends _i1.UpdateTable<FreshPointsTransactionRowTable> {
  FreshPointsTransactionRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> transactionType(String value) =>
      _i1.ColumnValue(
        table.transactionType,
        value,
      );

  _i1.ColumnValue<int, int> points(int value) => _i1.ColumnValue(
    table.points,
    value,
  );

  _i1.ColumnValue<int, int> balanceBefore(int value) => _i1.ColumnValue(
    table.balanceBefore,
    value,
  );

  _i1.ColumnValue<int, int> balanceAfter(int value) => _i1.ColumnValue(
    table.balanceAfter,
    value,
  );

  _i1.ColumnValue<String, String> referenceType(String? value) =>
      _i1.ColumnValue(
        table.referenceType,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> referenceId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.referenceId,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> createdBy(String? value) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class FreshPointsTransactionRowTable extends _i1.Table<_i1.UuidValue?> {
  FreshPointsTransactionRowTable({super.tableRelation})
    : super(tableName: 'fresh_points_transaction') {
    updateTable = FreshPointsTransactionRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    transactionType = _i1.ColumnString(
      'transactionType',
      this,
    );
    points = _i1.ColumnInt(
      'points',
      this,
    );
    balanceBefore = _i1.ColumnInt(
      'balanceBefore',
      this,
      hasDefault: true,
    );
    balanceAfter = _i1.ColumnInt(
      'balanceAfter',
      this,
      hasDefault: true,
    );
    referenceType = _i1.ColumnString(
      'referenceType',
      this,
    );
    referenceId = _i1.ColumnUuid(
      'referenceId',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    createdBy = _i1.ColumnString(
      'createdBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final FreshPointsTransactionRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString transactionType;

  late final _i1.ColumnInt points;

  late final _i1.ColumnInt balanceBefore;

  late final _i1.ColumnInt balanceAfter;

  late final _i1.ColumnString referenceType;

  late final _i1.ColumnUuid referenceId;

  late final _i1.ColumnString description;

  late final _i1.ColumnString createdBy;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    transactionType,
    points,
    balanceBefore,
    balanceAfter,
    referenceType,
    referenceId,
    description,
    createdBy,
    createdAt,
  ];
}

class FreshPointsTransactionRowInclude extends _i1.IncludeObject {
  FreshPointsTransactionRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreshPointsTransactionRow.t;
}

class FreshPointsTransactionRowIncludeList extends _i1.IncludeList {
  FreshPointsTransactionRowIncludeList._({
    _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FreshPointsTransactionRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreshPointsTransactionRow.t;
}

class FreshPointsTransactionRowRepository {
  const FreshPointsTransactionRowRepository._();

  /// Returns a list of [FreshPointsTransactionRow]s matching the given query parameters.
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
  Future<List<FreshPointsTransactionRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsTransactionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FreshPointsTransactionRow>(
      where: where?.call(FreshPointsTransactionRow.t),
      orderBy: orderBy?.call(FreshPointsTransactionRow.t),
      orderByList: orderByList?.call(FreshPointsTransactionRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FreshPointsTransactionRow] matching the given query parameters.
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
  Future<FreshPointsTransactionRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FreshPointsTransactionRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsTransactionRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FreshPointsTransactionRow>(
      where: where?.call(FreshPointsTransactionRow.t),
      orderBy: orderBy?.call(FreshPointsTransactionRow.t),
      orderByList: orderByList?.call(FreshPointsTransactionRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FreshPointsTransactionRow] by its [id] or null if no such row exists.
  Future<FreshPointsTransactionRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FreshPointsTransactionRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FreshPointsTransactionRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FreshPointsTransactionRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FreshPointsTransactionRow>> insert(
    _i1.DatabaseSession session,
    List<FreshPointsTransactionRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FreshPointsTransactionRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FreshPointsTransactionRow] and returns the inserted row.
  ///
  /// The returned [FreshPointsTransactionRow] will have its `id` field set.
  Future<FreshPointsTransactionRow> insertRow(
    _i1.DatabaseSession session,
    FreshPointsTransactionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FreshPointsTransactionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FreshPointsTransactionRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FreshPointsTransactionRow>> update(
    _i1.DatabaseSession session,
    List<FreshPointsTransactionRow> rows, {
    _i1.ColumnSelections<FreshPointsTransactionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FreshPointsTransactionRow>(
      rows,
      columns: columns?.call(FreshPointsTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreshPointsTransactionRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FreshPointsTransactionRow> updateRow(
    _i1.DatabaseSession session,
    FreshPointsTransactionRow row, {
    _i1.ColumnSelections<FreshPointsTransactionRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FreshPointsTransactionRow>(
      row,
      columns: columns?.call(FreshPointsTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreshPointsTransactionRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FreshPointsTransactionRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<FreshPointsTransactionRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FreshPointsTransactionRow>(
      id,
      columnValues: columnValues(FreshPointsTransactionRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FreshPointsTransactionRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FreshPointsTransactionRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FreshPointsTransactionRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsTransactionRowTable>? orderBy,
    _i1.OrderByListBuilder<FreshPointsTransactionRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FreshPointsTransactionRow>(
      columnValues: columnValues(FreshPointsTransactionRow.t.updateTable),
      where: where(FreshPointsTransactionRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreshPointsTransactionRow.t),
      orderByList: orderByList?.call(FreshPointsTransactionRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FreshPointsTransactionRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FreshPointsTransactionRow>> delete(
    _i1.DatabaseSession session,
    List<FreshPointsTransactionRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FreshPointsTransactionRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FreshPointsTransactionRow].
  Future<FreshPointsTransactionRow> deleteRow(
    _i1.DatabaseSession session,
    FreshPointsTransactionRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FreshPointsTransactionRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FreshPointsTransactionRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FreshPointsTransactionRow>(
      where: where(FreshPointsTransactionRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FreshPointsTransactionRow>(
      where: where?.call(FreshPointsTransactionRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FreshPointsTransactionRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreshPointsTransactionRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FreshPointsTransactionRow>(
      where: where(FreshPointsTransactionRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
