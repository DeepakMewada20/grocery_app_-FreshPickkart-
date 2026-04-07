import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' hide CartItem;
import 'package:freshpickkat_flutter/config/payment_config.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/screens/order_confirmation_screen.dart';
import 'package:freshpickkat_flutter/services/checkout_service.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cartController = CartController.instance;
  final authController = AuthController.instance;
  final userController = UserController.instance;
  final checkoutService = CheckoutService.instance;
  final paymentService = PaymentService.instance;
  final orderRecoveryService = OrderRecoveryService.instance;
  final client = ServerpodClient().client;

  Razorpay? _razorpay;
  bool _isProcessing = false;
  String? _errorMessage;
  bool _isErrorBanner = true;
  String? _currentOrderId;
  String? _currentRazorpayOrderId;
  Order? _currentOrderSnapshot;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    Future.microtask(() async {
      await cartController.refreshCartCurrentData();
      await orderRecoveryService.recoverPendingPayments(
        trigger: 'checkout_open',
      );
    });
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  void _setProcessing(bool value, {bool clearError = false}) {
    if (!mounted) return;
    setState(() {
      _isProcessing = value;
      if (clearError) {
        _errorMessage = null;
        _isErrorBanner = true;
      }
    });
  }

  Future<void> _placeOrder() async {
    if (_isProcessing) return;

    _setProcessing(true, clearError: true);

    await cartController.refreshCartCurrentData();

    if (cartController.cartItems.isEmpty) {
      _showError('Your basket is empty');
      return;
    }

    if (userController.shippingAddress.value == null) {
      _setProcessing(false);
      _goToAddress();
      return;
    }

    final keyId = await PaymentConfig.getRazorpayKeyId();
    if (keyId == null || keyId.isEmpty) {
      _showError(
        'Missing Razorpay key. Configure RAZORPAY_KEY_ID or the cloud function.',
      );
      return;
    }

    try {
      final order = _buildOrder();
      final checkoutSession = await checkoutService.createPendingOrder(
        draftOrder: order,
      );
      final orderId = checkoutSession.orderId;
      _currentOrderId = orderId;
      _currentOrderSnapshot = order.copyWith(orderId: orderId);

      final paymentOrder = await paymentService.startPayment(
        orderId: orderId,
        amount: cartController.totalAmount,
        customerPhone: _getCustomerPhone(),
      );

      if (paymentOrder.success != true) {
        await paymentService.markPaymentFailed(orderId);
        final error = paymentOrder.error ?? 'Payment order failed';
        final details = paymentOrder.details;
        _showError(
          details != null && details.toString().trim().isNotEmpty
              ? '$error: $details'
              : error,
        );
        return;
      }

      final razorpayOrderId = paymentOrder.razorpayOrderId;
      if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
        await paymentService.markPaymentFailed(orderId);
        _showError('Invalid payment order response');
        return;
      }
      _currentRazorpayOrderId = razorpayOrderId;

      final amountPaise =
          paymentOrder.amount ?? (cartController.totalAmount * 100).round();
      if (amountPaise <= 0) {
        await paymentService.markPaymentFailed(orderId);
        _showError('Invalid payment amount. Please try again.');
        return;
      }

      final customerPhone = _getCustomerPhone();
      final customerEmail = userController.userEmail.value.isNotEmpty
          ? userController.userEmail.value
          : '$customerPhone@freshpickkart.com';

      print('[DEBUG-1] customerPhone: "$customerPhone"');
      print('[DEBUG-1] customerEmail: "$customerEmail"');

      if (customerPhone.isEmpty) {
        await paymentService.markPaymentFailed(orderId);
        _showError(
          'Phone number is required for payment. Please update your profile.',
        );
        return;
      }

      final isTestMode = keyId.startsWith('rzp_test_');

      print(
        '[DEBUG-2] Starting UPI flow (${isTestMode ? 'test' : 'live'})',
      );
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
    } catch (e) {
      print('[DEBUG-ERROR] _placeOrder exception: $e');
      if (_currentOrderId != null) {
        await paymentService.markPaymentFailed(_currentOrderId!);
      }
      _showError('Failed to start payment: $e');
    }
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
                    value: selectedVpa,
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
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select UPI App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ...upiApps.map((app) {
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(
                      app['icon'] as IconData,
                      color: AppTheme.primaryGreen,
                      size: 26,
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
                    size: 16,
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
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppTheme.primaryGreen,
                    size: 26,
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
                  size: 16,
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
              const SizedBox(height: 16),
            ],
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
    print('[DEBUG-3] _submitUpiPayment called');
    print('[DEBUG-3] upiAppPackageName: $upiAppPackageName');
    print('[DEBUG-3] vpa: $vpa');
    print('[DEBUG-3] keyId: $keyId');
    print('[DEBUG-3] amountPaise: $amountPaise');
    print('[DEBUG-3] razorpayOrderId: $razorpayOrderId');

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
      if (upiAppPackageName != null) 'upi_app_package_name': upiAppPackageName,
      'notes': {
        'order_id': orderId,
      },
    };

    print('[DEBUG-4] Options: $options');
    print('[DEBUG-4] Calling _razorpay.submit()');
    _razorpay?.submit(options);
  }

  Order _buildOrder() {
    final address = userController.shippingAddress.value!;
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
        ),
      );

      // Add BOGO free item if selected
      if (item.bogoFreeProductId != null) {
        final freeProduct = productProvider.allProducts.firstWhereOrNull(
          (p) => p.productId == item.bogoFreeProductId,
        );

        if (freeProduct != null) {
          items.add(
            OrderItem(
              productId: freeProduct.productId!,
              variantLabel: productFullQuantityLabel(freeProduct),
              productName: freeProduct.productName,
              productImage: freeProduct.imageUrl,
              quantity: item.quantity, // 1 free for every 1 trigger
              unitPrice: 0,
              totalPrice: 0,
              isFreeItem: true,
              triggerProductId: item.product.productId,
            ),
          );
        }
      }
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
      deliveryFee: cartController.deliveryFee,
      finalAmount: cartController.totalAmount,
      status: 'pending',
      paymentStatus: 'pending',
      refundStatus: 'none',
      deliveryAddress: address,
      orderedAt: DateTime.now(),
      couponApplied: cartController.appliedCoupon.value?.code,
    );
  }

  String _getCustomerPhone() {
    final phone = userController.userPhone.value;
    if (phone.isNotEmpty) return phone;
    return authController.currentUser?.phoneNumber ?? '';
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
      _showError('Payment response incomplete');
      return;
    }

    print(
      'Payment success: orderId=$orderId, razorpayOrderId=$razorpayOrderId, '
      'paymentId=$paymentId, signature=$signature',
    );

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

        if (result.isConfirmed) {
          await _completeSuccessfulPayment(orderId);
        } else if (result.isQueuedForRecovery) {
          Future(() async {
            await orderRecoveryService.recoverPendingPayments(
              trigger: 'payment_success',
            );
          });
          if (mounted) {
            _showInfo(
              result.message ??
                  'Payment received. We are finalizing your order automatically.',
            );
          }
        } else {
          _showError(result.message ?? 'Payment verification failed');
        }
      } catch (e) {
        if (mounted) {
          _showInfo(
            'Payment received. Recovery will retry automatically: $e',
          );
        }
      }
    });
  }

  Future<void> _completeSuccessfulPayment(String orderId) async {
    Get.offAll(() => OrderConfirmationScreen(orderId: orderId));

    cartController.removeCoupon();
    cartController.clearCart();
  }

  Future<bool> _tryResolvePendingUpiPayment({
    required String orderId,
    required String paymentId,
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

    for (var attempt = 0; attempt < 6; attempt++) {
      final statusResult = await client.payment
          .getPaymentStatus(paymentId)
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

      final order = await client.order.getOrderById(orderId);
      final orderPaymentStatus = order?.paymentStatus.toLowerCase().trim();
      if (orderPaymentStatus == 'paid') {
        await _completeSuccessfulPayment(orderId);
        return true;
      }

      if (attempt < 5) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }

    return false;
  }

  Future<void> _watchPendingPaymentResolution({
    required String orderId,
    required String paymentId,
  }) async {
    for (var attempt = 0; attempt < 10; attempt++) {
      if (!mounted) return;

      final resolved = await _tryResolvePendingUpiPayment(
        orderId: orderId,
        paymentId: paymentId,
      );
      if (resolved) {
        return;
      }

      final order = await client.order.getOrderById(orderId);
      final orderPaymentStatus = order?.paymentStatus.toLowerCase().trim();
      if (orderPaymentStatus == 'failed') {
        _showError('Payment failed. Please try again.');
        return;
      }

      if (attempt < 9) {
        await Future.delayed(const Duration(seconds: 4));
      }
    }

    _showInfo(
      'Payment status is still syncing. If money was debited, please check Orders in a moment.',
    );
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
        } catch (_) {}
      }
    }
    return null;
  }

  void _handlePaymentError(Map<dynamic, dynamic> response) async {
    try {
      print('=== PAYMENT ERROR FULL RESPONSE ===');
      print(response.toString());
      print('===================================');

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

      if (orderId != null && paymentId != null && paymentId.isNotEmpty) {
        final resolved = await _tryResolvePendingUpiPayment(
          orderId: orderId,
          paymentId: paymentId,
        );
        if (resolved) {
          return;
        }

        if (code == 'payment_cancelled') {
          _showInfo(
            'Payment status is syncing. Please wait while we confirm it.',
          );
          Future(() async {
            await _watchPendingPaymentResolution(
              orderId: orderId,
              paymentId: paymentId,
            );
          });
          return;
        }
      }

      if (orderId != null) {
        await paymentService.markPaymentFailed(orderId);
      }
      print(
        'Razorpay payment error ($code): ${message.isEmpty ? 'unknown error' : message}',
      );
      _showError(
        message.isEmpty
            ? 'Payment failed (code: $code). Please try again.'
            : 'Payment failed ($code): $message',
      );
    } catch (e) {
      _showError('Error handling payment failure: $e');
    }
  }

  void _goToAddress() {
    authController.returnRoute.value = '/checkout';
    Get.toNamed('/address');
  }

  void _showError(String message) {
    final safeMessage = message.trim().isEmpty
        ? 'Payment failed. Please try again.'
        : message;
    // Keep a console log for easier debugging.
    // ignore: avoid_print
    print('Checkout error: $safeMessage');
    if (mounted) {
      setState(() {
        _errorMessage = safeMessage;
        _isErrorBanner = true;
        _isProcessing = false;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎯 Checkout Page Banner
                    Obx(() {
                      final banners =
                          BannerController.instance.checkoutPageBanners;
                      if (banners.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NetworkBannerWidget(
                          height: 120,
                          banners: banners,
                          autoScrollInterval: const Duration(seconds: 5),
                          autoScrollDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    }),
                    _buildAddressSection(cs),
                    const SizedBox(height: 16),
                    _buildItemsSection(cs),
                    const SizedBox(height: 16),
                    _buildBillDetails(cs),
                    const SizedBox(height: 16),
                    _buildPaymentSection(cs),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorBanner(cs),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _buildPlaceOrderButton(cs),
          ],
        );
      }),
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
    final address = userController.shippingAddress.value;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: _goToAddress,
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (address == null)
            Text(
              'No address found. Please add delivery address.',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userController.userName.value.isEmpty
                      ? 'Customer'
                      : userController.userName.value,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCustomerPhone(),
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatAddress(address),
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.8)),
                ),
              ],
            ),
        ],
      ),
    );
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

  Widget _buildItemsSection(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...cartController.regularCartItems.map(
            (item) => _buildRegularCheckoutItem(item, cs),
          ),
          ...cartController.comboGroups.map(
            (group) => _buildComboCheckoutGroup(group, cs),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularCheckoutItem(CartItem item, ColorScheme cs) {
    final productProvider = Get.find<ProductProviderController>();
    final freeProduct = item.bogoFreeProductId == null
        ? null
        : productProvider.allProducts.firstWhereOrNull(
            (p) => p.productId == item.bogoFreeProductId,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.product.productName} (${productFullQuantityLabel(item.product)}) x${item.quantity}',
                  style: TextStyle(color: cs.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'INR ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (freeProduct != null) ...[
            const SizedBox(height: 4),
            Text(
              'FREE: ${freeProduct.productName} (${productFullQuantityLabel(freeProduct)}) x${item.quantity}',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComboCheckoutGroup(ComboCartGroup group, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  comboDiscountBadgeText(
                    group.discountType,
                    group.discountValue,
                  ),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...group.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.productName} (${productFullQuantityLabel(item.product)}) x${item.quantity}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'INR ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Combo total x${group.bundleQuantity}',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'INR ${group.discountedTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'INR ${group.originalTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.45),
                        fontSize: 12,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _buildBillRow(
            'Item Total',
            'INR ${cartController.subtotal.toStringAsFixed(0)}',
            cs: cs,
          ),
          if (cartController.couponDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              'Coupon Discount',
              '-INR ${cartController.couponDiscount.toStringAsFixed(0)}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          const SizedBox(height: 8),
          _buildBillRow(
            'Delivery Fee',
            cartController.deliveryFee == 0
                ? 'FREE'
                : 'INR ${cartController.deliveryFee.toStringAsFixed(0)}',
            valueColor: cartController.deliveryFee == 0
                ? Colors.green
                : cs.onSurface,
            cs: cs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: cs.outlineVariant),
          ),
          _buildBillRow(
            'To Pay',
            'INR ${cartController.totalAmount.toStringAsFixed(0)}',
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
        Text(
          label,
          style: TextStyle(
            color: isTotal ? cs.onSurface : cs.onSurface.withValues(alpha: 0.6),
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? cs.onSurface,
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: cs.onSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pay Online (Razorpay) - INR',
              style: TextStyle(color: cs.onSurface),
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: cs.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'PLACE ORDER',
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
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
