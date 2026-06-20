import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/basket_suggestions/basket_suggestion_service.dart';
import '../services/postgres/postgres_coupon_service.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/pricing_engine.dart';

class CartEndpoint extends Endpoint {
  final PostgresCouponService _couponService = PostgresCouponService();

  Future<CartHydratedData> getCartHydratedData(
    Session session,
    List<CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    bool autoApplyCoupons = false,
    String basketMode = 'cart',
  }) async {
    final pricing = await PricingEngine.calculateCartPricing(
      session: session,
      items: items,
      userId: userId,
      appliedCouponCode: appliedCouponCode,
      autoApplyCoupons: autoApplyCoupons,
    );

    final subtotal = pricing.subtotal;

    final futures = <Future>[
      BasketSuggestionService.getSuggestions(
        session: session,
        items: items,
        cartTotal: subtotal,
        mode: basketMode,
        userId: userId,
        appliedCouponCode: appliedCouponCode,
      ),
      DeliveryEngine.getDeliveryConfig(session),
    ];

    if (userId != null && userId.isNotEmpty) {
      futures.add(
        _couponService.getAvailableCoupons(
          session,
          userId: userId,
          cartSubtotal: subtotal,
          cartItems: items,
        ),
      );
    }

    final results = await Future.wait(futures);

    return CartHydratedData(
      cartPricing: pricing,
      basketSuggestions: results[0] as BasketSuggestionResult?,
      deliveryConfig: results[1] as DeliveryConfig,
      availableCoupons: userId != null && userId.isNotEmpty
          ? results[2] as List<CouponDisplay>
          : const <CouponDisplay>[],
    );
  }
}
