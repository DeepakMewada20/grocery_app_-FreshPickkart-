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
import 'applied_offer_info.dart' as _i2;
import 'applied_coupon_info.dart' as _i3;
import 'free_item_info.dart' as _i4;
import 'pricing_line_item.dart' as _i5;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i6;

abstract class CartPricingResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CartPricingResult._({
    required this.subtotal,
    required this.itemDiscounts,
    required this.productOfferDiscount,
    required this.categoryOfferDiscount,
    required this.bogoDiscount,
    required this.comboDiscount,
    required this.couponDiscount,
    required this.deliveryFee,
    required this.originalDeliveryFee,
    required this.freeDeliveryApplied,
    required this.totalSavings,
    required this.totalAmount,
    required this.appliedOffers,
    this.appliedCoupon,
    required this.freeItems,
    required this.pricingBreakdown,
  });

  factory CartPricingResult({
    required double subtotal,
    required double itemDiscounts,
    required double productOfferDiscount,
    required double categoryOfferDiscount,
    required double bogoDiscount,
    required double comboDiscount,
    required double couponDiscount,
    required double deliveryFee,
    required double originalDeliveryFee,
    required bool freeDeliveryApplied,
    required double totalSavings,
    required double totalAmount,
    required List<_i2.AppliedOfferInfo> appliedOffers,
    _i3.AppliedCouponInfo? appliedCoupon,
    required List<_i4.FreeItemInfo> freeItems,
    required List<_i5.PricingLineItem> pricingBreakdown,
  }) = _CartPricingResultImpl;

  factory CartPricingResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartPricingResult(
      subtotal: (jsonSerialization['subtotal'] as num).toDouble(),
      itemDiscounts: (jsonSerialization['itemDiscounts'] as num).toDouble(),
      productOfferDiscount: (jsonSerialization['productOfferDiscount'] as num)
          .toDouble(),
      categoryOfferDiscount: (jsonSerialization['categoryOfferDiscount'] as num)
          .toDouble(),
      bogoDiscount: (jsonSerialization['bogoDiscount'] as num).toDouble(),
      comboDiscount: (jsonSerialization['comboDiscount'] as num).toDouble(),
      couponDiscount: (jsonSerialization['couponDiscount'] as num).toDouble(),
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      originalDeliveryFee: (jsonSerialization['originalDeliveryFee'] as num)
          .toDouble(),
      freeDeliveryApplied: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['freeDeliveryApplied'],
      ),
      totalSavings: (jsonSerialization['totalSavings'] as num).toDouble(),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      appliedOffers: _i6.Protocol().deserialize<List<_i2.AppliedOfferInfo>>(
        jsonSerialization['appliedOffers'],
      ),
      appliedCoupon: jsonSerialization['appliedCoupon'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.AppliedCouponInfo>(
              jsonSerialization['appliedCoupon'],
            ),
      freeItems: _i6.Protocol().deserialize<List<_i4.FreeItemInfo>>(
        jsonSerialization['freeItems'],
      ),
      pricingBreakdown: _i6.Protocol().deserialize<List<_i5.PricingLineItem>>(
        jsonSerialization['pricingBreakdown'],
      ),
    );
  }

  double subtotal;

  double itemDiscounts;

  double productOfferDiscount;

  double categoryOfferDiscount;

  double bogoDiscount;

  double comboDiscount;

  double couponDiscount;

  double deliveryFee;

  double originalDeliveryFee;

  bool freeDeliveryApplied;

  double totalSavings;

  double totalAmount;

  List<_i2.AppliedOfferInfo> appliedOffers;

  _i3.AppliedCouponInfo? appliedCoupon;

  List<_i4.FreeItemInfo> freeItems;

  List<_i5.PricingLineItem> pricingBreakdown;

  /// Returns a shallow copy of this [CartPricingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartPricingResult copyWith({
    double? subtotal,
    double? itemDiscounts,
    double? productOfferDiscount,
    double? categoryOfferDiscount,
    double? bogoDiscount,
    double? comboDiscount,
    double? couponDiscount,
    double? deliveryFee,
    double? originalDeliveryFee,
    bool? freeDeliveryApplied,
    double? totalSavings,
    double? totalAmount,
    List<_i2.AppliedOfferInfo>? appliedOffers,
    _i3.AppliedCouponInfo? appliedCoupon,
    List<_i4.FreeItemInfo>? freeItems,
    List<_i5.PricingLineItem>? pricingBreakdown,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartPricingResult',
      'subtotal': subtotal,
      'itemDiscounts': itemDiscounts,
      'productOfferDiscount': productOfferDiscount,
      'categoryOfferDiscount': categoryOfferDiscount,
      'bogoDiscount': bogoDiscount,
      'comboDiscount': comboDiscount,
      'couponDiscount': couponDiscount,
      'deliveryFee': deliveryFee,
      'originalDeliveryFee': originalDeliveryFee,
      'freeDeliveryApplied': freeDeliveryApplied,
      'totalSavings': totalSavings,
      'totalAmount': totalAmount,
      'appliedOffers': appliedOffers.toJson(valueToJson: (v) => v.toJson()),
      if (appliedCoupon != null) 'appliedCoupon': appliedCoupon?.toJson(),
      'freeItems': freeItems.toJson(valueToJson: (v) => v.toJson()),
      'pricingBreakdown': pricingBreakdown.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CartPricingResult',
      'subtotal': subtotal,
      'itemDiscounts': itemDiscounts,
      'productOfferDiscount': productOfferDiscount,
      'categoryOfferDiscount': categoryOfferDiscount,
      'bogoDiscount': bogoDiscount,
      'comboDiscount': comboDiscount,
      'couponDiscount': couponDiscount,
      'deliveryFee': deliveryFee,
      'originalDeliveryFee': originalDeliveryFee,
      'freeDeliveryApplied': freeDeliveryApplied,
      'totalSavings': totalSavings,
      'totalAmount': totalAmount,
      'appliedOffers': appliedOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (appliedCoupon != null)
        'appliedCoupon': appliedCoupon?.toJsonForProtocol(),
      'freeItems': freeItems.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'pricingBreakdown': pricingBreakdown.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartPricingResultImpl extends CartPricingResult {
  _CartPricingResultImpl({
    required double subtotal,
    required double itemDiscounts,
    required double productOfferDiscount,
    required double categoryOfferDiscount,
    required double bogoDiscount,
    required double comboDiscount,
    required double couponDiscount,
    required double deliveryFee,
    required double originalDeliveryFee,
    required bool freeDeliveryApplied,
    required double totalSavings,
    required double totalAmount,
    required List<_i2.AppliedOfferInfo> appliedOffers,
    _i3.AppliedCouponInfo? appliedCoupon,
    required List<_i4.FreeItemInfo> freeItems,
    required List<_i5.PricingLineItem> pricingBreakdown,
  }) : super._(
         subtotal: subtotal,
         itemDiscounts: itemDiscounts,
         productOfferDiscount: productOfferDiscount,
         categoryOfferDiscount: categoryOfferDiscount,
         bogoDiscount: bogoDiscount,
         comboDiscount: comboDiscount,
         couponDiscount: couponDiscount,
         deliveryFee: deliveryFee,
         originalDeliveryFee: originalDeliveryFee,
         freeDeliveryApplied: freeDeliveryApplied,
         totalSavings: totalSavings,
         totalAmount: totalAmount,
         appliedOffers: appliedOffers,
         appliedCoupon: appliedCoupon,
         freeItems: freeItems,
         pricingBreakdown: pricingBreakdown,
       );

  /// Returns a shallow copy of this [CartPricingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartPricingResult copyWith({
    double? subtotal,
    double? itemDiscounts,
    double? productOfferDiscount,
    double? categoryOfferDiscount,
    double? bogoDiscount,
    double? comboDiscount,
    double? couponDiscount,
    double? deliveryFee,
    double? originalDeliveryFee,
    bool? freeDeliveryApplied,
    double? totalSavings,
    double? totalAmount,
    List<_i2.AppliedOfferInfo>? appliedOffers,
    Object? appliedCoupon = _Undefined,
    List<_i4.FreeItemInfo>? freeItems,
    List<_i5.PricingLineItem>? pricingBreakdown,
  }) {
    return CartPricingResult(
      subtotal: subtotal ?? this.subtotal,
      itemDiscounts: itemDiscounts ?? this.itemDiscounts,
      productOfferDiscount: productOfferDiscount ?? this.productOfferDiscount,
      categoryOfferDiscount:
          categoryOfferDiscount ?? this.categoryOfferDiscount,
      bogoDiscount: bogoDiscount ?? this.bogoDiscount,
      comboDiscount: comboDiscount ?? this.comboDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      originalDeliveryFee: originalDeliveryFee ?? this.originalDeliveryFee,
      freeDeliveryApplied: freeDeliveryApplied ?? this.freeDeliveryApplied,
      totalSavings: totalSavings ?? this.totalSavings,
      totalAmount: totalAmount ?? this.totalAmount,
      appliedOffers:
          appliedOffers ??
          this.appliedOffers.map((e0) => e0.copyWith()).toList(),
      appliedCoupon: appliedCoupon is _i3.AppliedCouponInfo?
          ? appliedCoupon
          : this.appliedCoupon?.copyWith(),
      freeItems:
          freeItems ?? this.freeItems.map((e0) => e0.copyWith()).toList(),
      pricingBreakdown:
          pricingBreakdown ??
          this.pricingBreakdown.map((e0) => e0.copyWith()).toList(),
    );
  }
}
