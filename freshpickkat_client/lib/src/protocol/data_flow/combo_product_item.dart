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

abstract class ComboProductItem implements _i1.SerializableModel {
  ComboProductItem._({
    required this.productId,
    this.productName,
    required this.quantity,
    this.variantId,
  });

  factory ComboProductItem({
    required String productId,
    String? productName,
    required int quantity,
    String? variantId,
  }) = _ComboProductItemImpl;

  factory ComboProductItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComboProductItem(
      productId: jsonSerialization['productId'] as String,
      productName: jsonSerialization['productName'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      variantId: jsonSerialization['variantId'] as String?,
    );
  }

  String productId;

  String? productName;

  int quantity;

  String? variantId;

  /// Returns a shallow copy of this [ComboProductItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComboProductItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    String? variantId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComboProductItem',
      'productId': productId,
      if (productName != null) 'productName': productName,
      'quantity': quantity,
      if (variantId != null) 'variantId': variantId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComboProductItemImpl extends ComboProductItem {
  _ComboProductItemImpl({
    required String productId,
    String? productName,
    required int quantity,
    String? variantId,
  }) : super._(
         productId: productId,
         productName: productName,
         quantity: quantity,
         variantId: variantId,
       );

  /// Returns a shallow copy of this [ComboProductItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComboProductItem copyWith({
    String? productId,
    Object? productName = _Undefined,
    int? quantity,
    Object? variantId = _Undefined,
  }) {
    return ComboProductItem(
      productId: productId ?? this.productId,
      productName: productName is String? ? productName : this.productName,
      quantity: quantity ?? this.quantity,
      variantId: variantId is String? ? variantId : this.variantId,
    );
  }
}
