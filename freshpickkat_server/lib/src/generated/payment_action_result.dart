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

abstract class PaymentActionResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentActionResult._({
    required this.success,
    this.message,
    this.error,
    this.refundId,
    this.amount,
    this.status,
    this.paymentId,
  });

  factory PaymentActionResult({
    required bool success,
    String? message,
    String? error,
    String? refundId,
    int? amount,
    String? status,
    String? paymentId,
  }) = _PaymentActionResultImpl;

  factory PaymentActionResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentActionResult(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String?,
      error: jsonSerialization['error'] as String?,
      refundId: jsonSerialization['refundId'] as String?,
      amount: jsonSerialization['amount'] as int?,
      status: jsonSerialization['status'] as String?,
      paymentId: jsonSerialization['paymentId'] as String?,
    );
  }

  bool success;

  String? message;

  String? error;

  String? refundId;

  int? amount;

  String? status;

  String? paymentId;

  /// Returns a shallow copy of this [PaymentActionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentActionResult copyWith({
    bool? success,
    String? message,
    String? error,
    String? refundId,
    int? amount,
    String? status,
    String? paymentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentActionResult',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (refundId != null) 'refundId': refundId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (paymentId != null) 'paymentId': paymentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentActionResult',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (refundId != null) 'refundId': refundId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (paymentId != null) 'paymentId': paymentId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentActionResultImpl extends PaymentActionResult {
  _PaymentActionResultImpl({
    required bool success,
    String? message,
    String? error,
    String? refundId,
    int? amount,
    String? status,
    String? paymentId,
  }) : super._(
         success: success,
         message: message,
         error: error,
         refundId: refundId,
         amount: amount,
         status: status,
         paymentId: paymentId,
       );

  /// Returns a shallow copy of this [PaymentActionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentActionResult copyWith({
    bool? success,
    Object? message = _Undefined,
    Object? error = _Undefined,
    Object? refundId = _Undefined,
    Object? amount = _Undefined,
    Object? status = _Undefined,
    Object? paymentId = _Undefined,
  }) {
    return PaymentActionResult(
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      error: error is String? ? error : this.error,
      refundId: refundId is String? ? refundId : this.refundId,
      amount: amount is int? ? amount : this.amount,
      status: status is String? ? status : this.status,
      paymentId: paymentId is String? ? paymentId : this.paymentId,
    );
  }
}
