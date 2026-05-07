import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/widgets/network_error_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductFilterOption {
  final String value;
  final String label;

  const ProductFilterOption({required this.value, required this.label});
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
    this.padding = EdgeInsets.zero,
    this.searchToCategorySpacing = 10,
    this.categoryHeight = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == EdgeInsets.zero
          ? EdgeInsets.fromLTRB(
              AdminResponsive.pageHorizontalPadding(context),
              12.h,
              AdminResponsive.pageHorizontalPadding(context),
              8.h,
            )
          : padding,
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
          SizedBox(height: searchToCategorySpacing.h),
          SizedBox(
            height: categoryHeight.h.clamp(34.0, 42.0),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categoryOptions.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
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
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.green.withValues(alpha: 0.12),
                      labelStyle: TextStyle(
                        fontSize: 12.sp.clamp(10.0, 13.0),
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.green.shade800
                            : Colors.grey.shade800,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
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

      if (productController.networkController.hasError.value &&
          products.isEmpty) {
        return NetworkErrorWidget(
          onRetry: () => productController.networkController.retryLastRequest(),
        );
      }

      if (error != null && products.isEmpty) {
        return RefreshIndicator(
          onRefresh: loadData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              SizedBox(
                height: 260,
                child: AdminStateView.error(
                  message: error,
                  onRetry: () => productController.loadInitial(),
                ),
              ),
            ],
          ),
        );
      }

      if (products.isEmpty) {
        return RefreshIndicator(
          onRefresh: loadData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              SizedBox(
                height: 260,
                child: AdminStateView.empty(
                  title: 'No products yet',
                  message: 'Add your first product to start selling.',
                  onRefresh: loadData,
                ),
              ),
            ],
          ),
        );
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
                SizedBox(
                  height: 260,
                  child: AdminStateView.empty(
                    title: 'No matching products',
                    message: 'Try a different search or category filter.',
                    icon: Icons.search_off_outlined,
                  ),
                ),
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = AdminResponsive.productListColumnsForWidth(
                constraints.maxWidth,
              );
              final itemCount =
                  visible.length +
                  (enablePagination &&
                          (hasMore || isLoadingMore || error != null)
                      ? 1
                      : 0);
              final listPadding = AdminResponsive.pagePadding(
                context,
              ).copyWith(bottom: AdminResponsive.bottomInset(context) + 76.h);

              Widget paginationTile() {
                if (productController.networkController.hasError.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: NetworkErrorWidget(
                      onRetry: () => productController.networkController
                          .retryLastRequest(),
                    ),
                  );
                }
                if (error != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      children: [
                        Text(
                          'Error: $error',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () => productController.loadMore(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              Widget itemAt(int index) {
                if (index >= visible.length) return paginationTile();
                final product = visible[index];
                final productId = product.productId ?? '';
                final isSelected = selectedProductIds.contains(productId);
                return _ProductAdminCard(
                  product: product,
                  isSelected: isSelected,
                  showActionMenu: showActionMenu,
                  isSelectionMode: onSelectProduct != null,
                  onTap: () {
                    if (onSelectProduct != null) {
                      onSelectProduct!(product);
                      return;
                    }
                    onOpenEditProductDialog?.call(product);
                  },
                  onEdit: () => onOpenEditProductDialog?.call(product),
                  onDelete: () => onDeleteProduct?.call(product),
                );
              }

              if (columns == 1) {
                return ListView.builder(
                  controller: scrollController,
                  padding: listPadding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: itemAt(index),
                  ),
                );
              }

              return GridView.builder(
                controller: scrollController,
                padding: listPadding,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: itemCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: constraints.maxWidth > 980 ? 1.85 : 1.65,
                ),
                itemBuilder: (context, index) => itemAt(index),
              );
            },
          );
        })(),
      );
    });
  }
}

class _ProductAdminCard extends StatelessWidget {
  const _ProductAdminCard({
    required this.product,
    required this.isSelected,
    required this.showActionMenu,
    required this.isSelectionMode,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final bool isSelected;
  final bool showActionMenu;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = product.isAvailable ? Colors.green : Colors.redAccent;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox.square(
                  dimension: 64.r.clamp(52.0, 72.0),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: cs.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: cs.onSurfaceVariant,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      product.productName,
                      maxLines: 2,
                      minFontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.cardTitle(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${product.category} • ${product.quantity}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.caption(context),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        CatalogInlineBadge(
                          label: '₹${product.price.toStringAsFixed(0)}',
                          color: Colors.green.shade700,
                        ),
                        CatalogInlineBadge(
                          label: product.isAvailable
                              ? 'Available'
                              : 'Out of stock',
                          color: statusColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              if (isSelectionMode)
                Icon(
                  isSelected ? Icons.check_circle : Icons.chevron_right,
                  color: isSelected ? Colors.green : Colors.grey,
                )
              else if (showActionMenu)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
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
