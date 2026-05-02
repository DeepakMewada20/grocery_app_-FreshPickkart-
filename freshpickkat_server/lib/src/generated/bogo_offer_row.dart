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

abstract class BogoOfferRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  BogoOfferRow._({
    this.id,
    required this.triggerProductId,
    this.triggerVariantId,
    int? minTriggerQuantity,
    this.triggerBaseQuantity,
    this.triggerBaseUnit,
    required this.title,
    required this.startsAt,
    required this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : minTriggerQuantity = minTriggerQuantity ?? 1,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BogoOfferRow({
    _i1.UuidValue? id,
    required _i1.UuidValue triggerProductId,
    _i1.UuidValue? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BogoOfferRowImpl;

  factory BogoOfferRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return BogoOfferRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      triggerProductId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['triggerProductId'],
      ),
      triggerVariantId: jsonSerialization['triggerVariantId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['triggerVariantId'],
            ),
      minTriggerQuantity: jsonSerialization['minTriggerQuantity'] as int?,
      triggerBaseQuantity: (jsonSerialization['triggerBaseQuantity'] as num?)
          ?.toDouble(),
      triggerBaseUnit: jsonSerialization['triggerBaseUnit'] as String?,
      title: jsonSerialization['title'] as String,
      startsAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      endsAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      status: jsonSerialization['status'] as String?,
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deactivatedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = BogoOfferRowTable();

  static const db = BogoOfferRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue triggerProductId;

  _i1.UuidValue? triggerVariantId;

  int minTriggerQuantity;

  double? triggerBaseQuantity;

  String? triggerBaseUnit;

  String title;

  DateTime startsAt;

  DateTime endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [BogoOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BogoOfferRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? triggerProductId,
    _i1.UuidValue? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BogoOfferRow',
      if (id != null) 'id': id?.toJson(),
      'triggerProductId': triggerProductId.toJson(),
      if (triggerVariantId != null)
        'triggerVariantId': triggerVariantId?.toJson(),
      'minTriggerQuantity': minTriggerQuantity,
      if (triggerBaseQuantity != null)
        'triggerBaseQuantity': triggerBaseQuantity,
      if (triggerBaseUnit != null) 'triggerBaseUnit': triggerBaseUnit,
      'title': title,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BogoOfferRowInclude include() {
    return BogoOfferRowInclude._();
  }

  static BogoOfferRowIncludeList includeList({
    _i1.WhereExpressionBuilder<BogoOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRowTable>? orderByList,
    BogoOfferRowInclude? include,
  }) {
    return BogoOfferRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BogoOfferRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BogoOfferRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BogoOfferRowImpl extends BogoOfferRow {
  _BogoOfferRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue triggerProductId,
    _i1.UuidValue? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         triggerProductId: triggerProductId,
         triggerVariantId: triggerVariantId,
         minTriggerQuantity: minTriggerQuantity,
         triggerBaseQuantity: triggerBaseQuantity,
         triggerBaseUnit: triggerBaseUnit,
         title: title,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BogoOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BogoOfferRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? triggerProductId,
    Object? triggerVariantId = _Undefined,
    int? minTriggerQuantity,
    Object? triggerBaseQuantity = _Undefined,
    Object? triggerBaseUnit = _Undefined,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BogoOfferRow(
      id: id is _i1.UuidValue? ? id : this.id,
      triggerProductId: triggerProductId ?? this.triggerProductId,
      triggerVariantId: triggerVariantId is _i1.UuidValue?
          ? triggerVariantId
          : this.triggerVariantId,
      minTriggerQuantity: minTriggerQuantity ?? this.minTriggerQuantity,
      triggerBaseQuantity: triggerBaseQuantity is double?
          ? triggerBaseQuantity
          : this.triggerBaseQuantity,
      triggerBaseUnit: triggerBaseUnit is String?
          ? triggerBaseUnit
          : this.triggerBaseUnit,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BogoOfferRowUpdateTable extends _i1.UpdateTable<BogoOfferRowTable> {
  BogoOfferRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> triggerProductId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.triggerProductId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> triggerVariantId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.triggerVariantId,
    value,
  );

  _i1.ColumnValue<int, int> minTriggerQuantity(int value) => _i1.ColumnValue(
    table.minTriggerQuantity,
    value,
  );

  _i1.ColumnValue<double, double> triggerBaseQuantity(double? value) =>
      _i1.ColumnValue(
        table.triggerBaseQuantity,
        value,
      );

  _i1.ColumnValue<String, String> triggerBaseUnit(String? value) =>
      _i1.ColumnValue(
        table.triggerBaseUnit,
        value,
      );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startsAt(DateTime value) =>
      _i1.ColumnValue(
        table.startsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endsAt(DateTime value) => _i1.ColumnValue(
    table.endsAt,
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

class BogoOfferRowTable extends _i1.Table<_i1.UuidValue?> {
  BogoOfferRowTable({super.tableRelation}) : super(tableName: 'bogo_offer') {
    updateTable = BogoOfferRowUpdateTable(this);
    triggerProductId = _i1.ColumnUuid(
      'triggerProductId',
      this,
    );
    triggerVariantId = _i1.ColumnUuid(
      'triggerVariantId',
      this,
    );
    minTriggerQuantity = _i1.ColumnInt(
      'minTriggerQuantity',
      this,
      hasDefault: true,
    );
    triggerBaseQuantity = _i1.ColumnDouble(
      'triggerBaseQuantity',
      this,
    );
    triggerBaseUnit = _i1.ColumnString(
      'triggerBaseUnit',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    startsAt = _i1.ColumnDateTime(
      'startsAt',
      this,
    );
    endsAt = _i1.ColumnDateTime(
      'endsAt',
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

  late final BogoOfferRowUpdateTable updateTable;

  late final _i1.ColumnUuid triggerProductId;

  late final _i1.ColumnUuid triggerVariantId;

  late final _i1.ColumnInt minTriggerQuantity;

  late final _i1.ColumnDouble triggerBaseQuantity;

  late final _i1.ColumnString triggerBaseUnit;

  late final _i1.ColumnString title;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    triggerProductId,
    triggerVariantId,
    minTriggerQuantity,
    triggerBaseQuantity,
    triggerBaseUnit,
    title,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class BogoOfferRowInclude extends _i1.IncludeObject {
  BogoOfferRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BogoOfferRow.t;
}

class BogoOfferRowIncludeList extends _i1.IncludeList {
  BogoOfferRowIncludeList._({
    _i1.WhereExpressionBuilder<BogoOfferRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BogoOfferRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BogoOfferRow.t;
}

class BogoOfferRowRepository {
  const BogoOfferRowRepository._();

  /// Returns a list of [BogoOfferRow]s matching the given query parameters.
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
  Future<List<BogoOfferRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BogoOfferRow>(
      where: where?.call(BogoOfferRow.t),
      orderBy: orderBy?.call(BogoOfferRow.t),
      orderByList: orderByList?.call(BogoOfferRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BogoOfferRow] matching the given query parameters.
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
  Future<BogoOfferRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BogoOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BogoOfferRow>(
      where: where?.call(BogoOfferRow.t),
      orderBy: orderBy?.call(BogoOfferRow.t),
      orderByList: orderByList?.call(BogoOfferRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BogoOfferRow] by its [id] or null if no such row exists.
  Future<BogoOfferRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BogoOfferRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BogoOfferRow]s in the list and returns the inserted rows.
  ///
  /// The returned [BogoOfferRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BogoOfferRow>> insert(
    _i1.DatabaseSession session,
    List<BogoOfferRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BogoOfferRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BogoOfferRow] and returns the inserted row.
  ///
  /// The returned [BogoOfferRow] will have its `id` field set.
  Future<BogoOfferRow> insertRow(
    _i1.DatabaseSession session,
    BogoOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BogoOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BogoOfferRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BogoOfferRow>> update(
    _i1.DatabaseSession session,
    List<BogoOfferRow> rows, {
    _i1.ColumnSelections<BogoOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BogoOfferRow>(
      rows,
      columns: columns?.call(BogoOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BogoOfferRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BogoOfferRow> updateRow(
    _i1.DatabaseSession session,
    BogoOfferRow row, {
    _i1.ColumnSelections<BogoOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BogoOfferRow>(
      row,
      columns: columns?.call(BogoOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BogoOfferRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BogoOfferRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BogoOfferRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BogoOfferRow>(
      id,
      columnValues: columnValues(BogoOfferRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BogoOfferRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BogoOfferRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BogoOfferRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BogoOfferRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BogoOfferRowTable>? orderBy,
    _i1.OrderByListBuilder<BogoOfferRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BogoOfferRow>(
      columnValues: columnValues(BogoOfferRow.t.updateTable),
      where: where(BogoOfferRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BogoOfferRow.t),
      orderByList: orderByList?.call(BogoOfferRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BogoOfferRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BogoOfferRow>> delete(
    _i1.DatabaseSession session,
    List<BogoOfferRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BogoOfferRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BogoOfferRow].
  Future<BogoOfferRow> deleteRow(
    _i1.DatabaseSession session,
    BogoOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BogoOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BogoOfferRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BogoOfferRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BogoOfferRow>(
      where: where(BogoOfferRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BogoOfferRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BogoOfferRow>(
      where: where?.call(BogoOfferRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BogoOfferRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BogoOfferRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BogoOfferRow>(
      where: where(BogoOfferRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
