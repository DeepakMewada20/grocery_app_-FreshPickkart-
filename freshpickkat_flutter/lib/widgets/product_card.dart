import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late String _selectedVariantId;
  StreamSubscription? _cartSubscription;

  @override
  void initState() {
    super.initState();
    _selectedVariantId = inferProductVariantId(widget.product);
    _cartSubscription = _cartController.cartItems.listen((_) {
      _syncSelectedVariantFromCart();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  Product get _displayProduct =>
      applyVariantToProduct(widget.product, variantId: _selectedVariantId);

  void _syncSelectedVariantFromCart() {
    if (!mounted) return;
    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) => item.product.productId == widget.product.productId,
    );
    if (cartItem == null) return;
    final actualVariantId =
        cartItem.variantId ?? inferProductVariantId(widget.product);
    if (actualVariantId != _selectedVariantId) {
      setState(() => _selectedVariantId = actualVariantId);
    }
  }

  void _increment() {
    _cartController.addItem(widget.product, variantId: _selectedVariantId);
  }

  void _decrement() {
    _cartController.removeItem(widget.product, variantId: _selectedVariantId);
  }

  Future<void> _handleAddToCart() async {
    if (_authController.isLoggedIn) {
      _increment();
      await _showBogoSelectionIfNeeded(_displayProduct);
      if (widget.onAddPressed != null) widget.onAddPressed!();
    } else {
      ProtectedNavigationHelper.navigateTo(
        routeName: Get.currentRoute,
        productToAdd: _displayProduct,
      );
    }
  }

  Future<void> _showBogoSelectionIfNeeded(Product product) async {
    final freeProductIds = product.bogoFreeProductIds ?? const <String>[];
    if (!isBogoProduct(product) || product.productId == null) return;

    final offer = await BogoController.instance.fetchOfferForProduct(
      product.productId!,
    );

    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == _selectedVariantId,
    );
    if (cartItem?.bogoFreeProductId != null) return;

    final isEligible =
        offer == null ||
        (isBogoTriggerVariantEligible(
              widget.product,
              offer: offer,
              selectedVariantId: _selectedVariantId,
            ) &&
            isBogoTriggerQuantityEligible(offer, cartItem?.quantity ?? 0));

    if (isEligible && freeProductIds.length == 1) {
      _cartController.setBogoSelection(
        product.productId!,
        freeProductIds.first,
        triggerVariantId: _selectedVariantId,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.bottomSheet(
        BogoSelectionBottomSheet(
          triggerProductId: product.productId!,
          triggerVariantId: _selectedVariantId,
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
    final variants = sortedProductVariants(widget.product);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: InkWell(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              Get.to(() => ProductDetailScreen(product: displayProduct));
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: cs.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section (1:1 Aspect Ratio)
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                          child: widget.enableHero &&
                                  widget.product.productId != null
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
                          top: 8,
                          left: 8,
                          child: ProductOfferBadge(
                            product: displayProduct,
                            fontSize: 10.sp.clamp(8.0, 11.0),
                          ),
                        ),
                    ],
                  ),
                ),

                // Product details section
                Expanded(
                  child: Padding(
                    padding: AppSpacing.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product title
                        AutoSizeText(
                          widget.product.productName,
                          style: AppTextStyles.productTitle(context).copyWith(
                            fontSize: widget.titleFontSize?.sp ??
                                AppTextStyles.productTitle(context).fontSize,
                          ),
                          maxLines: 2,
                          minFontSize: 9,
                          stepGranularity: 0.5,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Bottom Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (variants.length > 1) ...[
                              SizedBox(
                                height: 26.h.clamp(22.0, 30.0),
                                child: DropdownButton<String>(
                                  value: _selectedVariantId,
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 14.r,
                                  underline: const SizedBox.shrink(),
                                  style: GoogleFonts.inter(
                                    color: cs.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: widget.quantityFontSize?.sp ??
                                        AppTextStyles.productQuantity(
                                          context,
                                        ).fontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  dropdownColor: cs.surface,
                                  items: variants.map(
                                    (variant) {
                                      return DropdownMenuItem(
                                        value: variant.variantId,
                                        child: Text(
                                          formatQuantityString(
                                            variant.quantityValue,
                                            variant.quantityUnit,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _selectedVariantId = value;
                                    });
                                  },
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                height: 26.h.clamp(22.0, 30.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    productFullQuantityLabel(displayProduct),
                                    style: AppTextStyles.productQuantity(
                                      context,
                                    ).copyWith(
                                      fontSize: widget.quantityFontSize?.sp ??
                                          AppTextStyles.productQuantity(
                                            context,
                                          ).fontSize,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 3.h),

                            Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: AutoSizeText(
                                    '₹${displayProduct.price.formatPrice}',
                                    style: AppTextStyles.productPrice(
                                      context,
                                    ).copyWith(
                                      fontSize: widget.priceFontSize?.sp ??
                                          AppTextStyles.productPrice(
                                            context,
                                          ).fontSize,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (displayProduct.realPrice >
                                    displayProduct.price) ...[
                                  SizedBox(width: 6.w),
                                  Flexible(
                                    flex: 2,
                                    child: AutoSizeText(
                                      '₹${displayProduct.realPrice.formatPrice}',
                                      style: AppTextStyles.productMrp(
                                        context,
                                      ).copyWith(
                                        fontSize:
                                            widget.realPriceFontSize?.sp ??
                                                AppTextStyles.productMrp(
                                                  context,
                                                ).fontSize,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 6.h),

                            // Add button or Quantity selector
                            SizedBox(
                              width: double.infinity,
                              height: 32.h.clamp(30.0, 36.0),
                              child: !displayProduct.isAvailable
                                  ? _buildNotAvailableButton(cs)
                                  : Obx(() {
                                      final quantity = _cartController
                                          .getProductQuantity(
                                        widget.product.productId,
                                        variantId: _selectedVariantId,
                                      );
                                      return quantity == 0
                                          ? _buildAddButton(cs)
                                          : _buildQuantitySelector(quantity);
                                    }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(ColorScheme cs) {
    // White bg with dark text — works on both light and dark themes
    return Material(
      color: cs.inverseSurface,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: _handleAddToCart,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          alignment: Alignment.center,
          child: AutoSizeText(
            'ADD',
            style: AppTextStyles.button(context).copyWith(
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
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: AutoSizeText(
        'Not Available',
        style: AppTextStyles.button(context).copyWith(
          color: cs.onSurface.withOpacity(0.5),
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
            onTap: _decrement,
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Icon(Icons.remove, color: Colors.white, size: 16.r),
            ),
          ),
          AutoSizeText(
            '$quantity',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            minFontSize: 10,
          ),
          InkWell(
            onTap: _increment,
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
