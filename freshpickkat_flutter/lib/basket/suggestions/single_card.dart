import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/suggestion_navigation_helper.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:get/get.dart';

class SingleCardBody extends StatelessWidget {
  final client.BasketSuggestion s;
  final Color accent;

  const SingleCardBody({super.key, required this.s, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Colors.white.withValues(alpha: 0.92)
        : const Color(0xFF111111);
    final textSecondary = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFF888888);
    final isBest = s.isBest ?? false;
    final action = s.actions?.first;
    final type = s.type;
    final isSmgm = type == 'smgm_reward';

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isBest) ...[
                const BestBadge(),
                SizedBox(width: 6.w),
              ],
              if (action != null)
                Flexible(
                  child: SuggestionActionChip(
                    label: isSmgm ? _buildSmgmChipLabel(s) : action.label.toUpperCase(),
                    color: accent,
                    icon: _getIcon(action.type),
                  ),
                ),
              const Spacer(),
              if (s.savingAmount != null && s.savingAmount! > 0)
                SaveBadge(amount: s.savingAmount!, accent: accent),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            isSmgm ? _buildSmgmMainText(s) : (s.title ?? s.message),
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13.5.sp,
              height: 1.3,
              letterSpacing: -0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isSmgm) ...[
            if (s.progressTarget != null && s.progressTarget! > 0) ...[
              SizedBox(height: 3.h),
              Text(
                'Free on orders above ₹${s.progressTarget!.toStringAsFixed(0)}',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 11.sp,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ] else if ((s.subtitle ?? '').trim().isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              s.subtitle!,
              style: TextStyle(
                color: textSecondary,
                fontSize: 11.sp,
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
              if (isSmgm)
                _buildSmgmThumb(s)
              else if (type == 'combo' && s.comboId != null)
                _ComboThumbs(comboId: s.comboId!, s: s)
              else if (s.thumbnailUrl != null)
                _Thumb(url: s.thumbnailUrl!),

              if (isSmgm)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s.metadata?['productName'] ?? '',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        if (s.metadata?['quantity'] case final qty?
                            when qty.isNotEmpty)
                          Text(
                            qty,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 11.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else ...[
                SizedBox(width: 8.w),
                if (s.metadata != null &&
                    s.metadata!.containsKey('curLabel') &&
                    s.metadata!.containsKey('vLabel'))
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
                else if (type == 'coupon' ||
                    type == 'delivery' ||
                    action?.type == 'coupon' ||
                    action?.type == 'delivery')
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SuggestionProgressBar(
                        current: s.progressCurrent ?? 0,
                        target: s.progressTarget ?? 0,
                        accent: accent,
                      ),
                    ),
                  )
                else
                  const Spacer(),
              ],

              SizedBox(width: 8.w),
              CTAButton(
                label: (action?.ctaLabel ?? 'View Offer').toUpperCase(),
                accent: accent,
                onTap: isSmgm
                    ? () => SuggestionNavigationHelper.handleTap(s)
                    : () => CartController.instance.applyBasketSuggestion(s),
                showArrow: type != 'delivery',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSmgmChipLabel(client.BasketSuggestion s) {
    return 'FREE GIFT';
  }

  String _buildSmgmMainText(client.BasketSuggestion s) {
    final remaining = s.progressRemaining ?? 0;
    if (remaining > 0) {
      return 'Spend ₹${remaining.toStringAsFixed(0)} more & unlock!';
    }
    return "You've unlocked a free gift!";
  }

  Widget _buildSmgmThumb(client.BasketSuggestion s) {
    if (s.thumbnailUrl != null) {
      return _Thumb(url: s.thumbnailUrl!);
    }
    final productId = s.metadata?['productId']?.toString();
    if (productId != null && productId.isNotEmpty) {
      final cached = ProductProviderController.instance.allProducts
          .firstWhereOrNull((p) => p.productId == productId);
      if (cached?.imageUrl case final url? when url.isNotEmpty) {
        return _Thumb(url: url);
      }
    }
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(Icons.card_giftcard_rounded, color: accent, size: 20.r),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'coupon':
        return Icons.confirmation_number_rounded;
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'variant':
        return Icons.trending_up_rounded;
      case 'combo':
        return Icons.layers_rounded;
      case 'bogo':
      case 'smgm_reward':
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
        final productIds = combo.comboProducts
            .map((p) => p.productId)
            .toSet()
            .toList();
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
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SafeNetworkImage(
          url: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
