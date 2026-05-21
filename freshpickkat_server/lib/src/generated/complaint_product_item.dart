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

abstract class ComplaintProductItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ComplaintProductItem._({
    required this.orderItemId,
    required this.productId,
    this.variantId,
    required this.productName,
    required this.productImage,
    this.variantLabel,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ComplaintProductItem({
    required String orderItemId,
    required String productId,
    String? variantId,
    required String productName,
    required String productImage,
    String? variantLabel,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
  }) = _ComplaintProductItemImpl;

  factory ComplaintProductItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ComplaintProductItem(
      orderItemId: jsonSerialization['orderItemId'] as String,
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      productName: jsonSerialization['productName'] as String,
      productImage: jsonSerialization['productImage'] as String,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
    );
  }

  String orderItemId;

  String productId;

  String? variantId;

  String productName;

  String productImage;

  String? variantLabel;

  int quantity;

  double unitPrice;

  double totalPrice;

  /// Returns a shallow copy of this [ComplaintProductItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplaintProductItem copyWith({
    String? orderItemId,
    String? productId,
    String? variantId,
    String? productName,
    String? productImage,
    String? variantLabel,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplaintProductItem',
      'orderItemId': orderItemId,
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'productName': productName,
      'productImage': productImage,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ComplaintProductItem',
      'orderItemId': orderItemId,
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'productName': productName,
      'productImage': productImage,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintProductItemImpl extends ComplaintProductItem {
  _ComplaintProductItemImpl({
    required String orderItemId,
    required String productId,
    String? variantId,
    required String productName,
    required String productImage,
    String? variantLabel,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
  }) : super._(
         orderItemId: orderItemId,
         productId: productId,
         variantId: variantId,
         productName: productName,
         productImage: productImage,
         variantLabel: variantLabel,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
       );

  /// Returns a shallow copy of this [ComplaintProductItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplaintProductItem copyWith({
    String? orderItemId,
    String? productId,
    Object? variantId = _Undefined,
    String? productName,
    String? productImage,
    Object? variantLabel = _Undefined,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return ComplaintProductItem(
      orderItemId: orderItemId ?? this.orderItemId,
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
