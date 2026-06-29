import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as product_detail_screen;
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
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
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);
    final triggerVariant = resolveConfiguredBogoTriggerVariant(product, offer);
    final freeProducts = offer.freeProducts ?? const <BogoFreeProduct>[];
    final reward = freeProducts.isEmpty ? null : freeProducts.first;
    final requiredQty = offer.minTriggerQuantity ?? 1;
    final freeQty = reward == null ? 1 : bogoRewardFreeQuantity(reward);
    final triggerLabel = triggerVariant == null
        ? product.quantity
        : formatQuantityString(
            triggerVariant.quantityValue,
            triggerVariant.quantityUnit,
          );
    final offerText = 'Buy $requiredQty x $triggerLabel Get $freeQty FREE';
    final badgeText = 'Buy $requiredQty Get $freeQty';

    final productController = ProductProviderController.instance;
    final freeProductObjects = freeProducts
        .map(
          (fp) => productController.allProducts.firstWhereOrNull(
            (p) => p.productId == fp.productId,
          ),
        )
        .whereType<Product>()
        .toList();

    return GestureDetector(
      onTap: () async {
        await navigateDeferred(
          loadLibrary: product_detail_screen.loadLibrary,
          pageBuilder: () =>
              product_detail_screen.ProductDetailScreen(product: product),
        );
      },
      child: Container(
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
            // Trigger Product Section (Compact)
            SizedBox(
              height: 110.h,
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Trigger Product Image (Smaller)
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14.r),
                          bottomLeft: Radius.circular(14.r),
                        ),
                        child: Container(
                          width: 100.w,
                          height: 110.h,
                          color: cs.surface,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.image_not_supported_outlined,
                              color: cs.onSurface.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  product.productName,
                                  maxLines: 2,
                                  minFontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Text(
                                offerText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹${(triggerVariant?.price ?? product.price).formatPrice}',
                                    style: TextStyle(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  if ((triggerVariant?.realPrice ?? product.realPrice) > (triggerVariant?.price ?? product.price))
                                    Text(
                                      '₹${(triggerVariant?.realPrice ?? product.realPrice).formatPrice}',
                                      style: TextStyle(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.45,
                                        ),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 8.w,
                    top: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: offerTheme.badge,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: offerTheme.onBadge,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Divider(height: 1, color: cs.outlineVariant),
            // Offer Text & Free Products Section
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  // Free Products Scrollable List
                  if (freeProductObjects.isNotEmpty) ...[
                    Text(
                      'Choose Free Item:',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 90.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: freeProductObjects.length,
                        separatorBuilder: (_, _) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final freeProduct = freeProductObjects[index];
                          final freeConfig = freeProducts[index];
                          final displayProduct = freeConfig.variantId != null
                              ? applyVariantToProduct(freeProduct, variantId: freeConfig.variantId)
                              : freeProduct;
                          final freeQtyText = freeConfig.variantId != null
                              ? _getVariantQuantityLabel(
                                  freeProduct,
                                  freeConfig.variantId!,
                                )
                              : freeProduct.quantity;
                          return _FreeProductCard(
                            product: displayProduct,
                            quantityLabel: freeQtyText,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                  Obx(() {
                    final cart = CartController.instance;
                    final qty = cart.getProductQuantity(
                      product.productId,
                      variantId: triggerVariant?.variantId,
                    );
                    return SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: qty == 0
                          ? FilledButton.icon(
                              onPressed: product.productId == null
                                  ? null
                                  : () {
                                      cart.suspendPricingRefresh();
                                      try {
                                        cart.addItem(
                                          product,
                                          variantId: triggerVariant?.variantId,
                                          quantityDelta: requiredQty <= 0
                                              ? 1
                                              : requiredQty,
                                        );
                                        if (reward != null) {
                                          cart.setBogoSelection(
                                            product.productId!,
                                            reward.productId,
                                            triggerVariantId:
                                                triggerVariant?.variantId,
                                          );
                                        }
                                      } finally {
                                        cart.resumePricingRefresh();
                                      }
                                    },
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                size: 18,
                              ),
                              label: const Text('Add Offer'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                textStyle: TextStyle(fontSize: 12.sp),
                              ),
                            )
                          : _buildQuantitySelector(
                              qty,
                              cart,
                              product,
                              triggerVariant,
                              requiredQty,
                            ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVariantQuantityLabel(Product product, String variantId) {
    try {
      final variant = product.variants?.firstWhere(
        (v) => v.variantId == variantId,
      );
      if (variant != null) {
        return formatQuantityString(
          variant.quantityValue,
          variant.quantityUnit,
        );
      }
    } catch (_) {}
    return product.quantity;
  }

  Widget _buildQuantitySelector(
    int quantity,
    CartController cart,
    Product product,
    ProductVariant? triggerVariant,
    int requiredQty,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => cart.removeItem(
              product,
              variantId: triggerVariant?.variantId,
              quantityDelta: requiredQty <= 0 ? 1 : requiredQty,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Icon(Icons.remove, color: Colors.white, size: 16.r),
            ),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          InkWell(
            onTap: () => cart.addItem(
              product,
              variantId: triggerVariant?.variantId,
              quantityDelta: requiredQty <= 0 ? 1 : requiredQty,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Icon(Icons.add, color: Colors.white, size: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeProductCard extends StatelessWidget {
  final Product product;
  final String quantityLabel;

  const _FreeProductCard({
    required this.product,
    required this.quantityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 170.w,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: cs.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              bottomLeft: Radius.circular(10.r),
            ),
            child: SizedBox(
              width: 85.w,
              height: 90.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image_not_supported_outlined,
                      color: cs.onSurface.withValues(alpha: 0.35),
                      size: 20.r,
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    right: 2.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        'FREE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    quantityLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '₹${product.price.formatPrice}',
                    maxLines: 1,
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
