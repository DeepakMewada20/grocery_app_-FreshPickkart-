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
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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
            margin: EdgeInsets.fromLTRB(ScreenScale.w(16), ScreenScale.h(8), ScreenScale.w(16), 0),
            padding: EdgeInsets.all(ScreenScale.r(14)),
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
                          fontSize: ScreenScale.sp(10),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenScale.h(12)),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Container(
                        width: ScreenScale.r(56),
                        height: ScreenScale.r(56),
                        color: cs.surface,
                        child: SafeNetworkImage(
                          url: displayImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenScale.w(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: ScreenScale.sp(14),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (qtyLabel.isNotEmpty) ...[
                            SizedBox(height: ScreenScale.h(2)),
                            Text(
                              qtyLabel,
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.5),
                                fontSize: ScreenScale.sp(12),
                              ),
                            ),
                          ],
                          if (freeItem.rewardThreshold != null &&
                              freeItem.rewardThreshold! > 0) ...[
                            SizedBox(height: ScreenScale.h(2)),
                            Text(
                              'Free on orders above ₹${freeItem.rewardThreshold!.formatPrice}',
                              style: TextStyle(
                                color: offerTheme.badge,
                                fontSize: ScreenScale.sp(11),
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
                          fontSize: ScreenScale.sp(14),
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
