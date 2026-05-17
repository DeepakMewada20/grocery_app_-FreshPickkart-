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

abstract class NotificationCampaignRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  NotificationCampaignRow._({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.topic,
    this.imageUrl,
    required this.targetAudience,
    String? status,
    String? priority,
    this.scheduledAt,
    this.creatorAdminFirebaseUid,
    this.targetMetadataJson,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    this.lastError,
    this.sentAt,
    this.entityType,
    this.entityId,
    this.dataJson,
    DateTime? createdAt,
  }) : status = status ?? 'queued',
       priority = priority ?? 'normal',
       recipientCount = recipientCount ?? 0,
       successCount = successCount ?? 0,
       failureCount = failureCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory NotificationCampaignRow({
    _i1.UuidValue? id,
    required String title,
    required String body,
    required String type,
    required String topic,
    String? imageUrl,
    required String targetAudience,
    String? status,
    String? priority,
    DateTime? scheduledAt,
    String? creatorAdminFirebaseUid,
    String? targetMetadataJson,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    String? lastError,
    DateTime? sentAt,
    String? entityType,
    String? entityId,
    String? dataJson,
    DateTime? createdAt,
  }) = _NotificationCampaignRowImpl;

  factory NotificationCampaignRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationCampaignRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      type: jsonSerialization['type'] as String,
      topic: jsonSerialization['topic'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      targetAudience: jsonSerialization['targetAudience'] as String,
      status: jsonSerialization['status'] as String?,
      priority: jsonSerialization['priority'] as String?,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      creatorAdminFirebaseUid:
          jsonSerialization['creatorAdminFirebaseUid'] as String?,
      targetMetadataJson: jsonSerialization['targetMetadataJson'] as String?,
      recipientCount: jsonSerialization['recipientCount'] as int?,
      successCount: jsonSerialization['successCount'] as int?,
      failureCount: jsonSerialization['failureCount'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      entityType: jsonSerialization['entityType'] as String?,
      entityId: jsonSerialization['entityId'] as String?,
      dataJson: jsonSerialization['dataJson'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotificationCampaignRowTable();

  static const db = NotificationCampaignRowRepository._();

  @override
  _i1.UuidValue? id;

  String title;

  String body;

  String type;

  String topic;

  String? imageUrl;

  String targetAudience;

  String status;

  String priority;

  DateTime? scheduledAt;

  String? creatorAdminFirebaseUid;

  String? targetMetadataJson;

  int recipientCount;

  int successCount;

  int failureCount;

  String? lastError;

  DateTime? sentAt;

  String? entityType;

  String? entityId;

  String? dataJson;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotificationCampaignRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationCampaignRow copyWith({
    _i1.UuidValue? id,
    String? title,
    String? body,
    String? type,
    String? topic,
    String? imageUrl,
    String? targetAudience,
    String? status,
    String? priority,
    DateTime? scheduledAt,
    String? creatorAdminFirebaseUid,
    String? targetMetadataJson,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    String? lastError,
    DateTime? sentAt,
    String? entityType,
    String? entityId,
    String? dataJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationCampaignRow',
      if (id != null) 'id': id?.toJson(),
      'title': title,
      'body': body,
      'type': type,
      'topic': topic,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'targetAudience': targetAudience,
      'status': status,
      'priority': priority,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (creatorAdminFirebaseUid != null)
        'creatorAdminFirebaseUid': creatorAdminFirebaseUid,
      if (targetMetadataJson != null) 'targetMetadataJson': targetMetadataJson,
      'recipientCount': recipientCount,
      'successCount': successCount,
      'failureCount': failureCount,
      if (lastError != null) 'lastError': lastError,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (entityType != null) 'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (dataJson != null) 'dataJson': dataJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotificationCampaignRowInclude include() {
    return NotificationCampaignRowInclude._();
  }

  static NotificationCampaignRowIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationCampaignRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationCampaignRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationCampaignRowTable>? orderByList,
    NotificationCampaignRowInclude? include,
  }) {
    return NotificationCampaignRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationCampaignRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationCampaignRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationCampaignRowImpl extends NotificationCampaignRow {
  _NotificationCampaignRowImpl({
    _i1.UuidValue? id,
    required String title,
    required String body,
    required String type,
    required String topic,
    String? imageUrl,
    required String targetAudience,
    String? status,
    String? priority,
    DateTime? scheduledAt,
    String? creatorAdminFirebaseUid,
    String? targetMetadataJson,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    String? lastError,
    DateTime? sentAt,
    String? entityType,
    String? entityId,
    String? dataJson,
    DateTime? createdAt,
  }) : super._(
         id: id,
         title: title,
         body: body,
         type: type,
         topic: topic,
         imageUrl: imageUrl,
         targetAudience: targetAudience,
         status: status,
         priority: priority,
         scheduledAt: scheduledAt,
         creatorAdminFirebaseUid: creatorAdminFirebaseUid,
         targetMetadataJson: targetMetadataJson,
         recipientCount: recipientCount,
         successCount: successCount,
         failureCount: failureCount,
         lastError: lastError,
         sentAt: sentAt,
         entityType: entityType,
         entityId: entityId,
         dataJson: dataJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotificationCampaignRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationCampaignRow copyWith({
    Object? id = _Undefined,
    String? title,
    String? body,
    String? type,
    String? topic,
    Object? imageUrl = _Undefined,
    String? targetAudience,
    String? status,
    String? priority,
    Object? scheduledAt = _Undefined,
    Object? creatorAdminFirebaseUid = _Undefined,
    Object? targetMetadataJson = _Undefined,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    Object? lastError = _Undefined,
    Object? sentAt = _Undefined,
    Object? entityType = _Undefined,
    Object? entityId = _Undefined,
    Object? dataJson = _Undefined,
    DateTime? createdAt,
  }) {
    return NotificationCampaignRow(
      id: id is _i1.UuidValue? ? id : this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      topic: topic ?? this.topic,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      targetAudience: targetAudience ?? this.targetAudience,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      creatorAdminFirebaseUid: creatorAdminFirebaseUid is String?
          ? creatorAdminFirebaseUid
          : this.creatorAdminFirebaseUid,
      targetMetadataJson: targetMetadataJson is String?
          ? targetMetadataJson
          : this.targetMetadataJson,
      recipientCount: recipientCount ?? this.recipientCount,
      successCount: successCount ?? this.successCount,
      failureCount: failureCount ?? this.failureCount,
      lastError: lastError is String? ? lastError : this.lastError,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
      entityType: entityType is String? ? entityType : this.entityType,
      entityId: entityId is String? ? entityId : this.entityId,
      dataJson: dataJson is String? ? dataJson : this.dataJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationCampaignRowUpdateTable
    extends _i1.UpdateTable<NotificationCampaignRowTable> {
  NotificationCampaignRowUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> body(String value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> topic(String value) => _i1.ColumnValue(
    table.topic,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> targetAudience(String value) =>
      _i1.ColumnValue(
        table.targetAudience,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<String, String> creatorAdminFirebaseUid(String? value) =>
      _i1.ColumnValue(
        table.creatorAdminFirebaseUid,
        value,
      );

  _i1.ColumnValue<String, String> targetMetadataJson(String? value) =>
      _i1.ColumnValue(
        table.targetMetadataJson,
        value,
      );

  _i1.ColumnValue<int, int> recipientCount(int value) => _i1.ColumnValue(
    table.recipientCount,
    value,
  );

  _i1.ColumnValue<int, int> successCount(int value) => _i1.ColumnValue(
    table.successCount,
    value,
  );

  _i1.ColumnValue<int, int> failureCount(int value) => _i1.ColumnValue(
    table.failureCount,
    value,
  );

  _i1.ColumnValue<String, String> lastError(String? value) => _i1.ColumnValue(
    table.lastError,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _i1.ColumnValue(
        table.sentAt,
        value,
      );

  _i1.ColumnValue<String, String> entityType(String? value) => _i1.ColumnValue(
    table.entityType,
    value,
  );

  _i1.ColumnValue<String, String> entityId(String? value) => _i1.ColumnValue(
    table.entityId,
    value,
  );

  _i1.ColumnValue<String, String> dataJson(String? value) => _i1.ColumnValue(
    table.dataJson,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotificationCampaignRowTable extends _i1.Table<_i1.UuidValue?> {
  NotificationCampaignRowTable({super.tableRelation})
    : super(tableName: 'notification_campaign') {
    updateTable = NotificationCampaignRowUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    topic = _i1.ColumnString(
      'topic',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    targetAudience = _i1.ColumnString(
      'targetAudience',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
      hasDefault: true,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
    );
    creatorAdminFirebaseUid = _i1.ColumnString(
      'creatorAdminFirebaseUid',
      this,
    );
    targetMetadataJson = _i1.ColumnString(
      'targetMetadataJson',
      this,
    );
    recipientCount = _i1.ColumnInt(
      'recipientCount',
      this,
      hasDefault: true,
    );
    successCount = _i1.ColumnInt(
      'successCount',
      this,
      hasDefault: true,
    );
    failureCount = _i1.ColumnInt(
      'failureCount',
      this,
      hasDefault: true,
    );
    lastError = _i1.ColumnString(
      'lastError',
      this,
    );
    sentAt = _i1.ColumnDateTime(
      'sentAt',
      this,
    );
    entityType = _i1.ColumnString(
      'entityType',
      this,
    );
    entityId = _i1.ColumnString(
      'entityId',
      this,
    );
    dataJson = _i1.ColumnString(
      'dataJson',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotificationCampaignRowUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString body;

  late final _i1.ColumnString type;

  late final _i1.ColumnString topic;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString targetAudience;

  late final _i1.ColumnString status;

  late final _i1.ColumnString priority;

  late final _i1.ColumnDateTime scheduledAt;

  late final _i1.ColumnString creatorAdminFirebaseUid;

  late final _i1.ColumnString targetMetadataJson;

  late final _i1.ColumnInt recipientCount;

  late final _i1.ColumnInt successCount;

  late final _i1.ColumnInt failureCount;

  late final _i1.ColumnString lastError;

  late final _i1.ColumnDateTime sentAt;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnString entityId;

  late final _i1.ColumnString dataJson;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    body,
    type,
    topic,
    imageUrl,
    targetAudience,
    status,
    priority,
    scheduledAt,
    creatorAdminFirebaseUid,
    targetMetadataJson,
    recipientCount,
    successCount,
    failureCount,
    lastError,
    sentAt,
    entityType,
    entityId,
    dataJson,
    createdAt,
  ];
}

class NotificationCampaignRowInclude extends _i1.IncludeObject {
  NotificationCampaignRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationCampaignRow.t;
}

class NotificationCampaignRowIncludeList extends _i1.IncludeList {
  NotificationCampaignRowIncludeList._({
    _i1.WhereExpressionBuilder<NotificationCampaignRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationCampaignRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => NotificationCampaignRow.t;
}

class NotificationCampaignRowRepository {
  const NotificationCampaignRowRepository._();

  /// Returns a list of [NotificationCampaignRow]s matching the given query parameters.
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
  Future<List<NotificationCampaignRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationCampaignRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationCampaignRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationCampaignRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationCampaignRow>(
      where: where?.call(NotificationCampaignRow.t),
      orderBy: orderBy?.call(NotificationCampaignRow.t),
      orderByList: orderByList?.call(NotificationCampaignRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationCampaignRow] matching the given query parameters.
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
  Future<NotificationCampaignRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationCampaignRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationCampaignRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationCampaignRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationCampaignRow>(
      where: where?.call(NotificationCampaignRow.t),
      orderBy: orderBy?.call(NotificationCampaignRow.t),
      orderByList: orderByList?.call(NotificationCampaignRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationCampaignRow] by its [id] or null if no such row exists.
  Future<NotificationCampaignRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationCampaignRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationCampaignRow]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationCampaignRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationCampaignRow>> insert(
    _i1.DatabaseSession session,
    List<NotificationCampaignRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationCampaignRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationCampaignRow] and returns the inserted row.
  ///
  /// The returned [NotificationCampaignRow] will have its `id` field set.
  Future<NotificationCampaignRow> insertRow(
    _i1.DatabaseSession session,
    NotificationCampaignRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationCampaignRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationCampaignRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationCampaignRow>> update(
    _i1.DatabaseSession session,
    List<NotificationCampaignRow> rows, {
    _i1.ColumnSelections<NotificationCampaignRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationCampaignRow>(
      rows,
      columns: columns?.call(NotificationCampaignRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationCampaignRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationCampaignRow> updateRow(
    _i1.DatabaseSession session,
    NotificationCampaignRow row, {
    _i1.ColumnSelections<NotificationCampaignRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationCampaignRow>(
      row,
      columns: columns?.call(NotificationCampaignRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationCampaignRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationCampaignRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<NotificationCampaignRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationCampaignRow>(
      id,
      columnValues: columnValues(NotificationCampaignRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationCampaignRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationCampaignRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NotificationCampaignRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationCampaignRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationCampaignRowTable>? orderBy,
    _i1.OrderByListBuilder<NotificationCampaignRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationCampaignRow>(
      columnValues: columnValues(NotificationCampaignRow.t.updateTable),
      where: where(NotificationCampaignRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationCampaignRow.t),
      orderByList: orderByList?.call(NotificationCampaignRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationCampaignRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationCampaignRow>> delete(
    _i1.DatabaseSession session,
    List<NotificationCampaignRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationCampaignRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationCampaignRow].
  Future<NotificationCampaignRow> deleteRow(
    _i1.DatabaseSession session,
    NotificationCampaignRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationCampaignRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationCampaignRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationCampaignRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationCampaignRow>(
      where: where(NotificationCampaignRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationCampaignRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationCampaignRow>(
      where: where?.call(NotificationCampaignRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationCampaignRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationCampaignRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationCampaignRow>(
      where: where(NotificationCampaignRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
