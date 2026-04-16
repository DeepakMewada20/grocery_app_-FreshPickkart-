import 'package:flutter/material.dart';
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
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final networkController = NetworkController.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await CartController.instance.refreshCartCurrentData();
      await CartController.instance.fetchBasketSuggestions();
      await CategoryProviderController.instance.fetchCategoriesIfEmpty();
      await ProductProviderController.instance.fetchTrendingIfEmpty();
      await ProductProviderController.instance.fetchBestSellersIfEmpty();
    });
    BannerController.instance.loadBannersForScreen('cart_page');

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('basket')) {
          CartController.instance.refreshCartCurrentData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text(
          'Basket',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => cartController.itemCount > 0
                ? IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: cs.error,
                    ),
                    onPressed: () =>
                        _showClearCartDialog(context, cartController),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.itemCount == 0) {
          return _buildEmptyState(context);
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // 🎯 Cart Page Banner
                    Obx(() {
                      final banners = BannerController.instance.cartPageBanners;
                      if (banners.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                        child: NetworkBannerWidget(
                          height: 130,
                          banners: banners,
                          autoScrollInterval: const Duration(seconds: 4),
                          autoScrollDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    }),
                    _buildCartItemsList(context, cartController, cs),
                    const BasketSuggestionsSection(),
                    const CouponSection(),
                    _buildBillDetails(cartController, cs),
                  ],
                ),
              ),
            ),
            _buildProceedButton(context, cartController, cs),
          ],
        );
      }),
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

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: bogoOffer != null
                  ? offerTheme.badgeBorder
                  : cs.outlineVariant,
              width: bogoOffer != null ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: cs.surface,
                      child: Image.network(
                        item.product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (bogoOffer != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: offerTheme.badge,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          'BOGO',
                          style: TextStyle(
                            color: offerTheme.onBadge,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.productName,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      productFullQuantityLabel(item.product),
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${item.product.price.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.product.realPrice >
                                item.product.price) ...[
                              const SizedBox(width: 8),
                              Text(
                                '₹${item.product.realPrice.formatPrice}',
                                style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        _buildRegularQuantitySelector(cartController, item, cs),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (bogoOffer != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                if (freeProduct != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: offerTheme.badgeSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: offerTheme.badgeBorder),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            freeProduct.imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FREE: ${freeProduct.productName}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: offerTheme.badge,
                                ),
                              ),
                              Text(
                                '${freeProductQuantity ?? freeProduct.quantity} x ${item.quantity}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.7),
                                ),
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
                  ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: offerTheme.badge,
                      foregroundColor: offerTheme.onBadge,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.35),
          width: 1.4,
        ),
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
                  borderRadius: BorderRadius.circular(999),
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
              color: AppTheme.primaryGreen,
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
                      child: Image.network(
                        item.product.imageUrl,
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
                      color: AppTheme.primaryGreen,
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
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.remove, color: cs.onPrimary, size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: () => cartController.addItem(
              item.product,
              variantId: item.variantId,
            ),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.add, color: cs.onPrimary, size: 20),
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
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.remove, color: cs.onPrimary, size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '${group.bundleQuantity}',
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: () => cartController.incrementComboGroup(group.comboId),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.add, color: cs.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails(CartController cartController, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildBillRow(
            'MRP Total',
            '₹${cartController.mrpTotal.formatPrice}',
            cs: cs,
          ),
          if (cartController.productDiscountTotal > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow(
              'Product Discount',
              '-₹${cartController.productDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          if (cartController.comboDiscountTotal > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow(
              'Combo Discount',
              '-₹${cartController.comboDiscountTotal.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          const SizedBox(height: 12),
          _buildBillRow(
            'Subtotal After Discounts',
            '₹${cartController.subtotal.formatPrice}',
            cs: cs,
          ),
          if (cartController.couponDiscount > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow(
              'Coupon Discount',
              '-₹${cartController.couponDiscount.formatPrice}',
              valueColor: Colors.green,
              cs: cs,
            ),
          ],
          const SizedBox(height: 12),
          _buildBillRow(
            'Delivery Fee',
            cartController.deliveryFee == 0
                ? 'FREE'
                : '₹${cartController.deliveryFee.formatPrice}',
            valueColor: cartController.deliveryFee == 0
                ? Colors.green
                : cs.onSurface,
            cs: cs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: cs.outlineVariant),
          ),
          _buildBillRow(
            'To Pay',
            '₹${cartController.totalAmount.formatPrice}',
            isTotal: true,
            cs: cs,
          ),
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
        Text(
          label,
          style: TextStyle(
            color: isTotal ? cs.onSurface : cs.onSurface.withValues(alpha: 0.6),
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: effectiveValueColor,
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton(
    BuildContext context,
    CartController cartController,
    ColorScheme cs,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
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
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹${cartController.totalAmount.formatPrice}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  'PROCEED',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(
    BuildContext context,
    CartController cartController,
  ) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        title: Text(
          'Clear Basket?',
          style: TextStyle(color: cs.onSurface),
        ),
        content: Text(
          'Are you sure you want to remove all items from your basket?',
          style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: AppTheme.primaryGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              cartController.clearCart();
              Navigator.pop(context);
            },
            child: Text(
              'CLEAR',
              style: TextStyle(color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}
