import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
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

  void _increment() {
    _cartController.addItem(widget.product);
  }

  void _decrement() {
    _cartController.removeItem(widget.product);
  }

  void _handleAddToCart() {
    if (_authController.isLoggedIn) {
      _increment();
      _showBogoSelectionIfNeeded(widget.product);
      if (widget.onAddPressed != null) widget.onAddPressed!();
    } else {
      ProtectedNavigationHelper.navigateTo(
        routeName: Get.currentRoute,
        productToAdd: widget.product,
      );
    }
  }

  void _showBogoSelectionIfNeeded(Product product) {
    final freeProductIds = product.bogoFreeProductIds ?? const <String>[];
    if (!isBogoProduct(product) || product.productId == null) return;

    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) => item.product.productId == product.productId,
    );
    if (cartItem?.bogoFreeProductId != null) return;

    if (freeProductIds.length == 1) {
      _cartController.setBogoSelection(
        product.productId!,
        freeProductIds.first,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.bottomSheet(
        BogoSelectionBottomSheet(
          triggerProductId: product.productId!,
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
              Get.to(() => ProductDetailScreen(product: widget.product));
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
                                    widget.product.imageUrl,
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
                                  widget.product.imageUrl,
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
                      if (hasProductOffer(widget.product))
                        Positioned(
                          top: 8,
                          left: 8,
                          child: ProductOfferBadge(
                            product: widget.product,
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
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Bottom Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quantity (Truncated to 1 line)
                            // Product quantity
                            Text(
                              widget.product.quantity,
                              style: GoogleFonts.inter(
                                color: cs.onSurface.withValues(alpha: 0.5),
                                fontSize: widget.quantityFontSize ?? 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text(
                                  '₹${widget.product.price.formatPrice}',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF4CAF50),
                                    fontSize: widget.priceFontSize ?? 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.product.realPrice >
                                    widget.product.price) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹${widget.product.realPrice.formatPrice}',
                                    style: GoogleFonts.inter(
                                      color: cs.onSurface.withValues(
                                        alpha: 0.35,
                                      ),
                                      fontSize: widget.realPriceFontSize ?? 10,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: cs.onSurface.withValues(
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
