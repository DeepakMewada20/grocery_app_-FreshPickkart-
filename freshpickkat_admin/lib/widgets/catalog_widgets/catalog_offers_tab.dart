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
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  bool _handleScrollNotification(ScrollNotification notification) {
    final isProductBackedFilter =
        widget.offerTypeFilter != 'combo_offer' &&
        widget.offerTypeFilter != 'category_offer';
    if (!isProductBackedFilter) return false;
    if (notification.metrics.pixels <
        notification.metrics.maxScrollExtent - 240) {
      return false;
    }
    widget.productController.loadMore();
    return false;
  }

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

  bool _comboOfferMatchesFilters(ComboOffer offer, List<Product> products) {
    final comboProducts = _productsForComboOffer(offer, products);
    if (comboProducts.isEmpty) return false;

    if (widget.offerCategoryFilter != 'All' &&
        !comboProducts.any(
          (product) => product.category == widget.offerCategoryFilter,
        )) {
      return false;
    }

    final query = widget.offerSearchQuery.toLowerCase().trim();
    if (query.isEmpty) return true;

    final joinedNames = comboProducts
        .map((product) => product.productName)
        .join(' ');
    final joinedCategories = comboProducts
        .map((product) => product.category)
        .join(' ');
    final joinedQuantities = comboProducts
        .map((product) => product.quantity)
        .join(' ');
    return offer.name.toLowerCase().contains(query) ||
        joinedNames.toLowerCase().contains(query) ||
        joinedCategories.toLowerCase().contains(query) ||
        joinedQuantities.toLowerCase().contains(query);
  }

  double _comboProductsSellingTotal(ComboOffer offer, List<Product> products) {
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

  double _comboProductsMrpTotal(ComboOffer offer, List<Product> products) {
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

  double _comboFinalPrice(ComboOffer offer, List<Product> products) {
    final sellingTotal = _comboProductsSellingTotal(offer, products);
    if (offer.discountValue <= 0) return sellingTotal;
    if (offer.discountType == 'percentage') {
      return (sellingTotal * (1 - (offer.discountValue / 100))).clamp(
        0,
        double.infinity,
      );
    }
    return (sellingTotal - offer.discountValue).clamp(0, double.infinity);
  }

  String _formatMoney(double value) => '₹${value.toStringAsFixed(0)}';

  BogoOffer? _linkedBogoOffer(Product product, List<BogoOffer> bogoOffers) {
    final productId = product.productId;
    if (productId == null) return null;
    return bogoOffers.firstWhereOrNull(
      (offer) => offer.triggerProductId == productId,
    );
  }

  bool _isBogoOfferActive(Product product, List<BogoOffer> bogoOffers) {
    final offer = _linkedBogoOffer(product, bogoOffers);
    return offer?.isActive ?? false;
  }

  bool _isDirectOfferActive(Product product) {
    return (hasCatalogConfiguredPercentageOffer(product) ||
            hasCatalogConfiguredFlatOffer(product)) &&
        product.realPrice > 0 &&
        product.price < product.realPrice;
  }

  double _priceForDirectOffer({
    required double realPrice,
    required String? discountType,
    required double discountValue,
  }) {
    if (realPrice <= 0 || discountValue <= 0) return realPrice;
    if (discountType == 'flat') {
      return (realPrice - discountValue).clamp(0, double.infinity);
    }
    return (realPrice * (1 - (discountValue / 100))).clamp(0, double.infinity);
  }

  Product _buildDirectDiscountProduct(
    Product product, {
    required bool isActive,
    bool clearOffer = false,
  }) {
    final discountType = product.discountType;
    final configuredDiscountValue = discountType == 'flat'
        ? (product.discountValue ?? catalogFlatDiscountValue(product))
        : (product.discountValue ?? product.discount);
    final discountValue = clearOffer ? 0.0 : configuredDiscountValue;

    final updatedVariants = product.variants?.map((variant) {
      final nextPrice = clearOffer || !isActive
          ? variant.realPrice
          : _priceForDirectOffer(
              realPrice: variant.realPrice,
              discountType: discountType,
              discountValue: discountValue,
            );
      return variant.copyWith(price: nextPrice);
    }).toList();

    final primaryVariant = updatedVariants?.firstOrNull;
    final nextRealPrice = primaryVariant?.realPrice ?? product.realPrice;
    final nextPrice =
        primaryVariant?.price ??
        (clearOffer || !isActive
            ? product.realPrice
            : _priceForDirectOffer(
                realPrice: product.realPrice,
                discountType: discountType,
                discountValue: discountValue,
              ));

    return product.copyWith(
      price: nextPrice,
      realPrice: nextRealPrice,
      discount: isActive && !clearOffer && discountType == 'percentage'
          ? discountValue
          : 0,
      discountType: clearOffer
          ? (discountType == 'flat' ? 'flat' : 'percentage')
          : discountType,
      discountValue: clearOffer ? 0 : discountValue,
      variants: updatedVariants,
    );
  }

  Future<void> _editComboOffer(ComboOffer offer) async {
    await showEditComboOfferDialog(
      context: context,
      controller: widget.comboOfferController,
      offer: offer,
    );
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
  }

  Future<void> _removeComboOffer(ComboOffer offer) async {
    final comboId = offer.comboId;
    if (comboId == null || comboId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Offer'),
        content: Text('Remove combo offer "${offer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Remove',
              style: TextStyle(color: AdminAppTheme.getErrorColor(context)),
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
  }

  Widget _buildComboOfferCard(ComboOffer offer, List<Product> products) {
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
                          CatalogInlineBadge(
                            label: 'Combo Offer',
                            color: AdminAppTheme.getSuccessColor(context),
                          ),
                          CatalogInlineBadge(
                            label: offer.isActive ? 'Active' : 'Inactive',
                            color: offer.isActive
                                ? AdminAppTheme.getSuccessColor(context)
                                : AdminAppTheme.getErrorColor(context),
                          ),
                          CatalogInlineBadge(
                            label: offer.discountType == 'percentage'
                                ? 'MORE ${offer.discountValue.toStringAsFixed(0)}% OFF'
                                : 'MORE ${_formatMoney(offer.discountValue)} OFF',
                            color: AdminAppTheme.getWarningColor(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  splashRadius: 18,
                  icon: Icon(Icons.more_vert),
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
                  itemBuilder: (context) => [
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
                          Icon(
                            Icons.delete_outline,
                            color: AdminAppTheme.getErrorColor(context),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Remove Offer',
                            style: TextStyle(
                              color: AdminAppTheme.getErrorColor(context),
                            ),
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
                final quantityLabel = variant != null
                    ? product.quantity
                    : product.quantity;
                return Container(
                  width: 164.w.clamp(148.0, 190.0).toDouble(),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getSuccessColor(
                      context,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AdminAppTheme.getBorderColor(context),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.imageUrl,
                          width: 42.r,
                          height: 42.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 42.r,
                                height: 42.r,
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ).withValues(alpha: 0.15),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 18,
                                ),
                              ),
                        ),
                      ),
                      SizedBox(width: 8.w),
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
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ),
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
                color: AdminAppTheme.getSuccessColor(
                  context,
                ).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AdminAppTheme.getSuccessColor(
                    context,
                  ).withValues(alpha: 0.15),
                ),
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
                      color: AdminAppTheme.getSuccessColor(context),
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

  bool _categoryOfferMatchesFilters(
    CategoryOffer offer,
    List<Product> products,
  ) {
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
    final joinedNames = categoryProducts
        .map((product) => product.productName)
        .join(' ');
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
  }

  Future<void> _removeCategoryOffer(CategoryOffer offer) async {
    final offerId = offer.offerId;
    if (offerId == null || offerId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Offer'),
        content: Text('Remove category offer "${offer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Remove',
              style: TextStyle(color: AdminAppTheme.getErrorColor(context)),
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
          success
              ? 'Category offer removed'
              : 'Failed to remove category offer',
        ),
      ),
    );
  }

  Widget _buildCategoryOfferCard(CategoryOffer offer, List<Product> products) {
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
                          CatalogInlineBadge(
                            label: 'Category Offer',
                            color: AdminAppTheme.getSuccessColor(context),
                          ),
                          CatalogInlineBadge(
                            label: offer.isActive ? 'Active' : 'Inactive',
                            color: offer.isActive
                                ? AdminAppTheme.getSuccessColor(context)
                                : AdminAppTheme.getErrorColor(context),
                          ),
                          CatalogInlineBadge(
                            label: offer.discountType == 'percentage'
                                ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                                : 'Flat ${_formatMoney(offer.discountValue)} OFF',
                            color: AdminAppTheme.getWarningColor(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  splashRadius: 18,
                  icon: Icon(Icons.more_vert),
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
                  itemBuilder: (context) => [
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
                          Icon(
                            Icons.delete_outline,
                            color: AdminAppTheme.getErrorColor(context),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Remove Offer',
                            style: TextStyle(
                              color: AdminAppTheme.getErrorColor(context),
                            ),
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
                color: AdminAppTheme.getTextSecondaryColor(context),
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
                    width: 164.w.clamp(148.0, 190.0).toDouble(),
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AdminAppTheme.getSuccessColor(
                        context,
                      ).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AdminAppTheme.getBorderColor(context),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.imageUrl,
                            width: 42.r,
                            height: 42.r,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 42.r,
                                  height: 42.r,
                                  color: AdminAppTheme.getTextSecondaryColor(
                                    context,
                                  ).withValues(alpha: 0.15),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 18,
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                                  color: AdminAppTheme.getTextSecondaryColor(
                                    context,
                                  ),
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
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) {
    if (hasCatalogConfiguredBogoOffer(product, bogoOffers: bogoOffers)) {
      return _OfferCardActionType.bogo;
    }
    if (hasCatalogConfiguredPercentageOffer(product) ||
        hasCatalogConfiguredFlatOffer(product)) {
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

  _OfferCardActionType _actionTypeForCurrentFilter(
    Product product,
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) {
    switch (widget.offerTypeFilter) {
      case 'bogo':
        return hasCatalogConfiguredBogoOffer(product, bogoOffers: bogoOffers)
            ? _OfferCardActionType.bogo
            : _OfferCardActionType.none;
      case 'percentage':
      case 'flat':
        return hasCatalogConfiguredPercentageOffer(product) ||
                hasCatalogConfiguredFlatOffer(product)
            ? _OfferCardActionType.directDiscount
            : _OfferCardActionType.none;
      case 'category_offer':
        return _linkedCategoryOffer(product, categoryOffers) != null
            ? _OfferCardActionType.categoryOffer
            : _OfferCardActionType.none;
      case 'combo_offer':
        return _linkedComboOffer(product, comboOffers) != null
            ? _OfferCardActionType.comboOffer
            : _OfferCardActionType.none;
      default:
        return _primaryActionTypeFor(
          product,
          bogoOffers,
          categoryOffers,
          comboOffers,
        );
    }
  }

  String _offerBadgeLabelForCurrentFilter(
    Product product,
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) {
    switch (_actionTypeForCurrentFilter(
      product,
      bogoOffers,
      categoryOffers,
      comboOffers,
    )) {
      case _OfferCardActionType.bogo:
        final offer = _linkedBogoOffer(product, bogoOffers);
        final freeCount =
            offer?.freeProductIds.length ??
            (product.bogoFreeProductIds ?? const <String>[]).length;
        return freeCount > 0 ? 'BOGO • $freeCount free choices' : 'BOGO';
      case _OfferCardActionType.directDiscount:
        return catalogProductOfferLabel(product);
      case _OfferCardActionType.categoryOffer:
        return 'Category Offer';
      case _OfferCardActionType.comboOffer:
        return 'Combo Offer';
      case _OfferCardActionType.none:
        return catalogProductOfferLabelWithLinkedOffers(
          product,
          bogoOffers: bogoOffers,
          categoryOffers: categoryOffers,
          comboOffers: comboOffers,
        );
    }
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

  ComboOffer? _linkedComboOffer(Product product, List<ComboOffer> comboOffers) {
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
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    switch (_actionTypeForCurrentFilter(
      product,
      bogoOffers,
      categoryOffers,
      comboOffers,
    )) {
      case _OfferCardActionType.bogo:
        final offer = _linkedBogoOffer(product, bogoOffers);
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
          },
          groupedSubcategoryOptionsFor:
              widget.categoryController.subcategoryOptionsWithImagesFor,
        );
        if (saved == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product offer updated')),
          );
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
        break;
      case _OfferCardActionType.comboOffer:
        final offer = _linkedComboOffer(product, comboOffers);
        if (offer == null) return;
        await showEditComboOfferDialog(
          context: context,
          controller: widget.comboOfferController,
          offer: offer,
        );
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
            variantId: s.variant?.variantId,
          ),
        )
        .toList();

    if (configuredFreeProducts.isEmpty) return;

    await _bogoController.upsertOffer(
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
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    final actionType = _actionTypeForCurrentFilter(
      product,
      bogoOffers,
      categoryOffers,
      comboOffers,
    );
    if (actionType == _OfferCardActionType.none) return;

    final confirmed = await _showRemoveConfirmation(
      actionType: actionType,
      product: product,
      bogoOffers: bogoOffers,
      categoryOffers: categoryOffers,
      comboOffers: comboOffers,
    );
    if (confirmed != true || !mounted) return;
  }

  bool _supportsToggle(_OfferCardActionType actionType) {
    switch (actionType) {
      case _OfferCardActionType.bogo:
      case _OfferCardActionType.directDiscount:
      case _OfferCardActionType.categoryOffer:
      case _OfferCardActionType.comboOffer:
        return true;
      case _OfferCardActionType.none:
        return false;
    }
  }

  Future<void> _toggleOfferForProduct(
    Product product,
    List<BogoOffer> bogoOffers,
    List<CategoryOffer> categoryOffers,
    List<ComboOffer> comboOffers,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final actionType = _actionTypeForCurrentFilter(
      product,
      bogoOffers,
      categoryOffers,
      comboOffers,
    );
    bool success = false;
    String? statusLabel;

    switch (actionType) {
      case _OfferCardActionType.bogo:
        final offer = _linkedBogoOffer(product, bogoOffers);
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
        final nextActive = !_isDirectOfferActive(product);
        await widget.productController.updateProduct(
          _buildDirectDiscountProduct(product, isActive: nextActive),
        );
        success = true;
        statusLabel = nextActive ? 'activated' : 'deactivated';
        break;
      case _OfferCardActionType.none:
        return;
    }

    if (!mounted) return;
    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${product.productName} offer ${statusLabel ?? 'updated'}',
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to update offer status')),
      );
    }
  }

  Future<bool?> _showRemoveConfirmation({
    required _OfferCardActionType actionType,
    required Product product,
    required List<BogoOffer> bogoOffers,
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
            title: Text('Remove Offer'),
            content: Text(
              'Remove the $removeLabel from "${product.productName}"?',
            ),
            actions: [
              TextButton(
                onPressed: isRemoving
                    ? null
                    : () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: isRemoving
                    ? null
                    : () async {
                        setDialogState(() => isRemoving = true);
                        final success = await _performRemoveOffer(
                          actionType: actionType,
                          product: product,
                          bogoOffers: bogoOffers,
                          categoryOffers: categoryOffers,
                          comboOffers: comboOffers,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context, success);
                        if (success) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.productName} offer removed',
                              ),
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Failed to remove offer'),
                            ),
                          );
                        }
                      },
                child: isRemoving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Remove',
                        style: TextStyle(
                          color: AdminAppTheme.getErrorColor(context),
                        ),
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
    required List<BogoOffer> bogoOffers,
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
            _buildDirectDiscountProduct(
              product,
              isActive: false,
              clearOffer: true,
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
        return AdminStateView.error(
          message: error,
          onRetry: () => widget.productController.loadInitial(),
        );
      }

      final visibleProducts = filterCatalogOfferProducts(
        products: products,
        bogoOffers: bogoOffers,
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
      final activeBogoOfferCount = bogoOffers
          .where((offer) => offer.isActive)
          .length;
      final inactiveBogoOfferCount = bogoCount - activeBogoOfferCount;
      final noOfferCount = products.where((product) {
        return !hasCatalogAnyLiveOffer(
          product,
          bogoOffers: bogoOffers,
          categoryOffers: categoryOffers,
          comboOffers: comboOffers,
        );
      }).length;
      final percentageCount = products
          .where(hasCatalogConfiguredPercentageOffer)
          .length;
      final activePercentageCount = products
          .where(hasCatalogActivePercentageOffer)
          .length;
      final inactivePercentageCount = percentageCount - activePercentageCount;
      final flatCount = products.where(hasCatalogConfiguredFlatOffer).length;
      final activeFlatCount = products.where(hasCatalogActiveFlatOffer).length;
      final inactiveFlatCount = flatCount - activeFlatCount;
      final directOfferCount = percentageCount + flatCount;
      final liveDirectOfferCount = products.where((product) {
        return isCatalogPercentageOffer(product) || isCatalogFlatOffer(product);
      }).length;
      final liveBogoOfferCount = bogoOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final totalCategoryOfferCount = categoryOffers.length;
      final activeCategoryOfferCount = categoryOffers
          .where((offer) => offer.isActive)
          .length;
      final liveCategoryOfferCount = categoryOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final inactiveCategoryOfferCount =
          totalCategoryOfferCount - activeCategoryOfferCount;
      final totalComboOfferCount = comboOffers.length;
      final activeComboOfferCount = comboOffers
          .where((offer) => offer.isActive)
          .length;
      final liveComboOfferCount = comboOffers.where((offer) {
        return _isOfferLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final inactiveComboOfferCount =
          totalComboOfferCount - activeComboOfferCount;
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

      return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AdminResponsive.pagePadding(context).copyWith(
              top: 12.h,
              bottom: AdminResponsive.bottomInset(context) + 76.h,
            ),
            children: [
              CatalogOffersTypeFilterBar(
                selectedValue: widget.offerTypeFilter,
                onSelected: widget.onOfferTypeChanged,
                items: [
                  CatalogOfferTypeFilterItem(
                    value: 'all',
                    label: 'All',
                    count: '$allOfferCount',
                    icon: Icons.grid_view_rounded,
                    accentColor: AdminThemeTokens.toneGreen,
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'live',
                    label: 'Live',
                    count: '$liveOfferCount',
                    icon: Icons.local_offer_rounded,
                    accentColor: AdminAppTheme.getSuccessColor(context),
                    subtitle: 'Running now',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'bogo',
                    label: 'BOGO',
                    count: '$bogoCount',
                    icon: Icons.card_giftcard,
                    accentColor: AdminThemeTokens.toneTeal,
                    subtitle:
                        '$activeBogoOfferCount active · $inactiveBogoOfferCount off',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'category_offer',
                    label: 'Category',
                    count: '$totalCategoryOfferCount',
                    icon: Icons.category_outlined,
                    accentColor: AdminThemeTokens.toneSteel,
                    subtitle:
                        '$activeCategoryOfferCount active · $inactiveCategoryOfferCount off',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'combo_offer',
                    label: 'Combo',
                    count: '$totalComboOfferCount',
                    icon: Icons.widgets_outlined,
                    accentColor: AdminThemeTokens.toneGreenSoft,
                    subtitle:
                        '$activeComboOfferCount active · $inactiveComboOfferCount off',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'percentage',
                    label: 'Percentage',
                    count: '$percentageCount',
                    icon: Icons.percent,
                    accentColor: AdminThemeTokens.toneIndigo,
                    subtitle:
                        '$activePercentageCount active · $inactivePercentageCount off',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'flat',
                    label: 'Flat',
                    count: '$flatCount',
                    icon: Icons.currency_rupee,
                    accentColor: AdminThemeTokens.toneMoss,
                    subtitle:
                        '$activeFlatCount active · $inactiveFlatCount off',
                  ),
                  CatalogOfferTypeFilterItem(
                    value: 'none',
                    label: 'No offer',
                    count: '$noOfferCount',
                    icon: Icons.remove_circle_outline,
                    accentColor: AdminThemeTokens.toneNeutral,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ProductSearchAndCategoryControls(
                searchHintText: 'Search product or offer',
                onSearchChanged: widget.onOfferSearchChanged,
                categoryOptions: categoryOptions,
                selectedCategory: widget.offerCategoryFilter,
                onCategorySelected: widget.onOfferCategoryChanged,
                padding: EdgeInsets.only(bottom: 8.h),
                searchToCategorySpacing: 10,
                categoryHeight: 34,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.offerTypeFilter == 'combo_offer'
                          ? 'Combo Offers'
                          : widget.offerTypeFilter == 'category_offer'
                          ? 'Category Offers'
                          : 'Products by Offer',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                  ),
                  Text(
                    widget.offerTypeFilter == 'combo_offer'
                        ? '${visibleComboOffers.length} items'
                        : widget.offerTypeFilter == 'category_offer'
                        ? '${visibleCategoryOffers.length} items'
                        : '${visibleProducts.length} items',
                    style: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
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
                    child: Text(
                      'No category offers matched the selected filters',
                    ),
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
                    child: Text(
                      'No products matched the selected offer filters',
                    ),
                  ),
                )
              else
                ...visibleProducts.map((product) {
                  final actionType = _actionTypeForCurrentFilter(
                    product,
                    bogoOffers,
                    categoryOffers,
                    comboOffers,
                  );
                  final hasActions = actionType != _OfferCardActionType.none;
                  final supportsToggle = _supportsToggle(actionType);
                  final isOfferActive = switch (actionType) {
                    _OfferCardActionType.bogo => _isBogoOfferActive(
                      product,
                      bogoOffers,
                    ),
                    _OfferCardActionType.directDiscount => _isDirectOfferActive(
                      product,
                    ),
                    _OfferCardActionType.categoryOffer ||
                    _OfferCardActionType.comboOffer => true,
                    _OfferCardActionType.none => false,
                  };

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: AdminResponsive.cardPadding(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              width: 64.r.clamp(54.0, 72.0).toDouble(),
                              height: 64.r.clamp(54.0, 72.0).toDouble(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 64.r.clamp(54.0, 72.0).toDouble(),
                                height: 64.r.clamp(54.0, 72.0).toDouble(),
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ).withValues(alpha: 0.15),
                                alignment: Alignment.center,
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp
                                        .clamp(13.0, 16.0)
                                        .toDouble(),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${product.category} • ${product.quantity}',
                                  style: TextStyle(
                                    color: AdminAppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    CatalogInlineBadge(
                                      label: _offerBadgeLabelForCurrentFilter(
                                        product,
                                        bogoOffers,
                                        categoryOffers,
                                        comboOffers,
                                      ),
                                      color:
                                          hasCatalogAnyLiveOffer(
                                            product,
                                            bogoOffers: bogoOffers,
                                            categoryOffers: categoryOffers,
                                            comboOffers: comboOffers,
                                          )
                                          ? AdminAppTheme.getSuccessColor(
                                              context,
                                            )
                                          : AdminAppTheme.getNeutralColor(
                                              context,
                                            ),
                                    ),
                                    if (hasActions)
                                      CatalogInlineBadge(
                                        label: isOfferActive
                                            ? 'Active'
                                            : 'Inactive',
                                        color: isOfferActive
                                            ? AdminAppTheme.getSuccessColor(
                                                context,
                                              )
                                            : AdminAppTheme.getErrorColor(
                                                context,
                                              ).withValues(alpha: 0.2),
                                      ),
                                    CatalogInlineBadge(
                                      label: product.isAvailable
                                          ? 'Available'
                                          : 'Out of stock',
                                      color: product.isAvailable
                                          ? AdminAppTheme.getSuccessColor(
                                              context,
                                            )
                                          : AdminAppTheme.getErrorColor(
                                              context,
                                            ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '₹${product.price.toStringAsFixed(0)} • MRP ₹${product.realPrice.toStringAsFixed(0)}',
                                ),
                              ],
                            ),
                          ),
                          if (hasActions) ...[
                            SizedBox(width: 8.w),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              splashRadius: 18,
                              icon: Icon(Icons.more_vert),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'toggle':
                                    await _toggleOfferForProduct(
                                      product,
                                      bogoOffers,
                                      categoryOffers,
                                      comboOffers,
                                    );
                                    break;
                                  case 'edit':
                                    await _editOfferForProduct(
                                      product,
                                      bogoOffers,
                                      categoryOffers,
                                      comboOffers,
                                    );
                                    break;
                                  case 'remove':
                                    await _removeOfferForProduct(
                                      product,
                                      bogoOffers,
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
                                PopupMenuItem(
                                  value: 'remove',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: AdminAppTheme.getErrorColor(
                                          context,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Remove Offer',
                                        style: TextStyle(
                                          color: AdminAppTheme.getErrorColor(
                                            context,
                                          ),
                                        ),
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
              if (widget.offerTypeFilter != 'combo_offer' &&
                  widget.offerTypeFilter != 'category_offer' &&
                  widget.productController.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
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
