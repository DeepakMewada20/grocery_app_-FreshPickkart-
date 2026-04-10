import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../../endpoints/bogo_endpoint.dart';
import '../../endpoints/combo_offer_endpoint.dart';
import '../../endpoints/product_endpoint.dart';
import '../../generated/protocol.dart';
import '../coupon_service.dart';
import '../delivery/delivery_engine.dart';

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

  static Future<BasketSuggestionResult> getSuggestions({
    required Session session,
    required List<CartItemInput> items,
    required double cartTotal,
    String? userId,
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

    final productIds = normalizedItems.map((item) => item.productId).toSet();
    final products = await ProductEndpoint().getProductsByIds(
      session,
      productIds.toList(),
    );
    final productMap = {
      for (final product in products)
        if (product.productId != null) product.productId!: product,
    };

    final deliveryConfig = await _getDeliveryConfig();
    final coupons = await _getCoupons();
    final bogoOffers = await _getBogoOffers(session);
    final comboOffers = await _getComboOffers(session);

    final suggestions = <BasketSuggestion>[];

    final freeDeliverySuggestion = _buildFreeDeliverySuggestion(
      cartTotal: cartTotal,
      config: deliveryConfig,
    );
    if (freeDeliverySuggestion != null) suggestions.add(freeDeliverySuggestion);

    final couponSuggestion = _buildCouponSuggestion(
      cartTotal: cartTotal,
      coupons: coupons,
    );
    if (couponSuggestion != null) suggestions.add(couponSuggestion);

    final comboSuggestion = _buildComboSuggestion(
      cartItems: normalizedItems,
      comboOffers: comboOffers,
      productMap: productMap,
    );

    final comboProductIds = <String>{};
    if (comboSuggestion != null) {
      suggestions.add(comboSuggestion);
      final productIdsText = comboSuggestion.metadata?['comboProductIds'];
      if (productIdsText != null && productIdsText.isNotEmpty) {
        comboProductIds.addAll(
          productIdsText.split(',').where((value) => value.trim().isNotEmpty),
        );
      }
    }

    final bogoSuggestion = _buildBogoSuggestion(
      cartItems: normalizedItems,
      bogoOffers: bogoOffers,
      productMap: productMap,
      blockedProductIds: comboProductIds,
    );
    if (bogoSuggestion != null) suggestions.add(bogoSuggestion);

    final variantSuggestion = _buildVariantSuggestion(
      cartItems: normalizedItems,
      productMap: productMap,
      blockedProductIds: comboProductIds,
    );
    if (variantSuggestion != null) suggestions.add(variantSuggestion);

    suggestions.sort((a, b) => a.priority.compareTo(b.priority));
    return BasketSuggestionResult(
      suggestions: suggestions.take(3).toList(growable: false),
    );
  }

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

  static BasketSuggestion? _buildFreeDeliverySuggestion({
    required double cartTotal,
    required DeliveryConfig config,
  }) {
    // 1. Calculate current potential fee (simplified slab match)
    double currentFee = config.baseDeliveryFee;
    for (final slab in config.slabs) {
      if (cartTotal >= slab.minOrderAmount && cartTotal <= slab.maxOrderAmount) {
        currentFee = slab.fee;
        break;
      }
    }

    if (currentFee <= 0) return null;

    // 2. Find the next best milestone
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
      message = 'Add ₹${remaining.toStringAsFixed(0)} more to get FREE delivery';
    } else {
      message =
          'Add ₹${remaining.toStringAsFixed(0)} more to get ₹${savings.toStringAsFixed(0)} OFF on delivery';
    }

    return BasketSuggestion(
      message: message,
      type: 'free_delivery',
      priority: 1,
      metadata: {
        'goal': nextMilestone.fee <= 0 ? 'free_delivery' : 'discounted_delivery',
        'nextFee': nextMilestone.fee.toString(),
        'savings': savings.toString(),
        'highlight': remaining <= 50 ? 'near' : 'normal',
      },
      progressCurrent: cartTotal,
      progressTarget: target,
      progressRemaining: remaining,
      ctaLabel: 'Shop More',
    );
  }

  static BasketSuggestion? _buildCouponSuggestion({
    required double cartTotal,
    required List<Coupon> coupons,
  }) {
    final now = DateTime.now().toUtc();
    Coupon? bestCoupon;
    var bestGap = double.infinity;

    for (final coupon in coupons) {
      final expiry = (coupon.expiryDate ?? coupon.endDate).toUtc();
      final start = coupon.startDate.toUtc();
      if (!coupon.isActive || now.isBefore(start) || now.isAfter(expiry)) {
        continue;
      }
      if (coupon.minOrderAmount <= cartTotal) continue;
      final gap = coupon.minOrderAmount - cartTotal;
      if (gap < bestGap) {
        bestGap = gap;
        bestCoupon = coupon;
      }
    }

    if (bestCoupon == null) return null;
    final remaining =
        math.max(0.0, bestCoupon.minOrderAmount - cartTotal).toDouble();
    return BasketSuggestion(
      message:
          'Add ₹${remaining.toStringAsFixed(0)} more to get ${_couponRewardLabel(bestCoupon)}',
      type: 'coupon',
      priority: 2,
      metadata: {
        'couponCode': bestCoupon.code,
        'goal': 'coupon',
        'highlight': remaining <= 75 ? 'near' : 'normal',
      },
      progressCurrent: cartTotal,
      progressTarget: bestCoupon.minOrderAmount,
      progressRemaining: remaining,
      ctaLabel: 'Unlock Coupon',
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

  static BasketSuggestion? _buildComboSuggestion({
    required List<CartItemInput> cartItems,
    required List<ComboOffer> comboOffers,
    required Map<String, Product> productMap,
  }) {
    ComboOffer? bestCombo;
    var bestSavings = 0.0;

    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      if (combo.comboProducts.isEmpty) continue;

      var matchedProducts = 0;
      for (final comboProduct in combo.comboProducts) {
        final cartItem = cartItems.where((item) => item.comboId == null).firstWhere(
          (item) => item.productId == comboProduct.productId,
          orElse: () => CartItemInput(productId: '', quantity: 0),
        );
        if (cartItem.productId.isNotEmpty) {
          matchedProducts++;
        }
      }

      if (matchedProducts <= 0) continue;

      final savings = _calculateComboSavings(combo, productMap);
      if (savings <= 0) continue;

      if (bestCombo == null ||
          matchedProducts > 0 && (savings > bestSavings)) {
        bestCombo = combo;
        bestSavings = savings;
      }
    }

    if (bestCombo == null) return null;
    return BasketSuggestion(
      message: 'Add combo pack & save ₹${bestSavings.toStringAsFixed(0)}',
      type: 'combo',
      priority: 4,
      metadata: {
        'comboName': bestCombo.name,
        'comboProductIds':
            bestCombo.comboProducts.map((item) => item.productId).join(','),
      },
      ctaLabel: 'Add Combo',
      comboId: bestCombo.comboId,
    );
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

  static BasketSuggestion? _buildBogoSuggestion({
    required List<CartItemInput> cartItems,
    required List<BogoOffer> bogoOffers,
    required Map<String, Product> productMap,
    required Set<String> blockedProductIds,
  }) {
    BasketSuggestion? bestSuggestion;

    for (final offer in bogoOffers) {
      if (!offer.isActive || blockedProductIds.contains(offer.triggerProductId)) {
        continue;
      }

      final cartItem = cartItems.firstWhere(
        (item) =>
            item.productId == offer.triggerProductId &&
            item.comboId == null &&
            (offer.triggerVariantId == null ||
                offer.triggerVariantId!.trim().isEmpty ||
                item.variantId == offer.triggerVariantId),
        orElse: () => CartItemInput(productId: '', quantity: 0),
      );
      if (cartItem.productId.isEmpty) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;

      final unlockQuantity = math.max(2, (offer.minTriggerQuantity ?? 1) * 2);
      if (cartItem.quantity >= unlockQuantity) {
        return BasketSuggestion(
          message: 'You unlocked BOGO! 1 item FREE',
          type: 'bogo',
          priority: 3,
          metadata: {'state': 'unlocked'},
          ctaLabel: 'Choose Free Item',
          productId: offer.triggerProductId,
          variantId: offer.triggerVariantId,
        );
      }

      final remaining = unlockQuantity - cartItem.quantity;
      if (remaining <= 0) continue;

      bestSuggestion = BasketSuggestion(
        message: 'Buy $remaining more and get it FREE',
        type: 'bogo',
        priority: 3,
        metadata: {'state': 'locked'},
        ctaLabel: 'Add One More',
        productId: offer.triggerProductId,
        variantId: offer.triggerVariantId,
      );
      break;
    }

    return bestSuggestion;
  }

  static BasketSuggestion? _buildVariantSuggestion({
    required List<CartItemInput> cartItems,
    required Map<String, Product> productMap,
    required Set<String> blockedProductIds,
  }) {
    BasketSuggestion? bestSuggestion;
    var bestSavings = 0.0;

    for (final item in cartItems) {
      if (item.comboId != null || blockedProductIds.contains(item.productId)) {
        continue;
      }

      final product = productMap[item.productId];
      if (product == null) continue;
      final variants = (product.variants ?? const <ProductVariant>[])
          .where((variant) => variant.isAvailable)
          .toList();
      if (variants.length < 2) continue;

      final currentVariant = _resolveVariant(product, item.variantId);
      if (currentVariant == null || currentVariant.quantityValue <= 0) continue;
      final currentUnitPrice = currentVariant.price / currentVariant.quantityValue;

      for (final variant in variants) {
        if (variant.variantId == currentVariant.variantId) continue;
        if (variant.quantityUnit != currentVariant.quantityUnit) continue;
        if (variant.quantityValue <= currentVariant.quantityValue) continue;

        final variantUnitPrice = variant.price / variant.quantityValue;
        if (variantUnitPrice >= currentUnitPrice) continue;

        final estimatedCurrentCost = currentUnitPrice * variant.quantityValue;
        final savings = estimatedCurrentCost - variant.price;
        if (savings <= bestSavings) continue;

        bestSavings = savings;
        bestSuggestion = BasketSuggestion(
          message:
              'Upgrade to ${_formatVariantLabel(variant)} & save ₹${savings.toStringAsFixed(0)}',
          type: 'variant',
          priority: 5,
          metadata: {'targetVariantLabel': _formatVariantLabel(variant)},
          ctaLabel: 'Upgrade',
          productId: item.productId,
          variantId: variant.variantId,
        );
      }
    }

    return bestSuggestion;
  }

  static ProductVariant? _resolveVariant(Product product, String? variantId) {
    final variants = product.variants ?? const <ProductVariant>[];
    if (variants.isEmpty) return null;
    if (variantId == null || variantId.trim().isEmpty) {
      return variants.first;
    }
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
