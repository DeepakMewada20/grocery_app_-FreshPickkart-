import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/product_form_dialog.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_categories_tab.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';

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
    _categoryProductCache[scope] = List<Product>.from(_productController.products);
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
          final createdProduct = await _productController.addProduct(result.product);
          if (createdProduct?.productId != null && result.bogoSelections != null) {
            await _saveBogoOfferConfiguration(
              triggerProductId: createdProduct!.productId!,
              selections: result.bogoSelections!,
            );
          }
          if (!mounted) return;
          setState(_syncAllKnownProductCaches);
        },
        groupedSubcategoryOptionsFor:
            _categoryController.groupedSubcategoryOptionsFor,
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
            _categoryController.groupedSubcategoryOptionsFor,
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
            quantity: s.freeQuantity,
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

    final allProducts = _categoryProductCache['All'] ?? _productController.products;
    return allProducts.where((product) => product.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Products'),
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
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
            enablePagination:
                _selectedCategory == _fetchedCategoryScope,
          ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          final currentIndex = _tabController.index;
          if (currentIndex == 0) {
            _openAddProductDialog();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
