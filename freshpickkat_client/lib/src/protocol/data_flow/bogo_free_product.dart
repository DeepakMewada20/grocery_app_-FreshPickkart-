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

abstract class BogoFreeProduct implements _i1.SerializableModel {
  BogoFreeProduct._({
    required this.productId,
    this.variantId,
    this.freeQuantity,
  });

  factory BogoFreeProduct({
    required String productId,
    String? variantId,
    int? freeQuantity,
  }) = _BogoFreeProductImpl;

  factory BogoFreeProduct.fromJson(Map<String, dynamic> jsonSerialization) {
    return BogoFreeProduct(
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      freeQuantity: jsonSerialization['freeQuantity'] as int?,
    );
  }

  String productId;

  String? variantId;

  int? freeQuantity;

  /// Returns a shallow copy of this [BogoFreeProduct]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BogoFreeProduct copyWith({
    String? productId,
    String? variantId,
    int? freeQuantity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BogoFreeProduct',
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (freeQuantity != null) 'freeQuantity': freeQuantity,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BogoFreeProductImpl extends BogoFreeProduct {
  _BogoFreeProductImpl({
    required String productId,
    String? variantId,
    int? freeQuantity,
  }) : super._(
         productId: productId,
         variantId: variantId,
         freeQuantity: freeQuantity,
       );

  /// Returns a shallow copy of this [BogoFreeProduct]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BogoFreeProduct copyWith({
    String? productId,
    Object? variantId = _Undefined,
    Object? freeQuantity = _Undefined,
  }) {
    return BogoFreeProduct(
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      freeQuantity: freeQuantity is int? ? freeQuantity : this.freeQuantity,
    );
  }
}
