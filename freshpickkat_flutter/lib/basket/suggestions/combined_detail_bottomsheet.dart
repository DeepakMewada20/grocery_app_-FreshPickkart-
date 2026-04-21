import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:get/get.dart';

class CombinedDetailBottomSheet extends StatelessWidget {
  final client.BasketSuggestion suggestion;

  const CombinedDetailBottomSheet({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actions = (suggestion.actions ?? []).take(3).toList(growable: false);

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.82,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Combined Deal Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${actions.length} step${actions.length == 1 ? '' : 's'} to stack this deal',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...actions.asMap().entries.map((entry) {
                        final i = entry.key;
                        final action = entry.value;
                        final isLast = i == actions.length - 1;

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: AppTheme.primaryGreen.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        action.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _stepDescription(action),
                                        style: TextStyle(
                                          color: cs.onSurface.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      ),
                                      if ((action.extraSpend ?? 0) > 0 ||
                                          (action.benefit ?? 0) > 0) ...[
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            if ((action.extraSpend ?? 0) > 0)
                                              _InfoPill(
                                                label:
                                                    'Spend ₹${action.extraSpend!.formatPrice}',
                                              ),
                                            if ((action.benefit ?? 0) > 0)
                                              _InfoPill(
                                                label:
                                                    'Save ₹${action.benefit!.formatPrice}',
                                              ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              Icon(
                                _getIcon(action),
                                size: 18,
                                color: cs.onSurface.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Stat(
                              label: 'Extra Spend',
                              value:
                                  '₹${suggestion.extraSpend?.formatPrice ?? "0"}',
                              color: cs.onSurface,
                            ),
                            _Stat(
                              label: 'Total Benefit',
                              value:
                                  '₹${((suggestion.netProfit ?? 0) + (suggestion.extraSpend ?? 0)).formatPrice}',
                              color: AppTheme.primaryGreen,
                            ),
                            _Stat(
                              label: 'Net Profit',
                              value:
                                  '₹${(suggestion.netProfit ?? 0).formatPrice}',
                              color: const Color(0xFFE6A23C),
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    CartController.instance.applyBasketSuggestion(suggestion);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply All Steps',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _actionKind(client.BasketSuggestionAction action) {
    if (action.type == 'coupon' ||
        action.type == 'apply_coupon' ||
        action.couponCode != null) {
      return 'coupon';
    }
    if (action.type == 'combo' || action.comboId != null) {
      return 'combo';
    }
    if (action.type == 'bogo') {
      return 'bogo';
    }
    if (action.type == 'delivery') {
      return 'delivery';
    }
    if (action.type == 'variant') {
      return 'variant';
    }
    if (action.type == 'product' ||
        action.type == 'add_to_cart' ||
        action.productId != null) {
      return 'product';
    }
    return action.type;
  }

  String _stepDescription(client.BasketSuggestionAction action) {
    switch (_actionKind(action)) {
      case 'coupon':
        final code = action.couponCode;
        return code == null || code.trim().isEmpty
            ? 'Apply the coupon after cart updates to stack extra savings.'
            : 'Apply $code after the cart updates to unlock extra savings.';
      case 'delivery':
        return (action.extraSpend ?? 0) > 0
            ? 'This stack also pushes the basket toward lower delivery charges.'
            : 'Delivery savings are already included in this stack.';
      case 'variant':
        return 'Switch to the better-value pack before checkout.';
      case 'combo':
        return 'Add the combo bundle to activate its offer pricing.';
      case 'bogo':
        return (action.extraSpend ?? 0) > 0
            ? 'Add the trigger product first, then choose your free item.'
            : 'Choose your free item from the active BOGO offer.';
      case 'product':
        return 'Add the product required for this stacked deal.';
      default:
        return action.ctaLabel;
    }
  }

  IconData _getIcon(client.BasketSuggestionAction action) {
    switch (_actionKind(action)) {
      case 'coupon':
        return Icons.confirmation_number_rounded;
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'variant':
        return Icons.trending_up_rounded;
      case 'combo':
        return Icons.layers_rounded;
      case 'bogo':
        return Icons.card_giftcard_rounded;
      case 'product':
        return Icons.local_offer_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _InfoPill extends StatelessWidget {
  final String label;

  const _InfoPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          color: cs.onSurface.withValues(alpha: 0.72),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
