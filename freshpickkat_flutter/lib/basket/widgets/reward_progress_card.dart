import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

class RewardProgressCard extends StatelessWidget {
  const RewardProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);

    return Obx(() {
      final freeItems =
          cartController.cartPricing.value?.freeItems ?? [];
      final smgmFreeItems =
          freeItems
              .where((item) => item.rewardSource == 'SHOP_MORE_GET_MORE')
              .toList();
      final smgmOffers =
          smgmFreeItems.map((item) {
            return (
              productName: item.productName,
              threshold: item.rewardThreshold ?? 0,
              rewardValue: item.rewardValue ?? 0,
            );
          }).toList();

      if (smgmFreeItems.isEmpty) {
        return const SizedBox.shrink();
      }

      final cartTotal = cartController.subtotal;

      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: offerTheme.badgeSoft,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: offerTheme.badgeBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  color: offerTheme.badge,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Unlock Your Free Gift',
                  style: TextStyle(
                    color: offerTheme.badge,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ...smgmOffers.map((offer) {
              final progress = (cartTotal / offer.threshold).clamp(0.0, 1.0);
              final remaining =
                  (offer.threshold - cartTotal).clamp(0.0, double.infinity);
              final isUnlocked = cartTotal >= offer.threshold;

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isUnlocked
                              ? '✅ Unlocked!'
                              : '₹${cartTotal.formatPrice} / ₹${offer.threshold.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isUnlocked
                                ? Colors.green
                                : cs.onSurface,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'FREE ${offer.productName}',
                          style: TextStyle(
                            color: offerTheme.badge,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isUnlocked ? Colors.green : offerTheme.badge,
                        ),
                        minHeight: 10.h,
                      ),
                    ),
                    if (!isUnlocked) ...[
                      SizedBox(height: 6.h),
                      Text(
                        'Add ₹${remaining.toStringAsFixed(0)} more to get FREE ${offer.productName}${offer.rewardValue > 0 ? " worth ₹${offer.rewardValue.toStringAsFixed(0)}" : ""}.',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
