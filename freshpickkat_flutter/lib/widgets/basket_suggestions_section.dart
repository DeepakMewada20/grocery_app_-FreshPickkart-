import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:get/get.dart';

class BasketSuggestionsSection extends StatelessWidget {
  const BasketSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final suggestions = cartController.basketSuggestions;
      if (suggestions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: suggestions
            .map((suggestion) => _SuggestionCard(suggestion: suggestion, cs: cs))
            .toList(growable: false),
      );
    });
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.cs,
  });

  final BasketSuggestion suggestion;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final progress =
        suggestion.progressTarget != null && suggestion.progressTarget! > 0
        ? (suggestion.progressCurrent! / suggestion.progressTarget!).clamp(0.0, 1.0)
        : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColorForType(suggestion.type, cs)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconForType(suggestion.type), color: _borderColorForType(suggestion.type, cs)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  suggestion.message,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          if (progress != null) ...[
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
            const SizedBox(height: 8),
            Text(
              '₹${(suggestion.progressCurrent ?? 0).formatPrice} / ₹${(suggestion.progressTarget ?? 0).formatPrice}',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.65),
                fontSize: 12,
              ),
            ),
          ],
          if (suggestion.ctaLabel != null &&
              (suggestion.type == 'combo' ||
                  suggestion.type == 'bogo' ||
                  suggestion.type == 'variant')) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => cartController.applyBasketSuggestion(suggestion),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _borderColorForType(suggestion.type, cs),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(suggestion.ctaLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'free_delivery':
        return Icons.local_shipping_outlined;
      case 'coupon':
        return Icons.local_offer_outlined;
      case 'bogo':
        return Icons.card_giftcard_outlined;
      case 'combo':
        return Icons.inventory_2_outlined;
      case 'variant':
        return Icons.trending_up_outlined;
      default:
        return Icons.lightbulb_outline;
    }
  }

  Color _borderColorForType(String type, ColorScheme cs) {
    switch (type) {
      case 'free_delivery':
        return Colors.green;
      case 'coupon':
        return Colors.amber.shade800;
      case 'bogo':
        return Colors.pinkAccent;
      case 'combo':
        return AppTheme.primaryGreen;
      case 'variant':
        return Colors.blueAccent;
      default:
        return cs.outline;
    }
  }
}
