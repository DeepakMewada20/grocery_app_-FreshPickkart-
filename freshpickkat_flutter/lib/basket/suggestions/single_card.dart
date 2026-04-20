import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:get/get.dart';

class SingleCardBody extends StatelessWidget {
  final client.BasketSuggestion s;
  final Color accent;

  const SingleCardBody({super.key, required this.s, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF111111);
    final textSecondary = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFF888888);
    final isBest = s.isBest ?? false;
    final action = s.actions?.first;
    final type = s.type;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
          const SizedBox(height: 8),
          Text(
            s.title ?? s.message,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              height: 1.3,
              letterSpacing: -0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if ((s.subtitle ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              s.subtitle!,
              style: TextStyle(
                color: textSecondary,
                fontSize: 11,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const Spacer(),

          // Variant comparison and other specific UI is now handled in the bottom row to save space

          Row(
            children: [
              if (type == 'combo' && s.comboId != null)
                _ComboThumbs(comboId: s.comboId!, s: s)
              else if (s.thumbnailUrl != null)
                _Thumb(url: s.thumbnailUrl!),
                
              const SizedBox(width: 8),

              // Variant Comparison logic moved here
              if (s.metadata != null && s.metadata!.containsKey('curLabel') && s.metadata!.containsKey('vLabel'))
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: VariantComparisonView(
                      curLabel: s.metadata!['curLabel'] ?? '',
                      curPrice: s.metadata!['curPrice'] ?? '',
                      vLabel: s.metadata!['vLabel'] ?? '',
                      vPrice: s.metadata!['vPrice'] ?? '',
                      accent: accent,
                    ),
                  ),
                )
              else if (type == 'coupon' || type == 'delivery' || action?.type == 'coupon' || action?.type == 'delivery')
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SuggestionProgressBar(
                      current: s.progressCurrent ?? 0,
                      target: s.progressTarget ?? 0,
                      accent: accent,
                    ),
                  ),
                )
              else
                const Spacer(),

              const SizedBox(width: 8),
              CTAButton(
                label: (action?.ctaLabel ?? 'View Offer').toUpperCase(),
                accent: accent,
                onTap: () => CartController.instance.applyBasketSuggestion(s),
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
      case 'reorder': return Icons.replay_rounded;
      case 'category': return Icons.category_rounded;
      case 'product': return Icons.local_offer_rounded;
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
      
      final urls = <String>[];
      
      if (combo != null) {
        final productIds = combo.comboProducts.map((p) => p.productId).toList();
        final products = ProductProviderController.instance.allProducts
            .where((p) => productIds.contains(p.productId))
            .toList();
        urls.addAll(products.map((p) => p.imageUrl).whereType<String>());
      }

      // Fallback to metadata if we have few/no images from loaded products
      if (urls.length < 2) {
        final metaUrls = s.metadata?['comboImageUrls']?.split(',') ?? [];
        for (final url in metaUrls) {
          if (url.isNotEmpty && !urls.contains(url)) {
            urls.add(url);
          }
        }
      }
      
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
        child: SafeNetworkImage(
          url: url, 
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
