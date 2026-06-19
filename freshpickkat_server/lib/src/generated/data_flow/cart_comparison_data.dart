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
import '../data_flow/cart_item_snapshot.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class CartComparisonData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CartComparisonData._({
    required this.items,
    this.couponId,
    required this.discountAmount,
    required this.deliveryCharge,
    required this.totalAmount,
  });

  factory CartComparisonData({
    required List<_i2.CartItemSnapshot> items,
    String? couponId,
    required double discountAmount,
    required double deliveryCharge,
    required double totalAmount,
  }) = _CartComparisonDataImpl;

  factory CartComparisonData.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartComparisonData(
      items: _i3.Protocol().deserialize<List<_i2.CartItemSnapshot>>(
        jsonSerialization['items'],
      ),
      couponId: jsonSerialization['couponId'] as String?,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
      deliveryCharge: (jsonSerialization['deliveryCharge'] as num).toDouble(),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
    );
  }

  List<_i2.CartItemSnapshot> items;

  String? couponId;

  double discountAmount;

  double deliveryCharge;

  double totalAmount;

  /// Returns a shallow copy of this [CartComparisonData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartComparisonData copyWith({
    List<_i2.CartItemSnapshot>? items,
    String? couponId,
    double? discountAmount,
    double? deliveryCharge,
    double? totalAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartComparisonData',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (couponId != null) 'couponId': couponId,
      'discountAmount': discountAmount,
      'deliveryCharge': deliveryCharge,
      'totalAmount': totalAmount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CartComparisonData',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (couponId != null) 'couponId': couponId,
      'discountAmount': discountAmount,
      'deliveryCharge': deliveryCharge,
      'totalAmount': totalAmount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartComparisonDataImpl extends CartComparisonData {
  _CartComparisonDataImpl({
    required List<_i2.CartItemSnapshot> items,
    String? couponId,
    required double discountAmount,
    required double deliveryCharge,
    required double totalAmount,
  }) : super._(
         items: items,
         couponId: couponId,
         discountAmount: discountAmount,
         deliveryCharge: deliveryCharge,
         totalAmount: totalAmount,
       );

  /// Returns a shallow copy of this [CartComparisonData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartComparisonData copyWith({
    List<_i2.CartItemSnapshot>? items,
    Object? couponId = _Undefined,
    double? discountAmount,
    double? deliveryCharge,
    double? totalAmount,
  }) {
    return CartComparisonData(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      couponId: couponId is String? ? couponId : this.couponId,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
