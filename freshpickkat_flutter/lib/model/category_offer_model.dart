class CategoryOfferModel {
  final String? offerId;
  final String name;
  final String? description;
  final String categoryId;
  final String? categoryName;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final double? minOrderAmount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int priority;

  CategoryOfferModel({
    this.offerId,
    required this.name,
    this.description,
    required this.categoryId,
    this.categoryName,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    this.minOrderAmount,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.priority = 0,
  });

  factory CategoryOfferModel.fromEntity(dynamic offer) {
    return CategoryOfferModel(
      offerId: offer.offerId,
      name: offer.name ?? '',
      description: offer.description,
      categoryId: offer.categoryId ?? '',
      categoryName: offer.categoryName,
      discountType: offer.discountType ?? 'flat',
      discountValue: offer.discountValue?.toDouble() ?? 0,
      maxDiscount: offer.maxDiscount?.toDouble(),
      minOrderAmount: offer.minOrderAmount?.toDouble(),
      startDate: offer.startDate ?? DateTime.now(),
      endDate: offer.endDate ?? DateTime.now().add(const Duration(days: 30)),
      isActive: offer.isActive ?? true,
      priority: offer.priority ?? 0,
    );
  }

  String get discountLabel {
    if (discountType == 'percentage') {
      return '${discountValue.toInt()}% OFF';
    } else {
      return '₹${discountValue.toInt()} OFF';
    }
  }

  String get minOrderLabel {
    if (minOrderAmount != null && minOrderAmount! > 0) {
      return 'Min order ₹${minOrderAmount!.toInt()}';
    }
    return '';
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && startDate.isBefore(now) && endDate.isAfter(now);
  }
}
