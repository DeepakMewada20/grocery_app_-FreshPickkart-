class FreeDeliveryRuleModel {
  final String? ruleId;
  final String name;
  final String? description;
  final String ruleType;
  final double? minOrderAmount;
  final int? minItemsCount;
  final String? couponCode;
  final String? userId;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final double deliveryFeeWaived;

  FreeDeliveryRuleModel({
    this.ruleId,
    required this.name,
    this.description,
    required this.ruleType,
    this.minOrderAmount,
    this.minItemsCount,
    this.couponCode,
    this.userId,
    this.isActive = true,
    required this.startDate,
    required this.endDate,
    this.deliveryFeeWaived = 40.0,
  });

  factory FreeDeliveryRuleModel.fromEntity(dynamic rule) {
    return FreeDeliveryRuleModel(
      ruleId: rule.ruleId,
      name: rule.name ?? '',
      description: rule.description,
      ruleType: rule.ruleType ?? 'min_order_amount',
      minOrderAmount: rule.minOrderAmount?.toDouble(),
      minItemsCount: rule.minItemsCount,
      couponCode: rule.couponCode,
      userId: rule.userId,
      isActive: rule.isActive ?? true,
      startDate: rule.startDate ?? DateTime.now(),
      endDate: rule.endDate ?? DateTime.now().add(const Duration(days: 30)),
      deliveryFeeWaived: rule.deliveryFeeWaived?.toDouble() ?? 40.0,
    );
  }

  String get ruleLabel {
    switch (ruleType) {
      case 'min_order_amount':
        return 'Free delivery on orders above ₹${minOrderAmount?.toInt() ?? 0}';
      case 'min_items':
        return 'Free delivery on $minItemsCount+ items';
      case 'coupon':
        return 'Free delivery with coupon: $couponCode';
      case 'user_specific':
        return 'Free delivery (Personal offer)';
      default:
        return name;
    }
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && startDate.isBefore(now) && endDate.isAfter(now);
  }
}
