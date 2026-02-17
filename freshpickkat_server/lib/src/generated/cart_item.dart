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

abstract class CartItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CartItem._({
    required this.productId,
    required this.quantity,
  });

  factory CartItem({
    required String productId,
    required int quantity,
  }) = _CartItemImpl;

  factory CartItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartItem(
      productId: jsonSerialization['productId'] as String,
      quantity: jsonSerialization['quantity'] as int,
    );
  }

  String productId;

  int quantity;

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartItem copyWith({
    String? productId,
    int? quantity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartItem',
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CartItem',
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CartItemImpl extends CartItem {
  _CartItemImpl({
    required String productId,
    required int quantity,
  }) : super._(
         productId: productId,
         quantity: quantity,
       );

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartItem copyWith({
    String? productId,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }
}
