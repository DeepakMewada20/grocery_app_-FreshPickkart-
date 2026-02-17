import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/widgets/discound_badge.dart';
import 'package:freshpickkat_flutter/widgets/login_bottom_sheet.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddPressed;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddPressed,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final AuthController _authController = AuthController.instance;
  final CartController _cartController = CartController.instance;

  void _increment() {
    _cartController.addItem(widget.product);
  }

  void _decrement() {
    _cartController.removeItem(widget.product);
  }

  void _handleAddToCart() {
    if (_authController.isLoggedIn) {
      _increment();
      if (widget.onAddPressed != null) widget.onAddPressed!();
    } else {
      Get.bottomSheet(
        LoginBottomSheet(
          onLoginPressed: () {
            _authController.returnRoute.value = Get.currentRoute;
            Get.back(); // Close bottom sheet
            Get.toNamed('/phone-auth');
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProductDetailScreen(product: widget.product));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with 1:1 aspect ratio and discount badge
            AspectRatio(
              aspectRatio: 1, // Perfect square 1:1 ratio
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Discount badge
                  if (widget.product.discount > 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: DiscountBadge(
                        discount: '${widget.product.discount}%\nOFF',
                      ),
                    ),
                ],
              ),
            ),
            // Product details section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product title
                    Text(
                      widget.product.productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // Pushes follows to bottom
                    // Quantity
                    Text(
                      widget.product.quantity,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${widget.product.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.product.realPrice >
                            widget.product.price) ...[
                          const SizedBox(width: 5),
                          Text(
                            '₹${widget.product.realPrice}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white.withOpacity(0.4),
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
                        final quantity = _cartController.getProductQuantity(
                          widget.product.productId,
                        );
                        return quantity == 0
                            ? _buildAddButton()
                            : _buildQuantitySelector(quantity);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return OutlinedButton(
      onPressed: _handleAddToCart,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2196F3),
        side: const BorderSide(
          color: Color(0xFF2196F3),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.zero,
      ),
      child: const Text(
        '+ Add',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: _decrement,
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: _increment,
          ),
        ],
      ),
    );
  }
}
