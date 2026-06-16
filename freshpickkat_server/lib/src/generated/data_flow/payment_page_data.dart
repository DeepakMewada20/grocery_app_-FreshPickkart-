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
import '../data_flow/payment_page_item.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class PaymentPageData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentPageData._({
    required this.valid,
    this.errorMessage,
    this.orderId,
    this.orderNumber,
    this.finalAmount,
    this.itemCount,
    this.deliveryAddress,
    this.items,
    this.razorpayOrderId,
    this.amountPaise,
    this.currency,
    this.expiresAt,
    this.createdAt,
  });

  factory PaymentPageData({
    required bool valid,
    String? errorMessage,
    String? orderId,
    String? orderNumber,
    double? finalAmount,
    int? itemCount,
    String? deliveryAddress,
    List<_i2.PaymentPageItem>? items,
    String? razorpayOrderId,
    int? amountPaise,
    String? currency,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) = _PaymentPageDataImpl;

  factory PaymentPageData.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentPageData(
      valid: _i1.BoolJsonExtension.fromJson(jsonSerialization['valid']),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      orderId: jsonSerialization['orderId'] as String?,
      orderNumber: jsonSerialization['orderNumber'] as String?,
      finalAmount: (jsonSerialization['finalAmount'] as num?)?.toDouble(),
      itemCount: jsonSerialization['itemCount'] as int?,
      deliveryAddress: jsonSerialization['deliveryAddress'] as String?,
      items: (jsonSerialization['items'] as List<dynamic>?)
          ?.map((item) =>
              _i3.Protocol().deserialize<_i2.PaymentPageItem>(item))
          .toList(),
      razorpayOrderId: jsonSerialization['razorpayOrderId'] as String?,
      amountPaise: jsonSerialization['amountPaise'] as int?,
      currency: jsonSerialization['currency'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  bool valid;

  String? errorMessage;

  String? orderId;

  String? orderNumber;

  double? finalAmount;

  int? itemCount;

  String? deliveryAddress;

  List<_i2.PaymentPageItem>? items;

  String? razorpayOrderId;

  int? amountPaise;

  String? currency;

  DateTime? expiresAt;

  DateTime? createdAt;

  @_i1.useResult
  PaymentPageData copyWith({
    bool? valid,
    Object? errorMessage = _Undefined,
    Object? orderId = _Undefined,
    Object? orderNumber = _Undefined,
    Object? finalAmount = _Undefined,
    Object? itemCount = _Undefined,
    Object? deliveryAddress = _Undefined,
    Object? items = _Undefined,
    Object? razorpayOrderId = _Undefined,
    Object? amountPaise = _Undefined,
    Object? currency = _Undefined,
    Object? expiresAt = _Undefined,
    Object? createdAt = _Undefined,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentPageData',
      'valid': valid,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (orderId != null) 'orderId': orderId,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (finalAmount != null) 'finalAmount': finalAmount,
      if (itemCount != null) 'itemCount': itemCount,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (items != null) 'items': items?.map((item) => item.toJson()).toList(),
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (amountPaise != null) 'amountPaise': amountPaise,
      if (currency != null) 'currency': currency,
      if (expiresAt != null) 'expiresAt': expiresAt?.toUtc().toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentPageData',
      'valid': valid,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (orderId != null) 'orderId': orderId,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (finalAmount != null) 'finalAmount': finalAmount,
      if (itemCount != null) 'itemCount': itemCount,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (items != null)
        'items': items?.map((item) => item.toJsonForProtocol()).toList(),
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (amountPaise != null) 'amountPaise': amountPaise,
      if (currency != null) 'currency': currency,
      if (expiresAt != null) 'expiresAt': expiresAt?.toUtc().toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentPageDataImpl extends PaymentPageData {
  _PaymentPageDataImpl({
    required bool valid,
    String? errorMessage,
    String? orderId,
    String? orderNumber,
    double? finalAmount,
    int? itemCount,
    String? deliveryAddress,
    List<_i2.PaymentPageItem>? items,
    String? razorpayOrderId,
    int? amountPaise,
    String? currency,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) : super._(
         valid: valid,
         errorMessage: errorMessage,
         orderId: orderId,
         orderNumber: orderNumber,
         finalAmount: finalAmount,
         itemCount: itemCount,
         deliveryAddress: deliveryAddress,
         items: items,
         razorpayOrderId: razorpayOrderId,
         amountPaise: amountPaise,
         currency: currency,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  @_i1.useResult
  @override
  PaymentPageData copyWith({
    Object? valid,
    Object? errorMessage = _Undefined,
    Object? orderId = _Undefined,
    Object? orderNumber = _Undefined,
    Object? finalAmount = _Undefined,
    Object? itemCount = _Undefined,
    Object? deliveryAddress = _Undefined,
    Object? items = _Undefined,
    Object? razorpayOrderId = _Undefined,
    Object? amountPaise = _Undefined,
    Object? currency = _Undefined,
    Object? expiresAt = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return PaymentPageData(
      valid: valid is bool ? valid : this.valid,
      errorMessage: errorMessage is String?
          ? errorMessage
          : this.errorMessage,
      orderId: orderId is String? ? orderId : this.orderId,
      orderNumber: orderNumber is String?
          ? orderNumber
          : this.orderNumber,
      finalAmount: finalAmount is double?
          ? finalAmount
          : this.finalAmount,
      itemCount: itemCount is int? ? itemCount : this.itemCount,
      deliveryAddress: deliveryAddress is String?
          ? deliveryAddress
          : this.deliveryAddress,
      items: items is List<_i2.PaymentPageItem>?
          ? items
          : this.items?.map((e) => e.copyWith()).toList(),
      razorpayOrderId: razorpayOrderId is String?
          ? razorpayOrderId
          : this.razorpayOrderId,
      amountPaise: amountPaise is int?
          ? amountPaise
          : this.amountPaise,
      currency: currency is String? ? currency : this.currency,
      expiresAt: expiresAt is DateTime?
          ? expiresAt
          : this.expiresAt,
      createdAt: createdAt is DateTime?
          ? createdAt
          : this.createdAt,
    );
  }
}
