import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/product_detail_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final AuthController _authController = AuthController.instance;
  final ProductProviderController _productProviderController =
      ProductProviderController.instance;
  final CartController _cartController = CartController.instance;
  late final ProductDetailController _controller;
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial product
    _controllerTag =
        'product_detail_${widget.product.productId}_${UniqueKey()}';
    _controller = Get.put(
      ProductDetailController(widget.product),
      tag: _controllerTag,
    );
  }

  @override
  void dispose() {
    Get.delete<ProductDetailController>(tag: _controllerTag);
    super.dispose();
  }

  void _incrementQuantity(Product product) {
    _cartController.addItem(product);
  }

  void _decrementQuantity(Product product) {
    _cartController.removeItem(product);
  }

  void _handleAddToCart(Product product) {
    ProtectedNavigationHelper.executeProtectedAction(
      onLoggedIn: () => _incrementQuantity(product),
      productToAdd: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = _controller.product.value;
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
                      product.imageUrl,
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
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 12,
                          ),
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
                                product.productName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.quantity,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // We need to pass the *current* product to the cart controller
                        _buildAddButton(
                          product,
                          _cartController.getProductQuantity(product.productId),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            '₹${product.price}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'M.R.P: ₹${product.realPrice}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${product.discount}% OFF',
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
                    _buildRelatedProducts(product),
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
              ProtectedNavigationHelper.navigateTo(
                routeName: Get.currentRoute,
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
    });
  }

  Widget _buildAddButton(Product product, int quantity) {
    if (quantity == 0) {
      return SizedBox(
        height: 36,
        child: OutlinedButton(
          onPressed: () => _handleAddToCart(product),
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
              onPressed: () => _decrementQuantity(product),
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
              onPressed: () => _incrementQuantity(product),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRelatedProducts(Product currentProduct) {
    // Filter related products by category
    final relatedProducts = _productProviderController.allProducts
        .where(
          (p) =>
              p.category == currentProduct.category &&
              p.productId != currentProduct.productId,
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
              enableHero: false,
              onTap: () {
                _controller.updateProduct(p);
              },
              onAddPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
