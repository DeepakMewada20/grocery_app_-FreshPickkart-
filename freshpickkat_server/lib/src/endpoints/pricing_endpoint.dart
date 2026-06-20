import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/pricing_engine.dart';
import '../services/basket_suggestions/basket_suggestion_service.dart';
import '../services/delivery/delivery_engine.dart';

class PricingEndpoint extends Endpoint {
  Future<CartPricingResult> calculateCartPricing(
    Session session,
    List<CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    bool autoApplyCoupons = true,
  }) async {
    final cartItems = items
        .map(
          (item) => CartItemInput(
            productId: item.productId,
            variantId: item.variantId,
            quantity: item.quantity,
            comboId: item.comboId,
            bogoFreeProductId: item.bogoFreeProductId,
          ),
        )
        .toList();

    return await PricingEngine.calculateCartPricing(
      session: session,
      items: cartItems,
      userId: userId,
      appliedCouponCode: appliedCouponCode,
      autoApplyCoupons: autoApplyCoupons,
    );
  }

  Future<List<AppliedOfferInfo>> getApplicableOffers(
    Session session,
    List<CartItemInput> items,
  ) async {
    final result = await calculateCartPricing(
      session,
      items,
      appliedCouponCode: null,
      autoApplyCoupons: false,
    );
    return result.appliedOffers;
  }

  Future<BasketSuggestionResult> basketSuggestions(
    Session session,
    List<CartItemInput>? items, {
    double? cartTotal,
    String mode = 'cart',
    String? userId,
    String? appliedCouponCode,
  }) async {
    return BasketSuggestionService.getSuggestions(
      session: session,
      items: items,
      cartTotal: cartTotal,
      mode: mode,
      userId: userId,
      appliedCouponCode: appliedCouponCode,
    );
  }

  Future<double> calculateDeliveryFee(
    Session session,
    double orderAmount,
    int itemCount,
    String? couponCode,
    String? userId,
  ) async {
    final result = await DeliveryEngine.calculate(
      session: session,
      cartTotal: orderAmount,
      userId: userId,
    );
    return result.deliveryFee;
  }
}
