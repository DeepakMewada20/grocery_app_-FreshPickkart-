import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/combo_product_preview_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';

/// Screen shown when user taps a "combo" type banner.
class ComboOffersScreen extends StatefulWidget {
  /// Optional — if set, scroll/highlight this combo
  final String? highlightComboId;

  const ComboOffersScreen({super.key, this.highlightComboId});

  @override
  State<ComboOffersScreen> createState() => _ComboOffersScreenState();
}

class _ComboOffersScreenState extends State<ComboOffersScreen> {
  final _comboController = ComboOfferController.instance;
  final _productController = ProductProviderController.instance;
  String? _selectedComboId;
  Worker? _comboWorker;

  @override
  void initState() {
    super.initState();
    _selectedComboId = widget.highlightComboId;
    if (_comboController.activeComboOffers.isEmpty) {
      _comboController.fetchActiveComboOffers();
    }
    _prefetchComboProducts();
    _comboWorker = ever<List<ComboOffer>>(
      _comboController.activeComboOffers,
      (_) => _prefetchComboProducts(),
    );
  }

  void _prefetchComboProducts() {
    final ids = _comboController.activeComboOffers
        .expand((combo) => combo.comboProducts)
        .map((item) => item.productId)
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList();
    if (ids.isEmpty) return;
    _productController.fetchProductsByIds(ids);
  }

  @override
  void dispose() {
    _comboWorker?.dispose();
    super.dispose();
  }

  List<ResolvedComboProduct> _getProductsForCombo(ComboOffer combo) {
    return resolveComboProducts(combo, _productController.allProducts);
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
          'Combo Deals',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_comboController.isLoading.value &&
              _comboController.activeComboOffers.isEmpty) {
            return const ProductGridShimmer(
              itemCount: 4,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }

          final combos = _comboController.activeComboOffers;

          if (combos.isEmpty) {
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
                      Icons.shopping_basket_outlined,
                      size: 56,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No combo deals right now',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back soon for exciting bundle deals.',
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
                    final count = _comboController.activeComboOffers.length;
                    return Row(
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 18,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$count combo${count == 1 ? '' : 's'} available',
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
                  child: ListView.builder(
                    itemCount: combos.length,
                    itemBuilder: (context, index) {
                      final combo = combos[index];
                      final isSelected = combo.comboId == _selectedComboId;
                      final products = _getProductsForCombo(combo);
                      return _ComboCard(
                        combo: combo,
                        products: products,
                        isHighlighted: isSelected,
                        onTap: () => setState(() {
                          _selectedComboId = _selectedComboId == combo.comboId
                              ? null
                              : combo.comboId;
                        }),
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

class _ComboCard extends StatelessWidget {
  final ComboOffer combo;
  final List<ResolvedComboProduct> products;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _ComboCard({
    required this.combo,
    required this.products,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartController = CartController.instance;
    final screenWidth = MediaQuery.of(context).size.width;

    final discountLabel = comboDiscountBadgeText(
      combo.discountType,
      combo.discountValue,
    );
    final originalUnitTotal = calculateComboOriginalUnitTotal(products);
    final comboUnitTotal = applyComboDiscount(
      originalTotal: originalUnitTotal,
      discountType: combo.discountType,
      discountValue: combo.discountValue,
    );

    final productCardWidth = ((screenWidth - 84) / 2).clamp(132.0, 164.0);
    final productStripHeight = productCardWidth * 1.38;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted ? AppTheme.primaryGreen : cs.outlineVariant,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            discountLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          combo.name,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (combo.description != null &&
                            combo.description!.isNotEmpty)
                          Text(
                            combo.description!,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '₹${comboUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '₹${originalUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.4),
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isHighlighted
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),

          // Expandable product list
          if (isHighlighted && products.isNotEmpty) ...[
            Divider(color: cs.outlineVariant, height: 1),
            SizedBox(
              height: productStripHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == products.length - 1 ? 0 : 12,
                    ),
                    child: SizedBox(
                      width: productCardWidth,
                      child: ComboProductPreviewCard(item: products[index]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    cartController.addComboOffer(combo);
                    Get.snackbar(
                      'Added to Basket',
                      '${products.length} combo products added from ${combo.name}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppTheme.primaryGreen,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add Combo to Basket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],

          if (isHighlighted && products.isEmpty) ...[
            Divider(color: cs.outlineVariant, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Products loading...',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
