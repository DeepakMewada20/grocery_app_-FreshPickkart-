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

abstract class DeliverySettingsRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  DeliverySettingsRow._({
    this.id,
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  }) : defaultVerificationMethod = defaultVerificationMethod ?? 'otp',
       cameraOnlyCapture = cameraOnlyCapture ?? true,
       gpsRequired = gpsRequired ?? true,
       strictDistanceValidation = strictDistanceValidation ?? true,
       maxAllowedRadiusMeters = maxAllowedRadiusMeters ?? 200,
       updatedAt = updatedAt ?? DateTime.now();

  factory DeliverySettingsRow({
    _i1.UuidValue? id,
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  }) = _DeliverySettingsRowImpl;

  factory DeliverySettingsRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliverySettingsRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      defaultVerificationMethod:
          jsonSerialization['defaultVerificationMethod'] as String?,
      cameraOnlyCapture: jsonSerialization['cameraOnlyCapture'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['cameraOnlyCapture'],
            ),
      gpsRequired: jsonSerialization['gpsRequired'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['gpsRequired']),
      strictDistanceValidation:
          jsonSerialization['strictDistanceValidation'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['strictDistanceValidation'],
            ),
      maxAllowedRadiusMeters:
          jsonSerialization['maxAllowedRadiusMeters'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeliverySettingsRowTable();

  static const db = DeliverySettingsRowRepository._();

  @override
  _i1.UuidValue? id;

  String defaultVerificationMethod;

  bool cameraOnlyCapture;

  bool gpsRequired;

  bool strictDistanceValidation;

  int maxAllowedRadiusMeters;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeliverySettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliverySettingsRow copyWith({
    _i1.UuidValue? id,
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliverySettingsRow',
      if (id != null) 'id': id?.toJson(),
      'defaultVerificationMethod': defaultVerificationMethod,
      'cameraOnlyCapture': cameraOnlyCapture,
      'gpsRequired': gpsRequired,
      'strictDistanceValidation': strictDistanceValidation,
      'maxAllowedRadiusMeters': maxAllowedRadiusMeters,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static DeliverySettingsRowInclude include() {
    return DeliverySettingsRowInclude._();
  }

  static DeliverySettingsRowIncludeList includeList({
    _i1.WhereExpressionBuilder<DeliverySettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySettingsRowTable>? orderByList,
    DeliverySettingsRowInclude? include,
  }) {
    return DeliverySettingsRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliverySettingsRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeliverySettingsRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliverySettingsRowImpl extends DeliverySettingsRow {
  _DeliverySettingsRowImpl({
    _i1.UuidValue? id,
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         defaultVerificationMethod: defaultVerificationMethod,
         cameraOnlyCapture: cameraOnlyCapture,
         gpsRequired: gpsRequired,
         strictDistanceValidation: strictDistanceValidation,
         maxAllowedRadiusMeters: maxAllowedRadiusMeters,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliverySettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliverySettingsRow copyWith({
    Object? id = _Undefined,
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  }) {
    return DeliverySettingsRow(
      id: id is _i1.UuidValue? ? id : this.id,
      defaultVerificationMethod:
          defaultVerificationMethod ?? this.defaultVerificationMethod,
      cameraOnlyCapture: cameraOnlyCapture ?? this.cameraOnlyCapture,
      gpsRequired: gpsRequired ?? this.gpsRequired,
      strictDistanceValidation:
          strictDistanceValidation ?? this.strictDistanceValidation,
      maxAllowedRadiusMeters:
          maxAllowedRadiusMeters ?? this.maxAllowedRadiusMeters,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DeliverySettingsRowUpdateTable
    extends _i1.UpdateTable<DeliverySettingsRowTable> {
  DeliverySettingsRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> defaultVerificationMethod(String value) =>
      _i1.ColumnValue(
        table.defaultVerificationMethod,
        value,
      );

  _i1.ColumnValue<bool, bool> cameraOnlyCapture(bool value) => _i1.ColumnValue(
    table.cameraOnlyCapture,
    value,
  );

  _i1.ColumnValue<bool, bool> gpsRequired(bool value) => _i1.ColumnValue(
    table.gpsRequired,
    value,
  );

  _i1.ColumnValue<bool, bool> strictDistanceValidation(bool value) =>
      _i1.ColumnValue(
        table.strictDistanceValidation,
        value,
      );

  _i1.ColumnValue<int, int> maxAllowedRadiusMeters(int value) =>
      _i1.ColumnValue(
        table.maxAllowedRadiusMeters,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class DeliverySettingsRowTable extends _i1.Table<_i1.UuidValue?> {
  DeliverySettingsRowTable({super.tableRelation})
    : super(tableName: 'delivery_settings') {
    updateTable = DeliverySettingsRowUpdateTable(this);
    defaultVerificationMethod = _i1.ColumnString(
      'defaultVerificationMethod',
      this,
      hasDefault: true,
    );
    cameraOnlyCapture = _i1.ColumnBool(
      'cameraOnlyCapture',
      this,
      hasDefault: true,
    );
    gpsRequired = _i1.ColumnBool(
      'gpsRequired',
      this,
      hasDefault: true,
    );
    strictDistanceValidation = _i1.ColumnBool(
      'strictDistanceValidation',
      this,
      hasDefault: true,
    );
    maxAllowedRadiusMeters = _i1.ColumnInt(
      'maxAllowedRadiusMeters',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final DeliverySettingsRowUpdateTable updateTable;

  late final _i1.ColumnString defaultVerificationMethod;

  late final _i1.ColumnBool cameraOnlyCapture;

  late final _i1.ColumnBool gpsRequired;

  late final _i1.ColumnBool strictDistanceValidation;

  late final _i1.ColumnInt maxAllowedRadiusMeters;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    defaultVerificationMethod,
    cameraOnlyCapture,
    gpsRequired,
    strictDistanceValidation,
    maxAllowedRadiusMeters,
    updatedAt,
  ];
}

class DeliverySettingsRowInclude extends _i1.IncludeObject {
  DeliverySettingsRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliverySettingsRow.t;
}

class DeliverySettingsRowIncludeList extends _i1.IncludeList {
  DeliverySettingsRowIncludeList._({
    _i1.WhereExpressionBuilder<DeliverySettingsRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeliverySettingsRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => DeliverySettingsRow.t;
}

class DeliverySettingsRowRepository {
  const DeliverySettingsRowRepository._();

  /// Returns a list of [DeliverySettingsRow]s matching the given query parameters.
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
  Future<List<DeliverySettingsRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeliverySettingsRow>(
      where: where?.call(DeliverySettingsRow.t),
      orderBy: orderBy?.call(DeliverySettingsRow.t),
      orderByList: orderByList?.call(DeliverySettingsRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeliverySettingsRow] matching the given query parameters.
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
  Future<DeliverySettingsRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySettingsRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeliverySettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeliverySettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeliverySettingsRow>(
      where: where?.call(DeliverySettingsRow.t),
      orderBy: orderBy?.call(DeliverySettingsRow.t),
      orderByList: orderByList?.call(DeliverySettingsRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeliverySettingsRow] by its [id] or null if no such row exists.
  Future<DeliverySettingsRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeliverySettingsRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeliverySettingsRow]s in the list and returns the inserted rows.
  ///
  /// The returned [DeliverySettingsRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeliverySettingsRow>> insert(
    _i1.DatabaseSession session,
    List<DeliverySettingsRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeliverySettingsRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeliverySettingsRow] and returns the inserted row.
  ///
  /// The returned [DeliverySettingsRow] will have its `id` field set.
  Future<DeliverySettingsRow> insertRow(
    _i1.DatabaseSession session,
    DeliverySettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeliverySettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeliverySettingsRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeliverySettingsRow>> update(
    _i1.DatabaseSession session,
    List<DeliverySettingsRow> rows, {
    _i1.ColumnSelections<DeliverySettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeliverySettingsRow>(
      rows,
      columns: columns?.call(DeliverySettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliverySettingsRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeliverySettingsRow> updateRow(
    _i1.DatabaseSession session,
    DeliverySettingsRow row, {
    _i1.ColumnSelections<DeliverySettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeliverySettingsRow>(
      row,
      columns: columns?.call(DeliverySettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeliverySettingsRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeliverySettingsRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DeliverySettingsRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeliverySettingsRow>(
      id,
      columnValues: columnValues(DeliverySettingsRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeliverySettingsRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeliverySettingsRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeliverySettingsRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeliverySettingsRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeliverySettingsRowTable>? orderBy,
    _i1.OrderByListBuilder<DeliverySettingsRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeliverySettingsRow>(
      columnValues: columnValues(DeliverySettingsRow.t.updateTable),
      where: where(DeliverySettingsRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeliverySettingsRow.t),
      orderByList: orderByList?.call(DeliverySettingsRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeliverySettingsRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeliverySettingsRow>> delete(
    _i1.DatabaseSession session,
    List<DeliverySettingsRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeliverySettingsRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeliverySettingsRow].
  Future<DeliverySettingsRow> deleteRow(
    _i1.DatabaseSession session,
    DeliverySettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeliverySettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeliverySettingsRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliverySettingsRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeliverySettingsRow>(
      where: where(DeliverySettingsRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeliverySettingsRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeliverySettingsRow>(
      where: where?.call(DeliverySettingsRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeliverySettingsRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeliverySettingsRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeliverySettingsRow>(
      where: where(DeliverySettingsRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
