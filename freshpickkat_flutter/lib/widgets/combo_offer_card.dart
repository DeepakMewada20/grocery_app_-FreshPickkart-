import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;

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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isHighlighted ? AppTheme.primaryGreen : cs.outlineVariant,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: Offset(0, 4.h),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isCompactVariant) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: AutoSizeText(
                              discountLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                              minFontSize: 9,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                        AutoSizeText(
                          combo.name,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                          minFontSize: 12,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (combo.description != null &&
                            combo.description!.isNotEmpty)
                          Text(
                            combo.description!,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (!isCompactVariant)
                          Text(
                            'Tap to review bundled products in this combo deal.',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 6.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Combo ₹${comboUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Text(
                              'Sell ₹${originalUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'MRP ₹${mrpUnitTotal.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface.withValues(alpha: 0.4),
                                fontSize: 13.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    size: 24.r,
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
                padding: EdgeInsets.all(12.r),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == products.length - 1 ? 0 : 12.w,
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
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Obx(() {
                  final group = cartController.comboGroups.firstWhereOrNull(
                    (g) => g.comboId == (combo.comboId ?? combo.name),
                  );
                  return SizedBox(
                    width: double.infinity,
                    child: group == null
                        ? ElevatedButton.icon(
                            onPressed: () {
                              cartController.addComboOffer(combo);
                              Get.snackbar(
                                'Added to Basket',
                                '${products.length} combo products added from ${combo.name}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppTheme.primaryGreen,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                margin: EdgeInsets.all(16.r),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Add Combo to Basket'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          )
                        : _buildQuantitySelector(group),
                  );
                }),
              ),
          ],
          if (isExpanded && products.isEmpty) ...[
            Divider(color: cs.outlineVariant, height: 1),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                'Products loading...',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(ComboCartGroup group) {
    final cart = CartController.instance;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => cart.decrementComboGroup(
              combo.comboId ?? combo.name,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              child: Icon(Icons.remove, color: Colors.white, size: 18.r),
            ),
          ),
          Text(
            '${group.items.first.quantity}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          InkWell(
            onTap: () => cart.incrementComboGroup(
              combo.comboId ?? combo.name,
            ),
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              child: Icon(Icons.add, color: Colors.white, size: 18.r),
            ),
          ),
        ],
      ),
    );
  }
}
