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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i2;

abstract class Product implements _i1.SerializableModel {
  Product._({
    this.productId,
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.realPrice,
    required this.discount,
    required this.isAvailable,
    required this.addedAt,
    required this.subcategory,
    required this.quantity,
    this.searchKeywords,
  });

  factory Product({
    String? productId,
    required String productName,
    required String category,
    required String imageUrl,
    required int price,
    required int realPrice,
    required int discount,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    List<String>? searchKeywords,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      productId: jsonSerialization['productId'] as String?,
      productName: jsonSerialization['productName'] as String,
      category: jsonSerialization['category'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      price: jsonSerialization['price'] as int,
      realPrice: jsonSerialization['realPrice'] as int,
      discount: jsonSerialization['discount'] as int,
      isAvailable: jsonSerialization['isAvailable'] as bool,
      addedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedAt']),
      subcategory: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['subcategory'],
      ),
      quantity: jsonSerialization['quantity'] as String,
      searchKeywords: jsonSerialization['searchKeywords'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['searchKeywords'],
            ),
    );
  }

  String? productId;

  String productName;

  String category;

  String imageUrl;

  int price;

  int realPrice;

  int discount;

  bool isAvailable;

  DateTime addedAt;

  List<String> subcategory;

  String quantity;

  List<String>? searchKeywords;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    String? productId,
    String? productName,
    String? category,
    String? imageUrl,
    int? price,
    int? realPrice,
    int? discount,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    List<String>? searchKeywords,
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
      'isAvailable': isAvailable,
      'addedAt': addedAt.toJson(),
      'subcategory': subcategory.toJson(),
      'quantity': quantity,
      if (searchKeywords != null) 'searchKeywords': searchKeywords?.toJson(),
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
    required int price,
    required int realPrice,
    required int discount,
    required bool isAvailable,
    required DateTime addedAt,
    required List<String> subcategory,
    required String quantity,
    List<String>? searchKeywords,
  }) : super._(
         productId: productId,
         productName: productName,
         category: category,
         imageUrl: imageUrl,
         price: price,
         realPrice: realPrice,
         discount: discount,
         isAvailable: isAvailable,
         addedAt: addedAt,
         subcategory: subcategory,
         quantity: quantity,
         searchKeywords: searchKeywords,
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
    int? price,
    int? realPrice,
    int? discount,
    bool? isAvailable,
    DateTime? addedAt,
    List<String>? subcategory,
    String? quantity,
    Object? searchKeywords = _Undefined,
  }) {
    return Product(
      productId: productId is String? ? productId : this.productId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      realPrice: realPrice ?? this.realPrice,
      discount: discount ?? this.discount,
      isAvailable: isAvailable ?? this.isAvailable,
      addedAt: addedAt ?? this.addedAt,
      subcategory: subcategory ?? this.subcategory.map((e0) => e0).toList(),
      quantity: quantity ?? this.quantity,
      searchKeywords: searchKeywords is List<String>?
          ? searchKeywords
          : this.searchKeywords?.map((e0) => e0).toList(),
    );
  }
}
