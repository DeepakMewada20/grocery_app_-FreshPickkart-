import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/coupon_extensions.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COUPON SECTION — Auto-Apply UX
//
// Design Philosophy:
//   • The app always applies the best eligible coupon automatically.
//   • Users never need to manually apply coupons.
//   • This section reassures the user they already have the maximum discount.
//   • "Apply" buttons have been intentionally removed.
// ─────────────────────────────────────────────────────────────────────────────

class CouponSection extends StatefulWidget {
  const CouponSection({super.key});

  @override
  State<CouponSection> createState() => _CouponSectionState();
}

class _CouponSectionState extends State<CouponSection> {
  final CartController _cartController = CartController.instance;
  bool _showCouponList = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!_cartController.hasCouponDataForCurrentCart) {
        _cartController.ensureAvailableCouponsLoaded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: AppSpacing.symmetric(horizontal: 16, vertical: 8),
      padding: AppSpacing.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: AppSpacing.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: AppTheme.primaryGreen,
                        size: AppIcons.small,
                      ),
                    ),
                    SizedBox(width: ScreenScale.w(10)),
                    Flexible(
                      child: AutoSizeText(
                        'Smart Savings',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: ScreenScale.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 12,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ScreenScale.w(8)),
              GestureDetector(
                onTap: () async {
                  setState(() => _showCouponList = !_showCouponList);
                  if (_showCouponList &&
                      !_cartController.hasCouponDataForCurrentCart) {
                    await _cartController.ensureAvailableCouponsLoaded();
                  }
                },
                child: AutoSizeText(
                  _showCouponList ? 'Hide offers' : 'View all offers',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: ScreenScale.sp(13),
                    fontWeight: FontWeight.w500,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(12)),

          // ── Status area ─────────────────────────────────────────────────
          Obx(() {
            // Loading indicator
            if (_cartController.isLoadingCoupons.value &&
                _cartController.availableCoupons.isEmpty) {
              return Padding(
                padding: AppSpacing.symmetric(vertical: 8),
                child: LinearProgressIndicator(
                  backgroundColor: cs.surfaceContainerHighest,
                  color: AppTheme.primaryGreen,
                ),
              );
            }

            // Error state
            if (_cartController.couponError.value.isNotEmpty &&
                _cartController.appliedCoupon.value == null) {
              return Text(
                _cartController.couponError.value,
                style: TextStyle(color: cs.error, fontSize: ScreenScale.sp(12)),
              );
            }

            // ── Coupon applied ────────────────────────────────────────────
            if (_cartController.appliedCoupon.value != null) {
              return _AppliedCouponCard(
                coupon: _cartController.appliedCoupon.value!,
                discount: _cartController.couponDiscount,
                cs: cs,
                onRemove: () => _cartController.removeCoupon(),
              );
            }

            // ── Best coupon available (not yet applied — rare state) ──────
            final bestCode = _cartController.bestCoupon.value?.bestCouponCode;
            if (bestCode != null && bestCode.isNotEmpty) {
              final bestCoupon = _cartController.availableCoupons
                  .firstWhereOrNull((c) => c.code == bestCode);
              if (bestCoupon != null && bestCoupon.isApplicable) {
                return _BestOfferAvailableCard(coupon: bestCoupon, cs: cs);
              }
            }

            // ── No applicable offers ─────────────────────────────────────
            if (_cartController.availableCoupons.isNotEmpty) {
              return _NoApplicableOfferHint(cs: cs);
            }

            return const SizedBox.shrink();
          }),

          // ── Offer list (view-only, expandable) ──────────────────────────
          if (_showCouponList) ...[
            SizedBox(height: ScreenScale.h(16)),
            const Divider(),
            SizedBox(height: ScreenScale.h(8)),
            Obx(() {
              if (_cartController.isLoadingCoupons.value) {
                return Center(
                  child: Padding(
                    padding: AppSpacing.all(20),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              if (_cartController.availableCoupons.isEmpty) {
                return Padding(
                  padding: AppSpacing.all(20),
                  child: Center(
                    child: Text(
                      'No offers available for your order',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              }

              // Build view-only list
              final applicable = _cartController.availableCoupons
                  .where((c) => c.isApplicable)
                  .toList();
              final notApplicable = _cartController.availableCoupons
                  .where((c) => !c.isApplicable)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (applicable.isNotEmpty) ...[
                    _SectionLabel(
                      label: 'Available Offers',
                      subtitle:
                          'Best offer is auto-applied • You can switch anytime',
                      cs: cs,
                    ),
                    SizedBox(height: ScreenScale.h(8)),
                    ...applicable.map(
                      (c) => Padding(
                        padding: AppSpacing.only(bottom: 8),
                        child: _OfferListCard(
                          coupon: c,
                          cs: cs,
                          onApply: () async {
                            await _cartController.applyCoupon(c.code);
                          },
                        ),
                      ),
                    ),
                  ],
                  if (notApplicable.isNotEmpty) ...[
                    SizedBox(height: ScreenScale.h(8)),
                    _SectionLabel(
                      label: 'Unlock More Offers',
                      subtitle: 'Add more items to unlock these',
                      cs: cs,
                    ),
                    SizedBox(height: ScreenScale.h(8)),
                    ...notApplicable.map(
                      (c) => Padding(
                        padding: AppSpacing.only(bottom: 8),
                        child: _OfferListCard(
                          coupon: c,
                          cs: cs,
                          onApply: null,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Applied coupon card — shown when the best coupon is active
// ─────────────────────────────────────────────────────────────────────────────
class _AppliedCouponCard extends StatelessWidget {
  final CouponDisplay coupon;
  final double discount;
  final ColorScheme cs;
  final VoidCallback onRemove;

  const _AppliedCouponCard({
    required this.coupon,
    required this.discount,
    required this.cs,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivery = coupon.isDeliveryDiscount;
    return Container(
      padding: AppSpacing.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto-applied badge row
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: AppIcons.small,
              ),
              SizedBox(width: ScreenScale.w(6)),
              Expanded(
                child: AutoSizeText(
                  'Best coupon applied automatically',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: ScreenScale.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  minFontSize: 10,
                ),
              ),
              // Subtle remove button
              GestureDetector(
                onTap: onRemove,
                child: Container(
                    padding: AppSpacing.all(4),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: ScreenScale.r(14),
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(10)),
          // Coupon code + savings
          Row(
            children: [
              Container(
                    padding: AppSpacing.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      color: Colors.green.shade600,
                      size: AppIcons.tiny,
                    ),
                    SizedBox(width: ScreenScale.w(4)),
                    Text(
                      coupon.code,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: ScreenScale.sp(13),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ScreenScale.w(10)),
              Expanded(
                child: Text(
                  isDelivery
                      ? 'Free delivery applied!'
                      : discount > 0
                      ? '₹${discount.formatPrice} saved on this order'
                      : coupon.displayDiscount,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: ScreenScale.sp(13),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(6)),
          Text(
            '✨ You are getting the best available offer',
            style: TextStyle(
              color: Colors.green.shade600.withValues(alpha: 0.8),
              fontSize: ScreenScale.sp(11),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Best offer available card (rare — shown briefly before auto-apply fires)
// ─────────────────────────────────────────────────────────────────────────────
class _BestOfferAvailableCard extends StatelessWidget {
  final CouponDisplay coupon;
  final ColorScheme cs;

  const _BestOfferAvailableCard({required this.coupon, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
                    padding: AppSpacing.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppTheme.primaryGreen,
              size: AppIcons.button,
            ),
          ),
          SizedBox(width: ScreenScale.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: AppSpacing.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Text(
                        'Best',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenScale.sp(9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenScale.w(6)),
                    Expanded(
                      child: AutoSizeText(
                        coupon.code,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: ScreenScale.sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenScale.h(4)),
                Text(
                  coupon.displayDiscount,
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: ScreenScale.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenScale.h(2)),
                Text(
                  'Best savings unlocked automatically',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontSize: ScreenScale.sp(11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// No applicable offer hint
// ─────────────────────────────────────────────────────────────────────────────
class _NoApplicableOfferHint extends StatelessWidget {
  final ColorScheme cs;
  const _NoApplicableOfferHint({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: cs.onSurface.withValues(alpha: 0.4),
            size: AppIcons.small,
          ),
          SizedBox(width: ScreenScale.w(8)),
          Expanded(
            child: Text(
              'Add more items to unlock exclusive offers',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontSize: ScreenScale.sp(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label for the expanded offer list
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final String? subtitle;
  final ColorScheme cs;
  const _SectionLabel({required this.label, this.subtitle, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.7),
            fontSize: ScreenScale.sp(12),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: ScreenScale.h(2)),
          Text(
            subtitle!,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.45),
              fontSize: ScreenScale.sp(10),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View-only offer card for the expanded list (no Apply button)
// ─────────────────────────────────────────────────────────────────────────────
class _OfferListCard extends StatelessWidget {
  final CouponDisplay coupon;
  final ColorScheme cs;

  /// null = no apply button (locked coupon)
  final Future<void> Function()? onApply;

  const _OfferListCard({
    required this.coupon,
    required this.cs,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final appliedCode = cartController.appliedCoupon.value?.code
        .trim()
        .toUpperCase();
    final isApplied =
        appliedCode != null && appliedCode == coupon.code.trim().toUpperCase();
    final isApplicable = coupon.isApplicable;
    final normalizedCode = coupon.code.trim().toUpperCase();

    return Container(
      padding: AppSpacing.all(12),
      decoration: BoxDecoration(
        color: isApplied ? Colors.green.withValues(alpha: 0.06) : cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: isApplied
              ? Colors.green.withValues(alpha: 0.35)
              : cs.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
                    padding: AppSpacing.all(8),
            decoration: BoxDecoration(
              color:
                  (isApplied
                          ? Colors.green
                          : isApplicable
                          ? AppTheme.primaryGreen
                          : cs.onSurface)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              isApplied
                  ? Icons.check_circle_rounded
                  : isApplicable
                  ? Icons.discount_rounded
                  : Icons.lock_outline_rounded,
              color: isApplied
                  ? Colors.green.shade600
                  : isApplicable
                  ? AppTheme.primaryGreen
                  : cs.onSurface.withValues(alpha: 0.35),
              size: AppIcons.button,
            ),
          ),
          SizedBox(width: ScreenScale.w(12)),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        coupon.code,
                        style: TextStyle(
                          color: isApplicable
                              ? cs.onSurface
                              : cs.onSurface.withValues(alpha: 0.45),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenScale.sp(13),
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (coupon.isBest) ...[
                      SizedBox(width: ScreenScale.w(6)),
                      Container(
                        padding: AppSpacing.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(ScreenScale.r(3)),
                        ),
                        child: Text(
                          'Best',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenScale.sp(8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: ScreenScale.h(3)),
                Text(
                  coupon.description,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontSize: ScreenScale.sp(11),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenScale.h(2)),
                Text(
                  isApplicable
                      ? coupon.displayDiscount
                      : (coupon.reason ?? 'Not applicable'),
                  style: TextStyle(
                    color: isApplicable
                        ? AppTheme.primaryGreen
                        : cs.onSurface.withValues(alpha: 0.4),
                    fontSize: ScreenScale.sp(11),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: ScreenScale.w(8)),

          // Action area — Apply button or status chip
          if (isApplied)
            // Applied chip
            Container(
                padding: AppSpacing.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
              ),
              child: Text(
                '✓ Applied',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: ScreenScale.sp(11),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (isApplicable && onApply != null)
            // Apply button — for eligible non-applied coupons
            Obx(() {
              final isApplyingThis =
                  cartController.isApplyingCoupon.value &&
                  cartController.applyingCouponCode.value == normalizedCode;
              return SizedBox(
                height: ScreenScale.h(34),
                child: ElevatedButton(
                  onPressed: cartController.isApplyingCoupon.value
                      ? null
                      : () async {
                          await onApply!();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: AppSpacing.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: isApplyingThis
                      ? SizedBox(
                          height: ScreenScale.r(14),
                          width: ScreenScale.r(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: ScreenScale.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            })
          else if (coupon.status == 'USED')
            // Used chip
            Container(
                padding: AppSpacing.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                  color: cs.onSurface.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                'Used',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: ScreenScale.sp(11),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            // Locked chip
            Container(
                padding: AppSpacing.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: cs.outlineVariant),
              ),
              child: Text(
                'Locked',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.35),
                  fontSize: ScreenScale.sp(11),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
