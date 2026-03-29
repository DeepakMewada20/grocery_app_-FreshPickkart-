import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class ProductSelectionDialog extends StatefulWidget {
  final String title;
  final Set<String> excludedProductIds;
  final String? initialCategory;

  const ProductSelectionDialog({
    super.key,
    this.title = 'Select Product',
    this.excludedProductIds = const <String>{},
    this.initialCategory,
  });

  static Future<Product?> show({
    required BuildContext context,
    String title = 'Select Product',
    Set<String> excludedProductIds = const <String>{},
    String? initialCategory,
  }) {
    return showDialog<Product>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        title: title,
        excludedProductIds: excludedProductIds,
        initialCategory: initialCategory,
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

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
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
        category:
            _selectedCategory == null || _selectedCategory!.isEmpty
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
        category:
            _selectedCategory == null || _selectedCategory!.isEmpty
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
    _categoryProductCache[scope] = List<Product>.from(_productController.products);
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

    final allProducts = _categoryProductCache['All'] ?? _productController.products;
    return allProducts
        .where((product) => product.category == normalizedSelected)
        .toList();
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

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 640,
        height: 520,
        child: Column(
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
                onSelectProduct: (product) => Navigator.pop(context, product),
                visibleProducts: _visibleProducts,
                loadData: _refreshData,
                showActionMenu: false,
                enablePagination:
                    (_selectedCategory == null || _selectedCategory!.isEmpty
                        ? 'All'
                        : _selectedCategory!) ==
                    _fetchedCategoryScope,
              ),
            ),
          ],
        ),
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
