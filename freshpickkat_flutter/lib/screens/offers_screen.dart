import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';

/// Screen shown when user taps an "offer" type banner.
/// Displays all products that have an active offer/discount.
class OffersScreen extends StatefulWidget {
  /// Optional — if set, a specific offer card is highlighted/scrolled to.
  final String? highlightOfferId;

  const OffersScreen({super.key, this.highlightOfferId});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final _productController = ProductProviderController.instance;
  final _networkController = NetworkController.instance;
  String _sortBy = 'discount'; // 'discount' | 'price_low' | 'price_high'

  @override
  void initState() {
    super.initState();
    ever(_networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (_networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('offers')) {
          _productController.fetchProducts();
        }
      }
    });
  }

  List<Product> get _filteredProducts {
    final products = _productController.allProducts.where((p) {
      final hasDiscount =
          p.discountType != null &&
          p.discountType!.isNotEmpty &&
          p.realPrice > p.price;

      // Also include BOGO products
      final isBogo =
          p.bogoFreeProductIds != null && p.bogoFreeProductIds!.isNotEmpty;

      return hasDiscount || isBogo;
    }).toList();

    switch (_sortBy) {
      case 'discount':
        products.sort((a, b) {
          final discA = a.realPrice - a.price;
          final discB = b.realPrice - b.price;
          return discB.compareTo(discA);
        });
        break;
      case 'price_low':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text(
          'Special Offers',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort_rounded, color: cs.onSurface),
            tooltip: 'Sort',
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'discount',
                child: Row(
                  children: [
                    Icon(
                      Icons.percent,
                      size: 18,
                      color: _sortBy == 'discount'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Best Discount',
                      style: TextStyle(
                        fontWeight: _sortBy == 'discount'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'discount'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'price_low',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: _sortBy == 'price_low'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price: Low to High',
                      style: TextStyle(
                        fontWeight: _sortBy == 'price_low'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'price_low'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'price_high',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: _sortBy == 'price_high'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price: High to Low',
                      style: TextStyle(
                        fontWeight: _sortBy == 'price_high'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'price_high'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final isLoading = _productController.isLoading.value;
          final hasData = _productController.hasData;

          if (isLoading && !hasData) {
            return ProductGridShimmer(
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }

          final products = _filteredProducts;

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 56,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No offers right now',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back soon for exciting deals.',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Obx(() {
                    final count = _filteredProducts.length;
                    return Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 18,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$count deal${count == 1 ? '' : 's'} available',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.59,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        onAddPressed: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
