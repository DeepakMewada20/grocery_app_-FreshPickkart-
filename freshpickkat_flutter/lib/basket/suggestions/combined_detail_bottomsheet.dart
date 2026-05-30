import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/combo_offer_card.dart';
import 'package:get/get.dart';

class CombinedDetailBottomSheet extends StatelessWidget {
  final client.BasketSuggestion suggestion;

  const CombinedDetailBottomSheet({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actions = (suggestion.actions ?? []).take(3).toList(growable: false);

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: AppResponsive.sheetConstraints(context),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: AppTheme.primaryGreen,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Combined Deal Breakdown',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${actions.length} step${actions.length == 1 ? '' : 's'} to stack this deal',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.5),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...actions.asMap().entries.map((entry) {
                          final i = entry.key;
                          final action = entry.value;
                          final isLast = i == actions.length - 1;

                          if (_actionKind(action) == 'combo') {
                            return _ComboTimelineStep(
                              stepNumber: i + 1,
                              isLast: isLast,
                              action: action,
                            );
                          }

                          return Stack(
                            children: [
                              if (!isLast)
                                Positioned(
                                  top: 28.r,
                                  bottom: 0,
                                  left: 14.r - 1.r, // Centered relative to 28.r circle
                                  width: 2.r,
                                  child: Container(
                                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 28.r,
                                    height: 28.r,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 24.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            action.label,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            _stepDescription(action),
                                            style: TextStyle(
                                              color: cs.onSurface.withValues(
                                                alpha: 0.6,
                                              ),
                                              fontSize: 13.sp,
                                              height: 1.3,
                                            ),
                                          ),
                                          if ((action.extraSpend ?? 0) > 0 ||
                                              (action.benefit ?? 0) > 0) ...[
                                            SizedBox(height: 10.h),
                                            Wrap(
                                              spacing: 8.w,
                                              runSpacing: 8.h,
                                              children: [
                                                if ((action.extraSpend ?? 0) > 0)
                                                  _InfoPill(
                                                    label:
                                                        'Spend ₹${action.extraSpend!.formatPrice}',
                                                  ),
                                                if ((action.benefit ?? 0) > 0)
                                                  _InfoPill(
                                                    label:
                                                        'Save ₹${action.benefit!.formatPrice}',
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    _getIcon(action),
                                    size: 18.r,
                                    color: cs.onSurface.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _Stat(
                                label: 'Extra Spend',
                                value:
                                    '₹${suggestion.extraSpend?.formatPrice ?? "0"}',
                                color: cs.onSurface,
                              ),
                              _Stat(
                                label: 'Total Benefit',
                                value:
                                    '₹${((suggestion.netProfit ?? 0) + (suggestion.extraSpend ?? 0)).formatPrice}',
                                color: AppTheme.primaryGreen,
                              ),
                              _Stat(
                                label: 'Net Profit',
                                value:
                                    '₹${(suggestion.netProfit ?? 0).formatPrice}',
                                color: const Color(0xFFE6A23C),
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h.clamp(48.0, 62.0).toDouble(),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      CartController.instance.applyBasketSuggestion(suggestion);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: AutoSizeText(
                      'Apply All Steps',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _actionKind(client.BasketSuggestionAction action) {
    if (action.type == 'coupon' ||
        action.type == 'apply_coupon' ||
        action.couponCode != null) {
      return 'coupon';
    }
    if (action.type == 'combo' || action.comboId != null) {
      return 'combo';
    }
    if (action.type == 'bogo') {
      return 'bogo';
    }
    if (action.type == 'delivery') {
      return 'delivery';
    }
    if (action.type == 'variant') {
      return 'variant';
    }
    if (action.type == 'product' ||
        action.type == 'add_to_cart' ||
        action.productId != null) {
      return 'product';
    }
    return action.type;
  }

  String _stepDescription(client.BasketSuggestionAction action) {
    switch (_actionKind(action)) {
      case 'coupon':
        final code = action.couponCode;
        return code == null || code.trim().isEmpty
            ? 'Apply the coupon after cart updates to stack extra savings.'
            : 'Apply $code after the cart updates to unlock extra savings.';
      case 'delivery':
        return (action.extraSpend ?? 0) > 0
            ? 'This stack also pushes the basket toward lower delivery charges.'
            : 'Delivery savings are already included in this stack.';
      case 'variant':
        return 'Switch to the better-value pack before checkout.';
      case 'combo':
        return 'Add the combo bundle to activate its offer pricing.';
      case 'bogo':
        return (action.extraSpend ?? 0) > 0
            ? 'Add the trigger product first, then choose your free item.'
            : 'Choose your free item from the active BOGO offer.';
      case 'product':
        return 'Add the product required for this stacked deal.';
      default:
        return action.ctaLabel;
    }
  }

  IconData _getIcon(client.BasketSuggestionAction action) {
    switch (_actionKind(action)) {
      case 'coupon':
        return Icons.confirmation_number_rounded;
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'variant':
        return Icons.trending_up_rounded;
      case 'combo':
        return Icons.layers_rounded;
      case 'bogo':
        return Icons.card_giftcard_rounded;
      case 'product':
        return Icons.local_offer_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _ComboTimelineStep extends StatelessWidget {
  final int stepNumber;
  final bool isLast;
  final client.BasketSuggestionAction action;

  const _ComboTimelineStep({
    required this.stepNumber,
    required this.isLast,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isLast)
          Positioned(
            top: 28.r,
            bottom: 0,
            left: 14.r - 1.r,
            width: 2.r,
            child: Container(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: _ComboOfferBreakdownCard(action: action),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComboOfferBreakdownCard extends StatefulWidget {
  final client.BasketSuggestionAction action;

  const _ComboOfferBreakdownCard({required this.action});

  @override
  State<_ComboOfferBreakdownCard> createState() =>
      _ComboOfferBreakdownCardState();
}

class _ComboOfferBreakdownCardState extends State<_ComboOfferBreakdownCard> {
  bool _isExpanded = false;
  String? _prefetchedComboId;

  @override
  void initState() {
    super.initState();
    ComboOfferController.instance.fetchActiveComboOffersIfEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final comboId =
          widget.action.comboId ?? widget.action.payload?['comboId'];
      final combo = ComboOfferController.instance.activeComboOffers
          .firstWhereOrNull(
            (offer) => (offer.comboId ?? offer.name) == comboId,
          );

      if (combo == null) {
        return _FallbackComboCard(
          isExpanded: _isExpanded,
          onToggle: () => setState(() => _isExpanded = !_isExpanded),
          title: widget.action.label,
          subtitle: 'Combo details are loading from the active offers list.',
        );
      }

      final productIds = combo.comboProducts
          .map((item) => item.productId)
          .toSet();
      if (_prefetchedComboId != (combo.comboId ?? combo.name)) {
        _prefetchedComboId = combo.comboId ?? combo.name;
        ProductProviderController.instance.fetchProductsByIds(
          productIds.toList(),
        );
      }

      final products = resolveComboProducts(
        combo,
        ProductProviderController.instance.allProducts,
      );
      return ComboOfferCard(
        combo: combo,
        products: products,
        isExpanded: _isExpanded,
        isHighlighted: _isExpanded,
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        isCompactVariant: true,
      );
    });
  }
}

class _FallbackComboCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final String title;
  final String subtitle;

  const _FallbackComboCard({
    required this.isExpanded,
    required this.onToggle,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      title,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                      minFontSize: 11,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isExpanded) ...[
                      SizedBox(height: 6.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;

  const _InfoPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          fontSize: 11.5.sp,
          color: cs.onSurface.withValues(alpha: 0.72),
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 8,
        maxLines: 1,
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
          minFontSize: 8,
          maxLines: 1,
        ),
        SizedBox(height: 4.h),
        AutoSizeText(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            color: color,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
          minFontSize: 10,
          maxLines: 1,
        ),
      ],
    );
  }
}
