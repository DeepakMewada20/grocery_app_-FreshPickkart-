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
    required this.orderNumber,
    required this.finalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    this.paymentLinkUrl,
    this.paymentLinkExpiresAt,
    this.linkStatus,
    required this.expiresInSeconds,
  });

  factory PaymentSessionData({
    required String orderNumber,
    required double finalAmount,
    required String paymentStatus,
    required String orderStatus,
    String? paymentLinkUrl,
    DateTime? paymentLinkExpiresAt,
    String? linkStatus,
    required int expiresInSeconds,
  }) = _PaymentSessionDataImpl;

  factory PaymentSessionData.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentSessionData(
      orderNumber: jsonSerialization['orderNumber'] as String,
      finalAmount: (jsonSerialization['finalAmount'] as num).toDouble(),
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      orderStatus: jsonSerialization['orderStatus'] as String,
      paymentLinkUrl: jsonSerialization['paymentLinkUrl'] as String?,
      paymentLinkExpiresAt: jsonSerialization['paymentLinkExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['paymentLinkExpiresAt'],
            ),
      linkStatus: jsonSerialization['linkStatus'] as String?,
      expiresInSeconds: jsonSerialization['expiresInSeconds'] as int,
    );
  }

  String orderNumber;

  double finalAmount;

  String paymentStatus;

  String orderStatus;

  String? paymentLinkUrl;

  DateTime? paymentLinkExpiresAt;

  String? linkStatus;

  int expiresInSeconds;

  /// Returns a shallow copy of this [PaymentSessionData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentSessionData copyWith({
    String? orderNumber,
    double? finalAmount,
    String? paymentStatus,
    String? orderStatus,
    String? paymentLinkUrl,
    DateTime? paymentLinkExpiresAt,
    String? linkStatus,
    int? expiresInSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentSessionData',
      'orderNumber': orderNumber,
      'finalAmount': finalAmount,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      if (paymentLinkUrl != null) 'paymentLinkUrl': paymentLinkUrl,
      if (paymentLinkExpiresAt != null)
        'paymentLinkExpiresAt': paymentLinkExpiresAt?.toJson(),
      if (linkStatus != null) 'linkStatus': linkStatus,
      'expiresInSeconds': expiresInSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentSessionData',
      'orderNumber': orderNumber,
      'finalAmount': finalAmount,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      if (paymentLinkUrl != null) 'paymentLinkUrl': paymentLinkUrl,
      if (paymentLinkExpiresAt != null)
        'paymentLinkExpiresAt': paymentLinkExpiresAt?.toJson(),
      if (linkStatus != null) 'linkStatus': linkStatus,
      'expiresInSeconds': expiresInSeconds,
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
    required String orderNumber,
    required double finalAmount,
    required String paymentStatus,
    required String orderStatus,
    String? paymentLinkUrl,
    DateTime? paymentLinkExpiresAt,
    String? linkStatus,
    required int expiresInSeconds,
  }) : super._(
         orderNumber: orderNumber,
         finalAmount: finalAmount,
         paymentStatus: paymentStatus,
         orderStatus: orderStatus,
         paymentLinkUrl: paymentLinkUrl,
         paymentLinkExpiresAt: paymentLinkExpiresAt,
         linkStatus: linkStatus,
         expiresInSeconds: expiresInSeconds,
       );

  /// Returns a shallow copy of this [PaymentSessionData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentSessionData copyWith({
    String? orderNumber,
    double? finalAmount,
    String? paymentStatus,
    String? orderStatus,
    Object? paymentLinkUrl = _Undefined,
    Object? paymentLinkExpiresAt = _Undefined,
    Object? linkStatus = _Undefined,
    int? expiresInSeconds,
  }) {
    return PaymentSessionData(
      orderNumber: orderNumber ?? this.orderNumber,
      finalAmount: finalAmount ?? this.finalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentLinkUrl: paymentLinkUrl is String?
          ? paymentLinkUrl
          : this.paymentLinkUrl,
      paymentLinkExpiresAt: paymentLinkExpiresAt is DateTime?
          ? paymentLinkExpiresAt
          : this.paymentLinkExpiresAt,
      linkStatus: linkStatus is String? ? linkStatus : this.linkStatus,
      expiresInSeconds: expiresInSeconds ?? this.expiresInSeconds,
    );
  }
}
