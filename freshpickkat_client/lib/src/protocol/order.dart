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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'order_item.dart' as _i2;
import 'address.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class Order implements _i1.SerializableModel {
  Order._({
    required this.orderId,
    required this.userId,
    this.userName,
    required this.userPhone,
    required this.items,
    required this.itemCount,
    required this.totalAmount,
    required this.discountAmount,
    required this.deliveryFee,
    required this.finalAmount,
    required this.status,
    required this.paymentStatus,
    required this.refundStatus,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.deliveryAddress,
    required this.orderedAt,
    this.confirmedAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.deliveryPersonName,
    this.deliveryPersonPhone,
    this.deliveryOtp,
    this.couponApplied,
    required this.orderType,
    this.sourceOrderNumber,
    this.complaintId,
  });

  factory Order({
    required String orderId,
    required String userId,
    String? userName,
    required String userPhone,
    required List<_i2.OrderItem> items,
    required int itemCount,
    required double totalAmount,
    required double discountAmount,
    required double deliveryFee,
    required double finalAmount,
    required String status,
    required String paymentStatus,
    required String refundStatus,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    required _i3.Address deliveryAddress,
    required DateTime orderedAt,
    DateTime? confirmedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? couponApplied,
    required String orderType,
    String? sourceOrderNumber,
    String? complaintId,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      orderId: jsonSerialization['orderId'] as String,
      userId: jsonSerialization['userId'] as String,
      userName: jsonSerialization['userName'] as String?,
      userPhone: jsonSerialization['userPhone'] as String,
      items: _i4.Protocol().deserialize<List<_i2.OrderItem>>(
        jsonSerialization['items'],
      ),
      itemCount: jsonSerialization['itemCount'] as int,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      finalAmount: (jsonSerialization['finalAmount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      refundStatus: jsonSerialization['refundStatus'] as String,
      razorpayOrderId: jsonSerialization['razorpayOrderId'] as String?,
      razorpayPaymentId: jsonSerialization['razorpayPaymentId'] as String?,
      deliveryAddress: _i4.Protocol().deserialize<_i3.Address>(
        jsonSerialization['deliveryAddress'],
      ),
      orderedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['orderedAt'],
      ),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
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
      couponApplied: jsonSerialization['couponApplied'] as String?,
      orderType: jsonSerialization['orderType'] as String,
      sourceOrderNumber: jsonSerialization['sourceOrderNumber'] as String?,
      complaintId: jsonSerialization['complaintId'] as String?,
    );
  }

  String orderId;

  String userId;

  String? userName;

  String userPhone;

  List<_i2.OrderItem> items;

  int itemCount;

  double totalAmount;

  double discountAmount;

  double deliveryFee;

  double finalAmount;

  String status;

  String paymentStatus;

  String refundStatus;

  String? razorpayOrderId;

  String? razorpayPaymentId;

  _i3.Address deliveryAddress;

  DateTime orderedAt;

  DateTime? confirmedAt;

  DateTime? outForDeliveryAt;

  DateTime? deliveredAt;

  DateTime? cancelledAt;

  String? cancellationReason;

  String? deliveryPersonName;

  String? deliveryPersonPhone;

  String? deliveryOtp;

  String? couponApplied;

  String orderType;

  String? sourceOrderNumber;

  String? complaintId;

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Order copyWith({
    String? orderId,
    String? userId,
    String? userName,
    String? userPhone,
    List<_i2.OrderItem>? items,
    int? itemCount,
    double? totalAmount,
    double? discountAmount,
    double? deliveryFee,
    double? finalAmount,
    String? status,
    String? paymentStatus,
    String? refundStatus,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    _i3.Address? deliveryAddress,
    DateTime? orderedAt,
    DateTime? confirmedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? couponApplied,
    String? orderType,
    String? sourceOrderNumber,
    String? complaintId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Order',
      'orderId': orderId,
      'userId': userId,
      if (userName != null) 'userName': userName,
      'userPhone': userPhone,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'deliveryFee': deliveryFee,
      'finalAmount': finalAmount,
      'status': status,
      'paymentStatus': paymentStatus,
      'refundStatus': refundStatus,
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (razorpayPaymentId != null) 'razorpayPaymentId': razorpayPaymentId,
      'deliveryAddress': deliveryAddress.toJson(),
      'orderedAt': orderedAt.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (outForDeliveryAt != null)
        'outForDeliveryAt': outForDeliveryAt?.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (deliveryPersonName != null) 'deliveryPersonName': deliveryPersonName,
      if (deliveryPersonPhone != null)
        'deliveryPersonPhone': deliveryPersonPhone,
      if (deliveryOtp != null) 'deliveryOtp': deliveryOtp,
      if (couponApplied != null) 'couponApplied': couponApplied,
      'orderType': orderType,
      if (sourceOrderNumber != null) 'sourceOrderNumber': sourceOrderNumber,
      if (complaintId != null) 'complaintId': complaintId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    required String orderId,
    required String userId,
    String? userName,
    required String userPhone,
    required List<_i2.OrderItem> items,
    required int itemCount,
    required double totalAmount,
    required double discountAmount,
    required double deliveryFee,
    required double finalAmount,
    required String status,
    required String paymentStatus,
    required String refundStatus,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    required _i3.Address deliveryAddress,
    required DateTime orderedAt,
    DateTime? confirmedAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryOtp,
    String? couponApplied,
    required String orderType,
    String? sourceOrderNumber,
    String? complaintId,
  }) : super._(
         orderId: orderId,
         userId: userId,
         userName: userName,
         userPhone: userPhone,
         items: items,
         itemCount: itemCount,
         totalAmount: totalAmount,
         discountAmount: discountAmount,
         deliveryFee: deliveryFee,
         finalAmount: finalAmount,
         status: status,
         paymentStatus: paymentStatus,
         refundStatus: refundStatus,
         razorpayOrderId: razorpayOrderId,
         razorpayPaymentId: razorpayPaymentId,
         deliveryAddress: deliveryAddress,
         orderedAt: orderedAt,
         confirmedAt: confirmedAt,
         outForDeliveryAt: outForDeliveryAt,
         deliveredAt: deliveredAt,
         cancelledAt: cancelledAt,
         cancellationReason: cancellationReason,
         deliveryPersonName: deliveryPersonName,
         deliveryPersonPhone: deliveryPersonPhone,
         deliveryOtp: deliveryOtp,
         couponApplied: couponApplied,
         orderType: orderType,
         sourceOrderNumber: sourceOrderNumber,
         complaintId: complaintId,
       );

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Order copyWith({
    String? orderId,
    String? userId,
    Object? userName = _Undefined,
    String? userPhone,
    List<_i2.OrderItem>? items,
    int? itemCount,
    double? totalAmount,
    double? discountAmount,
    double? deliveryFee,
    double? finalAmount,
    String? status,
    String? paymentStatus,
    String? refundStatus,
    Object? razorpayOrderId = _Undefined,
    Object? razorpayPaymentId = _Undefined,
    _i3.Address? deliveryAddress,
    DateTime? orderedAt,
    Object? confirmedAt = _Undefined,
    Object? outForDeliveryAt = _Undefined,
    Object? deliveredAt = _Undefined,
    Object? cancelledAt = _Undefined,
    Object? cancellationReason = _Undefined,
    Object? deliveryPersonName = _Undefined,
    Object? deliveryPersonPhone = _Undefined,
    Object? deliveryOtp = _Undefined,
    Object? couponApplied = _Undefined,
    String? orderType,
    Object? sourceOrderNumber = _Undefined,
    Object? complaintId = _Undefined,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      userName: userName is String? ? userName : this.userName,
      userPhone: userPhone ?? this.userPhone,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      itemCount: itemCount ?? this.itemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      finalAmount: finalAmount ?? this.finalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      refundStatus: refundStatus ?? this.refundStatus,
      razorpayOrderId: razorpayOrderId is String?
          ? razorpayOrderId
          : this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId is String?
          ? razorpayPaymentId
          : this.razorpayPaymentId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress.copyWith(),
      orderedAt: orderedAt ?? this.orderedAt,
      confirmedAt: confirmedAt is DateTime? ? confirmedAt : this.confirmedAt,
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
      couponApplied: couponApplied is String?
          ? couponApplied
          : this.couponApplied,
      orderType: orderType ?? this.orderType,
      sourceOrderNumber: sourceOrderNumber is String?
          ? sourceOrderNumber
          : this.sourceOrderNumber,
      complaintId: complaintId is String? ? complaintId : this.complaintId,
    );
  }
}
