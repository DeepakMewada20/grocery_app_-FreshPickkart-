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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

abstract class ComplaintRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ComplaintRow._({
    this.id,
    required this.userId,
    required this.orderId,
    required this.orderItemId,
    required this.issueType,
    required this.description,
    required this.imageUrls,
    String? status,
    this.adminReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'Pending',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ComplaintRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue orderId,
    required _i1.UuidValue orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
    String? status,
    String? adminReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ComplaintRowImpl;

  factory ComplaintRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComplaintRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      orderItemId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderItemId'],
      ),
      issueType: jsonSerialization['issueType'] as String,
      description: jsonSerialization['description'] as String,
      imageUrls: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['imageUrls'],
      ),
      status: jsonSerialization['status'] as String?,
      adminReply: jsonSerialization['adminReply'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ComplaintRowTable();

  static const db = ComplaintRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i1.UuidValue orderId;

  _i1.UuidValue orderItemId;

  String issueType;

  String description;

  List<String> imageUrls;

  String status;

  String? adminReply;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ComplaintRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplaintRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? orderId,
    _i1.UuidValue? orderItemId,
    String? issueType,
    String? description,
    List<String>? imageUrls,
    String? status,
    String? adminReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplaintRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'orderId': orderId.toJson(),
      'orderItemId': orderItemId.toJson(),
      'issueType': issueType,
      'description': description,
      'imageUrls': imageUrls.toJson(),
      'status': status,
      if (adminReply != null) 'adminReply': adminReply,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ComplaintRowInclude include() {
    return ComplaintRowInclude._();
  }

  static ComplaintRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ComplaintRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintRowTable>? orderByList,
    ComplaintRowInclude? include,
  }) {
    return ComplaintRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplaintRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ComplaintRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintRowImpl extends ComplaintRow {
  _ComplaintRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue orderId,
    required _i1.UuidValue orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
    String? status,
    String? adminReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         orderId: orderId,
         orderItemId: orderItemId,
         issueType: issueType,
         description: description,
         imageUrls: imageUrls,
         status: status,
         adminReply: adminReply,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ComplaintRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplaintRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    _i1.UuidValue? orderId,
    _i1.UuidValue? orderItemId,
    String? issueType,
    String? description,
    List<String>? imageUrls,
    String? status,
    Object? adminReply = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplaintRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      orderItemId: orderItemId ?? this.orderItemId,
      issueType: issueType ?? this.issueType,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls.map((e0) => e0).toList(),
      status: status ?? this.status,
      adminReply: adminReply is String? ? adminReply : this.adminReply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComplaintRowUpdateTable extends _i1.UpdateTable<ComplaintRowTable> {
  ComplaintRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderItemId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.orderItemId,
    value,
  );

  _i1.ColumnValue<String, String> issueType(String value) => _i1.ColumnValue(
    table.issueType,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> imageUrls(List<String> value) =>
      _i1.ColumnValue(
        table.imageUrls,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> adminReply(String? value) => _i1.ColumnValue(
    table.adminReply,
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

class ComplaintRowTable extends _i1.Table<_i1.UuidValue?> {
  ComplaintRowTable({super.tableRelation}) : super(tableName: 'complaint') {
    updateTable = ComplaintRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    orderItemId = _i1.ColumnUuid(
      'orderItemId',
      this,
    );
    issueType = _i1.ColumnString(
      'issueType',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    imageUrls = _i1.ColumnSerializable<List<String>>(
      'imageUrls',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    adminReply = _i1.ColumnString(
      'adminReply',
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

  late final ComplaintRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid orderItemId;

  late final _i1.ColumnString issueType;

  late final _i1.ColumnString description;

  late final _i1.ColumnSerializable<List<String>> imageUrls;

  late final _i1.ColumnString status;

  late final _i1.ColumnString adminReply;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    orderId,
    orderItemId,
    issueType,
    description,
    imageUrls,
    status,
    adminReply,
    createdAt,
    updatedAt,
  ];
}

class ComplaintRowInclude extends _i1.IncludeObject {
  ComplaintRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComplaintRow.t;
}

class ComplaintRowIncludeList extends _i1.IncludeList {
  ComplaintRowIncludeList._({
    _i1.WhereExpressionBuilder<ComplaintRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ComplaintRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ComplaintRow.t;
}

class ComplaintRowRepository {
  const ComplaintRowRepository._();

  /// Returns a list of [ComplaintRow]s matching the given query parameters.
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
  Future<List<ComplaintRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ComplaintRow>(
      where: where?.call(ComplaintRow.t),
      orderBy: orderBy?.call(ComplaintRow.t),
      orderByList: orderByList?.call(ComplaintRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ComplaintRow] matching the given query parameters.
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
  Future<ComplaintRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComplaintRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ComplaintRow>(
      where: where?.call(ComplaintRow.t),
      orderBy: orderBy?.call(ComplaintRow.t),
      orderByList: orderByList?.call(ComplaintRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ComplaintRow] by its [id] or null if no such row exists.
  Future<ComplaintRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ComplaintRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ComplaintRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ComplaintRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ComplaintRow>> insert(
    _i1.DatabaseSession session,
    List<ComplaintRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ComplaintRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ComplaintRow] and returns the inserted row.
  ///
  /// The returned [ComplaintRow] will have its `id` field set.
  Future<ComplaintRow> insertRow(
    _i1.DatabaseSession session,
    ComplaintRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ComplaintRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ComplaintRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ComplaintRow>> update(
    _i1.DatabaseSession session,
    List<ComplaintRow> rows, {
    _i1.ColumnSelections<ComplaintRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ComplaintRow>(
      rows,
      columns: columns?.call(ComplaintRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplaintRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ComplaintRow> updateRow(
    _i1.DatabaseSession session,
    ComplaintRow row, {
    _i1.ColumnSelections<ComplaintRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ComplaintRow>(
      row,
      columns: columns?.call(ComplaintRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplaintRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ComplaintRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ComplaintRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ComplaintRow>(
      id,
      columnValues: columnValues(ComplaintRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ComplaintRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ComplaintRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ComplaintRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ComplaintRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintRowTable>? orderBy,
    _i1.OrderByListBuilder<ComplaintRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ComplaintRow>(
      columnValues: columnValues(ComplaintRow.t.updateTable),
      where: where(ComplaintRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplaintRow.t),
      orderByList: orderByList?.call(ComplaintRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ComplaintRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ComplaintRow>> delete(
    _i1.DatabaseSession session,
    List<ComplaintRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ComplaintRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ComplaintRow].
  Future<ComplaintRow> deleteRow(
    _i1.DatabaseSession session,
    ComplaintRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ComplaintRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ComplaintRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComplaintRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ComplaintRow>(
      where: where(ComplaintRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ComplaintRow>(
      where: where?.call(ComplaintRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ComplaintRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComplaintRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ComplaintRow>(
      where: where(ComplaintRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
