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

abstract class FreeItemInfo implements _i1.SerializableModel {
  FreeItemInfo._({
    required this.productId,
    required this.productName,
    this.imageUrl,
    this.variantId,
    this.variantLabel,
    required this.quantity,
    this.triggerProductId,
    this.bogoOfferId,
    this.rewardSource,
    this.rewardOfferId,
    this.rewardOfferName,
    this.rewardThreshold,
    this.originalUnitPrice,
    this.rewardValue,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
  }) : isRewardProduct = isRewardProduct ?? false,
       quantityEditable = quantityEditable ?? false,
       priceEditable = priceEditable ?? false;

  factory FreeItemInfo({
    required String productId,
    required String productName,
    String? imageUrl,
    String? variantId,
    String? variantLabel,
    required int quantity,
    String? triggerProductId,
    String? bogoOfferId,
    String? rewardSource,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    double? originalUnitPrice,
    double? rewardValue,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
  }) = _FreeItemInfoImpl;

  factory FreeItemInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return FreeItemInfo(
      productId: jsonSerialization['productId'] as String,
      productName: jsonSerialization['productName'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      variantId: jsonSerialization['variantId'] as String?,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      triggerProductId: jsonSerialization['triggerProductId'] as String?,
      bogoOfferId: jsonSerialization['bogoOfferId'] as String?,
      rewardSource: jsonSerialization['rewardSource'] as String?,
      rewardOfferId: jsonSerialization['rewardOfferId'] as String?,
      rewardOfferName: jsonSerialization['rewardOfferName'] as String?,
      rewardThreshold: (jsonSerialization['rewardThreshold'] as num?)
          ?.toDouble(),
      originalUnitPrice: (jsonSerialization['originalUnitPrice'] as num?)
          ?.toDouble(),
      rewardValue: (jsonSerialization['rewardValue'] as num?)?.toDouble(),
      isRewardProduct: jsonSerialization['isRewardProduct'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isRewardProduct'],
            ),
      quantityEditable: jsonSerialization['quantityEditable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['quantityEditable'],
            ),
      priceEditable: jsonSerialization['priceEditable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['priceEditable']),
    );
  }

  String productId;

  String productName;

  String? imageUrl;

  String? variantId;

  String? variantLabel;

  int quantity;

  String? triggerProductId;

  String? bogoOfferId;

  String? rewardSource;

  String? rewardOfferId;

  String? rewardOfferName;

  double? rewardThreshold;

  double? originalUnitPrice;

  double? rewardValue;

  bool isRewardProduct;

  bool quantityEditable;

  bool priceEditable;

  /// Returns a shallow copy of this [FreeItemInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreeItemInfo copyWith({
    String? productId,
    String? productName,
    String? imageUrl,
    String? variantId,
    String? variantLabel,
    int? quantity,
    String? triggerProductId,
    String? bogoOfferId,
    String? rewardSource,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    double? originalUnitPrice,
    double? rewardValue,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreeItemInfo',
      'productId': productId,
      'productName': productName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (variantId != null) 'variantId': variantId,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
      if (bogoOfferId != null) 'bogoOfferId': bogoOfferId,
      if (rewardSource != null) 'rewardSource': rewardSource,
      if (rewardOfferId != null) 'rewardOfferId': rewardOfferId,
      if (rewardOfferName != null) 'rewardOfferName': rewardOfferName,
      if (rewardThreshold != null) 'rewardThreshold': rewardThreshold,
      if (originalUnitPrice != null) 'originalUnitPrice': originalUnitPrice,
      if (rewardValue != null) 'rewardValue': rewardValue,
      'isRewardProduct': isRewardProduct,
      'quantityEditable': quantityEditable,
      'priceEditable': priceEditable,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreeItemInfoImpl extends FreeItemInfo {
  _FreeItemInfoImpl({
    required String productId,
    required String productName,
    String? imageUrl,
    String? variantId,
    String? variantLabel,
    required int quantity,
    String? triggerProductId,
    String? bogoOfferId,
    String? rewardSource,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    double? originalUnitPrice,
    double? rewardValue,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
  }) : super._(
         productId: productId,
         productName: productName,
         imageUrl: imageUrl,
         variantId: variantId,
         variantLabel: variantLabel,
         quantity: quantity,
         triggerProductId: triggerProductId,
         bogoOfferId: bogoOfferId,
         rewardSource: rewardSource,
         rewardOfferId: rewardOfferId,
         rewardOfferName: rewardOfferName,
         rewardThreshold: rewardThreshold,
         originalUnitPrice: originalUnitPrice,
         rewardValue: rewardValue,
         isRewardProduct: isRewardProduct,
         quantityEditable: quantityEditable,
         priceEditable: priceEditable,
       );

  /// Returns a shallow copy of this [FreeItemInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreeItemInfo copyWith({
    String? productId,
    String? productName,
    Object? imageUrl = _Undefined,
    Object? variantId = _Undefined,
    Object? variantLabel = _Undefined,
    int? quantity,
    Object? triggerProductId = _Undefined,
    Object? bogoOfferId = _Undefined,
    Object? rewardSource = _Undefined,
    Object? rewardOfferId = _Undefined,
    Object? rewardOfferName = _Undefined,
    Object? rewardThreshold = _Undefined,
    Object? originalUnitPrice = _Undefined,
    Object? rewardValue = _Undefined,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
  }) {
    return FreeItemInfo(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      variantId: variantId is String? ? variantId : this.variantId,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      quantity: quantity ?? this.quantity,
      triggerProductId: triggerProductId is String?
          ? triggerProductId
          : this.triggerProductId,
      bogoOfferId: bogoOfferId is String? ? bogoOfferId : this.bogoOfferId,
      rewardSource: rewardSource is String? ? rewardSource : this.rewardSource,
      rewardOfferId: rewardOfferId is String?
          ? rewardOfferId
          : this.rewardOfferId,
      rewardOfferName: rewardOfferName is String?
          ? rewardOfferName
          : this.rewardOfferName,
      rewardThreshold: rewardThreshold is double?
          ? rewardThreshold
          : this.rewardThreshold,
      originalUnitPrice: originalUnitPrice is double?
          ? originalUnitPrice
          : this.originalUnitPrice,
      rewardValue: rewardValue is double? ? rewardValue : this.rewardValue,
      isRewardProduct: isRewardProduct ?? this.isRewardProduct,
      quantityEditable: quantityEditable ?? this.quantityEditable,
      priceEditable: priceEditable ?? this.priceEditable,
    );
  }
}
