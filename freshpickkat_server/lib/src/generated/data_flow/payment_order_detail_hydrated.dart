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
import '../data_flow/payment_transaction.dart' as _i2;
import '../data_flow/refund_record.dart' as _i3;
import '../data_flow/razorpay_payment_status.dart' as _i4;
import '../data_flow/razorpay_refund_data.dart' as _i5;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i6;

abstract class PaymentOrderDetailHydrated
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentOrderDetailHydrated._({
    this.paymentTransaction,
    this.refundRecords,
    this.razorpayLiveStatus,
    this.razorpayRefundData,
    this.error,
  });

  factory PaymentOrderDetailHydrated({
    _i2.PaymentTransaction? paymentTransaction,
    List<_i3.RefundRecord>? refundRecords,
    _i4.RazorpayPaymentStatus? razorpayLiveStatus,
    _i5.RazorpayRefundData? razorpayRefundData,
    String? error,
  }) = _PaymentOrderDetailHydratedImpl;

  factory PaymentOrderDetailHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PaymentOrderDetailHydrated(
      paymentTransaction: jsonSerialization['paymentTransaction'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.PaymentTransaction>(
              jsonSerialization['paymentTransaction'],
            ),
      refundRecords: jsonSerialization['refundRecords'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i3.RefundRecord>>(
              jsonSerialization['refundRecords'],
            ),
      razorpayLiveStatus: jsonSerialization['razorpayLiveStatus'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.RazorpayPaymentStatus>(
              jsonSerialization['razorpayLiveStatus'],
            ),
      razorpayRefundData: jsonSerialization['razorpayRefundData'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.RazorpayRefundData>(
              jsonSerialization['razorpayRefundData'],
            ),
      error: jsonSerialization['error'] as String?,
    );
  }

  _i2.PaymentTransaction? paymentTransaction;

  List<_i3.RefundRecord>? refundRecords;

  _i4.RazorpayPaymentStatus? razorpayLiveStatus;

  _i5.RazorpayRefundData? razorpayRefundData;

  String? error;

  /// Returns a shallow copy of this [PaymentOrderDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentOrderDetailHydrated copyWith({
    _i2.PaymentTransaction? paymentTransaction,
    List<_i3.RefundRecord>? refundRecords,
    _i4.RazorpayPaymentStatus? razorpayLiveStatus,
    _i5.RazorpayRefundData? razorpayRefundData,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentOrderDetailHydrated',
      if (paymentTransaction != null)
        'paymentTransaction': paymentTransaction?.toJson(),
      if (refundRecords != null)
        'refundRecords': refundRecords?.toJson(valueToJson: (v) => v.toJson()),
      if (razorpayLiveStatus != null)
        'razorpayLiveStatus': razorpayLiveStatus?.toJson(),
      if (razorpayRefundData != null)
        'razorpayRefundData': razorpayRefundData?.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentOrderDetailHydrated',
      if (paymentTransaction != null)
        'paymentTransaction': paymentTransaction?.toJsonForProtocol(),
      if (refundRecords != null)
        'refundRecords': refundRecords?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (razorpayLiveStatus != null)
        'razorpayLiveStatus': razorpayLiveStatus?.toJsonForProtocol(),
      if (razorpayRefundData != null)
        'razorpayRefundData': razorpayRefundData?.toJsonForProtocol(),
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentOrderDetailHydratedImpl extends PaymentOrderDetailHydrated {
  _PaymentOrderDetailHydratedImpl({
    _i2.PaymentTransaction? paymentTransaction,
    List<_i3.RefundRecord>? refundRecords,
    _i4.RazorpayPaymentStatus? razorpayLiveStatus,
    _i5.RazorpayRefundData? razorpayRefundData,
    String? error,
  }) : super._(
         paymentTransaction: paymentTransaction,
         refundRecords: refundRecords,
         razorpayLiveStatus: razorpayLiveStatus,
         razorpayRefundData: razorpayRefundData,
         error: error,
       );

  /// Returns a shallow copy of this [PaymentOrderDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentOrderDetailHydrated copyWith({
    Object? paymentTransaction = _Undefined,
    Object? refundRecords = _Undefined,
    Object? razorpayLiveStatus = _Undefined,
    Object? razorpayRefundData = _Undefined,
    Object? error = _Undefined,
  }) {
    return PaymentOrderDetailHydrated(
      paymentTransaction: paymentTransaction is _i2.PaymentTransaction?
          ? paymentTransaction
          : this.paymentTransaction?.copyWith(),
      refundRecords: refundRecords is List<_i3.RefundRecord>?
          ? refundRecords
          : this.refundRecords?.map((e0) => e0.copyWith()).toList(),
      razorpayLiveStatus: razorpayLiveStatus is _i4.RazorpayPaymentStatus?
          ? razorpayLiveStatus
          : this.razorpayLiveStatus?.copyWith(),
      razorpayRefundData: razorpayRefundData is _i5.RazorpayRefundData?
          ? razorpayRefundData
          : this.razorpayRefundData?.copyWith(),
      error: error is String? ? error : this.error,
    );
  }
}
