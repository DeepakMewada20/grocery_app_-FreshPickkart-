import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/basket/coupon_section.dart';
import 'package:freshpickkat_flutter/basket/basket_suggestions_section.dart';
import 'package:freshpickkat_flutter/basket/empty_basket_view.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';

import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/basket/reward_celebration_service.dart';
import 'package:freshpickkat_flutter/basket/widgets/confetti_burst_widget.dart';
import 'package:freshpickkat_flutter/basket/widgets/reward_banner_overlay.dart';
import 'package:freshpickkat_flutter/basket/widgets/savings_card.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final networkController = NetworkController.instance;
  double _redemptionPercentageLimit = 50.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await CartController.instance.refreshCartCurrentData();
      await CartController.instance.fetchCartPricing();
      await CartController.instance.fetchMaxRedeemablePoints();
      await _fetchFreshPointsSettings();
      await CartController.instance.fetchBasketSuggestions();
      await CategoryProviderController.instance.fetchCategoriesIfEmpty();
      await ProductProviderController.instance.fetchTrendingIfEmpty();
      await ProductProviderController.instance.fetchBestSellersIfEmpty();
      // Snapshot reward state AFTER initial load so celebrations
      // only fire on genuine user-driven transitions, never on startup.
      if (mounted) {
        final cart = CartController.instance;
        RewardCelebrationService.instance.snapshotCurrentState(
          deliveryFee: cart.deliveryFee,
          couponCode: cart.appliedCoupon.value?.code,
          couponDiscount: cart.couponDiscount,
        );
      }
    });
    BannerController.instance.refreshBannersForScreen('cart_page');

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('basket')) {
          CartController.instance.refreshCartCurrentData();
          BannerController.instance.refreshBannersForScreen('cart_page');
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    final cartController = CartController.instance;
    cartController.triggerPricingRefresh();
    BannerController.instance.refreshBannersForScreen('cart_page');
    // Small delay so the RefreshIndicator spinner is visible
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (cartController.itemCount == 0) {
            return _buildEmptyState(context);
          }

          return ConfettiBurstWidget(
            child: RewardBannerOverlay(
              child: Builder(
                builder: (context) => Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        displacement: 40.h,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              // 🎯 Cart Page Banner
                              Obx(() {
                                final banners =
                                    BannerController.instance.cartPageBanners;
                                if (banners.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8.h, 0, 4.h),
                                  child: NetworkBannerWidget(
                                    height: AppResponsive.bannerHeight(
                                      context,
                                      ratio: 0.42,
                                      min: 110,
                                      max: 160,
                                    ),
                                    banners: banners,
                                    autoScrollInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    autoScrollDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  ),
                                );
                              }),
                              _buildCartItemsList(context, cartController, cs),
                              const BasketSuggestionsSection(),
                    const CouponSection(),
                    _buildFreshPointsSection(cartController, cs),
                    _buildBillDetails(cartController, cs),
                              const SavingsCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildProceedButton(context, cartController, cs),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyBasketView();
  }

  Widget _buildCartItemsList(
    BuildContext context,
    CartController cartController,
    ColorScheme cs,
  ) {
    return Column(
      children: [
        ...cartController.regularCartItems.map(
          (item) => _buildRegularCartItem(context, cartController, item, cs),
        ),
        ...cartController.comboGroups.map(
          (group) => _buildComboGroupCard(cartController, group, cs),
        ),
      ],
    );
  }

  Widget _buildRegularCartItem(
    BuildContext context,
    CartController cartController,
    CartItem item,
    ColorScheme cs,
  ) {
    final bogoController = BogoController.instance;
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);

    final bogoOffer = bogoController.getOfferForProduct(
      item.product.productId!,
    );
    final freeProduct = item.bogoFreeProductId != null
        ? Get.find<ProductProviderController>().allProducts.firstWhereOrNull(
            (p) => p.productId == item.bogoFreeProductId,
          )
        : null;
    final freeProductQuantity = freeProduct == null
        ? null
        : bogoController.freeProductQuantityLabel(
            item.product.productId ?? '',
            freeProduct.productId ?? '',
            fallback: freeProduct.quantity,
          );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: 76.r,
                        height: 76.r,
                        color: cs.surface,
                        child: SafeNetworkImage(
                          url: item.product.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (bogoOffer != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: offerTheme.badge,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'BOGO',
                            style: TextStyle(
                              color: offerTheme.onBadge,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item.product.productName,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        productFullQuantityLabel(item.product),
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.5),
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final price = Wrap(
                            spacing: 8.w,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              AutoSizeText(
                                '₹${item.product.price.formatPrice}',
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                minFontSize: 12,
                              ),
                              if (item.product.realPrice > item.product.price)
                                AutoSizeText(
                                  '₹${item.product.realPrice.formatPrice}',
                                  style: TextStyle(
                                    color: cs.onSurface.withValues(alpha: 0.4),
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 10,
                                ),
                            ],
                          );
                          if (constraints.maxWidth < 230) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                price,
                                SizedBox(height: 8.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildRegularQuantitySelector(
                                    cartController,
                                    item,
                                    cs,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: price),
                              SizedBox(width: 8.w),
                              _buildRegularQuantitySelector(
                                cartController,
                                item,
                                cs,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (bogoOffer != null) ...[
            Divider(height: 1, color: cs.outlineVariant),
            if (freeProduct != null)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        color: cs.surface,
                        child: SafeNetworkImage(
                          url: freeProduct.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                child: Text(
                                  'FREE',
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: AutoSizeText(
                                  freeProduct.productName,
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  minFontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            '${freeProductQuantity ?? freeProduct.quantity} x ${item.quantity}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.bottomSheet(
                          BogoSelectionBottomSheet(
                            triggerProductId: item.product.productId!,
                            triggerVariantId: item.variantId,
                            freeProductIds: bogoOffer.freeProductIds,
                          ),
                        );
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.bottomSheet(
                        BogoSelectionBottomSheet(
                          triggerProductId: item.product.productId!,
                          triggerVariantId: item.variantId,
                          freeProductIds: bogoOffer.freeProductIds,
                        ),
                      );
                    },
                    icon: const Icon(Icons.card_giftcard, size: 18),
                    label: const Text('Select your free gift'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      side: BorderSide(color: cs.outlineVariant),
                      minimumSize: Size(double.infinity, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildComboGroupCard(
    CartController cartController,
    ComboCartGroup group,
    ColorScheme cs,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'COMBO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  group.name,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comboDiscountBadgeText(group.discountType, group.discountValue),
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...group.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 52,
                      height: 52,
                      color: cs.surface,
                      child: SafeNetworkImage(
                        url: item.product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.productName,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${productFullQuantityLabel(item.product)} x ${item.comboItemQuantity ?? 1}',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'MRP ₹${(item.product.realPrice * (item.comboItemQuantity ?? 1) * group.bundleQuantity).formatPrice}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.4),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sell ₹${(item.product.price * (item.comboItemQuantity ?? 1) * group.bundleQuantity).formatPrice}',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Combo ₹${group.discountedTotal.formatPrice}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sell ₹${group.originalTotal.formatPrice}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'MRP ₹${group.mrpTotal.formatPrice}',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              _buildComboQuantitySelector(cartController, group, cs),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularQuantitySelector(
    CartController cartController,
    CartItem item,
    ColorScheme cs,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => cartController.removeItem(
              item.product,
              variantId: item.variantId,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Icon(Icons.remove, color: cs.onPrimary, size: 18.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          InkWell(
            onTap: () => cartController.addItem(
              item.product,
              variantId: item.variantId,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Icon(Icons.add, color: cs.onPrimary, size: 18.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboQuantitySelector(
    CartController cartController,
    ComboCartGroup group,
    ColorScheme cs,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => cartController.decrementComboGroup(group.comboId),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Icon(Icons.remove, color: cs.onPrimary, size: 18.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '${group.bundleQuantity}',
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          InkWell(
            onTap: () => cartController.incrementComboGroup(group.comboId),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Icon(Icons.add, color: cs.onPrimary, size: 18.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails(CartController cartController, ColorScheme cs) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() {
            final showEstimatedDelivery =
                cartController.isPricingStale.value ||
                cartController.cartPricing.value?.deliveryPricing == null;
            return Column(
              children: [
                _buildBillRow(
                  'MRP Total',
                  '₹${cartController.mrpTotal.formatPrice}',
                  cs: cs,
                ),
                if (cartController.productDiscountTotal > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'Product Discount',
                    '-₹${cartController.productDiscountTotal.formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                if (cartController.comboDiscountTotal > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'Combo Savings',
                    '-₹${cartController.comboDiscountTotal.formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                if (cartController.bogoDiscountTotal > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'BOGO Savings',
                    '-₹${cartController.bogoDiscountTotal.formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                if (cartController.categoryOfferDiscountTotal > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'Category Offer Savings',
                    '-₹${cartController.categoryOfferDiscountTotal.formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                SizedBox(height: 12.h),
                _buildBillRow(
                  'Items Total (Combo Applied)',
                  '₹${cartController.subtotal.formatPrice}',
                  cs: cs,
                ),
                if (cartController.couponDiscount > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'Coupon Discount',
                    '-₹${cartController.couponDiscount.formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                if ((cartController.cartPricing.value?.freshPointsDiscount ?? 0) > 0) ...[
                  SizedBox(height: 12.h),
                  _buildBillRow(
                    'FreshPoints (${cartController.cartPricing.value?.freshPointsRedeemed ?? 0} pts)',
                    '-₹${(cartController.cartPricing.value?.freshPointsDiscount ?? 0.0).formatPrice}',
                    valueColor: Colors.green,
                    cs: cs,
                  ),
                ],
                SizedBox(height: 12.h),
                _buildBillRow(
                  showEstimatedDelivery
                      ? 'Delivery Fee (Est.)'
                      : 'Delivery Fee',
                  cartController.deliveryFee == 0
                      ? (cartController.freeDeliveryApplied &&
                                cartController.originalDeliveryFee > 0
                            ? '₹${cartController.originalDeliveryFee.formatPrice} -> FREE'
                            : 'FREE')
                      : '₹${cartController.deliveryFee.formatPrice}',
                  valueColor: cartController.deliveryFee == 0
                      ? Colors.green
                      : cs.onSurface,
                  cs: cs,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(color: cs.outlineVariant),
                ),
                _buildBillRow(
                  'To Pay',
                  '₹${cartController.totalAmount.formatPrice}',
                  isTotal: true,
                  cs: cs,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
    required ColorScheme cs,
  }) {
    final effectiveValueColor =
        valueColor ?? (isTotal ? cs.onSurface : cs.onSurface);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.receiptLabel(context, total: isTotal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: AutoSizeText(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.receiptValue(
              context,
              total: isTotal,
              color: effectiveValueColor,
            ),
            maxLines: 1,
            minFontSize: 11,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _fetchFreshPointsSettings() async {
    try {
      final settings = await ServerpodClient().client.freshPoints.getSettings();
      if (mounted) {
        setState(() {
          _redemptionPercentageLimit = settings.redemptionPercentageLimit;
        });
      }
    } catch (_) {}
  }

  Widget _buildFreshPointsSection(CartController cart, ColorScheme cs) {
    final balance = AuthController.instance.appUser?.currentFreshPoints ?? 0;
    if (balance <= 0 && cart.freshPointsToRedeem.value == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => cart.freshPointsExpanded.toggle(),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: Obx(() => Text(
                    'FreshPoints Balance: ${cart.freshPointsToRedeem.value > 0 ? '${cart.freshPointsToRedeem.value} pts used' : '$balance pts'}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  )),
                ),
                Obx(() => Icon(
                  cart.freshPointsExpanded.value ? Icons.expand_less : Icons.expand_more,
                  color: cs.onSurfaceVariant,
                )),
              ],
            ),
          ),
          Obx(() {
            if (!cart.freshPointsExpanded.value) return const SizedBox.shrink();
            final maxRedeem = cart.maxRedeemablePoints.value;
            final redeemed = cart.freshPointsToRedeem.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  'Redeem up to $maxRedeem pts${_redemptionPercentageLimit > 0 ? ' (max ${_redemptionPercentageLimit.toInt()}% of payable)' : ''}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text('0', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp)),
                    Expanded(
                      child: Slider(
                        value: redeemed.clamp(0, maxRedeem).toDouble(),
                        min: 0,
                        max: maxRedeem > 0 ? maxRedeem.toDouble() : 1,
                        divisions: maxRedeem.clamp(1, 100),
                        activeColor: Colors.amber.shade700,
                        onChanged: (v) {
                          cart.setFreshPointsToRedeem(v.round());
                        },
                      ),
                    ),
                    Text('$maxRedeem', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp)),
                  ],
                ),
                if (redeemed > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Saving ₹${redeemed.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.green, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProceedButton(
    BuildContext context,
    CartController cartController,
    ColorScheme cs,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ProtectedNavigationHelper.navigateTo(routeName: '/checkout');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: cs.onPrimary,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => AutoSizeText(
                      '₹${cartController.totalAmount.formatPrice}',
                      maxLines: 1,
                      minFontSize: 12,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AutoSizeText(
                    'TOTAL AMOUNT',
                    maxLines: 1,
                    minFontSize: 8,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Row(
              children: [
                AutoSizeText(
                  'PROCEED',
                  maxLines: 1,
                  minFontSize: 12,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios, size: 16.r),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
