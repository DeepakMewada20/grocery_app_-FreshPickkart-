import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

List<Coupon> _filterCatalogCouponsByStatus(
  List<Coupon> coupons,
  String statusFilter,
) {
  switch (statusFilter) {
    case 'live':
      return coupons.where(isCatalogCouponLive).toList();
    case 'inactive':
      return coupons.where((coupon) => !coupon.isActive).toList();
    default:
      return coupons;
  }
}

List<Coupon> filterCatalogCoupons(
  List<Coupon> coupons,
  String query, {
  String statusFilter = 'all',
  String categoryFilter = 'all',
}) {
  var filtered = _filterCatalogCouponsByStatus(coupons, statusFilter);
  if (categoryFilter != 'all') {
    filtered = filtered
        .where((coupon) => coupon.couponCategory == categoryFilter)
        .toList();
  }
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return filtered;

  return filtered.where((coupon) {
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
      'category_offer' => _hasCatalogLiveCategoryOffer(
        product,
        categoryOffers: categoryOffers,
      ),
      'combo_offer' => _hasCatalogLiveComboOffer(
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

bool _isCatalogBogoOffer(Product product) {
  final freeIds = product.bogoFreeProductIds ?? const <String>[];
  return product.discountType == 'bogo' || freeIds.isNotEmpty;
}

bool hasCatalogConfiguredBogoOffer(
  Product product, {
  required List<BogoOffer> bogoOffers,
}) {
  final productId = product.productId;
  if (productId == null) return _isCatalogBogoOffer(product);
  return bogoOffers.any((offer) => offer.triggerProductId == productId) ||
      _isCatalogBogoOffer(product);
}

bool _hasCatalogLiveBogoOffer(
  Product product, {
  required List<BogoOffer> bogoOffers,
}) {
  final productId = product.productId;
  if (productId == null) return false;
  final now = DateTime.now();
  return bogoOffers.any((offer) {
    if (offer.triggerProductId != productId || !offer.isActive) return false;
    if (offer.startDate != null && offer.startDate!.isAfter(now)) return false;
    if (offer.endDate != null && offer.endDate!.isBefore(now)) return false;
    return true;
  });
}

bool hasCatalogConfiguredPercentageOffer(Product product) {
  if (_isCatalogBogoOffer(product)) return false;
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
  if (_isCatalogBogoOffer(product) ||
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
  return _hasCatalogLiveBogoOffer(product, bogoOffers: bogoOffers) ||
      hasCatalogActivePercentageOffer(product) ||
      hasCatalogActiveFlatOffer(product) ||
      _hasCatalogLiveCategoryOffer(product, categoryOffers: categoryOffers) ||
      _hasCatalogLiveComboOffer(product, comboOffers: comboOffers);
}

bool _hasCatalogLiveCategoryOffer(
  Product product, {
  required List<CategoryOffer> categoryOffers,
}) {
  final productId = product.productId;
  final now = DateTime.now();
  return categoryOffers.any((offer) {
    if (!offer.isActive) return false;
    if (offer.startDate != null && offer.startDate!.isAfter(now)) return false;
    if (offer.endDate != null && offer.endDate!.isBefore(now)) return false;
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

bool _hasCatalogLiveComboOffer(
  Product product, {
  required List<ComboOffer> comboOffers,
}) {
  final productId = product.productId;
  if (productId == null) return false;
  final now = DateTime.now();
  return comboOffers.any((offer) {
    if (!offer.isActive) return false;
    if (offer.startDate != null && offer.startDate!.isAfter(now)) return false;
    if (offer.endDate != null && offer.endDate!.isBefore(now)) return false;
    return offer.comboProducts.any((item) => item.productId == productId);
  });
}

List<ShopMoreGetMoreOffer> filterCatalogSmgmOffers(
  List<ShopMoreGetMoreOffer> offers,
  String query,
) {
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return offers;
  return offers.where((offer) {
    return offer.name.toLowerCase().contains(normalized) ||
        offer.freeProductId.toLowerCase().contains(normalized);
  }).toList();
}

double catalogFlatDiscountValue(Product product) {
  final directValue = product.discountValue ?? 0;
  if (directValue > 0) return directValue;
  final computedValue = product.realPrice - product.price;
  return computedValue > 0 ? computedValue : 0;
}

String catalogProductOfferLabel(Product product) {
  if (_isCatalogBogoOffer(product)) {
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
      return 'FLAT ₹${value.toStringAsFixed(2)} OFF';
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
      return 'FLAT ₹${value.toStringAsFixed(2)} OFF';
    }
  }
  if (_hasCatalogLiveCategoryOffer(product, categoryOffers: categoryOffers)) {
    return 'Category Offer';
  }
  if (_hasCatalogLiveComboOffer(product, comboOffers: comboOffers)) {
    return 'Combo Offer';
  }
  return 'No active offer';
}

bool isCatalogCouponLive(Coupon coupon) {
  if (!coupon.isActive) return false;
  final today = DateUtils.dateOnly(DateTime.now());
  if (coupon.startDate != null &&
      today.isBefore(DateUtils.dateOnly(coupon.startDate!))) {
    return false;
  }
  if (coupon.endDate != null &&
      today.isAfter(DateUtils.dateOnly(coupon.endDate!))) {
    return false;
  }
  return true;
}

String catalogCouponStatusLabel(Coupon coupon) {
  if (!coupon.isActive) return 'Inactive';
  final today = DateUtils.dateOnly(DateTime.now());
  if (coupon.startDate != null &&
      today.isBefore(DateUtils.dateOnly(coupon.startDate!))) {
    return 'Scheduled';
  }
  if (coupon.endDate != null &&
      today.isAfter(DateUtils.dateOnly(coupon.endDate!))) {
    return 'Expired';
  }
  return 'Live';
}

Color catalogCouponStatusColor(BuildContext context, Coupon coupon) {
  final status = catalogCouponStatusLabel(coupon);
  switch (status) {
    case 'Live':
      return AdminAppTheme.getSuccessColor(context);
    case 'Scheduled':
      return AdminAppTheme.getWarningColor(context);
    case 'Expired':
      return AdminAppTheme.getErrorColor(context);
    default:
      return AdminAppTheme.getNeutralColor(context);
  }
}

String catalogDateLabel(DateTime? value) {
  if (value == null) return 'No expiry';
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

String catalogCouponValueLabel(Coupon coupon) {
  if (coupon.discountValue == null) return 'N/A';
  if (coupon.type == 'PERCENTAGE_DISCOUNT') {
    return '${coupon.discountValue!.toStringAsFixed(0)}%';
  }
  return '₹${coupon.discountValue!.toStringAsFixed(2)}';
}
