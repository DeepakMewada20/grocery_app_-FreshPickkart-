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

abstract class SubCategoryRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SubCategoryRow._({
    this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.imageUrl,
    int? displayOrder,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : displayOrder = displayOrder ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SubCategoryRow({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    required String slug,
    String? imageUrl,
    int? displayOrder,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SubCategoryRowImpl;

  factory SubCategoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubCategoryRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      categoryId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['categoryId'],
      ),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      displayOrder: jsonSerialization['displayOrder'] as int?,
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

  static final t = SubCategoryRowTable();

  static const db = SubCategoryRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue categoryId;

  String name;

  String slug;

  String? imageUrl;

  int displayOrder;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SubCategoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubCategoryRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? categoryId,
    String? name,
    String? slug,
    String? imageUrl,
    int? displayOrder,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubCategoryRow',
      if (id != null) 'id': id?.toJson(),
      'categoryId': categoryId.toJson(),
      'name': name,
      'slug': slug,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'displayOrder': displayOrder,
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

  static SubCategoryRowInclude include() {
    return SubCategoryRowInclude._();
  }

  static SubCategoryRowIncludeList includeList({
    _i1.WhereExpressionBuilder<SubCategoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubCategoryRowTable>? orderByList,
    SubCategoryRowInclude? include,
  }) {
    return SubCategoryRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubCategoryRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SubCategoryRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubCategoryRowImpl extends SubCategoryRow {
  _SubCategoryRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    required String slug,
    String? imageUrl,
    int? displayOrder,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         categoryId: categoryId,
         name: name,
         slug: slug,
         imageUrl: imageUrl,
         displayOrder: displayOrder,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SubCategoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubCategoryRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? categoryId,
    String? name,
    String? slug,
    Object? imageUrl = _Undefined,
    int? displayOrder,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubCategoryRow(
      id: id is _i1.UuidValue? ? id : this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SubCategoryRowUpdateTable extends _i1.UpdateTable<SubCategoryRowTable> {
  SubCategoryRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> categoryId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<int, int> displayOrder(int value) => _i1.ColumnValue(
    table.displayOrder,
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

class SubCategoryRowTable extends _i1.Table<_i1.UuidValue?> {
  SubCategoryRowTable({super.tableRelation})
    : super(tableName: 'sub_category') {
    updateTable = SubCategoryRowUpdateTable(this);
    categoryId = _i1.ColumnUuid(
      'categoryId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    displayOrder = _i1.ColumnInt(
      'displayOrder',
      this,
      hasDefault: true,
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

  late final SubCategoryRowUpdateTable updateTable;

  late final _i1.ColumnUuid categoryId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString slug;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnInt displayOrder;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    categoryId,
    name,
    slug,
    imageUrl,
    displayOrder,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class SubCategoryRowInclude extends _i1.IncludeObject {
  SubCategoryRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SubCategoryRow.t;
}

class SubCategoryRowIncludeList extends _i1.IncludeList {
  SubCategoryRowIncludeList._({
    _i1.WhereExpressionBuilder<SubCategoryRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SubCategoryRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SubCategoryRow.t;
}

class SubCategoryRowRepository {
  const SubCategoryRowRepository._();

  /// Returns a list of [SubCategoryRow]s matching the given query parameters.
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
  Future<List<SubCategoryRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubCategoryRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubCategoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SubCategoryRow>(
      where: where?.call(SubCategoryRow.t),
      orderBy: orderBy?.call(SubCategoryRow.t),
      orderByList: orderByList?.call(SubCategoryRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SubCategoryRow] matching the given query parameters.
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
  Future<SubCategoryRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubCategoryRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<SubCategoryRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubCategoryRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SubCategoryRow>(
      where: where?.call(SubCategoryRow.t),
      orderBy: orderBy?.call(SubCategoryRow.t),
      orderByList: orderByList?.call(SubCategoryRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SubCategoryRow] by its [id] or null if no such row exists.
  Future<SubCategoryRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SubCategoryRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SubCategoryRow]s in the list and returns the inserted rows.
  ///
  /// The returned [SubCategoryRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SubCategoryRow>> insert(
    _i1.DatabaseSession session,
    List<SubCategoryRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SubCategoryRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SubCategoryRow] and returns the inserted row.
  ///
  /// The returned [SubCategoryRow] will have its `id` field set.
  Future<SubCategoryRow> insertRow(
    _i1.DatabaseSession session,
    SubCategoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SubCategoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SubCategoryRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SubCategoryRow>> update(
    _i1.DatabaseSession session,
    List<SubCategoryRow> rows, {
    _i1.ColumnSelections<SubCategoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SubCategoryRow>(
      rows,
      columns: columns?.call(SubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubCategoryRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SubCategoryRow> updateRow(
    _i1.DatabaseSession session,
    SubCategoryRow row, {
    _i1.ColumnSelections<SubCategoryRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SubCategoryRow>(
      row,
      columns: columns?.call(SubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubCategoryRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SubCategoryRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SubCategoryRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SubCategoryRow>(
      id,
      columnValues: columnValues(SubCategoryRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SubCategoryRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SubCategoryRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SubCategoryRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SubCategoryRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubCategoryRowTable>? orderBy,
    _i1.OrderByListBuilder<SubCategoryRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SubCategoryRow>(
      columnValues: columnValues(SubCategoryRow.t.updateTable),
      where: where(SubCategoryRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubCategoryRow.t),
      orderByList: orderByList?.call(SubCategoryRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SubCategoryRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SubCategoryRow>> delete(
    _i1.DatabaseSession session,
    List<SubCategoryRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SubCategoryRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SubCategoryRow].
  Future<SubCategoryRow> deleteRow(
    _i1.DatabaseSession session,
    SubCategoryRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SubCategoryRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SubCategoryRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SubCategoryRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SubCategoryRow>(
      where: where(SubCategoryRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubCategoryRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SubCategoryRow>(
      where: where?.call(SubCategoryRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SubCategoryRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SubCategoryRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SubCategoryRow>(
      where: where(SubCategoryRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
