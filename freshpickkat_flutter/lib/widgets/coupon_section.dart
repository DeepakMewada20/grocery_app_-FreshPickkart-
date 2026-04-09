import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
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
  final TextEditingController _couponController = TextEditingController();
  final CartController _cartController = CartController.instance;
  final RxString _inputText = ''.obs;
  bool _showCouponList = false;

  @override
  void initState() {
    super.initState();
    _couponController.addListener(() {
      _inputText.value = _couponController.text;
      if (_inputText.value.isNotEmpty &&
          _cartController.couponError.value == 'Please enter a coupon code') {
        _cartController.couponError.value = '';
      }
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
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
                        _couponController.clear();
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

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          hintStyle: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.4),
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: cs.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: cs.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          filled: true,
                          fillColor: cs.surface,
                        ),
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 14,
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final isEmpty = _inputText.value.trim().isEmpty;
                      final isApplying = _cartController.isApplyingCoupon.value;
                      final typedCode = _couponController.text
                          .trim()
                          .toUpperCase();
                      final isApplyingTypedCoupon =
                          isApplying &&
                          typedCode.isNotEmpty &&
                          _cartController.applyingCouponCode.value == typedCode;
                      return ElevatedButton(
                        onPressed:
                            _cartController.isLoadingCoupons.value || isApplying
                            ? null
                            : () async {
                                if (isEmpty) {
                                  _cartController.couponError.value =
                                      'Please enter a coupon code';
                                  return;
                                }
                                await _cartController.applyCoupon(
                                  _couponController.text.trim(),
                                );
                                if (_cartController
                                    .couponError
                                    .value
                                    .isNotEmpty) {
                                  // Error is already shown in the UI via Obx, no need for snackbar
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Coupon applied successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEmpty
                              ? cs.inverseSurface
                              : AppTheme.primaryGreen,
                          foregroundColor: isEmpty
                              ? cs.onInverseSurface
                              : cs.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isEmpty ? 0 : 2,
                        ),
                        child: isApplyingTypedCoupon
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: isEmpty
                                      ? cs.onInverseSurface
                                      : cs.onPrimary,
                                ),
                              )
                            : const Text(
                                'Apply',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      );
                    }),
                  ],
                ),
                if (_cartController.couponError.value.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _cartController.couponError.value,
                    style: TextStyle(
                      color: cs.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            );
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
                      _couponController.text = bestCoupon.code;
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
                        _couponController.text = coupon.code;
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
  const _BestCouponCard({required this.coupon, required this.onApply});

  final CouponDisplay coupon;
  final Future<void> Function() onApply;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cs = Theme.of(context).colorScheme;
    final normalizedCode = coupon.code.trim().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Coupon',
            style: TextStyle(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            coupon.code,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            coupon.displayDiscount,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              final isApplyingThisCoupon =
                  cartController.isApplyingCoupon.value &&
                  cartController.applyingCouponCode.value == normalizedCode;
              return SizedBox(
                height: 38,
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
                      : const Text(
                          'Apply Best Coupon',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
