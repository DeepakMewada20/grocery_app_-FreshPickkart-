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

abstract class BannerPlacementRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  BannerPlacementRow._({
    this.id,
    required this.bannerId,
    required this.placementKey,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BannerPlacementRow({
    _i1.UuidValue? id,
    required _i1.UuidValue bannerId,
    required String placementKey,
    DateTime? createdAt,
  }) = _BannerPlacementRowImpl;

  factory BannerPlacementRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return BannerPlacementRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      bannerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['bannerId'],
      ),
      placementKey: jsonSerialization['placementKey'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BannerPlacementRowTable();

  static const db = BannerPlacementRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue bannerId;

  String placementKey;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [BannerPlacementRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BannerPlacementRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? bannerId,
    String? placementKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BannerPlacementRow',
      if (id != null) 'id': id?.toJson(),
      'bannerId': bannerId.toJson(),
      'placementKey': placementKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BannerPlacementRowInclude include() {
    return BannerPlacementRowInclude._();
  }

  static BannerPlacementRowIncludeList includeList({
    _i1.WhereExpressionBuilder<BannerPlacementRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerPlacementRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerPlacementRowTable>? orderByList,
    BannerPlacementRowInclude? include,
  }) {
    return BannerPlacementRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerPlacementRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BannerPlacementRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BannerPlacementRowImpl extends BannerPlacementRow {
  _BannerPlacementRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue bannerId,
    required String placementKey,
    DateTime? createdAt,
  }) : super._(
         id: id,
         bannerId: bannerId,
         placementKey: placementKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BannerPlacementRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BannerPlacementRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? bannerId,
    String? placementKey,
    DateTime? createdAt,
  }) {
    return BannerPlacementRow(
      id: id is _i1.UuidValue? ? id : this.id,
      bannerId: bannerId ?? this.bannerId,
      placementKey: placementKey ?? this.placementKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BannerPlacementRowUpdateTable
    extends _i1.UpdateTable<BannerPlacementRowTable> {
  BannerPlacementRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> bannerId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.bannerId,
        value,
      );

  _i1.ColumnValue<String, String> placementKey(String value) => _i1.ColumnValue(
    table.placementKey,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class BannerPlacementRowTable extends _i1.Table<_i1.UuidValue?> {
  BannerPlacementRowTable({super.tableRelation})
    : super(tableName: 'banner_placement') {
    updateTable = BannerPlacementRowUpdateTable(this);
    bannerId = _i1.ColumnUuid(
      'bannerId',
      this,
    );
    placementKey = _i1.ColumnString(
      'placementKey',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final BannerPlacementRowUpdateTable updateTable;

  late final _i1.ColumnUuid bannerId;

  late final _i1.ColumnString placementKey;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    bannerId,
    placementKey,
    createdAt,
  ];
}

class BannerPlacementRowInclude extends _i1.IncludeObject {
  BannerPlacementRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerPlacementRow.t;
}

class BannerPlacementRowIncludeList extends _i1.IncludeList {
  BannerPlacementRowIncludeList._({
    _i1.WhereExpressionBuilder<BannerPlacementRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BannerPlacementRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerPlacementRow.t;
}

class BannerPlacementRowRepository {
  const BannerPlacementRowRepository._();

  /// Returns a list of [BannerPlacementRow]s matching the given query parameters.
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
  Future<List<BannerPlacementRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerPlacementRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerPlacementRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerPlacementRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BannerPlacementRow>(
      where: where?.call(BannerPlacementRow.t),
      orderBy: orderBy?.call(BannerPlacementRow.t),
      orderByList: orderByList?.call(BannerPlacementRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BannerPlacementRow] matching the given query parameters.
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
  Future<BannerPlacementRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerPlacementRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<BannerPlacementRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerPlacementRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BannerPlacementRow>(
      where: where?.call(BannerPlacementRow.t),
      orderBy: orderBy?.call(BannerPlacementRow.t),
      orderByList: orderByList?.call(BannerPlacementRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BannerPlacementRow] by its [id] or null if no such row exists.
  Future<BannerPlacementRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BannerPlacementRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BannerPlacementRow]s in the list and returns the inserted rows.
  ///
  /// The returned [BannerPlacementRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BannerPlacementRow>> insert(
    _i1.DatabaseSession session,
    List<BannerPlacementRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BannerPlacementRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BannerPlacementRow] and returns the inserted row.
  ///
  /// The returned [BannerPlacementRow] will have its `id` field set.
  Future<BannerPlacementRow> insertRow(
    _i1.DatabaseSession session,
    BannerPlacementRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BannerPlacementRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BannerPlacementRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BannerPlacementRow>> update(
    _i1.DatabaseSession session,
    List<BannerPlacementRow> rows, {
    _i1.ColumnSelections<BannerPlacementRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BannerPlacementRow>(
      rows,
      columns: columns?.call(BannerPlacementRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerPlacementRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BannerPlacementRow> updateRow(
    _i1.DatabaseSession session,
    BannerPlacementRow row, {
    _i1.ColumnSelections<BannerPlacementRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BannerPlacementRow>(
      row,
      columns: columns?.call(BannerPlacementRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerPlacementRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BannerPlacementRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BannerPlacementRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BannerPlacementRow>(
      id,
      columnValues: columnValues(BannerPlacementRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BannerPlacementRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BannerPlacementRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BannerPlacementRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BannerPlacementRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerPlacementRowTable>? orderBy,
    _i1.OrderByListBuilder<BannerPlacementRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BannerPlacementRow>(
      columnValues: columnValues(BannerPlacementRow.t.updateTable),
      where: where(BannerPlacementRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerPlacementRow.t),
      orderByList: orderByList?.call(BannerPlacementRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BannerPlacementRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BannerPlacementRow>> delete(
    _i1.DatabaseSession session,
    List<BannerPlacementRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BannerPlacementRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BannerPlacementRow].
  Future<BannerPlacementRow> deleteRow(
    _i1.DatabaseSession session,
    BannerPlacementRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BannerPlacementRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BannerPlacementRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerPlacementRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BannerPlacementRow>(
      where: where(BannerPlacementRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerPlacementRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BannerPlacementRow>(
      where: where?.call(BannerPlacementRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BannerPlacementRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerPlacementRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BannerPlacementRow>(
      where: where(BannerPlacementRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
