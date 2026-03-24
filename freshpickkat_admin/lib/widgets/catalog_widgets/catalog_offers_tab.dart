import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:get/get.dart';

class CatalogOffersTab extends StatelessWidget {
  const CatalogOffersTab({
    super.key,
    required this.productController,
    required this.categoryController,
    required this.couponController,
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
  final String offerSearchQuery;
  final String offerTypeFilter;
  final String offerCategoryFilter;
  final ValueChanged<String> onOfferSearchChanged;
  final ValueChanged<String> onOfferCategoryChanged;
  final ValueChanged<String> onOfferTypeChanged;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = productController.products;
      final categories = categoryController.categories;
      final coupons = couponController.coupons;
      final isLoading = productController.isLoading.value;
      final error = productController.error.value;

      if (isLoading && products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && products.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      final visibleProducts = filterCatalogOfferProducts(
        products: products,
        query: offerSearchQuery,
        offerTypeFilter: offerTypeFilter,
        categoryFilter: offerCategoryFilter,
      );
      final liveCoupons = coupons.where(isCatalogCouponLive).toList();
      final bogoCount = products.where(isCatalogBogoOffer).length;
      final percentageCount = products.where(isCatalogPercentageOffer).length;
      final flatCount = products.where(isCatalogFlatOffer).length;
      final liveProductOfferCount = products
          .where(hasCatalogActiveOffer)
          .length;

      final categoryItems = <DropdownMenuItem<String>>[
        const DropdownMenuItem<String>(value: 'All', child: Text('All')),
        ...categories.map(
          (category) => DropdownMenuItem<String>(
            value: category.categoryName,
            child: Text(category.categoryName),
          ),
        ),
      ];

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CatalogStatCard(
                  title: 'Live Product Offers',
                  value: '$liveProductOfferCount',
                  icon: Icons.local_offer,
                  color: Colors.green,
                ),
                CatalogStatCard(
                  title: 'BOGO',
                  value: '$bogoCount',
                  icon: Icons.card_giftcard,
                  color: Colors.deepOrange,
                ),
                CatalogStatCard(
                  title: 'Percentage',
                  value: '$percentageCount',
                  icon: Icons.percent,
                  color: Colors.indigo,
                ),
                CatalogStatCard(
                  title: 'Flat',
                  value: '$flatCount',
                  icon: Icons.currency_rupee,
                  color: Colors.purple,
                ),
                CatalogStatCard(
                  title: 'Live Coupons',
                  value: '${liveCoupons.length}',
                  icon: Icons.discount,
                  color: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search product or offer',
                border: OutlineInputBorder(),
              ),
              onChanged: onOfferSearchChanged,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: offerCategoryFilter,
              decoration: const InputDecoration(
                labelText: 'Filter by category',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: categoryItems,
              onChanged: (value) {
                if (value == null) return;
                onOfferCategoryChanged(value);
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CatalogOfferFilterChip(
                  label: 'Live',
                  selected: offerTypeFilter == 'live',
                  onSelected: () => onOfferTypeChanged('live'),
                ),
                CatalogOfferFilterChip(
                  label: 'All',
                  selected: offerTypeFilter == 'all',
                  onSelected: () => onOfferTypeChanged('all'),
                ),
                CatalogOfferFilterChip(
                  label: 'BOGO',
                  selected: offerTypeFilter == 'bogo',
                  onSelected: () => onOfferTypeChanged('bogo'),
                ),
                CatalogOfferFilterChip(
                  label: 'Percentage',
                  selected: offerTypeFilter == 'percentage',
                  onSelected: () => onOfferTypeChanged('percentage'),
                ),
                CatalogOfferFilterChip(
                  label: 'Flat',
                  selected: offerTypeFilter == 'flat',
                  onSelected: () => onOfferTypeChanged('flat'),
                ),
                CatalogOfferFilterChip(
                  label: 'No Offer',
                  selected: offerTypeFilter == 'none',
                  onSelected: () => onOfferTypeChanged('none'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Products by Offer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${visibleProducts.length} items',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (visibleProducts.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No products matched the selected offer filters'),
                ),
              )
            else
              ...visibleProducts.map(
                (product) => Card(
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
                                    label: catalogProductOfferLabel(product),
                                    color: hasCatalogActiveOffer(product)
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
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Running Coupons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (liveCoupons.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No live coupon is running right now'),
                ),
              )
            else
              ...liveCoupons.map(
                (coupon) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE6F4EA),
                      child: Icon(Icons.discount, color: Colors.green),
                    ),
                    title: Text(coupon.code),
                    subtitle: Text(
                      '${coupon.description}\n${coupon.couponCategory} • ${coupon.discountType ?? 'delivery'}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      catalogCouponValueLabel(coupon),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
