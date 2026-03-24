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

abstract class Product
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Product._({
    this.productId,
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.realPrice,
    required this.discount,
    this.discountType,
    this.discountValue,
    required this.isAvailable,
    required this.addedAt,
    required this.subcategory,
    required this.quantity,
    this.countryOfOrigin,
    this.searchKeywords,
    required this.mostSearch,
    required this.mostPurchases,
    this.bogoFreeProductIds,
  });

  factory Product({
    String? productId,
    required String productName,
    required String category,
    required String imageUrl,
    required double price,
    required double realPrice,
    required double discount,
    String? discountType,
    double? discountValue,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    String? countryOfOrigin,
    List<String>? searchKeywords,
    required int mostSearch,
    required int mostPurchases,
    List<String>? bogoFreeProductIds,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      productId: jsonSerialization['productId'] as String?,
      productName: jsonSerialization['productName'] as String,
      category: jsonSerialization['category'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      realPrice: (jsonSerialization['realPrice'] as num).toDouble(),
      discount: (jsonSerialization['discount'] as num).toDouble(),
      discountType: jsonSerialization['discountType'] as String?,
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      isAvailable: jsonSerialization['isAvailable'] as bool,
      addedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedAt']),
      subcategory: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['subcategory'],
      ),
      quantity: jsonSerialization['quantity'] as String,
      countryOfOrigin: jsonSerialization['countryOfOrigin'] as String?,
      searchKeywords: jsonSerialization['searchKeywords'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['searchKeywords'],
            ),
      mostSearch: jsonSerialization['mostSearch'] as int,
      mostPurchases: jsonSerialization['mostPurchases'] as int,
      bogoFreeProductIds: jsonSerialization['bogoFreeProductIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['bogoFreeProductIds'],
            ),
    );
  }

  String? productId;

  String productName;

  String category;

  String imageUrl;

  double price;

  double realPrice;

  double discount;

  String? discountType;

  double? discountValue;

  bool isAvailable;

  DateTime addedAt;

  List<String> subcategory;

  String quantity;

  String? countryOfOrigin;

  List<String>? searchKeywords;

  int mostSearch;

  int mostPurchases;

  List<String>? bogoFreeProductIds;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    String? productId,
    String? productName,
    String? category,
    String? imageUrl,
    double? price,
    double? realPrice,
    double? discount,
    String? discountType,
    double? discountValue,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    String? countryOfOrigin,
    List<String>? searchKeywords,
    int? mostSearch,
    int? mostPurchases,
    List<String>? bogoFreeProductIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (productId != null) 'productId': productId,
      'productName': productName,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'realPrice': realPrice,
      'discount': discount,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      'isAvailable': isAvailable,
      'addedAt': addedAt.toJson(),
      'subcategory': subcategory.toJson(),
      'quantity': quantity,
      if (countryOfOrigin != null) 'countryOfOrigin': countryOfOrigin,
      if (searchKeywords != null) 'searchKeywords': searchKeywords?.toJson(),
      'mostSearch': mostSearch,
      'mostPurchases': mostPurchases,
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (productId != null) 'productId': productId,
      'productName': productName,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'realPrice': realPrice,
      'discount': discount,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      'isAvailable': isAvailable,
      'addedAt': addedAt.toJson(),
      'subcategory': subcategory.toJson(),
      'quantity': quantity,
      if (countryOfOrigin != null) 'countryOfOrigin': countryOfOrigin,
      if (searchKeywords != null) 'searchKeywords': searchKeywords?.toJson(),
      'mostSearch': mostSearch,
      'mostPurchases': mostPurchases,
      if (bogoFreeProductIds != null)
        'bogoFreeProductIds': bogoFreeProductIds?.toJson(),
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
    required String productName,
    required String category,
    required String imageUrl,
    required double price,
    required double realPrice,
    required double discount,
    String? discountType,
    double? discountValue,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    String? countryOfOrigin,
    List<String>? searchKeywords,
    required int mostSearch,
    required int mostPurchases,
    List<String>? bogoFreeProductIds,
  }) : super._(
         productId: productId,
         productName: productName,
         category: category,
         imageUrl: imageUrl,
         price: price,
         realPrice: realPrice,
         discount: discount,
         discountType: discountType,
         discountValue: discountValue,
         isAvailable: isAvailable,
         addedAt: addedAt,
         subcategory: subcategory,
         quantity: quantity,
         countryOfOrigin: countryOfOrigin,
         searchKeywords: searchKeywords,
         mostSearch: mostSearch,
         mostPurchases: mostPurchases,
         bogoFreeProductIds: bogoFreeProductIds,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? productId = _Undefined,
    String? productName,
    String? category,
    String? imageUrl,
    double? price,
    double? realPrice,
    double? discount,
    Object? discountType = _Undefined,
    Object? discountValue = _Undefined,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    Object? countryOfOrigin = _Undefined,
    Object? searchKeywords = _Undefined,
    int? mostSearch,
    int? mostPurchases,
    Object? bogoFreeProductIds = _Undefined,
  }) {
    return Product(
      productId: productId is String? ? productId : this.productId,
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
      isAvailable: isAvailable ?? this.isAvailable,
      addedAt: addedAt ?? this.addedAt,
      subcategory: subcategory ?? this.subcategory.map((e0) => e0).toList(),
      quantity: quantity ?? this.quantity,
      countryOfOrigin: countryOfOrigin is String?
          ? countryOfOrigin
          : this.countryOfOrigin,
      searchKeywords: searchKeywords is List<String>?
          ? searchKeywords
          : this.searchKeywords?.map((e0) => e0).toList(),
      mostSearch: mostSearch ?? this.mostSearch,
      mostPurchases: mostPurchases ?? this.mostPurchases,
      bogoFreeProductIds: bogoFreeProductIds is List<String>?
          ? bogoFreeProductIds
          : this.bogoFreeProductIds?.map((e0) => e0).toList(),
    );
  }
}
