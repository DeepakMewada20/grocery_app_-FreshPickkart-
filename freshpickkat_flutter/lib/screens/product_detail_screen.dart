import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/login_bottom_sheet.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final AuthController _authController = AuthController.instance;
  final ProductProviderController _productController =
      ProductProviderController.instance;
  final CartController _cartController = CartController.instance;

  void _incrementQuantity() {
    _cartController.addItem(widget.product);
  }

  void _decrementQuantity() {
    _cartController.removeItem(widget.product);
  }

  void _handleAddToCart() {
    if (_authController.isLoggedIn) {
      _incrementQuantity();
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8BC34A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Solapur (Maharashtra)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.product.quantity,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => _buildAddButton(
                          _cartController.getProductQuantity(
                            widget.product.productId,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          '₹${widget.product.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'M.R.P: ₹${widget.product.realPrice}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.product.discount}% OFF',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '(Inclusive of all taxes)',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),

                  const Text(
                    'Related Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRelatedProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (_authController.isLoggedIn) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: () {
            Get.bottomSheet(
              LoginBottomSheet(
                onLoginPressed: () {
                  _authController.returnRoute.value = Get.currentRoute;
                  Get.back(); // Close bottom sheet
                  Get.toNamed('/phone-auth');
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Subscribe Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAddButton(int quantity) {
    if (quantity == 0) {
      return SizedBox(
        height: 36,
        child: OutlinedButton(
          onPressed: _handleAddToCart,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2196F3),
            side: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text(
            '+ Add',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.remove, color: Colors.white, size: 18),
              onPressed: _decrementQuantity,
            ),
            const SizedBox(width: 12),
            Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              onPressed: _incrementQuantity,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRelatedProducts() {
    // Filter related products by category
    final relatedProducts = _productController.allProducts
        .where(
          (p) =>
              p.category == widget.product.category &&
              p.productId != widget.product.productId,
        )
        .toList();

    if (relatedProducts.isEmpty) {
      return const Text(
        'No related products found',
        style: TextStyle(color: Colors.white54),
      );
    }

    return SizedBox(
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: relatedProducts.length,
        itemBuilder: (context, index) {
          final p = relatedProducts[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: ProductCard(
              product: p,
              onAddPressed: () {
                // This will be handled inside ProductCard
              },
            ),
          );
        },
      ),
    );
  }
}
