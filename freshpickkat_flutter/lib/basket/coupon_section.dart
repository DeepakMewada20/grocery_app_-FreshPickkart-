import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Apply Coupon',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                child: Text(
                  _showCouponList ? 'Hide coupons' : 'View available',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (_cartController.appliedCoupon.value != null) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
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
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _cartController
                                    .appliedCoupon
                                    .value!
                                    .isDeliveryDiscount
                                ? 'Free delivery applied!'
                                : '₹${_cartController.couponDiscount.formatPrice} discount applied!',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                            ),
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
                      constraints: const BoxConstraints(),
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
                  fontSize: 12,
                ),
              );
            }

            if (_cartController.isLoadingCoupons.value &&
                _cartController.availableCoupons.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Obx(() {
              if (_cartController.isLoadingCoupons.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_cartController.availableCoupons.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
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
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.discount_outlined,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      coupon.code,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _couponBadgeLabel(),
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.description,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.isApplicable
                      ? coupon.displayDiscount
                      : (coupon.reason ?? 'Not applicable'),
                  style: TextStyle(
                    color: coupon.isApplicable
                        ? AppTheme.primaryGreen
                        : cs.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Min. order: ₹${coupon.minOrderAmount.formatPrice}',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () {
              final isApplyingThisCoupon =
                  cartController.isApplyingCoupon.value &&
                  cartController.applyingCouponCode.value == normalizedCode;
              return ElevatedButton(
                onPressed:
                    coupon.isApplicable &&
                        !cartController.isApplyingCoupon.value
                    ? () async {
                        await onApply();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: coupon.isApplicable
                      ? AppTheme.primaryGreen
                      : cs.surface,
                  foregroundColor: coupon.isApplicable
                      ? cs.onPrimary
                      : cs.primary,
                  elevation: coupon.isApplicable ? 2 : 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: coupon.isApplicable
                        ? BorderSide.none
                        : BorderSide(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.5),
                          ),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isApplyingThisCoupon
                    ? SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: coupon.isApplicable
                              ? cs.onPrimary
                              : cs.primary,
                        ),
                      )
                    : Text(
                        coupon.isApplicable ? 'Apply' : 'Locked',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
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
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Best',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          coupon.code,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: compact ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    coupon.displayDiscount,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.75),
                      fontSize: compact ? 12 : 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Min. order: ₹${coupon.minOrderAmount.formatPrice}',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: compact ? 10 : 11,
                    ),
                  ),
                ],
              ),
            ),
            if (!isThisCouponApplied) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: compact ? 34 : 38,
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 12 : 16,
                    ),
                  ),
                  child: isApplyingThisCoupon
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : Text(
                          compact ? 'Apply' : 'Apply Best Coupon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: compact ? 12 : 14,
                          ),
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
