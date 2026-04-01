import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/widgets/network_error_widget.dart';

class ProductFilterOption {
  final String value;
  final String label;

  const ProductFilterOption({
    required this.value,
    required this.label,
  });
}

class ProductSearchAndCategoryControls extends StatelessWidget {
  final String searchHintText;
  final ValueChanged<String> onSearchChanged;
  final List<ProductFilterOption> categoryOptions;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final EdgeInsetsGeometry padding;
  final double searchToCategorySpacing;
  final double categoryHeight;

  const ProductSearchAndCategoryControls({
    super.key,
    required this.searchHintText,
    required this.onSearchChanged,
    required this.categoryOptions,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
    this.searchToCategorySpacing = 10,
    this.categoryHeight = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: searchHintText,
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.green),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: onSearchChanged,
          ),
          SizedBox(height: searchToCategorySpacing),
          SizedBox(
            height: categoryHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categoryOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final option = categoryOptions[index];
                final isSelected = selectedCategory == option.value;
                return Theme(
                  data: Theme.of(context).copyWith(
                    chipTheme: Theme.of(context).chipTheme.copyWith(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.green.withValues(alpha: 0.12),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.green.shade800
                            : Colors.grey.shade800,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                  child: CatalogOfferFilterChip(
                    label: option.label,
                    selected: isSelected,
                    onSelected: () => onCategorySelected(option.value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsListArea extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(Product)? onOpenEditProductDialog;
  final void Function(Product)? onDeleteProduct;
  final void Function(Product)? onSelectProduct;
  final List<Product> Function() visibleProducts;
  final Future<void> Function() loadData;
  final bool showActionMenu;
  final Set<String> selectedProductIds;
  final bool enablePagination;

  const ProductsListArea({
    super.key,
    required this.scrollController,
    this.onOpenEditProductDialog,
    this.onDeleteProduct,
    this.onSelectProduct,
    required this.visibleProducts,
    required this.loadData,
    this.showActionMenu = true,
    this.selectedProductIds = const <String>{},
    this.enablePagination = true,
  });

  @override
  Widget build(BuildContext context) {
    final productController = AdminProductController.instance;

    return Obx(() {
      final products = productController.products;
      final isLoading = productController.isLoading.value;
      final error = productController.error.value;
      final hasMore = productController.hasMore.value;
      final isLoadingMore = productController.isLoadingMore.value;

      if (isLoading && products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (productController.networkController.hasError.value && products.isEmpty) {
        return NetworkErrorWidget(
          onRetry: () => productController.networkController.retryLastRequest(),
        );
      }

      if (error != null && products.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      if (products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return RefreshIndicator(
        onRefresh: loadData,
        child: (() {
          final visible = visibleProducts();
          if (visible.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                const Center(child: Text('No matching products')),
                if (enablePagination && hasMore) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => productController.loadMore(),
                      child: isLoadingMore
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                (enablePagination && (hasMore || isLoadingMore || error != null)
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index >= visible.length) {
                if (productController.networkController.hasError.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: NetworkErrorWidget(
                      onRetry: () =>
                          productController.networkController.retryLastRequest(),
                    ),
                  );
                }
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
              final productId = product.productId ?? '';
              final isSelected = selectedProductIds.contains(productId);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () {
                    if (onSelectProduct != null) {
                      onSelectProduct!(product);
                      return;
                    }
                    onOpenEditProductDialog?.call(product);
                  },
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
                  trailing: onSelectProduct != null
                      ? Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.chevron_right,
                          color: isSelected ? Colors.green : Colors.grey,
                        )
                      : showActionMenu
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onOpenEditProductDialog?.call(product);
                            } else if (value == 'delete') {
                              onDeleteProduct?.call(product);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        })(),
      );
    });
  }
}

class ProductsListContent extends StatelessWidget {
  final ScrollController scrollController;
  final String searchQuery;
  final bool isSearching;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClose;
  final void Function(Product)? onOpenEditProductDialog;
  final void Function(Product)? onDeleteProduct;
  final void Function(Product)? onSelectProduct;
  final List<Product> Function() visibleProducts;
  final Future<void> Function() loadData;
  final bool showActionMenu;
  final bool showCategoryFilter;
  final String searchHintText;
  final Set<String> selectedProductIds;
  final Set<String> excludedProductIds;
  final String selectedCategory;
  final ValueChanged<String>? onCategorySelected;
  final bool enablePagination;

  const ProductsListContent({
    super.key,
    required this.scrollController,
    required this.searchQuery,
    required this.isSearching,
    required this.onSearchChanged,
    required this.onSearchClose,
    this.onOpenEditProductDialog,
    this.onDeleteProduct,
    this.onSelectProduct,
    required this.visibleProducts,
    required this.loadData,
    this.showActionMenu = true,
    this.showCategoryFilter = true,
    this.searchHintText = 'Search products...',
    this.selectedProductIds = const <String>{},
    this.excludedProductIds = const <String>{},
    this.selectedCategory = 'All',
    this.onCategorySelected,
    this.enablePagination = true,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = AdminCategoryController.instance;

    return Column(
      children: [
        if (showCategoryFilter)
          Obx(() {
            final options = <ProductFilterOption>[
              const ProductFilterOption(value: 'All', label: 'All'),
              ...categoryController.categories.map(
                (category) => ProductFilterOption(
                  value: category.categoryName,
                  label: category.categoryName,
                ),
              ),
            ];
            return ProductSearchAndCategoryControls(
              searchHintText: searchHintText,
              onSearchChanged: onSearchChanged,
              categoryOptions: options,
              selectedCategory: selectedCategory,
              onCategorySelected: (value) {
                onCategorySelected?.call(value);
              },
            );
          }),
        Expanded(
          child: ProductsListArea(
            scrollController: scrollController,
            onOpenEditProductDialog: onOpenEditProductDialog,
            onDeleteProduct: onDeleteProduct,
            onSelectProduct: onSelectProduct,
            visibleProducts: visibleProducts,
            loadData: loadData,
            showActionMenu: showActionMenu,
            selectedProductIds: selectedProductIds,
            enablePagination: enablePagination,
          ),
        ),
      ],
    );
  }
}
