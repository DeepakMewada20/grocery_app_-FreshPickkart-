import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:get/get.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/home');
        return false;
      },
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Order Placed'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.primaryGreen,
                  size: 72,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Successful',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: $orderId',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Amount Paid: INR ${amount.toStringAsFixed(0)}',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => OrderDetailScreen(orderId: orderId));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.onSurface,
                    side: BorderSide(color: cs.outlineVariant),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
