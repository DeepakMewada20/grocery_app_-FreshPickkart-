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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

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
    this.bogoFreeProductIds,
    this.comboOfferIds,
    bool? isFreeDelivery,
  }) : isFreeDelivery = isFreeDelivery ?? false;

  factory ProductVariant({
    required String variantId,
    required double quantityValue,
    required String quantityUnit,
    String? quantityDescription,
    required double price,
    required double realPrice,
    required bool isAvailable,
    int? sortOrder,
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? isFreeDelivery,
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
      bogoFreeProductIds: jsonSerialization['bogoFreeProductIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['bogoFreeProductIds'],
            ),
      comboOfferIds: jsonSerialization['comboOfferIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['comboOfferIds'],
            ),
      isFreeDelivery: jsonSerialization['isFreeDelivery'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeDelivery']),
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

  List<String>? bogoFreeProductIds;

  List<String>? comboOfferIds;

  bool isFreeDelivery;

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
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? isFreeDelivery,
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
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
      if (comboOfferIds != null) 'comboOfferIds': comboOfferIds?.toJson(),
      'isFreeDelivery': isFreeDelivery,
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
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
      if (comboOfferIds != null) 'comboOfferIds': comboOfferIds?.toJson(),
      'isFreeDelivery': isFreeDelivery,
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
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? isFreeDelivery,
  }) : super._(
         variantId: variantId,
         quantityValue: quantityValue,
         quantityUnit: quantityUnit,
         quantityDescription: quantityDescription,
         price: price,
         realPrice: realPrice,
         isAvailable: isAvailable,
         sortOrder: sortOrder,
         bogoFreeProductIds: bogoFreeProductIds,
         comboOfferIds: comboOfferIds,
         isFreeDelivery: isFreeDelivery,
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
    Object? bogoFreeProductIds = _Undefined,
    Object? comboOfferIds = _Undefined,
    bool? isFreeDelivery,
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
      bogoFreeProductIds: bogoFreeProductIds is List<String>?
          ? bogoFreeProductIds
          : this.bogoFreeProductIds?.map((e0) => e0).toList(),
      comboOfferIds: comboOfferIds is List<String>?
          ? comboOfferIds
          : this.comboOfferIds?.map((e0) => e0).toList(),
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
    );
  }
}
