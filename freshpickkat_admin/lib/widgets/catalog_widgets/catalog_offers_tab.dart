import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_category_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/screens/category_offers_screen.dart';
import 'package:freshpickkat_admin/screens/combo_offers_screen.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/product_form_dialog.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class CatalogOffersTab extends StatefulWidget {
  const CatalogOffersTab({
    super.key,
    required this.productController,
    required this.categoryController,
    required this.couponController,
    required this.categoryOfferController,
    required this.comboOfferController,
    required this.offerSearchQuery,
    required this.offerTypeFilter,
    required this.offerCategoryFilter,
    required this.onOfferSearchChanged,
    required this.onOfferCategoryChanged,
    required this.onOfferTypeChanged,
    required this.onRefresh,
  });

  final AdminProductController productController;
  final AdminCategoryController categoryController;
  final AdminCouponController couponController;
  final AdminCategoryOfferController categoryOfferController;
  final AdminComboOfferController comboOfferController;
  final String offerSearchQuery;
  final String offerTypeFilter;
  final String offerCategoryFilter;
  final ValueChanged<String> onOfferSearchChanged;
  final ValueChanged<String> onOfferCategoryChanged;
  final ValueChanged<String> onOfferTypeChanged;
  final Future<void> Function() onRefresh;

  @override
  State<CatalogOffersTab> createState() => _CatalogOffersTabState();
}

class _CatalogOffersTabState extends State<CatalogOffersTab> {
  AdminBogoController get _bogoController => AdminBogoController.instance;

  bool _isOfferLive(DateTime startDate, DateTime endDate, bool isActive) {
    final now = DateTime.now();
    return isActive && !startDate.isAfter(now) && !endDate.isBefore(now);
  }

  List<Product> _productsForComboOffer(
    ComboOffer offer,
    List<Product> products,
  ) {
    final byId = {
      for (final product in products)
        if ((product.productId ?? '').isNotEmpty) product.productId!: product,
    };
    return offer.comboProducts
        .map((item) => byId[item.productId])
        .whereType<Product>()
        .toList();
  }

  bool _comboOfferMatchesFilters(
    ComboOffer offer,
    List<Product> products,
  ) {
    final comboProducts = _productsForComboOffer(offer, products);
    if (comboProducts.isEmpty) return false;

    if (widget.offerCategoryFilter != 'All' &&
        !comboProducts.any((product) => product.category == widget.offerCategoryFilter)) {
      return false;
    }

    final query = widget.offerSearchQuery.toLowerCase().trim();
    if (query.isEmpty) return true;

    final joinedNames = comboProducts.map((product) => product.productName).join(' ');
    final joinedCategories = comboProducts.map((product) => product.category).join(' ');
    final joinedQuantities = comboProducts.map((product) => product.quantity).join(' ');
    return offer.name.toLowerCase().contains(query) ||
        joinedNames.toLowerCase().contains(query) ||
        joinedCategories.toLowerCase().contains(query) ||
        joinedQuantities.toLowerCase().contains(query);
  }

  double _comboProductsSellingTotal(
    ComboOffer offer,
    List<Product> products,
  ) {
    final byId = {
      for (final product in products)
        if ((product.productId ?? '').isNotEmpty) product.productId!: product,
    };
    double total = 0;
    for (final item in offer.comboProducts) {
      final product = byId[item.productId];
      if (product == null) continue;
      final variant = product.variants?.firstWhereOrNull(
        (entry) => entry.variantId == item.variantId,
      );
      total += (variant?.price ?? product.price) * item.quantity;
    }
    return total;
  }

  double _comboProductsMrpTotal(
    ComboOffer offer,
    List<Product> products,
  ) {
    final byId = {
      for (final product in products)
        if ((product.productId ?? '').isNotEmpty) product.productId!: product,
    };
    double total = 0;
    for (final item in offer.comboProducts) {
      final product = byId[item.productId];
      if (product == null) continue;
      final variant = product.variants?.firstWhereOrNull(
        (entry) => entry.variantId == item.variantId,
      );
      total += (variant?.realPrice ?? product.realPrice) * item.quantity;
    }
    return total;
  }

  double _comboFinalPrice(
    ComboOffer offer,
    List<Product> products,
  ) {
    final sellingTotal = _comboProductsSellingTotal(offer, products);
    if (offer.discountValue <= 0) return sellingTotal;
    if (offer.discountType == 'percentage') {
      return (sellingTotal * (1 - (offer.discountValue / 100)))
          .clamp(0, double.infinity);
    }
    return (sellingTotal - offer.discountValue).clamp(0, double.infinity);
  }

  String _formatMoney(double value) => '₹${value.toStringAsFixed(0)}';

  Future<void> _editComboOffer(ComboOffer offer) async {
    await showEditComboOfferDialog(
      context: context,
      controller: widget.comboOfferController,
      offer: offer,
    );
    if (!mounted) return;
    await widget.onRefresh();
  }

  Future<void> _toggleComboOffer(ComboOffer offer) async {
    final comboId = offer.comboId;
    if (comboId == null || comboId.isEmpty) return;
    final success = await widget.comboOfferController.toggleComboOffer(
      comboId,
      !offer.isActive,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Combo offer ${offer.isActive ? 'deactivated' : 'activated'}'
              : 'Failed to update combo offer',
        ),
      ),
    );
    if (success) {
      await widget.onRefresh();
    }
  }

  Future<void> _removeComboOffer(ComboOffer offer) async {
    final comboId = offer.comboId;
    if (comboId == null || comboId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Offer'),
        content: Text('Remove combo offer "${offer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final success = await widget.comboOfferController.deleteComboOffer(comboId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Combo offer removed' : 'Failed to remove combo offer',
        ),
      ),
    );
    if (success) {
      await widget.onRefresh();
    }
  }

  Widget _buildComboOfferCard(
    ComboOffer offer,
    List<Product> products,
  ) {
    final comboProducts = _productsForComboOffer(offer, products);
    final sellingTotal = _comboProductsSellingTotal(offer, products);
    final mrpTotal = _comboProductsMrpTotal(offer, products);
    final finalPrice = _comboFinalPrice(offer, products);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          const CatalogInlineBadge(
                            label: 'Combo Offer',
                            color: Colors.green,
                          ),
                          CatalogInlineBadge(
                            label: offer.isActive ? 'Active' : 'Inactive',
                            color: offer.isActive ? Colors.teal : Colors.redAccent,
                          ),
                          CatalogInlineBadge(
                            label: offer.discountType == 'percentage'
                                ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                                : 'Flat ${_formatMoney(offer.discountValue)} OFF',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  splashRadius: 18,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    switch (value) {
                      case 'toggle':
                        await _toggleComboOffer(offer);
                        break;
                      case 'edit':
                        await _editComboOffer(offer);
                        break;
                      case 'remove':
                        await _removeComboOffer(offer);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(Icons.toggle_on),
                          SizedBox(width: 8),
                          Text('Toggle Active'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Remove Offer',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: comboProducts.map((product) {
                final item = offer.comboProducts.firstWhereOrNull(
                  (entry) => entry.productId == product.productId,
                );
                final variant = product.variants?.firstWhereOrNull(
                  (entry) => entry.variantId == item?.variantId,
                );
                final quantityLabel = variant != null ? product.quantity : product.quantity;
                return Container(
                  width: 164,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.imageUrl,
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 42,
                            height: 42,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item?.quantity ?? 1}x • $quantityLabel',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('MRP ${_formatMoney(mrpTotal)}'),
                  Text('Selling ${_formatMoney(sellingTotal)}'),
                  Text(
                    'Combo ${_formatMoney(finalPrice)}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _categoryOfferMatchesFilters(CategoryOffer offer, List<Product> products) {
    if (widget.offerCategoryFilter != 'All' &&
        offer.categoryName != widget.offerCategoryFilter &&
        offer.categoryId != widget.offerCategoryFilter) {
      return false;
    }
    final query = widget.offerSearchQuery.toLowerCase().trim();
    if (query.isEmpty) return true;
    final categoryProducts = products
        .where(
          (product) =>
              product.category == offer.categoryName ||
              product.category == offer.categoryId,
        )
        .toList();
    final joinedNames =
        categoryProducts.map((product) => product.productName).join(' ');
    return offer.name.toLowerCase().contains(query) ||
        (offer.categoryName ?? '').toLowerCase().contains(query) ||
        joinedNames.toLowerCase().contains(query);
  }

  Future<void> _editCategoryOffer(CategoryOffer offer) async {
    await showEditCategoryOfferDialog(
      context: context,
      controller: widget.categoryOfferController,
      offer: offer,
    );
    if (!mounted) return;
    await widget.onRefresh();
  }

  Future<void> _toggleCategoryOffer(CategoryOffer offer) async {
    final offerId = offer.offerId;
    if (offerId == null || offerId.isEmpty) return;
    final success = await widget.categoryOfferController.toggleCategoryOffer(
      offerId,
      !offer.isActive,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Category offer ${offer.isActive ? 'deactivated' : 'activated'}'
              : 'Failed to update category offer',
        ),
      ),
    );
    if (success) {
      await widget.onRefresh();
    }
  }

  Future<void> _removeCategoryOffer(CategoryOffer offer) async {
    final offerId = offer.offerId;
    if (offerId == null || offerId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Offer'),
        content: Text('Remove category offer "${offer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final success = await widget.categoryOfferController.deleteCategoryOffer(
      offerId,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Category offer removed' : 'Failed to remove category offer',
        ),
      ),
    );
    if (success) {
      await widget.onRefresh();
    }
  }

  Widget _buildCategoryOfferCard(
    CategoryOffer offer,
    List<Product> products,
  ) {
    final categoryProducts = products
        .where(
          (product) =>
              product.category == offer.categoryName ||
              product.category == offer.categoryId,
        )
        .take(4)
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          const CatalogInlineBadge(
                            label: 'Category Offer',
                            color: Colors.green,
                          ),
                          CatalogInlineBadge(
                            label: offer.isActive ? 'Active' : 'Inactive',
                            color: offer.isActive ? Colors.teal : Colors.redAccent,
                          ),
                          CatalogInlineBadge(
                            label: offer.discountType == 'percentage'
                                ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                                : 'Flat ${_formatMoney(offer.discountValue)} OFF',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  splashRadius: 18,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    switch (value) {
                      case 'toggle':
                        await _toggleCategoryOffer(offer);
                        break;
                      case 'edit':
                        await _editCategoryOffer(offer);
                        break;
                      case 'remove':
                        await _removeCategoryOffer(offer);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(Icons.toggle_on),
                          SizedBox(width: 8),
                          Text('Toggle Active'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Remove Offer',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${offer.categoryName ?? offer.categoryId}',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            if ((offer.minOrderAmount ?? 0) > 0) ...[
              const SizedBox(height: 4),
              Text('Min order ${_formatMoney(offer.minOrderAmount!)}'),
            ],
            if ((offer.maxDiscount ?? 0) > 0) ...[
              const SizedBox(height: 4),
              Text('Max discount ${_formatMoney(offer.maxDiscount!)}'),
            ],
            if (categoryProducts.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryProducts.map((product) {
                  return Container(
                    width: 164,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.imageUrl,
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 42,
                              height: 42,
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.quantity,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _OfferCardActionType _primaryActionTypeFor(
    Product product,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) {
    if (isCatalogBogoOffer(product)) return _OfferCardActionType.bogo;
    if (isCatalogPercentageOffer(product) || isCatalogFlatOffer(product)) {
      return _OfferCardActionType.directDiscount;
    }
    if (_linkedCategoryOffer(product, categoryOffers) != null) {
      return _OfferCardActionType.categoryOffer;
    }
    if (_linkedComboOffer(product, comboOffers) != null) {
      return _OfferCardActionType.comboOffer;
    }
    return _OfferCardActionType.none;
  }

  CategoryOffer? _linkedCategoryOffer(
    Product product,
    List<CategoryOffer> categoryOffers,
  ) {
    final now = DateTime.now();
    final productId = product.productId;
    for (final offer in categoryOffers) {
      if (!offer.isActive ||
          offer.startDate.isAfter(now) ||
          offer.endDate.isBefore(now)) {
        continue;
      }
      if (productId != null &&
          (offer.excludeProductIds ?? const <String>[]).contains(productId)) {
        continue;
      }
      final productIds = offer.productIds ?? const <String>[];
      if (productIds.isNotEmpty && productId != null) {
        if (productIds.contains(productId)) return offer;
        continue;
      }
      if (offer.categoryName == product.category ||
          offer.categoryId == product.category) {
        return offer;
      }
    }
    return null;
  }

  ComboOffer? _linkedComboOffer(
    Product product,
    List<ComboOffer> comboOffers,
  ) {
    final now = DateTime.now();
    final productId = product.productId;
    if (productId == null) return null;
    for (final offer in comboOffers) {
      if (!offer.isActive ||
          offer.startDate.isAfter(now) ||
          offer.endDate.isBefore(now)) {
        continue;
      }
      if (offer.comboProducts.any((item) => item.productId == productId)) {
        return offer;
      }
    }
    return null;
  }

  Future<void> _editOfferForProduct(
    Product product,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    switch (_primaryActionTypeFor(product, categoryOffers, comboOffers)) {
      case _OfferCardActionType.bogo:
        final offer = _bogoController.bogoOffers.firstWhereOrNull(
          (item) => item.triggerProductId == product.productId,
        );
        if (offer == null) return;
        final saved = await BogoOfferEditorScreen.show(
          context: context,
          offer: offer,
          onSave: (updated) => _bogoController.upsertOffer(updated),
        );
        if (saved == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('BOGO offer updated successfully')),
          );
          await widget.onRefresh();
        }
        break;
      case _OfferCardActionType.directDiscount:
        final saved = await ProductFormDialog.show(
          context: context,
          product: product,
          categories: widget.categoryController.categories,
          onSubmit: (result) async {
            await widget.productController.updateProduct(result.product);
            final productId = product.productId;
            if (result.bogoSelections != null && productId != null) {
              await _saveBogoOfferConfiguration(
                triggerProductId: productId,
                selections: result.bogoSelections!,
              );
            }
            await widget.onRefresh();
          },
          groupedSubcategoryOptionsFor:
              widget.categoryController.groupedSubcategoryOptionsFor,
        );
        if (saved == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product offer updated')),
          );
          await widget.onRefresh();
        }
        break;
      case _OfferCardActionType.categoryOffer:
        final offer = _linkedCategoryOffer(product, categoryOffers);
        if (offer == null) return;
        await showEditCategoryOfferDialog(
          context: context,
          controller: widget.categoryOfferController,
          offer: offer,
        );
        if (!mounted) return;
        await widget.onRefresh();
        break;
      case _OfferCardActionType.comboOffer:
        final offer = _linkedComboOffer(product, comboOffers);
        if (offer == null) return;
        await showEditComboOfferDialog(
          context: context,
          controller: widget.comboOfferController,
          offer: offer,
        );
        if (!mounted) return;
        await widget.onRefresh();
        break;
      case _OfferCardActionType.none:
        break;
    }
  }

  Future<void> _saveBogoOfferConfiguration({
    required String triggerProductId,
    required List<BogoProductSelection> selections,
  }) async {
    final configuredFreeProducts = selections
        .where((s) => s.product.productId?.trim().isNotEmpty ?? false)
        .map(
          (s) => BogoFreeProduct(
            productId: s.product.productId!,
            quantity: s.freeQuantity,
          ),
        )
        .toList();

    if (configuredFreeProducts.isEmpty) return;

    await ServerpodAdminClient().client.bogo.upsertOffer(
      BogoOffer(
        triggerProductId: triggerProductId,
        freeProductIds: configuredFreeProducts.map((f) => f.productId).toList(),
        freeProducts: configuredFreeProducts,
        offerTitle: 'Buy 1 Get 1 Free',
        isActive: true,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _removeOfferForProduct(
    Product product,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    final actionType = _primaryActionTypeFor(product, categoryOffers, comboOffers);
    if (actionType == _OfferCardActionType.none) return;

    final confirmed = await _showRemoveConfirmation(
      actionType: actionType,
      product: product,
      categoryOffers: categoryOffers,
      comboOffers: comboOffers,
    );

    if (confirmed != true || !mounted) return;
    await widget.onRefresh();
  }

  bool _supportsToggle(_OfferCardActionType actionType) {
    switch (actionType) {
      case _OfferCardActionType.bogo:
      case _OfferCardActionType.categoryOffer:
      case _OfferCardActionType.comboOffer:
        return true;
      case _OfferCardActionType.directDiscount:
      case _OfferCardActionType.none:
        return false;
    }
  }

  Future<void> _toggleOfferForProduct(
    Product product,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final actionType = _primaryActionTypeFor(product, categoryOffers, comboOffers);
    bool success = false;
    String? statusLabel;

    switch (actionType) {
      case _OfferCardActionType.bogo:
        final offer = _bogoController.bogoOffers.firstWhereOrNull(
          (item) => item.triggerProductId == product.productId,
        );
        if (offer == null) break;
        final nextActive = !offer.isActive;
        success = await _bogoController.upsertOffer(
          offer.copyWith(isActive: nextActive),
        );
        statusLabel = nextActive ? 'activated' : 'deactivated';
        break;
      case _OfferCardActionType.categoryOffer:
        final offer = _linkedCategoryOffer(product, categoryOffers);
        final offerId = offer?.offerId;
        if (offer == null || offerId == null || offerId.isEmpty) break;
        final nextActive = !offer.isActive;
        success = await widget.categoryOfferController.toggleCategoryOffer(
          offerId,
          nextActive,
        );
        statusLabel = nextActive ? 'activated' : 'deactivated';
        break;
      case _OfferCardActionType.comboOffer:
        final offer = _linkedComboOffer(product, comboOffers);
        final comboId = offer?.comboId;
        if (offer == null || comboId == null || comboId.isEmpty) break;
        final nextActive = !offer.isActive;
        success = await widget.comboOfferController.toggleComboOffer(
          comboId,
          nextActive,
        );
        statusLabel = nextActive ? 'activated' : 'deactivated';
        break;
      case _OfferCardActionType.directDiscount:
      case _OfferCardActionType.none:
        return;
    }

    if (!mounted) return;
    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('${product.productName} offer ${statusLabel ?? 'updated'}'),
        ),
      );
      await widget.onRefresh();
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to update offer status')),
      );
    }
  }

  Future<bool?> _showRemoveConfirmation({
    required _OfferCardActionType actionType,
    required Product product,
    required List<CategoryOffer> categoryOffers,
    required List<ComboOffer> comboOffers,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final removeLabel = switch (actionType) {
      _OfferCardActionType.bogo => 'BOGO offer',
      _OfferCardActionType.directDiscount => 'product offer',
      _OfferCardActionType.categoryOffer => 'category offer',
      _OfferCardActionType.comboOffer => 'combo offer',
      _OfferCardActionType.none => 'offer',
    };

    return showDialog<bool>(
      context: context,
      builder: (context) {
        var isRemoving = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Remove Offer'),
            content: Text(
              'Remove the $removeLabel from "${product.productName}"?',
            ),
            actions: [
              TextButton(
                onPressed: isRemoving ? null : () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isRemoving
                    ? null
                    : () async {
                        setDialogState(() => isRemoving = true);
                        final success = await _performRemoveOffer(
                          actionType: actionType,
                          product: product,
                          categoryOffers: categoryOffers,
                          comboOffers: comboOffers,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context, success);
                        if (success) {
                          messenger.showSnackBar(
                            SnackBar(content: Text('${product.productName} offer removed')),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Failed to remove offer')),
                          );
                        }
                      },
                child: isRemoving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _performRemoveOffer({
    required _OfferCardActionType actionType,
    required Product product,
    required List<CategoryOffer> categoryOffers,
    required List<ComboOffer> comboOffers,
  }) async {
    try {
      switch (actionType) {
        case _OfferCardActionType.bogo:
          final productId = product.productId;
          if (productId == null) return false;
          return _bogoController.deleteOffer(productId);
        case _OfferCardActionType.directDiscount:
          await widget.productController.updateProduct(
            product.copyWith(
              discount: 0,
              discountValue: 0,
              discountType: 'percentage',
            ),
          );
          return true;
        case _OfferCardActionType.categoryOffer:
          final offer = _linkedCategoryOffer(product, categoryOffers);
          final offerId = offer?.offerId;
          if (offerId == null || offerId.isEmpty) return false;
          return widget.categoryOfferController.deleteCategoryOffer(offerId);
        case _OfferCardActionType.comboOffer:
          final offer = _linkedComboOffer(product, comboOffers);
          final comboId = offer?.comboId;
          if (comboId == null || comboId.isEmpty) return false;
          return widget.comboOfferController.deleteComboOffer(comboId);
        case _OfferCardActionType.none:
          return false;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = widget.productController.products;
      final categories = widget.categoryController.categories;
      final bogoOffers = _bogoController.bogoOffers;
      final categoryOffers = widget.categoryOfferController.categoryOffers;
      final comboOffers = widget.comboOfferController.comboOffers;
      final isLoading = widget.productController.isLoading.value;
      final error = widget.productController.error.value;

      if (isLoading && products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && products.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      final visibleProducts = filterCatalogOfferProducts(
        products: products,
        categoryOffers: categoryOffers,
        comboOffers: comboOffers,
        query: widget.offerSearchQuery,
        offerTypeFilter: widget.offerTypeFilter,
        categoryFilter: widget.offerCategoryFilter,
      );
      final visibleComboOffers = comboOffers
          .where((offer) => _comboOfferMatchesFilters(offer, products))
          .toList();
      final visibleCategoryOffers = categoryOffers
          .where((offer) => _categoryOfferMatchesFilters(offer, products))
          .toList();
      final bogoCount = bogoOffers.length;
      final noOfferCount = products.where((product) {
        return !hasCatalogAnyLiveOffer(
          product,
          categoryOffers: categoryOffers,
          comboOffers: comboOffers,
        );
      }).length;
      final percentageCount = products.where(isCatalogPercentageOffer).length;
      final flatCount = products.where(isCatalogFlatOffer).length;
      final directOfferCount = percentageCount + flatCount;
      final liveDirectOfferCount = products.where((product) {
        return isCatalogPercentageOffer(product) || isCatalogFlatOffer(product);
      }).length;
      final liveBogoOfferCount = bogoOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveCategoryOfferCount = categoryOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveComboOfferCount = comboOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final allOfferCount =
          directOfferCount +
          bogoOffers.length +
          categoryOffers.length +
          comboOffers.length;
      final liveOfferCount =
          liveDirectOfferCount +
          liveBogoOfferCount +
          liveCategoryOfferCount +
          liveComboOfferCount;

      final categoryOptions = <ProductFilterOption>[
        const ProductFilterOption(value: 'All', label: 'All'),
        ...categories.map(
          (category) => ProductFilterOption(
            value: category.categoryName,
            label: category.categoryName,
          ),
        ),
      ];

      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          children: [
            SizedBox(
              height: 76,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CatalogStatCard(
                    title: 'All',
                    value: '$allOfferCount',
                    icon: Icons.grid_view_rounded,
                    color: const Color(0xFF335C4B),
                    compact: true,
                    selected: widget.offerTypeFilter == 'all',
                    onTap: () => widget.onOfferTypeChanged('all'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'Live',
                    value: '$liveOfferCount',
                    icon: Icons.local_offer,
                    color: const Color(0xFF1F6B4F),
                    compact: true,
                    selected: widget.offerTypeFilter == 'live',
                    onTap: () => widget.onOfferTypeChanged('live'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'BOGO',
                    value: '$bogoCount',
                    icon: Icons.card_giftcard,
                    color: const Color(0xFF2B7A78),
                    compact: true,
                    selected: widget.offerTypeFilter == 'bogo',
                    onTap: () => widget.onOfferTypeChanged('bogo'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'Category Offers',
                    value: '$liveCategoryOfferCount',
                    icon: Icons.category_outlined,
                    color: const Color(0xFF3A5F6F),
                    compact: true,
                    selected: widget.offerTypeFilter == 'category_offer',
                    onTap: () => widget.onOfferTypeChanged('category_offer'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'Combo Offers',
                    value: '$liveComboOfferCount',
                    icon: Icons.widgets_outlined,
                    color: const Color(0xFF4F7D63),
                    compact: true,
                    selected: widget.offerTypeFilter == 'combo_offer',
                    onTap: () => widget.onOfferTypeChanged('combo_offer'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'Percentage',
                    value: '$percentageCount',
                    icon: Icons.percent,
                    color: const Color(0xFF46627A),
                    compact: true,
                    selected: widget.offerTypeFilter == 'percentage',
                    onTap: () => widget.onOfferTypeChanged('percentage'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'Flat',
                    value: '$flatCount',
                    icon: Icons.currency_rupee,
                    color: const Color(0xFF5B6B5F),
                    compact: true,
                    selected: widget.offerTypeFilter == 'flat',
                    onTap: () => widget.onOfferTypeChanged('flat'),
                  ),
                  const SizedBox(width: 10),
                  CatalogStatCard(
                    title: 'No Offer',
                    value: '$noOfferCount',
                    icon: Icons.remove_circle_outline,
                    color: const Color(0xFF66706C),
                    compact: true,
                    selected: widget.offerTypeFilter == 'none',
                    onTap: () => widget.onOfferTypeChanged('none'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ProductSearchAndCategoryControls(
              searchHintText: 'Search product or offer',
              onSearchChanged: widget.onOfferSearchChanged,
              categoryOptions: categoryOptions,
              selectedCategory: widget.offerCategoryFilter,
              onCategorySelected: widget.onOfferCategoryChanged,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.offerTypeFilter == 'combo_offer'
                        ? 'Combo Offers'
                        : widget.offerTypeFilter == 'category_offer'
                            ? 'Category Offers'
                            : 'Products by Offer',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  widget.offerTypeFilter == 'combo_offer'
                      ? '${visibleComboOffers.length} items'
                      : widget.offerTypeFilter == 'category_offer'
                          ? '${visibleCategoryOffers.length} items'
                          : '${visibleProducts.length} items',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.offerTypeFilter == 'combo_offer' &&
                visibleComboOffers.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No combo offers matched the selected filters'),
                ),
              )
            else if (widget.offerTypeFilter == 'category_offer' &&
                visibleCategoryOffers.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No category offers matched the selected filters'),
                ),
              )
            else if (widget.offerTypeFilter == 'combo_offer')
              ...visibleComboOffers.map(
                (offer) => _buildComboOfferCard(offer, products),
              )
            else if (widget.offerTypeFilter == 'category_offer')
              ...visibleCategoryOffers.map(
                (offer) => _buildCategoryOfferCard(offer, products),
              )
            else if (visibleProducts.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No products matched the selected offer filters'),
                ),
              )
            else
              ...visibleProducts.map((product) {
                final actionType = _primaryActionTypeFor(
                  product,
                  categoryOffers,
                  comboOffers,
                );
                final hasActions = actionType != _OfferCardActionType.none;
                final supportsToggle = _supportsToggle(actionType);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.imageUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.category} • ${product.quantity}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  CatalogInlineBadge(
                                    label: catalogProductOfferLabelWithLinkedOffers(
                                      product,
                                      categoryOffers: categoryOffers,
                                      comboOffers: comboOffers,
                                    ),
                                    color: hasCatalogAnyLiveOffer(
                                      product,
                                      categoryOffers: categoryOffers,
                                      comboOffers: comboOffers,
                                    )
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  CatalogInlineBadge(
                                    label: product.isAvailable
                                        ? 'Available'
                                        : 'Out of stock',
                                    color: product.isAvailable
                                        ? Colors.teal
                                        : Colors.redAccent,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${product.price.toStringAsFixed(0)} • MRP ₹${product.realPrice.toStringAsFixed(0)}',
                              ),
                            ],
                          ),
                        ),
                        if (hasActions) ...[
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            splashRadius: 18,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              switch (value) {
                                case 'toggle':
                                  await _toggleOfferForProduct(
                                    product,
                                    categoryOffers,
                                    comboOffers,
                                  );
                                  break;
                                case 'edit':
                                  await _editOfferForProduct(
                                    product,
                                    categoryOffers,
                                    comboOffers,
                                  );
                                  break;
                                case 'remove':
                                  await _removeOfferForProduct(
                                    product,
                                    categoryOffers,
                                    comboOffers,
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              if (supportsToggle)
                                const PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(Icons.toggle_on),
                                      SizedBox(width: 8),
                                      Text('Toggle Active'),
                                    ],
                                  ),
                                ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Remove Offer',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}

enum _OfferCardActionType {
  none,
  directDiscount,
  bogo,
  categoryOffer,
  comboOffer,
}
