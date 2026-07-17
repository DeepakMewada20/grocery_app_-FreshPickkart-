import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_utils.dart';
import 'package:freshpickkat_flutter/basket/suggestions/shared_components.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
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
      padding: AppSpacing.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isBest) ...[
                const BestBadge(),
                SizedBox(width: 6.w),
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
          SizedBox(height: 10.h),
          Text(
            s.title ?? s.message,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13.sp,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if ((s.subtitle ?? '').trim().isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              s.subtitle!,
              style: TextStyle(
                color: textPrimary.withValues(alpha: 0.7),
                fontSize: 11.5.sp,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),

          Row(
            children: [
              if (comboAction == null && s.thumbnailUrl != null) ...[
                _Thumb(url: s.thumbnailUrl!),
                SizedBox(width: 12.w),
              ],
              // Action steps indicators
              Row(
                children: actions.map((a) {
                  final isLast = a == actions.last;
                  return Row(
                    children: [
                      Icon(
                        _getIcon(a),
                        size: AppIcons.small,
                        color: accent.withValues(alpha: 0.8),
                      ),
                      if (!isLast)
                        Container(
                          width: 12.w,
                          height: 1,
                          margin: AppSpacing.symmetric(horizontal: 4),
                          color: accent.withValues(alpha: 0.3),
                        ),
                    ],
                  );
                }).toList(),
              ),
              if (hasCouponOrDelivery)
                Expanded(
                  child: Padding(
                    padding: AppSpacing.symmetric(horizontal: 12),
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
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: SafeNetworkImage(
          url: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
