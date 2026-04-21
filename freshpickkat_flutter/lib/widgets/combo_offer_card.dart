import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:get/get.dart';

import 'combo_product_preview_card.dart';

class ComboOfferCard extends StatelessWidget {
  final ComboOffer combo;
  final List<ResolvedComboProduct> products;
  final bool isExpanded;
  final bool isHighlighted;
  final VoidCallback onTap;
  final bool isCompactVariant;
  final EdgeInsetsGeometry? margin;

  const ComboOfferCard({
    super.key,
    required this.combo,
    required this.products,
    required this.isExpanded,
    required this.isHighlighted,
    required this.onTap,
    this.isCompactVariant = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartController = CartController.instance;
    final screenWidth = MediaQuery.of(context).size.width;

    final discountLabel = comboDiscountBadgeText(
      combo.discountType,
      combo.discountValue,
    );
    final mrpUnitTotal = calculateComboMrpUnitTotal(products);
    final originalUnitTotal = calculateComboOriginalUnitTotal(products);
    final comboUnitTotal = applyComboDiscount(
      originalTotal: originalUnitTotal,
      discountType: combo.discountType,
      discountValue: combo.discountValue,
    );

    final productCardWidth = ((screenWidth - 84) / 2).clamp(132.0, 164.0);
    final productStripHeight = productCardWidth * 1.38;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: margin,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted ? AppTheme.primaryGreen : cs.outlineVariant,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isCompactVariant) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              discountLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          combo.name,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (combo.description != null &&
                            combo.description!.isNotEmpty)
                          Text(
                            combo.description!,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (!isCompactVariant)
                          Text(
                            'Tap to review bundled products in this combo deal.',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Combo ₹${comboUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Sell ₹${originalUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'MRP ₹${mrpUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.4),
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && products.isNotEmpty) ...[
            Divider(color: cs.outlineVariant, height: 1),
            SizedBox(
              height: productStripHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == products.length - 1 ? 0 : 12,
                    ),
                    child: SizedBox(
                      width: productCardWidth,
                      child: ComboProductPreviewCard(item: products[index]),
                    ),
                  );
                },
              ),
            ),
            if (!isCompactVariant)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartController.addComboOffer(combo);
                      Get.snackbar(
                        'Added to Basket',
                        '${products.length} combo products added from ${combo.name}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.primaryGreen,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add Combo to Basket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
          if (isExpanded && products.isEmpty) ...[
            Divider(color: cs.outlineVariant, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Products loading...',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
