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

abstract class OrderItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  OrderItem._({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.isFreeItem,
    this.triggerProductId,
  });

  factory OrderItem({
    required String productId,
    required String productName,
    required String productImage,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    String? triggerProductId,
  }) = _OrderItemImpl;

  factory OrderItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItem(
      productId: jsonSerialization['productId'] as String,
      productName: jsonSerialization['productName'] as String,
      productImage: jsonSerialization['productImage'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      isFreeItem: jsonSerialization['isFreeItem'] as bool,
      triggerProductId: jsonSerialization['triggerProductId'] as String?,
    );
  }

  String productId;

  String productName;

  String productImage;

  int quantity;

  double unitPrice;

  double totalPrice;

  bool isFreeItem;

  String? triggerProductId;

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    String? triggerProductId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItem',
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderItem',
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
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
    required String productName,
    required String productImage,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    String? triggerProductId,
  }) : super._(
         productId: productId,
         productName: productName,
         productImage: productImage,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
         isFreeItem: isFreeItem,
         triggerProductId: triggerProductId,
       );

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    Object? triggerProductId = _Undefined,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isFreeItem: isFreeItem ?? this.isFreeItem,
      triggerProductId: triggerProductId is String?
          ? triggerProductId
          : this.triggerProductId,
    );
  }
}
