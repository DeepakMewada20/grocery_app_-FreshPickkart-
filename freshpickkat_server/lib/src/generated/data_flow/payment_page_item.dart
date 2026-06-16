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

abstract class PaymentPageItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentPageItem._({
    required this.productName,
    this.variantLabel,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.productImage,
  });

  factory PaymentPageItem({
    required String productName,
    String? variantLabel,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? productImage,
  }) = _PaymentPageItemImpl;

  factory PaymentPageItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentPageItem(
      productName: jsonSerialization['productName'] as String,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      productImage: jsonSerialization['productImage'] as String?,
    );
  }

  String productName;

  String? variantLabel;

  int quantity;

  double unitPrice;

  double totalPrice;

  String? productImage;

  @_i1.useResult
  PaymentPageItem copyWith({
    String? productName,
    Object? variantLabel = _Undefined,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    Object? productImage = _Undefined,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentPageItem',
      'productName': productName,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      if (productImage != null) 'productImage': productImage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentPageItem',
      'productName': productName,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      if (productImage != null) 'productImage': productImage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentPageItemImpl extends PaymentPageItem {
  _PaymentPageItemImpl({
    required String productName,
    String? variantLabel,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? productImage,
  }) : super._(
         productName: productName,
         variantLabel: variantLabel,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
         productImage: productImage,
       );

  @_i1.useResult
  @override
  PaymentPageItem copyWith({
    String? productName,
    Object? variantLabel = _Undefined,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    Object? productImage = _Undefined,
  }) {
    return PaymentPageItem(
      productName: productName ?? this.productName,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      productImage: productImage is String? ? productImage : this.productImage,
    );
  }
}
