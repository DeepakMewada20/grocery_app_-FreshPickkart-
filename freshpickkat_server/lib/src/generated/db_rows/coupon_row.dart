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

abstract class CouponRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CouponRow._({
    this.id,
    required this.code,
    this.description,
    required this.couponType,
    String? couponCategory,
    this.discountValue,
    double? minOrderAmount,
    this.maxDiscountAmount,
    this.maxUsageTotal,
    this.maxUsagePerUser,
    this.loyaltyRequiredOrders,
    int? usedCount,
    this.startsAt,
    this.endsAt,
    String? status,
    this.deactivatedAt,
    this.assignedUserId,
    this.assignedPhone,
    this.productIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : couponCategory = couponCategory ?? 'All',
       minOrderAmount = minOrderAmount ?? 0.0,
       usedCount = usedCount ?? 0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CouponRow({
    _i1.UuidValue? id,
    required String code,
    String? description,
    required String couponType,
    String? couponCategory,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    int? maxUsageTotal,
    int? maxUsagePerUser,
    int? loyaltyRequiredOrders,
    int? usedCount,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    _i1.UuidValue? assignedUserId,
    String? assignedPhone,
    String? productIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CouponRowImpl;

  factory CouponRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CouponRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String?,
      couponType: jsonSerialization['couponType'] as String,
      couponCategory: jsonSerialization['couponCategory'] as String?,
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num?)?.toDouble(),
      maxDiscountAmount: (jsonSerialization['maxDiscountAmount'] as num?)
          ?.toDouble(),
      maxUsageTotal: jsonSerialization['maxUsageTotal'] as int?,
      maxUsagePerUser: jsonSerialization['maxUsagePerUser'] as int?,
      loyaltyRequiredOrders: jsonSerialization['loyaltyRequiredOrders'] as int?,
      usedCount: jsonSerialization['usedCount'] as int?,
      startsAt: jsonSerialization['startsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startsAt']),
      endsAt: jsonSerialization['endsAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      status: jsonSerialization['status'] as String?,
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deactivatedAt'],
            ),
      assignedUserId: jsonSerialization['assignedUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['assignedUserId'],
            ),
      assignedPhone: jsonSerialization['assignedPhone'] as String?,
      productIds: jsonSerialization['productIds'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CouponRowTable();

  static const db = CouponRowRepository._();

  @override
  _i1.UuidValue? id;

  String code;

  String? description;

  String couponType;

  String couponCategory;

  double? discountValue;

  double minOrderAmount;

  double? maxDiscountAmount;

  int? maxUsageTotal;

  int? maxUsagePerUser;

  int? loyaltyRequiredOrders;

  int usedCount;

  DateTime? startsAt;

  DateTime? endsAt;

  String status;

  DateTime? deactivatedAt;

  _i1.UuidValue? assignedUserId;

  String? assignedPhone;

  String? productIds;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CouponRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponRow copyWith({
    _i1.UuidValue? id,
    String? code,
    String? description,
    String? couponType,
    String? couponCategory,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    int? maxUsageTotal,
    int? maxUsagePerUser,
    int? loyaltyRequiredOrders,
    int? usedCount,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    _i1.UuidValue? assignedUserId,
    String? assignedPhone,
    String? productIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponRow',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      if (description != null) 'description': description,
      'couponType': couponType,
      'couponCategory': couponCategory,
      if (discountValue != null) 'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (maxUsageTotal != null) 'maxUsageTotal': maxUsageTotal,
      if (maxUsagePerUser != null) 'maxUsagePerUser': maxUsagePerUser,
      if (loyaltyRequiredOrders != null)
        'loyaltyRequiredOrders': loyaltyRequiredOrders,
      'usedCount': usedCount,
      if (startsAt != null) 'startsAt': startsAt?.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      if (assignedUserId != null) 'assignedUserId': assignedUserId?.toJson(),
      if (assignedPhone != null) 'assignedPhone': assignedPhone,
      if (productIds != null) 'productIds': productIds,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CouponRowInclude include() {
    return CouponRowInclude._();
  }

  static CouponRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CouponRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponRowTable>? orderByList,
    CouponRowInclude? include,
  }) {
    return CouponRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CouponRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CouponRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CouponRowImpl extends CouponRow {
  _CouponRowImpl({
    _i1.UuidValue? id,
    required String code,
    String? description,
    required String couponType,
    String? couponCategory,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    int? maxUsageTotal,
    int? maxUsagePerUser,
    int? loyaltyRequiredOrders,
    int? usedCount,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    DateTime? deactivatedAt,
    _i1.UuidValue? assignedUserId,
    String? assignedPhone,
    String? productIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         code: code,
         description: description,
         couponType: couponType,
         couponCategory: couponCategory,
         discountValue: discountValue,
         minOrderAmount: minOrderAmount,
         maxDiscountAmount: maxDiscountAmount,
         maxUsageTotal: maxUsageTotal,
         maxUsagePerUser: maxUsagePerUser,
         loyaltyRequiredOrders: loyaltyRequiredOrders,
         usedCount: usedCount,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         assignedUserId: assignedUserId,
         assignedPhone: assignedPhone,
         productIds: productIds,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CouponRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CouponRow copyWith({
    Object? id = _Undefined,
    String? code,
    Object? description = _Undefined,
    String? couponType,
    String? couponCategory,
    Object? discountValue = _Undefined,
    double? minOrderAmount,
    Object? maxDiscountAmount = _Undefined,
    Object? maxUsageTotal = _Undefined,
    Object? maxUsagePerUser = _Undefined,
    Object? loyaltyRequiredOrders = _Undefined,
    int? usedCount,
    Object? startsAt = _Undefined,
    Object? endsAt = _Undefined,
    String? status,
    Object? deactivatedAt = _Undefined,
    Object? assignedUserId = _Undefined,
    Object? assignedPhone = _Undefined,
    Object? productIds = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CouponRow(
      id: id is _i1.UuidValue? ? id : this.id,
      code: code ?? this.code,
      description: description is String? ? description : this.description,
      couponType: couponType ?? this.couponType,
      couponCategory: couponCategory ?? this.couponCategory,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscountAmount: maxDiscountAmount is double?
          ? maxDiscountAmount
          : this.maxDiscountAmount,
      maxUsageTotal: maxUsageTotal is int? ? maxUsageTotal : this.maxUsageTotal,
      maxUsagePerUser: maxUsagePerUser is int?
          ? maxUsagePerUser
          : this.maxUsagePerUser,
      loyaltyRequiredOrders: loyaltyRequiredOrders is int?
          ? loyaltyRequiredOrders
          : this.loyaltyRequiredOrders,
      usedCount: usedCount ?? this.usedCount,
      startsAt: startsAt is DateTime? ? startsAt : this.startsAt,
      endsAt: endsAt is DateTime? ? endsAt : this.endsAt,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      assignedUserId: assignedUserId is _i1.UuidValue?
          ? assignedUserId
          : this.assignedUserId,
      assignedPhone: assignedPhone is String?
          ? assignedPhone
          : this.assignedPhone,
      productIds: productIds is String? ? productIds : this.productIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CouponRowUpdateTable extends _i1.UpdateTable<CouponRowTable> {
  CouponRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> couponType(String value) => _i1.ColumnValue(
    table.couponType,
    value,
  );

  _i1.ColumnValue<String, String> couponCategory(String value) =>
      _i1.ColumnValue(
        table.couponCategory,
        value,
      );

  _i1.ColumnValue<double, double> discountValue(double? value) =>
      _i1.ColumnValue(
        table.discountValue,
        value,
      );

  _i1.ColumnValue<double, double> minOrderAmount(double value) =>
      _i1.ColumnValue(
        table.minOrderAmount,
        value,
      );

  _i1.ColumnValue<double, double> maxDiscountAmount(double? value) =>
      _i1.ColumnValue(
        table.maxDiscountAmount,
        value,
      );

  _i1.ColumnValue<int, int> maxUsageTotal(int? value) => _i1.ColumnValue(
    table.maxUsageTotal,
    value,
  );

  _i1.ColumnValue<int, int> maxUsagePerUser(int? value) => _i1.ColumnValue(
    table.maxUsagePerUser,
    value,
  );

  _i1.ColumnValue<int, int> loyaltyRequiredOrders(int? value) =>
      _i1.ColumnValue(
        table.loyaltyRequiredOrders,
        value,
      );

  _i1.ColumnValue<int, int> usedCount(int value) => _i1.ColumnValue(
    table.usedCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startsAt(DateTime? value) =>
      _i1.ColumnValue(
        table.startsAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endsAt(DateTime? value) =>
      _i1.ColumnValue(
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

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> assignedUserId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.assignedUserId,
    value,
  );

  _i1.ColumnValue<String, String> assignedPhone(String? value) =>
      _i1.ColumnValue(
        table.assignedPhone,
        value,
      );

  _i1.ColumnValue<String, String> productIds(String? value) => _i1.ColumnValue(
    table.productIds,
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

class CouponRowTable extends _i1.Table<_i1.UuidValue?> {
  CouponRowTable({super.tableRelation}) : super(tableName: 'coupon') {
    updateTable = CouponRowUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    couponType = _i1.ColumnString(
      'couponType',
      this,
    );
    couponCategory = _i1.ColumnString(
      'couponCategory',
      this,
      hasDefault: true,
    );
    discountValue = _i1.ColumnDouble(
      'discountValue',
      this,
    );
    minOrderAmount = _i1.ColumnDouble(
      'minOrderAmount',
      this,
      hasDefault: true,
    );
    maxDiscountAmount = _i1.ColumnDouble(
      'maxDiscountAmount',
      this,
    );
    maxUsageTotal = _i1.ColumnInt(
      'maxUsageTotal',
      this,
    );
    maxUsagePerUser = _i1.ColumnInt(
      'maxUsagePerUser',
      this,
    );
    loyaltyRequiredOrders = _i1.ColumnInt(
      'loyaltyRequiredOrders',
      this,
    );
    usedCount = _i1.ColumnInt(
      'usedCount',
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
    assignedUserId = _i1.ColumnUuid(
      'assignedUserId',
      this,
    );
    assignedPhone = _i1.ColumnString(
      'assignedPhone',
      this,
    );
    productIds = _i1.ColumnString(
      'productIds',
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

  late final CouponRowUpdateTable updateTable;

  late final _i1.ColumnString code;

  late final _i1.ColumnString description;

  late final _i1.ColumnString couponType;

  late final _i1.ColumnString couponCategory;

  late final _i1.ColumnDouble discountValue;

  late final _i1.ColumnDouble minOrderAmount;

  late final _i1.ColumnDouble maxDiscountAmount;

  late final _i1.ColumnInt maxUsageTotal;

  late final _i1.ColumnInt maxUsagePerUser;

  late final _i1.ColumnInt loyaltyRequiredOrders;

  late final _i1.ColumnInt usedCount;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnUuid assignedUserId;

  late final _i1.ColumnString assignedPhone;

  late final _i1.ColumnString productIds;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    description,
    couponType,
    couponCategory,
    discountValue,
    minOrderAmount,
    maxDiscountAmount,
    maxUsageTotal,
    maxUsagePerUser,
    loyaltyRequiredOrders,
    usedCount,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    assignedUserId,
    assignedPhone,
    productIds,
    createdAt,
    updatedAt,
  ];
}

class CouponRowInclude extends _i1.IncludeObject {
  CouponRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CouponRow.t;
}

class CouponRowIncludeList extends _i1.IncludeList {
  CouponRowIncludeList._({
    _i1.WhereExpressionBuilder<CouponRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CouponRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CouponRow.t;
}

class CouponRowRepository {
  const CouponRowRepository._();

  /// Returns a list of [CouponRow]s matching the given query parameters.
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
  Future<List<CouponRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CouponRow>(
      where: where?.call(CouponRow.t),
      orderBy: orderBy?.call(CouponRow.t),
      orderByList: orderByList?.call(CouponRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CouponRow] matching the given query parameters.
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
  Future<CouponRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CouponRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CouponRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CouponRow>(
      where: where?.call(CouponRow.t),
      orderBy: orderBy?.call(CouponRow.t),
      orderByList: orderByList?.call(CouponRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CouponRow] by its [id] or null if no such row exists.
  Future<CouponRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CouponRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CouponRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CouponRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CouponRow>> insert(
    _i1.DatabaseSession session,
    List<CouponRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CouponRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CouponRow] and returns the inserted row.
  ///
  /// The returned [CouponRow] will have its `id` field set.
  Future<CouponRow> insertRow(
    _i1.DatabaseSession session,
    CouponRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CouponRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CouponRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CouponRow>> update(
    _i1.DatabaseSession session,
    List<CouponRow> rows, {
    _i1.ColumnSelections<CouponRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CouponRow>(
      rows,
      columns: columns?.call(CouponRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CouponRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CouponRow> updateRow(
    _i1.DatabaseSession session,
    CouponRow row, {
    _i1.ColumnSelections<CouponRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CouponRow>(
      row,
      columns: columns?.call(CouponRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CouponRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CouponRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CouponRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CouponRow>(
      id,
      columnValues: columnValues(CouponRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CouponRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CouponRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CouponRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CouponRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CouponRowTable>? orderBy,
    _i1.OrderByListBuilder<CouponRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CouponRow>(
      columnValues: columnValues(CouponRow.t.updateTable),
      where: where(CouponRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CouponRow.t),
      orderByList: orderByList?.call(CouponRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CouponRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CouponRow>> delete(
    _i1.DatabaseSession session,
    List<CouponRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CouponRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CouponRow].
  Future<CouponRow> deleteRow(
    _i1.DatabaseSession session,
    CouponRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CouponRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CouponRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CouponRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CouponRow>(
      where: where(CouponRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CouponRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CouponRow>(
      where: where?.call(CouponRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CouponRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CouponRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CouponRow>(
      where: where(CouponRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
