import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:get/get.dart';

class DeliveryProgressCard extends StatelessWidget {
  const DeliveryProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final deliveryPricing =
          cartController.cartPricing.value?.deliveryPricing ??
          cartController.localDeliveryPricing.value;
      if (deliveryPricing == null) return const SizedBox.shrink();

      final progress = ((deliveryPricing.progressPercent ?? 0) / 100).clamp(
        0.0,
        1.0,
      );
      final showProgress =
          deliveryPricing.freeDeliveryThreshold != null &&
          deliveryPricing.freeDeliveryThreshold! > 0 &&
          (deliveryPricing.progressPercent ?? 0) > 0 &&
          (deliveryPricing.progressPercent ?? 0) < 100;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
              deliveryPricing.isFree
                  ? 'Delivery: FREE'
                  : 'Delivery: ₹${deliveryPricing.deliveryFee.formatPrice}',
              style: TextStyle(
                color: cartController.deliveryFee == 0
                    ? Colors.green
                    : cs.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (deliveryPricing.message != null &&
                deliveryPricing.message!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                deliveryPricing.message!,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
              ),
            ],
            if (showProgress) ...[
              const SizedBox(height: 12),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: cs.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 0.8 ? Colors.orange : AppTheme.primaryGreen,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      );
    });
  }
}
