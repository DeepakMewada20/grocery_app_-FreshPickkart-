import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as product_detail_screen;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:get/get.dart';

import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddPressed;
  final VoidCallback? onTap;
  final bool enableHero;
  final String? heroTagSuffix;
  final double? titleFontSize;
  final double? priceFontSize;
  final double? quantityFontSize;
  final double? realPriceFontSize;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddPressed,
    this.onTap,
    this.enableHero = false,
    this.heroTagSuffix,
    this.titleFontSize,
    this.priceFontSize,
    this.quantityFontSize,
    this.realPriceFontSize,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final AuthController _authController = AuthController.instance;
  final CartController _cartController = CartController.instance;
  bool _isPressed = false;
  StreamSubscription? _cartSubscription;

  String get _variantId => widget.product.variantId?.isNotEmpty == true
      ? widget.product.variantId!
      : 'default';

  @override
  void initState() {
    super.initState();
    _cartSubscription = _cartController.cartItems.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  Product get _displayProduct =>
      applyVariantToProduct(widget.product, variantId: _variantId);

  void _increment() {
    _cartController.addItem(widget.product, variantId: _variantId);
  }

  void _decrement() {
    _cartController.removeItem(widget.product, variantId: _variantId);
  }

  Future<void> _handleAddToCart() async {
    if (_authController.isLoggedIn) {
      _cartController.suspendPricingRefresh();
      try {
        _increment();
        await _showBogoSelectionIfNeeded(_displayProduct);
      } finally {
        _cartController.resumePricingRefresh();
      }
      if (widget.onAddPressed != null) widget.onAddPressed!();
    } else {
      ProtectedNavigationHelper.navigateTo(
        routeName: Get.currentRoute,
        productToAdd: _displayProduct,
      );
    }
  }

  Future<void> _showBogoSelectionIfNeeded(Product product) async {
    if (!isBogoProduct(product) || product.productId == null) return;

    final offer = await BogoController.instance.fetchOfferForProduct(
      product.productId!,
      variantId: _variantId,
    );

    final freeProductIds =
        (offer?.freeProductIds.isNotEmpty == true
            ? offer!.freeProductIds
            : product.bogoFreeProductIds) ??
        const <String>[];

    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == _variantId,
    );
    if (cartItem?.bogoFreeProductId != null) return;

    final isEligible =
        offer == null ||
        (isBogoTriggerVariantEligible(
              widget.product,
              offer: offer,
              selectedVariantId: _variantId,
            ) &&
            isBogoTriggerQuantityEligible(offer, cartItem?.quantity ?? 0));

    if (isEligible && freeProductIds.length == 1) {
      _cartController.setBogoSelection(
        product.productId!,
        freeProductIds.first,
        triggerVariantId: _variantId,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.bottomSheet(
        BogoSelectionBottomSheet(
          triggerProductId: product.productId!,
          triggerVariantId: _variantId,
          freeProductIds: freeProductIds,
        ),
        isScrollControlled: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayProduct = _displayProduct;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: InkWell(
          onTap: () async {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              await navigateDeferred(
                loadLibrary: product_detail_screen.loadLibrary,
                pageBuilder: () => product_detail_screen.ProductDetailScreen(
                  product: displayProduct,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
              border: Border.all(
                color: cs.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: AppSpacing.sm,
                  offset: Offset(0, ScreenScale.h(4)),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isHorizontalTile =
                    kIsWeb &&
                    constraints.hasBoundedHeight &&
                    constraints.maxWidth > constraints.maxHeight * 1.2;

                final imageSection = _buildImageSection(
                  context,
                  cs,
                  displayProduct,
                );
                final detailsSection = _buildDetailsSection(
                  context,
                  cs,
                  displayProduct,
                );

                if (isHorizontalTile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: imageSection),
                      Expanded(flex: 4, child: detailsSection),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(aspectRatio: 1.0, child: imageSection),
                    Expanded(child: detailsSection),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ColorScheme cs,
    Product displayProduct,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.extraLarge),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.extraLarge),
            ),
            child: widget.enableHero && widget.product.productId != null
                ? Hero(
                    tag:
                        'product_${widget.product.productId}${widget.heroTagSuffix ?? ''}',
                    child: SafeNetworkImage(
                      url: displayProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : SafeNetworkImage(
                    url: displayProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        if (hasProductOffer(displayProduct))
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: ProductOfferBadge(
              product: displayProduct,
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    ColorScheme cs,
    Product displayProduct,
  ) {
    return Padding(
      padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.product.productName,
            style: AppText.productTitle(context).copyWith(
              fontSize:
                  widget.titleFontSize?.sp ??
                  AppText.productTitle(context).fontSize,
            ),
            maxLines: 2,
            minFontSize: 9,
            stepGranularity: 0.5,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: AutoSizeText(
                    productFullQuantityLabel(displayProduct),
                    style: AppText.productQuantity(context).copyWith(
                      fontSize:
                          widget.quantityFontSize?.sp ??
                          AppText.productQuantity(context).fontSize,
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSpacing.height(3),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: AutoSizeText(
                          '₹${displayProduct.price.formatPrice}',
                          style: AppText.productPrice(context).copyWith(
                            fontSize:
                                widget.priceFontSize?.sp ??
                                AppText.productPrice(context).fontSize,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (displayProduct.realPrice > displayProduct.price) ...[
                        AppSpacing.width(AppSpacing.xs),
                        Flexible(
                          flex: 2,
                          child: AutoSizeText(
                            '₹${displayProduct.realPrice.formatPrice}',
                            style: AppText.productMrp(context).copyWith(
                              fontSize:
                                  widget.realPriceFontSize?.sp ??
                                  AppText.productMrp(context).fontSize,
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AppSpacing.height(AppSpacing.xs),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: !displayProduct.isAvailable
                        ? _buildNotAvailableButton(cs)
                        : _buildAddOrQuantity(cs),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOrQuantity(ColorScheme cs) {
    final quantity = _cartController.getProductQuantity(
      widget.product.productId,
      variantId: _variantId,
    );
    return quantity == 0
        ? _buildAddButton(cs)
        : _buildQuantitySelector(quantity);
  }

  Widget _buildAddButton(ColorScheme cs) {
    return Material(
      color: cs.inverseSurface,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: _handleAddToCart,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          alignment: Alignment.center,
          child: AutoSizeText(
            'ADD',
            style: AppText.button(context).copyWith(
              color: cs.onInverseSurface,
            ),
            maxLines: 1,
            minFontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildNotAvailableButton(ColorScheme cs) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: AutoSizeText(
        'Not Available',
        style: AppText.button(context).copyWith(
          color: cs.onSurface.withValues(alpha: 0.5),
        ),
        maxLines: 1,
        minFontSize: 8,
      ),
    );
  }

  Widget _buildQuantitySelector(int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: AppSpacing.xxs,
            offset: Offset(0, ScreenScale.h(2)),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: _decrement,
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: Padding(
              padding: AppSpacing.symmetric(horizontal: 10, vertical: 8),
              child: Icon(Icons.remove, color: Colors.white, size: AppIcons.small),
            ),
          ),
          AutoSizeText(
            '$quantity',
            style: AppText.titleSmall(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            minFontSize: 10,
          ),
          InkWell(
            onTap: _increment,
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: Padding(
              padding: AppSpacing.symmetric(horizontal: 10, vertical: 8),
              child: Icon(Icons.add, color: Colors.white, size: AppIcons.small),
            ),
          ),
        ],
      ),
    );
  }
}
