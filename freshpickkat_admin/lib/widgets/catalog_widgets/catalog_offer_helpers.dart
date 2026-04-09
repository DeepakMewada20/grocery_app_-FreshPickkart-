import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

List<Coupon> filterCatalogCoupons(List<Coupon> coupons, String query) {
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return coupons;

  return coupons.where((coupon) {
    return coupon.code.toLowerCase().contains(normalized) ||
        coupon.description.toLowerCase().contains(normalized) ||
        coupon.couponCategory.toLowerCase().contains(normalized) ||
        (coupon.type ?? '').toLowerCase().contains(normalized);
  }).toList();
}

List<Product> filterCatalogOfferProducts({
  required List<Product> products,
  required List<BogoOffer> bogoOffers,
  required List<CategoryOffer> categoryOffers,
  required List<ComboOffer> comboOffers,
  required String query,
  required String offerTypeFilter,
  required String categoryFilter,
}) {
  final normalizedQuery = query.toLowerCase().trim();
  final filtered = products.where((product) {
    final categoryMatch =
        categoryFilter == 'All' || product.category == categoryFilter;
    if (!categoryMatch) return false;

    final offerTypeMatch = switch (offerTypeFilter) {
      'live' => hasCatalogAnyLiveOffer(
        product,
        bogoOffers: bogoOffers,
        categoryOffers: categoryOffers,
        comboOffers: comboOffers,
      ),
      'bogo' => hasCatalogConfiguredBogoOffer(product, bogoOffers: bogoOffers),
      'category_offer' => hasCatalogLiveCategoryOffer(
        product,
        categoryOffers: categoryOffers,
      ),
      'combo_offer' => hasCatalogLiveComboOffer(
        product,
        comboOffers: comboOffers,
      ),
      'percentage' => hasCatalogConfiguredPercentageOffer(product),
      'flat' => hasCatalogConfiguredFlatOffer(product),
      'none' => !hasCatalogAnyLiveOffer(
        product,
        bogoOffers: bogoOffers,
        categoryOffers: categoryOffers,
        comboOffers: comboOffers,
      ),
      _ => true,
    };
    if (!offerTypeMatch) return false;

    if (normalizedQuery.isEmpty) return true;
    final offerLabel = catalogProductOfferLabel(product).toLowerCase();
    return product.productName.toLowerCase().contains(normalizedQuery) ||
        product.category.toLowerCase().contains(normalizedQuery) ||
        product.quantity.toLowerCase().contains(normalizedQuery) ||
        offerLabel.contains(normalizedQuery);
  }).toList();

  filtered.sort((a, b) {
    final aHasOffer = hasCatalogAnyLiveOffer(
      a,
      bogoOffers: bogoOffers,
      categoryOffers: categoryOffers,
      comboOffers: comboOffers,
    );
    final bHasOffer = hasCatalogAnyLiveOffer(
      b,
      bogoOffers: bogoOffers,
      categoryOffers: categoryOffers,
      comboOffers: comboOffers,
    );
    if (aHasOffer != bHasOffer) {
      return aHasOffer ? -1 : 1;
    }
    return a.productName.toLowerCase().compareTo(b.productName.toLowerCase());
  });
  return filtered;
}

bool isCatalogBogoOffer(Product product) {
  final freeIds = product.bogoFreeProductIds ?? const <String>[];
  return product.discountType == 'bogo' || freeIds.isNotEmpty;
}

bool hasCatalogConfiguredBogoOffer(
  Product product, {
  required List<BogoOffer> bogoOffers,
}) {
  final productId = product.productId;
  if (productId == null) return isCatalogBogoOffer(product);
  return bogoOffers.any((offer) => offer.triggerProductId == productId) ||
      isCatalogBogoOffer(product);
}

bool hasCatalogLiveBogoOffer(
  Product product, {
  required List<BogoOffer> bogoOffers,
}) {
  final productId = product.productId;
  if (productId == null) return false;
  final now = DateTime.now();
  return bogoOffers.any((offer) {
    return offer.triggerProductId == productId &&
        offer.isActive &&
        !offer.startDate.isAfter(now) &&
        !offer.endDate.isBefore(now);
  });
}

bool hasCatalogConfiguredPercentageOffer(Product product) {
  if (isCatalogBogoOffer(product)) return false;
  final configuredValue = product.discountValue ?? product.discount;
  if (product.discountType == 'percentage') {
    return configuredValue > 0;
  }
  if (product.discountType == 'flat') return false;
  return product.discount > 0;
}

bool hasCatalogActivePercentageOffer(Product product) {
  return hasCatalogConfiguredPercentageOffer(product) &&
      product.realPrice > 0 &&
      product.price < product.realPrice;
}

bool hasCatalogConfiguredFlatOffer(Product product) {
  if (isCatalogBogoOffer(product) ||
      hasCatalogConfiguredPercentageOffer(product)) {
    return false;
  }
  if (product.discountType == 'flat') {
    return (product.discountValue ?? 0) > 0 ||
        catalogFlatDiscountValue(product) > 0;
  }
  if (product.discountType == 'percentage') return false;
  return catalogFlatDiscountValue(product) > 0;
}

bool hasCatalogActiveFlatOffer(Product product) {
  return hasCatalogConfiguredFlatOffer(product) &&
      product.realPrice > 0 &&
      product.price < product.realPrice;
}

bool isCatalogPercentageOffer(Product product) {
  return hasCatalogActivePercentageOffer(product);
}

bool isCatalogFlatOffer(Product product) {
  return hasCatalogActiveFlatOffer(product);
}

bool hasCatalogAnyLiveOffer(
  Product product, {
  required List<BogoOffer> bogoOffers,
  required List<CategoryOffer> categoryOffers,
  required List<ComboOffer> comboOffers,
}) {
  return hasCatalogLiveBogoOffer(product, bogoOffers: bogoOffers) ||
      hasCatalogActivePercentageOffer(product) ||
      hasCatalogActiveFlatOffer(product) ||
      hasCatalogLiveCategoryOffer(product, categoryOffers: categoryOffers) ||
      hasCatalogLiveComboOffer(product, comboOffers: comboOffers);
}

bool hasCatalogLiveCategoryOffer(
  Product product, {
  required List<CategoryOffer> categoryOffers,
}) {
  final productId = product.productId;
  final now = DateTime.now();
  return categoryOffers.any((offer) {
    if (!offer.isActive ||
        offer.startDate.isAfter(now) ||
        offer.endDate.isBefore(now)) {
      return false;
    }
    if (productId != null &&
        (offer.excludeProductIds ?? const <String>[]).contains(productId)) {
      return false;
    }
    final productIds = offer.productIds ?? const <String>[];
    if (productIds.isNotEmpty && productId != null) {
      return productIds.contains(productId);
    }
    return offer.categoryName == product.category ||
        offer.categoryId == product.category;
  });
}

bool hasCatalogLiveComboOffer(
  Product product, {
  required List<ComboOffer> comboOffers,
}) {
  final productId = product.productId;
  if (productId == null) return false;
  final now = DateTime.now();
  return comboOffers.any((offer) {
    if (!offer.isActive ||
        offer.startDate.isAfter(now) ||
        offer.endDate.isBefore(now)) {
      return false;
    }
    return offer.comboProducts.any((item) => item.productId == productId);
  });
}

double catalogFlatDiscountValue(Product product) {
  final directValue = product.discountValue ?? 0;
  if (directValue > 0) return directValue;
  final computedValue = product.realPrice - product.price;
  return computedValue > 0 ? computedValue : 0;
}

String catalogProductOfferLabel(Product product) {
  if (isCatalogBogoOffer(product)) {
    final freeCount = (product.bogoFreeProductIds ?? const <String>[]).length;
    return freeCount > 0 ? 'BOGO • $freeCount free choices' : 'BOGO';
  }
  if (hasCatalogConfiguredPercentageOffer(product)) {
    final percent = product.discountValue ?? product.discount;
    return '${percent.toStringAsFixed(0)}% OFF';
  }
  if (hasCatalogConfiguredFlatOffer(product)) {
    final value = catalogFlatDiscountValue(product);
    if (value > 0) {
      return 'FLAT ₹${value.toStringAsFixed(0)} OFF';
    }
  }
  return 'No active offer';
}

String catalogProductOfferLabelWithLinkedOffers(
  Product product, {
  required List<BogoOffer> bogoOffers,
  required List<CategoryOffer> categoryOffers,
  required List<ComboOffer> comboOffers,
}) {
  if (hasCatalogConfiguredBogoOffer(product, bogoOffers: bogoOffers)) {
    final freeCount = (product.bogoFreeProductIds ?? const <String>[]).length;
    return freeCount > 0 ? 'BOGO • $freeCount free choices' : 'BOGO';
  }
  if (hasCatalogConfiguredPercentageOffer(product)) {
    final percent = product.discountValue ?? product.discount;
    return '${percent.toStringAsFixed(0)}% OFF';
  }
  if (hasCatalogConfiguredFlatOffer(product)) {
    final value = catalogFlatDiscountValue(product);
    if (value > 0) {
      return 'FLAT ₹${value.toStringAsFixed(0)} OFF';
    }
  }
  if (hasCatalogLiveCategoryOffer(product, categoryOffers: categoryOffers)) {
    return 'Category Offer';
  }
  if (hasCatalogLiveComboOffer(product, comboOffers: comboOffers)) {
    return 'Combo Offer';
  }
  return 'No active offer';
}

bool isCatalogCouponLive(Coupon coupon) {
  if (!coupon.isActive) return false;
  final today = DateUtils.dateOnly(DateTime.now());
  final start = DateUtils.dateOnly(coupon.startDate);
  final end = DateUtils.dateOnly(coupon.endDate);
  return !today.isBefore(start) && !today.isAfter(end);
}

String catalogCouponStatusLabel(Coupon coupon) {
  if (!coupon.isActive) return 'Inactive';
  final today = DateUtils.dateOnly(DateTime.now());
  final start = DateUtils.dateOnly(coupon.startDate);
  final end = DateUtils.dateOnly(coupon.endDate);
  if (today.isBefore(start)) return 'Scheduled';
  if (today.isAfter(end)) return 'Expired';
  return 'Live';
}

Color catalogCouponStatusColor(Coupon coupon) {
  final status = catalogCouponStatusLabel(coupon);
  switch (status) {
    case 'Live':
      return Colors.green;
    case 'Scheduled':
      return Colors.orange;
    case 'Expired':
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}

String catalogDateLabel(DateTime value) {
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

String catalogCouponValueLabel(Coupon coupon) {
  if (coupon.discountValue == null) return 'N/A';
  if (coupon.type == 'PERCENTAGE_DISCOUNT') {
    return '${coupon.discountValue!.toStringAsFixed(0)}%';
  }
  return '₹${coupon.discountValue!.toStringAsFixed(0)}';
}
