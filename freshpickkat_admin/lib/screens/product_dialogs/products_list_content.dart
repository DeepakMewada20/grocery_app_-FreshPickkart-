import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/widgets/network_error_widget.dart';

class ProductsListContent extends StatelessWidget {
  final ScrollController scrollController;
  final String searchQuery;
  final bool isSearching;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClose;
  final VoidCallback onOpenAddProductDialog;
  final void Function(Product) onOpenEditProductDialog;
  final void Function(Product) onDeleteProduct;
  final List<Product> Function() visibleProducts;
  final Future<void> Function() loadData;

  const ProductsListContent({
    super.key,
    required this.scrollController,
    required this.searchQuery,
    required this.isSearching,
    required this.onSearchChanged,
    required this.onSearchClose,
    required this.onOpenAddProductDialog,
    required this.onOpenEditProductDialog,
    required this.onDeleteProduct,
    required this.visibleProducts,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return Column(
        children: [
          Container(
            color: Colors.green,
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              bottom: 8,
              top: MediaQuery.of(context).padding.top + 8,
            ),
            child: TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onSearchClose,
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(child: _buildProductList(context)),
        ],
      );
    }

    return _buildProductList(context);
  }

  Widget _buildProductList(BuildContext context) {
    final productController = AdminProductController.instance;
    final categoryController = AdminCategoryController.instance;

    return Obx(() {
      final products = productController.products;
      final isLoading = productController.isLoading.value;
      final error = productController.error.value;
      final hasMore = productController.hasMore.value;
      final isLoadingMore = productController.isLoadingMore.value;

      final categoryItems = <DropdownMenuItem<String>>[
        const DropdownMenuItem<String>(value: 'All', child: Text('All')),
        ...categoryController.categories.map<DropdownMenuItem<String>>(
          (c) => DropdownMenuItem<String>(
            value: c.categoryName,
            child: Text(c.categoryName),
          ),
        ),
      ];

      if (productController.networkController.hasError.value) {
        return NetworkErrorWidget(
          onRetry: () => productController.networkController.retryLastRequest(),
        );
      }

      if (isLoading && products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && products.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      if (products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: DropdownButtonFormField<String>(
              initialValue: productController.categoryFilter,
              decoration: InputDecoration(
                labelText: 'Filter by category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items: categoryItems,
              onChanged: (value) {
                if (value == null) return;
                productController.loadInitial(category: value);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadData,
              child: (() {
                final visible = visibleProducts();
                if (visible.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      const Center(child: Text('No matching products')),
                      if (hasMore) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => productController.loadMore(),
                            child: isLoadingMore
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Load More from Server'),
                          ),
                        ),
                      ],
                    ],
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(12),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      visible.length +
                      (hasMore || isLoadingMore || error != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= visible.length) {
                      if (error != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                'Error: $error',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => productController.loadMore(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final product = visible[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () => onOpenEditProductDialog(product),
                        isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(product.imageUrl),
                          onBackgroundImageError: (_, _) {},
                        ),
                        title: Text(product.productName),
                        subtitle: Text(
                          '${product.category} • ${product.quantity}\n'
                          '₹${product.price.toStringAsFixed(0)} | '
                          '${product.isAvailable ? 'Available' : 'Out of stock'}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onOpenEditProductDialog(product);
                            } else if (value == 'delete') {
                              onDeleteProduct(product);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })(),
            ),
          ),
        ],
      );
    });
  }
}
