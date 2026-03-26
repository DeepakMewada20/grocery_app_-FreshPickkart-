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

abstract class PaymentOrderResult implements _i1.SerializableModel {
  PaymentOrderResult._({
    required this.success,
    this.razorpayOrderId,
    this.amount,
    this.currency,
    this.error,
    this.details,
  });

  factory PaymentOrderResult({
    required bool success,
    String? razorpayOrderId,
    int? amount,
    String? currency,
    String? error,
    String? details,
  }) = _PaymentOrderResultImpl;

  factory PaymentOrderResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentOrderResult(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      razorpayOrderId: jsonSerialization['razorpayOrderId'] as String?,
      amount: jsonSerialization['amount'] as int?,
      currency: jsonSerialization['currency'] as String?,
      error: jsonSerialization['error'] as String?,
      details: jsonSerialization['details'] as String?,
    );
  }

  bool success;

  String? razorpayOrderId;

  int? amount;

  String? currency;

  String? error;

  String? details;

  /// Returns a shallow copy of this [PaymentOrderResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentOrderResult copyWith({
    bool? success,
    String? razorpayOrderId,
    int? amount,
    String? currency,
    String? error,
    String? details,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentOrderResult',
      'success': success,
      if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (error != null) 'error': error,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentOrderResultImpl extends PaymentOrderResult {
  _PaymentOrderResultImpl({
    required bool success,
    String? razorpayOrderId,
    int? amount,
    String? currency,
    String? error,
    String? details,
  }) : super._(
         success: success,
         razorpayOrderId: razorpayOrderId,
         amount: amount,
         currency: currency,
         error: error,
         details: details,
       );

  /// Returns a shallow copy of this [PaymentOrderResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentOrderResult copyWith({
    bool? success,
    Object? razorpayOrderId = _Undefined,
    Object? amount = _Undefined,
    Object? currency = _Undefined,
    Object? error = _Undefined,
    Object? details = _Undefined,
  }) {
    return PaymentOrderResult(
      success: success ?? this.success,
      razorpayOrderId: razorpayOrderId is String?
          ? razorpayOrderId
          : this.razorpayOrderId,
      amount: amount is int? ? amount : this.amount,
      currency: currency is String? ? currency : this.currency,
      error: error is String? ? error : this.error,
      details: details is String? ? details : this.details,
    );
  }
}
