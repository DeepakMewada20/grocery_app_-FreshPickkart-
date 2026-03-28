import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/product_form_dialog.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_categories_tab.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
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
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isOpeningDialog = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      _productController.loadInitial(),
    ]);
    debugPrint('DEBUG: _loadData refresh complete.');
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      if (_productController.hasMore.value &&
          !_productController.isLoadingMore.value) {
        debugPrint('DEBUG: _handleScroll triggering loadMore...');
        _productController.loadMore();
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
          final productId = await _productController.addProduct(result.product);
          if (productId != null && result.bogoSelections != null) {
            await _saveBogoOfferConfiguration(
              triggerProductId: productId,
              selections: result.bogoSelections!,
            );
          }
          await _loadData();
        },
        groupedSubcategoryOptionsFor:
            _categoryController.groupedSubcategoryOptionsFor,
      );

      if (saved != true) return;

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added')));
      await _loadData();
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
          await _loadData();
        },
        groupedSubcategoryOptionsFor:
            _categoryController.groupedSubcategoryOptionsFor,
      );

      if (saved != true) return;

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product updated')));
      await _loadData();
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
    return _productController.products.where((p) {
      final categoryMatch =
          _productController.categoryFilter == 'All' ||
          p.category == _productController.categoryFilter;
      if (!categoryMatch) return false;
      if (query.isEmpty) return true;
      return p.productName.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          p.quantity.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            _productController.totalCount.value > 0
                ? 'Catalog (${_productController.totalCount.value})'
                : 'Catalog',
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductsListContent(
            scrollController: _scrollController,
            searchQuery: _searchQuery,
            isSearching: _isSearching,
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onSearchClose: () {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
              });
            },
            onOpenAddProductDialog: _openAddProductDialog,
            onOpenEditProductDialog: _openEditProductDialog,
            onDeleteProduct: _deleteProduct,
            visibleProducts: _visibleProducts,
            loadData: _loadData,
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
        backgroundColor: Colors.green,
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
