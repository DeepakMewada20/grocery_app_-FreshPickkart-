import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../delivery/delivery_charge_calculator.dart';
import '../bogo/bogo_eligibility.dart';
import '../postgres/postgres_coupon_service.dart';
import '../postgres/postgres_fresh_points_service.dart';
import '../postgres/postgres_offer_service.dart';
import '../postgres/postgres_product_compat_service.dart';
import '../postgres/postgres_support.dart';

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
    int freshPointsToRedeem = 0,
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
      freshPointsDiscount: 0,
      freshPointsRedeemed: 0,
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
    final bogoOffers = await _fetchActiveBogoOffers(session);
    final productIds = items.map((i) => i.productId).toSet();
    for (final item in items) {
      final freeProductId = item.bogoFreeProductId?.trim();
      if (freeProductId != null && freeProductId.isNotEmpty) {
        productIds.add(freeProductId);
      }
    }
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

    final categoryOffers = await _fetchActiveCategoryOffers(session);
    final comboOffers = await _fetchActiveComboOffers(session);
    double effectiveSubtotal = subtotal;
    final unvalidatedBogoSelections = items
        .where((item) => item.bogoFreeProductId?.trim().isNotEmpty == true)
        .map(
          (item) =>
              '${item.productId}:${item.variantId ?? ''}:${item.bogoFreeProductId}',
        )
        .toSet();

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;
      final now = DateTime.now();
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;

      final matchingTriggerItems = items.where(
        (item) =>
            item.productId == offer.triggerProductId &&
            item.bogoFreeProductId != null,
      );

      for (final triggerItem in matchingTriggerItems) {
        unvalidatedBogoSelections.remove(
          '${triggerItem.productId}:${triggerItem.variantId ?? ''}:${triggerItem.bogoFreeProductId}',
        );
        final selectedFreeProductId = triggerItem.bogoFreeProductId?.trim();
        if (selectedFreeProductId == null || selectedFreeProductId.isEmpty) {
          continue;
        }
        final reward = findBogoReward(
          offer,
          freeProductId: selectedFreeProductId,
        );
        if (reward == null) {
          session.log(
            'BOGO reward not found for freeProductId=$selectedFreeProductId '
            'in offer ${offer.offerId}, trigger=${offer.triggerProductId}',
            level: LogLevel.warning,
          );
          unvalidatedBogoSelections.remove(
            '${triggerItem.productId}:${triggerItem.variantId ?? ''}:$selectedFreeProductId',
          );
          continue;
        }
        if (!isBogoTriggerEligible(
          triggerProduct: product,
          offer: offer,
          selectedVariantId: triggerItem.variantId,
        )) {
          throw ArgumentError(_bogoVariantError(product, offer));
        }
        if (triggerItem.quantity < (offer.minTriggerQuantity ?? 1)) {
          final remaining =
              (offer.minTriggerQuantity ?? 1) - triggerItem.quantity;
          throw ArgumentError(
            'Add $remaining more item${remaining == 1 ? '' : 's'} to unlock FREE product',
          );
        }
        final freeProduct = productMap[selectedFreeProductId];
        if (freeProduct == null) continue;

        final freeQty = calculateBogoFreeQuantity(
          offer: offer,
          reward: reward,
          triggerQuantity: triggerItem.quantity,
        );
        if (freeQty <= 0) continue;

        final discount =
            _resolveItemPrice(freeProduct, variantId: reward.variantId) *
            freeQty;
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
            variantId: reward.variantId,
            quantity: freeQty,
            triggerProductId: offer.triggerProductId,
            bogoOfferId: offer.offerId,
          ),
        );
      }
    }
    if (unvalidatedBogoSelections.isNotEmpty) {
      throw ArgumentError('Selected free product is not eligible.');
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

    // ── Shop More, Get More (eligibility based on effectiveSubtotal) ──
    final smgmOffer = await _offerService.getApplicableShopMoreGetMoreOffer(
      session,
      eligibleAmount: effectiveSubtotal,
    );
    if (smgmOffer != null) {
      String smgmProductName = '';
      if (productMap.containsKey(smgmOffer.freeProductId)) {
        smgmProductName =
            productMap[smgmOffer.freeProductId]?.productName ?? '';
      } else {
        try {
          final parsedPid = tryParseUuid(smgmOffer.freeProductId);
          if (parsedPid != null) {
            final pRow = await ProductRow.db.findById(session, parsedPid);
            smgmProductName = pRow?.name ?? '';
          }
        } catch (_) {}
      }
      freeItemsList.add(
        FreeItemInfo(
          productId: smgmOffer.freeProductId,
          productName: smgmProductName,
          variantId: smgmOffer.freeVariantId?.isNotEmpty == true
              ? smgmOffer.freeVariantId
              : null,
          quantity: smgmOffer.freeQuantity,
          rewardSource: 'SHOP_MORE_GET_MORE',
          rewardOfferId: smgmOffer.offerId,
          rewardOfferName: smgmOffer.name,
          rewardThreshold: smgmOffer.minimumOrderAmount,
        ),
      );
      appliedOffersList.add(
        AppliedOfferInfo(
          offerId: smgmOffer.offerId ?? '',
          offerName: smgmOffer.name,
          offerType: 'shop_more_get_more',
          discountAmount: 0,
        ),
      );
    }

    final deliveryPricing = await DeliveryChargeCalculator.calculate(
      session: session,
      cartTotal: effectiveSubtotal,
      userId: userId,
      cartItems: items,
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

    // ── FreshPoints discount (applied after coupon, before final total) ──
    if (freshPointsToRedeem > 0 && userId != null && userId.isNotEmpty) {
      try {
        final fpService = PostgresFreshPointsService();
        final settings = await fpService.getOrCreateSettings(session);
        if (settings.isEnabled &&
            totalAmount >= settings.minimumOrderForRedemption) {
          AppUserRow? user;
          final uid = userId;
          if (uid != null) {
            final parsedUuid = tryParseUuid(uid);
            if (parsedUuid != null) {
              user = await AppUserRow.db.findById(session, parsedUuid);
            } else {
              user = await AppUserRow.db.findFirstRow(
                session,
                where: (t) => t.firebaseUid.equals(uid),
              );
            }
          }
          if (user != null && user.currentFreshPoints > 0) {
            final maxByLimit =
                (totalAmount * settings.redemptionPercentageLimit / 100)
                    .floor();
            final actualRedeem = freshPointsToRedeem
                .clamp(0, maxByLimit < user.currentFreshPoints
                    ? maxByLimit
                    : user.currentFreshPoints);
            if (actualRedeem > 0) {
              final fpDiscount = actualRedeem.toDouble();
              result.freshPointsDiscount = fpDiscount;
              result.freshPointsRedeemed = actualRedeem;
              totalAmount = (totalAmount - fpDiscount).clamp(0, totalAmount);
            }
          }
        }
      } catch (_) {
        // If FreshPoints calculation fails, silently skip
      }
    }

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

    if (result.freshPointsDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'FreshPoints Used',
          amount: -result.freshPointsDiscount,
          type: 'freshPoints',
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
    Iterable<String> productIds,
  ) async {
    final Map<String, Product> productMap = {};
    if (productIds.isEmpty) return productMap;

    final products = await _productService.getProductsByIds(
      session,
      productIds.toSet().toList(),
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

  static String _bogoVariantError(Product triggerProduct, BogoOffer offer) {
    final configured = resolveConfiguredBogoTriggerVariant(
      triggerProduct,
      offer,
    );
    if (configured != null) {
      final label = configured.quantityDescription?.trim().isNotEmpty == true
          ? configured.quantityDescription!.trim()
          : '${_compactQuantity(configured.quantityValue)} ${configured.quantityUnit}';
      return 'Offer available only on $label and above';
    }
    if (offer.triggerBaseQuantity != null && offer.triggerBaseUnit != null) {
      return 'Offer available only on ${_compactQuantity(offer.triggerBaseQuantity!)} ${offer.triggerBaseUnit} and above';
    }
    return 'Selected pack is not eligible for this offer.';
  }

  static String _compactQuantity(double value) {
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toString();
  }
}
