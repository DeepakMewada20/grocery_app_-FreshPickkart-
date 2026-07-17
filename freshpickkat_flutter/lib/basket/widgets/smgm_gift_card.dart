import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SmgmGiftCard extends StatelessWidget {
  final CartController cartController;

  const SmgmGiftCard({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);

    return Obx(() {
      final freeItems = cartController.cartPricing.value?.freeItems ?? [];
      final smgmItems = freeItems
          .where((item) => item.rewardSource == 'SHOP_MORE_GET_MORE')
          .toList();
      if (smgmItems.isEmpty) return const SizedBox.shrink();

      return Column(
        children: smgmItems.map((freeItem) {
          final cachedProduct = ProductProviderController.instance.allProducts
              .firstWhereOrNull(
                (p) => p.productId == freeItem.productId,
              );
          final displayName =
              freeItem.productName.isNotEmpty
                  ? freeItem.productName
                  : (cachedProduct?.productName ?? '');
          final displayImage =
              (freeItem.imageUrl?.isNotEmpty == true)
                  ? freeItem.imageUrl!
                  : cachedProduct?.imageUrl;
          final qtyLabel = cachedProduct != null
              ? productFullQuantityLabel(cachedProduct)
              : '';

          return Container(
            margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: offerTheme.badgeSoft,
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
              border: Border.all(color: offerTheme.badgeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: AppSpacing.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: offerTheme.badge,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Text(
                        'SHOP MORE, GET MORE',
                        style: TextStyle(
                          color: offerTheme.onBadge,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Container(
                        width: 56.r,
                        height: 56.r,
                        color: cs.surface,
                        child: SafeNetworkImage(
                          url: displayImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (qtyLabel.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              qtyLabel,
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.5),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                          if (freeItem.rewardThreshold != null &&
                              freeItem.rewardThreshold! > 0) ...[
                            SizedBox(height: 2.h),
                            Text(
                              'Free on orders above ₹${freeItem.rewardThreshold!.formatPrice}',
                              style: TextStyle(
                                color: offerTheme.badge,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (freeItem.rewardValue != null &&
                        freeItem.rewardValue! > 0)
                      Text(
                        '₹${freeItem.rewardValue!.formatPrice}',
                        style: TextStyle(
                          color: offerTheme.badge,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
