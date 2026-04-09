// Generated file - Create manually based on server model
// This model represents the public-facing coupon data sent to clients

class CouponDisplay {
  final String? type;
  final String code;
  final String description;
  final String couponCategory;
  final double minOrderAmount;
  final double? maxDiscount;
  final double? discountValue;
  final bool isDeliveryDiscount;

  CouponDisplay({
    this.type,
    required this.code,
    required this.description,
    required this.couponCategory,
    required this.minOrderAmount,
    this.maxDiscount,
    this.discountValue,
    required this.isDeliveryDiscount,
  });

  factory CouponDisplay.fromJson(Map<String, dynamic> json) {
    return CouponDisplay(
      type: json['type'] as String?,
      code: json['code'] as String,
      description: json['description'] as String,
      couponCategory: json['couponCategory'] as String,
      minOrderAmount: (json['minOrderAmount'] as num).toDouble(),
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      isDeliveryDiscount: json['isDeliveryDiscount'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'code': code,
      'description': description,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      'maxDiscount': maxDiscount,
      'discountValue': discountValue,
      'isDeliveryDiscount': isDeliveryDiscount,
    };
  }

  @override
  String toString() {
    return 'CouponDisplay(code: $code, description: $description, couponCategory: $couponCategory, minOrderAmount: $minOrderAmount, discountValue: $discountValue, isDeliveryDiscount: $isDeliveryDiscount)';
  }
}
