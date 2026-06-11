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
import 'cart_pricing_result.dart' as _i2;
import 'basket_suggestion_result.dart' as _i3;
import 'coupon_display.dart' as _i4;
import 'delivery_config.dart' as _i5;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i6;

abstract class CartHydratedData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CartHydratedData._({
    this.cartPricing,
    this.basketSuggestions,
    required this.availableCoupons,
    required this.deliveryConfig,
  });

  factory CartHydratedData({
    _i2.CartPricingResult? cartPricing,
    _i3.BasketSuggestionResult? basketSuggestions,
    required List<_i4.CouponDisplay> availableCoupons,
    required _i5.DeliveryConfig deliveryConfig,
  }) = _CartHydratedDataImpl;

  factory CartHydratedData.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartHydratedData(
      cartPricing: jsonSerialization['cartPricing'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.CartPricingResult>(
              jsonSerialization['cartPricing'],
            ),
      basketSuggestions: jsonSerialization['basketSuggestions'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.BasketSuggestionResult>(
              jsonSerialization['basketSuggestions'],
            ),
      availableCoupons: _i6.Protocol().deserialize<List<_i4.CouponDisplay>>(
        jsonSerialization['availableCoupons'],
      ),
      deliveryConfig: _i6.Protocol().deserialize<_i5.DeliveryConfig>(
        jsonSerialization['deliveryConfig'],
      ),
    );
  }

  _i2.CartPricingResult? cartPricing;

  _i3.BasketSuggestionResult? basketSuggestions;

  List<_i4.CouponDisplay> availableCoupons;

  _i5.DeliveryConfig deliveryConfig;

  /// Returns a shallow copy of this [CartHydratedData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartHydratedData copyWith({
    _i2.CartPricingResult? cartPricing,
    _i3.BasketSuggestionResult? basketSuggestions,
    List<_i4.CouponDisplay>? availableCoupons,
    _i5.DeliveryConfig? deliveryConfig,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartHydratedData',
      if (cartPricing != null) 'cartPricing': cartPricing?.toJson(),
      if (basketSuggestions != null)
        'basketSuggestions': basketSuggestions?.toJson(),
      'availableCoupons': availableCoupons.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'deliveryConfig': deliveryConfig.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CartHydratedData',
      if (cartPricing != null) 'cartPricing': cartPricing?.toJsonForProtocol(),
      if (basketSuggestions != null)
        'basketSuggestions': basketSuggestions?.toJsonForProtocol(),
      'availableCoupons': availableCoupons.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'deliveryConfig': deliveryConfig.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartHydratedDataImpl extends CartHydratedData {
  _CartHydratedDataImpl({
    _i2.CartPricingResult? cartPricing,
    _i3.BasketSuggestionResult? basketSuggestions,
    required List<_i4.CouponDisplay> availableCoupons,
    required _i5.DeliveryConfig deliveryConfig,
  }) : super._(
         cartPricing: cartPricing,
         basketSuggestions: basketSuggestions,
         availableCoupons: availableCoupons,
         deliveryConfig: deliveryConfig,
       );

  /// Returns a shallow copy of this [CartHydratedData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartHydratedData copyWith({
    Object? cartPricing = _Undefined,
    Object? basketSuggestions = _Undefined,
    List<_i4.CouponDisplay>? availableCoupons,
    _i5.DeliveryConfig? deliveryConfig,
  }) {
    return CartHydratedData(
      cartPricing: cartPricing is _i2.CartPricingResult?
          ? cartPricing
          : this.cartPricing?.copyWith(),
      basketSuggestions: basketSuggestions is _i3.BasketSuggestionResult?
          ? basketSuggestions
          : this.basketSuggestions?.copyWith(),
      availableCoupons:
          availableCoupons ??
          this.availableCoupons.map((e0) => e0.copyWith()).toList(),
      deliveryConfig: deliveryConfig ?? this.deliveryConfig.copyWith(),
    );
  }
}
