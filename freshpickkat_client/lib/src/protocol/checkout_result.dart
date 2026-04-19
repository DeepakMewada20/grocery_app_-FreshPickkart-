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
import 'payment_order_result.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class CheckoutResult implements _i1.SerializableModel {
  CheckoutResult._({
    required this.success,
    this.orderId,
    this.paymentOrder,
    this.error,
  });

  factory CheckoutResult({
    required bool success,
    String? orderId,
    _i2.PaymentOrderResult? paymentOrder,
    String? error,
  }) = _CheckoutResultImpl;

  factory CheckoutResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckoutResult(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      orderId: jsonSerialization['orderId'] as String?,
      paymentOrder: jsonSerialization['paymentOrder'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.PaymentOrderResult>(
              jsonSerialization['paymentOrder'],
            ),
      error: jsonSerialization['error'] as String?,
    );
  }

  bool success;

  String? orderId;

  _i2.PaymentOrderResult? paymentOrder;

  String? error;

  /// Returns a shallow copy of this [CheckoutResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutResult copyWith({
    bool? success,
    String? orderId,
    _i2.PaymentOrderResult? paymentOrder,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutResult',
      'success': success,
      if (orderId != null) 'orderId': orderId,
      if (paymentOrder != null) 'paymentOrder': paymentOrder?.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckoutResultImpl extends CheckoutResult {
  _CheckoutResultImpl({
    required bool success,
    String? orderId,
    _i2.PaymentOrderResult? paymentOrder,
    String? error,
  }) : super._(
         success: success,
         orderId: orderId,
         paymentOrder: paymentOrder,
         error: error,
       );

  /// Returns a shallow copy of this [CheckoutResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutResult copyWith({
    bool? success,
    Object? orderId = _Undefined,
    Object? paymentOrder = _Undefined,
    Object? error = _Undefined,
  }) {
    return CheckoutResult(
      success: success ?? this.success,
      orderId: orderId is String? ? orderId : this.orderId,
      paymentOrder: paymentOrder is _i2.PaymentOrderResult?
          ? paymentOrder
          : this.paymentOrder?.copyWith(),
      error: error is String? ? error : this.error,
    );
  }
}
