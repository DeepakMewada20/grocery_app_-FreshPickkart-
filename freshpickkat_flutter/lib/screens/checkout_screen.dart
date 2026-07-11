import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:freshpickkat_client/freshpickkat_client.dart' hide CartItem;
import 'package:freshpickkat_flutter/config/payment_config.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/screens/order_confirmation_screen.dart'
    deferred as order_confirmation_screen;
import 'package:freshpickkat_flutter/services/checkout_service.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/services/payment_link_service.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/tracking/models/delivery_location.dart';
import 'package:freshpickkat_flutter/tracking/repositories/server_order_tracking_repository.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cartController = CartController.instance;
  final authController = AuthController.instance;
  final userController = UserController.instance;
  final orderController = OrderController.instance;
  final checkoutService = CheckoutService.instance;
  final paymentService = PaymentService.instance;
  final paymentLinkService = PaymentLinkService.instance;
  final orderRecoveryService = OrderRecoveryService.instance;
  final networkController = NetworkController.instance;
  final client = ServerpodClient().client;
  final _trackingRepository = ServerOrderTrackingRepository();

  Razorpay? _razorpay;
  bool _isProcessing = false;
  bool _isShareablePayment = false;
  bool _isCodPayment = false;
  bool _codAvailable = true;
  String? _codDisabledReason;
  String? _loadingStatus;
  String? _errorMessage;
  bool _isErrorBanner = true;
  PendingOrderInfo? _pendingOrderInfo;
  String? _currentOrderId;
  String? _currentRazorpayOrderId;
  String? _activePaymentLink;
  bool _linkPaymentReceived = false;
  bool _isShareSheetOpen = false;
  Timer? _linkCardTimer;
  StreamSubscription<PaymentEvent>? _paymentStreamSub;
  Order? _currentOrderSnapshot;
  DateTime? _lastRefreshTime;
  Future<void>? _refreshFuture;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _refreshFuture = Future.microtask(() async {
      await _refreshCheckoutHydrated();
    });

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('checkout')) {
          _refreshCheckoutHydrated();
        }
      }
    });
  }

  Future<void> _refreshCheckoutHydrated() async {
    try {
      await cartController.revalidateOnly();

      final items = cartController.buildCartItemInputs();
      if (items.isNotEmpty) {
        final hydrated = await client.checkout.getCheckoutInitHydrated(
          items,
          userId: AuthController.instance.currentUser?.uid,
          appliedCouponCode: cartController.appliedCoupon.value?.code,
          autoApplyCoupons: false,
          basketMode: 'cart',
          freshPointsToRedeem: cartController.freshPointsToRedeem.value,
        );
        cartController.applyCartHydratedData(hydrated.cartData);
        BannerController.instance.checkoutPageBanners.assignAll(
          hydrated.checkoutBanners,
        );

        if (mounted) {
          setState(() {
            _codAvailable = hydrated.codAvailable;
            _codDisabledReason = hydrated.codDisabledReason;
            if (!_codAvailable && _isCodPayment) {
              _isCodPayment = false;
            }
          });
        }

        if (hydrated.activePendingOrder != null && mounted) {
          setState(() {
            _pendingOrderInfo = hydrated.activePendingOrder;
          });
        }
      } else {
        cartController.cartPricing.value = null;
        await BannerController.instance.refreshBannersForScreen(
          'checkout_page',
        );
      }

      await orderRecoveryService.recoverPendingPayments(
        trigger: 'checkout_open',
      );
    } catch (e) {
      AppLogger.error('Checkout', 'HydratedInit: $e');
      await cartController.refreshCartCurrentData();
      await BannerController.instance.refreshBannersForScreen('checkout_page');
      await orderRecoveryService.recoverPendingPayments(
        trigger: 'checkout_open',
      );
    }
    _lastRefreshTime = DateTime.now();
  }

  // ── Decision Matrix for Pending Order on Place Order ──

  void _startLinkCardTimer() {
    _linkCardTimer?.cancel();
    _linkCardTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _handleRefresh() async {
    await _refreshCheckoutHydrated();
    if (_pendingOrderInfo == null) return;
    if (_activePaymentLink != null) {
      _startPaymentStream(_pendingOrderInfo!.orderNumber);
    }
    try {
      final user = authController.currentUser;
      if (user == null) return;
      final idToken = await authController.requireIdToken();
      final order = await client.order.getOrderById(
        _pendingOrderInfo!.orderNumber,
        user.uid,
        idToken,
      );
      if (order != null && order.paymentStatus == 'paid' && mounted) {
        _linkCardTimer?.cancel();
        await _completeSuccessfulPayment(_pendingOrderInfo!.orderNumber);
      }
    } catch (_) {}
  }

  bool get _isLinkActive {
    if (_activePaymentLink == null || _linkPaymentReceived) return false;
    if (_pendingOrderInfo == null) return false;
    final expiresAt = _pendingOrderInfo!.orderedAt.add(
      Duration(minutes: _pendingOrderInfo!.expiresInMinutes),
    );
    return !expiresAt.isBefore(DateTime.now());
  }

  bool get _isLinkValidForCurrentCart {
    if (!_isLinkActive) return false;
    if (_pendingOrderInfo?.cartData == null) return false;
    final currentCart = _computeCurrentCartData();
    return _isCartSame(currentCart, _pendingOrderInfo!.cartData!);
  }

  CartComparisonData _computeCurrentCartData() {
    final items = <CartItemSnapshot>[];

    for (final item in cartController.regularCartItems) {
      items.add(
        CartItemSnapshot(
          productId: item.product.productId ?? '',
          variantId: item.variantId ?? '',
          quantity: item.quantity,
        ),
      );
    }

    for (final group in cartController.comboGroups) {
      for (final item in group.items) {
        items.add(
          CartItemSnapshot(
            productId: item.product.productId ?? '',
            variantId: item.variantId ?? '',
            quantity: item.quantity,
          ),
        );
      }
    }

    items.sort(
      (a, b) => '${a.productId}_${a.variantId}'.compareTo(
        '${b.productId}_${b.variantId}',
      ),
    );

    double totalDiscount =
        cartController.couponDiscount +
        cartController.productDiscountTotal +
        cartController.comboDiscountTotal +
        cartController.bogoDiscountTotal;

    return CartComparisonData(
      items: items,
      couponId: cartController.appliedCoupon.value?.code,
      discountAmount: totalDiscount,
      deliveryCharge: cartController.deliveryFee,
      totalAmount: cartController.totalAmount,
    );
  }

  bool _isCartSame(CartComparisonData a, CartComparisonData b) {
    if (a.items.length != b.items.length) return false;
    for (var i = 0; i < a.items.length; i++) {
      if (a.items[i].productId != b.items[i].productId) return false;
      if (a.items[i].variantId != b.items[i].variantId) return false;
      if (a.items[i].quantity != b.items[i].quantity) return false;
    }
    if (a.couponId != b.couponId) return false;
    if (a.discountAmount != b.discountAmount) return false;
    if (a.deliveryCharge != b.deliveryCharge) return false;
    if (a.totalAmount != b.totalAmount) return false;
    return true;
  }

  Future<bool> _showActiveLinkConfirmation() async {
    final cs = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.link_off, color: cs.error, size: 24.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Active Payment Link',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'You have an active payment link. If you proceed with Pay Now, '
          'the existing link will expire and a new payment session will be created.\n\n'
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('EXPIRE & CONTINUE'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _handlePendingOrderOnPlaceOrder() async {
    // COD always creates fresh — no pending payment to continue
    if (_isCodPayment) {
      _pendingOrderInfo = null;
      await _placeOrderCod();
      return;
    }

    final info = _pendingOrderInfo!;
    final pStatus = info.paymentStatus;
    final oStatus = info.orderStatus;

    // FAILED → clear stale info, create fresh
    if (pStatus == 'failed') {
      _pendingOrderInfo = null;
      if (_isShareablePayment) {
        await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
      } else {
        await _placeOrderCore();
      }
      return;
    }

    // EXPIRED / CANCELLED → create fresh (dead order)
    if (pStatus == 'expired' ||
        pStatus == 'cancelled' ||
        oStatus == 'cancelled' ||
        oStatus == 'cancelled_by_user' ||
        oStatus == 'payment_expired') {
      _pendingOrderInfo = null;
      if (_isShareablePayment) {
        await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
      } else {
        await _placeOrderCore();
      }
      return;
    }

    // PENDING — compare cart + age
    final currentCart = _computeCurrentCartData();
    final pendingCart = info.cartData;
    final isSameCart =
        pendingCart != null && _isCartSame(currentCart, pendingCart);
    final isWithinTime =
        DateTime.now().difference(info.orderedAt).inMinutes <=
        (info.expiresInMinutes);

    if (isSameCart && isWithinTime) {
      if (_isShareablePayment) {
        if (info.linkStatus == 'ACTIVE') {
          await _reuseExistingPaymentLink(info.orderNumber);
        } else {
          await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
        }
      } else {
        if (info.linkStatus == 'ACTIVE') {
          final proceed = await _showActiveLinkConfirmation();
          if (proceed) {
            await _placeOrderCore(pendingOrderAction: 'cancel');
          }
        } else {
          await _placeOrderCore(pendingOrderAction: 'continue');
        }
      }
      return;
    }

    // Different cart or too old
    if (info.linkStatus == 'ACTIVE') {
      if (_isShareablePayment) {
        await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
      } else {
        final proceed = await _showActiveLinkConfirmation();
        if (proceed) {
          await _placeOrderCore(pendingOrderAction: 'cancel');
        }
      }
      return;
    }

    // No active link — cancel silently + create new
    if (_isShareablePayment) {
      await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
    } else {
      await _placeOrderCore(pendingOrderAction: 'cancel');
    }
  }

  /// Creates a COD order without any payment gateway interaction.
  Future<void> _placeOrderCod() async {
    if (_isProcessing) return;

    try {
      final deliveryAddress = orderController.getDeliveryAddress(
        userController.shippingAddress.value,
      );

      if (deliveryAddress == null ||
          deliveryAddress.latitude == null ||
          deliveryAddress.longitude == null) {
        _setProcessing(false);
        _openLocationPicker(initialAddress: deliveryAddress);
        if (!mounted) return;
        AppSnackbar.show(
          'Location Needed',
          'Please pick your location on the map.',
        );
        return;
      }

      final customerPhone = _getCustomerPhone();
      if (customerPhone.isEmpty) {
        _showError(ErrorMessages.phoneRequired);
        return;
      }

      final order = _buildOrderFromCart(deliveryAddress);

      _setProcessing(true, status: 'Creating COD order...');

      final checkoutResult = await checkoutService.createCodOrder(
        draftOrder: order,
        freshPointsToRedeem: cartController.freshPointsToRedeem.value,
      );

      if (checkoutResult.success != true || checkoutResult.orderId == null) {
        _showError(checkoutResult.error ?? ErrorMessages.paymentFailed);
        return;
      }

      final orderId = checkoutResult.orderId!;

      _currentOrderId = orderId;
      _currentOrderSnapshot = order.copyWith(orderId: orderId);

      _seedTrackingMetadata(orderId, order);

      await _completeSuccessfulPayment(orderId);
    } catch (e) {
      AppLogger.error('Checkout', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  /// Core order creation + payment flow.
  /// Skips PaymentSessionSheet entirely.
  /// For Pay Now: goes directly to UPI.
  /// For Pay Someone Else: generates payment link + shows share sheet.
  Future<void> _placeOrderCore({String? pendingOrderAction}) async {
    if (_isProcessing) return;

    // COD is handled by _placeOrderCod
    if (_isCodPayment) {
      await _placeOrderCod();
      return;
    }

    try {
      final deliveryAddress = orderController.getDeliveryAddress(
        userController.shippingAddress.value,
      );

      if (deliveryAddress == null ||
          deliveryAddress.latitude == null ||
          deliveryAddress.longitude == null) {
        _setProcessing(false);
        _openLocationPicker(initialAddress: deliveryAddress);
        if (!mounted) return;
        AppSnackbar.show(
          'Location Needed',
          'Please pick your location on the map.',
        );
        return;
      }

      final customerPhone = _getCustomerPhone();
      if (customerPhone.isEmpty) {
        _showError(ErrorMessages.phoneRequired);
        return;
      }

      final keyId = await PaymentConfig.getRazorpayKeyId();
      if (keyId == null || keyId.isEmpty) {
        _showError(ErrorMessages.paymentConfigError);
        return;
      }

      final customerEmail = userController.userEmail.value.isNotEmpty
          ? userController.userEmail.value
          : '$customerPhone@freshpickkart.com';

      final order = _buildOrderFromCart(deliveryAddress);

      _setProcessing(
        true,
        status: pendingOrderAction == 'continue'
            ? 'Resuming payment...'
            : pendingOrderAction == 'cancel'
            ? 'Cancelling & creating new order...'
            : 'Creating order & fetching payment ID...',
      );

      final checkoutResult = await checkoutService.createOrderAndPayment(
        draftOrder: order,
        amount: cartController.totalAmount,
        customerPhone: customerPhone,
        pendingOrderAction: pendingOrderAction,
        freshPointsToRedeem: cartController.freshPointsToRedeem.value,
      );

      if (checkoutResult.success != true || checkoutResult.orderId == null) {
        final error = checkoutResult.error ?? '';
        if (error.startsWith('ACTIVE_PENDING_ORDER:')) {
          _setProcessing(false);
          _showError('An unpaid order already exists. Please try again.');
          return;
        }
        _showError(error.isNotEmpty ? error : ErrorMessages.paymentFailed);
        return;
      }

      final orderId = checkoutResult.orderId!;
      final paymentOrder = checkoutResult.paymentOrder;

      _currentOrderId = orderId;
      _currentOrderSnapshot = order.copyWith(orderId: orderId);
      if (pendingOrderAction == 'continue') {
        // Keep existing _pendingOrderInfo — same order still active
      } else if (mounted) {
        setState(() {
          _pendingOrderInfo = PendingOrderInfo(
            orderNumber: orderId,
            finalAmount: cartController.totalAmount,
            orderedAt: DateTime.now(),
            expiresInMinutes: 10,
            paymentStatus: 'pending',
            orderStatus: 'placed',
            cartData: _computeCurrentCartData(),
          );
        });
      }

      _seedTrackingMetadata(orderId, order);

      if (paymentOrder == null || paymentOrder.success != true) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(paymentOrder?.error ?? ErrorMessages.paymentOrderFailed);
        return;
      }

      final razorpayOrderId = paymentOrder.razorpayOrderId;
      if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(ErrorMessages.paymentResponseIncomplete);
        return;
      }
      _currentRazorpayOrderId = razorpayOrderId;

      final amountPaise =
          paymentOrder.amount ?? (cartController.totalAmount * 100).round();
      if (amountPaise <= 0) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(ErrorMessages.invalidAmount);
        return;
      }

      final isTestMode = keyId.startsWith('rzp_test_');

      _setProcessing(false);

      if (!mounted) return;

      if (_isShareablePayment) {
        await _generateLinkAndShowSheet(orderId);
      } else {
        _setProcessing(true, status: 'Opening payment gateway...');
        final didSelectUpiOption = await _startUpiPaymentFlow(
          isTestMode: isTestMode,
          keyId: keyId,
          amountPaise: amountPaise,
          currency: 'INR',
          razorpayOrderId: razorpayOrderId,
          customerPhone: customerPhone,
          customerEmail: customerEmail,
          orderId: orderId,
        );
        if (!didSelectUpiOption && mounted) {
          _setProcessing(false);
        }
      }
    } catch (e) {
      if (_currentOrderId != null) {
        await _markPaymentFailedBestEffort(_currentOrderId!);
      }
      AppLogger.error('Checkout', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  void _startPaymentStream(String orderId) {
    _stopPaymentStream();
    unawaited(_subscribePaymentStream(orderId));
  }

  Future<void> _subscribePaymentStream(String orderId) async {
    try {
      final user = authController.currentUser;
      if (user == null) return;
      final idToken = await authController.requireIdToken();
      _paymentStreamSub = client.paymentStream
          .watchPaymentStatus(orderId, user.uid, idToken)
          .listen(
            (event) {
              if (event.paymentStatus == 'paid') {
                _linkCardTimer?.cancel();
                if (mounted) setState(() => _linkPaymentReceived = true);
                if (_isShareSheetOpen) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                _completeSuccessfulPayment(orderId);
              }
            },
            onError: (_) {
              // Stream disconnected — will auto-reconnect
            },
            cancelOnError: false,
          );
    } catch (_) {}
  }

  void _stopPaymentStream() {
    _paymentStreamSub?.cancel();
    _paymentStreamSub = null;
  }

  /// Generate a payment link for an existing order and show the share sheet.
  Future<void> _generateLinkAndShowSheet(String orderId) async {
    try {
      final firebaseUid = authController.currentUser?.uid ?? '';
      final idToken = await authController.requireIdToken();
      final result = await paymentLinkService.getOrCreatePaymentLink(
        orderId,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      if (!mounted) return;
      final paymentLink = result['paymentLink'] as String? ?? '';
      _showSharePaymentLinkSheet(paymentLink, orderId);
      _startPaymentStream(orderId);
    } catch (e) {
      AppLogger.error('ShareablePayment', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _linkCardTimer?.cancel();
    _stopPaymentStream();
    super.dispose();
  }

  void _setProcessing(bool value, {bool clearError = false, String? status}) {
    if (!mounted) return;
    setState(() {
      _isProcessing = value;
      _loadingStatus = status;
      if (clearError) {
        _errorMessage = null;
        _isErrorBanner = true;
      }
    });
  }

  Future<void> _markPaymentFailedBestEffort(String orderId) async {
    try {
      await paymentService
          .markPaymentFailed(orderId)
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      AppLogger.warning(
        "Checkout",
        "Unable to mark payment failed: $e",
      );
    }
  }

  Future<void> _placeOrder() async {
    if (_isProcessing) return;

    // Decision matrix for pending order
    if (_pendingOrderInfo != null) {
      await _handlePendingOrderOnPlaceOrder();
      return;
    }

    if (_isShareablePayment) {
      await _placeOrderWithShareableLink(pendingOrderAction: 'cancel');
      return;
    }

    if (_isCodPayment) {
      await _placeOrderCod();
      return;
    }

    // 1. If an initial refresh is still running, wait for it first
    if (_refreshFuture != null) {
      _setProcessing(true, clearError: true, status: 'Finalizing basket...');
      await _refreshFuture;
      _refreshFuture = null; // Clear it once done
    }

    final now = DateTime.now();
    final shouldRefresh =
        _lastRefreshTime == null ||
        now.difference(_lastRefreshTime!).inMinutes >= 3;

    if (shouldRefresh) {
      _setProcessing(true, clearError: true, status: 'Refreshing basket...');
      await cartController.refreshCartCurrentData();
      _lastRefreshTime = DateTime.now();
    } else {
      // If we just finished waiting for _refreshFuture above, we are already "Processing"
      if (!_isProcessing) {
        _setProcessing(true, clearError: true, status: 'Checking basket...');
      } else {
        setState(() {
          _loadingStatus = 'Checking basket...';
        });
      }
    }

    if (cartController.cartItems.isEmpty) {
      _showError(ErrorMessages.emptyCart);
      return;
    }

    // Check if delivery address is available (either saved or temp)
    final deliveryAddress = orderController.getDeliveryAddress(
      userController.shippingAddress.value,
    );

    if (deliveryAddress == null ||
        deliveryAddress.latitude == null ||
        deliveryAddress.longitude == null) {
      _setProcessing(false);
      _openLocationPicker(initialAddress: deliveryAddress);
      // Give the user a hint why the picker opened
      if (!mounted) return;
      AppSnackbar.show(
        'Location Needed',
        'This address needs a map location. Please pick your location on the map.',
      );
      return;
    }

    final keyId = await PaymentConfig.getRazorpayKeyId();
    if (keyId == null || keyId.isEmpty) {
      _showError(
        ErrorMessages.paymentConfigError,
      );
      return;
    }

    try {
      final customerPhone = _getCustomerPhone();
      final customerEmail = userController.userEmail.value.isNotEmpty
          ? userController.userEmail.value
          : '$customerPhone@freshpickkart.com';

      if (customerPhone.isEmpty) {
        _showError(
          ErrorMessages.phoneRequired,
        );
        return;
      }

      // Build order - checkout service will use temp address if available
      final order = _buildOrderFromCart(deliveryAddress);

      _setProcessing(true, status: 'Creating order & fetching payment ID...');

      // CONSOLIDATED CALL: Creates both Order and Payment ID in one network request
      final checkoutResult = await checkoutService.createOrderAndPayment(
        draftOrder: order,
        amount: cartController.totalAmount,
        customerPhone: customerPhone,
        freshPointsToRedeem: cartController.freshPointsToRedeem.value,
      );

      if (checkoutResult.success != true || checkoutResult.orderId == null) {
        final error = checkoutResult.error ?? '';
        if (error.startsWith('ACTIVE_PENDING_ORDER:')) {
          _setProcessing(false);
          _showError('An unpaid order already exists. Please try again.');
          return;
        }
        _showError(error.isNotEmpty ? error : ErrorMessages.paymentFailed);
        return;
      }

      final orderId = checkoutResult.orderId!;
      final paymentOrder = checkoutResult.paymentOrder;

      _currentOrderId = orderId;
      _currentOrderSnapshot = order.copyWith(orderId: orderId);

      // OPTIMIZATION: Seed tracking metadata in background (no await)
      _seedTrackingMetadata(orderId, order);

      if (paymentOrder == null || paymentOrder.success != true) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(paymentOrder?.error ?? ErrorMessages.paymentOrderFailed);
        return;
      }

      final razorpayOrderId = paymentOrder.razorpayOrderId;
      if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(ErrorMessages.paymentResponseIncomplete);
        return;
      }
      _currentRazorpayOrderId = razorpayOrderId;

      final amountPaise =
          paymentOrder.amount ?? (cartController.totalAmount * 100).round();
      if (amountPaise <= 0) {
        await _markPaymentFailedBestEffort(orderId);
        _showError(ErrorMessages.invalidAmount);
        return;
      }

      final isTestMode = keyId.startsWith('rzp_test_');

      _setProcessing(false);

      if (mounted) {
        _setProcessing(true, status: 'Opening payment gateway...');
        final didSelectUpiOption = await _startUpiPaymentFlow(
          isTestMode: isTestMode,
          keyId: keyId,
          amountPaise: amountPaise,
          currency: paymentOrder.currency ?? 'INR',
          razorpayOrderId: razorpayOrderId,
          customerPhone: customerPhone,
          customerEmail: customerEmail,
          orderId: orderId,
        );
        if (!didSelectUpiOption && mounted) {
          _setProcessing(false);
        }
      }
    } catch (e) {
      if (_currentOrderId != null) {
        await _markPaymentFailedBestEffort(_currentOrderId!);
      }
      AppLogger.error('Checkout', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  Future<void> _reuseExistingPaymentLink(String orderNumber) async {
    if (_isProcessing) return;
    _setProcessing(true, status: 'Fetching existing payment link...');
    try {
      final firebaseUid = authController.currentUser?.uid ?? '';
      final idToken = await authController.requireIdToken();
      final result = await paymentLinkService.getOrCreatePaymentLink(
        orderNumber,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      _setProcessing(false);
      if (!mounted) return;
      if (result['success'] == true) {
        final paymentLink = result['paymentLink'] as String? ?? '';
        if (mounted) {
          setState(() {
            _activePaymentLink = paymentLink;
            _linkPaymentReceived = false;
          });
        }
        _startLinkCardTimer();
        _showSharePaymentLinkSheet(paymentLink, orderNumber);
        _startPaymentStream(orderNumber);
      } else {
        _showError(result['error'] as String? ?? 'Failed to get payment link');
      }
    } catch (e) {
      _setProcessing(false);
      AppLogger.error('ReuseLink', e);
      _showError('Failed to get payment link');
    }
  }

  Future<void> _placeOrderWithShareableLink({
    String? pendingOrderAction,
  }) async {
    if (_isProcessing) return;

    try {
      _setProcessing(true, clearError: true, status: 'Creating order...');

      final deliveryAddress = orderController.getDeliveryAddress(
        userController.shippingAddress.value,
      );

      if (deliveryAddress == null ||
          deliveryAddress.latitude == null ||
          deliveryAddress.longitude == null) {
        _setProcessing(false);
        _openLocationPicker(initialAddress: deliveryAddress);
        if (!mounted) return;
        AppSnackbar.show(
          'Location Needed',
          'Please pick your location on the map.',
        );
        return;
      }

      final customerPhone = _getCustomerPhone();
      if (customerPhone.isEmpty) {
        _showError(ErrorMessages.phoneRequired);
        return;
      }

      final order = _buildOrderFromCart(deliveryAddress);
      final idempotencyKey = checkoutService.generateIdempotencyKey(
        authController.currentUser?.uid ?? '',
      );

      _setProcessing(true, status: 'Creating payment link...');

      final firebaseUid = authController.currentUser?.uid ?? '';
      final idToken = await authController.requireIdToken();

      final result = await paymentLinkService.createShareablePaymentLink(
        draftOrder: order,
        idempotencyKey: idempotencyKey,
        amount: cartController.totalAmount,
        customerPhone: customerPhone,
        firebaseUid: firebaseUid,
        idToken: idToken,
        pendingOrderAction: pendingOrderAction,
      );

      if (result.success != true) {
        _showError(result.error ?? 'Failed to create payment link');
        return;
      }

      final paymentLink = result.paymentLink ?? '';
      final orderId = result.orderId ?? '';

      _setProcessing(false);

      if (!mounted) return;

      if (mounted) {
        setState(() {
          _pendingOrderInfo = PendingOrderInfo(
            orderNumber: orderId,
            finalAmount: cartController.totalAmount,
            orderedAt: DateTime.now(),
            expiresInMinutes: 20,
            paymentStatus: 'pending',
            orderStatus: 'placed',
            linkStatus: 'ACTIVE',
            cartData: _computeCurrentCartData(),
          );
          _activePaymentLink = paymentLink;
          _linkPaymentReceived = false;
        });
      }
      _startLinkCardTimer();

      _showSharePaymentLinkSheet(paymentLink, orderId);
      _startPaymentStream(orderId);
    } catch (e) {
      AppLogger.error('ShareablePayment', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  void _showSharePaymentLinkSheet(String paymentLink, String orderId) {
    final amount = cartController.totalAmount;
    final message =
        'Hi,\n\nCan you please complete the payment for my grocery order?\n\n'
        '$paymentLink\n\n'
        'Order amount: ₹${amount.toStringAsFixed(2)}\n'
        'This link expires in 20 minutes.';

    final localExpiresAt = _pendingOrderInfo != null
        ? _pendingOrderInfo!.orderedAt.add(
            Duration(minutes: _pendingOrderInfo!.expiresInMinutes),
          )
        : DateTime.now().add(const Duration(minutes: 20));

    final remainingNotifier = ValueNotifier<Duration>(
      () {
        final diff = localExpiresAt.difference(DateTime.now());
        return diff.isNegative ? Duration.zero : diff;
      }(),
    );

    Timer? timer;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = localExpiresAt.difference(DateTime.now());
      if (diff.isNegative) {
        remainingNotifier.value = Duration.zero;
        timer?.cancel();
      } else {
        remainingNotifier.value = diff;
      }
    });

    var copied = false;
    _isShareSheetOpen = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        var listenerAttached = false;
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: AppResponsive.sheetConstraints(context),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: StatefulBuilder(
                builder: (context, setSheetState) {
                  if (!listenerAttached) {
                    listenerAttached = true;
                    remainingNotifier.addListener(() {
                      if (context.mounted) setSheetState(() {});
                    });
                  }

                  final remaining = remainingNotifier.value;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48.r,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Payment Link Ready',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Share the payment link with someone to complete the payment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '#$orderId',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (remaining.inSeconds > 0)
                        Text(
                          'Expires in ${remaining.inMinutes} min ${remaining.inSeconds.remainder(60)} sec',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: remaining.inMinutes < 2
                                ? Colors.red
                                : Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildShareButton(
                              icon: copied ? Icons.check : Icons.copy,
                              label: copied ? 'Copied!' : 'Copy Link',
                              color: copied
                                  ? AppTheme.primaryGreen
                                  : Colors.grey[700]!,
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: paymentLink),
                                );
                                setSheetState(() {
                                  copied = true;
                                });
                                Future.delayed(const Duration(seconds: 2), () {
                                  setSheetState(() {
                                    copied = false;
                                  });
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildShareButton(
                              icon: Icons.share,
                              label: 'Share',
                              color: AppTheme.primaryGreen,
                              onTap: () {
                                Share.share(
                                  message,
                                  subject: 'Payment for Order #$orderId',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isShareSheetOpen = false;
      timer?.cancel();
      remainingNotifier.dispose();
    });
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28.r),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _startUpiPaymentFlow({
    required bool isTestMode,
    required String keyId,
    required int amountPaise,
    required String currency,
    required String razorpayOrderId,
    required String customerPhone,
    required String customerEmail,
    required String orderId,
  }) {
    if (isTestMode) {
      return _showTestUpiDialog(
        keyId: keyId,
        amountPaise: amountPaise,
        currency: currency,
        razorpayOrderId: razorpayOrderId,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        orderId: orderId,
      );
    }

    return _showUpiAppSelection(
      keyId: keyId,
      amountPaise: amountPaise,
      currency: currency,
      razorpayOrderId: razorpayOrderId,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      orderId: orderId,
    );
  }

  Future<bool> _showTestUpiDialog({
    required String keyId,
    required int amountPaise,
    required String currency,
    required String razorpayOrderId,
    required String customerPhone,
    required String customerEmail,
    required String orderId,
  }) async {
    var selectedVpa = 'success@razorpay';

    final didSubmit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Test UPI Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Razorpay test mode mein UPI Intent redirect supported nahi hota. Test VPA select karein.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedVpa,
                    decoration: const InputDecoration(
                      labelText: 'Test UPI ID',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'success@razorpay',
                        child: Text('Success (success@razorpay)'),
                      ),
                      DropdownMenuItem(
                        value: 'failure@razorpay',
                        child: Text('Failure (failure@razorpay)'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedVpa = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    _submitUpiPayment(
                      keyId: keyId,
                      amountPaise: amountPaise,
                      currency: currency,
                      razorpayOrderId: razorpayOrderId,
                      customerPhone: customerPhone,
                      customerEmail: customerEmail,
                      orderId: orderId,
                      vpa: selectedVpa,
                    );
                  },
                  child: const Text('Pay'),
                ),
              ],
            );
          },
        );
      },
    );

    return didSubmit ?? false;
  }

  Future<bool> _showUpiAppSelection({
    required String keyId,
    required int amountPaise,
    required String currency,
    required String razorpayOrderId,
    required String customerPhone,
    required String customerEmail,
    required String orderId,
  }) async {
    final upiApps = [
      {
        'name': 'PhonePe',
        'packageName': 'com.phonepe.app',
        'icon': Icons.phone_android,
        'color': const Color(0xFF5F259D),
      },
      {
        'name': 'Google Pay',
        'packageName': 'com.google.android.apps.nbu.paisa.user',
        'icon': Icons.g_mobiledata,
        'color': const Color(0xFF4285F4),
      },
      {
        'name': 'Paytm',
        'packageName': 'net.one97.paytm',
        'icon': Icons.payment,
        'color': const Color(0xFF00BAF2),
      },
      {
        'name': 'BHIM',
        'packageName': 'in.org.npci.upiapp',
        'icon': Icons.account_balance,
        'color': const Color(0xFF0079C1),
      },
    ];

    final didSelect = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: AppResponsive.sheetConstraints(context),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Select UPI App',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ...upiApps.map((app) {
                        return ListTile(
                          leading: Container(
                            width: 48.r,
                            height: 48.r,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primaryGreen.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                            ),
                            child: Icon(
                              app['icon'] as IconData,
                              color: AppTheme.primaryGreen,
                              size: 26.r,
                            ),
                          ),
                          title: Text(
                            app['name'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.r,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          onTap: () {
                            Navigator.pop(context, true);
                            _submitUpiPayment(
                              keyId: keyId,
                              amountPaise: amountPaise,
                              currency: currency,
                              razorpayOrderId: razorpayOrderId,
                              customerPhone: customerPhone,
                              customerEmail: customerEmail,
                              orderId: orderId,
                              upiAppPackageName: app['packageName'] as String,
                            );
                          },
                        );
                      }),
                      SizedBox(height: 8.h),
                      ListTile(
                        leading: Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryGreen.withValues(
                                alpha: 0.18,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            color: AppTheme.primaryGreen,
                            size: 26.r,
                          ),
                        ),
                        title: Text(
                          'Enter VPA',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.r,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        onTap: () {
                          Navigator.pop(context, true);
                          _submitUpiPayment(
                            keyId: keyId,
                            amountPaise: amountPaise,
                            currency: currency,
                            razorpayOrderId: razorpayOrderId,
                            customerPhone: customerPhone,
                            customerEmail: customerEmail,
                            orderId: orderId,
                            upiAppPackageName: null,
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    return didSelect ?? false;
  }

  void _submitUpiPayment({
    required String keyId,
    required int amountPaise,
    required String currency,
    required String razorpayOrderId,
    required String customerPhone,
    required String customerEmail,
    required String orderId,
    String? upiAppPackageName,
    String? vpa,
  }) {
    final options = {
      'key': keyId,
      'amount': amountPaise,
      'currency': currency,
      'order_id': razorpayOrderId,
      'contact': customerPhone,
      'email': customerEmail,
      'method': 'upi',
      if (vpa != null && vpa.isNotEmpty) 'vpa': vpa,
      if (vpa == null || vpa.isEmpty) '_[flow]': 'intent',
      'upi_app_package_name': ?upiAppPackageName,
      'notes': {
        'order_id': orderId,
      },
    };

    _razorpay?.submit(options);
  }

  Order _buildOrderFromCart(Address deliveryAddress) {
    final userId = authController.currentUser?.uid ?? '';
    final userName = userController.userName.value;
    final userPhone = _getCustomerPhone();
    final List<OrderItem> items = [];
    final productProvider = Get.find<ProductProviderController>();

    for (final item in cartController.regularCartItems) {
      // Add main product
      items.add(
        OrderItem(
          productId: item.product.productId ?? '',
          variantId: item.variantId,
          variantLabel: productFullQuantityLabel(item.product),
          productName: item.product.productName,
          productImage: item.product.imageUrl,
          quantity: item.quantity,
          unitPrice: item.product.price,
          totalPrice: item.product.price * item.quantity,
          isFreeItem: false,
          isFreeDelivery: item.product.isFreeDelivery,
        ),
      );

      // Add BOGO free item if selected
      if (item.bogoFreeProductId != null) {
        final freeProduct = productProvider.allProducts.firstWhereOrNull(
          (p) => p.productId == item.bogoFreeProductId,
        );

        if (freeProduct != null) {
          final freeLabel = BogoController.instance.freeProductQuantityLabel(
            item.product.productId ?? '',
            freeProduct.productId ?? '',
            fallback: productFullQuantityLabel(freeProduct),
          );
          final offer = BogoController.instance.getOfferForProduct(
            item.product.productId ?? '',
          );
          final reward = offer == null
              ? null
              : findBogoReward(offer, freeProductId: freeProduct.productId!);
          final freeQuantity = offer == null || reward == null
              ? item.quantity
              : calculateBogoFreeQuantity(
                  offer: offer,
                  reward: reward,
                  triggerQuantity: item.quantity,
                );
          items.add(
            OrderItem(
              productId: freeProduct.productId!,
              variantId: reward?.variantId,
              variantLabel: freeLabel,
              productName: freeProduct.productName,
              productImage: freeProduct.imageUrl,
              quantity: freeQuantity <= 0 ? 1 : freeQuantity,
              unitPrice: 0,
              totalPrice: 0,
              isFreeItem: true,
              isFreeDelivery: false,
              triggerProductId: item.product.productId,
            ),
          );
        }
      }
    }

    // Add SMGM free items
    final smgmFreeItems =
        (cartController.cartPricing.value?.freeItems ?? [])
            .where((item) => item.rewardSource == 'SHOP_MORE_GET_MORE')
            .toList();
    for (final freeItem in smgmFreeItems) {
      items.add(
        OrderItem(
          productId: freeItem.productId,
          variantId: freeItem.variantId,
          productName: freeItem.productName,
          productImage: '',
          quantity: freeItem.quantity,
          unitPrice: 0,
          totalPrice: 0,
          isFreeItem: true,
          isFreeDelivery: false,
          isRewardProduct: true,
          quantityEditable: false,
          priceEditable: false,
          originalUnitPrice: freeItem.originalUnitPrice ?? freeItem.rewardValue,
          rewardValue: freeItem.rewardValue,
          rewardOfferId: freeItem.rewardOfferId,
          rewardOfferName: freeItem.rewardOfferName,
          rewardThreshold: freeItem.rewardThreshold,
          rewardSource: freeItem.rewardSource,
        ),
      );
    }

    for (final group in cartController.comboGroups) {
      for (final item in group.items) {
        items.add(
          OrderItem(
            productId: item.product.productId ?? '',
            variantId: item.variantId,
            variantLabel: productFullQuantityLabel(item.product),
            productName: item.product.productName,
            productImage: item.product.imageUrl,
            quantity: item.quantity,
            unitPrice: item.product.price,
            totalPrice: item.product.price * item.quantity,
            isFreeItem: false,
            isFreeDelivery: item.product.isFreeDelivery,
            comboId: item.comboId,
            comboName: item.comboName,
            comboDiscountType: item.comboDiscountType,
            comboDiscountValue: item.comboDiscountValue,
            comboItemQuantity: item.comboItemQuantity,
          ),
        );
      }
    }

    final itemCount = items.fold(
      0,
      (sum, i) => sum + i.quantity,
    );

    return Order(
      orderId: '',
      userId: userId,
      userName: userName.isEmpty ? null : userName,
      userPhone: userPhone,
      items: items,
      itemCount: itemCount,
      totalAmount: cartController.subtotal,
      discountAmount: cartController.couponDiscount,
      mrpTotal: cartController.mrpTotal,
      productDiscountAmount: cartController.productDiscountTotal,
      comboDiscountAmount: cartController.comboDiscountTotal,
      bogoDiscountAmount: cartController.bogoDiscountTotal,
      deliveryFee: cartController.deliveryFee,
      originalDeliveryFee: cartController.originalDeliveryFee,
      deliveryDiscountAmount: cartController.deliveryDiscountAmount,
      freeDeliveryApplied: cartController.freeDeliveryApplied,
      finalAmount: cartController.totalAmount,
      status: 'placed',
      paymentStatus: 'pending',
      refundStatus: 'none',
      deliveryAddress: deliveryAddress,
      orderedAt: DateTime.now(),
      orderType: 'regular',
      sourceOrderNumber: null,
      complaintId: null,
      couponApplied: cartController.appliedCoupon.value?.code,
      freshPointsUsed: cartController.freshPointsToRedeem.value,
      freshPointsValue: cartController.cartPricing.value?.freshPointsDiscount ?? 0.0,
      actualPaymentAmount: cartController.totalAmount,
    );
  }

  String _getCustomerPhone() {
    final phone = userController.userPhone.value;
    if (phone.isNotEmpty) return phone;
    return authController.currentUser?.phoneNumber ?? '';
  }

  Future<void> _seedTrackingMetadata(String orderId, Order order) async {
    try {
      final userLocation = await _buildUserLocation(order.deliveryAddress);
      await _trackingRepository.seedOrderTrackingMetadata(
        orderId: orderId,
        status: 'placed',
        trackingEnabled: false,
        userLocation: userLocation,
      );
    } catch (e) {
      AppLogger.warning('Checkout', 'Tracking seed failed: $e');
    }
  }

  Future<DeliveryLocation?> _buildUserLocation(Address address) async {
    final type = GetStorage().read<String>('delivery_location_type') ?? 'saved';
    final formattedAddress = _formatAddress(address);
    final lat = address.latitude;
    final lng = address.longitude;

    if (lat != null && lng != null) {
      return DeliveryLocation(
        lat: lat,
        lng: lng,
        address: formattedAddress,
        type: type,
      );
    }

    try {
      final results = await geocoding.locationFromAddress(formattedAddress);
      if (results.isNotEmpty) {
        final location = results.first;
        return DeliveryLocation(
          lat: location.latitude,
          lng: location.longitude,
          address: formattedAddress,
          type: type,
        );
      }
    } catch (e) {
      AppLogger.warning('Checkout', 'Geocoding failed: $e');
    }

    return null;
  }

  String _formatAddress(Address address) {
    final parts = [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((p) => p.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  void _handlePaymentSuccess(Map<dynamic, dynamic> response) {
    final orderId = _currentOrderId;
    final payload = response['data'] is Map
        ? response['data'] as Map
        : response;
    final razorpayOrderId = payload['razorpay_order_id'] as String?;
    final paymentId = payload['razorpay_payment_id'] as String?;
    final signature = payload['razorpay_signature'] as String? ?? '';

    if (orderId == null || razorpayOrderId == null || paymentId == null) {
      _showError(ErrorMessages.paymentResponseIncomplete);
      return;
    }

    setState(() {
      _loadingStatus = 'Verifying payment...';
    });

    Future(() async {
      try {
        final result = await paymentService
            .completeOrder(
              userId: authController.currentUser?.uid ?? '',
              orderId: orderId,
              paymentId: paymentId,
              razorpayOrderId: razorpayOrderId,
              signature: signature,
              amount:
                  _currentOrderSnapshot?.finalAmount ??
                  cartController.totalAmount,
            )
            .timeout(const Duration(seconds: 20));

        if (result) {
          setState(() {
            _loadingStatus = 'Confirming order...';
          });
          await _completeSuccessfulPayment(orderId);
        } else {
          Future(() async {
            await orderRecoveryService.recoverPendingPayments(
              trigger: 'payment_success',
            );
          });
          if (mounted) {
            _showInfo(
              'Payment received. We are finalizing your order automatically.',
            );
          }
        }
      } catch (e) {
        AppLogger.error('Checkout', e);
        if (mounted) {
          _showInfo(
            'Payment received. Recovery will retry automatically.',
          );
        }
      }
    });
  }

  Future<void> _completeSuccessfulPayment(String orderId) async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      await order_confirmation_screen.loadLibrary();
      Get.back();
      Get.offAll(
        () =>
            order_confirmation_screen.OrderConfirmationScreen(orderId: orderId),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Unable to load this feature. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    cartController.removeCoupon();
    cartController.clearCart();
  }

  Future<bool> _tryResolvePendingUpiPayment({
    required String orderId,
    required String paymentId,
    int attempts = 6,
    Duration retryDelay = const Duration(seconds: 3),
  }) async {
    final razorpayOrderId = _currentRazorpayOrderId;
    if (razorpayOrderId == null || razorpayOrderId.isEmpty) return false;

    if (mounted) {
      setState(() {
        _isProcessing = true;
        _errorMessage = 'Verifying payment status...';
        _isErrorBanner = false;
      });
    }

    for (var attempt = 0; attempt < attempts; attempt++) {
      final user = authController.currentUser;
      if (user == null) return false;
      final idToken = await authController.requireIdToken();
      final statusResult = await client.payment
          .getPaymentStatus(paymentId, orderId, user.uid, idToken)
          .timeout(const Duration(seconds: 15));
      final paymentStatus = statusResult.status?.toLowerCase().trim();

      if (statusResult.success == true &&
          (paymentStatus == 'authorized' || paymentStatus == 'captured')) {
        final verifyResult = await client.payment
            .verifyPayment(orderId, razorpayOrderId, paymentId, '')
            .timeout(const Duration(seconds: 20));
        if (verifyResult.success == true && verifyResult.verified == true) {
          await _completeSuccessfulPayment(orderId);
          return true;
        }
      }

      final order = await client.order.getOrderById(
        orderId,
        user.uid,
        idToken,
      );
      final orderPaymentStatus = order?.paymentStatus.toLowerCase().trim();
      if (orderPaymentStatus == 'paid') {
        await _completeSuccessfulPayment(orderId);
        return true;
      }

      if (attempt < attempts - 1) {
        await Future.delayed(retryDelay);
      }
    }

    return false;
  }

  Map<String, dynamic>? _extractRazorpayError(Map<dynamic, dynamic> response) {
    final data = response['data'];
    if (data is Map) {
      final message = data['message'];
      if (message is Map) {
        final error = message['error'];
        if (error is Map<String, dynamic>) return error;
        if (error is Map) return Map<String, dynamic>.from(error);
      }
      if (message is String && message.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(message);
          if (decoded is Map && decoded['error'] is Map) {
            return Map<String, dynamic>.from(decoded['error'] as Map);
          }
        } catch (e) {
          AppLogger.warning('Checkout', 'Error decode: $e');
        }
      }
    }
    return null;
  }

  void _handlePaymentError(Map<dynamic, dynamic> response) async {
    try {
      final orderId = _currentOrderId;
      final errorData = _extractRazorpayError(response);
      final metadata = errorData?['metadata'];
      final paymentId = metadata is Map
          ? metadata['payment_id']?.toString()
          : null;
      final code =
          errorData?['reason']?.toString() ??
          errorData?['code']?.toString() ??
          response['code']?.toString() ??
          response['error_code']?.toString() ??
          'unknown';
      final message =
          errorData?['description']?.toString().trim() ??
          response['message']?.toString().trim() ??
          response['description']?.toString().trim() ??
          '';
      final normalizedCode = code.toLowerCase().trim();
      final normalizedMessage = message.toLowerCase();
      final isPaymentCancelled =
          normalizedCode == 'payment_cancelled' ||
          normalizedCode == '2' ||
          normalizedMessage.contains('payment cancelled') ||
          normalizedMessage.contains('payment canceled') ||
          normalizedMessage.contains('cancelled by user');

      if (orderId != null && paymentId != null && paymentId.isNotEmpty) {
        if (mounted) {
          setState(() {
            _loadingStatus = 'Finalizing payment status...';
          });
        }
        final resolved = await _tryResolvePendingUpiPayment(
          orderId: orderId,
          paymentId: paymentId,
          attempts: isPaymentCancelled ? 1 : 20,
        );
        if (resolved) {
          return;
        }
      }

      if (orderId != null) {
        await _markPaymentFailedBestEffort(orderId);
        if (mounted && _pendingOrderInfo?.orderNumber == orderId) {
          final existing = _pendingOrderInfo!;
          setState(() {
            _pendingOrderInfo = PendingOrderInfo(
              orderNumber: existing.orderNumber,
              finalAmount: existing.finalAmount,
              orderedAt: existing.orderedAt,
              expiresInMinutes: existing.expiresInMinutes,
              paymentStatus: 'failed',
              orderStatus: existing.orderStatus,
              linkStatus: existing.linkStatus,
              cartData: existing.cartData,
            );
            _activePaymentLink = null;
            _linkCardTimer?.cancel();
          });
        }
      }

      if (isPaymentCancelled) {
        _showError('Payment cancelled. Please try again.');
        AppLogger.warning('Checkout', 'Payment cancelled by user');
        return;
      }

      _showError(
        message.isEmpty
            ? ErrorMessages.paymentFailed
            : ErrorMessages.paymentError(message),
      );
      AppLogger.error(
        "Checkout",
        "Payment error code=$code msg=$message",
      );
    } catch (e) {
      AppLogger.error('Checkout', e);
      _showError(ErrorMessages.paymentFailed);
    }
  }

  void _showError(String message) {
    final safeMessage = message.trim().isEmpty
        ? 'Payment failed. Please try again.'
        : message;
    AppLogger.error('Checkout', safeMessage);
    if (mounted) {
      setState(() {
        _errorMessage = safeMessage;
        _isErrorBanner = true;
        _isProcessing = false;
        _loadingStatus = null;
      });
    }
  }

  void _showInfo(String message) {
    final safeMessage = message.trim().isEmpty
        ? 'Please wait while we verify your payment.'
        : message;
    if (mounted) {
      setState(() {
        _errorMessage = safeMessage;
        _isErrorBanner = false;
        _isProcessing = false;
        _loadingStatus = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_isProcessing,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // User tried to pop while processing, we can show a snackbar here if desired.
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: cs.onSurface,
          elevation: 0,
        ),
        body: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return _buildEmptyState(cs);
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 16.r),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // 🎯 Checkout Page Banner - full width
                        Obx(() {
                          final banners =
                              BannerController.instance.checkoutPageBanners;
                          if (banners.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: NetworkBannerWidget(
                              height: AppResponsive.bannerHeight(
                                context,
                                ratio: 0.42,
                                min: 110,
                                max: 160,
                              ),
                              banners: banners,
                              autoScrollInterval: const Duration(seconds: 5),
                              autoScrollDuration: const Duration(
                                milliseconds: 500,
                              ),
                            ),
                          );
                        }),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: AppResponsive.constrainContent(
                            context: context,
                            maxWidth: AppResponsive.maxCheckoutWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAddressSection(cs),
                                SizedBox(height: 16.h),
                                _buildItemsSection(cs),
                                SizedBox(height: 16.h),
                                _buildBillDetails(cs),
                                SizedBox(height: 16.h),
                                _buildPaymentSection(cs),
                                if (_errorMessage != null) ...[
                                  SizedBox(height: 16.h),
                                  _buildErrorBanner(cs),
                                ],
                                SizedBox(height: 80.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: _buildPlaceOrderButton(cs),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Your basket is empty',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to continue checkout',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(ColorScheme cs) {
    return Obx(() {
      final displayAddress = userController.shippingAddress.value;

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Delivery Address',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle(context).copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                if (displayAddress != null)
                  SizedBox(
                    height: 35.h.clamp(32.0, 42.0),
                    child: _buildAddressButton(
                      cs,
                      icon: Icons.my_location,
                      label: 'Change',
                      onPressed: () =>
                          _openLocationPicker(initialAddress: null),
                      compact: true,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayAddress == null) ...[
              Text(
                'No address selected. Please add delivery address.',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
              ),
              SizedBox(height: 16.h),
              _buildAddressButton(
                cs,
                icon: Icons.my_location,
                label: 'Use Current Location',
                onPressed: () => _openLocationPicker(initialAddress: null),
              ),
            ] else ...[
              if (displayAddress.latitude == null ||
                  displayAddress.longitude == null)
                Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.amber.shade700,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'Location coordinates missing for this address. Please update it on the map for accurate delivery.',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            _openLocationPicker(initialAddress: displayAddress),
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userController.userName.value.isEmpty
                              ? 'Customer'
                              : userController.userName.value,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _getCustomerPhone(),
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.7),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: cs.onSurface.withValues(alpha: 0.6),
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _formatAddress(displayAddress),
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildAddressButton(
    ColorScheme cs, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool compact = false,
  }) {
    if (compact) {
      return Container(
        margin: EdgeInsets.only(left: 12.w),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18.r),
          label: Text(
            label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            side: BorderSide(
              color: cs.primary.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Future<void> _openLocationPicker({required Address? initialAddress}) async {
    await Get.toNamed(
      '/location-picker',
      arguments: {
        'isCheckoutMode': true,
        'initialAddress': initialAddress,
      },
    );
  }

  // String _formatAddress(Address address) {
  //   final parts = [
  //     address.street,
  //     address.city,
  //     address.state,
  //     address.zipCode,
  //     address.country,
  //   ].where((p) => p.trim().isNotEmpty).toList();
  //   return parts.join(', ');
  // }

  Widget _buildItemsSection(ColorScheme cs) {
    final bogoItems = cartController.regularCartItems
        .where((i) => i.bogoFreeProductId != null)
        .toList();
    final allIndividualItems = cartController.regularCartItems
        .where((i) => i.bogoFreeProductId == null)
        .toList();
    final freeDeliveryItems = allIndividualItems
        .where((i) => i.product.isFreeDelivery)
        .toList();
    final individualItems = allIndividualItems
        .where((i) => !i.product.isFreeDelivery)
        .toList();
    final comboGroups = cartController.comboGroups;
    final bogoController = BogoController.instance;

    int totalCount = 0;
    for (final item in bogoItems) {
      totalCount += item.quantity;
      final offer = bogoController.getOfferForProduct(
        item.product.productId ?? '',
      );
      if (offer != null && item.bogoFreeProductId != null) {
        final reward = findBogoReward(
          offer,
          freeProductId: item.bogoFreeProductId!,
        );
        if (reward != null) {
          totalCount += calculateBogoFreeQuantity(
            offer: offer,
            reward: reward,
            triggerQuantity: item.quantity,
          );
        }
      }
    }
    for (final item in allIndividualItems) {
      totalCount += item.quantity;
    }
    for (final group in comboGroups) {
      for (final item in group.items) {
        totalCount += item.quantity;
      }
    }

    final smgmFreeItems =
        (cartController.cartPricing.value?.freeItems ?? [])
            .where((item) => item.rewardSource == 'SHOP_MORE_GET_MORE')
            .toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          if (bogoItems.isNotEmpty) ...[
            _buildSectionLabel('BOGO Offers', cs),
            SizedBox(height: 8.h),
            ...bogoItems.map(
              (item) => _buildBogoCheckoutCard(item, cs),
            ),
            SizedBox(height: 12.h),
          ],
          if (smgmFreeItems.isNotEmpty) ...[
            _buildSectionLabel('Free Gifts', cs),
            SizedBox(height: 8.h),
            ...smgmFreeItems.map(
              (item) => _buildSmgmCheckoutItem(item, cs),
            ),
            SizedBox(height: 12.h),
          ],
          if (freeDeliveryItems.isNotEmpty) ...[
            _buildSectionLabel('Free Delivery', cs),
            SizedBox(height: 8.h),
            ...freeDeliveryItems.map(
              (item) => _buildIndividualCheckoutItem(item, cs),
            ),
            SizedBox(height: 12.h),
          ],
          if (comboGroups.isNotEmpty) ...[
            _buildSectionLabel('Combo Offers', cs),
            SizedBox(height: 8.h),
            ...comboGroups.map(
              (group) => _buildComboCheckoutGroup(group, cs),
            ),
            SizedBox(height: 12.h),
          ],
          if (individualItems.isNotEmpty) ...[
            _buildSectionLabel('Individual Items', cs),
            SizedBox(height: 8.h),
            ...individualItems.map(
              (item) => _buildIndividualCheckoutItem(item, cs),
            ),
            SizedBox(height: 12.h),
          ],
          _buildTotalItemCount(totalCount, cs),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, ColorScheme cs, {Color? badgeColor}) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: badgeColor ?? cs.onSurface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBogoCheckoutCard(
    CartItem item,
    ColorScheme cs,
  ) {
    final productProvider = Get.find<ProductProviderController>();
    final freeProduct = item.bogoFreeProductId == null
        ? null
        : productProvider.allProducts.firstWhereOrNull(
            (p) => p.productId == item.bogoFreeProductId,
          );
    final freeLabel = freeProduct != null
        ? BogoController.instance.freeProductQuantityLabel(
            item.product.productId ?? '',
            freeProduct.productId ?? '',
            fallback: productFullQuantityLabel(freeProduct),
          )
        : null;
    final offer = BogoController.instance.getOfferForProduct(
      item.product.productId ?? '',
    );
    final reward = freeProduct != null && offer != null
        ? findBogoReward(offer, freeProductId: freeProduct.productId!)
        : null;
    final freeQuantity = reward != null
        ? calculateBogoFreeQuantity(
            offer: offer!,
            reward: reward,
            triggerQuantity: item.quantity,
          )
        : item.quantity;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.product.productName} (${productFullQuantityLabel(item.product)}) x${item.quantity}',
                    style: TextStyle(color: cs.onSurface, fontSize: 13.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '₹${(item.product.price * item.quantity).formatPrice}',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            if (freeProduct != null) ...[
              SizedBox(height: 8.h),
              Divider(color: cs.outlineVariant, height: 1),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            '${freeProduct.productName} ($freeLabel) x$freeQuantity',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 13.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '₹0',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualCheckoutItem(CartItem item, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item.product.productName} (${productFullQuantityLabel(item.product)}) x${item.quantity}',
              style: TextStyle(color: cs.onSurface, fontSize: 13.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '₹${(item.product.price * item.quantity).formatPrice}',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmgmCheckoutItem(FreeItemInfo item, ColorScheme cs) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'FREE',
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.productName} x${item.quantity}',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.rewardOfferName != null &&
                    item.rewardOfferName!.isNotEmpty)
                  Text(
                    'Unlocked via ${item.rewardOfferName}',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ),
          if (item.rewardValue != null && item.rewardValue! > 0)
            Text(
              '₹${item.rewardValue!.formatPrice}',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalItemCount(int totalCount, ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total items',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          Text(
            '$totalCount',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboCheckoutGroup(ComboCartGroup group, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  comboDiscountBadgeText(
                    group.discountType,
                    group.discountValue,
                  ),
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...group.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.productName} (${productFullQuantityLabel(item.product)}) x${item.quantity}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: 13.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '₹${(item.product.price * item.quantity).formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.75),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Combo total x${group.bundleQuantity}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${group.discountedTotal.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      '₹${group.originalTotal.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.45),
                        fontSize: 12.sp,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetails(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          _buildBillRow(
            'MRP Total',
            '₹${cartController.mrpTotal.formatPrice}',
            cs: cs,
          ),
          if (cartController.productDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Product Discount',
              '₹${cartController.productDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.comboDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Combo Savings',
              '₹${cartController.comboDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.bogoDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'BOGO Savings',
              '₹${cartController.bogoDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.freeGiftSavings > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Free Gift Savings',
              '₹${cartController.freeGiftSavings.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.categoryOfferDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Category Offer Savings',
              '₹${cartController.categoryOfferDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          SizedBox(height: 8.h),
          _buildBillRow(
            'Items Total (Combo Applied)',
            '₹${cartController.subtotal.formatPrice}',
            cs: cs,
          ),
          if (cartController.couponDiscount > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Coupon Discount',
              '₹${cartController.couponDiscount.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if ((cartController.cartPricing.value?.freshPointsDiscount ?? 0) > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'FreshPoints (${cartController.cartPricing.value?.freshPointsRedeemed ?? 0} pts)',
              '₹${(cartController.cartPricing.value?.freshPointsDiscount ?? 0.0).formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          SizedBox(height: 8.h),
          _buildBillRow(
            'Delivery Fee',
            cartController.deliveryFee == 0
                ? (cartController.freeDeliveryApplied &&
                          cartController.originalDeliveryFee > 0
                      ? '₹${cartController.originalDeliveryFee.formatPrice} -> FREE'
                      : 'FREE')
                : '₹${cartController.deliveryFee.formatPrice}',
            valueColor: cartController.deliveryFee == 0
                ? Colors.green
                : cs.onSurface,
            cs: cs,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: cs.outlineVariant),
          ),
          _buildBillRow(
            'To Pay',
            '₹${cartController.totalAmount.formatPrice}',
            isTotal: true,
            cs: cs,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
    required ColorScheme cs,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.receiptLabel(context, total: isTotal),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: AutoSizeText(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.receiptValue(
              context,
              total: isTotal,
              color: valueColor ?? cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection(ColorScheme cs) {
    final linkValid = _isLinkValidForCurrentCart;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, color: cs.onSurface),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Payment Method',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildPaymentOptionTile(
            cs: cs,
            icon: Icons.person,
            title: 'Pay Now',
            subtitle: 'Pay using UPI, Cards, Net Banking',
            isSelected: !_isShareablePayment && !_isCodPayment,
            onTap: () => setState(() {
              _isShareablePayment = false;
              _isCodPayment = false;
            }),
          ),
          SizedBox(height: 8.h),
          _buildPaymentOptionTile(
            cs: cs,
            icon: Icons.money,
            title: 'Cash on Delivery',
            subtitle: _codAvailable
                ? 'Pay when you receive your order'
                : 'Temporarily unavailable',
            isSelected: _isCodPayment,
            onTap: _codAvailable
                ? () => setState(() {
                      _isCodPayment = true;
                      _isShareablePayment = false;
                    })
                : null,
          ),
          if (!_codAvailable) ...[
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Text(
                'Cash on Delivery is temporarily unavailable for your account '
                'due to multiple previous delivery refusals.\n\n'
                'Complete a successful prepaid order to restore Cash on '
                'Delivery access.',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
          SizedBox(height: 8.h),
          _buildPaymentOptionTile(
            cs: cs,
            icon: Icons.share,
            title: 'Ask Someone Else To Pay',
            subtitle: 'Share a payment link via WhatsApp, SMS, etc.',
            isSelected: linkValid ? true : _isShareablePayment,
            onTap: linkValid
                ? null
                : () => setState(() {
                    _isShareablePayment = true;
                    _isCodPayment = false;
                  }),
            isDisabled: linkValid,
          ),
          if (_activePaymentLink != null) ...[
            SizedBox(height: 12.h),
            _buildLinkStatusCard(cs),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkStatusCard(ColorScheme cs) {
    final expiresAt = _pendingOrderInfo != null
        ? _pendingOrderInfo!.orderedAt.add(
            Duration(minutes: _pendingOrderInfo!.expiresInMinutes),
          )
        : DateTime.now().add(const Duration(minutes: 20));
    final remaining = expiresAt.difference(DateTime.now());
    final expired = remaining.isNegative;
    final statusColor = _linkPaymentReceived
        ? cs.primary
        : expired
        ? cs.error
        : cs.primary;
    final bgColor = statusColor.withValues(alpha: 0.1);
    final borderColor = statusColor.withValues(alpha: 0.3);
    final textColor = statusColor.withValues(alpha: 0.85);
    final message = _pendingOrderInfo != null
        ? 'Hi,\n\nCan you please complete the payment for my grocery order?\n\n'
              '$_activePaymentLink\n\n'
              'Order amount: ₹${_pendingOrderInfo!.finalAmount.toStringAsFixed(2)}\n'
              'This link expires in 20 minutes.'
        : '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _linkPaymentReceived
                    ? Icons.check_circle
                    : expired
                    ? Icons.timer_off
                    : Icons.timer_outlined,
                color: statusColor,
                size: 24.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _linkPaymentReceived
                          ? 'Payment Received!'
                          : expired
                          ? 'Link Expired'
                          : 'Payment Link Active',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    if (!_linkPaymentReceived && !expired)
                      Text(
                        'Expires in ${remaining.inMinutes} min ${remaining.inSeconds.remainder(60)} sec',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (!expired && !_linkPaymentReceived && message.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: _activePaymentLink ?? ''),
                      );
                      AppSnackbar.show(
                        'Link Copied',
                        'Payment link copied to clipboard',
                      );
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy, color: statusColor, size: 16.r),
                          SizedBox(width: 6.w),
                          Text(
                            'Copy Link',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final orderId = _pendingOrderInfo?.orderNumber ?? '';
                      Share.share(
                        message,
                        subject: 'Payment for Order #$orderId',
                      );
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: statusColor, size: 16.r),
                          SizedBox(width: 6.w),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required ColorScheme cs,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    final effectiveOnTap = isDisabled ? null : onTap;
    final textColor = isDisabled
        ? cs.onSurface.withValues(alpha: 0.35)
        : cs.onSurface;
    final accentColor = isDisabled
        ? cs.onSurface.withValues(alpha: 0.35)
        : AppTheme.primaryGreen;
    return InkWell(
      onTap: effectiveOnTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accentColor : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? accentColor.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? accentColor : textColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDisabled
                          ? cs.onSurface.withValues(alpha: 0.3)
                          : cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? accentColor : textColor,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(ColorScheme cs) {
    final disablePlaceOrder = _isLinkValidForCurrentCart && _isShareablePayment;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54.h.clamp(50.0, 62.0),
        child: ElevatedButton(
          onPressed: (_isProcessing || disablePlaceOrder) ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: disablePlaceOrder
                ? cs.onSurface.withValues(alpha: 0.12)
                : AppTheme.primaryGreen,
            foregroundColor: cs.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: _isProcessing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: AutoSizeText(
                        _loadingStatus ?? 'Processing...',
                        maxLines: 1,
                        minFontSize: 11,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  disablePlaceOrder ? 'LINK ACTIVE' : 'PLACE ORDER',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ColorScheme cs) {
    final backgroundColor = _isErrorBanner
        ? cs.errorContainer
        : cs.surfaceContainerHighest;
    final borderColor = _isErrorBanner ? cs.error : cs.outlineVariant;
    final textColor = _isErrorBanner ? cs.onErrorContainer : cs.onSurface;
    final icon = _isErrorBanner ? Icons.error_outline : Icons.info_outline;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _errorMessage ?? '',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
