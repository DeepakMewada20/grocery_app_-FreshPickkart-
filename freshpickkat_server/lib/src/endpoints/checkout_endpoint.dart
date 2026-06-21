import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/basket_suggestions/basket_suggestion_service.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/postgres/postgres_banner_service.dart';
import '../services/postgres/postgres_coupon_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_payment_link_service.dart';
import '../services/pricing/pricing_engine.dart';
import 'order_endpoint.dart';
import 'payment_endpoint.dart';

class CheckoutEndpoint extends Endpoint {
  final _orderEndpoint = OrderEndpoint();
  final _paymentEndpoint = PaymentEndpoint();
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresBannerService _banners = PostgresBannerService();
  final PostgresCouponService _coupons = PostgresCouponService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();

  Future<protocol.CheckoutInitHydrated> getCheckoutInitHydrated(
    Session session,
    List<protocol.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    bool autoApplyCoupons = false,
    String basketMode = 'cart',
    int freshPointsToRedeem = 0,
  }) async {
    final pricing = await PricingEngine.calculateCartPricing(
      session: session,
      items: items,
      userId: userId,
      appliedCouponCode: appliedCouponCode,
      autoApplyCoupons: autoApplyCoupons,
      freshPointsToRedeem: freshPointsToRedeem,
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
      futures.add(
        _coupons.getAvailableCoupons(
          session,
          userId: userId,
          cartSubtotal: subtotal,
          cartItems: items,
        ),
      );
    }

    // Check for existing active pending order
    Future<protocol.PendingOrderInfo?> pendingOrderFuture;
    if (userId != null && userId.isNotEmpty) {
      pendingOrderFuture = _buildPendingOrderInfo(session, userId);
    } else {
      pendingOrderFuture = Future.value(null);
    }
    futures.add(pendingOrderFuture);

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
      activePendingOrder: results[4] as protocol.PendingOrderInfo?,
    );
  }

  Future<protocol.CheckoutResult> createOrderAndPayment(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone, {
    String? pendingOrderAction,
    int freshPointsToRedeem = 0,
  }) async {
    try {
      if (pendingOrderAction == 'continue') {
        return await _handleContinuePayment(
          session,
          order,
          customerPhone,
        );
      }

      final userId = order.userId;

      // If cancel requested, cancel existing pending order first
      if (pendingOrderAction == 'cancel' && userId.isNotEmpty) {
        await _handleCancelThenCreate(session, userId);
      } else if (userId.isNotEmpty) {
        // Normal flow: check for existing pending order
        final existing = await _orders.findActivePendingOrder(session, userId);
        if (existing != null) {
          return protocol.CheckoutResult(
            success: false,
            error: 'ACTIVE_PENDING_ORDER:${existing.orderNumber}',
            orderId: existing.orderNumber,
          );
        }
      }

      // 1. Create order (server calculates all pricing internally)
      final orderId = await _orderEndpoint.createPendingOrder(
        session,
        order,
        idempotencyKey,
        freshPointsToRedeem: freshPointsToRedeem,
      );

      // 2. Get server-calculated payment amount (reduced by FreshPoints)
      final actualPaymentAmount = await _orders.getOrderActualPaymentAmount(
        session,
        orderId,
      );

      // 3. Create payment order with actual amount to collect
      final paymentResult = await _paymentEndpoint.createPaymentOrder(
        session,
        orderId,
        actualPaymentAmount,
        customerPhone,
      );

      if (paymentResult.success != true) {
        return protocol.CheckoutResult(
          success: false,
          error: paymentResult.error ?? 'Failed to create payment order',
          orderId: orderId,
        );
      }

      // Initialize payment session for this order
      await _paymentLinks.initializePaymentSession(session, orderId);

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

  Future<protocol.CheckoutResult> _handleContinuePayment(
    Session session,
    protocol.Order order,
    String customerPhone,
  ) async {
    final userId = order.userId;
    final existing = await _orders.findActivePendingOrder(session, userId);
    if (existing == null) {
      return protocol.CheckoutResult(
        success: false,
        error: 'No active pending order found. Please create a new order.',
      );
    }

    // Disable any existing payment link — prevents stale link payment
    if (existing.linkStatus == 'ACTIVE') {
      await _paymentLinks.disablePaymentLink(session, existing.orderNumber);
    }

    // Create a fresh payment session for the existing pending order
    final amountToCollect = existing.actualPaymentAmount > 0
        ? existing.actualPaymentAmount
        : existing.finalAmount;
    final paymentResult = await _paymentEndpoint.createPaymentOrder(
      session,
      existing.orderNumber,
      amountToCollect,
      customerPhone,
    );

    if (paymentResult.success != true) {
      return protocol.CheckoutResult(
        success: false,
        error: paymentResult.error ?? 'Failed to create payment order',
        orderId: existing.orderNumber,
      );
    }

    // Initialize payment session for existing pending order
    await _paymentLinks.initializePaymentSession(session, existing.orderNumber);

    return protocol.CheckoutResult(
      success: true,
      orderId: existing.orderNumber,
      paymentOrder: paymentResult,
    );
  }

  Future<void> _handleCancelThenCreate(
    Session session,
    String userId,
  ) async {
    final existing = await _orders.findActivePendingOrder(session, userId);
    if (existing != null) {
      await _orders.cancelPendingOrder(
        session,
        existing.orderNumber,
        userId,
        reason: 'Cancelled by user — starting fresh checkout',
      );
    }
  }

  Future<protocol.PendingOrderInfo?> _buildPendingOrderInfo(
    Session session,
    String userId,
  ) async {
    final order = await _orders.findActivePendingOrder(session, userId);
    if (order == null || order.id == null) return null;

    final orderedAt = order.orderedAt;
    final elapsed = DateTime.now().toUtc().difference(orderedAt);
    final remaining = const Duration(minutes: 10) - elapsed;
    final expiresInMinutes = remaining.inMinutes.clamp(0, 10);

    // Fetch order items for cart comparison
    final itemRows = await protocol.OrderItemRow.db.find(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );

    final cartItems = itemRows
        .where((i) => !i.isFreeItem)
        .map(
          (i) => protocol.CartItemSnapshot(
            productId: i.productId.toString(),
            variantId: i.productVariantId?.toString() ?? '',
            quantity: i.quantity,
          ),
        )
        .toList();

    cartItems.sort(
      (a, b) => '${a.productId}_${a.variantId}'.compareTo(
        '${b.productId}_${b.variantId}',
      ),
    );

    return protocol.PendingOrderInfo(
      orderNumber: order.orderNumber,
      finalAmount: order.finalAmount,
      orderedAt: orderedAt,
      expiresInMinutes: expiresInMinutes,
      paymentStatus: order.paymentStatus,
      orderStatus: order.orderStatus,
      linkStatus: order.linkStatus,
      cartData: protocol.CartComparisonData(
        items: cartItems,
        couponId: order.couponId?.toString(),
        discountAmount: order.discountAmount,
        deliveryCharge: order.deliveryFee,
        totalAmount: order.finalAmount,
      ),
    );
  }
}
