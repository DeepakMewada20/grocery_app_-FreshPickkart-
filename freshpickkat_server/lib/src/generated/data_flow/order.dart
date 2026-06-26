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
import '../data_flow/order_item.dart' as _i2;
import '../data_flow/address.dart' as _i3;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i4;

abstract class Order
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Order._({
    required this.orderId,
    required this.userId,
    this.userName,
    required this.userPhone,
    required this.items,
    required this.itemCount,
    required this.totalAmount,
    required this.discountAmount,
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    required this.deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    this.freeDeliveryReason,
    this.couponSnapshot,
    this.paymentSnapshot,
    this.addressSnapshot,
    this.pricingSnapshot,
    this.deliverySnapshot,
    required this.freshPointsUsed,
    required this.freshPointsValue,
    required this.actualPaymentAmount,
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
    this.deliveryOtpExpiresAt,
    this.deliveryVerificationMethod,
    this.deliveryProofImageUrl,
    this.deliveryProofLatitude,
    this.deliveryProofLongitude,
    this.deliveryProofTimestamp,
    this.deliveryProofDistanceMeters,
    this.deliveryProofGpsAccuracy,
    this.deliveredByUserId,
    this.deliveredByName,
    this.deliveredByRole,
    this.deliveryCompletedAt,
    this.deliveryOtpVerifiedAt,
    this.couponApplied,
    required this.orderType,
    this.sourceOrderNumber,
    this.complaintId,
    this.paymentMode,
  }) : mrpTotal = mrpTotal ?? 0.0,
       productDiscountAmount = productDiscountAmount ?? 0.0,
       comboDiscountAmount = comboDiscountAmount ?? 0.0,
       bogoDiscountAmount = bogoDiscountAmount ?? 0.0,
       originalDeliveryFee = originalDeliveryFee ?? 0.0,
       deliveryDiscountAmount = deliveryDiscountAmount ?? 0.0,
       freeDeliveryApplied = freeDeliveryApplied ?? false;

  factory Order({
    required String orderId,
    required String userId,
    String? userName,
    required String userPhone,
    required List<_i2.OrderItem> items,
    required int itemCount,
    required double totalAmount,
    required double discountAmount,
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    required double deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    String? freeDeliveryReason,
    String? couponSnapshot,
    String? paymentSnapshot,
    String? addressSnapshot,
    String? pricingSnapshot,
    String? deliverySnapshot,
    required int freshPointsUsed,
    required double freshPointsValue,
    required double actualPaymentAmount,
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
    DateTime? deliveryOtpExpiresAt,
    String? deliveryVerificationMethod,
    String? deliveryProofImageUrl,
    double? deliveryProofLatitude,
    double? deliveryProofLongitude,
    DateTime? deliveryProofTimestamp,
    double? deliveryProofDistanceMeters,
    double? deliveryProofGpsAccuracy,
    String? deliveredByUserId,
    String? deliveredByName,
    String? deliveredByRole,
    DateTime? deliveryCompletedAt,
    DateTime? deliveryOtpVerifiedAt,
    String? couponApplied,
    required String orderType,
    String? sourceOrderNumber,
    String? complaintId,
    String? paymentMode,
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
      mrpTotal: (jsonSerialization['mrpTotal'] as num?)?.toDouble(),
      productDiscountAmount:
          (jsonSerialization['productDiscountAmount'] as num?)?.toDouble(),
      comboDiscountAmount: (jsonSerialization['comboDiscountAmount'] as num?)
          ?.toDouble(),
      bogoDiscountAmount: (jsonSerialization['bogoDiscountAmount'] as num?)
          ?.toDouble(),
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      originalDeliveryFee: (jsonSerialization['originalDeliveryFee'] as num?)
          ?.toDouble(),
      deliveryDiscountAmount:
          (jsonSerialization['deliveryDiscountAmount'] as num?)?.toDouble(),
      freeDeliveryApplied: jsonSerialization['freeDeliveryApplied'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['freeDeliveryApplied'],
            ),
      freeDeliveryReason: jsonSerialization['freeDeliveryReason'] as String?,
      couponSnapshot: jsonSerialization['couponSnapshot'] as String?,
      paymentSnapshot: jsonSerialization['paymentSnapshot'] as String?,
      addressSnapshot: jsonSerialization['addressSnapshot'] as String?,
      pricingSnapshot: jsonSerialization['pricingSnapshot'] as String?,
      deliverySnapshot: jsonSerialization['deliverySnapshot'] as String?,
      freshPointsUsed: jsonSerialization['freshPointsUsed'] as int,
      freshPointsValue: (jsonSerialization['freshPointsValue'] as num)
          .toDouble(),
      actualPaymentAmount: (jsonSerialization['actualPaymentAmount'] as num)
          .toDouble(),
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
      deliveryOtpExpiresAt: jsonSerialization['deliveryOtpExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveryOtpExpiresAt'],
            ),
      deliveryVerificationMethod:
          jsonSerialization['deliveryVerificationMethod'] as String?,
      deliveryProofImageUrl:
          jsonSerialization['deliveryProofImageUrl'] as String?,
      deliveryProofLatitude:
          (jsonSerialization['deliveryProofLatitude'] as num?)?.toDouble(),
      deliveryProofLongitude:
          (jsonSerialization['deliveryProofLongitude'] as num?)?.toDouble(),
      deliveryProofTimestamp:
          jsonSerialization['deliveryProofTimestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveryProofTimestamp'],
            ),
      deliveryProofDistanceMeters:
          (jsonSerialization['deliveryProofDistanceMeters'] as num?)
              ?.toDouble(),
      deliveryProofGpsAccuracy:
          (jsonSerialization['deliveryProofGpsAccuracy'] as num?)?.toDouble(),
      deliveredByUserId: jsonSerialization['deliveredByUserId'] as String?,
      deliveredByName: jsonSerialization['deliveredByName'] as String?,
      deliveredByRole: jsonSerialization['deliveredByRole'] as String?,
      deliveryCompletedAt: jsonSerialization['deliveryCompletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveryCompletedAt'],
            ),
      deliveryOtpVerifiedAt: jsonSerialization['deliveryOtpVerifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveryOtpVerifiedAt'],
            ),
      couponApplied: jsonSerialization['couponApplied'] as String?,
      orderType: jsonSerialization['orderType'] as String,
      sourceOrderNumber: jsonSerialization['sourceOrderNumber'] as String?,
      complaintId: jsonSerialization['complaintId'] as String?,
      paymentMode: jsonSerialization['paymentMode'] as String?,
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

  double mrpTotal;

  double productDiscountAmount;

  double comboDiscountAmount;

  double bogoDiscountAmount;

  double deliveryFee;

  double originalDeliveryFee;

  double deliveryDiscountAmount;

  bool freeDeliveryApplied;

  String? freeDeliveryReason;

  String? couponSnapshot;

  String? paymentSnapshot;

  String? addressSnapshot;

  String? pricingSnapshot;

  String? deliverySnapshot;

  int freshPointsUsed;

  double freshPointsValue;

  double actualPaymentAmount;

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

  DateTime? deliveryOtpExpiresAt;

  String? deliveryVerificationMethod;

  String? deliveryProofImageUrl;

  double? deliveryProofLatitude;

  double? deliveryProofLongitude;

  DateTime? deliveryProofTimestamp;

  double? deliveryProofDistanceMeters;

  double? deliveryProofGpsAccuracy;

  String? deliveredByUserId;

  String? deliveredByName;

  String? deliveredByRole;

  DateTime? deliveryCompletedAt;

  DateTime? deliveryOtpVerifiedAt;

  String? couponApplied;

  String orderType;

  String? sourceOrderNumber;

  String? complaintId;

  String? paymentMode;

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
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    double? deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    String? freeDeliveryReason,
    String? couponSnapshot,
    String? paymentSnapshot,
    String? addressSnapshot,
    String? pricingSnapshot,
    String? deliverySnapshot,
    int? freshPointsUsed,
    double? freshPointsValue,
    double? actualPaymentAmount,
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
    DateTime? deliveryOtpExpiresAt,
    String? deliveryVerificationMethod,
    String? deliveryProofImageUrl,
    double? deliveryProofLatitude,
    double? deliveryProofLongitude,
    DateTime? deliveryProofTimestamp,
    double? deliveryProofDistanceMeters,
    double? deliveryProofGpsAccuracy,
    String? deliveredByUserId,
    String? deliveredByName,
    String? deliveredByRole,
    DateTime? deliveryCompletedAt,
    DateTime? deliveryOtpVerifiedAt,
    String? couponApplied,
    String? orderType,
    String? sourceOrderNumber,
    String? complaintId,
    String? paymentMode,
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
      'mrpTotal': mrpTotal,
      'productDiscountAmount': productDiscountAmount,
      'comboDiscountAmount': comboDiscountAmount,
      'bogoDiscountAmount': bogoDiscountAmount,
      'deliveryFee': deliveryFee,
      'originalDeliveryFee': originalDeliveryFee,
      'deliveryDiscountAmount': deliveryDiscountAmount,
      'freeDeliveryApplied': freeDeliveryApplied,
      if (freeDeliveryReason != null) 'freeDeliveryReason': freeDeliveryReason,
      if (couponSnapshot != null) 'couponSnapshot': couponSnapshot,
      if (paymentSnapshot != null) 'paymentSnapshot': paymentSnapshot,
      if (addressSnapshot != null) 'addressSnapshot': addressSnapshot,
      if (pricingSnapshot != null) 'pricingSnapshot': pricingSnapshot,
      if (deliverySnapshot != null) 'deliverySnapshot': deliverySnapshot,
      'freshPointsUsed': freshPointsUsed,
      'freshPointsValue': freshPointsValue,
      'actualPaymentAmount': actualPaymentAmount,
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
      if (deliveryOtpExpiresAt != null)
        'deliveryOtpExpiresAt': deliveryOtpExpiresAt?.toJson(),
      if (deliveryVerificationMethod != null)
        'deliveryVerificationMethod': deliveryVerificationMethod,
      if (deliveryProofImageUrl != null)
        'deliveryProofImageUrl': deliveryProofImageUrl,
      if (deliveryProofLatitude != null)
        'deliveryProofLatitude': deliveryProofLatitude,
      if (deliveryProofLongitude != null)
        'deliveryProofLongitude': deliveryProofLongitude,
      if (deliveryProofTimestamp != null)
        'deliveryProofTimestamp': deliveryProofTimestamp?.toJson(),
      if (deliveryProofDistanceMeters != null)
        'deliveryProofDistanceMeters': deliveryProofDistanceMeters,
      if (deliveryProofGpsAccuracy != null)
        'deliveryProofGpsAccuracy': deliveryProofGpsAccuracy,
      if (deliveredByUserId != null) 'deliveredByUserId': deliveredByUserId,
      if (deliveredByName != null) 'deliveredByName': deliveredByName,
      if (deliveredByRole != null) 'deliveredByRole': deliveredByRole,
      if (deliveryCompletedAt != null)
        'deliveryCompletedAt': deliveryCompletedAt?.toJson(),
      if (deliveryOtpVerifiedAt != null)
        'deliveryOtpVerifiedAt': deliveryOtpVerifiedAt?.toJson(),
      if (couponApplied != null) 'couponApplied': couponApplied,
      'orderType': orderType,
      if (sourceOrderNumber != null) 'sourceOrderNumber': sourceOrderNumber,
      if (complaintId != null) 'complaintId': complaintId,
      if (paymentMode != null) 'paymentMode': paymentMode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Order',
      'orderId': orderId,
      'userId': userId,
      if (userName != null) 'userName': userName,
      'userPhone': userPhone,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'mrpTotal': mrpTotal,
      'productDiscountAmount': productDiscountAmount,
      'comboDiscountAmount': comboDiscountAmount,
      'bogoDiscountAmount': bogoDiscountAmount,
      'deliveryFee': deliveryFee,
      'originalDeliveryFee': originalDeliveryFee,
      'deliveryDiscountAmount': deliveryDiscountAmount,
      'freeDeliveryApplied': freeDeliveryApplied,
      if (freeDeliveryReason != null) 'freeDeliveryReason': freeDeliveryReason,
      if (couponSnapshot != null) 'couponSnapshot': couponSnapshot,
      if (paymentSnapshot != null) 'paymentSnapshot': paymentSnapshot,
      if (addressSnapshot != null) 'addressSnapshot': addressSnapshot,
      if (pricingSnapshot != null) 'pricingSnapshot': pricingSnapshot,
      if (deliverySnapshot != null) 'deliverySnapshot': deliverySnapshot,
      'freshPointsUsed': freshPointsUsed,
      'freshPointsValue': freshPointsValue,
      'actualPaymentAmount': actualPaymentAmount,
      'finalAmount': finalAmount,
      'status': status,
      'paymentStatus': paymentStatus,
      'refundStatus': refundStatus,
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (razorpayPaymentId != null) 'razorpayPaymentId': razorpayPaymentId,
      'deliveryAddress': deliveryAddress.toJsonForProtocol(),
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
      if (deliveryOtpExpiresAt != null)
        'deliveryOtpExpiresAt': deliveryOtpExpiresAt?.toJson(),
      if (deliveryVerificationMethod != null)
        'deliveryVerificationMethod': deliveryVerificationMethod,
      if (deliveryProofImageUrl != null)
        'deliveryProofImageUrl': deliveryProofImageUrl,
      if (deliveryProofLatitude != null)
        'deliveryProofLatitude': deliveryProofLatitude,
      if (deliveryProofLongitude != null)
        'deliveryProofLongitude': deliveryProofLongitude,
      if (deliveryProofTimestamp != null)
        'deliveryProofTimestamp': deliveryProofTimestamp?.toJson(),
      if (deliveryProofDistanceMeters != null)
        'deliveryProofDistanceMeters': deliveryProofDistanceMeters,
      if (deliveryProofGpsAccuracy != null)
        'deliveryProofGpsAccuracy': deliveryProofGpsAccuracy,
      if (deliveredByUserId != null) 'deliveredByUserId': deliveredByUserId,
      if (deliveredByName != null) 'deliveredByName': deliveredByName,
      if (deliveredByRole != null) 'deliveredByRole': deliveredByRole,
      if (deliveryCompletedAt != null)
        'deliveryCompletedAt': deliveryCompletedAt?.toJson(),
      if (deliveryOtpVerifiedAt != null)
        'deliveryOtpVerifiedAt': deliveryOtpVerifiedAt?.toJson(),
      if (couponApplied != null) 'couponApplied': couponApplied,
      'orderType': orderType,
      if (sourceOrderNumber != null) 'sourceOrderNumber': sourceOrderNumber,
      if (complaintId != null) 'complaintId': complaintId,
      if (paymentMode != null) 'paymentMode': paymentMode,
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
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    required double deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    String? freeDeliveryReason,
    String? couponSnapshot,
    String? paymentSnapshot,
    String? addressSnapshot,
    String? pricingSnapshot,
    String? deliverySnapshot,
    required int freshPointsUsed,
    required double freshPointsValue,
    required double actualPaymentAmount,
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
    DateTime? deliveryOtpExpiresAt,
    String? deliveryVerificationMethod,
    String? deliveryProofImageUrl,
    double? deliveryProofLatitude,
    double? deliveryProofLongitude,
    DateTime? deliveryProofTimestamp,
    double? deliveryProofDistanceMeters,
    double? deliveryProofGpsAccuracy,
    String? deliveredByUserId,
    String? deliveredByName,
    String? deliveredByRole,
    DateTime? deliveryCompletedAt,
    DateTime? deliveryOtpVerifiedAt,
    String? couponApplied,
    required String orderType,
    String? sourceOrderNumber,
    String? complaintId,
    String? paymentMode,
  }) : super._(
         orderId: orderId,
         userId: userId,
         userName: userName,
         userPhone: userPhone,
         items: items,
         itemCount: itemCount,
         totalAmount: totalAmount,
         discountAmount: discountAmount,
         mrpTotal: mrpTotal,
         productDiscountAmount: productDiscountAmount,
         comboDiscountAmount: comboDiscountAmount,
         bogoDiscountAmount: bogoDiscountAmount,
         deliveryFee: deliveryFee,
         originalDeliveryFee: originalDeliveryFee,
         deliveryDiscountAmount: deliveryDiscountAmount,
         freeDeliveryApplied: freeDeliveryApplied,
         freeDeliveryReason: freeDeliveryReason,
         couponSnapshot: couponSnapshot,
         paymentSnapshot: paymentSnapshot,
         addressSnapshot: addressSnapshot,
         pricingSnapshot: pricingSnapshot,
         deliverySnapshot: deliverySnapshot,
         freshPointsUsed: freshPointsUsed,
         freshPointsValue: freshPointsValue,
         actualPaymentAmount: actualPaymentAmount,
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
         deliveryOtpExpiresAt: deliveryOtpExpiresAt,
         deliveryVerificationMethod: deliveryVerificationMethod,
         deliveryProofImageUrl: deliveryProofImageUrl,
         deliveryProofLatitude: deliveryProofLatitude,
         deliveryProofLongitude: deliveryProofLongitude,
         deliveryProofTimestamp: deliveryProofTimestamp,
         deliveryProofDistanceMeters: deliveryProofDistanceMeters,
         deliveryProofGpsAccuracy: deliveryProofGpsAccuracy,
         deliveredByUserId: deliveredByUserId,
         deliveredByName: deliveredByName,
         deliveredByRole: deliveredByRole,
         deliveryCompletedAt: deliveryCompletedAt,
         deliveryOtpVerifiedAt: deliveryOtpVerifiedAt,
         couponApplied: couponApplied,
         orderType: orderType,
         sourceOrderNumber: sourceOrderNumber,
         complaintId: complaintId,
         paymentMode: paymentMode,
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
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    double? deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    Object? freeDeliveryReason = _Undefined,
    Object? couponSnapshot = _Undefined,
    Object? paymentSnapshot = _Undefined,
    Object? addressSnapshot = _Undefined,
    Object? pricingSnapshot = _Undefined,
    Object? deliverySnapshot = _Undefined,
    int? freshPointsUsed,
    double? freshPointsValue,
    double? actualPaymentAmount,
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
    Object? deliveryOtpExpiresAt = _Undefined,
    Object? deliveryVerificationMethod = _Undefined,
    Object? deliveryProofImageUrl = _Undefined,
    Object? deliveryProofLatitude = _Undefined,
    Object? deliveryProofLongitude = _Undefined,
    Object? deliveryProofTimestamp = _Undefined,
    Object? deliveryProofDistanceMeters = _Undefined,
    Object? deliveryProofGpsAccuracy = _Undefined,
    Object? deliveredByUserId = _Undefined,
    Object? deliveredByName = _Undefined,
    Object? deliveredByRole = _Undefined,
    Object? deliveryCompletedAt = _Undefined,
    Object? deliveryOtpVerifiedAt = _Undefined,
    Object? couponApplied = _Undefined,
    String? orderType,
    Object? sourceOrderNumber = _Undefined,
    Object? complaintId = _Undefined,
    Object? paymentMode = _Undefined,
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
      mrpTotal: mrpTotal ?? this.mrpTotal,
      productDiscountAmount:
          productDiscountAmount ?? this.productDiscountAmount,
      comboDiscountAmount: comboDiscountAmount ?? this.comboDiscountAmount,
      bogoDiscountAmount: bogoDiscountAmount ?? this.bogoDiscountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      originalDeliveryFee: originalDeliveryFee ?? this.originalDeliveryFee,
      deliveryDiscountAmount:
          deliveryDiscountAmount ?? this.deliveryDiscountAmount,
      freeDeliveryApplied: freeDeliveryApplied ?? this.freeDeliveryApplied,
      freeDeliveryReason: freeDeliveryReason is String?
          ? freeDeliveryReason
          : this.freeDeliveryReason,
      couponSnapshot: couponSnapshot is String?
          ? couponSnapshot
          : this.couponSnapshot,
      paymentSnapshot: paymentSnapshot is String?
          ? paymentSnapshot
          : this.paymentSnapshot,
      addressSnapshot: addressSnapshot is String?
          ? addressSnapshot
          : this.addressSnapshot,
      pricingSnapshot: pricingSnapshot is String?
          ? pricingSnapshot
          : this.pricingSnapshot,
      deliverySnapshot: deliverySnapshot is String?
          ? deliverySnapshot
          : this.deliverySnapshot,
      freshPointsUsed: freshPointsUsed ?? this.freshPointsUsed,
      freshPointsValue: freshPointsValue ?? this.freshPointsValue,
      actualPaymentAmount: actualPaymentAmount ?? this.actualPaymentAmount,
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
      deliveryOtpExpiresAt: deliveryOtpExpiresAt is DateTime?
          ? deliveryOtpExpiresAt
          : this.deliveryOtpExpiresAt,
      deliveryVerificationMethod: deliveryVerificationMethod is String?
          ? deliveryVerificationMethod
          : this.deliveryVerificationMethod,
      deliveryProofImageUrl: deliveryProofImageUrl is String?
          ? deliveryProofImageUrl
          : this.deliveryProofImageUrl,
      deliveryProofLatitude: deliveryProofLatitude is double?
          ? deliveryProofLatitude
          : this.deliveryProofLatitude,
      deliveryProofLongitude: deliveryProofLongitude is double?
          ? deliveryProofLongitude
          : this.deliveryProofLongitude,
      deliveryProofTimestamp: deliveryProofTimestamp is DateTime?
          ? deliveryProofTimestamp
          : this.deliveryProofTimestamp,
      deliveryProofDistanceMeters: deliveryProofDistanceMeters is double?
          ? deliveryProofDistanceMeters
          : this.deliveryProofDistanceMeters,
      deliveryProofGpsAccuracy: deliveryProofGpsAccuracy is double?
          ? deliveryProofGpsAccuracy
          : this.deliveryProofGpsAccuracy,
      deliveredByUserId: deliveredByUserId is String?
          ? deliveredByUserId
          : this.deliveredByUserId,
      deliveredByName: deliveredByName is String?
          ? deliveredByName
          : this.deliveredByName,
      deliveredByRole: deliveredByRole is String?
          ? deliveredByRole
          : this.deliveredByRole,
      deliveryCompletedAt: deliveryCompletedAt is DateTime?
          ? deliveryCompletedAt
          : this.deliveryCompletedAt,
      deliveryOtpVerifiedAt: deliveryOtpVerifiedAt is DateTime?
          ? deliveryOtpVerifiedAt
          : this.deliveryOtpVerifiedAt,
      couponApplied: couponApplied is String?
          ? couponApplied
          : this.couponApplied,
      orderType: orderType ?? this.orderType,
      sourceOrderNumber: sourceOrderNumber is String?
          ? sourceOrderNumber
          : this.sourceOrderNumber,
      complaintId: complaintId is String? ? complaintId : this.complaintId,
      paymentMode: paymentMode is String? ? paymentMode : this.paymentMode,
    );
  }
}
