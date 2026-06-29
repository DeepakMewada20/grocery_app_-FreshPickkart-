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
    this.orderItemId,
    required this.productId,
    this.variantId,
    this.variantLabel,
    required this.productName,
    required this.productImage,
    this.mrp,
    this.sku,
    this.productSlug,
    this.categoryName,
    this.productStatus,
    this.appliedOfferSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    this.originalUnitPrice,
    this.rewardValue,
    this.triggerProductId,
    this.comboId,
    this.comboName,
    this.comboDiscountType,
    this.comboDiscountValue,
    this.comboItemQuantity,
    this.rewardOfferId,
    this.rewardOfferName,
    this.rewardThreshold,
    this.rewardSource,
    bool? isFreeDelivery,
  }) : isRewardProduct = isRewardProduct ?? false,
       quantityEditable = quantityEditable ?? true,
       priceEditable = priceEditable ?? true,
       isFreeDelivery = isFreeDelivery ?? false;

  factory OrderItem({
    String? orderItemId,
    required String productId,
    String? variantId,
    String? variantLabel,
    required String productName,
    required String productImage,
    double? mrp,
    String? sku,
    String? productSlug,
    String? categoryName,
    String? productStatus,
    String? appliedOfferSnapshot,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
  }) = _OrderItemImpl;

  factory OrderItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItem(
      orderItemId: jsonSerialization['orderItemId'] as String?,
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      productName: jsonSerialization['productName'] as String,
      productImage: jsonSerialization['productImage'] as String,
      mrp: (jsonSerialization['mrp'] as num?)?.toDouble(),
      sku: jsonSerialization['sku'] as String?,
      productSlug: jsonSerialization['productSlug'] as String?,
      categoryName: jsonSerialization['categoryName'] as String?,
      productStatus: jsonSerialization['productStatus'] as String?,
      appliedOfferSnapshot:
          jsonSerialization['appliedOfferSnapshot'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      isFreeItem: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFreeItem'],
      ),
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
      originalUnitPrice: (jsonSerialization['originalUnitPrice'] as num?)
          ?.toDouble(),
      rewardValue: (jsonSerialization['rewardValue'] as num?)?.toDouble(),
      triggerProductId: jsonSerialization['triggerProductId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      comboName: jsonSerialization['comboName'] as String?,
      comboDiscountType: jsonSerialization['comboDiscountType'] as String?,
      comboDiscountValue: (jsonSerialization['comboDiscountValue'] as num?)
          ?.toDouble(),
      comboItemQuantity: jsonSerialization['comboItemQuantity'] as int?,
      rewardOfferId: jsonSerialization['rewardOfferId'] as String?,
      rewardOfferName: jsonSerialization['rewardOfferName'] as String?,
      rewardThreshold: (jsonSerialization['rewardThreshold'] as num?)
          ?.toDouble(),
      rewardSource: jsonSerialization['rewardSource'] as String?,
      isFreeDelivery: jsonSerialization['isFreeDelivery'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeDelivery']),
    );
  }

  String? orderItemId;

  String productId;

  String? variantId;

  String? variantLabel;

  String productName;

  String productImage;

  double? mrp;

  String? sku;

  String? productSlug;

  String? categoryName;

  String? productStatus;

  String? appliedOfferSnapshot;

  int quantity;

  double unitPrice;

  double totalPrice;

  bool isFreeItem;

  bool isRewardProduct;

  bool quantityEditable;

  bool priceEditable;

  double? originalUnitPrice;

  double? rewardValue;

  String? triggerProductId;

  String? comboId;

  String? comboName;

  String? comboDiscountType;

  double? comboDiscountValue;

  int? comboItemQuantity;

  String? rewardOfferId;

  String? rewardOfferName;

  double? rewardThreshold;

  String? rewardSource;

  bool isFreeDelivery;

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderItem copyWith({
    String? orderItemId,
    String? productId,
    String? variantId,
    String? variantLabel,
    String? productName,
    String? productImage,
    double? mrp,
    String? sku,
    String? productSlug,
    String? categoryName,
    String? productStatus,
    String? appliedOfferSnapshot,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItem',
      if (orderItemId != null) 'orderItemId': orderItemId,
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'productName': productName,
      'productImage': productImage,
      if (mrp != null) 'mrp': mrp,
      if (sku != null) 'sku': sku,
      if (productSlug != null) 'productSlug': productSlug,
      if (categoryName != null) 'categoryName': categoryName,
      if (productStatus != null) 'productStatus': productStatus,
      if (appliedOfferSnapshot != null)
        'appliedOfferSnapshot': appliedOfferSnapshot,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      'isRewardProduct': isRewardProduct,
      'quantityEditable': quantityEditable,
      'priceEditable': priceEditable,
      if (originalUnitPrice != null) 'originalUnitPrice': originalUnitPrice,
      if (rewardValue != null) 'rewardValue': rewardValue,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
      if (comboId != null) 'comboId': comboId,
      if (comboName != null) 'comboName': comboName,
      if (comboDiscountType != null) 'comboDiscountType': comboDiscountType,
      if (comboDiscountValue != null) 'comboDiscountValue': comboDiscountValue,
      if (comboItemQuantity != null) 'comboItemQuantity': comboItemQuantity,
      if (rewardOfferId != null) 'rewardOfferId': rewardOfferId,
      if (rewardOfferName != null) 'rewardOfferName': rewardOfferName,
      if (rewardThreshold != null) 'rewardThreshold': rewardThreshold,
      if (rewardSource != null) 'rewardSource': rewardSource,
      'isFreeDelivery': isFreeDelivery,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderItem',
      if (orderItemId != null) 'orderItemId': orderItemId,
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'productName': productName,
      'productImage': productImage,
      if (mrp != null) 'mrp': mrp,
      if (sku != null) 'sku': sku,
      if (productSlug != null) 'productSlug': productSlug,
      if (categoryName != null) 'categoryName': categoryName,
      if (productStatus != null) 'productStatus': productStatus,
      if (appliedOfferSnapshot != null)
        'appliedOfferSnapshot': appliedOfferSnapshot,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      'isRewardProduct': isRewardProduct,
      'quantityEditable': quantityEditable,
      'priceEditable': priceEditable,
      if (originalUnitPrice != null) 'originalUnitPrice': originalUnitPrice,
      if (rewardValue != null) 'rewardValue': rewardValue,
      if (triggerProductId != null) 'triggerProductId': triggerProductId,
      if (comboId != null) 'comboId': comboId,
      if (comboName != null) 'comboName': comboName,
      if (comboDiscountType != null) 'comboDiscountType': comboDiscountType,
      if (comboDiscountValue != null) 'comboDiscountValue': comboDiscountValue,
      if (comboItemQuantity != null) 'comboItemQuantity': comboItemQuantity,
      if (rewardOfferId != null) 'rewardOfferId': rewardOfferId,
      if (rewardOfferName != null) 'rewardOfferName': rewardOfferName,
      if (rewardThreshold != null) 'rewardThreshold': rewardThreshold,
      if (rewardSource != null) 'rewardSource': rewardSource,
      'isFreeDelivery': isFreeDelivery,
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
    String? orderItemId,
    required String productId,
    String? variantId,
    String? variantLabel,
    required String productName,
    required String productImage,
    double? mrp,
    String? sku,
    String? productSlug,
    String? categoryName,
    String? productStatus,
    String? appliedOfferSnapshot,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required bool isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? triggerProductId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
  }) : super._(
         orderItemId: orderItemId,
         productId: productId,
         variantId: variantId,
         variantLabel: variantLabel,
         productName: productName,
         productImage: productImage,
         mrp: mrp,
         sku: sku,
         productSlug: productSlug,
         categoryName: categoryName,
         productStatus: productStatus,
         appliedOfferSnapshot: appliedOfferSnapshot,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
         isFreeItem: isFreeItem,
         isRewardProduct: isRewardProduct,
         quantityEditable: quantityEditable,
         priceEditable: priceEditable,
         originalUnitPrice: originalUnitPrice,
         rewardValue: rewardValue,
         triggerProductId: triggerProductId,
         comboId: comboId,
         comboName: comboName,
         comboDiscountType: comboDiscountType,
         comboDiscountValue: comboDiscountValue,
         comboItemQuantity: comboItemQuantity,
         rewardOfferId: rewardOfferId,
         rewardOfferName: rewardOfferName,
         rewardThreshold: rewardThreshold,
         rewardSource: rewardSource,
         isFreeDelivery: isFreeDelivery,
       );

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderItem copyWith({
    Object? orderItemId = _Undefined,
    String? productId,
    Object? variantId = _Undefined,
    Object? variantLabel = _Undefined,
    String? productName,
    String? productImage,
    Object? mrp = _Undefined,
    Object? sku = _Undefined,
    Object? productSlug = _Undefined,
    Object? categoryName = _Undefined,
    Object? productStatus = _Undefined,
    Object? appliedOfferSnapshot = _Undefined,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    Object? originalUnitPrice = _Undefined,
    Object? rewardValue = _Undefined,
    Object? triggerProductId = _Undefined,
    Object? comboId = _Undefined,
    Object? comboName = _Undefined,
    Object? comboDiscountType = _Undefined,
    Object? comboDiscountValue = _Undefined,
    Object? comboItemQuantity = _Undefined,
    Object? rewardOfferId = _Undefined,
    Object? rewardOfferName = _Undefined,
    Object? rewardThreshold = _Undefined,
    Object? rewardSource = _Undefined,
    bool? isFreeDelivery,
  }) {
    return OrderItem(
      orderItemId: orderItemId is String? ? orderItemId : this.orderItemId,
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      mrp: mrp is double? ? mrp : this.mrp,
      sku: sku is String? ? sku : this.sku,
      productSlug: productSlug is String? ? productSlug : this.productSlug,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      productStatus: productStatus is String?
          ? productStatus
          : this.productStatus,
      appliedOfferSnapshot: appliedOfferSnapshot is String?
          ? appliedOfferSnapshot
          : this.appliedOfferSnapshot,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isFreeItem: isFreeItem ?? this.isFreeItem,
      isRewardProduct: isRewardProduct ?? this.isRewardProduct,
      quantityEditable: quantityEditable ?? this.quantityEditable,
      priceEditable: priceEditable ?? this.priceEditable,
      originalUnitPrice: originalUnitPrice is double?
          ? originalUnitPrice
          : this.originalUnitPrice,
      rewardValue: rewardValue is double? ? rewardValue : this.rewardValue,
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
      rewardOfferId: rewardOfferId is String?
          ? rewardOfferId
          : this.rewardOfferId,
      rewardOfferName: rewardOfferName is String?
          ? rewardOfferName
          : this.rewardOfferName,
      rewardThreshold: rewardThreshold is double?
          ? rewardThreshold
          : this.rewardThreshold,
      rewardSource: rewardSource is String? ? rewardSource : this.rewardSource,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
    );
  }
}
