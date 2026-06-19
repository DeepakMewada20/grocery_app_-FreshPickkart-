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
import '../data_flow/cart_comparison_data.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class PendingOrderInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PendingOrderInfo._({
    required this.orderNumber,
    required this.finalAmount,
    required this.orderedAt,
    required this.expiresInMinutes,
    required this.paymentStatus,
    required this.orderStatus,
    this.linkStatus,
    this.cartData,
  });

  factory PendingOrderInfo({
    required String orderNumber,
    required double finalAmount,
    required DateTime orderedAt,
    required int expiresInMinutes,
    required String paymentStatus,
    required String orderStatus,
    String? linkStatus,
    _i2.CartComparisonData? cartData,
  }) = _PendingOrderInfoImpl;

  factory PendingOrderInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PendingOrderInfo(
      orderNumber: jsonSerialization['orderNumber'] as String,
      finalAmount: (jsonSerialization['finalAmount'] as num).toDouble(),
      orderedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['orderedAt'],
      ),
      expiresInMinutes: jsonSerialization['expiresInMinutes'] as int,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      orderStatus: jsonSerialization['orderStatus'] as String,
      linkStatus: jsonSerialization['linkStatus'] as String?,
      cartData: jsonSerialization['cartData'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.CartComparisonData>(
              jsonSerialization['cartData'],
            ),
    );
  }

  String orderNumber;

  double finalAmount;

  DateTime orderedAt;

  int expiresInMinutes;

  String paymentStatus;

  String orderStatus;

  String? linkStatus;

  _i2.CartComparisonData? cartData;

  /// Returns a shallow copy of this [PendingOrderInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PendingOrderInfo copyWith({
    String? orderNumber,
    double? finalAmount,
    DateTime? orderedAt,
    int? expiresInMinutes,
    String? paymentStatus,
    String? orderStatus,
    String? linkStatus,
    _i2.CartComparisonData? cartData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingOrderInfo',
      'orderNumber': orderNumber,
      'finalAmount': finalAmount,
      'orderedAt': orderedAt.toJson(),
      'expiresInMinutes': expiresInMinutes,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      if (linkStatus != null) 'linkStatus': linkStatus,
      if (cartData != null) 'cartData': cartData?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PendingOrderInfo',
      'orderNumber': orderNumber,
      'finalAmount': finalAmount,
      'orderedAt': orderedAt.toJson(),
      'expiresInMinutes': expiresInMinutes,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      if (linkStatus != null) 'linkStatus': linkStatus,
      if (cartData != null) 'cartData': cartData?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PendingOrderInfoImpl extends PendingOrderInfo {
  _PendingOrderInfoImpl({
    required String orderNumber,
    required double finalAmount,
    required DateTime orderedAt,
    required int expiresInMinutes,
    required String paymentStatus,
    required String orderStatus,
    String? linkStatus,
    _i2.CartComparisonData? cartData,
  }) : super._(
         orderNumber: orderNumber,
         finalAmount: finalAmount,
         orderedAt: orderedAt,
         expiresInMinutes: expiresInMinutes,
         paymentStatus: paymentStatus,
         orderStatus: orderStatus,
         linkStatus: linkStatus,
         cartData: cartData,
       );

  /// Returns a shallow copy of this [PendingOrderInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PendingOrderInfo copyWith({
    String? orderNumber,
    double? finalAmount,
    DateTime? orderedAt,
    int? expiresInMinutes,
    String? paymentStatus,
    String? orderStatus,
    Object? linkStatus = _Undefined,
    Object? cartData = _Undefined,
  }) {
    return PendingOrderInfo(
      orderNumber: orderNumber ?? this.orderNumber,
      finalAmount: finalAmount ?? this.finalAmount,
      orderedAt: orderedAt ?? this.orderedAt,
      expiresInMinutes: expiresInMinutes ?? this.expiresInMinutes,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      linkStatus: linkStatus is String? ? linkStatus : this.linkStatus,
      cartData: cartData is _i2.CartComparisonData?
          ? cartData
          : this.cartData?.copyWith(),
    );
  }
}
