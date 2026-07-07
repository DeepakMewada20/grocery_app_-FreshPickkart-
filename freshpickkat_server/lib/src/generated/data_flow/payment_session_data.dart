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

abstract class PaymentSessionData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentSessionData._({
    required this.success,
    this.sessionId,
    this.orderId,
    this.amount,
    this.status,
    this.razorpayQrId,
    this.qrImageUrl,
    this.expiresAt,
    this.expiresInSeconds,
    this.gatewayPaymentId,
    this.paidAt,
    this.error,
  });

  factory PaymentSessionData({
    required bool success,
    String? sessionId,
    String? orderId,
    double? amount,
    String? status,
    String? razorpayQrId,
    String? qrImageUrl,
    DateTime? expiresAt,
    int? expiresInSeconds,
    String? gatewayPaymentId,
    DateTime? paidAt,
    String? error,
  }) = _PaymentSessionDataImpl;

  factory PaymentSessionData.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentSessionData(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      sessionId: jsonSerialization['sessionId'] as String?,
      orderId: jsonSerialization['orderId'] as String?,
      amount: (jsonSerialization['amount'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
      razorpayQrId: jsonSerialization['razorpayQrId'] as String?,
      qrImageUrl: jsonSerialization['qrImageUrl'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      expiresInSeconds: jsonSerialization['expiresInSeconds'] as int?,
      gatewayPaymentId: jsonSerialization['gatewayPaymentId'] as String?,
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      error: jsonSerialization['error'] as String?,
    );
  }

  bool success;

  String? sessionId;

  String? orderId;

  double? amount;

  String? status;

  String? razorpayQrId;

  String? qrImageUrl;

  DateTime? expiresAt;

  int? expiresInSeconds;

  String? gatewayPaymentId;

  DateTime? paidAt;

  String? error;

  /// Returns a shallow copy of this [PaymentSessionData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentSessionData copyWith({
    bool? success,
    String? sessionId,
    String? orderId,
    double? amount,
    String? status,
    String? razorpayQrId,
    String? qrImageUrl,
    DateTime? expiresAt,
    int? expiresInSeconds,
    String? gatewayPaymentId,
    DateTime? paidAt,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentSessionData',
      'success': success,
      if (sessionId != null) 'sessionId': sessionId,
      if (orderId != null) 'orderId': orderId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (razorpayQrId != null) 'razorpayQrId': razorpayQrId,
      if (qrImageUrl != null) 'qrImageUrl': qrImageUrl,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
      if (gatewayPaymentId != null) 'gatewayPaymentId': gatewayPaymentId,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentSessionData',
      'success': success,
      if (sessionId != null) 'sessionId': sessionId,
      if (orderId != null) 'orderId': orderId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (razorpayQrId != null) 'razorpayQrId': razorpayQrId,
      if (qrImageUrl != null) 'qrImageUrl': qrImageUrl,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expiresInSeconds != null) 'expiresInSeconds': expiresInSeconds,
      if (gatewayPaymentId != null) 'gatewayPaymentId': gatewayPaymentId,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentSessionDataImpl extends PaymentSessionData {
  _PaymentSessionDataImpl({
    required bool success,
    String? sessionId,
    String? orderId,
    double? amount,
    String? status,
    String? razorpayQrId,
    String? qrImageUrl,
    DateTime? expiresAt,
    int? expiresInSeconds,
    String? gatewayPaymentId,
    DateTime? paidAt,
    String? error,
  }) : super._(
         success: success,
         sessionId: sessionId,
         orderId: orderId,
         amount: amount,
         status: status,
         razorpayQrId: razorpayQrId,
         qrImageUrl: qrImageUrl,
         expiresAt: expiresAt,
         expiresInSeconds: expiresInSeconds,
         gatewayPaymentId: gatewayPaymentId,
         paidAt: paidAt,
         error: error,
       );

  /// Returns a shallow copy of this [PaymentSessionData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentSessionData copyWith({
    bool? success,
    Object? sessionId = _Undefined,
    Object? orderId = _Undefined,
    Object? amount = _Undefined,
    Object? status = _Undefined,
    Object? razorpayQrId = _Undefined,
    Object? qrImageUrl = _Undefined,
    Object? expiresAt = _Undefined,
    Object? expiresInSeconds = _Undefined,
    Object? gatewayPaymentId = _Undefined,
    Object? paidAt = _Undefined,
    Object? error = _Undefined,
  }) {
    return PaymentSessionData(
      success: success ?? this.success,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      orderId: orderId is String? ? orderId : this.orderId,
      amount: amount is double? ? amount : this.amount,
      status: status is String? ? status : this.status,
      razorpayQrId: razorpayQrId is String? ? razorpayQrId : this.razorpayQrId,
      qrImageUrl: qrImageUrl is String? ? qrImageUrl : this.qrImageUrl,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      expiresInSeconds: expiresInSeconds is int?
          ? expiresInSeconds
          : this.expiresInSeconds,
      gatewayPaymentId: gatewayPaymentId is String?
          ? gatewayPaymentId
          : this.gatewayPaymentId,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      error: error is String? ? error : this.error,
    );
  }
}
