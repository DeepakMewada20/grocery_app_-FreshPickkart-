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

abstract class ProductVariant
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProductVariant._({
    required this.variantId,
    required this.quantityValue,
    required this.quantityUnit,
    this.quantityDescription,
    required this.price,
    required this.realPrice,
    required this.isAvailable,
    this.sortOrder,
  });

  factory ProductVariant({
    required String variantId,
    required double quantityValue,
    required String quantityUnit,
    String? quantityDescription,
    required double price,
    required double realPrice,
    required bool isAvailable,
    int? sortOrder,
  }) = _ProductVariantImpl;

  factory ProductVariant.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductVariant(
      variantId: jsonSerialization['variantId'] as String,
      quantityValue: (jsonSerialization['quantityValue'] as num).toDouble(),
      quantityUnit: jsonSerialization['quantityUnit'] as String,
      quantityDescription: jsonSerialization['quantityDescription'] as String?,
      price: (jsonSerialization['price'] as num).toDouble(),
      realPrice: (jsonSerialization['realPrice'] as num).toDouble(),
      isAvailable: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAvailable'],
      ),
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  String variantId;

  double quantityValue;

  String quantityUnit;

  String? quantityDescription;

  double price;

  double realPrice;

  bool isAvailable;

  int? sortOrder;

  /// Returns a shallow copy of this [ProductVariant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductVariant copyWith({
    String? variantId,
    double? quantityValue,
    String? quantityUnit,
    String? quantityDescription,
    double? price,
    double? realPrice,
    bool? isAvailable,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductVariant',
      'variantId': variantId,
      'quantityValue': quantityValue,
      'quantityUnit': quantityUnit,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      'price': price,
      'realPrice': realPrice,
      'isAvailable': isAvailable,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductVariant',
      'variantId': variantId,
      'quantityValue': quantityValue,
      'quantityUnit': quantityUnit,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      'price': price,
      'realPrice': realPrice,
      'isAvailable': isAvailable,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductVariantImpl extends ProductVariant {
  _ProductVariantImpl({
    required String variantId,
    required double quantityValue,
    required String quantityUnit,
    String? quantityDescription,
    required double price,
    required double realPrice,
    required bool isAvailable,
    int? sortOrder,
  }) : super._(
         variantId: variantId,
         quantityValue: quantityValue,
         quantityUnit: quantityUnit,
         quantityDescription: quantityDescription,
         price: price,
         realPrice: realPrice,
         isAvailable: isAvailable,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [ProductVariant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductVariant copyWith({
    String? variantId,
    double? quantityValue,
    String? quantityUnit,
    Object? quantityDescription = _Undefined,
    double? price,
    double? realPrice,
    bool? isAvailable,
    Object? sortOrder = _Undefined,
  }) {
    return ProductVariant(
      variantId: variantId ?? this.variantId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      quantityDescription: quantityDescription is String?
          ? quantityDescription
          : this.quantityDescription,
      price: price ?? this.price,
      realPrice: realPrice ?? this.realPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      sortOrder: sortOrder is int? ? sortOrder : this.sortOrder,
    );
  }
}
