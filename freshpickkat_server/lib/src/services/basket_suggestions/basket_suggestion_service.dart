import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../../endpoints/bogo_endpoint.dart';
import '../../endpoints/combo_offer_endpoint.dart';
import '../../endpoints/product_endpoint.dart';
import '../../generated/protocol.dart';
import '../coupon_service.dart';
import '../delivery/delivery_engine.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Internal scoring wrapper — never sent to client, pure Dart
// ─────────────────────────────────────────────────────────────────────────────
class _Scored {
  final BasketSuggestion suggestion;
  final double extraSpend;
  final double totalBenefit;
  final double netProfit;
  final double profitEfficiency;

  const _Scored({
    required this.suggestion,
    required this.extraSpend,
    required this.totalBenefit,
  }) : netProfit = totalBenefit - extraSpend,
       profitEfficiency = totalBenefit / (extraSpend + 1);
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────
class BasketSuggestionService {
  static const Duration _cacheTtl = Duration(minutes: 2);

  static List<BogoOffer>? _cachedBogoOffers;
  static DateTime? _cachedBogoAt;

  static List<ComboOffer>? _cachedComboOffers;
  static DateTime? _cachedComboAt;

  static DeliveryConfig? _cachedDeliveryConfig;
  static DateTime? _cachedDeliveryConfigAt;

  static List<Coupon>? _cachedCoupons;
  static DateTime? _cachedCouponsAt;

  // ─────────────────────────────────────────────────────────────────────────
  // Public entry point
  // ─────────────────────────────────────────────────────────────────────────
  static Future<BasketSuggestionResult> getSuggestions({
    required Session session,
    required List<CartItemInput> items,
    required double cartTotal,
    String? userId,
    String? appliedCouponCode,
  }) async {
    if (items.isEmpty) {
      return BasketSuggestionResult(suggestions: const []);
    }

    final normalizedItems = items
        .where((item) => item.productId.trim().isNotEmpty && item.quantity > 0)
        .toList();
    if (normalizedItems.isEmpty) {
      return BasketSuggestionResult(suggestions: const []);
    }

    // ── 1. Fetch all data (with cache) ──────────────────────────────────────
    final productIds = normalizedItems.map((item) => item.productId).toSet();
    final comboOffers = await _getComboOffers(session);
    for (final combo in comboOffers) {
      if (combo.isActive) {
        for (final cp in combo.comboProducts) {
          productIds.add(cp.productId);
        }
      }
    }

    final products = await ProductEndpoint().getProductsByIds(
      session,
      productIds.toList(),
    );
    final productMap = {
      for (final p in products)
        if (p.productId != null) p.productId!: p,
    };

    final deliveryConfig = await _getDeliveryConfig();
    final coupons = await _getCoupons();
    final bogoOffers = await _getBogoOffers(session);

    // ── 2. Build all individual scored suggestions ──────────────────────────
    final scored = <_Scored>[];

    final deliveryScored = _scoreDelivery(
      cartTotal: cartTotal,
      config: deliveryConfig,
    );
    if (deliveryScored != null) scored.add(deliveryScored);

    final couponScored = _scoreCoupon(
      cartTotal: cartTotal,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
    );
    if (couponScored != null) scored.add(couponScored);

    final bogoScored = _scoreBogoSuggestions(
      cartItems: normalizedItems,
      bogoOffers: bogoOffers,
      productMap: productMap,
    );
    scored.addAll(bogoScored);

    final comboScored = _scoreComboSuggestions(
      cartItems: normalizedItems,
      comboOffers: comboOffers,
      productMap: productMap,
    );
    scored.addAll(comboScored);

    final variantScored = _scoreVariantSuggestions(
      cartItems: normalizedItems,
      productMap: productMap,
    );
    scored.addAll(variantScored);

    // ── 3. Build combination suggestions ────────────────────────────────────
    final upgradedBaseItems = <_Scored>{};
    final combinations = _buildCombinations(
      cartTotal: cartTotal,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
      variantScored: variantScored,
      comboScored: comboScored,
      deliveryScored: deliveryScored,
      upgradedBaseItems: upgradedBaseItems,
    );
    scored.addAll(combinations);
    scored.removeWhere((item) => upgradedBaseItems.contains(item));

    // ── 4. Sort by: netProfit DESC → profitEfficiency DESC → extraSpend ASC ─
    scored.sort((a, b) {
      final np = b.netProfit.compareTo(a.netProfit);
      if (np != 0) return np;
      final pe = b.profitEfficiency.compareTo(a.profitEfficiency);
      if (pe != 0) return pe;
      return a.extraSpend.compareTo(b.extraSpend);
    });

    // ── 5. Stamp is_best on rank-0, write scoring into metadata ─────────────
    final results = <BasketSuggestion>[];
    for (var i = 0; i < scored.length && results.length < 6; i++) {
      final s = scored[i];
      final isBest = i == 0;
      final meta = Map<String, String>.from(s.suggestion.metadata ?? {});
      meta['isBest'] = isBest ? 'true' : 'false';
      if (isBest) {
        meta['tag'] = '⭐ Best Offer';
      }
      meta['netProfit'] = s.netProfit.toStringAsFixed(1);
      meta['profitEfficiency'] = s.profitEfficiency.toStringAsFixed(1);
      meta['extraSpend'] = s.extraSpend.toStringAsFixed(1);

      results.add(s.suggestion.copyWith(metadata: meta));
    }

    return BasketSuggestionResult(
      suggestions: results.toList(growable: false),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Combination generator
  // Needs access to individual scored lists to build merged suggestions
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _buildCombinations({
    required double cartTotal,
    required List<Coupon> coupons,
    required String? appliedCouponCode,
    required List<_Scored> variantScored,
    required List<_Scored> comboScored,
    required _Scored? deliveryScored,
    required Set<_Scored> upgradedBaseItems,
  }) {
    final combos = <_Scored>[];
    final now = DateTime.now().toUtc();

    // Helper to find best coupon unlocked after spending `extraAmount`
    Coupon? bestCouponAfterSpend(double extra) {
      final newTotal = cartTotal + extra;
      Coupon? best;
      var bestSaving = 0.0;
      for (final c in coupons) {
        final expiry = (c.expiryDate ?? c.endDate).toUtc();
        final start = c.startDate.toUtc();
        if (!c.isActive || now.isBefore(start) || now.isAfter(expiry)) {
          continue;
        }
        if (appliedCouponCode != null &&
            c.code.trim().toUpperCase() ==
                appliedCouponCode.trim().toUpperCase()) {
          continue;
        }
        // Already unlocked without the extra spend — skip
        if (c.minOrderAmount <= cartTotal) continue;
        // Will be unlocked after the extra spend
        if (c.minOrderAmount <= newTotal) {
          final saving = c.discountValue ?? 0;
          if (saving > bestSaving) {
            bestSaving = saving;
            best = c;
          }
        }
      }
      return best;
    }

    // ── A. Variant + Coupon ───────────────────────────────────────────────
    for (final v in variantScored) {
      final vSpend = v.extraSpend;
      final couponUnlocked = bestCouponAfterSpend(vSpend);
      if (couponUnlocked == null) continue;

      final couponBenefit = couponUnlocked.discountValue ?? 0;
      final totalBenefit = v.totalBenefit + couponBenefit;
      final totalSpend = vSpend;

      final tgtLabel =
          v.suggestion.metadata?['targetVariantLabel'] ?? 'larger pack';
      final msg =
          'Upgrade to $tgtLabel → unlock ${couponUnlocked.code} & save ₹${totalBenefit.toStringAsFixed(0)} total';

      final meta = Map<String, String>.from(v.suggestion.metadata ?? {});
      meta['comboCouponCode'] = couponUnlocked.code;
      meta['comboCouponBenefit'] = couponBenefit.toStringAsFixed(1);
      meta['combinationType'] = 'variant+coupon';

      combos.add(
        _Scored(
          extraSpend: totalSpend,
          totalBenefit: totalBenefit,
          suggestion: v.suggestion.copyWith(
            message: msg,
            ctaLabel: 'Upgrade & Apply',
            savingAmount: totalBenefit,
            metadata: meta,
          ),
        ),
      );
      upgradedBaseItems.add(v);
    }

    // ── B. Combo + Coupon ────────────────────────────────────────────────
    for (final c in comboScored) {
      final cSpend = c.extraSpend;
      final couponUnlocked = bestCouponAfterSpend(cSpend);
      if (couponUnlocked == null) continue;

      final couponBenefit = couponUnlocked.discountValue ?? 0;
      final totalBenefit = c.totalBenefit + couponBenefit;

      final comboShortName =
          c.suggestion.metadata?['comboShortName'] ?? 'this combo';
      final msg =
          'Add $comboShortName + ${couponUnlocked.code} coupon & save ₹${totalBenefit.toStringAsFixed(0)} total';

      final meta = Map<String, String>.from(c.suggestion.metadata ?? {});
      meta['comboCouponCode'] = couponUnlocked.code;
      meta['comboCouponBenefit'] = couponBenefit.toStringAsFixed(1);
      meta['combinationType'] = 'combo+coupon';

      combos.add(
        _Scored(
          extraSpend: cSpend,
          totalBenefit: totalBenefit,
          suggestion: c.suggestion.copyWith(
            message: msg,
            ctaLabel: 'Add & Apply',
            savingAmount: totalBenefit,
            metadata: meta,
          ),
        ),
      );
      upgradedBaseItems.add(c);
    }

    // ── C. Small spend → Delivery unlock + Coupon unlock ────────────────
    if (deliveryScored != null) {
      final dSpend = deliveryScored.extraSpend;
      if (dSpend <= 100) {
        final couponUnlocked = bestCouponAfterSpend(dSpend);
        if (couponUnlocked != null) {
          final couponBenefit = couponUnlocked.discountValue ?? 0;
          final totalBenefit = deliveryScored.totalBenefit + couponBenefit;
          final msg =
              'Add ₹${dSpend.toStringAsFixed(0)} → free delivery + ${couponUnlocked.code} coupon (save ₹${totalBenefit.toStringAsFixed(0)})';

          final meta = Map<String, String>.from(
            deliveryScored.suggestion.metadata ?? {},
          );
          meta['comboCouponCode'] = couponUnlocked.code;
          meta['comboCouponBenefit'] = couponBenefit.toStringAsFixed(1);
          meta['combinationType'] = 'delivery+coupon';

          combos.add(
            _Scored(
              extraSpend: dSpend,
              totalBenefit: totalBenefit,
              suggestion: deliveryScored.suggestion.copyWith(
                message: msg,
                ctaLabel: 'Shop More',
                savingAmount: totalBenefit,
                metadata: meta,
              ),
            ),
          );
          upgradedBaseItems.add(deliveryScored);
        }
      }
    }

    return combos;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Free delivery scorer
  // ─────────────────────────────────────────────────────────────────────────
  static _Scored? _scoreDelivery({
    required double cartTotal,
    required DeliveryConfig config,
  }) {
    double currentFee = config.baseDeliveryFee;
    for (final slab in config.slabs) {
      if (cartTotal >= slab.minOrderAmount &&
          cartTotal <= slab.maxOrderAmount) {
        currentFee = slab.fee;
        break;
      }
    }
    if (currentFee <= 0) return null;

    DeliverySlab? nextMilestone;
    for (final slab in config.slabs) {
      if (slab.minOrderAmount > cartTotal && slab.fee < currentFee) {
        if (nextMilestone == null ||
            slab.minOrderAmount < nextMilestone.minOrderAmount) {
          nextMilestone = slab;
        }
      }
    }
    if (nextMilestone == null) return null;

    final target = nextMilestone.minOrderAmount;
    final remaining = math.max(0.0, target - cartTotal).toDouble();
    final savings = currentFee - nextMilestone.fee;

    String message;
    if (nextMilestone.fee <= 0) {
      final nearText = remaining <= 50 ? 'Just' : 'Add';
      message =
          '$nearText ₹${remaining.toStringAsFixed(0)} away from FREE delivery 🚚';
    } else {
      message =
          'Add ₹${remaining.toStringAsFixed(0)} more — save ₹${savings.toStringAsFixed(0)} on delivery';
    }

    final suggestion = BasketSuggestion(
      message: message,
      type: 'free_delivery',
      priority: 0,
      metadata: {
        'goal': nextMilestone.fee <= 0
            ? 'free_delivery'
            : 'discounted_delivery',
        'nextFee': nextMilestone.fee.toString(),
        'savings': savings.toString(),
        'highlight': remaining <= 50 ? 'near' : 'normal',
      },
      progressCurrent: cartTotal,
      progressTarget: target,
      progressRemaining: remaining,
      ctaLabel: 'Shop More',
      savingAmount: savings,
    );

    return _Scored(
      suggestion: suggestion,
      // extraSpend: how much more to spend to unlock
      extraSpend: remaining,
      totalBenefit: savings,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Coupon scorer — picks the best single unlockable coupon
  // ─────────────────────────────────────────────────────────────────────────
  static _Scored? _scoreCoupon({
    required double cartTotal,
    required List<Coupon> coupons,
    String? appliedCouponCode,
  }) {
    final now = DateTime.now().toUtc();
    Coupon? bestCoupon;
    var bestNetProfit = double.negativeInfinity;

    for (final coupon in coupons) {
      final expiry = (coupon.expiryDate ?? coupon.endDate).toUtc();
      final start = coupon.startDate.toUtc();
      if (!coupon.isActive || now.isBefore(start) || now.isAfter(expiry)) {
        continue;
      }
      if (appliedCouponCode != null &&
          coupon.code.trim().toUpperCase() ==
              appliedCouponCode.trim().toUpperCase()) {
        continue;
      }
      if (coupon.minOrderAmount <= cartTotal) {
        continue;
      }

      final remaining = math
          .max(0.0, coupon.minOrderAmount - cartTotal)
          .toDouble();
      final discount = coupon.discountValue ?? 0.0;
      final np = discount - remaining;

      if (np > bestNetProfit) {
        bestNetProfit = np;
        bestCoupon = coupon;
      }
    }

    if (bestCoupon == null) return null;

    final remaining = math
        .max(0.0, bestCoupon.minOrderAmount - cartTotal)
        .toDouble();
    final discountValue = bestCoupon.discountValue ?? 0;
    final nearText = remaining <= 75 ? '🎟 Just' : 'Add';
    final couponMsg =
        '$nearText ₹${remaining.toStringAsFixed(0)} more — unlock coupon ${bestCoupon.code} for ${_couponRewardLabel(bestCoupon)}';

    final suggestion = BasketSuggestion(
      message: couponMsg,
      type: 'coupon',
      priority: 0,
      metadata: {
        'couponCode': bestCoupon.code,
        'goal': 'coupon',
        'highlight': remaining <= 75 ? 'near' : 'normal',
      },
      progressCurrent: cartTotal,
      progressTarget: bestCoupon.minOrderAmount,
      progressRemaining: remaining,
      ctaLabel: 'Unlock Coupon',
      savingAmount: discountValue,
    );

    return _Scored(
      suggestion: suggestion,
      extraSpend: remaining,
      totalBenefit: discountValue.toDouble(),
    );
  }

  static String _couponRewardLabel(Coupon coupon) {
    final type = (coupon.type ?? '').toUpperCase();
    final discountValue = coupon.discountValue ?? 0;
    if (type == 'PERCENTAGE_DISCOUNT') {
      final maxDiscount = coupon.maxDiscountAmount ?? coupon.maxDiscount;
      if (maxDiscount != null && maxDiscount > 0) {
        return 'up to ₹${maxDiscount.toStringAsFixed(0)} OFF';
      }
      return '${discountValue.toStringAsFixed(0)}% OFF';
    }
    return '₹${discountValue.toStringAsFixed(0)} OFF';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BOGO scorer — benefit = highest-priced free product
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreBogoSuggestions({
    required List<CartItemInput> cartItems,
    required List<BogoOffer> bogoOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <_Scored>[];

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;

      final minTriggerQty = offer.minTriggerQuantity ?? 1;
      if (minTriggerQty <= 0) continue;

      // BENEFIT: highest-priced free product (not just trigger price)
      final freeProductPrice = _highestFreeProductPrice(offer, productMap);
      final freeQtyPerTrigger = _getFreeQtyPerOffer(offer);

      // Check if free product is already in cart
      final freeProductInCart = cartItems.any(
        (item) =>
            (item.comboId == null || item.comboId!.isEmpty) &&
            offer.freeProductIds.contains(item.productId),
      );
      if (freeProductInCart) continue;

      final hasSpecificVariant =
          offer.triggerVariantId != null &&
          offer.triggerVariantId!.trim().isNotEmpty;

      if (hasSpecificVariant) {
        final variantCartItem = cartItems.firstWhereOrNull(
          (item) =>
              item.productId == offer.triggerProductId &&
              (item.comboId == null || item.comboId!.isEmpty) &&
              item.variantId == offer.triggerVariantId,
        );

        if (variantCartItem == null) {
          final variantLabel = _getVariantLabel(
            product,
            offer.triggerVariantId,
          );
          final currentVariantLabel = _getCurrentVariantLabel(
            cartItems,
            product,
            offer.triggerProductId,
          );

          if (currentVariantLabel != null && currentVariantLabel.isNotEmpty) {
            results.add(
              _Scored(
                extraSpend: 0,
                totalBenefit: freeProductPrice * freeQtyPerTrigger,
                suggestion: BasketSuggestion(
                  message:
                      'Switch$currentVariantLabel to$variantLabel & get $freeQtyPerTrigger FREE',
                  type: 'bogo',
                  priority: 0,
                  metadata: {'state': 'variant_required'},
                  ctaLabel: 'Upgrade Pack',
                  productId: offer.triggerProductId,
                  variantId: offer.triggerVariantId,
                  savingAmount: freeProductPrice * freeQtyPerTrigger,
                  thumbnailUrl: product.imageUrl,
                ),
              ),
            );
          }
          continue;
        }

        final totalTriggerSets = variantCartItem.quantity ~/ minTriggerQty;
        if (totalTriggerSets <= 0) {
          final remaining = minTriggerQty - variantCartItem.quantity;
          final unitText = _getVariantLabel(product, offer.triggerVariantId);
          final extraCost = product.price * remaining;
          results.add(
            _Scored(
              extraSpend: extraCost,
              totalBenefit: freeProductPrice * freeQtyPerTrigger,
              suggestion: BasketSuggestion(
                message:
                    'Add $remaining more$unitText & get $freeQtyPerTrigger FREE',
                type: 'bogo',
                priority: 0,
                metadata: {'state': 'quantity_required'},
                ctaLabel: 'Add to Cart',
                productId: offer.triggerProductId,
                variantId: offer.triggerVariantId,
                savingAmount: freeProductPrice * freeQtyPerTrigger,
                thumbnailUrl: product.imageUrl,
              ),
            ),
          );
        }
        continue;
      }

      final anyCartItem = cartItems.firstWhereOrNull(
        (item) =>
            item.productId == offer.triggerProductId &&
            (item.comboId == null || item.comboId!.isEmpty),
      );
      if (anyCartItem == null) continue;

      final totalTriggerSets = anyCartItem.quantity ~/ minTriggerQty;
      if (totalTriggerSets <= 0) {
        final remaining = minTriggerQty - anyCartItem.quantity;
        final variantLabel = _getCurrentVariantLabel(
          cartItems,
          product,
          offer.triggerProductId,
        );
        final unitText = (variantLabel != null && variantLabel.isNotEmpty)
            ? variantLabel
            : ' item';
        final extraCost = product.price * remaining;

        results.add(
          _Scored(
            extraSpend: extraCost,
            totalBenefit: freeProductPrice * freeQtyPerTrigger,
            suggestion: BasketSuggestion(
              message:
                  'Add $remaining more$unitText & get $freeQtyPerTrigger FREE',
              type: 'bogo',
              priority: 0,
              metadata: {'state': 'quantity_required'},
              ctaLabel: 'Add to Cart',
              productId: offer.triggerProductId,
              variantId: null,
              savingAmount: freeProductPrice * freeQtyPerTrigger,
              thumbnailUrl: product.imageUrl,
            ),
          ),
        );
      }
    }

    return results;
  }

  // Highest-priced free product price — for accurate BOGO benefit
  static double _highestFreeProductPrice(
    BogoOffer offer,
    Map<String, Product> productMap,
  ) {
    var highest = 0.0;
    for (final freeId in offer.freeProductIds) {
      final p = productMap[freeId];
      if (p != null && p.price > highest) highest = p.price;
    }
    // Fallback to trigger product price
    if (highest <= 0) {
      highest = productMap[offer.triggerProductId]?.price ?? 0;
    }
    return highest;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Combo scorer
  // extraSpend = combo price - value of matching items already in cart
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreComboSuggestions({
    required List<CartItemInput> cartItems,
    required List<ComboOffer> comboOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <_Scored>[];

    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      if (combo.comboProducts.isEmpty) continue;

      final comboId = combo.comboId ?? combo.name;
      if (cartItems.any((item) => item.comboId == comboId)) continue;

      var matchedProducts = 0;
      var alreadyInCartValue = 0.0;
      for (final comboProduct in combo.comboProducts) {
        final cartItem = cartItems
            .where((item) => (item.comboId == null || item.comboId!.isEmpty))
            .firstWhere(
              (item) => item.productId == comboProduct.productId,
              orElse: () => CartItemInput(productId: '', quantity: 0),
            );
        if (cartItem.productId.isNotEmpty) {
          matchedProducts++;
          final product = productMap[comboProduct.productId];
          if (product != null) {
            alreadyInCartValue +=
                product.price *
                math.min(cartItem.quantity, comboProduct.quantity);
          }
        }
      }

      if (matchedProducts <= 0) continue;

      final savings = _calculateComboSavings(combo, productMap);
      if (savings <= 0) continue;

      // Total combo price
      final comboFullPrice = combo.comboProducts.fold<double>(
        0,
        (sum, cp) => sum + (productMap[cp.productId]?.price ?? 0) * cp.quantity,
      );
      final extraSpend = math
          .max(0.0, comboFullPrice - alreadyInCartValue)
          .toDouble();

      final comboProductNames = combo.comboProducts
          .map((cp) => productMap[cp.productId]?.productName ?? 'Item')
          .where((name) => name.isNotEmpty)
          .toList();

      final comboImageUrls = combo.comboProducts
          .map((cp) => productMap[cp.productId]?.imageUrl ?? '')
          .where((url) => url.isNotEmpty)
          .join(',');

      final firstTwoNames = comboProductNames.take(2).join(' + ');
      final extraCount = comboProductNames.length - 2;
      final shortName = extraCount > 0
          ? '$firstTwoNames + $extraCount more'
          : firstTwoNames;
      final message = 'Bundle $shortName & save ₹${savings.toStringAsFixed(0)}';

      results.add(
        _Scored(
          extraSpend: extraSpend,
          totalBenefit: savings,
          suggestion: BasketSuggestion(
            message: message,
            type: 'combo',
            priority: 0,
            metadata: {
              'comboName': combo.name,
              'comboShortName': shortName,
              'comboProductIds': combo.comboProducts
                  .map((item) => item.productId)
                  .join(','),
              'comboImageUrls': comboImageUrls,
              'savings': savings.toString(),
            },
            ctaLabel: 'Add Bundle',
            comboId: combo.comboId,
            savingAmount: savings,
            thumbnailUrl:
                productMap[combo.comboProducts.first.productId]?.imageUrl,
          ),
        ),
      );
    }

    // Sort by net_profit within combos before returning
    results.sort((a, b) => b.netProfit.compareTo(a.netProfit));
    return results;
  }

  static double _calculateComboSavings(
    ComboOffer combo,
    Map<String, Product> productMap,
  ) {
    var total = 0.0;
    for (final comboProduct in combo.comboProducts) {
      final product = productMap[comboProduct.productId];
      if (product == null) continue;
      total += product.price * comboProduct.quantity;
    }
    if (total <= 0) return 0;
    if (combo.discountType == 'percentage') {
      return total * (combo.discountValue / 100);
    }
    return combo.discountValue;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Variant scorer
  // extraSpend = price difference (upgrade cost)
  // totalBenefit = per-unit savings * target quantity
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreVariantSuggestions({
    required List<CartItemInput> cartItems,
    required Map<String, Product> productMap,
  }) {
    final results = <_Scored>[];

    for (final item in cartItems) {
      if (item.comboId != null && item.comboId!.isNotEmpty) continue;

      final product = productMap[item.productId];
      if (product == null) continue;
      final variants = (product.variants ?? const <ProductVariant>[])
          .where((variant) => variant.isAvailable)
          .toList();
      if (variants.length < 2) continue;

      final currentVariant = _resolveVariant(product, item.variantId);
      if (currentVariant == null || currentVariant.quantityValue <= 0) continue;

      final curNorm = _normalizeQuantity(currentVariant);
      if (curNorm <= 0) continue;
      final currentUnitPrice = currentVariant.price / curNorm;

      _Scored? bestUpgrade;
      var bestNetProfit = double.negativeInfinity;

      for (final variant in variants) {
        if (variant.variantId == currentVariant.variantId) continue;

        final varNorm = _normalizeQuantity(variant);
        if (varNorm <= curNorm) continue;

        final variantUnitPrice = variant.price / varNorm;
        if (variantUnitPrice >= currentUnitPrice) continue;

        final estimatedCurrentCost = currentUnitPrice * varNorm;
        final savings = estimatedCurrentCost - variant.price;
        // extraSpend: user pays (targetPrice - currentPrice) more
        final extraSpend = math
            .max(0.0, variant.price - currentVariant.price)
            .toDouble();

        final np = savings - extraSpend;
        if (np <= bestNetProfit) continue;

        bestNetProfit = np;
        bestUpgrade = _Scored(
          extraSpend: extraSpend,
          totalBenefit: savings,
          suggestion: BasketSuggestion(
            message:
                'Upgrade to ${_formatVariantLabel(variant)} & save ₹${savings.toStringAsFixed(0)}',
            type: 'variant',
            priority: 0,
            metadata: {
              'currentVariantLabel': _formatVariantLabel(currentVariant),
              'currentVariantPrice': currentVariant.price.toStringAsFixed(0),
              'targetVariantLabel': _formatVariantLabel(variant),
              'targetVariantPrice': variant.price.toStringAsFixed(0),
              'totalVariantCount': variants.length.toString(),
              'savingsValue': savings.toString(),
            },
            ctaLabel: 'Upgrade',
            productId: item.productId,
            variantId: variant.variantId,
            savingAmount: savings,
            thumbnailUrl: product.imageUrl,
          ),
        );
      }

      if (bestUpgrade != null) results.add(bestUpgrade);
    }

    results.sort((a, b) => b.netProfit.compareTo(a.netProfit));
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cache helpers
  // ─────────────────────────────────────────────────────────────────────────
  static Future<DeliveryConfig> _getDeliveryConfig() async {
    if (_cachedDeliveryConfig != null &&
        _cachedDeliveryConfigAt != null &&
        DateTime.now().difference(_cachedDeliveryConfigAt!) < _cacheTtl) {
      return _cachedDeliveryConfig!;
    }
    final config = await DeliveryEngine.getDeliveryConfig();
    _cachedDeliveryConfig = config;
    _cachedDeliveryConfigAt = DateTime.now();
    return config;
  }

  static Future<List<Coupon>> _getCoupons() async {
    if (_cachedCoupons != null &&
        _cachedCouponsAt != null &&
        DateTime.now().difference(_cachedCouponsAt!) < _cacheTtl) {
      return _cachedCoupons!;
    }
    final coupons = await CouponService.fetchCoupons(activeOnly: true);
    _cachedCoupons = coupons;
    _cachedCouponsAt = DateTime.now();
    return coupons;
  }

  static Future<List<BogoOffer>> _getBogoOffers(Session session) async {
    if (_cachedBogoOffers != null &&
        _cachedBogoAt != null &&
        DateTime.now().difference(_cachedBogoAt!) < _cacheTtl) {
      return _cachedBogoOffers!;
    }
    final offers = await BogoEndpoint().getActiveOffers(session);
    _cachedBogoOffers = offers;
    _cachedBogoAt = DateTime.now();
    return offers;
  }

  static Future<List<ComboOffer>> _getComboOffers(Session session) async {
    if (_cachedComboOffers != null &&
        _cachedComboAt != null &&
        DateTime.now().difference(_cachedComboAt!) < _cacheTtl) {
      return _cachedComboOffers!;
    }
    final offers = await ComboOfferEndpoint().getActiveComboOffers(session);
    _cachedComboOffers = offers;
    _cachedComboAt = DateTime.now();
    return offers;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared helpers
  // ─────────────────────────────────────────────────────────────────────────
  static String? _getCurrentVariantLabel(
    List<CartItemInput> cartItems,
    Product product,
    String productId,
  ) {
    final cartItem = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (cartItem == null || cartItem.variantId == null) return null;
    return _getVariantLabel(product, cartItem.variantId);
  }

  static String _getVariantLabel(Product product, String? variantId) {
    if (variantId == null || variantId.trim().isEmpty) return '';
    final variants = product.variants ?? [];
    for (final variant in variants) {
      if (variant.variantId == variantId) {
        final label =
            variant.quantityDescription ??
            '${variant.quantityValue.toStringAsFixed(variant.quantityValue.truncateToDouble() == variant.quantityValue ? 0 : 1)}${variant.quantityUnit}';
        return ' ($label)';
      }
    }
    return '';
  }

  static int _getFreeQtyPerOffer(BogoOffer offer) {
    if (offer.freeProducts == null || offer.freeProducts!.isEmpty) return 1;
    final totalFreeQty = offer.freeProducts!.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item.quantity ?? '1') ?? 1),
    );
    return totalFreeQty > 0 ? totalFreeQty : 1;
  }

  static double _normalizeQuantity(ProductVariant variant) {
    final val = variant.quantityValue;
    final unit = variant.quantityUnit.toLowerCase().trim();
    if (unit == 'kg' || unit == 'l') return val * 1000;
    if (unit == 'g' || unit == 'ml') return val;
    return val;
  }

  static ProductVariant? _resolveVariant(Product product, String? variantId) {
    final variants = product.variants ?? const <ProductVariant>[];
    if (variants.isEmpty) return null;
    if (variantId == null || variantId.trim().isEmpty) return variants.first;
    for (final variant in variants) {
      if (variant.variantId == variantId) return variant;
    }
    return variants.first;
  }

  static String _formatVariantLabel(ProductVariant variant) {
    final value = variant.quantityValue;
    final amount = value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    return '$amount${variant.quantityUnit}';
  }
}
