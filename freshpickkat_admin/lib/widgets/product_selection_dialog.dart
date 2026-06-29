import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSelectionResult {
  final Product product;
  final ProductVariant? variant;

  const ProductSelectionResult({required this.product, this.variant});

  String get productId => product.productId ?? '';
  String get selectionKey => '$productId::${variant?.variantId ?? 'default'}';
}

class _VariantSelectionOutcome {
  final ProductVariant? variant;
  final bool wasCancelled;

  const _VariantSelectionOutcome({this.variant, this.wasCancelled = false});
}

class ProductSelectionDialog extends StatefulWidget {
  final String title;
  final Set<String> excludedProductIds;
  final String? initialCategory;
  final bool useBottomSheetPresentation;
  final bool allowMultiSelect;
  final List<ProductSelectionResult> initialSelections;

  const ProductSelectionDialog({
    super.key,
    this.title = 'Select Product',
    this.excludedProductIds = const <String>{},
    this.initialCategory,
    this.useBottomSheetPresentation = false,
    this.allowMultiSelect = false,
    this.initialSelections = const <ProductSelectionResult>[],
  });

  static Future<ProductSelectionResult?> show({
    required BuildContext context,
    String title = 'Select Product',
    Set<String> excludedProductIds = const <String>{},
    String? initialCategory,
  }) {
    return showDialog<ProductSelectionResult>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        title: title,
        excludedProductIds: excludedProductIds,
        initialCategory: initialCategory,
      ),
    );
  }

  static Future<ProductSelectionResult?> showBottomSheet({
    required BuildContext context,
    String title = 'Select Product',
    Set<String> excludedProductIds = const <String>{},
    String? initialCategory,
  }) {
    return showModalBottomSheet<ProductSelectionResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => ProductSelectionDialog(
        title: title,
        excludedProductIds: excludedProductIds,
        initialCategory: initialCategory,
        useBottomSheetPresentation: true,
      ),
    );
  }

  static Future<List<ProductSelectionResult>?> showMultiSelectBottomSheet({
    required BuildContext context,
    String title = 'Select Products',
    Set<String> excludedProductIds = const <String>{},
    String? initialCategory,
    List<ProductSelectionResult> initialSelections =
        const <ProductSelectionResult>[],
  }) {
    return showModalBottomSheet<List<ProductSelectionResult>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => ProductSelectionDialog(
        title: title,
        excludedProductIds: excludedProductIds,
        initialCategory: initialCategory,
        useBottomSheetPresentation: true,
        allowMultiSelect: true,
        initialSelections: initialSelections,
      ),
    );
  }

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  final _scrollController = ScrollController();
  final _productController = AdminProductController.instance;
  final _categoryController = AdminCategoryController.instance;
  String _searchQuery = '';
  String? _selectedCategory;
  String _fetchedCategoryScope = 'All';
  final Map<String, List<Product>> _categoryProductCache = {};
  late final Map<String, ProductSelectionResult> _selectedResults;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedResults = {
      for (final selection in widget.initialSelections)
        selection.productId: selection,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureDataLoaded();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _ensureDataLoaded() async {
    if (_categoryController.categories.isEmpty) {
      await _categoryController.loadCategories();
    }
    if (_productController.products.isEmpty) {
      await _productController.loadInitial(
        category: _selectedCategory == null || _selectedCategory!.isEmpty
            ? null
            : _selectedCategory,
      );
      _syncFetchedScopeCache(_selectedCategory ?? 'All');
    } else if (_categoryProductCache.isEmpty) {
      _syncFetchedScopeCache(_productController.categoryFilter);
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _refreshData() async {
    await Future.wait([
      _categoryController.loadCategories(),
      _productController.loadInitial(
        category: _selectedCategory == null || _selectedCategory!.isEmpty
            ? null
            : _selectedCategory,
      ),
    ]);
    _syncFetchedScopeCache(_selectedCategory ?? 'All');
  }

  Future<void> _selectCategory(String value) async {
    final normalized = value.isEmpty ? null : value;
    final cacheKey = normalized ?? 'All';

    if ((_selectedCategory ?? '') == value) return;

    setState(() {
      _selectedCategory = normalized;
    });

    if (_categoryProductCache.containsKey(cacheKey)) return;

    await _productController.loadInitial(category: normalized);
    if (!mounted) return;
    setState(() {
      _syncFetchedScopeCache(cacheKey);
    });
  }

  void _syncFetchedScopeCache(String scope) {
    _fetchedCategoryScope = scope;
    _categoryProductCache[scope] = List<Product>.from(
      _productController.products,
    );
  }

  List<Product> _visibleProducts() {
    final query = _searchQuery.toLowerCase().trim();
    final sourceProducts = _productsForSelectedCategory();
    return sourceProducts.where((product) {
      final productId = product.productId;
      if (productId != null && widget.excludedProductIds.contains(productId)) {
        return false;
      }
      if (_selectedCategory != null &&
          _selectedCategory!.trim().isNotEmpty &&
          product.category != _selectedCategory) {
        return false;
      }
      if (query.isEmpty) return true;
      return product.productName.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.quantity.toLowerCase().contains(query);
    }).toList();
  }

  List<Product> _productsForSelectedCategory() {
    final normalizedSelected =
        _selectedCategory == null || _selectedCategory!.isEmpty
        ? 'All'
        : _selectedCategory!;

    if (normalizedSelected == 'All') {
      return _categoryProductCache['All'] ?? _productController.products;
    }

    if (_categoryProductCache.containsKey(normalizedSelected)) {
      return _categoryProductCache[normalizedSelected]!;
    }

    final allProducts =
        _categoryProductCache['All'] ?? _productController.products;
    return allProducts
        .where((product) => product.category == normalizedSelected)
        .toList();
  }

  Future<void> _handleProductTap(Product product) async {
    if (!widget.allowMultiSelect) {
      final outcome = await _pickVariantIfNeeded(product);
      if (!mounted) return;
      if (outcome.wasCancelled) return;
      Navigator.pop(context, ProductSelectionResult(
        product: product,
        variant: outcome.variant,
      ));
      return;
    }

    final productId = product.productId ?? '';
    if (productId.isEmpty) return;

    if (_selectedResults.containsKey(productId)) {
      setState(() {
        _selectedResults.remove(productId);
      });
      return;
    }

    final selectedVariantOutcome = await _pickVariantIfNeeded(product);
    if (!mounted) return;
    if (selectedVariantOutcome.wasCancelled) return;

    setState(() {
      _selectedResults[productId] = ProductSelectionResult(
        product: product,
        variant: selectedVariantOutcome.variant,
      );
    });
  }

  Future<_VariantSelectionOutcome> _pickVariantIfNeeded(Product product) async {
    final variants =
        (product.variants ?? const <ProductVariant>[])
            .where((variant) => variant.isAvailable)
            .toList()
          ..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));

    if (variants.length <= 1) {
      return _VariantSelectionOutcome(
        variant: variants.isEmpty ? null : variants.first,
      );
    }

    final selectedVariant = await showModalBottomSheet<ProductVariant>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AdminResponsive.pageHorizontalPadding(context),
            8.h,
            AdminResponsive.pageHorizontalPadding(context),
            AdminResponsive.bottomInset(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Variant',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4.h),
              Text(
                product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: variants.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final variant = variants[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: AdminAppTheme.getBorderColor(context),
                        ),
                      ),
                      title: Text(_variantLabel(variant)),
                      subtitle: Text(
                        '₹${variant.price.toStringAsFixed(2)} • MRP ₹${variant.realPrice.toStringAsFixed(2)}',
                      ),
                      onTap: () => Navigator.pop(context, variant),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selectedVariant == null) {
      return const _VariantSelectionOutcome(wasCancelled: true);
    }
    return _VariantSelectionOutcome(variant: selectedVariant);
  }

  String _variantLabel(ProductVariant variant) {
    final quantity = variant.quantityValue % 1 == 0
        ? variant.quantityValue.toInt().toString()
        : variant.quantityValue.toString();
    final description = variant.quantityDescription?.trim();
    if (description == null || description.isEmpty) {
      return '$quantity ${variant.quantityUnit}';
    }
    return '$quantity ${variant.quantityUnit} ($description)';
  }

  @override
  Widget build(BuildContext context) {
    final categoryOptions = <ProductFilterOption>[
      const ProductFilterOption(value: '', label: 'All'),
      ..._categoryController.categories.map(
        (category) => ProductFilterOption(
          value: category.categoryName,
          label: category.categoryName,
        ),
      ),
    ];

    final content = Column(
      children: [
        ProductSearchAndCategoryControls(
          searchHintText: 'Search product by name, category, quantity...',
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          categoryOptions: categoryOptions,
          selectedCategory: _selectedCategory ?? '',
          onCategorySelected: _selectCategory,
        ),
        Expanded(
          child: ProductsListArea(
            scrollController: _scrollController,
            onSelectProduct: _handleProductTap,
            visibleProducts: _visibleProducts,
            loadData: _refreshData,
            showActionMenu: false,
            selectedProductIds: _selectedResults.keys.toSet(),
            enablePagination:
                (_selectedCategory == null || _selectedCategory!.isEmpty
                    ? 'All'
                    : _selectedCategory!) ==
                _fetchedCategoryScope,
          ),
        ),
      ],
    );

    if (widget.useBottomSheetPresentation) {
      final screenHeight = MediaQuery.sizeOf(context).height;
      return SizedBox(
        height:
            screenHeight * (AdminResponsive.isLandscape(context) ? 0.92 : 0.86),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTextStyles.sectionTitle(context),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(child: content),
              if (widget.allowMultiSelect)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_selectedResults.length} selected',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: _selectedResults.isEmpty
                              ? null
                              : () => Navigator.pop(
                                  context,
                                  _selectedResults.values.toList(),
                                ),
                          child: const Text('Add Selected'),
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

    return AlertDialog(
      title: Text(widget.title),
      constraints: AdminResponsive.dialogConstraints(context),
      content: SizedBox(
        width: MediaQuery.sizeOf(
          context,
        ).width.clamp(280.0, AdminResponsive.maxDialogWidth).toDouble(),
        height:
            MediaQuery.sizeOf(context).height *
            (AdminResponsive.isLandscape(context) ? 0.72 : 0.62),
        child: content,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
