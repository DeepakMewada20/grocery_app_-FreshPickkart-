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

abstract class ShopMoreGetMoreOfferRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ShopMoreGetMoreOfferRow._({
    this.id,
    required this.name,
    double? minimumOrderAmount,
    required this.freeProductId,
    this.freeVariantId,
    int? freeQuantity,
    int? priority,
    required this.startsAt,
    required this.endsAt,
    String? status,
    this.deactivatedAt,
    this.createdBy,
    this.updatedBy,
    this.activatedBy,
    this.deactivatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : minimumOrderAmount = minimumOrderAmount ?? 0.0,
       freeQuantity = freeQuantity ?? 1,
       priority = priority ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ShopMoreGetMoreOfferRow({
    _i1.UuidValue? id,
    required String name,
    double? minimumOrderAmount,
    required _i1.UuidValue freeProductId,
    _i1.UuidValue? freeVariantId,
    int? freeQuantity,
    int? priority,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShopMoreGetMoreOfferRowImpl;

  factory ShopMoreGetMoreOfferRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShopMoreGetMoreOfferRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      minimumOrderAmount: (jsonSerialization['minimumOrderAmount'] as num?)
          ?.toDouble(),
      freeProductId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['freeProductId'],
      ),
      freeVariantId: jsonSerialization['freeVariantId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['freeVariantId'],
            ),
      freeQuantity: jsonSerialization['freeQuantity'] as int?,
      priority: jsonSerialization['priority'] as int?,
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
      createdBy: jsonSerialization['createdBy'] as String?,
      updatedBy: jsonSerialization['updatedBy'] as String?,
      activatedBy: jsonSerialization['activatedBy'] as String?,
      deactivatedBy: jsonSerialization['deactivatedBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ShopMoreGetMoreOfferRowTable();

  static const db = ShopMoreGetMoreOfferRowRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  double minimumOrderAmount;

  _i1.UuidValue freeProductId;

  _i1.UuidValue? freeVariantId;

  int freeQuantity;

  int priority;

  DateTime startsAt;

  DateTime endsAt;

  String status;

  DateTime? deactivatedAt;

  String? createdBy;

  String? updatedBy;

  String? activatedBy;

  String? deactivatedBy;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ShopMoreGetMoreOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShopMoreGetMoreOfferRow copyWith({
    _i1.UuidValue? id,
    String? name,
    double? minimumOrderAmount,
    _i1.UuidValue? freeProductId,
    _i1.UuidValue? freeVariantId,
    int? freeQuantity,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopMoreGetMoreOfferRow',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'minimumOrderAmount': minimumOrderAmount,
      'freeProductId': freeProductId.toJson(),
      if (freeVariantId != null) 'freeVariantId': freeVariantId?.toJson(),
      'freeQuantity': freeQuantity,
      'priority': priority,
      'startsAt': startsAt.toJson(),
      'endsAt': endsAt.toJson(),
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (activatedBy != null) 'activatedBy': activatedBy,
      if (deactivatedBy != null) 'deactivatedBy': deactivatedBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ShopMoreGetMoreOfferRowInclude include() {
    return ShopMoreGetMoreOfferRowInclude._();
  }

  static ShopMoreGetMoreOfferRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShopMoreGetMoreOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShopMoreGetMoreOfferRowTable>? orderByList,
    ShopMoreGetMoreOfferRowInclude? include,
  }) {
    return ShopMoreGetMoreOfferRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopMoreGetMoreOfferRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShopMoreGetMoreOfferRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopMoreGetMoreOfferRowImpl extends ShopMoreGetMoreOfferRow {
  _ShopMoreGetMoreOfferRowImpl({
    _i1.UuidValue? id,
    required String name,
    double? minimumOrderAmount,
    required _i1.UuidValue freeProductId,
    _i1.UuidValue? freeVariantId,
    int? freeQuantity,
    int? priority,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         minimumOrderAmount: minimumOrderAmount,
         freeProductId: freeProductId,
         freeVariantId: freeVariantId,
         freeQuantity: freeQuantity,
         priority: priority,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdBy: createdBy,
         updatedBy: updatedBy,
         activatedBy: activatedBy,
         deactivatedBy: deactivatedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ShopMoreGetMoreOfferRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShopMoreGetMoreOfferRow copyWith({
    Object? id = _Undefined,
    String? name,
    double? minimumOrderAmount,
    _i1.UuidValue? freeProductId,
    Object? freeVariantId = _Undefined,
    int? freeQuantity,
    int? priority,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    Object? deactivatedAt = _Undefined,
    Object? createdBy = _Undefined,
    Object? updatedBy = _Undefined,
    Object? activatedBy = _Undefined,
    Object? deactivatedBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopMoreGetMoreOfferRow(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      freeProductId: freeProductId ?? this.freeProductId,
      freeVariantId: freeVariantId is _i1.UuidValue?
          ? freeVariantId
          : this.freeVariantId,
      freeQuantity: freeQuantity ?? this.freeQuantity,
      priority: priority ?? this.priority,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      updatedBy: updatedBy is String? ? updatedBy : this.updatedBy,
      activatedBy: activatedBy is String? ? activatedBy : this.activatedBy,
      deactivatedBy: deactivatedBy is String?
          ? deactivatedBy
          : this.deactivatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ShopMoreGetMoreOfferRowUpdateTable
    extends _i1.UpdateTable<ShopMoreGetMoreOfferRowTable> {
  ShopMoreGetMoreOfferRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<double, double> minimumOrderAmount(double value) =>
      _i1.ColumnValue(
        table.minimumOrderAmount,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> freeProductId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.freeProductId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> freeVariantId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.freeVariantId,
    value,
  );

  _i1.ColumnValue<int, int> freeQuantity(int value) => _i1.ColumnValue(
    table.freeQuantity,
    value,
  );

  _i1.ColumnValue<int, int> priority(int value) => _i1.ColumnValue(
    table.priority,
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

  _i1.ColumnValue<String, String> createdBy(String? value) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<String, String> updatedBy(String? value) => _i1.ColumnValue(
    table.updatedBy,
    value,
  );

  _i1.ColumnValue<String, String> activatedBy(String? value) => _i1.ColumnValue(
    table.activatedBy,
    value,
  );

  _i1.ColumnValue<String, String> deactivatedBy(String? value) =>
      _i1.ColumnValue(
        table.deactivatedBy,
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

class ShopMoreGetMoreOfferRowTable extends _i1.Table<_i1.UuidValue?> {
  ShopMoreGetMoreOfferRowTable({super.tableRelation})
    : super(tableName: 'shop_more_get_more_offer') {
    updateTable = ShopMoreGetMoreOfferRowUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    minimumOrderAmount = _i1.ColumnDouble(
      'minimumOrderAmount',
      this,
      hasDefault: true,
    );
    freeProductId = _i1.ColumnUuid(
      'freeProductId',
      this,
    );
    freeVariantId = _i1.ColumnUuid(
      'freeVariantId',
      this,
    );
    freeQuantity = _i1.ColumnInt(
      'freeQuantity',
      this,
      hasDefault: true,
    );
    priority = _i1.ColumnInt(
      'priority',
      this,
      hasDefault: true,
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
    createdBy = _i1.ColumnString(
      'createdBy',
      this,
    );
    updatedBy = _i1.ColumnString(
      'updatedBy',
      this,
    );
    activatedBy = _i1.ColumnString(
      'activatedBy',
      this,
    );
    deactivatedBy = _i1.ColumnString(
      'deactivatedBy',
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

  late final ShopMoreGetMoreOfferRowUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnDouble minimumOrderAmount;

  late final _i1.ColumnUuid freeProductId;

  late final _i1.ColumnUuid freeVariantId;

  late final _i1.ColumnInt freeQuantity;

  late final _i1.ColumnInt priority;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnString createdBy;

  late final _i1.ColumnString updatedBy;

  late final _i1.ColumnString activatedBy;

  late final _i1.ColumnString deactivatedBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    minimumOrderAmount,
    freeProductId,
    freeVariantId,
    freeQuantity,
    priority,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdBy,
    updatedBy,
    activatedBy,
    deactivatedBy,
    createdAt,
    updatedAt,
  ];
}

class ShopMoreGetMoreOfferRowInclude extends _i1.IncludeObject {
  ShopMoreGetMoreOfferRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ShopMoreGetMoreOfferRow.t;
}

class ShopMoreGetMoreOfferRowIncludeList extends _i1.IncludeList {
  ShopMoreGetMoreOfferRowIncludeList._({
    _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShopMoreGetMoreOfferRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ShopMoreGetMoreOfferRow.t;
}

class ShopMoreGetMoreOfferRowRepository {
  const ShopMoreGetMoreOfferRowRepository._();

  /// Returns a list of [ShopMoreGetMoreOfferRow]s matching the given query parameters.
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
  Future<List<ShopMoreGetMoreOfferRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShopMoreGetMoreOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShopMoreGetMoreOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ShopMoreGetMoreOfferRow>(
      where: where?.call(ShopMoreGetMoreOfferRow.t),
      orderBy: orderBy?.call(ShopMoreGetMoreOfferRow.t),
      orderByList: orderByList?.call(ShopMoreGetMoreOfferRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ShopMoreGetMoreOfferRow] matching the given query parameters.
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
  Future<ShopMoreGetMoreOfferRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShopMoreGetMoreOfferRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShopMoreGetMoreOfferRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ShopMoreGetMoreOfferRow>(
      where: where?.call(ShopMoreGetMoreOfferRow.t),
      orderBy: orderBy?.call(ShopMoreGetMoreOfferRow.t),
      orderByList: orderByList?.call(ShopMoreGetMoreOfferRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ShopMoreGetMoreOfferRow] by its [id] or null if no such row exists.
  Future<ShopMoreGetMoreOfferRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ShopMoreGetMoreOfferRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ShopMoreGetMoreOfferRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ShopMoreGetMoreOfferRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ShopMoreGetMoreOfferRow>> insert(
    _i1.DatabaseSession session,
    List<ShopMoreGetMoreOfferRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ShopMoreGetMoreOfferRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ShopMoreGetMoreOfferRow] and returns the inserted row.
  ///
  /// The returned [ShopMoreGetMoreOfferRow] will have its `id` field set.
  Future<ShopMoreGetMoreOfferRow> insertRow(
    _i1.DatabaseSession session,
    ShopMoreGetMoreOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShopMoreGetMoreOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShopMoreGetMoreOfferRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShopMoreGetMoreOfferRow>> update(
    _i1.DatabaseSession session,
    List<ShopMoreGetMoreOfferRow> rows, {
    _i1.ColumnSelections<ShopMoreGetMoreOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShopMoreGetMoreOfferRow>(
      rows,
      columns: columns?.call(ShopMoreGetMoreOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShopMoreGetMoreOfferRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShopMoreGetMoreOfferRow> updateRow(
    _i1.DatabaseSession session,
    ShopMoreGetMoreOfferRow row, {
    _i1.ColumnSelections<ShopMoreGetMoreOfferRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShopMoreGetMoreOfferRow>(
      row,
      columns: columns?.call(ShopMoreGetMoreOfferRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShopMoreGetMoreOfferRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShopMoreGetMoreOfferRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ShopMoreGetMoreOfferRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShopMoreGetMoreOfferRow>(
      id,
      columnValues: columnValues(ShopMoreGetMoreOfferRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShopMoreGetMoreOfferRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShopMoreGetMoreOfferRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ShopMoreGetMoreOfferRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShopMoreGetMoreOfferRowTable>? orderBy,
    _i1.OrderByListBuilder<ShopMoreGetMoreOfferRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShopMoreGetMoreOfferRow>(
      columnValues: columnValues(ShopMoreGetMoreOfferRow.t.updateTable),
      where: where(ShopMoreGetMoreOfferRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopMoreGetMoreOfferRow.t),
      orderByList: orderByList?.call(ShopMoreGetMoreOfferRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShopMoreGetMoreOfferRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShopMoreGetMoreOfferRow>> delete(
    _i1.DatabaseSession session,
    List<ShopMoreGetMoreOfferRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShopMoreGetMoreOfferRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShopMoreGetMoreOfferRow].
  Future<ShopMoreGetMoreOfferRow> deleteRow(
    _i1.DatabaseSession session,
    ShopMoreGetMoreOfferRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShopMoreGetMoreOfferRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShopMoreGetMoreOfferRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShopMoreGetMoreOfferRow>(
      where: where(ShopMoreGetMoreOfferRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShopMoreGetMoreOfferRow>(
      where: where?.call(ShopMoreGetMoreOfferRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ShopMoreGetMoreOfferRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ShopMoreGetMoreOfferRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ShopMoreGetMoreOfferRow>(
      where: where(ShopMoreGetMoreOfferRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
