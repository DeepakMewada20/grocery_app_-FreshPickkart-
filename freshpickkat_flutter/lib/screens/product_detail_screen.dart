import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/product_detail_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
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
  late String _selectedVariantId;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial product
    _controllerTag =
        'product_detail_${widget.product.productId}_${UniqueKey()}';
    _selectedVariantId = inferProductVariantId(widget.product);
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
    _cartController.addItem(product, variantId: _selectedVariantId);
  }

  void _decrementQuantity(Product product) {
    _cartController.removeItem(product, variantId: _selectedVariantId);
  }

  void _handleAddToCart(Product product) {
    ProtectedNavigationHelper.executeProtectedAction(
      onLoggedIn: () {
        _incrementQuantity(product);
        _showBogoSelectionIfNeeded(product);
      },
      productToAdd: product,
    );
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

  void _openBogoSelectionSheet(Product product) {
    if (!isBogoProduct(product) || product.productId == null) return;
    Get.bottomSheet(
      BogoSelectionBottomSheet(
        triggerProductId: product.productId!,
        triggerVariantId: _selectedVariantId,
        freeProductIds: product.bogoFreeProductIds ?? const <String>[],
      ),
      isScrollControlled: true,
    );
  }

  dynamic _cartItemForProduct(Product product) {
    return _cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == _selectedVariantId,
    );
  }

  Product? _selectedBogoFreeProduct(Product product) {
    final selectedId = _cartItemForProduct(product)?.bogoFreeProductId;
    if (selectedId == null) return null;
    return _productProviderController.allProducts.firstWhereOrNull(
      (item) => item.productId == selectedId,
    );
  }

  String _selectedBogoFreeQuantity(
    Product triggerProduct,
    Product freeProduct,
  ) {
    return BogoController.instance.freeProductQuantityLabel(
      triggerProduct.productId ?? '',
      freeProduct.productId ?? '',
      fallback: freeProduct.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = _controller.product.value;
      final displayProduct = applyVariantToProduct(
        product,
        variantId: _selectedVariantId,
      );
      final variants = sortedProductVariants(product);
      final cs = Theme.of(context).colorScheme;
      final offerTheme =
          Theme.of(context).extension<AppOfferTheme>() ??
          AppOfferTheme.fallback(Theme.of(context).brightness);
      final selectedFreeProduct = _selectedBogoFreeProduct(displayProduct);
      final cartItem = _cartItemForProduct(displayProduct);
      final selectedQuantity = cartItem?.quantity ?? 0;
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
                    if ((product.countryOfOrigin ?? '').trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.public_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Country of Origin: ${product.countryOfOrigin}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
                                displayProduct.productName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayProduct.quantity,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // We need to pass the *current* product to the cart controller
                        Obx(
                          () => _buildAddButton(
                            displayProduct,
                            _cartController.getProductQuantity(
                              product.productId,
                              variantId: _selectedVariantId,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (variants.length > 1)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: variants
                            .map(
                              (variant) => ChoiceChip(
                                label: Text(
                                  formatQuantityString(
                                    variant.quantityValue,
                                    variant.quantityUnit,
                                  ),
                                ),
                                selected:
                                    variant.variantId == _selectedVariantId,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedVariantId = variant.variantId;
                                  });
                                },
                                selectedColor: const Color(0xFF1B8A4C),
                                labelStyle: TextStyle(
                                  color: variant.variantId == _selectedVariantId
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: Colors.white10,
                                side: BorderSide(
                                  color: variant.variantId == _selectedVariantId
                                      ? const Color(0xFF1B8A4C)
                                      : Colors.white24,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (variants.length > 1) const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            '₹${displayProduct.price.formatPrice}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'M.R.P: ₹${displayProduct.realPrice.formatPrice}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          if (hasProductOffer(displayProduct)) ...[
                            const SizedBox(width: 12),
                            Text(
                              buildProductOfferLabel(displayProduct),
                              style: TextStyle(
                                color: productOfferColor(context),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isBogoProduct(displayProduct))
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: offerTheme.badgeSoft,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: offerTheme.badgeBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BOGO free product',
                              style: TextStyle(
                                color: offerTheme.badge,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              selectedQuantity == 0
                                  ? 'Add this item to choose 1 free product from ${displayProduct.bogoFreeProductIds?.length ?? 0} options.'
                                  : selectedFreeProduct == null
                                  ? 'Choose your free product now.'
                                  : 'Selected free product for this offer.',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (selectedQuantity > 0) ...[
                              const SizedBox(height: 12),
                              if (selectedFreeProduct != null)
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 54,
                                        height: 54,
                                        color: cs.surface,
                                        child: Image.network(
                                          selectedFreeProduct.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.broken_image_outlined,
                                                  color: cs.onSurface
                                                      .withValues(
                                                        alpha: 0.4,
                                                      ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedFreeProduct.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: cs.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _selectedBogoFreeQuantity(
                                              displayProduct,
                                              selectedFreeProduct,
                                            ),
                                            style: TextStyle(
                                              color: cs.onSurface.withValues(
                                                alpha: 0.68,
                                              ),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 12),
                              FilledButton.tonalIcon(
                                onPressed: () =>
                                    _openBogoSelectionSheet(displayProduct),
                                style: FilledButton.styleFrom(
                                  backgroundColor: offerTheme.badge,
                                  foregroundColor: offerTheme.onBadge,
                                ),
                                icon: const Icon(Icons.card_giftcard_outlined),
                                label: Text(
                                  selectedFreeProduct == null
                                      ? 'Choose Free Product'
                                      : 'Change Free Product',
                                ),
                              ),
                            ],
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
                    _buildRelatedProducts(displayProduct),
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
            foregroundColor: const Color(0xFF1B8A4C),
            side: const BorderSide(color: Color(0xFF1B8A4C), width: 1.5),
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
          color: const Color(0xFF1B8A4C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _decrementQuantity(product),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.remove, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _incrementQuantity(product),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.add, color: Colors.white, size: 18),
              ),
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
                setState(() {
                  _selectedVariantId = inferProductVariantId(p);
                });
              },
              onAddPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
