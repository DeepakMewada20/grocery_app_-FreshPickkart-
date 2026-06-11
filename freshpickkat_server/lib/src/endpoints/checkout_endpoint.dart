import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/basket_suggestions/basket_suggestion_service.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/postgres/postgres_banner_service.dart';
import '../services/postgres/postgres_coupon_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/pricing_engine.dart';
import 'order_endpoint.dart';
import 'payment_endpoint.dart';

class CheckoutEndpoint extends Endpoint {
  final _orderEndpoint = OrderEndpoint();
  final _paymentEndpoint = PaymentEndpoint();
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresBannerService _banners = PostgresBannerService();
  final PostgresCouponService _coupons = PostgresCouponService();

  Future<protocol.CheckoutInitHydrated> getCheckoutInitHydrated(
    Session session,
    List<protocol.CartItemInput> items, {
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
      _banners.getBanners(session, screen: 'checkout_page', activeOnly: true),
    ];

    if (userId != null && userId.isNotEmpty) {
      futures.add(_coupons.getAvailableCoupons(
        session,
        userId: userId,
        cartSubtotal: subtotal,
        cartItems: items,
      ));
    }

    final results = await Future.wait(futures);

    return protocol.CheckoutInitHydrated(
      cartData: protocol.CartHydratedData(
        cartPricing: pricing,
        basketSuggestions: results[0] as protocol.BasketSuggestionResult?,
        deliveryConfig: results[1] as protocol.DeliveryConfig,
        availableCoupons: userId != null && userId.isNotEmpty
            ? results[3] as List<protocol.CouponDisplay>
            : const <protocol.CouponDisplay>[],
      ),
      checkoutBanners: results[2] as List<protocol.Banner>,
    );
  }

  Future<protocol.CheckoutResult> createOrderAndPayment(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) async {
    try {
      // 1. Create order (server calculates all pricing internally)
      final orderId = await _orderEndpoint.createPendingOrder(
        session,
        order,
        idempotencyKey,
      );

      // 2. Get server-calculated final amount (ignore client-provided amount)
      final serverFinalAmount = await _orders.getOrderFinalAmount(
        session,
        orderId,
      );

      // 3. Create payment order with server-calculated amount
      final paymentResult = await _paymentEndpoint.createPaymentOrder(
        session,
        orderId,
        serverFinalAmount,
        customerPhone,
      );

      if (paymentResult.success != true) {
        return protocol.CheckoutResult(
          success: false,
          error: paymentResult.error ?? 'Failed to create payment order',
          orderId: orderId,
        );
      }

      return protocol.CheckoutResult(
        success: true,
        orderId: orderId,
        paymentOrder: paymentResult,
      );
    } catch (e) {
      return protocol.CheckoutResult(
        success: false,
        error: e.toString(),
      );
    }
  }
}
