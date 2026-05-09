import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:get/get.dart';

class BogoOfferCard extends StatelessWidget {
  const BogoOfferCard({
    super.key,
    required this.product,
    required this.offer,
  });

  final Product product;
  final BogoOffer offer;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final triggerVariant = resolveConfiguredBogoTriggerVariant(product, offer);
    final reward = (offer.freeProducts ?? const <BogoFreeProduct>[]).isEmpty
        ? null
        : (offer.freeProducts ?? const <BogoFreeProduct>[]).first;
    final requiredQty = offer.minTriggerQuantity ?? 1;
    final freeQty = reward == null ? 1 : bogoRewardFreeQuantity(reward);
    final triggerLabel = triggerVariant == null
        ? product.quantity
        : formatQuantityString(
            triggerVariant.quantityValue,
            triggerVariant.quantityUnit,
          );
    final offerText = 'Buy $requiredQty x $triggerLabel Get $freeQty FREE';

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.12),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => ColoredBox(
                        color: cs.surface,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: cs.onSurface.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 10.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE11D48),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'BUY X GET Y',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  product.productName,
                  maxLines: 2,
                  minFontSize: 11,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  offerText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      '₹${product.price.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (product.realPrice > product.price)
                      Text(
                        '₹${product.realPrice.formatPrice}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.45),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          color: Color(0xFFE11D48),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: product.productId == null
                        ? null
                        : () {
                            CartController.instance.addItem(
                              product,
                              variantId: triggerVariant?.variantId,
                              quantityDelta: requiredQty <= 0 ? 1 : requiredQty,
                            );
                            if (reward != null) {
                              CartController.instance.setBogoSelection(
                                product.productId!,
                                reward.productId,
                                triggerVariantId: triggerVariant?.variantId,
                              );
                            }
                            Get.snackbar(
                              'Offer Added',
                              offerText,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                            );
                          },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add Offer'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
