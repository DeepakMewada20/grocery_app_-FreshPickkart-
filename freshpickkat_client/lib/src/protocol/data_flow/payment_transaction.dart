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

abstract class PaymentTransaction implements _i1.SerializableModel {
  PaymentTransaction._({
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.amount,
    this.paymentStatus,
    this.gatewayStatus,
    this.failureReason,
  });

  factory PaymentTransaction({
    String? gatewayOrderId,
    String? gatewayPaymentId,
    int? amount,
    String? paymentStatus,
    String? gatewayStatus,
    String? failureReason,
  }) = _PaymentTransactionImpl;

  factory PaymentTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentTransaction(
      gatewayOrderId: jsonSerialization['gatewayOrderId'] as String?,
      gatewayPaymentId: jsonSerialization['gatewayPaymentId'] as String?,
      amount: jsonSerialization['amount'] as int?,
      paymentStatus: jsonSerialization['paymentStatus'] as String?,
      gatewayStatus: jsonSerialization['gatewayStatus'] as String?,
      failureReason: jsonSerialization['failureReason'] as String?,
    );
  }

  String? gatewayOrderId;

  String? gatewayPaymentId;

  int? amount;

  String? paymentStatus;

  String? gatewayStatus;

  String? failureReason;

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentTransaction copyWith({
    String? gatewayOrderId,
    String? gatewayPaymentId,
    int? amount,
    String? paymentStatus,
    String? gatewayStatus,
    String? failureReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentTransaction',
      if (gatewayOrderId != null) 'gatewayOrderId': gatewayOrderId,
      if (gatewayPaymentId != null) 'gatewayPaymentId': gatewayPaymentId,
      if (amount != null) 'amount': amount,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (failureReason != null) 'failureReason': failureReason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentTransactionImpl extends PaymentTransaction {
  _PaymentTransactionImpl({
    String? gatewayOrderId,
    String? gatewayPaymentId,
    int? amount,
    String? paymentStatus,
    String? gatewayStatus,
    String? failureReason,
  }) : super._(
         gatewayOrderId: gatewayOrderId,
         gatewayPaymentId: gatewayPaymentId,
         amount: amount,
         paymentStatus: paymentStatus,
         gatewayStatus: gatewayStatus,
         failureReason: failureReason,
       );

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentTransaction copyWith({
    Object? gatewayOrderId = _Undefined,
    Object? gatewayPaymentId = _Undefined,
    Object? amount = _Undefined,
    Object? paymentStatus = _Undefined,
    Object? gatewayStatus = _Undefined,
    Object? failureReason = _Undefined,
  }) {
    return PaymentTransaction(
      gatewayOrderId: gatewayOrderId is String?
          ? gatewayOrderId
          : this.gatewayOrderId,
      gatewayPaymentId: gatewayPaymentId is String?
          ? gatewayPaymentId
          : this.gatewayPaymentId,
      amount: amount is int? ? amount : this.amount,
      paymentStatus: paymentStatus is String?
          ? paymentStatus
          : this.paymentStatus,
      gatewayStatus: gatewayStatus is String?
          ? gatewayStatus
          : this.gatewayStatus,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
    );
  }
}
