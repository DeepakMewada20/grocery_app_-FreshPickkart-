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

    // ── 5. Finalize Results (Top 6) ──────────────────────────────────────────
    final results = <BasketSuggestion>[];
    for (var i = 0; i < scored.length && results.length < 6; i++) {
      final s = scored[i];
      final isBest = i == 0;
      
      final finalized = s.suggestion.copyWith(
        isBest: isBest,
        rank: i,
        netProfit: s.netProfit,
        extraSpend: s.extraSpend,
        profitEfficiency: s.profitEfficiency,
      );

      // UI metadata
      final meta = Map<String, String>.from(finalized.metadata ?? {});
      meta['isBest'] = isBest ? 'true' : 'false';
      
      results.add(finalized.copyWith(metadata: meta));
    }

    return BasketSuggestionResult(
      suggestions: results.toList(growable: false),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: Delivery
  // ─────────────────────────────────────────────────────────────────────────
  static _Scored? _scoreDelivery({
    required double cartTotal,
    required DeliveryConfig config,
  }) {
    double currentFee = config.baseDeliveryFee;
    for (final slab in config.slabs) {
      if (cartTotal >= slab.minOrderAmount && cartTotal <= slab.maxOrderAmount) {
        currentFee = slab.fee;
        break;
      }
    }
    if (currentFee <= 0) return null;

    DeliverySlab? nextMilestone;
    for (final slab in config.slabs) {
      if (slab.minOrderAmount > cartTotal && slab.fee < currentFee) {
        if (nextMilestone == null || slab.minOrderAmount < nextMilestone.minOrderAmount) {
          nextMilestone = slab;
        }
      }
    }
    if (nextMilestone == null) return null;

    final remaining = math.max(0.0, nextMilestone.minOrderAmount - cartTotal).toDouble();
    final savings = currentFee - nextMilestone.fee;
    
    final isFree = nextMilestone.fee == 0;
    final benefitLabel = isFree ? 'FREE Delivery' : 'SAVE ₹${savings.toStringAsFixed(0)}';
    
    final action = BasketSuggestionAction(
      type: 'delivery',
      label: 'Unlock $benefitLabel',
      ctaLabel: 'Shop More',
      benefit: savings,
      extraSpend: remaining,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: savings,
      suggestion: BasketSuggestion(
        message: 'Add ₹${remaining.toStringAsFixed(0)} more → $benefitLabel 🚚',
        type: 'single',
        priority: 0,
        actions: [action],
        progressCurrent: cartTotal,
        progressTarget: nextMilestone.minOrderAmount,
        progressRemaining: remaining,
        savingAmount: savings,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: Coupon
  // ─────────────────────────────────────────────────────────────────────────
  static _Scored? _scoreCoupon({
    required double cartTotal,
    required List<Coupon> coupons,
    String? appliedCouponCode,
  }) {
    final now = DateTime.now().toUtc();
    Coupon? best;
    var bestNp = double.negativeInfinity;

    for (final c in coupons) {
      if (!c.isActive || c.minOrderAmount <= cartTotal) continue;
      final expiry = (c.expiryDate ?? c.endDate).toUtc();
      if (now.isAfter(expiry)) continue;
      if (appliedCouponCode?.toUpperCase() == c.code.toUpperCase()) continue;

      final remaining = c.minOrderAmount - cartTotal;
      final benefit = c.discountValue ?? 0.0;
      final np = benefit - remaining;
      
      if (np > bestNp) {
        bestNp = np;
        best = c;
      }
    }

    if (best == null) return null;

    final remaining = best.minOrderAmount - cartTotal;
    final benefit = best.discountValue ?? 0.0;
    
    final action = BasketSuggestionAction(
      type: 'coupon',
      label: 'Unlock Coupon ${best.code}',
      ctaLabel: 'Unlock',
      couponCode: best.code,
      benefit: benefit,
      extraSpend: remaining,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: benefit,
      suggestion: BasketSuggestion(
        message: 'Add ₹${remaining.toStringAsFixed(0)} more for ${best.code}',
        type: 'single',
        priority: 0,
        actions: [action],
        progressCurrent: cartTotal,
        progressTarget: best.minOrderAmount,
        savingAmount: benefit,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: BOGO
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreBogoSuggestions({
    required List<CartItemInput> cartItems,
    required List<BogoOffer> bogoOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <_Scored>[];

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;

      final trigger = productMap[offer.triggerProductId];
      if (trigger == null) continue;

      // REDUNDANCY CHECK: If trigger is in cart AND any free product is in cart, skip
      final triggerInCart = cartItems.any((it) => it.productId == offer.triggerProductId);
      final freeInCart = cartItems.any((it) => offer.freeProductIds.contains(it.productId));
      
      if (triggerInCart && freeInCart) continue;

      // BENEFIT: Highest price item
      double benefit = 0;
      for (final fid in offer.freeProductIds) {
        final f = productMap[fid];
        if (f != null && f.price > benefit) benefit = f.price;
      }
      if (benefit <= 0) benefit = trigger.price;

      final extraSpend = triggerInCart ? 0.0 : trigger.price;
      final action = BasketSuggestionAction(
        type: 'bogo',
        label: 'Buy 1 Get 1 Free',
        ctaLabel: triggerInCart ? 'Get Free Item' : 'Add to Cart',
        productId: offer.triggerProductId,
        variantId: offer.triggerVariantId,
        benefit: benefit,
        extraSpend: extraSpend,
      );

      results.add(_Scored(
        extraSpend: extraSpend,
        totalBenefit: benefit,
        suggestion: BasketSuggestion(
          message: 'Get a free product with ${trigger.productName}',
          type: 'single',
          priority: 0,
          actions: [action],
          savingAmount: benefit,
          thumbnailUrl: trigger.imageUrl,
        ),
      ));
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: Combo
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreComboSuggestions({
    required List<CartItemInput> cartItems,
    required List<ComboOffer> comboOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <_Scored>[];
    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      final comboId = combo.comboId ?? combo.name;
      if (cartItems.any((it) => it.comboId == comboId)) continue;

      double fullPrice = 0;
      double alreadyInCartValue = 0;
      for (final cp in combo.comboProducts) {
        final p = productMap[cp.productId];
        if (p == null) continue;
        fullPrice += p.price * cp.quantity;
        
        final inCart = cartItems.firstWhereOrNull((it) => it.productId == cp.productId && it.comboId == null);
        if (inCart != null) {
          alreadyInCartValue += p.price * math.min(inCart.quantity, cp.quantity);
        }
      }

      double savings = 0;
      if (combo.discountType == 'percentage') {
        savings = fullPrice * (combo.discountValue / 100);
      } else {
        savings = combo.discountValue;
      }

      final extraSpend = math.max(0.0, fullPrice - alreadyInCartValue).toDouble();
      
      final action = BasketSuggestionAction(
        type: 'combo',
        label: 'Add ${combo.name}',
        ctaLabel: 'Add Combo',
        comboId: combo.comboId,
        benefit: savings,
        extraSpend: extraSpend,
      );

      results.add(_Scored(
        extraSpend: extraSpend,
        totalBenefit: savings,
        suggestion: BasketSuggestion(
          message: 'Save ₹${savings.toStringAsFixed(0)} with ${combo.name}',
          type: 'single',
          priority: 0,
          actions: [action],
          savingAmount: savings,
          comboId: combo.comboId,
          thumbnailUrl: productMap[combo.comboProducts.first.productId]?.imageUrl,
        ),
      ));
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: Variant
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

      final variants = (product.variants ?? []).where((v) => v.isAvailable).toList();
      if (variants.length < 2) continue;

      final current = _resolveVariant(product, item.variantId);
      if (current == null) continue;
      final curNorm = _normalizeQuantity(current);
      if (curNorm <= 0) continue;
      final curUp = current.price / curNorm;

      for (final v in variants) {
        if (v.variantId == current.variantId) continue;
        final vNorm = _normalizeQuantity(v);
        if (vNorm <= curNorm) continue;
        
        final vUp = v.price / vNorm;
        if (vUp >= curUp) continue;

        final projectedSavings = (curUp * vNorm) - v.price;
        final extraSpend = math.max(0.0, v.price - current.price).toDouble();

        final action = BasketSuggestionAction(
          type: 'variant',
          label: 'Upgrade to ${_formatVariantLabel(v)}',
          ctaLabel: 'Upgrade',
          productId: product.productId,
          variantId: v.variantId,
          benefit: projectedSavings,
          extraSpend: extraSpend,
        );

        results.add(_Scored(
          extraSpend: extraSpend,
          totalBenefit: projectedSavings,
          suggestion: BasketSuggestion(
            message: 'Upgrade pack & save ₹${projectedSavings.toStringAsFixed(0)}',
            type: 'single',
            priority: 0,
            actions: [action],
            savingAmount: projectedSavings,
            thumbnailUrl: product.imageUrl,
            metadata: {
              'curLabel': _formatVariantLabel(current),
              'curPrice': current.price.toStringAsFixed(0),
              'vLabel': _formatVariantLabel(v),
              'vPrice': v.price.toStringAsFixed(0),
            },
          ),
        ));
      }
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Combination generator
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

    Coupon? findBestCoupon(double extra) {
      final total = cartTotal + extra;
      Coupon? best;
      double maxSav = 0;
      for (final c in coupons) {
        if (!c.isActive || c.minOrderAmount <= cartTotal || c.minOrderAmount > total) continue;
        if (appliedCouponCode?.toUpperCase() == c.code.toUpperCase()) continue;
        if (c.discountValue != null && c.discountValue! > maxSav) {
          maxSav = c.discountValue!;
          best = c;
        }
      }
      return best;
    }

    // A. Variant + Coupon
    for (final v in variantScored) {
      final cUnlocked = findBestCoupon(v.extraSpend);
      if (cUnlocked == null) continue;

      final benefit = v.totalBenefit + (cUnlocked.discountValue ?? 0);
      final actions = [
        ...v.suggestion.actions!,
        BasketSuggestionAction(
          type: 'coupon',
          label: 'Apply ${cUnlocked.code}',
          ctaLabel: 'Apply',
          couponCode: cUnlocked.code,
          benefit: cUnlocked.discountValue,
          extraSpend: 0,
        ),
      ];

      combos.add(_Scored(
        extraSpend: v.extraSpend,
        totalBenefit: benefit,
        suggestion: BasketSuggestion(
          message: 'Upgrade pack & unlock ${cUnlocked.code} (Save ₹${benefit.toStringAsFixed(0)})',
          type: 'combined',
          priority: 0,
          actions: actions,
          savingAmount: benefit,
          thumbnailUrl: v.suggestion.thumbnailUrl,
        ),
      ));
      upgradedBaseItems.add(v);
    }

    // B. Combo + Coupon
    for (final c in comboScored) {
      final cUnlocked = findBestCoupon(c.extraSpend);
      if (cUnlocked == null) continue;

      final benefit = c.totalBenefit + (cUnlocked.discountValue ?? 0);
      final actions = [
        ...c.suggestion.actions!,
        BasketSuggestionAction(
          type: 'coupon',
          label: 'Apply ${cUnlocked.code}',
          ctaLabel: 'Apply',
          couponCode: cUnlocked.code,
          benefit: cUnlocked.discountValue,
          extraSpend: 0,
        ),
      ];

      combos.add(_Scored(
        extraSpend: c.extraSpend,
        totalBenefit: benefit,
        suggestion: BasketSuggestion(
          message: 'Add combo & unlock ${cUnlocked.code} (Save ₹${benefit.toStringAsFixed(0)})',
          type: 'combined',
          priority: 0,
          actions: actions,
          savingAmount: benefit,
          thumbnailUrl: c.suggestion.thumbnailUrl,
        ),
      ));
      upgradedBaseItems.add(c);
    }

    // C. Variant + Delivery
    if (deliveryScored != null) {
      for (final v in variantScored) {
        if (v.extraSpend >= deliveryScored.extraSpend) {
          final benefit = v.totalBenefit + deliveryScored.totalBenefit;
          final actions = [
             ...v.suggestion.actions!,
             ...deliveryScored.suggestion.actions!,
          ];
          combos.add(_Scored(
            extraSpend: v.extraSpend,
            totalBenefit: benefit,
            suggestion: BasketSuggestion(
              message: 'Upgrade & get FREE Delivery (Save ₹${benefit.toStringAsFixed(0)})',
              type: 'combined',
              priority: 0,
              actions: actions,
              savingAmount: benefit,
              thumbnailUrl: v.suggestion.thumbnailUrl,
            ),
          ));
          upgradedBaseItems.add(v);
          break; // Take the best variant
        }
      }
    }

    return combos;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared Helpers
  // ─────────────────────────────────────────────────────────────────────────

  static Future<DeliveryConfig> _getDeliveryConfig() async {
    if (_cachedDeliveryConfig != null && _cachedDeliveryConfigAt != null && DateTime.now().difference(_cachedDeliveryConfigAt!) < _cacheTtl) return _cachedDeliveryConfig!;
    final config = await DeliveryEngine.getDeliveryConfig();
    _cachedDeliveryConfig = config; _cachedDeliveryConfigAt = DateTime.now();
    return config;
  }

  static Future<List<Coupon>> _getCoupons() async {
    if (_cachedCoupons != null && _cachedCouponsAt != null && DateTime.now().difference(_cachedCouponsAt!) < _cacheTtl) return _cachedCoupons!;
    final coupons = await CouponService.fetchCoupons(activeOnly: true);
    _cachedCoupons = coupons; _cachedCouponsAt = DateTime.now();
    return coupons;
  }

  static Future<List<BogoOffer>> _getBogoOffers(Session session) async {
    if (_cachedBogoOffers != null && _cachedBogoAt != null && DateTime.now().difference(_cachedBogoAt!) < _cacheTtl) return _cachedBogoOffers!;
    final offers = await BogoEndpoint().getActiveOffers(session);
    _cachedBogoOffers = offers; _cachedBogoAt = DateTime.now();
    return offers;
  }

  static Future<List<ComboOffer>> _getComboOffers(Session session) async {
    if (_cachedComboOffers != null && _cachedComboAt != null && DateTime.now().difference(_cachedComboAt!) < _cacheTtl) return _cachedComboOffers!;
    final offers = await ComboOfferEndpoint().getActiveComboOffers(session);
    _cachedComboOffers = offers; _cachedComboAt = DateTime.now();
    return offers;
  }

  static ProductVariant? _resolveVariant(Product product, String? variantId) {
    final variants = product.variants ?? [];
    if (variants.isEmpty) return null;
    if (variantId == null) return variants.first;
    return variants.firstWhereOrNull((v) => v.variantId == variantId) ?? variants.first;
  }

  static double _normalizeQuantity(ProductVariant variant) {
    final val = variant.quantityValue;
    final unit = variant.quantityUnit.toLowerCase().trim();
    if (unit == 'kg' || unit == 'l') return val * 1000;
    return val;
  }

  static String _formatVariantLabel(ProductVariant variant) {
    final value = variant.quantityValue;
    final amount = value == value.truncateToDouble() ? value.toInt().toString() : value.toStringAsFixed(1);
    return '$amount${variant.quantityUnit}';
  }
}
