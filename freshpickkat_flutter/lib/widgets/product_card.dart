import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddPressed;
  final VoidCallback? onTap;
  final bool enableHero;
  final double? titleFontSize;
  final double? priceFontSize;
  final double? quantityFontSize;
  final double? realPriceFontSize;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddPressed,
    this.onTap,
    this.enableHero = true,
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedVariantId = inferProductVariantId(widget.product);
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.productId != widget.product.productId) {
      _selectedVariantId = inferProductVariantId(widget.product);
    }
  }

  Product get _displayProduct =>
      applyVariantToProduct(widget.product, variantId: _selectedVariantId);

  void _syncVariantFromCart() {
    if (widget.product.productId == null) return;

    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) => item.product.productId == widget.product.productId,
    );

    if (cartItem != null && cartItem.variantId != null) {
      if (_selectedVariantId != cartItem.variantId) {
        setState(() {
          _selectedVariantId = cartItem.variantId!;
        });
      }
    }
  }

  Future<void> _increment() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final currentQuantity = _cartController.getProductQuantity(
      widget.product.productId,
      variantId: _selectedVariantId,
    );

    if (currentQuantity == 0) {
      _cartController.addItem(widget.product, variantId: _selectedVariantId);
    } else {
      _cartController.incrementAndSwitchVariant(
        widget.product,
        _selectedVariantId,
      );
    }

    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _decrement() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    _cartController.decrementAndSwitchVariant(
      widget.product,
      _selectedVariantId,
    );

    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleAddToCart() {
    if (_authController.isLoggedIn) {
      _increment();
      _showBogoSelectionIfNeeded(_displayProduct);
      if (widget.onAddPressed != null) widget.onAddPressed!();
    } else {
      ProtectedNavigationHelper.navigateTo(
        routeName: Get.currentRoute,
        productToAdd: _displayProduct,
      );
    }
  }

  void _showBogoSelectionIfNeeded(Product product) {
    final freeProductIds = product.bogoFreeProductIds ?? const <String>[];
    if (!isBogoProduct(product) || product.productId == null) return;

    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == _selectedVariantId,
    );
    if (cartItem?.bogoFreeProductId != null) return;

    if (freeProductIds.length == 1) {
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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                            top: Radius.circular(16),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: widget.enableHero
                              ? Hero(
                                  tag:
                                      'product_${widget.product.productId}_$hashCode',
                                  child: Image.network(
                                    displayProduct.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Image.network(
                                  displayProduct.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      if (hasProductOffer(displayProduct))
                        Positioned(
                          top: 8,
                          left: 8,
                          child: ProductOfferBadge(
                            product: displayProduct,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),

                // Product details section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product title
                        Text(
                          widget.product.productName,
                          style: GoogleFonts.poppins(
                            color: cs.onSurface,
                            fontSize: widget.titleFontSize ?? 12,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Bottom Section
                        Obx(() {
                          _syncVariantFromCart();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (variants.length > 1) ...[
                                DropdownButton<String>(
                                  value: _selectedVariantId,
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 14,
                                  style: GoogleFonts.inter(
                                    color: cs.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: widget.quantityFontSize ?? 10,
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
                              ] else ...[
                                Text(
                                  displayProduct.quantity,
                                  style: GoogleFonts.inter(
                                    color: cs.onSurface.withValues(alpha: 0.5),
                                    fontSize: widget.quantityFontSize ?? 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Text(
                                    '₹${displayProduct.price.formatPrice}',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF4CAF50),
                                      fontSize: widget.priceFontSize ?? 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (displayProduct.realPrice >
                                      displayProduct.price) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹${displayProduct.realPrice.formatPrice}',
                                      style: GoogleFonts.inter(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.35,
                                        ),
                                        fontSize:
                                            widget.realPriceFontSize ?? 10,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: cs.onSurface
                                            .withValues(
                                              alpha: 0.35,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Add button or Quantity selector
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: Obx(() {
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
                          );
                        }),
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
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: cs.inverseSurface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }
    return Material(
      color: cs.inverseSurface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _handleAddToCart,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'ADD',
            style: GoogleFonts.poppins(
              color: cs.onInverseSurface,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(int quantity) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: _decrement,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          Text(
            '$quantity',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          InkWell(
            onTap: _increment,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
