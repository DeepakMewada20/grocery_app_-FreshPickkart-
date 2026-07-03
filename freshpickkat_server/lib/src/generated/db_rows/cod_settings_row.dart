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

abstract class CodSettingsRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CodSettingsRow._({
    this.id,
    int? maximumAllowedCodFailures,
    bool? enableAutoBlocking,
    DateTime? updatedAt,
  }) : maximumAllowedCodFailures = maximumAllowedCodFailures ?? 3,
       enableAutoBlocking = enableAutoBlocking ?? true,
       updatedAt = updatedAt ?? DateTime.now();

  factory CodSettingsRow({
    _i1.UuidValue? id,
    int? maximumAllowedCodFailures,
    bool? enableAutoBlocking,
    DateTime? updatedAt,
  }) = _CodSettingsRowImpl;

  factory CodSettingsRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CodSettingsRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      maximumAllowedCodFailures:
          jsonSerialization['maximumAllowedCodFailures'] as int?,
      enableAutoBlocking: jsonSerialization['enableAutoBlocking'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableAutoBlocking'],
            ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CodSettingsRowTable();

  static const db = CodSettingsRowRepository._();

  @override
  _i1.UuidValue? id;

  int maximumAllowedCodFailures;

  bool enableAutoBlocking;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CodSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CodSettingsRow copyWith({
    _i1.UuidValue? id,
    int? maximumAllowedCodFailures,
    bool? enableAutoBlocking,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CodSettingsRow',
      if (id != null) 'id': id?.toJson(),
      'maximumAllowedCodFailures': maximumAllowedCodFailures,
      'enableAutoBlocking': enableAutoBlocking,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CodSettingsRowInclude include() {
    return CodSettingsRowInclude._();
  }

  static CodSettingsRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CodSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodSettingsRowTable>? orderByList,
    CodSettingsRowInclude? include,
  }) {
    return CodSettingsRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodSettingsRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CodSettingsRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CodSettingsRowImpl extends CodSettingsRow {
  _CodSettingsRowImpl({
    _i1.UuidValue? id,
    int? maximumAllowedCodFailures,
    bool? enableAutoBlocking,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         maximumAllowedCodFailures: maximumAllowedCodFailures,
         enableAutoBlocking: enableAutoBlocking,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CodSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CodSettingsRow copyWith({
    Object? id = _Undefined,
    int? maximumAllowedCodFailures,
    bool? enableAutoBlocking,
    DateTime? updatedAt,
  }) {
    return CodSettingsRow(
      id: id is _i1.UuidValue? ? id : this.id,
      maximumAllowedCodFailures:
          maximumAllowedCodFailures ?? this.maximumAllowedCodFailures,
      enableAutoBlocking: enableAutoBlocking ?? this.enableAutoBlocking,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CodSettingsRowUpdateTable extends _i1.UpdateTable<CodSettingsRowTable> {
  CodSettingsRowUpdateTable(super.table);

  _i1.ColumnValue<int, int> maximumAllowedCodFailures(int value) =>
      _i1.ColumnValue(
        table.maximumAllowedCodFailures,
        value,
      );

  _i1.ColumnValue<bool, bool> enableAutoBlocking(bool value) => _i1.ColumnValue(
    table.enableAutoBlocking,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class CodSettingsRowTable extends _i1.Table<_i1.UuidValue?> {
  CodSettingsRowTable({super.tableRelation})
    : super(tableName: 'cod_settings') {
    updateTable = CodSettingsRowUpdateTable(this);
    maximumAllowedCodFailures = _i1.ColumnInt(
      'maximumAllowedCodFailures',
      this,
      hasDefault: true,
    );
    enableAutoBlocking = _i1.ColumnBool(
      'enableAutoBlocking',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final CodSettingsRowUpdateTable updateTable;

  late final _i1.ColumnInt maximumAllowedCodFailures;

  late final _i1.ColumnBool enableAutoBlocking;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    maximumAllowedCodFailures,
    enableAutoBlocking,
    updatedAt,
  ];
}

class CodSettingsRowInclude extends _i1.IncludeObject {
  CodSettingsRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CodSettingsRow.t;
}

class CodSettingsRowIncludeList extends _i1.IncludeList {
  CodSettingsRowIncludeList._({
    _i1.WhereExpressionBuilder<CodSettingsRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CodSettingsRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CodSettingsRow.t;
}

class CodSettingsRowRepository {
  const CodSettingsRowRepository._();

  /// Returns a list of [CodSettingsRow]s matching the given query parameters.
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
  Future<List<CodSettingsRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CodSettingsRow>(
      where: where?.call(CodSettingsRow.t),
      orderBy: orderBy?.call(CodSettingsRow.t),
      orderByList: orderByList?.call(CodSettingsRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CodSettingsRow] matching the given query parameters.
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
  Future<CodSettingsRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodSettingsRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CodSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CodSettingsRow>(
      where: where?.call(CodSettingsRow.t),
      orderBy: orderBy?.call(CodSettingsRow.t),
      orderByList: orderByList?.call(CodSettingsRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CodSettingsRow] by its [id] or null if no such row exists.
  Future<CodSettingsRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CodSettingsRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CodSettingsRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CodSettingsRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CodSettingsRow>> insert(
    _i1.DatabaseSession session,
    List<CodSettingsRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CodSettingsRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CodSettingsRow] and returns the inserted row.
  ///
  /// The returned [CodSettingsRow] will have its `id` field set.
  Future<CodSettingsRow> insertRow(
    _i1.DatabaseSession session,
    CodSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CodSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CodSettingsRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CodSettingsRow>> update(
    _i1.DatabaseSession session,
    List<CodSettingsRow> rows, {
    _i1.ColumnSelections<CodSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CodSettingsRow>(
      rows,
      columns: columns?.call(CodSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodSettingsRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CodSettingsRow> updateRow(
    _i1.DatabaseSession session,
    CodSettingsRow row, {
    _i1.ColumnSelections<CodSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CodSettingsRow>(
      row,
      columns: columns?.call(CodSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodSettingsRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CodSettingsRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CodSettingsRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CodSettingsRow>(
      id,
      columnValues: columnValues(CodSettingsRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CodSettingsRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CodSettingsRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CodSettingsRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CodSettingsRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodSettingsRowTable>? orderBy,
    _i1.OrderByListBuilder<CodSettingsRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CodSettingsRow>(
      columnValues: columnValues(CodSettingsRow.t.updateTable),
      where: where(CodSettingsRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodSettingsRow.t),
      orderByList: orderByList?.call(CodSettingsRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CodSettingsRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CodSettingsRow>> delete(
    _i1.DatabaseSession session,
    List<CodSettingsRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CodSettingsRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CodSettingsRow].
  Future<CodSettingsRow> deleteRow(
    _i1.DatabaseSession session,
    CodSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CodSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CodSettingsRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CodSettingsRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CodSettingsRow>(
      where: where(CodSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CodSettingsRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CodSettingsRow>(
      where: where?.call(CodSettingsRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CodSettingsRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CodSettingsRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CodSettingsRow>(
      where: where(CodSettingsRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
