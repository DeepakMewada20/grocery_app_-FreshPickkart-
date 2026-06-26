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

abstract class FreshPointsSettingsRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  FreshPointsSettingsRow._({
    this.id,
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    this.lastUpdatedBy,
    DateTime? updatedAt,
  }) : isEnabled = isEnabled ?? true,
       redemptionPercentageLimit = redemptionPercentageLimit ?? 50.0,
       allowRedemptionOnCOD = allowRedemptionOnCOD ?? true,
       minimumOrderForRedemption = minimumOrderForRedemption ?? 0.0,
       enablePointExpiry = enablePointExpiry ?? false,
       pointExpiryDays = pointExpiryDays ?? 90,
       enableAdminAdjustments = enableAdminAdjustments ?? true,
       updatedAt = updatedAt ?? DateTime.now();

  factory FreshPointsSettingsRow({
    _i1.UuidValue? id,
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    _i1.UuidValue? lastUpdatedBy,
    DateTime? updatedAt,
  }) = _FreshPointsSettingsRowImpl;

  factory FreshPointsSettingsRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FreshPointsSettingsRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      isEnabled: jsonSerialization['isEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      redemptionPercentageLimit:
          (jsonSerialization['redemptionPercentageLimit'] as num?)?.toDouble(),
      allowRedemptionOnCOD: jsonSerialization['allowRedemptionOnCOD'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['allowRedemptionOnCOD'],
            ),
      minimumOrderForRedemption:
          (jsonSerialization['minimumOrderForRedemption'] as num?)?.toDouble(),
      enablePointExpiry: jsonSerialization['enablePointExpiry'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enablePointExpiry'],
            ),
      pointExpiryDays: jsonSerialization['pointExpiryDays'] as int?,
      enableAdminAdjustments:
          jsonSerialization['enableAdminAdjustments'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableAdminAdjustments'],
            ),
      lastUpdatedBy: jsonSerialization['lastUpdatedBy'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastUpdatedBy'],
            ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = FreshPointsSettingsRowTable();

  static const db = FreshPointsSettingsRowRepository._();

  @override
  _i1.UuidValue? id;

  bool isEnabled;

  double redemptionPercentageLimit;

  bool allowRedemptionOnCOD;

  double minimumOrderForRedemption;

  bool enablePointExpiry;

  int pointExpiryDays;

  bool enableAdminAdjustments;

  _i1.UuidValue? lastUpdatedBy;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FreshPointsSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsSettingsRow copyWith({
    _i1.UuidValue? id,
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    _i1.UuidValue? lastUpdatedBy,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsSettingsRow',
      if (id != null) 'id': id?.toJson(),
      'isEnabled': isEnabled,
      'redemptionPercentageLimit': redemptionPercentageLimit,
      'allowRedemptionOnCOD': allowRedemptionOnCOD,
      'minimumOrderForRedemption': minimumOrderForRedemption,
      'enablePointExpiry': enablePointExpiry,
      'pointExpiryDays': pointExpiryDays,
      'enableAdminAdjustments': enableAdminAdjustments,
      if (lastUpdatedBy != null) 'lastUpdatedBy': lastUpdatedBy?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FreshPointsSettingsRowInclude include() {
    return FreshPointsSettingsRowInclude._();
  }

  static FreshPointsSettingsRowIncludeList includeList({
    _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsSettingsRowTable>? orderByList,
    FreshPointsSettingsRowInclude? include,
  }) {
    return FreshPointsSettingsRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreshPointsSettingsRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FreshPointsSettingsRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreshPointsSettingsRowImpl extends FreshPointsSettingsRow {
  _FreshPointsSettingsRowImpl({
    _i1.UuidValue? id,
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    _i1.UuidValue? lastUpdatedBy,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         isEnabled: isEnabled,
         redemptionPercentageLimit: redemptionPercentageLimit,
         allowRedemptionOnCOD: allowRedemptionOnCOD,
         minimumOrderForRedemption: minimumOrderForRedemption,
         enablePointExpiry: enablePointExpiry,
         pointExpiryDays: pointExpiryDays,
         enableAdminAdjustments: enableAdminAdjustments,
         lastUpdatedBy: lastUpdatedBy,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FreshPointsSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsSettingsRow copyWith({
    Object? id = _Undefined,
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    Object? lastUpdatedBy = _Undefined,
    DateTime? updatedAt,
  }) {
    return FreshPointsSettingsRow(
      id: id is _i1.UuidValue? ? id : this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      redemptionPercentageLimit:
          redemptionPercentageLimit ?? this.redemptionPercentageLimit,
      allowRedemptionOnCOD: allowRedemptionOnCOD ?? this.allowRedemptionOnCOD,
      minimumOrderForRedemption:
          minimumOrderForRedemption ?? this.minimumOrderForRedemption,
      enablePointExpiry: enablePointExpiry ?? this.enablePointExpiry,
      pointExpiryDays: pointExpiryDays ?? this.pointExpiryDays,
      enableAdminAdjustments:
          enableAdminAdjustments ?? this.enableAdminAdjustments,
      lastUpdatedBy: lastUpdatedBy is _i1.UuidValue?
          ? lastUpdatedBy
          : this.lastUpdatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FreshPointsSettingsRowUpdateTable
    extends _i1.UpdateTable<FreshPointsSettingsRowTable> {
  FreshPointsSettingsRowUpdateTable(super.table);

  _i1.ColumnValue<bool, bool> isEnabled(bool value) => _i1.ColumnValue(
    table.isEnabled,
    value,
  );

  _i1.ColumnValue<double, double> redemptionPercentageLimit(double value) =>
      _i1.ColumnValue(
        table.redemptionPercentageLimit,
        value,
      );

  _i1.ColumnValue<bool, bool> allowRedemptionOnCOD(bool value) =>
      _i1.ColumnValue(
        table.allowRedemptionOnCOD,
        value,
      );

  _i1.ColumnValue<double, double> minimumOrderForRedemption(double value) =>
      _i1.ColumnValue(
        table.minimumOrderForRedemption,
        value,
      );

  _i1.ColumnValue<bool, bool> enablePointExpiry(bool value) => _i1.ColumnValue(
    table.enablePointExpiry,
    value,
  );

  _i1.ColumnValue<int, int> pointExpiryDays(int value) => _i1.ColumnValue(
    table.pointExpiryDays,
    value,
  );

  _i1.ColumnValue<bool, bool> enableAdminAdjustments(bool value) =>
      _i1.ColumnValue(
        table.enableAdminAdjustments,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> lastUpdatedBy(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.lastUpdatedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class FreshPointsSettingsRowTable extends _i1.Table<_i1.UuidValue?> {
  FreshPointsSettingsRowTable({super.tableRelation})
    : super(tableName: 'fresh_points_settings') {
    updateTable = FreshPointsSettingsRowUpdateTable(this);
    isEnabled = _i1.ColumnBool(
      'isEnabled',
      this,
      hasDefault: true,
    );
    redemptionPercentageLimit = _i1.ColumnDouble(
      'redemptionPercentageLimit',
      this,
      hasDefault: true,
    );
    allowRedemptionOnCOD = _i1.ColumnBool(
      'allowRedemptionOnCOD',
      this,
      hasDefault: true,
    );
    minimumOrderForRedemption = _i1.ColumnDouble(
      'minimumOrderForRedemption',
      this,
      hasDefault: true,
    );
    enablePointExpiry = _i1.ColumnBool(
      'enablePointExpiry',
      this,
      hasDefault: true,
    );
    pointExpiryDays = _i1.ColumnInt(
      'pointExpiryDays',
      this,
      hasDefault: true,
    );
    enableAdminAdjustments = _i1.ColumnBool(
      'enableAdminAdjustments',
      this,
      hasDefault: true,
    );
    lastUpdatedBy = _i1.ColumnUuid(
      'lastUpdatedBy',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final FreshPointsSettingsRowUpdateTable updateTable;

  late final _i1.ColumnBool isEnabled;

  late final _i1.ColumnDouble redemptionPercentageLimit;

  late final _i1.ColumnBool allowRedemptionOnCOD;

  late final _i1.ColumnDouble minimumOrderForRedemption;

  late final _i1.ColumnBool enablePointExpiry;

  late final _i1.ColumnInt pointExpiryDays;

  late final _i1.ColumnBool enableAdminAdjustments;

  late final _i1.ColumnUuid lastUpdatedBy;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    isEnabled,
    redemptionPercentageLimit,
    allowRedemptionOnCOD,
    minimumOrderForRedemption,
    enablePointExpiry,
    pointExpiryDays,
    enableAdminAdjustments,
    lastUpdatedBy,
    updatedAt,
  ];
}

class FreshPointsSettingsRowInclude extends _i1.IncludeObject {
  FreshPointsSettingsRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreshPointsSettingsRow.t;
}

class FreshPointsSettingsRowIncludeList extends _i1.IncludeList {
  FreshPointsSettingsRowIncludeList._({
    _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FreshPointsSettingsRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FreshPointsSettingsRow.t;
}

class FreshPointsSettingsRowRepository {
  const FreshPointsSettingsRowRepository._();

  /// Returns a list of [FreshPointsSettingsRow]s matching the given query parameters.
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
  Future<List<FreshPointsSettingsRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FreshPointsSettingsRow>(
      where: where?.call(FreshPointsSettingsRow.t),
      orderBy: orderBy?.call(FreshPointsSettingsRow.t),
      orderByList: orderByList?.call(FreshPointsSettingsRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FreshPointsSettingsRow] matching the given query parameters.
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
  Future<FreshPointsSettingsRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<FreshPointsSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FreshPointsSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FreshPointsSettingsRow>(
      where: where?.call(FreshPointsSettingsRow.t),
      orderBy: orderBy?.call(FreshPointsSettingsRow.t),
      orderByList: orderByList?.call(FreshPointsSettingsRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FreshPointsSettingsRow] by its [id] or null if no such row exists.
  Future<FreshPointsSettingsRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FreshPointsSettingsRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FreshPointsSettingsRow]s in the list and returns the inserted rows.
  ///
  /// The returned [FreshPointsSettingsRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FreshPointsSettingsRow>> insert(
    _i1.DatabaseSession session,
    List<FreshPointsSettingsRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FreshPointsSettingsRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FreshPointsSettingsRow] and returns the inserted row.
  ///
  /// The returned [FreshPointsSettingsRow] will have its `id` field set.
  Future<FreshPointsSettingsRow> insertRow(
    _i1.DatabaseSession session,
    FreshPointsSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FreshPointsSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FreshPointsSettingsRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FreshPointsSettingsRow>> update(
    _i1.DatabaseSession session,
    List<FreshPointsSettingsRow> rows, {
    _i1.ColumnSelections<FreshPointsSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FreshPointsSettingsRow>(
      rows,
      columns: columns?.call(FreshPointsSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreshPointsSettingsRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FreshPointsSettingsRow> updateRow(
    _i1.DatabaseSession session,
    FreshPointsSettingsRow row, {
    _i1.ColumnSelections<FreshPointsSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FreshPointsSettingsRow>(
      row,
      columns: columns?.call(FreshPointsSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FreshPointsSettingsRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FreshPointsSettingsRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<FreshPointsSettingsRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FreshPointsSettingsRow>(
      id,
      columnValues: columnValues(FreshPointsSettingsRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FreshPointsSettingsRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FreshPointsSettingsRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FreshPointsSettingsRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FreshPointsSettingsRowTable>? orderBy,
    _i1.OrderByListBuilder<FreshPointsSettingsRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FreshPointsSettingsRow>(
      columnValues: columnValues(FreshPointsSettingsRow.t.updateTable),
      where: where(FreshPointsSettingsRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FreshPointsSettingsRow.t),
      orderByList: orderByList?.call(FreshPointsSettingsRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FreshPointsSettingsRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FreshPointsSettingsRow>> delete(
    _i1.DatabaseSession session,
    List<FreshPointsSettingsRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FreshPointsSettingsRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FreshPointsSettingsRow].
  Future<FreshPointsSettingsRow> deleteRow(
    _i1.DatabaseSession session,
    FreshPointsSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FreshPointsSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FreshPointsSettingsRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FreshPointsSettingsRow>(
      where: where(FreshPointsSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FreshPointsSettingsRow>(
      where: where?.call(FreshPointsSettingsRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FreshPointsSettingsRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FreshPointsSettingsRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FreshPointsSettingsRow>(
      where: where(FreshPointsSettingsRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
