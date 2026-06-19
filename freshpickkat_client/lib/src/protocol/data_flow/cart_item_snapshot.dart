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

abstract class CartItemSnapshot implements _i1.SerializableModel {
  CartItemSnapshot._({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  factory CartItemSnapshot({
    required String productId,
    required String variantId,
    required int quantity,
  }) = _CartItemSnapshotImpl;

  factory CartItemSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartItemSnapshot(
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String,
      quantity: jsonSerialization['quantity'] as int,
    );
  }

  String productId;

  String variantId;

  int quantity;

  /// Returns a shallow copy of this [CartItemSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartItemSnapshot copyWith({
    String? productId,
    String? variantId,
    int? quantity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartItemSnapshot',
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CartItemSnapshotImpl extends CartItemSnapshot {
  _CartItemSnapshotImpl({
    required String productId,
    required String variantId,
    required int quantity,
  }) : super._(
         productId: productId,
         variantId: variantId,
         quantity: quantity,
       );

  /// Returns a shallow copy of this [CartItemSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartItemSnapshot copyWith({
    String? productId,
    String? variantId,
    int? quantity,
  }) {
    return CartItemSnapshot(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }
}
