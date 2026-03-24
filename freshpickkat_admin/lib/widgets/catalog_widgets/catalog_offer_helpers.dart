import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

List<Coupon> filterCatalogCoupons(List<Coupon> coupons, String query) {
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return coupons;

  return coupons.where((coupon) {
    return coupon.code.toLowerCase().contains(normalized) ||
        coupon.description.toLowerCase().contains(normalized) ||
        coupon.couponCategory.toLowerCase().contains(normalized) ||
        (coupon.discountType ?? '').toLowerCase().contains(normalized);
  }).toList();
}

List<Product> filterCatalogOfferProducts({
  required List<Product> products,
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
      'live' => hasCatalogActiveOffer(product),
      'bogo' => isCatalogBogoOffer(product),
      'percentage' => isCatalogPercentageOffer(product),
      'flat' => isCatalogFlatOffer(product),
      'none' => !hasCatalogActiveOffer(product),
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
    final aHasOffer = hasCatalogActiveOffer(a);
    final bHasOffer = hasCatalogActiveOffer(b);
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

bool isCatalogPercentageOffer(Product product) {
  if (isCatalogBogoOffer(product)) return false;
  if (product.discountType == 'percentage') {
    return product.discount > 0;
  }
  if (product.discountType == 'flat') return false;
  return product.discount > 0;
}

bool isCatalogFlatOffer(Product product) {
  if (isCatalogBogoOffer(product) || isCatalogPercentageOffer(product)) {
    return false;
  }
  if (product.discountType == 'flat') {
    return catalogFlatDiscountValue(product) > 0;
  }
  if (product.discountType == 'percentage') return false;
  return catalogFlatDiscountValue(product) > 0;
}

bool hasCatalogActiveOffer(Product product) {
  return isCatalogBogoOffer(product) ||
      isCatalogPercentageOffer(product) ||
      isCatalogFlatOffer(product);
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
  if (isCatalogPercentageOffer(product)) {
    return '${product.discount.toStringAsFixed(0)}% OFF';
  }
  if (isCatalogFlatOffer(product)) {
    final value = catalogFlatDiscountValue(product);
    if (value > 0) {
      return 'FLAT ₹${value.toStringAsFixed(0)} OFF';
    }
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
  if (coupon.discountValue == null) return 'Free delivery';
  if (coupon.discountType == 'percentage') {
    return '${coupon.discountValue!.toStringAsFixed(0)}%';
  }
  return '₹${coupon.discountValue!.toStringAsFixed(0)}';
}
