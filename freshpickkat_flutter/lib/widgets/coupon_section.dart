import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

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
              Obx(() {
                if (_cartController.appliedCoupon.value != null) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _cartController.appliedCoupon.value!.code,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCouponList = !_showCouponList;
                      if (_showCouponList) {
                        _cartController.fetchAvailableCoupons();
                      }
                    });
                  },
                  child: Text(
                    _showCouponList ? 'Hide coupons' : 'View available',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
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
                                : '₹${_cartController.couponDiscount.toStringAsFixed(0)} discount applied!',
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
                      return ElevatedButton(
                        onPressed: _cartController.isLoadingCoupons.value
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
                        child: const Text(
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

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cartController.availableCoupons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final coupon = _cartController.availableCoupons[index];
                  return _CouponCard(
                    coupon: coupon,
                    onApply: () {
                      if (coupon.isApplicable) {
                        _couponController.text = coupon.code;
                        _cartController.applyCoupon(coupon.code);
                        setState(() {
                          _showCouponList = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Minimum order of ₹${coupon.minOrderAmount.toStringAsFixed(0)} required for this coupon',
                            ),
                            backgroundColor: cs.error,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
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
  final VoidCallback onApply;

  const _CouponCard({
    required this.coupon,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              coupon.isDeliveryDiscount
                  ? Icons.local_shipping_outlined
                  : Icons.discount_outlined,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      coupon.code,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                        coupon.isDeliveryDiscount ? 'Delivery' : 'Price',
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
                  'Min. order: ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: coupon.isApplicable
                  ? AppTheme.primaryGreen
                  : cs.surface,
              foregroundColor: coupon.isApplicable ? cs.onPrimary : cs.primary,
              elevation: coupon.isApplicable ? 2 : 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: coupon.isApplicable
                    ? BorderSide.none
                    : BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Apply',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
