import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class FreeDeliveryPromotionSection extends StatelessWidget {
  const FreeDeliveryPromotionSection({
    super.key,
    required this.products,
    required this.categories,
    required this.query,
    required this.onQueryChanged,
    required this.onToggleProduct,
    required this.onToggleCategory,
  });

  final List<Product> products;
  final List<Category> categories;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final void Function(Product product, bool enabled) onToggleProduct;
  final void Function(Category category, bool enabled) onToggleCategory;

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final filteredProducts = products.where((product) {
      if (normalized.isEmpty) return product.isFreeDelivery;
      return product.productName.toLowerCase().contains(normalized) ||
          product.category.toLowerCase().contains(normalized);
    }).take(12).toList();
    final filteredCategories = categories.where((category) {
      if (normalized.isEmpty) return category.isFreeDelivery;
      return category.categoryName.toLowerCase().contains(normalized);
    }).take(8).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product & Category Free Delivery',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: onQueryChanged,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search products or categories',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            if (filteredCategories.isEmpty)
              const Text('Search categories to enable Free Delivery')
            else
              ...filteredCategories.map(
                (category) => SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(category.categoryName),
                  subtitle: const Text('Applies to every active product in this category'),
                  value: category.isFreeDelivery,
                  onChanged: (value) => onToggleCategory(category, value),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'Products',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            if (filteredProducts.isEmpty)
              const Text('Search products to enable Free Delivery')
            else
              ...filteredProducts.map(
                (product) => SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  secondary: product.imageUrl.isEmpty
                      ? const Icon(Icons.inventory_2_outlined)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            product.imageUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.inventory_2_outlined,
                            ),
                          ),
                        ),
                  title: Text(product.productName),
                  subtitle: Text(product.category),
                  value: product.isFreeDelivery,
                  onChanged: product.isAvailable
                      ? (value) => onToggleProduct(product, value)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OfferConflictDialog extends StatelessWidget {
  const OfferConflictDialog({super.key, required this.conflict});

  final OfferConflictResponse conflict;

  @override
  Widget build(BuildContext context) {
    final combo = conflict.comboOffer;
    final bogo = conflict.bogoOffer;
    return AlertDialog(
      title: const Text('Offer Conflict'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conflict.message ?? 'This offer conflicts with another active offer.'),
            if (combo != null) ...[
              const SizedBox(height: 12),
              Text(
                combo.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              ...combo.comboProducts.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('${item.productName ?? item.productId} x${item.quantity}'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                combo.discountType == 'percentage'
                    ? 'Combo discount: ${combo.discountValue.toStringAsFixed(0)}%'
                    : 'Combo price benefit: ₹${combo.discountValue.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              const Text('Confirming will disable the whole combo.'),
            ],
            if (bogo != null) ...[
              const SizedBox(height: 12),
              Text('BOGO: ${bogo.offerTitle}'),
              Text('Trigger product: ${bogo.triggerProductId}'),
            ],
            if (conflict.productNames.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Products: ${conflict.productNames.join(', ')}'),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
