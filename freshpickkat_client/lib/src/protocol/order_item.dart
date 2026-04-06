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

abstract class OrderItem implements _i1.SerializableModel {
  OrderItem._({
    required this.productId,
    this.variantId,
    this.variantLabel,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.isFreeItem,
    this.triggerProductId,
    this.comboId,
    this.comboName,
    this.comboDiscountType,
    this.comboDiscountValue,
    this.comboItemQuantity,
  });

  factory OrderItem({
    required String productId,
    String? variantId,
    String? variantLabel,
    required String productName,
    required String productImage,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
  }) = _OrderItemImpl;

  factory OrderItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItem(
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      productName: jsonSerialization['productName'] as String,
      productImage: jsonSerialization['productImage'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      isFreeItem: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFreeItem'],
      ),
      triggerProductId: jsonSerialization['triggerProductId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      comboName: jsonSerialization['comboName'] as String?,
      comboDiscountType: jsonSerialization['comboDiscountType'] as String?,
      comboDiscountValue: (jsonSerialization['comboDiscountValue'] as num?)
          ?.toDouble(),
      comboItemQuantity: jsonSerialization['comboItemQuantity'] as int?,
    );
  }

  String productId;

  String? variantId;

  String? variantLabel;

  String productName;

  String productImage;

  int quantity;

  double unitPrice;

  double totalPrice;

  bool isFreeItem;

  String? triggerProductId;

  String? comboId;

  String? comboName;

  String? comboDiscountType;

  double? comboDiscountValue;

  int? comboItemQuantity;

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderItem copyWith({
    String? productId,
    String? variantId,
    String? variantLabel,
    String? productName,
    String? productImage,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItem',
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
      if (comboId != null) 'comboId': comboId,
      if (comboName != null) 'comboName': comboName,
      if (comboDiscountType != null) 'comboDiscountType': comboDiscountType,
      if (comboDiscountValue != null) 'comboDiscountValue': comboDiscountValue,
      if (comboItemQuantity != null) 'comboItemQuantity': comboItemQuantity,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderItemImpl extends OrderItem {
  _OrderItemImpl({
    required String productId,
    String? variantId,
    String? variantLabel,
    required String productName,
    required String productImage,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
  }) : super._(
         productId: productId,
         variantId: variantId,
         variantLabel: variantLabel,
         productName: productName,
         productImage: productImage,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
         isFreeItem: isFreeItem,
         triggerProductId: triggerProductId,
         comboId: comboId,
         comboName: comboName,
         comboDiscountType: comboDiscountType,
         comboDiscountValue: comboDiscountValue,
         comboItemQuantity: comboItemQuantity,
       );

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderItem copyWith({
    String? productId,
    Object? variantId = _Undefined,
    Object? variantLabel = _Undefined,
    String? productName,
    String? productImage,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    Object? triggerProductId = _Undefined,
    Object? comboId = _Undefined,
    Object? comboName = _Undefined,
    Object? comboDiscountType = _Undefined,
    Object? comboDiscountValue = _Undefined,
    Object? comboItemQuantity = _Undefined,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isFreeItem: isFreeItem ?? this.isFreeItem,
      triggerProductId: triggerProductId is String?
          ? triggerProductId
          : this.triggerProductId,
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
    );
  }
}
