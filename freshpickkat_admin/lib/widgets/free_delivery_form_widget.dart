import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FreeDeliveryPromotionSection extends StatelessWidget {
  const FreeDeliveryPromotionSection({
    super.key,
    required this.freeDeliveryProducts,
    required this.onToggleProduct,
    required this.onAddFreeDeliveryProducts,
  });

  final List<Product> freeDeliveryProducts;
  final void Function(Product product, bool enabled) onToggleProduct;
  final VoidCallback onAddFreeDeliveryProducts;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Free Delivery',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onAddFreeDeliveryProducts,
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text(
                    'Add Free Delivery Products',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (freeDeliveryProducts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No free delivery products added',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
              )
            else
              ...freeDeliveryProducts.map(
                (product) => SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  secondary: product.imageUrl.isEmpty
                      ? Icon(
                          Icons.inventory_2_outlined,
                          color: cs.onSurfaceVariant,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            product.imageUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.inventory_2_outlined,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                  title: Text(product.productName),
                  subtitle: Text(product.category),
                  value: true,
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
            Text(
              conflict.message ??
                  'This offer conflicts with another active offer.',
            ),
            if (combo != null) ...[
              const SizedBox(height: 12),
              Text(
                combo.name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...combo.comboProducts.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${item.productName ?? item.productId} x${item.quantity}',
                  ),
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
