import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:get/get.dart';

class SingleCardBody extends StatelessWidget {
  final client.BasketSuggestion s;
  final Color accent;

  const SingleCardBody({super.key, required this.s, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final isBest = s.isBest ?? false;
    final action = s.actions?.first;
    final type = s.type;

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
              if (action != null)
                Flexible(
                  child: SuggestionActionChip(
                    label: action.label.toUpperCase(),
                    color: accent,
                    icon: _getIcon(action.type),
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
              fontSize: 14,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const Spacer(),

          // ── SPECIFIC UI SECTIONS ──────────────────────────────────────────
          
            
          if (type == 'variant' && s.metadata != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: VariantComparisonView(
                curLabel: s.metadata!['curLabel'] ?? '',
                curPrice: s.metadata!['curPrice'] ?? '',
                vLabel: s.metadata!['vLabel'] ?? '',
                vPrice: s.metadata!['vPrice'] ?? '',
                accent: accent,
              ),
            ),

          Row(
            children: [
              if (type == 'combo' && s.comboId != null)
                _ComboThumbs(comboId: s.comboId!, s: s)
              else if (s.thumbnailUrl != null)
                _Thumb(url: s.thumbnailUrl!),
                
              if (type == 'coupon' || type == 'delivery' || action?.type == 'coupon' || action?.type == 'delivery')
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
                label: (action?.ctaLabel ?? 'View Offer').toUpperCase(),
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
