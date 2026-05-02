import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/bogo/bogo_eligibility.dart';
import '../services/postgres/postgres_coupon_service.dart';
import '../services/postgres/postgres_offer_service.dart';
import '../services/postgres/postgres_product_compat_service.dart';

class PricingEngine {
  static final PostgresCouponService _couponService = PostgresCouponService();
  static final PostgresOfferService _offerService = PostgresOfferService();
  static final PostgresProductCompatService _productService =
      PostgresProductCompatService();

  static T? _firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
    for (final item in list) {
      if (test(item)) return item;
    }
    return null;
  }

  static double _resolveItemPrice(Product product, {String? variantId}) {
    if (variantId != null &&
        variantId.trim().isNotEmpty &&
        product.variants != null) {
      final variant = _firstWhereOrNull(
        product.variants!,
        (v) => v.variantId == variantId,
      );
      if (variant != null) {
        return variant.price;
      }
    }
    return product.price;
  }

  static Future<CartPricingResult> calculateCartPricing({
    required Session session,
    required List<CartItemInput> items,
    String? userId,
    String? appliedCouponCode,
    bool autoApplyCoupons = true,
  }) async {
    final result = CartPricingResult(
      subtotal: 0,
      itemDiscounts: 0,
      productOfferDiscount: 0,
      categoryOfferDiscount: 0,
      bogoDiscount: 0,
      comboDiscount: 0,
      couponDiscount: 0,
      deliveryFee: 0,
      originalDeliveryFee: 0,
      freeDeliveryApplied: false,
      deliveryPricing: null,
      totalSavings: 0,
      totalAmount: 0,
      appliedOffers: [],
      freeItems: [],
      pricingBreakdown: [],
    );

    if (items.isEmpty) {
      result.pricingBreakdown = [
        PricingLineItem(label: 'Subtotal', amount: 0, type: 'subtotal'),
        PricingLineItem(
          label: 'Delivery Fee',
          amount: 0,
          type: 'delivery',
        ),
        PricingLineItem(
          label: 'Total',
          amount: 0,
          type: 'total',
        ),
      ];
      result.totalAmount = 0;
      return result;
    }

    double subtotal = 0;
    double itemDiscounts = 0;
    final appliedOffersList = <AppliedOfferInfo>[];
    final freeItemsList = <FreeItemInfo>[];
    final productIds = items.map((i) => i.productId).toSet().toList();
    final productMap = await _fetchProducts(session, productIds);

    for (final item in items) {
      final product = productMap[item.productId];
      if (product == null) continue;

      final itemPrice = _resolveItemPrice(product, variantId: item.variantId);

      final itemTotal = itemPrice * item.quantity;
      subtotal += itemTotal;

      final discount = (product.realPrice) - itemPrice;
      if (discount > 0) {
        itemDiscounts += discount * item.quantity;
        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: product.productId ?? '',
            offerName: '${product.productName} Offer',
            offerType: 'product_discount',
            discountAmount: discount * item.quantity,
          ),
        );
      }
    }

    result.subtotal = subtotal;
    result.itemDiscounts = itemDiscounts;
    result.totalSavings += itemDiscounts;

    final bogoOffers = await _fetchActiveBogoOffers(session);
    final categoryOffers = await _fetchActiveCategoryOffers(session);
    final comboOffers = await _fetchActiveComboOffers(session);
    double effectiveSubtotal = subtotal;

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;
      final now = DateTime.now();
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;

      final matchingTriggerItems = items.where(
        (item) =>
            item.productId == offer.triggerProductId &&
            isBogoTriggerEligible(
              triggerProduct: product,
              offer: offer,
              selectedVariantId: item.variantId,
            ) &&
            item.bogoFreeProductId != null &&
            offer.freeProductIds.contains(item.bogoFreeProductId),
      );

      for (final triggerItem in matchingTriggerItems) {
        final selectedFreeProductId = triggerItem.bogoFreeProductId;
        if (selectedFreeProductId == null) continue;
        final freeProduct = productMap[selectedFreeProductId];
        if (freeProduct == null) continue;

        final freeQty = triggerItem.quantity;
        if (freeQty <= 0) continue;

        final discount = freeProduct.price * freeQty;
        result.bogoDiscount += discount;
        result.totalSavings += discount;

        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: offer.offerId ?? offer.triggerProductId,
            offerName: offer.offerTitle,
            offerType: 'bogo',
            discountAmount: discount,
          ),
        );

        freeItemsList.add(
          FreeItemInfo(
            productId: selectedFreeProductId,
            productName: freeProduct.productName,
            variantId: null,
            quantity: freeQty,
            triggerProductId: offer.triggerProductId,
          ),
        );
      }
    }

    for (final offer in categoryOffers) {
      if (!offer.isActive) continue;
      final now = DateTime.now();
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;
      if (offer.minOrderAmount != null &&
          effectiveSubtotal < offer.minOrderAmount!) {
        continue;
      }

      final categoryItems = items.where((i) {
        final product = productMap[i.productId];
        if (product == null) return false;
        return product.category == offer.categoryId ||
            (product.subcategory.isNotEmpty &&
                product.subcategory.contains(offer.categoryId));
      }).toList();

      if (categoryItems.isEmpty) continue;

      double categoryTotal = 0;
      for (final item in categoryItems) {
        final product = productMap[item.productId];
        if (product == null) continue;
        categoryTotal += product.price * item.quantity;
      }

      double discount = 0;
      if (offer.discountType == 'percentage') {
        discount = categoryTotal * (offer.discountValue / 100);
        if (offer.maxDiscount != null && discount > offer.maxDiscount!) {
          discount = offer.maxDiscount!;
        }
      } else {
        discount = offer.discountValue;
      }

      if (discount > 0) {
        result.categoryOfferDiscount += discount;
        result.totalSavings += discount;
        effectiveSubtotal -= discount;

        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: offer.offerId ?? offer.categoryId,
            offerName: offer.name,
            offerType: 'category',
            discountAmount: discount,
          ),
        );
      }
    }

    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      final now = DateTime.now();
      if (combo.startDate.isAfter(now) || combo.endDate.isBefore(now)) continue;

      final comboId = combo.comboId?.trim();
      if (comboId == null || comboId.isEmpty) {
        continue;
      }

      bool allProductsPresent = true;

      for (final comboProduct in combo.comboProducts) {
        final cartItem = _firstWhereOrNull(
          items,
          (i) =>
              i.productId == comboProduct.productId &&
              i.comboId == comboId &&
              i.quantity >= comboProduct.quantity,
        );
        if (cartItem == null) {
          allProductsPresent = false;
          break;
        }
      }

      if (allProductsPresent) {
        var bundleCount = 1 << 30;
        var comboSellingUnitTotal = 0.0;

        for (final comboProduct in combo.comboProducts) {
          final product = productMap[comboProduct.productId];
          if (product == null) {
            allProductsPresent = false;
            break;
          }

          final cartItem = _firstWhereOrNull(
            items,
            (i) =>
                i.productId == comboProduct.productId &&
                i.comboId == comboId &&
                ((comboProduct.variantId == null ||
                        comboProduct.variantId!.trim().isEmpty)
                    ? true
                    : i.variantId == comboProduct.variantId),
          );
          if (cartItem == null || cartItem.quantity < comboProduct.quantity) {
            allProductsPresent = false;
            break;
          }

          bundleCount = math.min(
            bundleCount,
            cartItem.quantity ~/ comboProduct.quantity,
          );
          comboSellingUnitTotal +=
              _resolveItemPrice(product, variantId: comboProduct.variantId) *
              comboProduct.quantity;
        }

        if (!allProductsPresent || bundleCount <= 0) continue;

        final discountPerBundle = combo.discountType == 'percentage'
            ? comboSellingUnitTotal * (combo.discountValue / 100)
            : combo.discountValue;
        final discount =
            discountPerBundle.clamp(0, comboSellingUnitTotal).toDouble() *
            bundleCount;

        if (discount > 0) {
          result.comboDiscount += discount;
          result.totalSavings += discount;
          effectiveSubtotal -= discount;

          appliedOffersList.add(
            AppliedOfferInfo(
              offerId: combo.comboId ?? '',
              offerName: combo.name,
              offerType: 'combo',
              discountAmount: discount,
            ),
          );
        }
      }
    }

    if (appliedCouponCode != null && appliedCouponCode.isNotEmpty) {
      final manualCoupon = await _couponService.applyCoupon(
        session,
        userId: userId ?? '',
        couponCode: appliedCouponCode,
        cartSubtotal: effectiveSubtotal,
        cartItems: items,
      );
      if (manualCoupon.isValid && manualCoupon.discountAmount > 0) {
        result.couponDiscount = manualCoupon.discountAmount;
        effectiveSubtotal -= manualCoupon.discountAmount;
        result.totalSavings += manualCoupon.discountAmount;

        result.appliedCoupon = AppliedCouponInfo(
          couponId: manualCoupon.couponId ?? manualCoupon.couponCode ?? '',
          couponCode: manualCoupon.couponCode ?? appliedCouponCode,
          discountAmount: manualCoupon.discountAmount,
          isAutoApplied: false,
        );
      }
    } else if (autoApplyCoupons) {
      final bestCoupon = await _couponService.getBestCoupon(
        session,
        userId: userId ?? '',
        cartSubtotal: effectiveSubtotal,
        cartItems: items,
      );
      if (bestCoupon.bestCouponCode != null && bestCoupon.discountAmount > 0) {
        result.couponDiscount = bestCoupon.discountAmount;
        effectiveSubtotal -= bestCoupon.discountAmount;
        result.totalSavings += bestCoupon.discountAmount;

        result.appliedCoupon = AppliedCouponInfo(
          couponId: bestCoupon.bestCouponCode!,
          couponCode: bestCoupon.bestCouponCode!,
          discountAmount: bestCoupon.discountAmount,
          isAutoApplied: true,
        );
      }
    }

    final deliveryPricing = await DeliveryEngine.calculate(
      session: session,
      cartTotal: effectiveSubtotal,
      userId: userId,
    );
    result.deliveryPricing = deliveryPricing;
    result.deliveryFee = deliveryPricing.deliveryFee;
    result.originalDeliveryFee = deliveryPricing.baseDeliveryFee;
    result.freeDeliveryApplied = deliveryPricing.isFree;
    if (deliveryPricing.isFree && deliveryPricing.baseDeliveryFee > 0) {
      appliedOffersList.add(
        AppliedOfferInfo(
          offerId: deliveryPricing.appliedRuleType ?? 'delivery',
          offerName: deliveryPricing.appliedRuleName ?? 'Free Delivery',
          offerType: 'free_delivery',
          discountAmount: deliveryPricing.baseDeliveryFee,
        ),
      );
    }

    double totalAmount = effectiveSubtotal + result.deliveryFee;
    if (totalAmount < 0) totalAmount = 0;

    result.totalAmount = totalAmount;
    result.appliedOffers = appliedOffersList;
    result.freeItems = freeItemsList;

    result.pricingBreakdown = [
      PricingLineItem(label: 'Subtotal', amount: subtotal, type: 'subtotal'),
    ];

    if (itemDiscounts > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Product Discounts',
          amount: -itemDiscounts,
          type: 'discount',
        ),
      );
    }
    if (result.bogoDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'BOGO Savings',
          amount: -result.bogoDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.categoryOfferDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Category Offer',
          amount: -result.categoryOfferDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.comboDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Combo Discount',
          amount: -result.comboDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.couponDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Coupon (${result.appliedCoupon?.couponCode ?? ""})',
          amount: -result.couponDiscount,
          type: 'coupon',
        ),
      );
    }

    result.pricingBreakdown.add(
      PricingLineItem(
        label: 'Delivery Fee',
        amount: result.deliveryFee,
        type: 'delivery',
      ),
    );

    result.pricingBreakdown.add(
      PricingLineItem(label: 'Total', amount: totalAmount, type: 'total'),
    );

    return result;
  }

  static Future<Map<String, Product>> _fetchProducts(
    Session session,
    List<String> productIds,
  ) async {
    final Map<String, Product> productMap = {};
    if (productIds.isEmpty) return productMap;

    final products = await _productService.getProductsByIds(
      session,
      productIds,
    );
    for (final product in products) {
      final productId = product.productId?.trim();
      if (productId == null || productId.isEmpty) continue;
      productMap[productId] = product;
    }
    return productMap;
  }

  static Future<List<BogoOffer>> _fetchActiveBogoOffers(Session session) {
    return _offerService.getActiveBogoOffers(session);
  }

  static Future<List<CategoryOffer>> _fetchActiveCategoryOffers(
    Session session,
  ) {
    return _offerService.getActiveCategoryOffers(session);
  }

  static Future<List<ComboOffer>> _fetchActiveComboOffers(Session session) {
    return _offerService.getActiveComboOffers(session);
  }
}
