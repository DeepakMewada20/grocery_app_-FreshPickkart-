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
      for (final product in products)
        if (product.productId != null) product.productId!: product,
    };

    final deliveryConfig = await _getDeliveryConfig();
    final coupons = await _getCoupons();
    final bogoOffers = await _getBogoOffers(session);

    final suggestions = <BasketSuggestion>[];

    final deliverySuggestion = _buildFreeDeliverySuggestion(
      cartTotal: cartTotal,
      config: deliveryConfig,
    );
    if (deliverySuggestion != null) suggestions.add(deliverySuggestion);

    final couponSuggestion = _buildCouponSuggestion(
      cartTotal: cartTotal,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
    );
    if (couponSuggestion != null) suggestions.add(couponSuggestion);

    final bogoSuggestions = _buildBogoSuggestions(
      cartItems: normalizedItems,
      bogoOffers: bogoOffers,
      productMap: productMap,
    );
    suggestions.addAll(bogoSuggestions);

    final comboSuggestions = _buildComboSuggestions(
      cartItems: normalizedItems,
      comboOffers: comboOffers,
      productMap: productMap,
    );
    suggestions.addAll(comboSuggestions);

    final variantSuggestions = _buildVariantSuggestions(
      cartItems: normalizedItems,
      productMap: productMap,
    );
    suggestions.addAll(variantSuggestions);

    // Sort by priority and limit to 6
    suggestions.sort((a, b) => a.priority.compareTo(b.priority));
    return BasketSuggestionResult(
      suggestions: suggestions.take(6).toList(growable: false),
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
      if (cartTotal >= slab.minOrderAmount &&
          cartTotal <= slab.maxOrderAmount) {
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
      final nearText = remaining <= 50 ? 'Just' : 'Add';
      message = '$nearText ₹${remaining.toStringAsFixed(0)} away from FREE delivery 🚚';
    } else {
      message =
          'Add ₹${remaining.toStringAsFixed(0)} more — save ₹${savings.toStringAsFixed(0)} on delivery';
    }

    return BasketSuggestion(
      message: message,
      type: 'free_delivery',
      priority: 1,
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
  }

  static BasketSuggestion? _buildCouponSuggestion({
    required double cartTotal,
    required List<Coupon> coupons,
    String? appliedCouponCode,
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
      // Skip if already applied
      if (appliedCouponCode != null &&
          coupon.code.trim().toUpperCase() ==
              appliedCouponCode.trim().toUpperCase()) {
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
    final remaining = math
        .max(0.0, bestCoupon.minOrderAmount - cartTotal)
        .toDouble();
    final discountValue = bestCoupon.discountValue ?? 0;
    final nearText = remaining <= 75 ? '🎟 Just' : 'Add';
    final couponMsg = '$nearText ₹${remaining.toStringAsFixed(0)} more — unlock coupon ${bestCoupon.code} for ${_couponRewardLabel(bestCoupon)}';
    return BasketSuggestion(
      message: couponMsg,
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
      savingAmount: discountValue,
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

  static List<BasketSuggestion> _buildComboSuggestions({
    required List<CartItemInput> cartItems,
    required List<ComboOffer> comboOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <BasketSuggestion>[];

    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      if (combo.comboProducts.isEmpty) continue;

      // Skip if combo is already in cart
      final comboId = combo.comboId ?? combo.name;
      if (cartItems.any((item) => item.comboId == comboId)) {
        continue;
      }

      var matchedProducts = 0;
      for (final comboProduct in combo.comboProducts) {
        final cartItem = cartItems
            .where((item) => (item.comboId == null || item.comboId!.isEmpty))
            .firstWhere(
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

      // Build names list
      final comboProductNames = combo.comboProducts
          .map((cp) => productMap[cp.productId]?.productName ?? 'Item')
          .where((name) => name.isNotEmpty)
          .toList();

      // Comma-separated image URLs for all combo products
      final comboImageUrls = combo.comboProducts
          .map((cp) => productMap[cp.productId]?.imageUrl ?? '')
          .where((url) => url.isNotEmpty)
          .join(',');

      final firstTwoNames = comboProductNames.take(2).join(' + ');
      final extraCount = comboProductNames.length - 2;
      final message = extraCount > 0
          ? 'Bundle $firstTwoNames +$extraCount more & save ₹${savings.toStringAsFixed(0)}'
          : 'Bundle $firstTwoNames & save ₹${savings.toStringAsFixed(0)}';

      results.add(
        BasketSuggestion(
          message: message,
          type: 'combo',
          priority: 4,
          metadata: {
            'comboName': combo.name,
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
      );
    }

    results.sort((a, b) {
      final sa = double.tryParse(a.metadata?['savings'] ?? '0') ?? 0;
      final sb = double.tryParse(b.metadata?['savings'] ?? '0') ?? 0;
      return sb.compareTo(sa); // Best savings first
    });

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

  static List<BasketSuggestion> _buildBogoSuggestions({
    required List<CartItemInput> cartItems,
    required List<BogoOffer> bogoOffers,
    required Map<String, Product> productMap,
  }) {
    final results = <BasketSuggestion>[];

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;

      final minTriggerQty = offer.minTriggerQuantity ?? 1;
      if (minTriggerQty <= 0) continue;

      final freeQtyPerTrigger = _getFreeQtyPerOffer(offer);
      final freeItemPrice = product.price * freeQtyPerTrigger;

      // Check if free product is already in cart
      final freeProductInCart = cartItems.any(
        (item) =>
            (item.comboId == null || item.comboId!.isEmpty) &&
            offer.freeProductIds.contains(item.productId),
      );
      if (freeProductInCart) continue;

      // Check if offer requires specific variant
      final hasSpecificVariant =
          offer.triggerVariantId != null &&
          offer.triggerVariantId!.trim().isNotEmpty;

      if (hasSpecificVariant) {
        // Find cart item with specific variant
        final variantCartItem = cartItems.firstWhereOrNull(
          (item) =>
              item.productId == offer.triggerProductId &&
              (item.comboId == null || item.comboId!.isEmpty) &&
              item.variantId == offer.triggerVariantId,
        );

        if (variantCartItem == null) {
          // Wrong variant or no variant in cart - suggest upgrade
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
              BasketSuggestion(
                message:
                    'Switch$currentVariantLabel to$variantLabel & get $freeQtyPerTrigger FREE',
                type: 'bogo',
                priority: 3,
                metadata: {'state': 'variant_required'},
                ctaLabel: 'Upgrade Pack',
                productId: offer.triggerProductId,
                variantId: offer.triggerVariantId,
                savingAmount: freeItemPrice,
                thumbnailUrl: product.imageUrl,
              ),
            );
          }
          continue;
        }

        // Correct variant, check quantity
        final totalTriggerSets = variantCartItem.quantity ~/ minTriggerQty;
        if (totalTriggerSets <= 0) {
          final remaining = minTriggerQty - variantCartItem.quantity;
          final unitText = _getVariantLabel(product, offer.triggerVariantId);
          results.add(
            BasketSuggestion(
              message:
                  'Add $remaining more$unitText & get $freeQtyPerTrigger FREE',
              type: 'bogo',
              priority: 3,
              metadata: {'state': 'quantity_required'},
              ctaLabel: 'Add to Cart',
              productId: offer.triggerProductId,
              variantId: offer.triggerVariantId,
              savingAmount: freeItemPrice,
              thumbnailUrl: product.imageUrl,
            ),
          );
        }
        // If totalTriggerSets > 0, BOGO is unlocked - no suggestion needed
        // User will see unlocked state in cart automatically
      }

      // No specific variant required - check any variant of trigger product
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
            : 'item';
        results.add(
          BasketSuggestion(
            message:
                'Add $remaining more$unitText & get $freeQtyPerTrigger FREE',
            type: 'bogo',
            priority: 3,
            metadata: {'state': 'quantity_required'},
            ctaLabel: 'Add to Cart',
            productId: offer.triggerProductId,
            variantId: null,
            savingAmount: freeItemPrice,
            thumbnailUrl: product.imageUrl,
          ),
        );
      }
    }

    return results;
  }

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

  static List<BasketSuggestion> _buildVariantSuggestions({
    required List<CartItemInput> cartItems,
    required Map<String, Product> productMap,
  }) {
    final results = <BasketSuggestion>[];

    for (final item in cartItems) {
      if (item.comboId != null && item.comboId!.isNotEmpty) {
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

      final curNorm = _normalizeQuantity(currentVariant);
      if (curNorm <= 0) continue;
      final currentUnitPrice = currentVariant.price / curNorm;

      BasketSuggestion? bestUpgrade;
      var bestSavings = 0.0;

      for (final variant in variants) {
        if (variant.variantId == currentVariant.variantId) continue;

        final varNorm = _normalizeQuantity(variant);
        if (varNorm <= curNorm) continue; // Upsell only to larger packs

        final variantUnitPrice = variant.price / varNorm;
        if (variantUnitPrice >= currentUnitPrice) continue;

        final estimatedCurrentCost = currentUnitPrice * varNorm;
        final savings = estimatedCurrentCost - variant.price;
        if (savings <= bestSavings) continue;

        bestSavings = savings;
        bestUpgrade = BasketSuggestion(
          message:
              'Upgrade to ${_formatVariantLabel(variant)} & save ₹${savings.toStringAsFixed(0)}',
          type: 'variant',
          priority: 5,
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
        );
      }

      if (bestUpgrade != null) {
        results.add(bestUpgrade);
      }
    }

    results.sort((a, b) {
      final sa = double.tryParse(a.metadata?['savingsValue'] ?? '0') ?? 0;
      final sb = double.tryParse(b.metadata?['savingsValue'] ?? '0') ?? 0;
      return sb.compareTo(sa); // Best savings first
    });

    return results;
  }

  static double _normalizeQuantity(ProductVariant variant) {
    var val = variant.quantityValue;
    final unit = variant.quantityUnit.toLowerCase().trim();

    if (unit == 'kg' || unit == 'l') return val * 1000;
    if (unit == 'g' || unit == 'ml') return val;
    return val; // pcs, units, etc.
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
