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

abstract class CartItemInput
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CartItemInput._({
    required this.productId,
    this.variantId,
    required this.quantity,
    this.comboId,
    this.bogoFreeProductId,
  });

  factory CartItemInput({
    required String productId,
    String? variantId,
    required int quantity,
    String? comboId,
    String? bogoFreeProductId,
  }) = _CartItemInputImpl;

  factory CartItemInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartItemInput(
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      comboId: jsonSerialization['comboId'] as String?,
      bogoFreeProductId: jsonSerialization['bogoFreeProductId'] as String?,
    );
  }

  String productId;

  String? variantId;

  int quantity;

  String? comboId;

  String? bogoFreeProductId;

  /// Returns a shallow copy of this [CartItemInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartItemInput copyWith({
    String? productId,
    String? variantId,
    int? quantity,
    String? comboId,
    String? bogoFreeProductId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartItemInput',
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'quantity': quantity,
      if (comboId != null) 'comboId': comboId,
      if (bogoFreeProductId != null) 'bogoFreeProductId': bogoFreeProductId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CartItemInput',
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'quantity': quantity,
      if (comboId != null) 'comboId': comboId,
      if (bogoFreeProductId != null) 'bogoFreeProductId': bogoFreeProductId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartItemInputImpl extends CartItemInput {
  _CartItemInputImpl({
    required String productId,
    String? variantId,
    required int quantity,
    String? comboId,
    String? bogoFreeProductId,
  }) : super._(
         productId: productId,
         variantId: variantId,
         quantity: quantity,
         comboId: comboId,
         bogoFreeProductId: bogoFreeProductId,
       );

  /// Returns a shallow copy of this [CartItemInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartItemInput copyWith({
    String? productId,
    Object? variantId = _Undefined,
    int? quantity,
    Object? comboId = _Undefined,
    Object? bogoFreeProductId = _Undefined,
  }) {
    return CartItemInput(
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      quantity: quantity ?? this.quantity,
      comboId: comboId is String? ? comboId : this.comboId,
      bogoFreeProductId: bogoFreeProductId is String?
          ? bogoFreeProductId
          : this.bogoFreeProductId,
    );
  }
}
