import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class BogoSelectorWidget extends StatelessWidget {
  final List<Product> selectedProducts;
  final Set<String> unresolvedIds;
  final bool canBrowse;
  final Future<void> Function() onBrowsePressed;
  final ValueChanged<String> onRemove;
  final Map<String, String> freeProductQuantities;

  const BogoSelectorWidget({
    super.key,
    required this.selectedProducts,
    required this.unresolvedIds,
    required this.canBrowse,
    required this.onBrowsePressed,
    required this.onRemove,
    required this.freeProductQuantities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Free Products (Pick one or more)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: canBrowse ? onBrowsePressed : null,
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: Text(
                selectedProducts.isEmpty ? 'Browse Products' : 'Edit',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!canBrowse)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Text('Select the main product category first.'),
          )
        else if (selectedProducts.isEmpty && unresolvedIds.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text('No free products selected yet.'),
          )
        else
          Column(
            children: [
              ...selectedProducts.map((product) {
                final productId = product.productId;
                final normalizedConfiguredQuantity = productId == null
                    ? null
                    : freeProductQuantities[productId]?.trim();
                final freeQuantity = productId == null
                    ? product.quantity
                    : (normalizedConfiguredQuantity != null &&
                          normalizedConfiguredQuantity.isNotEmpty)
                    ? normalizedConfiguredQuantity
                    : product.quantity;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 52,
                              height: 52,
                              color: Colors.grey.shade100,
                              child: product.imageUrl.isEmpty
                                  ? const Icon(Icons.image_outlined)
                                  : Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.broken_image_outlined,
                                            );
                                          },
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.category} • Pack: ${product.quantity}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: productId == null
                                ? null
                                : () => onRemove(productId),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.scale_rounded,
                              size: 18,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Free quantity: $freeQuantity',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (unresolvedIds.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unresolvedIds
                      .map(
                        (id) => Chip(
                          label: Text('Unresolved: $id'),
                          onDeleted: () => onRemove(id),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
      ],
    );
  }
}
