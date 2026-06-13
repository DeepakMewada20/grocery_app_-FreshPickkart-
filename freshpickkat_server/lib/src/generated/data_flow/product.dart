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
import '../data_flow/product_variant.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class Product
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Product._({
    this.productId,
    this.variantId,
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.realPrice,
    required this.discount,
    this.discountType,
    this.discountValue,
    this.shortDescription,
    this.description,
    required this.isAvailable,
    required this.addedAt,
    required this.subcategory,
    required this.quantity,
    this.baseUnit,
    this.baseQuantity,
    this.quantityDescription,
    this.countryOfOrigin,
    this.stock,
    this.stockUnit,
    required this.mostSearch,
    required this.mostPurchases,
    bool? isFreeDelivery,
    this.bogoFreeProductIds,
    this.comboOfferIds,
    bool? hasCategoryOffer,
    this.variants,
  }) : isFreeDelivery = isFreeDelivery ?? false,
       hasCategoryOffer = hasCategoryOffer ?? false;

  factory Product({
    String? productId,
    String? variantId,
    required String productName,
    required String category,
    required String imageUrl,
    required double price,
    required double realPrice,
    required double discount,
    String? discountType,
    double? discountValue,
    String? shortDescription,
    String? description,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    String? countryOfOrigin,
    double? stock,
    String? stockUnit,
    required int mostSearch,
    required int mostPurchases,
    bool? isFreeDelivery,
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? hasCategoryOffer,
    List<_i2.ProductVariant>? variants,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      productId: jsonSerialization['productId'] as String?,
      variantId: jsonSerialization['variantId'] as String?,
      productName: jsonSerialization['productName'] as String,
      category: jsonSerialization['category'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      realPrice: (jsonSerialization['realPrice'] as num).toDouble(),
      discount: (jsonSerialization['discount'] as num).toDouble(),
      discountType: jsonSerialization['discountType'] as String?,
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      shortDescription: jsonSerialization['shortDescription'] as String?,
      description: jsonSerialization['description'] as String?,
      isAvailable: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAvailable'],
      ),
      addedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedAt']),
      subcategory: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['subcategory'],
      ),
      quantity: jsonSerialization['quantity'] as String,
      baseUnit: jsonSerialization['baseUnit'] as String?,
      baseQuantity: (jsonSerialization['baseQuantity'] as num?)?.toDouble(),
      quantityDescription: jsonSerialization['quantityDescription'] as String?,
      countryOfOrigin: jsonSerialization['countryOfOrigin'] as String?,
      stock: (jsonSerialization['stock'] as num?)?.toDouble(),
      stockUnit: jsonSerialization['stockUnit'] as String?,
      mostSearch: jsonSerialization['mostSearch'] as int,
      mostPurchases: jsonSerialization['mostPurchases'] as int,
      isFreeDelivery: jsonSerialization['isFreeDelivery'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeDelivery']),
      bogoFreeProductIds: jsonSerialization['bogoFreeProductIds'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['bogoFreeProductIds'],
            ),
      comboOfferIds: jsonSerialization['comboOfferIds'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['comboOfferIds'],
            ),
      hasCategoryOffer: jsonSerialization['hasCategoryOffer'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['hasCategoryOffer'],
            ),
      variants: jsonSerialization['variants'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ProductVariant>>(
              jsonSerialization['variants'],
            ),
    );
  }

  String? productId;

  String? variantId;

  String productName;

  String category;

  String imageUrl;

  double price;

  double realPrice;

  double discount;

  String? discountType;

  double? discountValue;

  String? shortDescription;

  String? description;

  bool isAvailable;

  DateTime addedAt;

  List<String> subcategory;

  String quantity;

  String? baseUnit;

  double? baseQuantity;

  String? quantityDescription;

  String? countryOfOrigin;

  double? stock;

  String? stockUnit;

  int mostSearch;

  int mostPurchases;

  bool isFreeDelivery;

  List<String>? bogoFreeProductIds;

  List<String>? comboOfferIds;

  bool hasCategoryOffer;

  List<_i2.ProductVariant>? variants;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    String? productId,
    String? variantId,
    String? productName,
    String? category,
    String? imageUrl,
    double? price,
    double? realPrice,
    double? discount,
    String? discountType,
    double? discountValue,
    String? shortDescription,
    String? description,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    String? countryOfOrigin,
    double? stock,
    String? stockUnit,
    int? mostSearch,
    int? mostPurchases,
    bool? isFreeDelivery,
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? hasCategoryOffer,
    List<_i2.ProductVariant>? variants,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'productName': productName,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'realPrice': realPrice,
      'discount': discount,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      if (shortDescription != null) 'shortDescription': shortDescription,
      if (description != null) 'description': description,
      'isAvailable': isAvailable,
      'addedAt': addedAt.toJson(),
      'subcategory': subcategory.toJson(),
      'quantity': quantity,
      if (baseUnit != null) 'baseUnit': baseUnit,
      if (baseQuantity != null) 'baseQuantity': baseQuantity,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      if (countryOfOrigin != null) 'countryOfOrigin': countryOfOrigin,
      if (stock != null) 'stock': stock,
      if (stockUnit != null) 'stockUnit': stockUnit,
      'mostSearch': mostSearch,
      'mostPurchases': mostPurchases,
      'isFreeDelivery': isFreeDelivery,
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
      if (comboOfferIds != null) 'comboOfferIds': comboOfferIds?.toJson(),
      'hasCategoryOffer': hasCategoryOffer,
      if (variants != null)
        'variants': variants?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'productName': productName,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'realPrice': realPrice,
      'discount': discount,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      if (shortDescription != null) 'shortDescription': shortDescription,
      if (description != null) 'description': description,
      'isAvailable': isAvailable,
      'addedAt': addedAt.toJson(),
      'subcategory': subcategory.toJson(),
      'quantity': quantity,
      if (baseUnit != null) 'baseUnit': baseUnit,
      if (baseQuantity != null) 'baseQuantity': baseQuantity,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      if (countryOfOrigin != null) 'countryOfOrigin': countryOfOrigin,
      if (stock != null) 'stock': stock,
      if (stockUnit != null) 'stockUnit': stockUnit,
      'mostSearch': mostSearch,
      'mostPurchases': mostPurchases,
      'isFreeDelivery': isFreeDelivery,
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
      if (comboOfferIds != null) 'comboOfferIds': comboOfferIds?.toJson(),
      'hasCategoryOffer': hasCategoryOffer,
      if (variants != null)
        'variants': variants?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    String? productId,
    String? variantId,
    required String productName,
    required String category,
    required String imageUrl,
    required double price,
    required double realPrice,
    required double discount,
    String? discountType,
    double? discountValue,
    String? shortDescription,
    String? description,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    String? countryOfOrigin,
    double? stock,
    String? stockUnit,
    required int mostSearch,
    required int mostPurchases,
    bool? isFreeDelivery,
    List<String>? bogoFreeProductIds,
    List<String>? comboOfferIds,
    bool? hasCategoryOffer,
    List<_i2.ProductVariant>? variants,
  }) : super._(
         productId: productId,
         variantId: variantId,
         productName: productName,
         category: category,
         imageUrl: imageUrl,
         price: price,
         realPrice: realPrice,
         discount: discount,
         discountType: discountType,
         discountValue: discountValue,
         shortDescription: shortDescription,
         description: description,
         isAvailable: isAvailable,
         addedAt: addedAt,
         subcategory: subcategory,
         quantity: quantity,
         baseUnit: baseUnit,
         baseQuantity: baseQuantity,
         quantityDescription: quantityDescription,
         countryOfOrigin: countryOfOrigin,
         stock: stock,
         stockUnit: stockUnit,
         mostSearch: mostSearch,
         mostPurchases: mostPurchases,
         isFreeDelivery: isFreeDelivery,
         bogoFreeProductIds: bogoFreeProductIds,
         comboOfferIds: comboOfferIds,
         hasCategoryOffer: hasCategoryOffer,
         variants: variants,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? productId = _Undefined,
    Object? variantId = _Undefined,
    String? productName,
    String? category,
    String? imageUrl,
    double? price,
    double? realPrice,
    double? discount,
    Object? discountType = _Undefined,
    Object? discountValue = _Undefined,
    Object? shortDescription = _Undefined,
    Object? description = _Undefined,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    Object? baseUnit = _Undefined,
    Object? baseQuantity = _Undefined,
    Object? quantityDescription = _Undefined,
    Object? countryOfOrigin = _Undefined,
    Object? stock = _Undefined,
    Object? stockUnit = _Undefined,
    int? mostSearch,
    int? mostPurchases,
    bool? isFreeDelivery,
    Object? bogoFreeProductIds = _Undefined,
    Object? comboOfferIds = _Undefined,
    bool? hasCategoryOffer,
    Object? variants = _Undefined,
  }) {
    return Product(
      productId: productId is String? ? productId : this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      realPrice: realPrice ?? this.realPrice,
      discount: discount ?? this.discount,
      discountType: discountType is String? ? discountType : this.discountType,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      shortDescription: shortDescription is String?
          ? shortDescription
          : this.shortDescription,
      description: description is String? ? description : this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      addedAt: addedAt ?? this.addedAt,
      subcategory: subcategory ?? this.subcategory.map((e0) => e0).toList(),
      quantity: quantity ?? this.quantity,
      baseUnit: baseUnit is String? ? baseUnit : this.baseUnit,
      baseQuantity: baseQuantity is double? ? baseQuantity : this.baseQuantity,
      quantityDescription: quantityDescription is String?
          ? quantityDescription
          : this.quantityDescription,
      countryOfOrigin: countryOfOrigin is String?
          ? countryOfOrigin
          : this.countryOfOrigin,
      stock: stock is double? ? stock : this.stock,
      stockUnit: stockUnit is String? ? stockUnit : this.stockUnit,
      mostSearch: mostSearch ?? this.mostSearch,
      mostPurchases: mostPurchases ?? this.mostPurchases,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      bogoFreeProductIds: bogoFreeProductIds is List<String>?
          ? bogoFreeProductIds
          : this.bogoFreeProductIds?.map((e0) => e0).toList(),
      comboOfferIds: comboOfferIds is List<String>?
          ? comboOfferIds
          : this.comboOfferIds?.map((e0) => e0).toList(),
      hasCategoryOffer: hasCategoryOffer ?? this.hasCategoryOffer,
      variants: variants is List<_i2.ProductVariant>?
          ? variants
          : this.variants?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
