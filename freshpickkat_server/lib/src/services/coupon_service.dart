import '../generated/protocol.dart';

class CouponService {
  static CouponValidationResult validateCoupon({
    required Coupon coupon,
    required double orderAmount,
  }) {
    final now = DateTime.now().toUtc();

    if (!coupon.isActive) {
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'This coupon is no longer active',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    if (now.isBefore(coupon.startDate.toUtc())) {
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'This coupon is not yet valid',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    if (now.isAfter(coupon.endDate.toUtc())) {
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'This coupon has expired',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    if (coupon.usageLimit != null && coupon.usedCount >= coupon.usageLimit!) {
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'This coupon has reached its usage limit',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    if (orderAmount < coupon.minOrderAmount) {
      return CouponValidationResult(
        isValid: false,
        errorMessage:
            'Minimum order amount of ₹${coupon.minOrderAmount.toStringAsFixed(0)} required',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    final isDeliveryDiscount =
        coupon.couponCategory.toLowerCase() == 'delivery';

    if (isDeliveryDiscount) {
      final deliveryFee = calculateDeliveryFee(orderAmount);
      double discountAmount = deliveryFee;

      if (coupon.maxDiscount != null && discountAmount > coupon.maxDiscount!) {
        discountAmount = coupon.maxDiscount!;
      }

      return CouponValidationResult(
        isValid: true,
        discountAmount: discountAmount,
        isDeliveryDiscount: true,
      );
    }

    if (coupon.discountType == null || coupon.discountValue == null) {
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'Invalid coupon configuration',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    double discountAmount = 0;

    if (coupon.discountType == 'flat') {
      discountAmount = coupon.discountValue!;
    } else if (coupon.discountType == 'percentage') {
      discountAmount = (orderAmount * coupon.discountValue!) / 100;

      if (coupon.maxDiscount != null && discountAmount > coupon.maxDiscount!) {
        discountAmount = coupon.maxDiscount!;
      }
    }

    return CouponValidationResult(
      isValid: true,
      discountAmount: discountAmount,
      isDeliveryDiscount: false,
    );
  }

  static List<CouponDisplay> getApplicableCoupons({
    required List<Coupon> coupons,
    required double orderAmount,
  }) {
    final now = DateTime.now().toUtc();
    final applicableCoupons = <CouponDisplay>[];

    for (var coupon in coupons) {
      if (!coupon.isActive) continue;
      if (now.isBefore(coupon.startDate.toUtc())) continue;
      if (now.isAfter(coupon.endDate.toUtc())) continue;
      if (coupon.usageLimit != null && coupon.usedCount >= coupon.usageLimit!) {
        continue;
      }

      applicableCoupons.add(
        CouponDisplay(
          code: coupon.code,
          description: coupon.description,
          couponCategory: coupon.couponCategory,
          minOrderAmount: coupon.minOrderAmount,
          maxDiscount: coupon.maxDiscount,
          discountValue: coupon.discountValue,
          discountType: coupon.discountType,
          isDeliveryDiscount: coupon.couponCategory.toLowerCase() == 'delivery',
          isApplicable: orderAmount >= coupon.minOrderAmount,
        ),
      );
    }

    return applicableCoupons;
  }

  static double calculateDeliveryFee(double subtotal) {
    return 40.0;
  }
}
