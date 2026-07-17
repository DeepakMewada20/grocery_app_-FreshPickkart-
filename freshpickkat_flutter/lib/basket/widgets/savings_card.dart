import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:get/get.dart';

/// Persistent savings breakdown card shown inside the cart.
///
/// Shows an itemized list of every saving category that is > 0,
/// plus a bold total. Values update in real time via Obx.
/// The total amount pulses with a scale animation whenever it increases.
class SavingsCard extends StatefulWidget {
  const SavingsCard({super.key});

  @override
  State<SavingsCard> createState() => _SavingsCardState();
}

class _SavingsCardState extends State<SavingsCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  double _prevTotalSavings = 0;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _maybePulse(double newTotal) {
    if (newTotal > _prevTotalSavings + 0.5) {
      _pulseCtrl.forward(from: 0);
    }
    _prevTotalSavings = newTotal;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? cs.primary : AppTheme.primaryGreen;

    return Obx(() {
      final cart = CartController.instance;

      final productSavings = cart.productDiscountTotal;
      final comboSavings = cart.comboDiscountTotal;
      final bogoSavings = cart.bogoDiscountTotal;
      final freeGiftSavings = cart.freeGiftSavings;
      final couponSavings = cart.couponDiscount;
      final deliverySavings = cart.deliveryDiscountAmount;
      final freshPointsSavings =
          cart.cartPricing.value?.freshPointsDiscount ?? 0.0;

      final totalSavings =
          productSavings +
          comboSavings +
          bogoSavings +
          freeGiftSavings +
          couponSavings +
          deliverySavings +
          freshPointsSavings;

      if (totalSavings <= 0) return const SizedBox.shrink();

      // Trigger pulse when savings grow
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybePulse(totalSavings);
      });

      final rows = <_SavingsRow>[];
      if (productSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.sell_rounded,
            label: 'Product Savings',
            amount: productSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (comboSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.discount_rounded,
            label: 'Combo Savings',
            amount: comboSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (bogoSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.card_giftcard_rounded,
            label: 'BOGO Savings',
            amount: bogoSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (freeGiftSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.celebration_rounded,
            label: 'Free Gift Savings',
            amount: freeGiftSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (couponSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.local_offer_rounded,
            label: 'Coupon Savings',
            amount: couponSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (deliverySavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.local_shipping_rounded,
            label: 'Delivery Savings',
            amount: deliverySavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }
      if (freshPointsSavings > 0) {
        rows.add(
          _SavingsRow(
            icon: Icons.monetization_on_rounded,
            label: 'FreshPoints Savings',
            amount: freshPointsSavings,
            accentColor: accentColor,
            cs: cs,
          ),
        );
      }

      return Container(
        margin: EdgeInsets.fromLTRB(16.r, 0, 16.r, 16.r),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.25 : 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
                  padding: AppSpacing.only(left: 16, top: 16, right: 16, bottom: 12),

              child: Row(
                children: [
                  Container(
                    padding: AppSpacing.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: accentColor,
                      size: AppIcons.button,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '💰 Your Savings',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, color: cs.outlineVariant),

            // Itemized rows
            Padding(
              padding: AppSpacing.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: rows,
              ),
            ),

            // Total savings — animated pulse
            Container(
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              padding: AppSpacing.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          accentColor.withValues(alpha: 0.18),
                          accentColor.withValues(alpha: 0.08),
                        ]
                      : [
                          accentColor.withValues(alpha: 0.12),
                          accentColor.withValues(alpha: 0.05),
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                  color: accentColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Savings',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: Text(
                      '₹${totalSavings.formatPrice}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Motivational footer
            Padding(
              padding: AppSpacing.only(left: 16, top: 0, right: 16, bottom: 14),
              child: Text(
                '🎉 Great savings! Every rupee counts.',
                style: TextStyle(
                  color: accentColor.withValues(alpha: 0.75),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// A single itemized savings row
// ─────────────────────────────────────────────────────────────────────────────
class _SavingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color accentColor;
  final ColorScheme cs;

  const _SavingsRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.accentColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: accentColor, size: AppIcons.small),
          SizedBox(width: 8.w),
          Icon(icon, color: cs.onSurface.withValues(alpha: 0.5), size: 14.r),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '₹${amount.formatPrice}',
            style: TextStyle(
              color: accentColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
