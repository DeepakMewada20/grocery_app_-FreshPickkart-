import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:get/get.dart';

class CombinedCardBody extends StatelessWidget {
  final client.BasketSuggestion s;
  final Color accent;

  const CombinedCardBody({super.key, required this.s, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final isBest = s.isBest ?? false;
    final actions = s.actions ?? [];
    final hasCouponOrDelivery = actions.any((a) => a.type == 'coupon' || a.type == 'delivery');
    final comboAction = actions.firstWhereOrNull((a) => a.type == 'combo');

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isBest) ...[
                const BestBadge(),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: SuggestionActionChip(
                  label: 'COMBINED DEAL',
                  color: accent,
                  icon: Icons.auto_awesome_rounded,
                ),
              ),
              const Spacer(),
              if (s.savingAmount != null && s.savingAmount! > 0)
                SaveBadge(amount: s.savingAmount!, accent: accent),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.message,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          
          // Action steps indicators
          Row(
            children: actions.map((a) {
              final isLast = a == actions.last;
              return Row(
                children: [
                   Icon(_getIcon(a.type), size: 12, color: accent.withValues(alpha: 0.7)),
                   if (!isLast) 
                     Container(
                       width: 12,
                       height: 1,
                       margin: const EdgeInsets.symmetric(horizontal: 4),
                       color: accent.withValues(alpha: 0.3),
                     ),
                ],
              );
            }).toList(),
          ),
          
          const Spacer(),


          Row(
            children: [
              if (comboAction != null && comboAction.comboId != null)
                _ComboThumbs(comboId: comboAction.comboId!, s: s)
              else if (s.thumbnailUrl != null)
                _Thumb(url: s.thumbnailUrl!),
              if (hasCouponOrDelivery)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SuggestionProgressBar(
                      current: s.progressCurrent ?? 0,
                      target: s.progressTarget ?? 0,
                      accent: accent,
                    ),
                  ),
                )
              else
                const Spacer(),
              CTAButton(
                label: actions.isNotEmpty ? (actions.first.ctaLabel).toUpperCase() : 'APPLY DEAL',
                accent: accent,
                onTap: () {}, // Handled by parent
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'coupon': return Icons.confirmation_number_rounded;
      case 'delivery': return Icons.local_shipping_rounded;
      case 'variant': return Icons.trending_up_rounded;
      case 'combo': return Icons.layers_rounded;
      case 'bogo': return Icons.card_giftcard_rounded;
      default: return Icons.star_rounded;
    }
  }
}

class _ComboThumbs extends StatelessWidget {
  final String comboId;
  final client.BasketSuggestion s;
  const _ComboThumbs({required this.comboId, required this.s});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final combos = ComboOfferController.instance.activeComboOffers;
      final combo = combos.firstWhereOrNull((c) => c.comboId == comboId);
      if (combo == null) return const SizedBox(width: 40, height: 40);

      final productIds = combo.comboProducts.map((p) => p.productId).toList();
      final products = ProductProviderController.instance.allProducts
          .where((p) => productIds.contains(p.productId))
          .toList();
      
      final urls = products.map((p) => p.imageUrl).whereType<String>().toList();
      if (urls.isEmpty && s.thumbnailUrl != null) {
         urls.add(s.thumbnailUrl!);
      }

      return OverlappingThumbs(imageUrls: urls);
    });
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url, 
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 20),
        ),
      ),
    );
  }
}
