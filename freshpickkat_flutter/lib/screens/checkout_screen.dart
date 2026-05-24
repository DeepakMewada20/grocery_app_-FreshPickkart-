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
import 'package:freshpickkat_flutter/screens/order_confirmation_screen.dart';
import 'package:freshpickkat_flutter/screens/location_picker_screen.dart';
import 'package:freshpickkat_flutter/services/checkout_service.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
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
import 'package:get_storage/get_storage.dart';
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
  final orderController = OrderController.instance;
  final checkoutService = CheckoutService.instance;
  final paymentService = PaymentService.instance;
  final orderRecoveryService = OrderRecoveryService.instance;
  final networkController = NetworkController.instance;
  final client = ServerpodClient().client;
  final _trackingRepository = ServerOrderTrackingRepository();

  Razorpay? _razorpay;
  bool _isProcessing = false;
  String? _loadingStatus;
  String? _errorMessage;
  bool _isErrorBanner = true;
  String? _currentOrderId;
  String? _currentRazorpayOrderId;
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
      await _refreshCartWithTimestamp();
      await BannerController.instance.loadBannersForScreen('checkout_page');
      await orderRecoveryService.recoverPendingPayments(
        trigger: 'checkout_open',
      );
    });

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('checkout')) {
          _refreshCartWithTimestamp();
        }
      }
    });
  }

  Future<void> _refreshCartWithTimestamp() async {
    await cartController.refreshCartCurrentData();
    _lastRefreshTime = DateTime.now();
  }

  @override
  void dispose() {
    _razorpay?.clear();
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

  Future<void> _placeOrder() async {
    if (_isProcessing) return;

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
      await _refreshCartWithTimestamp();
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
      _showError('Your basket is empty');
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This address needs a map location. Please pick your location on the map.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
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
      final customerPhone = _getCustomerPhone();
      final customerEmail = userController.userEmail.value.isNotEmpty
          ? userController.userEmail.value
          : '$customerPhone@freshpickkart.com';

      if (customerPhone.isEmpty) {
        _showError(
          'Phone number is required for payment. Please update your profile.',
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
      );

      if (checkoutResult.success != true || checkoutResult.orderId == null) {
        _showError(checkoutResult.error ?? 'Failed to initiate checkout');
        return;
      }

      final orderId = checkoutResult.orderId!;
      final paymentOrder = checkoutResult.paymentOrder;

      _currentOrderId = orderId;
      _currentOrderSnapshot = order.copyWith(orderId: orderId);

      // OPTIMIZATION: Seed tracking metadata in background (no await)
      _seedTrackingMetadata(orderId, order);

      if (paymentOrder == null || paymentOrder.success != true) {
        await paymentService.markPaymentFailed(orderId);
        _showError(paymentOrder?.error ?? 'Payment order failed');
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

      final isTestMode = keyId.startsWith('rzp_test_');

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
        return Align(
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
                padding: EdgeInsets.all(20.r),
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
                          color: AppTheme.primaryGreen.withValues(alpha: 0.14),
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
      'upi_app_package_name': ?upiAppPackageName,
      'notes': {
        'order_id': orderId,
      },
    };

    print('[DEBUG-4] Options: $options');
    print('[DEBUG-4] Calling _razorpay.submit()');
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
    } catch (_) {
      // Best effort only. Tracking metadata must never block checkout.
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
    } catch (_) {
      // Ignore geocoding failures and fall back to no seeded user location.
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
      _showError('Payment response incomplete');
      return;
    }

    print(
      'Payment success: orderId=$orderId, razorpayOrderId=$razorpayOrderId, '
      'paymentId=$paymentId, signature=$signature',
    );

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
        if (mounted) {
          _showInfo(
            'Payment received. Recovery will retry automatically: $e',
          );
        }
      }
    });
  }

  Future<void> _completeSuccessfulPayment(String orderId) async {
    // Clear temporary delivery address after order is placed
    orderController.clearTempDeliveryAddress();

    await Get.offAll(() => OrderConfirmationScreen(orderId: orderId));

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

      final user = authController.currentUser;
      if (user == null) return;
      final idToken = await authController.requireIdToken();
      final order = await client.order.getOrderById(
        orderId,
        user.uid,
        idToken,
      );
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
        setState(() {
          _loadingStatus = 'Finalizing payment status...';
        });
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: AppResponsive.constrainContent(
                    context: context,
                    maxWidth: AppResponsive.maxCheckoutWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🎯 Checkout Page Banner
                        Obx(() {
                          final banners =
                              BannerController.instance.checkoutPageBanners;
                          if (banners.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: NetworkBannerWidget(
                              height: AppResponsive.bannerHeight(
                                context,
                                ratio: 0.30,
                                min: 108,
                                max: 145,
                              ),
                              banners: banners,
                              autoScrollInterval: const Duration(seconds: 5),
                              autoScrollDuration: const Duration(
                                milliseconds: 500,
                              ),
                            ),
                          );
                        }),
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
              ),
              _buildPlaceOrderButton(cs),
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
      final address = userController.shippingAddress.value;
      final tempAddress = orderController.tempDeliveryAddress.value;
      final displayAddress = tempAddress ?? address;

      return Container(
        padding: EdgeInsets.all(20.r),
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
              if (tempAddress != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Temporary Address (This Order Only)',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
    await Get.to(
      () => LocationPickerScreen(
        isCheckoutMode: true,
        initialAddress: initialAddress,
      ),
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
    final individualItems = cartController.regularCartItems
        .where((i) => i.bogoFreeProductId == null)
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
    for (final item in individualItems) {
      totalCount += item.quantity;
    }
    for (final group in comboGroups) {
      for (final item in group.items) {
        totalCount += item.quantity;
      }
    }

    return Container(
      padding: EdgeInsets.all(16.r),
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
        padding: EdgeInsets.all(12.r),
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
        padding: EdgeInsets.all(12.r),
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
      padding: EdgeInsets.all(16.r),
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
            'INR ${cartController.mrpTotal.toStringAsFixed(0)}',
            cs: cs,
          ),
          if (cartController.productDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Product Discount',
              '-INR ${cartController.productDiscountTotal.toStringAsFixed(0)}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.comboDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Combo Savings',
              '-INR ${cartController.comboDiscountTotal.toStringAsFixed(0)}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.bogoDiscountTotal > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'BOGO Savings',
              '-INR ${cartController.bogoDiscountTotal.toStringAsFixed(0)}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          SizedBox(height: 8.h),
          _buildBillRow(
            'Items Total (Combo Applied)',
            'INR ${cartController.subtotal.toStringAsFixed(0)}',
            cs: cs,
          ),
          if (cartController.couponDiscount > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Coupon Discount',
              '-INR ${cartController.couponDiscount.toStringAsFixed(0)}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          SizedBox(height: 8.h),
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
            padding: EdgeInsets.symmetric(vertical: 12.h),
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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: cs.onSurface),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Pay Online (Razorpay) - INR',
              style: TextStyle(color: cs.onSurface),
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 20.r),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54.h.clamp(50.0, 62.0),
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
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
      padding: EdgeInsets.all(12.r),
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
