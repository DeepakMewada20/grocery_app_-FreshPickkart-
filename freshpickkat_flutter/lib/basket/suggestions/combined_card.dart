import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
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
    final actions = (s.actions ?? []).take(3).toList(growable: false);
    final hasCouponOrDelivery = actions.any((a) {
      final kind = _actionKind(a);
      return kind == 'coupon' || kind == 'delivery';
    });
    final comboAction = actions.firstWhereOrNull(
      (a) => _actionKind(a) == 'combo',
    );

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
            s.title ?? s.message,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if ((s.subtitle ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              s.subtitle!,
              style: TextStyle(
                color: textPrimary.withValues(alpha: 0.7),
                fontSize: 11.5,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),

          // Action steps indicators
          Row(
            children: actions.map((a) {
              final isLast = a == actions.last;
              return Row(
                children: [
                  Icon(
                    _getIcon(a),
                    size: 12,
                    color: accent.withValues(alpha: 0.7),
                  ),
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
                label: actions.length > 1
                    ? 'APPLY ALL'
                    : (actions.isNotEmpty
                          ? actions.first.ctaLabel.toUpperCase()
                          : 'APPLY DEAL'),
                accent: accent,
                onTap: () => CartController.instance.applyBasketSuggestion(s),
              ),
            ],
          ),
        ],
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
    if (action.type == 'reorder') {
      return 'reorder';
    }
    if (action.type == 'category') {
      return 'category';
    }
    if (action.type == 'product' ||
        action.type == 'add_to_cart' ||
        action.productId != null) {
      return 'product';
    }
    return action.type;
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
      case 'reorder':
        return Icons.replay_rounded;
      case 'category':
        return Icons.category_rounded;
      case 'product':
        return Icons.local_offer_rounded;
      default:
        return Icons.star_rounded;
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
