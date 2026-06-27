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

abstract class CartItem implements _i1.SerializableModel {
  CartItem._({
    required this.productId,
    this.variantId,
    required this.quantity,
    this.bogoFreeProductId,
    this.comboId,
    this.comboName,
    this.comboDiscountType,
    this.comboDiscountValue,
    this.comboItemQuantity,
    this.shopMoreGetMoreOfferId,
  });

  factory CartItem({
    required String productId,
    String? variantId,
    required int quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? shopMoreGetMoreOfferId,
  }) = _CartItemImpl;

  factory CartItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartItem(
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      bogoFreeProductId: jsonSerialization['bogoFreeProductId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      comboName: jsonSerialization['comboName'] as String?,
      comboDiscountType: jsonSerialization['comboDiscountType'] as String?,
      comboDiscountValue: (jsonSerialization['comboDiscountValue'] as num?)
          ?.toDouble(),
      comboItemQuantity: jsonSerialization['comboItemQuantity'] as int?,
      shopMoreGetMoreOfferId:
          jsonSerialization['shopMoreGetMoreOfferId'] as String?,
    );
  }

  String productId;

  String? variantId;

  int quantity;

  String? bogoFreeProductId;

  String? comboId;

  String? comboName;

  String? comboDiscountType;

  double? comboDiscountValue;

  int? comboItemQuantity;

  String? shopMoreGetMoreOfferId;

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartItem copyWith({
    String? productId,
    String? variantId,
    int? quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? shopMoreGetMoreOfferId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartItem',
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'quantity': quantity,
      if (bogoFreeProductId != null) 'bogoFreeProductId': bogoFreeProductId,
      if (comboId != null) 'comboId': comboId,
      if (comboName != null) 'comboName': comboName,
      if (comboDiscountType != null) 'comboDiscountType': comboDiscountType,
      if (comboDiscountValue != null) 'comboDiscountValue': comboDiscountValue,
      if (comboItemQuantity != null) 'comboItemQuantity': comboItemQuantity,
      if (shopMoreGetMoreOfferId != null)
        'shopMoreGetMoreOfferId': shopMoreGetMoreOfferId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartItemImpl extends CartItem {
  _CartItemImpl({
    required String productId,
    String? variantId,
    required int quantity,
    String? bogoFreeProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? shopMoreGetMoreOfferId,
  }) : super._(
         productId: productId,
         variantId: variantId,
         quantity: quantity,
         bogoFreeProductId: bogoFreeProductId,
         comboId: comboId,
         comboName: comboName,
         comboDiscountType: comboDiscountType,
         comboDiscountValue: comboDiscountValue,
         comboItemQuantity: comboItemQuantity,
         shopMoreGetMoreOfferId: shopMoreGetMoreOfferId,
       );

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartItem copyWith({
    String? productId,
    Object? variantId = _Undefined,
    int? quantity,
    Object? bogoFreeProductId = _Undefined,
    Object? comboId = _Undefined,
    Object? comboName = _Undefined,
    Object? comboDiscountType = _Undefined,
    Object? comboDiscountValue = _Undefined,
    Object? comboItemQuantity = _Undefined,
    Object? shopMoreGetMoreOfferId = _Undefined,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      quantity: quantity ?? this.quantity,
      bogoFreeProductId: bogoFreeProductId is String?
          ? bogoFreeProductId
          : this.bogoFreeProductId,
      comboId: comboId is String? ? comboId : this.comboId,
      comboName: comboName is String? ? comboName : this.comboName,
      comboDiscountType: comboDiscountType is String?
          ? comboDiscountType
          : this.comboDiscountType,
      comboDiscountValue: comboDiscountValue is double?
          ? comboDiscountValue
          : this.comboDiscountValue,
      comboItemQuantity: comboItemQuantity is int?
          ? comboItemQuantity
          : this.comboItemQuantity,
      shopMoreGetMoreOfferId: shopMoreGetMoreOfferId is String?
          ? shopMoreGetMoreOfferId
          : this.shopMoreGetMoreOfferId,
    );
  }
}
