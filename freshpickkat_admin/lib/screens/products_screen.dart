import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/product_form_dialog.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_categories_tab.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminProductController _productController =
      AdminProductController.instance;
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;

  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _fetchedCategoryScope = 'All';
  final Map<String, List<Product>> _categoryProductCache = {};
  bool _isOpeningDialog = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(_handleScroll);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    debugPrint('DEBUG: _loadData pulling refresh...');
    await Future.wait([
      _categoryController.loadCategories(),
      _productController.loadInitial(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      ),
    ]);
    _syncFetchedScopeCache(_selectedCategory);
    debugPrint('DEBUG: _loadData refresh complete.');
  }

  Future<void> _selectCategory(String value) async {
    if (_selectedCategory == value) return;

    setState(() {
      _selectedCategory = value;
    });

    final hasCachedScope = _categoryProductCache.containsKey(value);
    if (hasCachedScope) return;

    await _productController.loadInitial(
      category: value == 'All' ? null : value,
    );
    if (!mounted) return;
    setState(() {
      _syncFetchedScopeCache(value);
    });
  }

  void _syncFetchedScopeCache(String scope) {
    _fetchedCategoryScope = scope;
    _categoryProductCache[scope] = List<Product>.from(
      _productController.products,
    );
  }

  void _syncAllKnownProductCaches() {
    final allProducts = List<Product>.from(_productController.products);
    _categoryProductCache['All'] = allProducts;
    for (final category in _categoryProductCache.keys.toList()) {
      if (category == 'All') continue;
      _categoryProductCache[category] = allProducts
          .where((product) => product.category == category)
          .toList();
    }
    _fetchedCategoryScope = _selectedCategory;
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    if (_selectedCategory != _fetchedCategoryScope) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      if (_productController.hasMore.value &&
          !_productController.isLoadingMore.value) {
        debugPrint('DEBUG: _handleScroll triggering loadMore...');
        _productController.loadMore().then((_) {
          if (!mounted) return;
          setState(() {
            _syncFetchedScopeCache(_fetchedCategoryScope);
          });
        });
      }
    }
  }

  Future<void> _openAddProductDialog() async {
    if (_isOpeningDialog) return;
    _isOpeningDialog = true;

    try {
      final saved = await ProductFormDialog.show(
        context: context,
        product: null,
        categories: _categoryController.categories,
        onSubmit: (result) async {
          final createdProduct = await _productController.addProduct(
            result.product,
          );
          if (createdProduct?.productId != null &&
              result.bogoSelections != null) {
            await _saveBogoOfferConfiguration(
              triggerProductId: createdProduct!.productId!,
              selections: result.bogoSelections!,
            );
          }
          if (!mounted) return;
          setState(_syncAllKnownProductCaches);
        },
        groupedSubcategoryOptionsFor:
            _categoryController.subcategoryOptionsWithImagesFor,
      );

      if (saved != true) return;

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    } finally {
      _isOpeningDialog = false;
    }
  }

  Future<void> _openEditProductDialog(Product product) async {
    if (_isOpeningDialog) return;
    _isOpeningDialog = true;

    try {
      final saved = await ProductFormDialog.show(
        context: context,
        product: product,
        categories: _categoryController.categories,
        onSubmit: (result) async {
          await _productController.updateProduct(result.product);

          if (result.bogoSelections != null && product.productId != null) {
            await _saveBogoOfferConfiguration(
              triggerProductId: product.productId!,
              selections: result.bogoSelections!,
            );
          }
          if (!mounted) return;
          setState(_syncAllKnownProductCaches);
        },
        groupedSubcategoryOptionsFor:
            _categoryController.subcategoryOptionsWithImagesFor,
      );

      if (saved != true) return;

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update product: $e')));
    } finally {
      _isOpeningDialog = false;
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

    await AdminBogoController.instance.upsertOffer(
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

  Future<void> _deleteProduct(Product product) async {
    if (product.productId == null || product.productId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid product id')));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text('Delete "${product.productName}"?'),
            actions: [
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(this.context);
                        setDialogState(() => isDeleting = true);
                        try {
                          await _productController.deleteProduct(
                            product.productId!,
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context, true);
                        } catch (e) {
                          if (!context.mounted) return;
                          Navigator.pop(context, false);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete product: $e'),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminAppTheme.getErrorColor(context),
                ),
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );

    if (confirm != true) return;
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product deleted')));
  }

  List<Product> _visibleProducts() {
    final query = _searchQuery.toLowerCase().trim();
    final sourceProducts = _productsForSelectedCategory();
    return sourceProducts.where((p) {
      final categoryMatch =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      if (!categoryMatch) return false;
      if (query.isEmpty) return true;
      return p.productName.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          p.quantity.toLowerCase().contains(query);
    }).toList();
  }

  List<Product> _productsForSelectedCategory() {
    if (_selectedCategory == 'All') {
      return _categoryProductCache['All'] ?? _productController.products;
    }

    if (_categoryProductCache.containsKey(_selectedCategory)) {
      return _categoryProductCache[_selectedCategory]!;
    }

    final allProducts =
        _categoryProductCache['All'] ?? _productController.products;
    return allProducts
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  bool _isCategoryFabExpanded = false;

  void _toggleCategoryFab() {
    setState(() {
      _isCategoryFabExpanded = !_isCategoryFabExpanded;
    });
  }

  Future<void> _handleCategoryFabAction(String action) async {
    setState(() {
      _isCategoryFabExpanded = false;
    });

    // Small delay to let the menu close before opening dialog
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    if (action == 'category') {
      showAddCategoryDialog(context: context, controller: _categoryController);
    } else {
      showAddSubcategoryDialog(
        context: context,
        controller: _categoryController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: TabBar(
          controller: _tabController,
          labelColor: AdminThemeTokens.white,
          unselectedLabelColor: AdminThemeTokens.white.withValues(alpha: 0.7),
          indicatorColor: AdminThemeTokens.white,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Products Tab Content with its own FAB ────────────────────────
          Stack(
            children: [
              ProductsListContent(
                scrollController: _scrollController,
                searchQuery: _searchQuery,
                isSearching: false,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onSearchClose: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                onOpenEditProductDialog: _openEditProductDialog,
                onDeleteProduct: _deleteProduct,
                visibleProducts: _visibleProducts,
                loadData: _loadData,
                selectedCategory: _selectedCategory,
                onCategorySelected: _selectCategory,
                enablePagination: _selectedCategory == _fetchedCategoryScope,
              ),
              Positioned(
                right: 16.w,
                bottom: AdminResponsive.bottomInset(context),
                child: FloatingActionButton.extended(
                  key: const ValueKey('add_product_fab'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: AdminThemeTokens.white,
                  onPressed: _openAddProductDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ),
            ],
          ),

          // ── Categories Tab Content with Animated FAB Menu ────────────────
          Stack(
            children: [
              CatalogCategoriesTab(
                controller: AdminCategoryController.instance,
                onAddCategory: () => showAddCategoryDialog(
                  context: context,
                  controller: AdminCategoryController.instance,
                ),
                onAddSubcategory: () => showAddSubcategoryDialog(
                  context: context,
                  controller: AdminCategoryController.instance,
                ),
              ),
              // Backdrop for expanded FAB (inside stack so it moves with tab)
              if (_isCategoryFabExpanded)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggleCategoryFab,
                    child: Container(
                      color: AdminAppTheme.getScrimShadowColor(
                        context,
                        alpha: 0.05,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 16.w,
                bottom: AdminResponsive.bottomInset(context),
                child: _CategoryFabMenu(
                  key: const ValueKey('category_fab_menu'),
                  isExpanded: _isCategoryFabExpanded,
                  onToggle: _toggleCategoryFab,
                  onSelected: _handleCategoryFabAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Animated FAB Menu for Categories ─────────────────────────────────────────

class _CategoryFabMenu extends StatefulWidget {
  const _CategoryFabMenu({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onSelected,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelected;

  @override
  State<_CategoryFabMenu> createState() => _CategoryFabMenuState();
}

class _CategoryFabMenuState extends State<_CategoryFabMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    if (widget.isExpanded) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _CategoryFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.isExpanded) ...[
          _buildMenuItem(
            label: 'Add Subcategory',
            icon: Icons.account_tree_outlined,
            color: AdminAppTheme.getTealColor(context),
            onTap: () => widget.onSelected('subcategory'),
            index: 1,
          ),
          SizedBox(height: 12.h),
          _buildMenuItem(
            label: 'Add Category',
            icon: Icons.category_outlined,
            color: AdminAppTheme.getSuccessColor(context),
            onTap: () => widget.onSelected('category'),
            index: 0,
          ),
          SizedBox(height: 12.h),
        ],
        FloatingActionButton.extended(
          onPressed: widget.onToggle,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: AdminThemeTokens.white,
          icon: AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            turns: widget.isExpanded ? 0.375 : 0, // 45 degrees
            child: const Icon(Icons.add),
          ),
          label: Text(widget.isExpanded ? 'Close' : 'Add New'),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required int index,
  }) {
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(
        scale: _controller,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AdminThemeTokens.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AdminAppTheme.getScrimShadowColor(
                        context,
                        alpha: 0.1,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              FloatingActionButton.small(
                onPressed: onTap,
                backgroundColor: color,
                foregroundColor: AdminThemeTokens.white,
                child: Icon(icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
