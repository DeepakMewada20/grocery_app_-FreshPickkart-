import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_support.dart';
import 'delivery_engine.dart';

class DeliveryChargeCalculator {
  static Future<DeliveryPricingResult> calculate({
    required Session session,
    required double cartTotal,
    String? userId,
    String? location,
    List<CartItemInput>? cartItems,
  }) async {
    final normalPricing = await DeliveryEngine.calculate(
      session: session,
      cartTotal: cartTotal,
      userId: userId,
      location: location,
    );

    final hasPromotionalFreeDelivery = await _hasPromotionalFreeDelivery(
      session,
      cartItems ?? const <CartItemInput>[],
    );
    if (!hasPromotionalFreeDelivery || normalPricing.deliveryFee <= 0) {
      return normalPricing;
    }

    return DeliveryPricingResult(
      deliveryFee: 0,
      isFree: true,
      message: 'FREE Delivery unlocked',
      remainingAmount: 0,
      progressPercent: 100,
      appliedRuleType: 'product_category_free_delivery',
      appliedRuleName: 'Product Free Delivery',
      freeDeliveryThreshold: normalPricing.freeDeliveryThreshold,
      baseDeliveryFee: normalPricing.deliveryFee,
    );
  }

  static Future<bool> _hasPromotionalFreeDelivery(
    Session session,
    List<CartItemInput> cartItems,
  ) async {
    final productIds = cartItems
        .map((item) => tryParseUuid(item.productId))
        .whereType<UuidValue>()
        .toSet();
    if (productIds.isEmpty) return false;

    final products = await ProductRow.db.find(
      session,
      where: (t) => t.id.inSet(productIds) & t.status.equals('active'),
    );
    if (products.isEmpty) return false;
    return products.any((product) => product.isFreeDelivery);
  }
}
