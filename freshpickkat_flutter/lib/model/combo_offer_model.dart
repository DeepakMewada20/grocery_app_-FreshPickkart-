class ComboOfferModel {
  final String? comboId;
  final String name;
  final String? description;
  final List<ComboProductItemModel> comboProducts;
  final String discountType;
  final double discountValue;
  final int minQuantityPerProduct;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int priority;

  ComboOfferModel({
    this.comboId,
    required this.name,
    this.description,
    required this.comboProducts,
    required this.discountType,
    required this.discountValue,
    this.minQuantityPerProduct = 1,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.priority = 0,
  });

  factory ComboOfferModel.fromEntity(dynamic offer) {
    return ComboOfferModel(
      comboId: offer.comboId,
      name: offer.name,
      description: offer.description,
      comboProducts:
          (offer.comboProducts as List?)
              ?.map((cp) => ComboProductItemModel.fromEntity(cp))
              .toList() ??
          [],
      discountType: offer.discountType ?? 'flat',
      discountValue: offer.discountValue?.toDouble() ?? 0,
      minQuantityPerProduct: offer.minQuantityPerProduct ?? 1,
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

  String get productsLabel {
    return comboProducts.map((cp) => cp.productName ?? 'Product').join(' + ');
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && startDate.isBefore(now) && endDate.isAfter(now);
  }
}

class ComboProductItemModel {
  final String productId;
  final String? productName;
  final int quantity;
  final String? variantId;

  ComboProductItemModel({
    required this.productId,
    this.productName,
    required this.quantity,
    this.variantId,
  });

  factory ComboProductItemModel.fromEntity(dynamic item) {
    return ComboProductItemModel(
      productId: item.productId ?? '',
      productName: item.productName,
      quantity: item.quantity ?? 1,
      variantId: item.variantId,
    );
  }
}
