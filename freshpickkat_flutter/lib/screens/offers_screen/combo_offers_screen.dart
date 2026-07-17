import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/combo_offer_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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
  final _networkController = NetworkController.instance;
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

    ever(_networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (_networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('combo')) {
          _comboController.fetchActiveComboOffers();
          _productController.fetchProducts();
        }
      }
    });
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
            return ProductGridShimmer(
              itemCount: 4,
              padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(12), vertical: ScreenScale.h(8)),
            );
          }

          final combos = _comboController.activeComboOffers;

          if (combos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(ScreenScale.w(28)),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket_outlined,
                      size: ScreenScale.r(56),
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  SizedBox(height: ScreenScale.h(20)),
                  Text(
                    'No combo deals right now',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: ScreenScale.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ScreenScale.h(8)),
                  Text(
                    'Check back soon for exciting bundle deals.',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: ScreenScale.sp(14),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(12), vertical: ScreenScale.h(8)),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenScale.w(12),
                    vertical: ScreenScale.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(ScreenScale.r(14)),
                  ),
                  child: Obx(() {
                    final count = _comboController.activeComboOffers.length;
                    return Row(
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: ScreenScale.r(18),
                          color: AppTheme.primaryGreen,
                        ),
                        SizedBox(width: ScreenScale.w(8)),
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
                SizedBox(height: ScreenScale.h(12)),
                Expanded(
                  child: AppResponsive.constrainContent(
                    context: context,
                    maxWidth: AppResponsive.maxReadableWidth,
                    child: ListView.builder(
                      itemCount: combos.length,
                      itemBuilder: (context, index) {
                        final combo = combos[index];
                        final isSelected = combo.comboId == _selectedComboId;
                        final products = _getProductsForCombo(combo);
                        return ComboOfferCard(
                          combo: combo,
                          products: products,
                          isExpanded: isSelected,
                          isHighlighted: isSelected,
                          onTap: () => setState(() {
                            _selectedComboId = _selectedComboId == combo.comboId
                                ? null
                                : combo.comboId;
                          }),
                          margin: EdgeInsets.only(bottom: ScreenScale.h(16)),
                        );
                      },
                    ),
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
