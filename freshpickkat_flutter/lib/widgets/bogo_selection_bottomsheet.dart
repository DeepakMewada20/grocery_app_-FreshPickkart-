import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:get/get.dart';

class BogoSelectionBottomSheet extends StatelessWidget {
  final String triggerProductId;
  final List<String> freeProductIds;

  const BogoSelectionBottomSheet({
    super.key,
    required this.triggerProductId,
    required this.freeProductIds,
  });

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;
    final cartController = CartController.instance;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final offerTheme =
        theme.extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(theme.brightness);

    final List<Product> eligibleProducts = freeProductIds
        .map(
          (id) => productController.allProducts.firstWhereOrNull(
            (p) => p.productId == id,
          ),
        )
        .whereType<Product>()
        .toList();
    final selectedFreeProductId = cartController.cartItems
        .firstWhereOrNull((item) => item.product.productId == triggerProductId)
        ?.bogoFreeProductId;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: offerTheme.badgeSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        size: 16,
                        color: offerTheme.badge,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'BOGO Gift',
                        style: TextStyle(
                          color: offerTheme.badge,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: cs.onSurface),
                ),
              ],
            ),
            Text(
              'Choose your free product',
              style: theme.textTheme.titleLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select 1 item from the list below. This gift will be added at ₹0.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.68),
              ),
            ),
            const SizedBox(height: 18),
            if (eligibleProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No eligible products found.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.68),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: eligibleProducts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = eligibleProducts[index];
                    final isSelected =
                        product.productId == selectedFreeProductId;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? offerTheme.badgeSoft
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? offerTheme.badgeBorder
                              : cs.outlineVariant,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 64,
                              height: 64,
                              color: cs.surface,
                              child: product.imageUrl.isEmpty
                                  ? Icon(
                                      Icons.image_not_supported_outlined,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                                    )
                                  : Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.broken_image_outlined,
                                              color: cs.onSurface.withValues(
                                                alpha: 0.4,
                                              ),
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.quantity,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'FREE with this offer',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: offerTheme.badge,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              cartController.setBogoSelection(
                                triggerProductId,
                                product.productId,
                              );
                              Get.back();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: offerTheme.badge,
                              foregroundColor: offerTheme.onBadge,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                            child: Text(isSelected ? 'Selected' : 'Choose'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
