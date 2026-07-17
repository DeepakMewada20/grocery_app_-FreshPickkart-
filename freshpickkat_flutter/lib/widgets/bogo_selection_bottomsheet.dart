import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BogoSelectionBottomSheet extends StatefulWidget {
  final String triggerProductId;
  final String? triggerVariantId;
  final List<String> freeProductIds;

  const BogoSelectionBottomSheet({
    super.key,
    required this.triggerProductId,
    this.triggerVariantId,
    required this.freeProductIds,
  });

  @override
  State<BogoSelectionBottomSheet> createState() =>
      _BogoSelectionBottomSheetState();
}

class _BogoSelectionBottomSheetState extends State<BogoSelectionBottomSheet> {
  late String? _currentTriggerVariantId;
  bool _isSwitchingVariant = false;

  @override
  void initState() {
    super.initState();
    _currentTriggerVariantId = widget.triggerVariantId;
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;
    final bogoController = BogoController.instance;
    final cartController = CartController.instance;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final offerTheme =
        theme.extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(theme.brightness);

    final List<Product> eligibleProducts = widget.freeProductIds
        .map(
          (id) => productController.allProducts.firstWhereOrNull(
            (p) => p.productId == id,
          ),
        )
        .whereType<Product>()
        .toList();
    final triggerProduct = productController.allProducts.firstWhereOrNull(
      (product) => product.productId == widget.triggerProductId,
    );
    final offer = bogoController.getOfferForProduct(widget.triggerProductId);
    final triggerCartItem = cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == widget.triggerProductId &&
          (item.variantId ?? 'default') ==
              (_currentTriggerVariantId ?? 'default'),
    );
    final eligibleVariants = triggerProduct != null && offer != null
        ? eligibleBogoTriggerVariants(triggerProduct, offer)
        : const <ProductVariant>[];
    final isSelectionEnabled =
        triggerProduct != null &&
            offer != null &&
            widget.freeProductIds.isNotEmpty
        ? isBogoTriggerVariantEligible(
                triggerProduct,
                offer: offer,
                selectedVariantId: _currentTriggerVariantId,
              ) &&
              isBogoTriggerQuantityEligible(
                offer,
                triggerCartItem?.quantity ?? 0,
              )
        : true;
    final helperMessage = triggerProduct != null && offer != null
        ? _bogoHelperMessage(
            triggerProduct: triggerProduct,
            offer: offer,
            isSelectionEnabled: isSelectionEnabled,
            triggerQuantity: triggerCartItem?.quantity ?? 0,
          )
        : 'Select 1 item from the list below. This gift will be added at ₹0.';
    final selectedFreeProductId = triggerCartItem?.bogoFreeProductId;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: AppResponsive.sheetConstraints(context),
          child: Container(
            padding: AppSpacing.only(left: 20, top: 20, right: 20, bottom: 24),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.pill)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: AppSpacing.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: offerTheme.badgeSoft,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_offer_rounded,
                              size: AppIcons.small,
                              color: offerTheme.badge,
                            ),
                            SizedBox(width: 6.w),
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
                    isSelectionEnabled
                        ? 'Choose your free product'
                        : 'Free product locked for this pack',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    helperMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.68),
                    ),
                  ),
                  if (eligibleVariants.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.all(14),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSelectionEnabled
                                ? 'Eligible trigger packs'
                                : 'Upgrade trigger pack',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isSelectionEnabled
                                ? 'This offer works on these packs. You can switch here if needed.'
                                : 'Choose one of these packs to unlock your free product.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: eligibleVariants
                                .map((variant) {
                                  final isCurrent =
                                      variant.variantId ==
                                      _currentTriggerVariantId;
                                  return ChoiceChip(
                                    label: Text(
                                      formatBogoTriggerVariantLabel(variant),
                                    ),
                                    selected: isCurrent,
                                    onSelected: _isSwitchingVariant
                                        ? null
                                        : (selected) async {
                                            if (!selected || isCurrent) return;
                                            final switched =
                                                await _switchTriggerVariant(
                                                  variant.variantId,
                                                );
                                            if (!switched || !mounted) return;
                                            setState(() {
                                              _currentTriggerVariantId =
                                                  variant.variantId;
                                            });
                                          },
                                  );
                                })
                                .toList(growable: false),
                          ),
                          if (_isSwitchingVariant) ...[
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: offerTheme.badge,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Updating cart pack...',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 18.h),
                  if (eligibleProducts.isEmpty)
                    Padding(
                        padding: AppSpacing.symmetric(vertical: 12),
                      child: Text(
                        'No eligible products found.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: eligibleProducts.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final product = eligibleProducts[index];
                        final isSelected =
                            product.productId == selectedFreeProductId;
                        final displayQuantity = bogoController
                            .freeProductQuantityLabel(
                              widget.triggerProductId,
                              product.productId ?? '',
                              fallback: product.quantity,
                            );

                        return Container(
                          padding: AppSpacing.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? offerTheme.badgeSoft
                                : cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
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
                                borderRadius: BorderRadius.circular(AppRadius.large),
                                child: Container(
                                  width: 64.r,
                                  height: 64.r,
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
                                                  color: cs.onSurface
                                                      .withValues(
                                                        alpha: 0.4,
                                                      ),
                                                );
                                              },
                                        ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      displayQuantity,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: cs.onSurface.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      isSelectionEnabled
                                          ? 'FREE with this offer'
                                          : 'Available on eligible trigger packs',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: offerTheme.badge,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              FilledButton(
                                onPressed: !isSelectionEnabled
                                    ? null
                                    : () {
                                        cartController.setBogoSelection(
                                          widget.triggerProductId,
                                          product.productId,
                                          triggerVariantId:
                                              _currentTriggerVariantId,
                                        );
                                        Get.back();
                                      },
                                style: FilledButton.styleFrom(
                                  backgroundColor: offerTheme.badge,
                                  foregroundColor: offerTheme.onBadge,
                                  padding: AppSpacing.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  !isSelectionEnabled
                                      ? 'Unavailable'
                                      : (isSelected ? 'Selected' : 'Choose'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _switchTriggerVariant(String nextVariantId) async {
    setState(() => _isSwitchingVariant = true);
    try {
      return CartController.instance.switchRegularItemVariant(
        widget.triggerProductId,
        fromVariantId: _currentTriggerVariantId,
        toVariantId: nextVariantId,
      );
    } finally {
      if (mounted) {
        setState(() => _isSwitchingVariant = false);
      }
    }
  }
}

String _bogoHelperMessage({
  required Product triggerProduct,
  required BogoOffer offer,
  required bool isSelectionEnabled,
  required int triggerQuantity,
}) {
  if (isSelectionEnabled) {
    return 'Select your FREE product. This gift will be added at ₹0.';
  }
  final requiredQuantity = offer.minTriggerQuantity ?? 1;
  if (triggerQuantity < requiredQuantity) {
    final remaining = requiredQuantity - triggerQuantity;
    return 'Add $remaining more item${remaining == 1 ? '' : 's'} to unlock FREE product';
  }
  return buildBogoIneligibleMessage(triggerProduct, offer);
}
