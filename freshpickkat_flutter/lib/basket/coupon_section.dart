import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/coupon_extensions.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: AppTheme.primaryGreen,
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: AutoSizeText(
                        'Apply Coupon',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 12,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _showCouponList = !_showCouponList;
                  });
                  if (_showCouponList &&
                      !_cartController.hasCouponDataForCurrentCart) {
                    await _cartController.ensureAvailableCouponsLoaded();
                  }
                },
                child: AutoSizeText(
                  _showCouponList ? 'Hide coupons' : 'View available',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (_cartController.appliedCoupon.value != null) {
              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cartController.appliedCoupon.value!.code,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _cartController
                                    .appliedCoupon
                                    .value!
                                    .isDeliveryDiscount
                                ? 'Free delivery applied!'
                                : '₹${_cartController.couponDiscount.formatPrice} discount applied!',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _cartController.removeCoupon();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.green,
                        size: 20,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 32.r,
                        minHeight: 32.r,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            }

            if (_cartController.couponError.value.isNotEmpty) {
              return Text(
                _cartController.couponError.value,
                style: TextStyle(
                  color: cs.error,
                  fontSize: 12.sp,
                ),
              );
            }

            if (_cartController.isLoadingCoupons.value &&
                _cartController.availableCoupons.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: LinearProgressIndicator(
                  backgroundColor: cs.surfaceContainerHighest,
                  color: AppTheme.primaryGreen,
                ),
              );
            }

            final bestCouponCode =
                _cartController.bestCoupon.value?.bestCouponCode;
            if (bestCouponCode != null && bestCouponCode.isNotEmpty) {
              final bestCoupon = _cartController.availableCoupons
                  .firstWhereOrNull(
                    (coupon) => coupon.code == bestCouponCode,
                  );
              if (bestCoupon != null) {
                return _BestCouponCard(
                  coupon: bestCoupon,
                  compact: true,
                  onApply: () async {
                    await _cartController.applyCoupon(bestCoupon.code);
                    if (_cartController.couponError.value.isEmpty) {
                      setState(() {
                        _showCouponList = false;
                      });
                    }
                  },
                );
              }
            }

            return const SizedBox.shrink();
          }),
          if (_showCouponList) ...[
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 8.h),
            Obx(() {
              if (_cartController.isLoadingCoupons.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              if (_cartController.availableCoupons.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Center(
                    child: Text(
                      'No coupons available for your order',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              }

              final applicableCoupons = _cartController.availableCoupons
                  .where((coupon) => coupon.isApplicable)
                  .toList();
              final notApplicableCoupons = _cartController.availableCoupons
                  .where((coupon) => !coupon.isApplicable)
                  .toList();
              final bestCoupon = _cartController.bestCoupon.value == null
                  ? null
                  : _cartController.availableCoupons.firstWhereOrNull(
                      (coupon) =>
                          coupon.code ==
                          _cartController.bestCoupon.value!.bestCouponCode,
                    );

              final children = <Widget>[];
              if (bestCoupon != null) {
                children.add(
                  _BestCouponCard(
                    coupon: bestCoupon,
                    onApply: () async {
                      await _cartController.applyCoupon(bestCoupon.code);
                      if (_cartController.couponError.value.isEmpty) {
                        setState(() {
                          _showCouponList = false;
                        });
                      }
                    },
                  ),
                );
              }
              if (applicableCoupons.isNotEmpty) {
                children.add(
                  Text(
                    'Available Coupons',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
                for (final coupon in applicableCoupons) {
                  children.add(
                    _CouponCard(
                      coupon: coupon,
                      onApply: () async {
                        await _cartController.applyCoupon(coupon.code);
                        setState(() {
                          _showCouponList = false;
                        });
                      },
                    ),
                  );
                }
              }
              if (notApplicableCoupons.isNotEmpty) {
                children.add(
                  Text(
                    'Not Applicable Coupons',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
                for (final coupon in notApplicableCoupons) {
                  children.add(
                    _CouponCard(coupon: coupon, onApply: () async {}),
                  );
                }
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: children.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) => children[index],
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final CouponDisplay coupon;
  final Future<void> Function() onApply;

  const _CouponCard({
    required this.coupon,
    required this.onApply,
  });

  String _couponButtonLabel() {
    if (coupon.status == 'used') return 'Used';
    final appliedCode = CartController.instance.appliedCoupon.value?.code;
    if (appliedCode != null &&
        appliedCode.toUpperCase() == coupon.code.toUpperCase()) {
      return 'Applied';
    }
    return coupon.isApplicable ? 'Apply' : 'Locked';
  }

  String _couponBadgeLabel() {
    if (coupon.isBest) return 'Best';

    switch (coupon.type) {
      case 'FIRST_ORDER':
        return 'First Order';
      case 'PERCENTAGE_DISCOUNT':
        return '% Off';
      case 'FLAT_DISCOUNT':
        return 'Flat Off';
      case 'LIMITED_TIME':
        return 'Limited Time';
      case 'LOYALTY':
        return 'Loyalty';
      case 'PRODUCT_BASED':
        return 'Product';
      default:
        return 'Coupon';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;
    final normalizedCode = coupon.code.trim().toUpperCase();

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final details = Expanded(
            child: _CouponDetails(
              coupon: coupon,
              badgeLabel: _couponBadgeLabel(),
              cs: cs,
            ),
          );
          final applyButton = Obx(
            () {
              final isApplyingThisCoupon =
                  cartController.isApplyingCoupon.value &&
                  cartController.applyingCouponCode.value == normalizedCode;
              final buttonLabel = _couponButtonLabel();
              final isButtonActive = buttonLabel == 'Apply' &&
                  !cartController.isApplyingCoupon.value;
              return ElevatedButton(
                onPressed: isButtonActive
                    ? () async {
                        await onApply();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonLabel == 'Used'
                      ? cs.surfaceContainerHighest
                      : buttonLabel == 'Applied'
                          ? Colors.green.shade50
                          : coupon.isApplicable
                              ? AppTheme.primaryGreen
                              : cs.surface,
                  foregroundColor: buttonLabel == 'Used'
                      ? cs.onSurface.withValues(alpha: 0.4)
                      : buttonLabel == 'Applied'
                          ? Colors.green.shade700
                          : coupon.isApplicable
                              ? cs.onPrimary
                              : cs.primary,
                  elevation: coupon.isApplicable ? 2 : 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  minimumSize: Size(60.w, 32.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: buttonLabel == 'Used'
                        ? BorderSide.none
                        : buttonLabel == 'Applied'
                            ? BorderSide(color: Colors.green.shade300)
                            : coupon.isApplicable
                                ? BorderSide.none
                                : BorderSide(
                                    color: AppTheme.primaryGreen
                                        .withValues(alpha: 0.5),
                                  ),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isApplyingThisCoupon
                    ? SizedBox(
                        height: 14.r,
                        width: 14.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: coupon.isApplicable
                              ? cs.onPrimary
                              : AppTheme.primaryGreen,
                        ),
                      )
                    : AutoSizeText(
                        _couponButtonLabel(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 9,
                        maxLines: 1,
                      ),
              );
            },
          );
          final icon = Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.discount_outlined,
              color: AppTheme.primaryGreen,
              size: 20.r,
            ),
          );
          if (constraints.maxWidth < 330) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    icon,
                    SizedBox(width: 12.w),
                    details,
                  ],
                ),
                SizedBox(height: 10.h),
                Align(alignment: Alignment.centerRight, child: applyButton),
              ],
            );
          }
          return Row(
            children: [
              icon,
              SizedBox(width: 12.w),
              details,
              SizedBox(width: 10.w),
              applyButton,
            ],
          );
        },
      ),
    );
  }
}

class _CouponDetails extends StatelessWidget {
  const _CouponDetails({
    required this.coupon,
    required this.badgeLabel,
    required this.cs,
  });

  final CouponDisplay coupon;
  final String badgeLabel;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AutoSizeText(
              coupon.code,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              minFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: AutoSizeText(
                badgeLabel,
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 8,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          coupon.description,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontSize: 12.sp,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          coupon.isApplicable
              ? coupon.displayDiscount
              : (coupon.reason ?? 'Not applicable'),
          style: TextStyle(
            color: coupon.isApplicable ? AppTheme.primaryGreen : cs.error,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          'Min. order: ₹${coupon.minOrderAmount.formatPrice}',
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.4),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class _BestCouponCard extends StatelessWidget {
  const _BestCouponCard({
    required this.coupon,
    required this.onApply,
    this.compact = false,
  });

  final CouponDisplay coupon;
  final Future<void> Function() onApply;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;
    final normalizedCode = coupon.code.trim().toUpperCase();

    return Container(
      padding: EdgeInsets.all((compact ? 10 : 12).r),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Obx(() {
        final appliedCode = cartController.appliedCoupon.value?.code
            .trim()
            .toUpperCase();
        final isThisCouponApplied = appliedCode == normalizedCode;
        final isApplyingThisCoupon =
            cartController.isApplyingCoupon.value &&
            cartController.applyingCouponCode.value == normalizedCode;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AutoSizeText(
                          'Best',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 8,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AutoSizeText(
                          coupon.code,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: (compact ? 14 : 16).sp,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    coupon.displayDiscount,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.75),
                      fontSize: (compact ? 12 : 13).sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Min. order: ₹${coupon.minOrderAmount.formatPrice}',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: (compact ? 10 : 11).sp,
                    ),
                  ),
                ],
              ),
            ),
            if (!isThisCouponApplied) ...[
              SizedBox(width: 12.w),
              SizedBox(
                height: (compact ? 34 : 38).h,
                child: ElevatedButton(
                  onPressed: cartController.isApplyingCoupon.value
                      ? null
                      : () async {
                          await onApply();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: (compact ? 12 : 16).w,
                    ),
                  ),
                  child: isApplyingThisCoupon
                      ? SizedBox(
                          height: 16.r,
                          width: 16.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : AutoSizeText(
                          compact ? 'Apply' : 'Apply Best Coupon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (compact ? 12 : 14).sp,
                          ),
                          minFontSize: 9,
                          maxLines: 1,
                        ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
