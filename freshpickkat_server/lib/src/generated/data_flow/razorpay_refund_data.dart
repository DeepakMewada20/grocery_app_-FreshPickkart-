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

abstract class RazorpayRefundData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RazorpayRefundData._({
    required this.id,
    required this.paymentId,
    required this.amount,
    required this.status,
    this.speedProcessed,
    this.speedRequested,
    this.receipt,
    this.acquirerData,
    this.notes,
    this.errorCode,
    this.errorDescription,
    this.createdAt,
  });

  factory RazorpayRefundData({
    required String id,
    required String paymentId,
    required int amount,
    required String status,
    String? speedProcessed,
    String? speedRequested,
    String? receipt,
    String? acquirerData,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
  }) = _RazorpayRefundDataImpl;

  factory RazorpayRefundData.fromJson(Map<String, dynamic> jsonSerialization) {
    return RazorpayRefundData(
      id: jsonSerialization['id'] as String,
      paymentId: jsonSerialization['paymentId'] as String,
      amount: jsonSerialization['amount'] as int,
      status: jsonSerialization['status'] as String,
      speedProcessed: jsonSerialization['speedProcessed'] as String?,
      speedRequested: jsonSerialization['speedRequested'] as String?,
      receipt: jsonSerialization['receipt'] as String?,
      acquirerData: jsonSerialization['acquirerData'] as String?,
      notes: jsonSerialization['notes'] as String?,
      errorCode: jsonSerialization['errorCode'] as String?,
      errorDescription: jsonSerialization['errorDescription'] as String?,
      createdAt: jsonSerialization['createdAt'] as int?,
    );
  }

  String id;

  String paymentId;

  int amount;

  String status;

  String? speedProcessed;

  String? speedRequested;

  String? receipt;

  String? acquirerData;

  String? notes;

  String? errorCode;

  String? errorDescription;

  int? createdAt;

  /// Returns a shallow copy of this [RazorpayRefundData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RazorpayRefundData copyWith({
    String? id,
    String? paymentId,
    int? amount,
    String? status,
    String? speedProcessed,
    String? speedRequested,
    String? receipt,
    String? acquirerData,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RazorpayRefundData',
      'id': id,
      'paymentId': paymentId,
      'amount': amount,
      'status': status,
      if (speedProcessed != null) 'speedProcessed': speedProcessed,
      if (speedRequested != null) 'speedRequested': speedRequested,
      if (receipt != null) 'receipt': receipt,
      if (acquirerData != null) 'acquirerData': acquirerData,
      if (notes != null) 'notes': notes,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorDescription != null) 'errorDescription': errorDescription,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RazorpayRefundData',
      'id': id,
      'paymentId': paymentId,
      'amount': amount,
      'status': status,
      if (speedProcessed != null) 'speedProcessed': speedProcessed,
      if (speedRequested != null) 'speedRequested': speedRequested,
      if (receipt != null) 'receipt': receipt,
      if (acquirerData != null) 'acquirerData': acquirerData,
      if (notes != null) 'notes': notes,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorDescription != null) 'errorDescription': errorDescription,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RazorpayRefundDataImpl extends RazorpayRefundData {
  _RazorpayRefundDataImpl({
    required String id,
    required String paymentId,
    required int amount,
    required String status,
    String? speedProcessed,
    String? speedRequested,
    String? receipt,
    String? acquirerData,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
  }) : super._(
         id: id,
         paymentId: paymentId,
         amount: amount,
         status: status,
         speedProcessed: speedProcessed,
         speedRequested: speedRequested,
         receipt: receipt,
         acquirerData: acquirerData,
         notes: notes,
         errorCode: errorCode,
         errorDescription: errorDescription,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RazorpayRefundData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RazorpayRefundData copyWith({
    String? id,
    String? paymentId,
    int? amount,
    String? status,
    Object? speedProcessed = _Undefined,
    Object? speedRequested = _Undefined,
    Object? receipt = _Undefined,
    Object? acquirerData = _Undefined,
    Object? notes = _Undefined,
    Object? errorCode = _Undefined,
    Object? errorDescription = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return RazorpayRefundData(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      speedProcessed: speedProcessed is String?
          ? speedProcessed
          : this.speedProcessed,
      speedRequested: speedRequested is String?
          ? speedRequested
          : this.speedRequested,
      receipt: receipt is String? ? receipt : this.receipt,
      acquirerData: acquirerData is String? ? acquirerData : this.acquirerData,
      notes: notes is String? ? notes : this.notes,
      errorCode: errorCode is String? ? errorCode : this.errorCode,
      errorDescription: errorDescription is String?
          ? errorDescription
          : this.errorDescription,
      createdAt: createdAt is int? ? createdAt : this.createdAt,
    );
  }
}
