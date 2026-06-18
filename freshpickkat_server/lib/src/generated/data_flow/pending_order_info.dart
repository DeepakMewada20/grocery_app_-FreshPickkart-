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

abstract class PendingOrderInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PendingOrderInfo._({
    required this.orderNumber,
    required this.finalAmount,
    required this.orderedAt,
    required this.expiresInMinutes,
  });

  factory PendingOrderInfo({
    required String orderNumber,
    required double finalAmount,
    required DateTime orderedAt,
    required int expiresInMinutes,
  }) = _PendingOrderInfoImpl;

  factory PendingOrderInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PendingOrderInfo(
      orderNumber: jsonSerialization['orderNumber'] as String,
      finalAmount: (jsonSerialization['finalAmount'] as num).toDouble(),
      orderedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['orderedAt'],
      ),
      expiresInMinutes: jsonSerialization['expiresInMinutes'] as int,
    );
  }

  String orderNumber;

  double finalAmount;

  DateTime orderedAt;

  int expiresInMinutes;

  /// Returns a shallow copy of this [PendingOrderInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PendingOrderInfo copyWith({
    String? orderNumber,
    double? finalAmount,
    DateTime? orderedAt,
    int? expiresInMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingOrderInfo',
      'orderNumber': orderNumber,
      'finalAmount': finalAmount,
      'orderedAt': orderedAt.toJson(),
      'expiresInMinutes': expiresInMinutes,
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
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PendingOrderInfoImpl extends PendingOrderInfo {
  _PendingOrderInfoImpl({
    required String orderNumber,
    required double finalAmount,
    required DateTime orderedAt,
    required int expiresInMinutes,
  }) : super._(
         orderNumber: orderNumber,
         finalAmount: finalAmount,
         orderedAt: orderedAt,
         expiresInMinutes: expiresInMinutes,
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
  }) {
    return PendingOrderInfo(
      orderNumber: orderNumber ?? this.orderNumber,
      finalAmount: finalAmount ?? this.finalAmount,
      orderedAt: orderedAt ?? this.orderedAt,
      expiresInMinutes: expiresInMinutes ?? this.expiresInMinutes,
    );
  }
}
