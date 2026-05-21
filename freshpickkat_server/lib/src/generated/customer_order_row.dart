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

abstract class CustomerOrderRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CustomerOrderRow._({
    this.id,
    required this.userId,
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentStatus,
    required this.refundStatus,
    this.couponId,
    required this.itemCount,
    required this.totalAmount,
    double? discountAmount,
    double? deliveryFee,
    required this.finalAmount,
    this.placedAt,
    this.confirmedAt,
    this.packedAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.deliveryPersonName,
    this.deliveryPersonPhone,
    this.deliveryOtp,
    String? orderType,
    this.sourceOrderNumber,
    this.complaintId,
    this.analyticsProcessedAt,
    DateTime? orderedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : discountAmount = discountAmount ?? 0.0,
       deliveryFee = deliveryFee ?? 0.0,
       orderType = orderType ?? 'regular',
       orderedAt = orderedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CustomerOrderRow({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String orderNumber,
    required String orderStatus,
    required String paymentStatus,
    required String refundStatus,
    _i1.UuidValue? couponId,
    required int itemCount,
    required double totalAmount,
    double? discountAmount,
    double? deliveryFee,
    required double finalAmount,
    DateTime? placedAt,
    DateTime? confirmedAt,
    DateTime? packedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? orderType,
    String? sourceOrderNumber,
    String? complaintId,
    DateTime? analyticsProcessedAt,
    DateTime? orderedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomerOrderRowImpl;

  factory CustomerOrderRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerOrderRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      orderNumber: jsonSerialization['orderNumber'] as String,
      orderStatus: jsonSerialization['orderStatus'] as String,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      refundStatus: jsonSerialization['refundStatus'] as String,
      couponId: jsonSerialization['couponId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['couponId']),
      itemCount: jsonSerialization['itemCount'] as int,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      discountAmount: (jsonSerialization['discountAmount'] as num?)?.toDouble(),
      deliveryFee: (jsonSerialization['deliveryFee'] as num?)?.toDouble(),
      finalAmount: (jsonSerialization['finalAmount'] as num).toDouble(),
      placedAt: jsonSerialization['placedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['placedAt']),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
      packedAt: jsonSerialization['packedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['packedAt']),
      outForDeliveryAt: jsonSerialization['outForDeliveryAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['outForDeliveryAt'],
            ),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      deliveryPersonName: jsonSerialization['deliveryPersonName'] as String?,
      deliveryPersonPhone: jsonSerialization['deliveryPersonPhone'] as String?,
      deliveryOtp: jsonSerialization['deliveryOtp'] as String?,
      orderType: jsonSerialization['orderType'] as String?,
      sourceOrderNumber: jsonSerialization['sourceOrderNumber'] as String?,
      complaintId: jsonSerialization['complaintId'] as String?,
      analyticsProcessedAt: jsonSerialization['analyticsProcessedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['analyticsProcessedAt'],
            ),
      orderedAt: jsonSerialization['orderedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['orderedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CustomerOrderRowTable();

  static const db = CustomerOrderRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String orderNumber;

  String orderStatus;

  String paymentStatus;

  String refundStatus;

  _i1.UuidValue? couponId;

  int itemCount;

  double totalAmount;

  double discountAmount;

  double deliveryFee;

  double finalAmount;

  DateTime? placedAt;

  DateTime? confirmedAt;

  DateTime? packedAt;

  DateTime? outForDeliveryAt;

  DateTime? deliveredAt;

  DateTime? cancelledAt;

  String? cancellationReason;

  String? deliveryPersonName;

  String? deliveryPersonPhone;

  String? deliveryOtp;

  String orderType;

  String? sourceOrderNumber;

  String? complaintId;

  DateTime? analyticsProcessedAt;

  DateTime orderedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CustomerOrderRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CustomerOrderRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? orderNumber,
    String? orderStatus,
    String? paymentStatus,
    String? refundStatus,
    _i1.UuidValue? couponId,
    int? itemCount,
    double? totalAmount,
    double? discountAmount,
    double? deliveryFee,
    double? finalAmount,
    DateTime? placedAt,
    DateTime? confirmedAt,
    DateTime? packedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? orderType,
    String? sourceOrderNumber,
    String? complaintId,
    DateTime? analyticsProcessedAt,
    DateTime? orderedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerOrderRow',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'orderNumber': orderNumber,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'refundStatus': refundStatus,
      if (couponId != null) 'couponId': couponId?.toJson(),
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'deliveryFee': deliveryFee,
      'finalAmount': finalAmount,
      if (placedAt != null) 'placedAt': placedAt?.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (packedAt != null) 'packedAt': packedAt?.toJson(),
      if (outForDeliveryAt != null)
        'outForDeliveryAt': outForDeliveryAt?.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (deliveryPersonName != null) 'deliveryPersonName': deliveryPersonName,
      if (deliveryPersonPhone != null)
        'deliveryPersonPhone': deliveryPersonPhone,
      if (deliveryOtp != null) 'deliveryOtp': deliveryOtp,
      'orderType': orderType,
      if (sourceOrderNumber != null) 'sourceOrderNumber': sourceOrderNumber,
      if (complaintId != null) 'complaintId': complaintId,
      if (analyticsProcessedAt != null)
        'analyticsProcessedAt': analyticsProcessedAt?.toJson(),
      'orderedAt': orderedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CustomerOrderRowInclude include() {
    return CustomerOrderRowInclude._();
  }

  static CustomerOrderRowIncludeList includeList({
    _i1.WhereExpressionBuilder<CustomerOrderRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerOrderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerOrderRowTable>? orderByList,
    CustomerOrderRowInclude? include,
  }) {
    return CustomerOrderRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerOrderRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CustomerOrderRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerOrderRowImpl extends CustomerOrderRow {
  _CustomerOrderRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String orderNumber,
    required String orderStatus,
    required String paymentStatus,
    required String refundStatus,
    _i1.UuidValue? couponId,
    required int itemCount,
    required double totalAmount,
    double? discountAmount,
    double? deliveryFee,
    required double finalAmount,
    DateTime? placedAt,
    DateTime? confirmedAt,
    DateTime? packedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? orderType,
    String? sourceOrderNumber,
    String? complaintId,
    DateTime? analyticsProcessedAt,
    DateTime? orderedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         orderNumber: orderNumber,
         orderStatus: orderStatus,
         paymentStatus: paymentStatus,
         refundStatus: refundStatus,
         couponId: couponId,
         itemCount: itemCount,
         totalAmount: totalAmount,
         discountAmount: discountAmount,
         deliveryFee: deliveryFee,
         finalAmount: finalAmount,
         placedAt: placedAt,
         confirmedAt: confirmedAt,
         packedAt: packedAt,
         outForDeliveryAt: outForDeliveryAt,
         deliveredAt: deliveredAt,
         cancelledAt: cancelledAt,
         cancellationReason: cancellationReason,
         deliveryPersonName: deliveryPersonName,
         deliveryPersonPhone: deliveryPersonPhone,
         deliveryOtp: deliveryOtp,
         orderType: orderType,
         sourceOrderNumber: sourceOrderNumber,
         complaintId: complaintId,
         analyticsProcessedAt: analyticsProcessedAt,
         orderedAt: orderedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CustomerOrderRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CustomerOrderRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? orderNumber,
    String? orderStatus,
    String? paymentStatus,
    String? refundStatus,
    Object? couponId = _Undefined,
    int? itemCount,
    double? totalAmount,
    double? discountAmount,
    double? deliveryFee,
    double? finalAmount,
    Object? placedAt = _Undefined,
    Object? confirmedAt = _Undefined,
    Object? packedAt = _Undefined,
    Object? outForDeliveryAt = _Undefined,
    Object? deliveredAt = _Undefined,
    Object? cancelledAt = _Undefined,
    Object? cancellationReason = _Undefined,
    Object? deliveryPersonName = _Undefined,
    Object? deliveryPersonPhone = _Undefined,
    Object? deliveryOtp = _Undefined,
    String? orderType,
    Object? sourceOrderNumber = _Undefined,
    Object? complaintId = _Undefined,
    Object? analyticsProcessedAt = _Undefined,
    DateTime? orderedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerOrderRow(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      refundStatus: refundStatus ?? this.refundStatus,
      couponId: couponId is _i1.UuidValue? ? couponId : this.couponId,
      itemCount: itemCount ?? this.itemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      finalAmount: finalAmount ?? this.finalAmount,
      placedAt: placedAt is DateTime? ? placedAt : this.placedAt,
      confirmedAt: confirmedAt is DateTime? ? confirmedAt : this.confirmedAt,
      packedAt: packedAt is DateTime? ? packedAt : this.packedAt,
      outForDeliveryAt: outForDeliveryAt is DateTime?
          ? outForDeliveryAt
          : this.outForDeliveryAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
      cancellationReason: cancellationReason is String?
          ? cancellationReason
          : this.cancellationReason,
      deliveryPersonName: deliveryPersonName is String?
          ? deliveryPersonName
          : this.deliveryPersonName,
      deliveryPersonPhone: deliveryPersonPhone is String?
          ? deliveryPersonPhone
          : this.deliveryPersonPhone,
      deliveryOtp: deliveryOtp is String? ? deliveryOtp : this.deliveryOtp,
      orderType: orderType ?? this.orderType,
      sourceOrderNumber: sourceOrderNumber is String?
          ? sourceOrderNumber
          : this.sourceOrderNumber,
      complaintId: complaintId is String? ? complaintId : this.complaintId,
      analyticsProcessedAt: analyticsProcessedAt is DateTime?
          ? analyticsProcessedAt
          : this.analyticsProcessedAt,
      orderedAt: orderedAt ?? this.orderedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CustomerOrderRowUpdateTable
    extends _i1.UpdateTable<CustomerOrderRowTable> {
  CustomerOrderRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> orderNumber(String value) => _i1.ColumnValue(
    table.orderNumber,
    value,
  );

  _i1.ColumnValue<String, String> orderStatus(String value) => _i1.ColumnValue(
    table.orderStatus,
    value,
  );

  _i1.ColumnValue<String, String> paymentStatus(String value) =>
      _i1.ColumnValue(
        table.paymentStatus,
        value,
      );

  _i1.ColumnValue<String, String> refundStatus(String value) => _i1.ColumnValue(
    table.refundStatus,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> couponId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.couponId,
    value,
  );

  _i1.ColumnValue<int, int> itemCount(int value) => _i1.ColumnValue(
    table.itemCount,
    value,
  );

  _i1.ColumnValue<double, double> totalAmount(double value) => _i1.ColumnValue(
    table.totalAmount,
    value,
  );

  _i1.ColumnValue<double, double> discountAmount(double value) =>
      _i1.ColumnValue(
        table.discountAmount,
        value,
      );

  _i1.ColumnValue<double, double> deliveryFee(double value) => _i1.ColumnValue(
    table.deliveryFee,
    value,
  );

  _i1.ColumnValue<double, double> finalAmount(double value) => _i1.ColumnValue(
    table.finalAmount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> placedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.placedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> confirmedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.confirmedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> packedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.packedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> outForDeliveryAt(DateTime? value) =>
      _i1.ColumnValue(
        table.outForDeliveryAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deliveredAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deliveredAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> cancelledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.cancelledAt,
        value,
      );

  _i1.ColumnValue<String, String> cancellationReason(String? value) =>
      _i1.ColumnValue(
        table.cancellationReason,
        value,
      );

  _i1.ColumnValue<String, String> deliveryPersonName(String? value) =>
      _i1.ColumnValue(
        table.deliveryPersonName,
        value,
      );

  _i1.ColumnValue<String, String> deliveryPersonPhone(String? value) =>
      _i1.ColumnValue(
        table.deliveryPersonPhone,
        value,
      );

  _i1.ColumnValue<String, String> deliveryOtp(String? value) => _i1.ColumnValue(
    table.deliveryOtp,
    value,
  );

  _i1.ColumnValue<String, String> orderType(String value) => _i1.ColumnValue(
    table.orderType,
    value,
  );

  _i1.ColumnValue<String, String> sourceOrderNumber(String? value) =>
      _i1.ColumnValue(
        table.sourceOrderNumber,
        value,
      );

  _i1.ColumnValue<String, String> complaintId(String? value) => _i1.ColumnValue(
    table.complaintId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> analyticsProcessedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.analyticsProcessedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> orderedAt(DateTime value) =>
      _i1.ColumnValue(
        table.orderedAt,
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

class CustomerOrderRowTable extends _i1.Table<_i1.UuidValue?> {
  CustomerOrderRowTable({super.tableRelation})
    : super(tableName: 'customer_order') {
    updateTable = CustomerOrderRowUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    orderNumber = _i1.ColumnString(
      'orderNumber',
      this,
    );
    orderStatus = _i1.ColumnString(
      'orderStatus',
      this,
    );
    paymentStatus = _i1.ColumnString(
      'paymentStatus',
      this,
    );
    refundStatus = _i1.ColumnString(
      'refundStatus',
      this,
    );
    couponId = _i1.ColumnUuid(
      'couponId',
      this,
    );
    itemCount = _i1.ColumnInt(
      'itemCount',
      this,
    );
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
      this,
    );
    discountAmount = _i1.ColumnDouble(
      'discountAmount',
      this,
      hasDefault: true,
    );
    deliveryFee = _i1.ColumnDouble(
      'deliveryFee',
      this,
      hasDefault: true,
    );
    finalAmount = _i1.ColumnDouble(
      'finalAmount',
      this,
    );
    placedAt = _i1.ColumnDateTime(
      'placedAt',
      this,
    );
    confirmedAt = _i1.ColumnDateTime(
      'confirmedAt',
      this,
    );
    packedAt = _i1.ColumnDateTime(
      'packedAt',
      this,
    );
    outForDeliveryAt = _i1.ColumnDateTime(
      'outForDeliveryAt',
      this,
    );
    deliveredAt = _i1.ColumnDateTime(
      'deliveredAt',
      this,
    );
    cancelledAt = _i1.ColumnDateTime(
      'cancelledAt',
      this,
    );
    cancellationReason = _i1.ColumnString(
      'cancellationReason',
      this,
    );
    deliveryPersonName = _i1.ColumnString(
      'deliveryPersonName',
      this,
    );
    deliveryPersonPhone = _i1.ColumnString(
      'deliveryPersonPhone',
      this,
    );
    deliveryOtp = _i1.ColumnString(
      'deliveryOtp',
      this,
    );
    orderType = _i1.ColumnString(
      'orderType',
      this,
      hasDefault: true,
    );
    sourceOrderNumber = _i1.ColumnString(
      'sourceOrderNumber',
      this,
    );
    complaintId = _i1.ColumnString(
      'complaintId',
      this,
    );
    analyticsProcessedAt = _i1.ColumnDateTime(
      'analyticsProcessedAt',
      this,
    );
    orderedAt = _i1.ColumnDateTime(
      'orderedAt',
      this,
      hasDefault: true,
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

  late final CustomerOrderRowUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString orderNumber;

  late final _i1.ColumnString orderStatus;

  late final _i1.ColumnString paymentStatus;

  late final _i1.ColumnString refundStatus;

  late final _i1.ColumnUuid couponId;

  late final _i1.ColumnInt itemCount;

  late final _i1.ColumnDouble totalAmount;

  late final _i1.ColumnDouble discountAmount;

  late final _i1.ColumnDouble deliveryFee;

  late final _i1.ColumnDouble finalAmount;

  late final _i1.ColumnDateTime placedAt;

  late final _i1.ColumnDateTime confirmedAt;

  late final _i1.ColumnDateTime packedAt;

  late final _i1.ColumnDateTime outForDeliveryAt;

  late final _i1.ColumnDateTime deliveredAt;

  late final _i1.ColumnDateTime cancelledAt;

  late final _i1.ColumnString cancellationReason;

  late final _i1.ColumnString deliveryPersonName;

  late final _i1.ColumnString deliveryPersonPhone;

  late final _i1.ColumnString deliveryOtp;

  late final _i1.ColumnString orderType;

  late final _i1.ColumnString sourceOrderNumber;

  late final _i1.ColumnString complaintId;

  late final _i1.ColumnDateTime analyticsProcessedAt;

  late final _i1.ColumnDateTime orderedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    orderNumber,
    orderStatus,
    paymentStatus,
    refundStatus,
    couponId,
    itemCount,
    totalAmount,
    discountAmount,
    deliveryFee,
    finalAmount,
    placedAt,
    confirmedAt,
    packedAt,
    outForDeliveryAt,
    deliveredAt,
    cancelledAt,
    cancellationReason,
    deliveryPersonName,
    deliveryPersonPhone,
    deliveryOtp,
    orderType,
    sourceOrderNumber,
    complaintId,
    analyticsProcessedAt,
    orderedAt,
    createdAt,
    updatedAt,
  ];
}

class CustomerOrderRowInclude extends _i1.IncludeObject {
  CustomerOrderRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CustomerOrderRow.t;
}

class CustomerOrderRowIncludeList extends _i1.IncludeList {
  CustomerOrderRowIncludeList._({
    _i1.WhereExpressionBuilder<CustomerOrderRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomerOrderRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CustomerOrderRow.t;
}

class CustomerOrderRowRepository {
  const CustomerOrderRowRepository._();

  /// Returns a list of [CustomerOrderRow]s matching the given query parameters.
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
  Future<List<CustomerOrderRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomerOrderRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerOrderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerOrderRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomerOrderRow>(
      where: where?.call(CustomerOrderRow.t),
      orderBy: orderBy?.call(CustomerOrderRow.t),
      orderByList: orderByList?.call(CustomerOrderRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CustomerOrderRow] matching the given query parameters.
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
  Future<CustomerOrderRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomerOrderRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<CustomerOrderRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerOrderRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomerOrderRow>(
      where: where?.call(CustomerOrderRow.t),
      orderBy: orderBy?.call(CustomerOrderRow.t),
      orderByList: orderByList?.call(CustomerOrderRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomerOrderRow] by its [id] or null if no such row exists.
  Future<CustomerOrderRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomerOrderRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomerOrderRow]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerOrderRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CustomerOrderRow>> insert(
    _i1.DatabaseSession session,
    List<CustomerOrderRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CustomerOrderRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CustomerOrderRow] and returns the inserted row.
  ///
  /// The returned [CustomerOrderRow] will have its `id` field set.
  Future<CustomerOrderRow> insertRow(
    _i1.DatabaseSession session,
    CustomerOrderRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerOrderRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CustomerOrderRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CustomerOrderRow>> update(
    _i1.DatabaseSession session,
    List<CustomerOrderRow> rows, {
    _i1.ColumnSelections<CustomerOrderRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CustomerOrderRow>(
      rows,
      columns: columns?.call(CustomerOrderRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerOrderRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerOrderRow> updateRow(
    _i1.DatabaseSession session,
    CustomerOrderRow row, {
    _i1.ColumnSelections<CustomerOrderRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomerOrderRow>(
      row,
      columns: columns?.call(CustomerOrderRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerOrderRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomerOrderRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CustomerOrderRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerOrderRow>(
      id,
      columnValues: columnValues(CustomerOrderRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerOrderRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CustomerOrderRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CustomerOrderRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CustomerOrderRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerOrderRowTable>? orderBy,
    _i1.OrderByListBuilder<CustomerOrderRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CustomerOrderRow>(
      columnValues: columnValues(CustomerOrderRow.t.updateTable),
      where: where(CustomerOrderRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerOrderRow.t),
      orderByList: orderByList?.call(CustomerOrderRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CustomerOrderRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CustomerOrderRow>> delete(
    _i1.DatabaseSession session,
    List<CustomerOrderRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CustomerOrderRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CustomerOrderRow].
  Future<CustomerOrderRow> deleteRow(
    _i1.DatabaseSession session,
    CustomerOrderRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerOrderRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CustomerOrderRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CustomerOrderRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CustomerOrderRow>(
      where: where(CustomerOrderRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomerOrderRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CustomerOrderRow>(
      where: where?.call(CustomerOrderRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomerOrderRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CustomerOrderRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomerOrderRow>(
      where: where(CustomerOrderRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
