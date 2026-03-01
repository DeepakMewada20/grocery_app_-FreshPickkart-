// Generated file - Create manually based on server model
// This model represents the public-facing coupon data sent to clients

class CouponDisplay {
  final String code;
  final String description;
  final String couponCategory;
  final double minOrderAmount;
  final double? maxDiscount;
  final double? discountValue;
  final String? discountType;
  final bool isDeliveryDiscount;

  CouponDisplay({
    required this.code,
    required this.description,
    required this.couponCategory,
    required this.minOrderAmount,
    this.maxDiscount,
    this.discountValue,
    this.discountType,
    required this.isDeliveryDiscount,
  });

  factory CouponDisplay.fromJson(Map<String, dynamic> json) {
    return CouponDisplay(
      code: json['code'] as String,
      description: json['description'] as String,
      couponCategory: json['couponCategory'] as String,
      minOrderAmount: (json['minOrderAmount'] as num).toDouble(),
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      discountType: json['discountType'] as String?,
      isDeliveryDiscount: json['isDeliveryDiscount'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      'maxDiscount': maxDiscount,
      'discountValue': discountValue,
      'discountType': discountType,
      'isDeliveryDiscount': isDeliveryDiscount,
    };
  }

  @override
  String toString() {
    return 'CouponDisplay(code: $code, description: $description, couponCategory: $couponCategory, minOrderAmount: $minOrderAmount, discountValue: $discountValue, isDeliveryDiscount: $isDeliveryDiscount)';
  }
}
