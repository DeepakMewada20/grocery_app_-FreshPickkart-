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

abstract class PaymentLinkData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentLinkData._({
    required this.success,
    this.token,
    this.paymentLink,
    this.expiresAt,
    this.razorpayOrderId,
    this.amount,
    this.orderId,
    this.error,
  });

  factory PaymentLinkData({
    required bool success,
    String? token,
    String? paymentLink,
    DateTime? expiresAt,
    String? razorpayOrderId,
    int? amount,
    String? orderId,
    String? error,
  }) = _PaymentLinkDataImpl;

  factory PaymentLinkData.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentLinkData(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      token: jsonSerialization['token'] as String?,
      paymentLink: jsonSerialization['paymentLink'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      razorpayOrderId: jsonSerialization['razorpayOrderId'] as String?,
      amount: jsonSerialization['amount'] as int?,
      orderId: jsonSerialization['orderId'] as String?,
      error: jsonSerialization['error'] as String?,
    );
  }

  bool success;

  String? token;

  String? paymentLink;

  DateTime? expiresAt;

  String? razorpayOrderId;

  int? amount;

  String? orderId;

  String? error;

  @_i1.useResult
  PaymentLinkData copyWith({
    bool? success,
    String? token,
    String? paymentLink,
    DateTime? expiresAt,
    String? razorpayOrderId,
    int? amount,
    String? orderId,
    String? error,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentLinkData',
      'success': success,
      if (token != null) 'token': token,
      if (paymentLink != null) 'paymentLink': paymentLink,
      if (expiresAt != null) 'expiresAt': expiresAt?.toUtc().toIso8601String(),
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (amount != null) 'amount': amount,
      if (orderId != null) 'orderId': orderId,
      if (error != null) 'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentLinkData',
      'success': success,
      if (token != null) 'token': token,
      if (paymentLink != null) 'paymentLink': paymentLink,
      if (expiresAt != null) 'expiresAt': expiresAt?.toUtc().toIso8601String(),
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (amount != null) 'amount': amount,
      if (orderId != null) 'orderId': orderId,
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentLinkDataImpl extends PaymentLinkData {
  _PaymentLinkDataImpl({
    required bool success,
    String? token,
    String? paymentLink,
    DateTime? expiresAt,
    String? razorpayOrderId,
    int? amount,
    String? orderId,
    String? error,
  }) : super._(
         success: success,
         token: token,
         paymentLink: paymentLink,
         expiresAt: expiresAt,
         razorpayOrderId: razorpayOrderId,
         amount: amount,
         orderId: orderId,
         error: error,
       );

  @_i1.useResult
  @override
  PaymentLinkData copyWith({
    Object? success,
    Object? token = _Undefined,
    Object? paymentLink = _Undefined,
    Object? expiresAt = _Undefined,
    Object? razorpayOrderId = _Undefined,
    Object? amount = _Undefined,
    Object? orderId = _Undefined,
    Object? error = _Undefined,
  }) {
    return PaymentLinkData(
      success: success is bool ? success : this.success,
      token: token is String? ? token : this.token,
      paymentLink: paymentLink is String? ? paymentLink : this.paymentLink,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      razorpayOrderId: razorpayOrderId is String?
          ? razorpayOrderId
          : this.razorpayOrderId,
      amount: amount is int? ? amount : this.amount,
      orderId: orderId is String? ? orderId : this.orderId,
      error: error is String? ? error : this.error,
    );
  }
}
