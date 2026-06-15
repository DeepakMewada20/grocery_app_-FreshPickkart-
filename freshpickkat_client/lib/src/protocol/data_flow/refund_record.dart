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

abstract class RefundRecord implements _i1.SerializableModel {
  RefundRecord._({
    required this.refundId,
    required this.orderId,
    required this.paymentId,
    required this.userId,
    required this.amount,
    required this.status,
    this.gatewayRefundId,
    required this.source,
    required this.reason,
    this.complaintId,
    this.failureReason,
    required this.createdAt,
    this.updatedAt,
  });

  factory RefundRecord({
    required String refundId,
    required String orderId,
    required String paymentId,
    required String userId,
    required double amount,
    required String status,
    String? gatewayRefundId,
    required String source,
    required String reason,
    String? complaintId,
    String? failureReason,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _RefundRecordImpl;

  factory RefundRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefundRecord(
      refundId: jsonSerialization['refundId'] as String,
      orderId: jsonSerialization['orderId'] as String,
      paymentId: jsonSerialization['paymentId'] as String,
      userId: jsonSerialization['userId'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      gatewayRefundId: jsonSerialization['gatewayRefundId'] as String?,
      source: jsonSerialization['source'] as String,
      reason: jsonSerialization['reason'] as String,
      complaintId: jsonSerialization['complaintId'] as String?,
      failureReason: jsonSerialization['failureReason'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  String refundId;

  String orderId;

  String paymentId;

  String userId;

  double amount;

  String status;

  String? gatewayRefundId;

  String source;

  String reason;

  String? complaintId;

  String? failureReason;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [RefundRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefundRecord copyWith({
    String? refundId,
    String? orderId,
    String? paymentId,
    String? userId,
    double? amount,
    String? status,
    String? gatewayRefundId,
    String? source,
    String? reason,
    String? complaintId,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefundRecord',
      'refundId': refundId,
      'orderId': orderId,
      'paymentId': paymentId,
      'userId': userId,
      'amount': amount,
      'status': status,
      if (gatewayRefundId != null) 'gatewayRefundId': gatewayRefundId,
      'source': source,
      'reason': reason,
      if (complaintId != null) 'complaintId': complaintId,
      if (failureReason != null) 'failureReason': failureReason,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefundRecordImpl extends RefundRecord {
  _RefundRecordImpl({
    required String refundId,
    required String orderId,
    required String paymentId,
    required String userId,
    required double amount,
    required String status,
    String? gatewayRefundId,
    required String source,
    required String reason,
    String? complaintId,
    String? failureReason,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         refundId: refundId,
         orderId: orderId,
         paymentId: paymentId,
         userId: userId,
         amount: amount,
         status: status,
         gatewayRefundId: gatewayRefundId,
         source: source,
         reason: reason,
         complaintId: complaintId,
         failureReason: failureReason,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RefundRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefundRecord copyWith({
    String? refundId,
    String? orderId,
    String? paymentId,
    String? userId,
    double? amount,
    String? status,
    Object? gatewayRefundId = _Undefined,
    String? source,
    String? reason,
    Object? complaintId = _Undefined,
    Object? failureReason = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return RefundRecord(
      refundId: refundId ?? this.refundId,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      gatewayRefundId: gatewayRefundId is String?
          ? gatewayRefundId
          : this.gatewayRefundId,
      source: source ?? this.source,
      reason: reason ?? this.reason,
      complaintId: complaintId is String? ? complaintId : this.complaintId,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
