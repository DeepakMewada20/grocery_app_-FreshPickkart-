import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/config/payment_config.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cartController = CartController.instance;
  final authController = AuthController.instance;
  final userController = UserController.instance;
  final client = ServerpodClient().client;

  Razorpay? _razorpay;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _currentOrderId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_isProcessing) return;

    if (cartController.cartItems.isEmpty) {
      _showError('Your basket is empty');
      return;
    }

    if (userController.shippingAddress.value == null) {
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

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final order = _buildOrder();
      final orderId = await client.order.createOrder(order);
      _currentOrderId = orderId;

      final paymentOrder = await client.payment.createPaymentOrder(
        orderId,
        cartController.totalAmount,
        _getCustomerPhone(),
      );

      if (paymentOrder.success != true) {
        await client.payment.markPaymentFailed(orderId);
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
        await client.payment.markPaymentFailed(orderId);
        _showError('Invalid payment order response');
        return;
      }

      final amountPaise =
          paymentOrder.amount ?? (cartController.totalAmount * 100).round();
      if (amountPaise <= 0) {
        await client.payment.markPaymentFailed(orderId);
        _showError('Invalid payment amount. Please try again.');
        return;
      }

      // ignore: avoid_print
      print(
        'Razorpay open: orderId=$orderId, razorpayOrderId=$razorpayOrderId, amountPaise=$amountPaise',
      );

      final options = {
        'key': keyId,
        'amount': amountPaise,
        'currency': paymentOrder.currency ?? 'INR',
        'name': 'FreshPickKart',
        'description': 'Order $orderId',
        'order_id': razorpayOrderId,
        'prefill': {
          'contact': _getCustomerPhone(),
        },
        'notes': {
          'order_id': orderId,
        },
      };

      _razorpay?.open(options);
    } catch (e) {
      if (_currentOrderId != null) {
        await client.payment.markPaymentFailed(_currentOrderId!);
      }
      _showError('Failed to start payment: $e');
    }
  }

  Order _buildOrder() {
    final address = userController.shippingAddress.value!;
    final userId = authController.currentUser?.uid ?? '';
    final userName = userController.userName.value;
    final userPhone = _getCustomerPhone();
    final items = cartController.cartItems
        .map(
          (item) => OrderItem(
            productId: item.product.productId ?? '',
            productName: item.product.productName,
            productImage: item.product.imageUrl,
            quantity: item.quantity,
            unitPrice: item.product.price,
            totalPrice: item.product.price * item.quantity,
          ),
        )
        .toList();
    final itemCount = cartController.cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final orderId = _currentOrderId;
      final razorpayOrderId = response.orderId;
      final paymentId = response.paymentId;
      // Test mode mein signature null ho sakta hai, empty string se fallback
      final signature = response.signature ?? '';

      if (orderId == null || razorpayOrderId == null || paymentId == null) {
        _showError('Payment response incomplete');
        return;
      }

      // ignore: avoid_print
      print(
        'Payment success: orderId=$orderId, razorpayOrderId=$razorpayOrderId, '
        'paymentId=$paymentId, signature=$signature',
      );

      final verifyResult = await client.payment
          .verifyPayment(
            orderId,
            razorpayOrderId,
            paymentId,
            signature,
          )
          .timeout(const Duration(seconds: 20));

      if (verifyResult.success == true && verifyResult.verified == true) {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
        cartController.removeCoupon();
        cartController.clearCart();
        Get.offAllNamed('/home');
        Get.to(() => OrderDetailScreen(orderId: orderId));
      } else {
        _showError(verifyResult.message ?? 'Payment verification failed');
      }
    } catch (e) {
      _showError('Payment verification failed: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    try {
      final orderId = _currentOrderId;
      if (orderId != null) {
        await client.payment.markPaymentFailed(orderId);
      }
      final code = response.code?.toString() ?? 'unknown';
      final message = response.message?.trim();
      // ignore: avoid_print
      print('Razorpay payment error ($code): ${message ?? 'unknown error'}');
      _showError(
        message == null || message.isEmpty
            ? 'Payment failed (code: $code). Please try again.'
            : 'Payment failed ($code): $message',
      );
    } catch (e) {
      _showError('Error handling payment failure: $e');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showError('External wallet not supported');
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
          ...cartController.cartItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.product.productName} x${item.quantity}',
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
            );
          }),
        ],
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
    final textColor = cs.onErrorContainer;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: textColor),
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
