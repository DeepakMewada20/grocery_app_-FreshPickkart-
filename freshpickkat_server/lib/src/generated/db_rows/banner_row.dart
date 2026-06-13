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

abstract class BannerRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  BannerRow._({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.actionType,
    this.offerId,
    this.externalUrl,
    this.linkedProductId,
    this.comboOfferId,
    this.couponId,
    this.linkedCategoryId,
    this.linkedSubCategoryId,
    String? screenPlacements,
    this.linkedProductIds,
    int? priority,
    bool? isBaseImage,
    required this.startsAt,
    required this.endsAt,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : screenPlacements = screenPlacements ?? '',
       priority = priority ?? 0,
       isBaseImage = isBaseImage ?? false,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BannerRow({
    _i1.UuidValue? id,
    required String title,
    required String imageUrl,
    required String actionType,
    String? offerId,
    String? externalUrl,
    _i1.UuidValue? linkedProductId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? couponId,
    _i1.UuidValue? linkedCategoryId,
    _i1.UuidValue? linkedSubCategoryId,
    String? screenPlacements,
    String? linkedProductIds,
    int? priority,
    bool? isBaseImage,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BannerRowImpl;

  factory BannerRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return BannerRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      actionType: jsonSerialization['actionType'] as String,
      offerId: jsonSerialization['offerId'] as String?,
      externalUrl: jsonSerialization['externalUrl'] as String?,
      linkedProductId: jsonSerialization['linkedProductId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['linkedProductId'],
            ),
      comboOfferId: jsonSerialization['comboOfferId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['comboOfferId'],
            ),
      couponId: jsonSerialization['couponId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['couponId']),
      linkedCategoryId: jsonSerialization['linkedCategoryId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['linkedCategoryId'],
            ),
      linkedSubCategoryId: jsonSerialization['linkedSubCategoryId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['linkedSubCategoryId'],
            ),
      screenPlacements: jsonSerialization['screenPlacements'] as String?,
      linkedProductIds: jsonSerialization['linkedProductIds'] as String?,
      priority: jsonSerialization['priority'] as int?,
      isBaseImage: jsonSerialization['isBaseImage'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isBaseImage']),
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

  static final t = BannerRowTable();

  static const db = BannerRowRepository._();

  @override
  _i1.UuidValue? id;

  String title;

  String imageUrl;

  String actionType;

  String? offerId;

  String? externalUrl;

  _i1.UuidValue? linkedProductId;

  _i1.UuidValue? comboOfferId;

  _i1.UuidValue? couponId;

  _i1.UuidValue? linkedCategoryId;

  _i1.UuidValue? linkedSubCategoryId;

  String screenPlacements;

  String? linkedProductIds;

  int priority;

  bool isBaseImage;

  DateTime startsAt;

  DateTime endsAt;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [BannerRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BannerRow copyWith({
    _i1.UuidValue? id,
    String? title,
    String? imageUrl,
    String? actionType,
    String? offerId,
    String? externalUrl,
    _i1.UuidValue? linkedProductId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? couponId,
    _i1.UuidValue? linkedCategoryId,
    _i1.UuidValue? linkedSubCategoryId,
    String? screenPlacements,
    String? linkedProductIds,
    int? priority,
    bool? isBaseImage,
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
      '__className__': 'BannerRow',
      if (id != null) 'id': id?.toJson(),
      'title': title,
      'imageUrl': imageUrl,
      'actionType': actionType,
      if (offerId != null) 'offerId': offerId,
      if (externalUrl != null) 'externalUrl': externalUrl,
      if (linkedProductId != null) 'linkedProductId': linkedProductId?.toJson(),
      if (comboOfferId != null) 'comboOfferId': comboOfferId?.toJson(),
      if (couponId != null) 'couponId': couponId?.toJson(),
      if (linkedCategoryId != null)
        'linkedCategoryId': linkedCategoryId?.toJson(),
      if (linkedSubCategoryId != null)
        'linkedSubCategoryId': linkedSubCategoryId?.toJson(),
      'screenPlacements': screenPlacements,
      if (linkedProductIds != null) 'linkedProductIds': linkedProductIds,
      'priority': priority,
      'isBaseImage': isBaseImage,
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

  static BannerRowInclude include() {
    return BannerRowInclude._();
  }

  static BannerRowIncludeList includeList({
    _i1.WhereExpressionBuilder<BannerRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerRowTable>? orderByList,
    BannerRowInclude? include,
  }) {
    return BannerRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BannerRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BannerRowImpl extends BannerRow {
  _BannerRowImpl({
    _i1.UuidValue? id,
    required String title,
    required String imageUrl,
    required String actionType,
    String? offerId,
    String? externalUrl,
    _i1.UuidValue? linkedProductId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? couponId,
    _i1.UuidValue? linkedCategoryId,
    _i1.UuidValue? linkedSubCategoryId,
    String? screenPlacements,
    String? linkedProductIds,
    int? priority,
    bool? isBaseImage,
    required DateTime startsAt,
    required DateTime endsAt,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         title: title,
         imageUrl: imageUrl,
         actionType: actionType,
         offerId: offerId,
         externalUrl: externalUrl,
         linkedProductId: linkedProductId,
         comboOfferId: comboOfferId,
         couponId: couponId,
         linkedCategoryId: linkedCategoryId,
         linkedSubCategoryId: linkedSubCategoryId,
         screenPlacements: screenPlacements,
         linkedProductIds: linkedProductIds,
         priority: priority,
         isBaseImage: isBaseImage,
         startsAt: startsAt,
         endsAt: endsAt,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BannerRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BannerRow copyWith({
    Object? id = _Undefined,
    String? title,
    String? imageUrl,
    String? actionType,
    Object? offerId = _Undefined,
    Object? externalUrl = _Undefined,
    Object? linkedProductId = _Undefined,
    Object? comboOfferId = _Undefined,
    Object? couponId = _Undefined,
    Object? linkedCategoryId = _Undefined,
    Object? linkedSubCategoryId = _Undefined,
    String? screenPlacements,
    Object? linkedProductIds = _Undefined,
    int? priority,
    bool? isBaseImage,
    DateTime? startsAt,
    DateTime? endsAt,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BannerRow(
      id: id is _i1.UuidValue? ? id : this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      actionType: actionType ?? this.actionType,
      offerId: offerId is String? ? offerId : this.offerId,
      externalUrl: externalUrl is String? ? externalUrl : this.externalUrl,
      linkedProductId: linkedProductId is _i1.UuidValue?
          ? linkedProductId
          : this.linkedProductId,
      comboOfferId: comboOfferId is _i1.UuidValue?
          ? comboOfferId
          : this.comboOfferId,
      couponId: couponId is _i1.UuidValue? ? couponId : this.couponId,
      linkedCategoryId: linkedCategoryId is _i1.UuidValue?
          ? linkedCategoryId
          : this.linkedCategoryId,
      linkedSubCategoryId: linkedSubCategoryId is _i1.UuidValue?
          ? linkedSubCategoryId
          : this.linkedSubCategoryId,
      screenPlacements: screenPlacements ?? this.screenPlacements,
      linkedProductIds: linkedProductIds is String?
          ? linkedProductIds
          : this.linkedProductIds,
      priority: priority ?? this.priority,
      isBaseImage: isBaseImage ?? this.isBaseImage,
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

class BannerRowUpdateTable extends _i1.UpdateTable<BannerRowTable> {
  BannerRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> actionType(String value) => _i1.ColumnValue(
    table.actionType,
    value,
  );

  _i1.ColumnValue<String, String> offerId(String? value) => _i1.ColumnValue(
    table.offerId,
    value,
  );

  _i1.ColumnValue<String, String> externalUrl(String? value) => _i1.ColumnValue(
    table.externalUrl,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> linkedProductId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.linkedProductId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> comboOfferId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.comboOfferId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> couponId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.couponId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> linkedCategoryId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.linkedCategoryId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> linkedSubCategoryId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.linkedSubCategoryId,
    value,
  );

  _i1.ColumnValue<String, String> screenPlacements(String value) =>
      _i1.ColumnValue(
        table.screenPlacements,
        value,
      );

  _i1.ColumnValue<String, String> linkedProductIds(String? value) =>
      _i1.ColumnValue(
        table.linkedProductIds,
        value,
      );

  _i1.ColumnValue<int, int> priority(int value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<bool, bool> isBaseImage(bool value) => _i1.ColumnValue(
    table.isBaseImage,
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

class BannerRowTable extends _i1.Table<_i1.UuidValue?> {
  BannerRowTable({super.tableRelation}) : super(tableName: 'banner') {
    updateTable = BannerRowUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    actionType = _i1.ColumnString(
      'actionType',
      this,
    );
    offerId = _i1.ColumnString(
      'offerId',
      this,
    );
    externalUrl = _i1.ColumnString(
      'externalUrl',
      this,
    );
    linkedProductId = _i1.ColumnUuid(
      'linkedProductId',
      this,
    );
    comboOfferId = _i1.ColumnUuid(
      'comboOfferId',
      this,
    );
    couponId = _i1.ColumnUuid(
      'couponId',
      this,
    );
    linkedCategoryId = _i1.ColumnUuid(
      'linkedCategoryId',
      this,
    );
    linkedSubCategoryId = _i1.ColumnUuid(
      'linkedSubCategoryId',
      this,
    );
    screenPlacements = _i1.ColumnString(
      'screenPlacements',
      this,
      hasDefault: true,
    );
    linkedProductIds = _i1.ColumnString(
      'linkedProductIds',
      this,
    );
    priority = _i1.ColumnInt(
      'priority',
      this,
      hasDefault: true,
    );
    isBaseImage = _i1.ColumnBool(
      'isBaseImage',
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

  late final BannerRowUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString actionType;

  late final _i1.ColumnString offerId;

  late final _i1.ColumnString externalUrl;

  late final _i1.ColumnUuid linkedProductId;

  late final _i1.ColumnUuid comboOfferId;

  late final _i1.ColumnUuid couponId;

  late final _i1.ColumnUuid linkedCategoryId;

  late final _i1.ColumnUuid linkedSubCategoryId;

  late final _i1.ColumnString screenPlacements;

  late final _i1.ColumnString linkedProductIds;

  late final _i1.ColumnInt priority;

  late final _i1.ColumnBool isBaseImage;

  late final _i1.ColumnDateTime startsAt;

  late final _i1.ColumnDateTime endsAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    imageUrl,
    actionType,
    offerId,
    externalUrl,
    linkedProductId,
    comboOfferId,
    couponId,
    linkedCategoryId,
    linkedSubCategoryId,
    screenPlacements,
    linkedProductIds,
    priority,
    isBaseImage,
    startsAt,
    endsAt,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class BannerRowInclude extends _i1.IncludeObject {
  BannerRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerRow.t;
}

class BannerRowIncludeList extends _i1.IncludeList {
  BannerRowIncludeList._({
    _i1.WhereExpressionBuilder<BannerRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BannerRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => BannerRow.t;
}

class BannerRowRepository {
  const BannerRowRepository._();

  /// Returns a list of [BannerRow]s matching the given query parameters.
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
  Future<List<BannerRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BannerRow>(
      where: where?.call(BannerRow.t),
      orderBy: orderBy?.call(BannerRow.t),
      orderByList: orderByList?.call(BannerRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BannerRow] matching the given query parameters.
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
  Future<BannerRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<BannerRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BannerRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BannerRow>(
      where: where?.call(BannerRow.t),
      orderBy: orderBy?.call(BannerRow.t),
      orderByList: orderByList?.call(BannerRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BannerRow] by its [id] or null if no such row exists.
  Future<BannerRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BannerRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BannerRow]s in the list and returns the inserted rows.
  ///
  /// The returned [BannerRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BannerRow>> insert(
    _i1.DatabaseSession session,
    List<BannerRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BannerRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BannerRow] and returns the inserted row.
  ///
  /// The returned [BannerRow] will have its `id` field set.
  Future<BannerRow> insertRow(
    _i1.DatabaseSession session,
    BannerRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BannerRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BannerRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BannerRow>> update(
    _i1.DatabaseSession session,
    List<BannerRow> rows, {
    _i1.ColumnSelections<BannerRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BannerRow>(
      rows,
      columns: columns?.call(BannerRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BannerRow> updateRow(
    _i1.DatabaseSession session,
    BannerRow row, {
    _i1.ColumnSelections<BannerRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BannerRow>(
      row,
      columns: columns?.call(BannerRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BannerRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BannerRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BannerRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BannerRow>(
      id,
      columnValues: columnValues(BannerRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BannerRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BannerRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BannerRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BannerRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BannerRowTable>? orderBy,
    _i1.OrderByListBuilder<BannerRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BannerRow>(
      columnValues: columnValues(BannerRow.t.updateTable),
      where: where(BannerRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BannerRow.t),
      orderByList: orderByList?.call(BannerRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BannerRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BannerRow>> delete(
    _i1.DatabaseSession session,
    List<BannerRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BannerRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BannerRow].
  Future<BannerRow> deleteRow(
    _i1.DatabaseSession session,
    BannerRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BannerRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BannerRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BannerRow>(
      where: where(BannerRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BannerRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BannerRow>(
      where: where?.call(BannerRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BannerRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BannerRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BannerRow>(
      where: where(BannerRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
