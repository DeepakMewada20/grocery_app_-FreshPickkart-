import 'dart:math' as math;
import 'package:serverpod/serverpod.dart' hide Order;
import '../../endpoints/bogo_endpoint.dart';
import '../../endpoints/category_endpoint.dart';
import '../../endpoints/combo_offer_endpoint.dart';
import '../../endpoints/product_endpoint.dart';
import '../../endpoints/shop_more_get_more_endpoint.dart';
import '../../generated/protocol.dart';
import '../delivery/delivery_engine.dart';
import '../bogo/bogo_eligibility.dart';
import '../postgres/postgres_coupon_service.dart';
import '../postgres/postgres_order_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Internal scoring wrapper — never sent to client, pure Dart
// ─────────────────────────────────────────────────────────────────────────────
class _Scored {
  final BasketSuggestion suggestion;
  final double extraSpend;
  final double totalBenefit;
  final double netProfit;
  final double profitEfficiency;
  final double score;

  const _Scored({
    required this.suggestion,
    required this.extraSpend,
    required this.totalBenefit,
    this.score = 0,
  }) : netProfit = totalBenefit - extraSpend,
       profitEfficiency = totalBenefit / (extraSpend + 1);
}

class _ActionSelection {
  final List<BasketSuggestionAction> actions;
  final double totalBenefit;
  final double extraSpend;
  final double selectionValue;

  const _ActionSelection({
    required this.actions,
    required this.totalBenefit,
    required this.extraSpend,
    required this.selectionValue,
  });
}

class _ComboPricingSnapshot {
  final double sellingTotal;
  final double comboTotal;
  final double savings;

  const _ComboPricingSnapshot({
    required this.sellingTotal,
    required this.comboTotal,
    required this.savings,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────
class BasketSuggestionService {
  static const Duration _cacheTtl = Duration(minutes: 2);
  static final PostgresCouponService _couponService = PostgresCouponService();
  static final PostgresOrderService _orderService = PostgresOrderService();

  static List<BogoOffer>? _cachedBogoOffers;
  static DateTime? _cachedBogoAt;

  static List<ComboOffer>? _cachedComboOffers;
  static DateTime? _cachedComboAt;

  static DeliveryConfig? _cachedDeliveryConfig;
  static DateTime? _cachedDeliveryConfigAt;

  static List<Coupon>? _cachedCoupons;
  static DateTime? _cachedCouponsAt;

  static List<ShopMoreGetMoreOffer>? _cachedSmgmOffers;
  static DateTime? _cachedSmgmAt;

  static T? _firstWhereOrNull<T>(
    Iterable<T> values,
    bool Function(T item) test,
  ) {
    for (final value in values) {
      if (test(value)) return value;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public entry point
  // ─────────────────────────────────────────────────────────────────────────
  static Future<BasketSuggestionResult> getSuggestions({
    required Session session,
    List<CartItemInput>? items,
    double? cartTotal,
    String mode = 'cart',
    String? userId,
    String? appliedCouponCode,
  }) async {
    final normalizedItems = (items ?? const <CartItemInput>[])
        .where((item) => item.productId.trim().isNotEmpty && item.quantity > 0)
        .toList();

    final effectiveMode = mode == 'empty' || normalizedItems.isEmpty
        ? 'empty'
        : 'cart';
    if (effectiveMode == 'empty') {
      return _buildEmptyModeSuggestions(
        session: session,
        userId: userId,
        appliedCouponCode: appliedCouponCode,
      );
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

    final deliveryConfig = await _getDeliveryConfig(session);
    final coupons = await _getCoupons(session);
    final bogoOffers = await _getBogoOffers(session);
    final freeDeliveryProducts = await ProductEndpoint().getProducts(
      session,
      freeDelivery: true,
      limit: 6,
    );
    final smgmOffers = await _getSmgmOffers(session);

    // ── 2. Build all individual scored suggestions ──────────────────────────
    final scored = <_Scored>[];

    // If cart already has a free-delivery product, delivery fee is already ₹0
    // via DeliveryChargeCalculator — suppress all delivery slab suggestions
    // and delivery actions inside combined cards.
    final hasFreeDeliveryInCart = _hasCartFreeDeliveryProduct(
      normalizedItems,
      productMap,
    );

    final deliveryScored = hasFreeDeliveryInCart
        ? null
        : _scoreDelivery(
            cartTotal: cartTotal ?? 0,
            config: deliveryConfig,
          );
    if (deliveryScored != null) scored.add(deliveryScored);

    final couponScored = _scoreCoupon(
      cartTotal: cartTotal ?? 0,
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

    final freeDeliveryScored = hasFreeDeliveryInCart
        ? const <_Scored>[]
        : _scoreFreeDeliveryProducts(
            cartItems: normalizedItems,
            freeDeliveryProducts: freeDeliveryProducts,
            cartTotal: cartTotal ?? 0,
            deliveryConfig: deliveryConfig,
          );
    scored.addAll(freeDeliveryScored);

    final smgmScored = _scoreSmgmSuggestions(
      cartItems: normalizedItems,
      smgmOffers: smgmOffers,
      cartTotal: cartTotal ?? 0,
      productMap: productMap,
    );
    scored.addAll(smgmScored);

    // ── 3. Build combination suggestions ────────────────────────────────────
    final upgradedBaseItems = <_Scored>{};
    final combinations = _buildCombinations(
      cartTotal: cartTotal ?? 0,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
      variantScored: variantScored,
      comboScored: comboScored,
      bogoScored: bogoScored,
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

    // ── 5. Backfill if needed (Threshold: 6) ────────────────────────────────
    if (scored.length < 6) {
      final backfillPool = await Future.wait([
        ProductEndpoint().getProducts(
          session,
          limit: 8,
          sortBy: 'best_sellers',
        ),
        ProductEndpoint().getProducts(session, limit: 8, sortBy: 'trending'),
      ]);
      final bestSellers = backfillPool[0];
      final trending = backfillPool[1];

      // Refresh productMap with new backfill products
      for (final p in [...bestSellers, ...trending]) {
        if (p.productId != null) productMap.putIfAbsent(p.productId!, () => p);
      }

      final discovery = _scoreEmptyOfferSuggestions(
        bestSellers: bestSellers,
        trending: trending,
        bogoOffers: bogoOffers,
        comboOffers: comboOffers,
        productMap: productMap,
      );
      final prioritizedDiscovery = [
        ...discovery.where(
          (item) =>
              item.suggestion.type == 'bogo' || item.suggestion.type == 'combo',
        ),
        ...discovery.where(
          (item) =>
              item.suggestion.type != 'bogo' && item.suggestion.type != 'combo',
        ),
      ];

      for (final ds in prioritizedDiscovery) {
        final isDuplicate = scored.any(
          (s) =>
              (s.suggestion.productId != null &&
                  s.suggestion.productId == ds.suggestion.productId) ||
              (s.suggestion.comboId != null &&
                  s.suggestion.comboId == ds.suggestion.comboId),
        );
        final alreadyInCart = normalizedItems.any(
          (it) =>
              (ds.suggestion.comboId != null &&
                  it.comboId == ds.suggestion.comboId) ||
              (ds.suggestion.type == 'bogo' &&
                  ds.suggestion.productId != null &&
                  it.productId == ds.suggestion.productId),
        );

        if (!isDuplicate && !alreadyInCart) {
          // Low score to stay below contextual suggestions
          scored.add(
            _Scored(
              suggestion: ds.suggestion,
              extraSpend: ds.extraSpend,
              totalBenefit: ds.totalBenefit,
              score: ds.score * 0.1,
            ),
          );
        }
        if (scored.length >= 6) break;
      }
    }

    // ── 6. Finalize Results (Top 6) ──────────────────────────────────────────
    return _finalizeResults(scored);
  }

  static Future<BasketSuggestionResult> _buildEmptyModeSuggestions({
    required Session session,
    String? userId,
    String? appliedCouponCode,
  }) async {
    final normalizedUserId = userId?.trim();
    final futures = await Future.wait([
      ProductEndpoint().getProducts(session, limit: 8, sortBy: 'best_sellers'),
      ProductEndpoint().getProducts(session, limit: 8, sortBy: 'trending'),
      CategoryEndpoint().getCategories(session),
      _getBogoOffers(session),
      _getComboOffers(session),
      _getDeliveryConfig(session),
      _getCoupons(session),
      ProductEndpoint().getProducts(session, freeDelivery: true, limit: 6),
      normalizedUserId == null || normalizedUserId.isEmpty
          ? Future.value(const <Order>[])
          : _getRecentOrders(session, normalizedUserId),
      _getSmgmOffers(session),
    ]);

    final bestSellers = futures[0] as List<Product>;
    final trending = futures[1] as List<Product>;
    final categories = futures[2] as List<Category>;
    final bogoOffers = futures[3] as List<BogoOffer>;
    final comboOffers = futures[4] as List<ComboOffer>;
    final deliveryConfig = futures[5] as DeliveryConfig;
    final coupons = futures[6] as List<Coupon>;
    final freeDeliveryProducts = futures[7] as List<Product>;
    final recentOrders = futures[8] as List<Order>;
    final smgmOffers = futures[9] as List<ShopMoreGetMoreOffer>;

    final productPool = <Product>[
      ...bestSellers,
      ...trending,
    ];
    final loadedProductIds = productPool
        .map((product) => product.productId)
        .whereType<String>()
        .toSet();
    final recentOrderProductIds = recentOrders
        .expand((order) => order.items)
        .map((item) => item.productId)
        .where((productId) => productId.trim().isNotEmpty)
        .where((productId) => !loadedProductIds.contains(productId))
        .toSet()
        .toList();
    final recentOrderProducts = recentOrderProductIds.isEmpty
        ? const <Product>[]
        : await ProductEndpoint().getProductsByIds(
            session,
            recentOrderProductIds,
          );
    productPool.addAll(recentOrderProducts);
    final productMap = {
      for (final product in productPool)
        if (product.productId != null) product.productId!: product,
    };

    final scored = <_Scored>[];

    final reorder = _scoreReorderSuggestions(
      recentOrders: recentOrders,
      productMap: productMap,
    );
    scored.addAll(reorder);

    final coupon = _scoreEmptyCouponSuggestion(
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
    );
    if (coupon != null) scored.add(coupon);

    final delivery = _scoreEmptyDeliverySuggestion(deliveryConfig);
    if (delivery != null) scored.add(delivery);

    final emptyFreeDeliveryScored = _scoreFreeDeliveryProducts(
      cartItems: const [],
      freeDeliveryProducts: freeDeliveryProducts,
      cartTotal: 0,
      deliveryConfig: deliveryConfig,
    );
    scored.addAll(emptyFreeDeliveryScored);

    scored.addAll(
      _scoreSmgmSuggestions(
        cartItems: const [],
        smgmOffers: smgmOffers,
        cartTotal: 0,
        productMap: productMap,
      ),
    );

    scored.addAll(
      _scoreEmptyOfferSuggestions(
        bestSellers: bestSellers,
        trending: trending,
        bogoOffers: bogoOffers,
        comboOffers: comboOffers,
        productMap: productMap,
      ),
    );

    scored.addAll(
      _scoreCategorySuggestions(
        categories: categories,
        productPool: productPool,
      ),
    );

    scored.addAll(
      _buildEmptyCombinedSuggestion(
        coupon: coupon,
        delivery: delivery,
        offers: scored,
      ),
    );

    scored.sort((a, b) {
      final priorityCompare = _priorityBucket(a.suggestion.type).compareTo(
        _priorityBucket(b.suggestion.type),
      );
      if (priorityCompare != 0) return priorityCompare;
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      final benefitCompare = b.totalBenefit.compareTo(a.totalBenefit);
      if (benefitCompare != 0) return benefitCompare;
      return a.extraSpend.compareTo(b.extraSpend);
    });

    return _finalizeResults(scored);
  }

  static String _getScoredCategory(_Scored item) {
    final action =
        item.suggestion.action ??
        (item.suggestion.actions?.isNotEmpty == true
            ? item.suggestion.actions!.first
            : null);

    // 1. Free Delivery Product
    if (action?.label == 'FREE DELIVERY' ||
        item.suggestion.subtitle?.toLowerCase().contains(
              'free delivery with this product',
            ) ==
            true) {
      return 'free_delivery_product';
    }

    // 2. BOGO
    if (item.suggestion.type == 'bogo' || action?.type == 'bogo') {
      return 'bogo';
    }

    // 3. Combo
    if (item.suggestion.type == 'combo' || action?.type == 'combo') {
      return 'combo';
    }

    // 4. Delivery Slab
    if (item.suggestion.type == 'delivery' || action?.type == 'delivery') {
      return 'delivery_slab';
    }

    // 5. Coupon
    if (item.suggestion.type == 'coupon' || action?.type == 'coupon') {
      return 'coupon';
    }

    // 5b. SMGM Reward
    if (item.suggestion.type == 'smgm_reward') {
      return 'smgm_reward';
    }

    // 6. Combined
    if (item.suggestion.type == 'combined') {
      return 'combined';
    }

    // 7. Variant
    if (item.suggestion.type == 'variant' || action?.type == 'variant') {
      return 'variant';
    }

    // 8. Reorder
    if (item.suggestion.type == 'reorder' || action?.type == 'reorder') {
      return 'reorder';
    }

    // 9. Category
    if (item.suggestion.type == 'category' || action?.type == 'category') {
      return 'category';
    }

    // 10. Product
    if (item.suggestion.type == 'product' || action?.type == 'product') {
      return 'product';
    }

    return item.suggestion.type;
  }

  static BasketSuggestionResult _finalizeResults(List<_Scored> scored) {
    final selectedScored = <_Scored>[];
    final categoryCounts = <String, int>{};

    for (var limit = 1; limit <= 6 && selectedScored.length < 6; limit++) {
      for (final item in scored) {
        if (selectedScored.contains(item)) continue;

        final category = _getScoredCategory(item);
        final currentCount = categoryCounts[category] ?? 0;
        if (currentCount < limit) {
          selectedScored.add(item);
          categoryCounts[category] = currentCount + 1;
          if (selectedScored.length >= 6) break;
        }
      }
    }

    final results = <BasketSuggestion>[];
    for (var i = 0; i < selectedScored.length && results.length < 6; i++) {
      final item = selectedScored[i];
      final isBest = i == 0;
      final action =
          item.suggestion.action ??
          (item.suggestion.actions?.isNotEmpty == true
              ? item.suggestion.actions!.first
              : null);
      final finalized = item.suggestion.copyWith(
        id: item.suggestion.id ?? _buildSuggestionId(item.suggestion, i),
        title: item.suggestion.title ?? _defaultTitle(item.suggestion, action),
        subtitle:
            item.suggestion.subtitle ??
            _defaultSubtitle(item.suggestion, action),
        action: action,
        isBest: isBest,
        rank: i,
        score: item.score,
        netProfit: item.netProfit,
        extraSpend: item.extraSpend,
        profitEfficiency: item.profitEfficiency,
      );

      final meta = Map<String, String>.from(finalized.metadata ?? {});
      meta['isBest'] = isBest ? 'true' : 'false';
      meta['score'] = item.score.toStringAsFixed(2);
      results.add(finalized.copyWith(metadata: meta));
    }

    return BasketSuggestionResult(
      bestSuggestion: results.isNotEmpty ? results.first : null,
      otherSuggestions: results.length > 1
          ? results.skip(1).take(5).toList(growable: false)
          : const [],
      suggestions: results.toList(growable: false),
    );
  }

  static BasketSuggestionResult testFinalizeResults({
    required List<Map<String, dynamic>> items,
  }) {
    final scoredList = items.map((item) {
      final suggestion = BasketSuggestion(
        id: item['id'] as String?,
        type: item['type'] as String,
        title: item['title'] as String?,
        subtitle: item['subtitle'] as String?,
        message: item['message'] as String? ?? '',
        priority: item['priority'] as int? ?? 0,
        action: BasketSuggestionAction(
          type: item['actionType'] as String? ?? item['type'] as String,
          label: item['actionLabel'] as String? ?? '',
          ctaLabel: '',
        ),
      );
      return _Scored(
        suggestion: suggestion,
        extraSpend: (item['extraSpend'] as num? ?? 0).toDouble(),
        totalBenefit: (item['totalBenefit'] as num? ?? 0).toDouble(),
        score: (item['score'] as num? ?? 0).toDouble(),
      );
    }).toList();
    return _finalizeResults(scoredList);
  }

  static String _buildSuggestionId(BasketSuggestion suggestion, int index) {
    final action =
        suggestion.action ??
        (suggestion.actions?.isNotEmpty == true
            ? suggestion.actions!.first
            : null);
    final parts = <String?>[
      suggestion.type,
      suggestion.comboId,
      suggestion.productId,
      suggestion.variantId,
      action?.couponCode,
      action?.comboId,
      action?.productId,
      action?.variantId,
      action?.type,
      index.toString(),
    ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();
    return parts.join(':');
  }

  static String _defaultTitle(
    BasketSuggestion suggestion,
    BasketSuggestionAction? action,
  ) {
    switch (suggestion.type) {
      case 'reorder':
        return suggestion.title ?? action?.label ?? 'Buy again';
      case 'coupon':
        return suggestion.title ?? 'Coupon unlocked';
      case 'delivery':
        return suggestion.title ?? 'Free delivery';
      case 'combo':
        return suggestion.title ?? action?.label ?? 'Combo deal';
      case 'bogo':
        return suggestion.title ?? action?.label ?? 'BOGO deal';
      case 'category':
        return suggestion.title ?? action?.label ?? 'Category pick';
      case 'smgm_reward':
        return suggestion.title ?? 'Free Gift';
      case 'product':
        return suggestion.title ?? action?.label ?? 'Popular product';
      case 'combined':
        return suggestion.title ?? 'Stacked offer';
      default:
        return suggestion.title ?? 'Suggested for you';
    }
  }

  static String _defaultSubtitle(
    BasketSuggestion suggestion,
    BasketSuggestionAction? action,
  ) {
    switch (suggestion.type) {
      case 'reorder':
        return suggestion.subtitle ?? 'Tap to add it again in one step';
      case 'coupon':
        return suggestion.subtitle ?? 'Apply before checkout to save more';
      case 'delivery':
        return suggestion.subtitle ??
            'Add a little more to unlock cheaper delivery';
      case 'smgm_reward':
        return suggestion.subtitle ?? 'Unlock a free gift with your order';
      case 'combo':
      case 'bogo':
        return suggestion.subtitle ?? 'Best value picks from active offers';
      case 'category':
        return suggestion.subtitle ?? 'Jump straight into this aisle';
      case 'product':
        return suggestion.subtitle ?? 'A quick start from what is trending';
      case 'combined':
        return suggestion.subtitle ?? 'A stacked offer with higher savings';
      default:
        return suggestion.subtitle ?? action?.label ?? '';
    }
  }

  static int _priorityBucket(String type) {
    switch (type) {
      case 'reorder':
        return 0;
      case 'smgm_reward':
      case 'coupon':
        return 1;
      case 'delivery':
        return 2;
      case 'combo':
      case 'bogo':
      case 'combined':
        return 3;
      case 'product':
        return 4;
      case 'category':
        return 5;
      default:
        return 6;
    }
  }

  static double _scoreFromComponents({
    required String type,
    required double conversionProbability,
    required double userRelevance,
    required double profitImpact,
    required double urgency,
  }) {
    final typeBias = switch (type) {
      'reorder' => 20.0,
      'coupon' => 16.0,
      'delivery' => 14.0,
      'combined' => 15.0,
      'combo' => 12.0,
      'bogo' => 12.0,
      'smgm_reward' => 18.0,
      'product' => 8.0,
      'category' => 5.0,
      _ => 0.0,
    };
    return typeBias +
        conversionProbability +
        userRelevance +
        profitImpact +
        urgency;
  }

  static BasketSuggestionAction _primaryAction({
    required String type,
    required String label,
    required String ctaLabel,
    Map<String, String>? payload,
    String? productId,
    String? variantId,
    String? comboId,
    String? couponCode,
    double? benefit,
    double? extraSpend,
  }) {
    return BasketSuggestionAction(
      type: type,
      label: label,
      ctaLabel: ctaLabel,
      payload: payload,
      productId: productId,
      variantId: variantId,
      comboId: comboId,
      couponCode: couponCode,
      benefit: benefit,
      extraSpend: extraSpend,
    );
  }

  static BasketSuggestion _buildSuggestion({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required String message,
    required int priority,
    required BasketSuggestionAction action,
    List<BasketSuggestionAction>? actions,
    Map<String, String>? metadata,
    double? score,
    double? netProfit,
    double? extraSpend,
    double? profitEfficiency,
    bool? isBest,
    int? rank,
    double? progressCurrent,
    double? progressTarget,
    double? progressRemaining,
    String? ctaLabel,
    String? productId,
    String? variantId,
    String? comboId,
    double? savingAmount,
    String? thumbnailUrl,
  }) {
    return BasketSuggestion(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      message: message,
      priority: priority,
      score: score,
      metadata: metadata,
      action: action,
      actions: actions ?? [action],
      netProfit: netProfit,
      extraSpend: extraSpend,
      profitEfficiency: profitEfficiency,
      rank: rank,
      isBest: isBest,
      progressCurrent: progressCurrent,
      progressTarget: progressTarget,
      progressRemaining: progressRemaining,
      ctaLabel: ctaLabel ?? action.ctaLabel,
      productId: productId,
      variantId: variantId,
      comboId: comboId,
      savingAmount: savingAmount,
      thumbnailUrl: thumbnailUrl,
    );
  }

  static Future<List<Order>> _getRecentOrders(
    Session session,
    String userId,
  ) async {
    if (userId.trim().isEmpty) return const <Order>[];
    try {
      final orders = await _orderService.getUserOrders(session, userId);
      orders.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
      return orders.take(5).toList(growable: false);
    } catch (_) {
      return const <Order>[];
    }
  }

  static List<_Scored> _scoreReorderSuggestions({
    required List<Order> recentOrders,
    required Map<String, Product> productMap,
  }) {
    final counts = <String, int>{};
    final preferredVariant = <String, String?>{};
    for (final order in recentOrders) {
      for (final item in order.items) {
        if (item.productId.trim().isEmpty || item.isFreeItem) continue;
        counts[item.productId] = (counts[item.productId] ?? 0) + item.quantity;
        preferredVariant.putIfAbsent(item.productId, () => item.variantId);
      }
    }

    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries
        .take(5)
        .map((entry) {
          final product = productMap[entry.key];
          if (product == null) {
            return null;
          }
          final variantId = preferredVariant[entry.key];
          final action = _primaryAction(
            type: 'add_to_cart',
            label: 'Add ${product.productName}',
            ctaLabel: 'Add Again',
            payload: variantId == null
                ? {'productId': product.productId ?? ''}
                : {
                    'productId': product.productId ?? '',
                    'variantId': variantId,
                  },
            productId: product.productId,
            variantId: variantId,
          );
          final benefit = product.price;
          final score = _scoreFromComponents(
            type: 'reorder',
            conversionProbability:
                38 + (entry.value * 6).clamp(0, 24).toDouble(),
            userRelevance: 38 + (entry.value * 5).clamp(0, 20).toDouble(),
            profitImpact: (benefit / 10).clamp(4, 18).toDouble(),
            urgency: 22,
          );

          return _Scored(
            extraSpend: 0,
            totalBenefit: benefit,
            score: score,
            suggestion: _buildSuggestion(
              id: 'reorder:${entry.key}',
              type: 'reorder',
              title: product.productName,
              subtitle: 'Frequently bought again',
              message: 'Buy ${product.productName} again with one tap',
              priority: 0,
              action: action,
              productId: product.productId,
              variantId: variantId,
              thumbnailUrl: product.imageUrl,
              savingAmount: 0,
              ctaLabel: 'Add Again',
            ),
          );
        })
        .whereType<_Scored>()
        .toList();
  }

  static _Scored? _scoreEmptyCouponSuggestion({
    required List<Coupon> coupons,
    String? appliedCouponCode,
  }) {
    if (coupons.isEmpty) return null;
    final now = DateTime.now().toUtc();
    Coupon? best;
    for (final coupon in coupons) {
      if (!coupon.isActive) continue;
      if (appliedCouponCode?.toUpperCase() == coupon.code.toUpperCase()) {
        continue;
      }
      final expiry = (coupon.expiryDate ?? coupon.endDate)?.toUtc();
      if (expiry != null && now.isAfter(expiry)) continue;
      if (best == null) {
        best = coupon;
        continue;
      }
      final bestValue = (best.discountValue ?? 0);
      final candidateValue = (coupon.discountValue ?? 0);
      if (candidateValue > bestValue ||
          (candidateValue == bestValue &&
              coupon.minOrderAmount < best.minOrderAmount)) {
        best = coupon;
      }
    }
    if (best == null) return null;

    final benefit = best.discountValue ?? 0;
    final score = _scoreFromComponents(
      type: 'coupon',
      conversionProbability: 42,
      userRelevance: 18,
      profitImpact: (benefit / 2).clamp(8, 22).toDouble(),
      urgency: 20,
    );
    final remaining = best.minOrderAmount;
    final action = _primaryAction(
      type: 'apply_coupon',
      label: 'Apply ${best.code}',
      ctaLabel: 'Apply Coupon',
      payload: {
        'couponCode': best.code,
        'minOrderAmount': best.minOrderAmount.toStringAsFixed(0),
      },
      couponCode: best.code,
      benefit: benefit,
      extraSpend: remaining,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: benefit,
      score: score,
      suggestion: _buildSuggestion(
        id: 'coupon:${best.code}',
        type: 'coupon',
        title: 'Get ₹${benefit.toStringAsFixed(0)} OFF',
        subtitle: 'Use ${best.code} before checkout',
        message: 'Coupon ${best.code} is active and ready to use',
        priority: 1,
        action: action,
        score: score,
        savingAmount: benefit,
        progressCurrent: 0,
        progressTarget: best.minOrderAmount,
        progressRemaining: best.minOrderAmount,
      ),
    );
  }

  static _Scored? _scoreEmptyDeliverySuggestion(DeliveryConfig config) {
    final currentFee = config.baseDeliveryFee;
    if (currentFee <= 0 || config.slabs.isEmpty) return null;
    final nextMilestone =
        config.slabs.where((slab) => slab.fee == 0).fold<DeliverySlab?>(null, (
          best,
          slab,
        ) {
          if (best == null || slab.minOrderAmount < best.minOrderAmount) {
            return slab;
          }
          return best;
        }) ??
        config.slabs.first;

    final remaining = nextMilestone.minOrderAmount;
    final savings = currentFee - nextMilestone.fee;
    final action = _primaryAction(
      type: 'delivery',
      label: 'Free delivery',
      ctaLabel: 'Auto Apply',
      payload: {
        'minOrderAmount': nextMilestone.minOrderAmount.toStringAsFixed(0),
      },
      benefit: savings,
      extraSpend: remaining,
    );
    final score = _scoreFromComponents(
      type: 'delivery',
      conversionProbability: 36,
      userRelevance: 20,
      profitImpact: (savings * 1.6).clamp(8, 24).toDouble(),
      urgency: 24,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: savings,
      score: score,
      suggestion: _buildSuggestion(
        id: 'delivery:${nextMilestone.minOrderAmount.toStringAsFixed(0)}',
        type: 'delivery',
        title: nextMilestone.fee == 0
            ? 'Free delivery above ₹${nextMilestone.minOrderAmount.toStringAsFixed(0)}'
            : 'Delivery savings unlocked',
        subtitle: 'A little more brings the fee down',
        message:
            'Free delivery above ₹${nextMilestone.minOrderAmount.toStringAsFixed(0)}',
        priority: 2,
        action: action,
        score: score,
        savingAmount: savings,
        progressCurrent: 0,
        progressTarget: nextMilestone.minOrderAmount,
        progressRemaining: remaining,
      ),
    );
  }

  static List<_Scored> _scoreEmptyOfferSuggestions({
    required List<Product> bestSellers,
    required List<Product> trending,
    required List<BogoOffer> bogoOffers,
    required List<ComboOffer> comboOffers,
    required Map<String, Product> productMap,
  }) {
    final scored = <_Scored>[];
    final availableProducts = <Product>[
      ...bestSellers,
      ...trending,
    ].where((product) => product.productId != null).toList();

    final topProduct = availableProducts.isNotEmpty
        ? availableProducts.first
        : null;
    if (topProduct != null) {
      final action = _primaryAction(
        type: 'navigate',
        label: 'View ${topProduct.productName}',
        ctaLabel: 'View Product',
        payload: {
          'productId': topProduct.productId ?? '',
        },
        productId: topProduct.productId,
      );
      final score = _scoreFromComponents(
        type: 'product',
        conversionProbability: 28,
        userRelevance: 24,
        profitImpact: (topProduct.discount / 3).clamp(6, 18).toDouble(),
        urgency: 12,
      );
      scored.add(
        _Scored(
          extraSpend: topProduct.price,
          totalBenefit: topProduct.discount,
          score: score,
          suggestion: _buildSuggestion(
            id: 'product:${topProduct.productId}',
            type: 'product',
            title: topProduct.productName,
            subtitle: 'Top selling product',
            message: 'Start with ${topProduct.productName}',
            priority: 4,
            action: action,
            score: score,
            productId: topProduct.productId,
            thumbnailUrl: topProduct.imageUrl,
            savingAmount: topProduct.discount,
          ),
        ),
      );
    }

    final bogo = bogoOffers.where((offer) => offer.isActive).toList();
    for (final offer in bogo) {
      final trigger = productMap[offer.triggerProductId];
      if (trigger != null) {
        final action = _primaryAction(
          type: 'add_to_cart',
          label: 'Get ${trigger.productName}',
          ctaLabel: 'Add Item',
          payload: {
            'productId': trigger.productId ?? '',
            if (offer.triggerVariantId != null)
              'variantId': offer.triggerVariantId!,
          },
          productId: trigger.productId,
          variantId: offer.triggerVariantId,
        );
        final benefit = trigger.price;
        final score = _scoreFromComponents(
          type: 'bogo',
          conversionProbability: 34,
          userRelevance: 18,
          profitImpact: (benefit / 2).clamp(10, 20).toDouble(),
          urgency: 14,
        );
        scored.add(
          _Scored(
            extraSpend: trigger.price,
            totalBenefit: benefit,
            score: score,
            suggestion: _buildSuggestion(
              id: 'bogo:${trigger.productId}',
              type: 'bogo',
              title: 'BOGO on ${trigger.productName}',
              subtitle: 'Tap to view the free item',
              message: 'Buy ${trigger.productName} and get a free product',
              priority: 3,
              action: action,
              score: score,
              productId: trigger.productId,
              variantId: offer.triggerVariantId,
              thumbnailUrl: trigger.imageUrl,
              savingAmount: benefit,
            ),
          ),
        );
      }
    }

    final combo = comboOffers.where((offer) => offer.isActive).toList();
    for (final offer in combo) {
      final comboId = offer.comboId ?? offer.name;
      final comboLeadProduct = offer.comboProducts.isNotEmpty
          ? productMap[offer.comboProducts.first.productId]
          : null;
      if (comboLeadProduct != null) {
        final pricing = _computeComboPricing(offer, productMap);
        if (pricing.comboTotal <= 0 || pricing.savings <= 0) continue;
        final action = _primaryAction(
          type: 'navigate',
          label: 'View ${offer.name}',
          ctaLabel: 'View Combo',
          payload: {'comboId': comboId},
          comboId: comboId,
          benefit: pricing.savings,
          extraSpend: pricing.comboTotal,
        );
        final score = _scoreFromComponents(
          type: 'combo',
          conversionProbability: 30,
          userRelevance: 18,
          profitImpact: (pricing.savings / 2).clamp(8, 20).toDouble(),
          urgency: 14,
        );
        scored.add(
          _Scored(
            extraSpend: pricing.comboTotal,
            totalBenefit: pricing.savings,
            score: score,
            suggestion: _buildSuggestion(
              id: 'combo:$comboId',
              type: 'combo',
              title: offer.name,
              subtitle: 'Bundle deal',
              message:
                  'Get ${offer.name} for ₹${pricing.comboTotal.toStringAsFixed(0)} and save ₹${pricing.savings.toStringAsFixed(0)}',
              priority: 3,
              action: action,
              score: score,
              comboId: comboId,
              thumbnailUrl: comboLeadProduct.imageUrl,
              savingAmount: pricing.savings,
            ),
          ),
        );
      }
    }

    return scored;
  }

  static List<_Scored> _scoreCategorySuggestions({
    required List<Category> categories,
    required List<Product> productPool,
  }) {
    if (categories.isEmpty && productPool.isEmpty) return const [];
    final counts = <String, int>{};
    final images = <String, String>{};
    for (final product in productPool) {
      counts.update(product.category, (value) => value + 1, ifAbsent: () => 1);
      images.putIfAbsent(product.category, () => product.imageUrl);
    }

    final sortedCategories =
        categories
            .where((category) => category.categoryName.trim().isNotEmpty)
            .toList()
          ..sort((a, b) {
            final countA = counts[a.categoryName] ?? 0;
            final countB = counts[b.categoryName] ?? 0;
            final countCompare = countB.compareTo(countA);
            if (countCompare != 0) return countCompare;
            return a.categoryName.toLowerCase().compareTo(
              b.categoryName.toLowerCase(),
            );
          });

    return sortedCategories.take(2).map((category) {
      final productHint = _firstWhereOrNull(
        productPool,
        (product) => product.category == category.categoryName,
      );
      final action = _primaryAction(
        type: 'navigate',
        label: category.categoryName,
        ctaLabel: 'Browse',
        payload: {'categoryId': category.categoryName},
      );
      final score = _scoreFromComponents(
        type: 'category',
        conversionProbability: 16,
        userRelevance: (counts[category.categoryName] ?? 0) * 4.0,
        profitImpact: 5,
        urgency: 4,
      );

      return _Scored(
        extraSpend: 0,
        totalBenefit: 0,
        score: score,
        suggestion: _buildSuggestion(
          id: 'category:${category.categoryName}',
          type: 'category',
          title: category.categoryName,
          subtitle: 'Quick category entry',
          message: 'Explore ${category.categoryName}',
          priority: 5,
          action: action,
          score: score,
          productId: productHint?.productId,
          thumbnailUrl: images[category.categoryName],
        ),
      );
    }).toList();
  }

  static List<_Scored> _buildEmptyCombinedSuggestion({
    required _Scored? coupon,
    required _Scored? delivery,
    required List<_Scored> offers,
  }) {
    final bestCombo = _bestScoredByValue(
      offers.where((entry) => entry.suggestion.type == 'combo'),
    );
    final bestBogo = _bestScoredByValue(
      offers.where((entry) => entry.suggestion.type == 'bogo'),
    );
    final leadOffer = _bestScoredByValue([?bestCombo, ?bestBogo]);

    final components = <_Scored>[?bestCombo, ?bestBogo, ?coupon, ?delivery];
    if (components.length < 2) return const [];

    _ActionSelection? bestSelection;
    List<_Scored>? bestComponents;
    for (var mask = 0; mask < (1 << components.length); mask++) {
      final selected = <_Scored>[];
      for (var i = 0; i < components.length; i++) {
        if ((mask & (1 << i)) != 0) {
          selected.add(components[i]);
        }
      }

      if (selected.length < 2 || selected.length > 3) continue;
      final offerCount = selected
          .where(
            (entry) =>
                entry.suggestion.type == 'combo' ||
                entry.suggestion.type == 'bogo',
          )
          .length;
      if (offerCount > 2) continue;

      final actions = selected
          .map(_combinedActionForSuggestion)
          .whereType<BasketSuggestionAction>()
          .toList(growable: false);
      if (actions.length != selected.length) continue;

      final totalBenefit = selected.fold<double>(
        0,
        (sum, entry) => sum + entry.totalBenefit,
      );
      final extraSpend = selected.fold<double>(
        0,
        (maxSpend, entry) => math.max(maxSpend, entry.extraSpend),
      );
      final selection = _ActionSelection(
        actions: actions,
        totalBenefit: totalBenefit,
        extraSpend: extraSpend,
        selectionValue: _selectionValue(
          totalBenefit: totalBenefit,
          extraSpend: extraSpend,
          actionCount: actions.length,
        ),
      );

      if (_isBetterSelection(selection, bestSelection)) {
        bestSelection = selection;
        bestComponents = selected;
      }
    }

    if (bestSelection == null ||
        bestComponents == null ||
        bestSelection.actions.length < 2) {
      return const [];
    }

    final score = _scoreFromComponents(
      type: 'combined',
      conversionProbability: 40,
      userRelevance: 28,
      profitImpact: (bestSelection.totalBenefit / 2).clamp(12, 28).toDouble(),
      urgency: 18,
    );
    final visualBase = leadOffer ?? bestComponents.first;

    return [
      _Scored(
        extraSpend: bestSelection.extraSpend,
        totalBenefit: bestSelection.totalBenefit,
        score: score,
        suggestion: _buildSuggestion(
          id: 'combined:${bestSelection.actions.map((a) => a.type).join('+')}',
          type: 'combined',
          title: 'Stacked savings',
          subtitle: _combinedSubtitle(bestSelection.actions),
          message: 'Stack the strongest live offers without extra clutter',
          priority: 1,
          action: bestSelection.actions.first,
          actions: bestSelection.actions,
          score: score,
          savingAmount: bestSelection.totalBenefit,
          comboId: visualBase.suggestion.comboId,
          productId: visualBase.suggestion.productId,
          variantId: visualBase.suggestion.variantId,
          thumbnailUrl: visualBase.suggestion.thumbnailUrl,
          metadata: visualBase.suggestion.metadata,
        ),
      ),
    ];
  }

  static BasketSuggestionAction? _combinedActionForSuggestion(_Scored entry) {
    final action =
        entry.suggestion.action ??
        (entry.suggestion.actions?.isNotEmpty == true
            ? entry.suggestion.actions!.first
            : null);
    if (action == null) return null;

    final normalizedType = switch (entry.suggestion.type) {
      'combo' => 'combo',
      'bogo' => 'bogo',
      'coupon' => 'coupon',
      'delivery' => 'delivery',
      _ => action.type,
    };

    return action.copyWith(
      type: normalizedType,
      productId: action.productId ?? entry.suggestion.productId,
      variantId: action.variantId ?? entry.suggestion.variantId,
      comboId:
          action.comboId ??
          entry.suggestion.comboId ??
          action.payload?['comboId'],
      couponCode: action.couponCode ?? action.payload?['couponCode'],
      benefit: action.benefit ?? entry.totalBenefit,
      extraSpend: action.extraSpend ?? entry.extraSpend,
    );
  }

  static String _combinedSubtitle(List<BasketSuggestionAction> actions) {
    final labels = <String>[];
    for (final action in actions) {
      final label = switch (action.type) {
        'combo' => 'Combo',
        'bogo' => 'BOGO',
        'coupon' => 'Coupon',
        'delivery' => 'Delivery',
        'variant' => 'Pack upgrade',
        _ => null,
      };
      if (label != null && !labels.contains(label)) {
        labels.add(label);
      }
    }
    return labels.isEmpty
        ? 'Multiple savings in one suggestion'
        : labels.join(' + ');
  }

  static BasketSuggestionAction _couponActionFromCoupon(Coupon coupon) {
    return BasketSuggestionAction(
      type: 'coupon',
      label: 'Apply ${coupon.code}',
      ctaLabel: 'Apply',
      payload: {
        'couponCode': coupon.code,
      },
      couponCode: coupon.code,
      benefit: coupon.discountValue,
      extraSpend: 0,
    );
  }

  static double _selectionValue({
    required double totalBenefit,
    required double extraSpend,
    required int actionCount,
  }) {
    final complexityPenalty = math.max(0, actionCount - 2) * 15.0;
    return (totalBenefit - extraSpend) - complexityPenalty;
  }

  static bool _isBetterSelection(
    _ActionSelection candidate,
    _ActionSelection? current,
  ) {
    if (current == null) return true;
    final valueCompare = candidate.selectionValue.compareTo(
      current.selectionValue,
    );
    if (valueCompare != 0) return valueCompare > 0;
    final benefitCompare = candidate.totalBenefit.compareTo(
      current.totalBenefit,
    );
    if (benefitCompare != 0) return benefitCompare > 0;
    final actionCompare = current.actions.length.compareTo(
      candidate.actions.length,
    );
    if (actionCompare != 0) return actionCompare > 0;
    return candidate.extraSpend < current.extraSpend;
  }

  static _Scored? _bestScoredByValue(Iterable<_Scored> items) {
    _Scored? best;
    for (final item in items) {
      if (best == null) {
        best = item;
        continue;
      }
      final netCompare = item.netProfit.compareTo(best.netProfit);
      if (netCompare > 0) {
        best = item;
        continue;
      }
      if (netCompare < 0) continue;
      final efficiencyCompare = item.profitEfficiency.compareTo(
        best.profitEfficiency,
      );
      if (efficiencyCompare > 0) {
        best = item;
        continue;
      }
      if (efficiencyCompare < 0) continue;
      if (item.extraSpend < best.extraSpend) {
        best = item;
      }
    }
    return best;
  }

  static Coupon? _findBestCouponForAdditionalSpend({
    required double cartTotal,
    required double additionalSpend,
    required List<Coupon> coupons,
    required String? appliedCouponCode,
  }) {
    final total = cartTotal + additionalSpend;
    Coupon? best;
    double maxSav = 0;
    for (final coupon in coupons) {
      if (!coupon.isActive ||
          coupon.minOrderAmount <= cartTotal ||
          coupon.minOrderAmount > total) {
        continue;
      }
      if (appliedCouponCode?.toUpperCase() == coupon.code.toUpperCase()) {
        continue;
      }
      final value = coupon.discountValue ?? 0;
      if (value > maxSav) {
        maxSav = value;
        best = coupon;
      }
    }
    return best;
  }

  static _Scored? _stackWithThresholds({
    required double cartTotal,
    required List<Coupon> coupons,
    required String? appliedCouponCode,
    required _Scored base,
    required _Scored? deliveryScored,
    required String messagePrefix,
    required double conversionProbability,
    required double userRelevance,
    required double urgency,
  }) {
    final baseAction = _combinedActionForSuggestion(base);
    if (baseAction == null) return null;

    final unlockedCoupon = _findBestCouponForAdditionalSpend(
      cartTotal: cartTotal,
      additionalSpend: base.extraSpend,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
    );
    final availableDelivery = deliveryScored;
    final unlocksDelivery =
        availableDelivery != null &&
        base.extraSpend >= availableDelivery.extraSpend;
    final deliveryAction = unlocksDelivery
        ? _combinedActionForSuggestion(availableDelivery)
        : null;
    final deliveryBenefit = deliveryAction != null && availableDelivery != null
        ? availableDelivery.totalBenefit
        : 0.0;

    _ActionSelection? bestSelection;
    for (final includeCoupon in [false, true]) {
      if (includeCoupon && unlockedCoupon == null) continue;
      for (final includeDelivery in [false, true]) {
        if (includeDelivery && deliveryAction == null) continue;
        final actionCount =
            1 + (includeCoupon ? 1 : 0) + (includeDelivery ? 1 : 0);
        if (actionCount < 2 || actionCount > 3) continue;

        final totalBenefit =
            base.totalBenefit +
            (includeCoupon ? (unlockedCoupon?.discountValue ?? 0) : 0) +
            (includeDelivery ? deliveryBenefit : 0);
        final selection = _ActionSelection(
          actions: [
            baseAction,
            if (includeCoupon && unlockedCoupon != null)
              _couponActionFromCoupon(unlockedCoupon),
            if (includeDelivery && deliveryAction != null) deliveryAction,
          ],
          totalBenefit: totalBenefit,
          extraSpend: base.extraSpend,
          selectionValue: _selectionValue(
            totalBenefit: totalBenefit,
            extraSpend: base.extraSpend,
            actionCount: actionCount,
          ),
        );
        if (_isBetterSelection(selection, bestSelection)) {
          bestSelection = selection;
        }
      }
    }

    if (bestSelection == null || bestSelection.actions.length < 2) {
      return null;
    }

    final score = _scoreFromComponents(
      type: 'combined',
      conversionProbability: conversionProbability,
      userRelevance: userRelevance,
      profitImpact: (bestSelection.totalBenefit * 1.15)
          .clamp(14, 34)
          .toDouble(),
      urgency: urgency,
    );

    return _Scored(
      extraSpend: base.extraSpend,
      totalBenefit: bestSelection.totalBenefit,
      score: score,
      suggestion: BasketSuggestion(
        message:
            '$messagePrefix & stack more savings (Save ₹${bestSelection.totalBenefit.toStringAsFixed(0)})',
        type: 'combined',
        priority: 0,
        actions: bestSelection.actions,
        savingAmount: bestSelection.totalBenefit,
        productId: base.suggestion.productId,
        variantId: base.suggestion.variantId,
        comboId: base.suggestion.comboId,
        thumbnailUrl: base.suggestion.thumbnailUrl,
        metadata: base.suggestion.metadata,
      ),
    );
  }

  static _Scored? _buildDualOfferCombination({
    required double cartTotal,
    required List<Coupon> coupons,
    required String? appliedCouponCode,
    required _Scored combo,
    required _Scored bogo,
    required _Scored? deliveryScored,
  }) {
    final comboAction = _combinedActionForSuggestion(combo);
    final bogoAction = _combinedActionForSuggestion(bogo);
    if (comboAction == null || bogoAction == null) return null;

    final pairExtraSpend = combo.extraSpend + bogo.extraSpend;
    final pairBenefit = combo.totalBenefit + bogo.totalBenefit;
    final unlockedCoupon = _findBestCouponForAdditionalSpend(
      cartTotal: cartTotal,
      additionalSpend: pairExtraSpend,
      coupons: coupons,
      appliedCouponCode: appliedCouponCode,
    );
    final availableDelivery = deliveryScored;
    final deliveryAvailable =
        availableDelivery != null &&
        pairExtraSpend >= availableDelivery.extraSpend;
    final deliveryAction = deliveryAvailable
        ? _combinedActionForSuggestion(availableDelivery)
        : null;
    final deliveryBenefit = deliveryAction != null && availableDelivery != null
        ? availableDelivery.totalBenefit
        : 0.0;

    final pairIncrementalValue = bogo.totalBenefit - bogo.extraSpend;
    final simplerExtraValue = math.max(
      unlockedCoupon?.discountValue ?? 0,
      deliveryAvailable ? deliveryBenefit : 0,
    );
    if (pairIncrementalValue <= simplerExtraValue) {
      return null;
    }

    _ActionSelection? bestSelection;
    for (final extra in <BasketSuggestionAction?>[
      null,
      ?(unlockedCoupon != null
          ? _couponActionFromCoupon(unlockedCoupon)
          : null),
      ?deliveryAction,
    ]) {
      final actions = <BasketSuggestionAction>[
        comboAction,
        bogoAction,
        ?extra,
      ];
      final totalBenefit =
          pairBenefit +
          (extra?.type == 'coupon' ? unlockedCoupon?.discountValue ?? 0 : 0) +
          (extra?.type == 'delivery' ? deliveryBenefit : 0);
      final selection = _ActionSelection(
        actions: actions,
        totalBenefit: totalBenefit,
        extraSpend: pairExtraSpend,
        selectionValue: _selectionValue(
          totalBenefit: totalBenefit,
          extraSpend: pairExtraSpend,
          actionCount: actions.length,
        ),
      );
      if (_isBetterSelection(selection, bestSelection)) {
        bestSelection = selection;
      }
    }

    if (bestSelection == null || bestSelection.actions.length < 2) {
      return null;
    }

    final score = _scoreFromComponents(
      type: 'combined',
      conversionProbability: 44,
      userRelevance: 28,
      profitImpact: (bestSelection.totalBenefit * 1.15)
          .clamp(16, 36)
          .toDouble(),
      urgency: pairExtraSpend <= 75 ? 20 : 16,
    );

    return _Scored(
      extraSpend: pairExtraSpend,
      totalBenefit: bestSelection.totalBenefit,
      score: score,
      suggestion: BasketSuggestion(
        message:
            'Stack BOGO + Combo (Save ₹${bestSelection.totalBenefit.toStringAsFixed(0)})',
        type: 'combined',
        priority: 0,
        actions: bestSelection.actions,
        savingAmount: bestSelection.totalBenefit,
        comboId: combo.suggestion.comboId,
        productId: bogo.suggestion.productId,
        variantId: bogo.suggestion.variantId,
        thumbnailUrl:
            combo.suggestion.thumbnailUrl ?? bogo.suggestion.thumbnailUrl,
        metadata: combo.suggestion.metadata ?? bogo.suggestion.metadata,
      ),
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

    final remaining = math
        .max(0.0, nextMilestone.minOrderAmount - cartTotal)
        .toDouble();
    final savings = currentFee - nextMilestone.fee;

    final isFree = nextMilestone.fee == 0;
    final benefitLabel = isFree
        ? 'FREE Delivery'
        : 'SAVE ₹${savings.toStringAsFixed(0)}';

    final action = BasketSuggestionAction(
      type: 'delivery',
      label: 'Unlock $benefitLabel',
      ctaLabel: 'Shop More',
      payload: {
        'targetAmount': nextMilestone.minOrderAmount.toStringAsFixed(0),
      },
      benefit: savings,
      extraSpend: remaining,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: savings,
      score: _scoreFromComponents(
        type: 'delivery',
        conversionProbability: 28,
        userRelevance: 18,
        profitImpact: (savings * 1.6).clamp(8, 24).toDouble(),
        urgency: (remaining <= 75 ? 22 : 14).toDouble(),
      ),
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
      final expiry = (c.expiryDate ?? c.endDate)?.toUtc();
      if (expiry != null && now.isAfter(expiry)) continue;
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
      payload: {
        'couponCode': best.code,
        'minOrderAmount': best.minOrderAmount.toStringAsFixed(0),
      },
      couponCode: best.code,
      benefit: benefit,
      extraSpend: remaining,
    );

    return _Scored(
      extraSpend: remaining,
      totalBenefit: benefit,
      score: _scoreFromComponents(
        type: 'coupon',
        conversionProbability: 40,
        userRelevance: 14,
        profitImpact: (benefit * 1.4).clamp(10, 26).toDouble(),
        urgency: (remaining <= 100 ? 16 : 12).toDouble(),
      ),
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

      final bestFreeProduct = _bestBogoFreeProduct(offer, productMap);
      final baseBenefit = bestFreeProduct?.price ?? trigger.price;

      final triggerCartItems = cartItems
          .where(
            (item) =>
                item.productId == offer.triggerProductId &&
                (item.comboId == null || item.comboId!.trim().isEmpty),
          )
          .toList();

      final eligibleTriggerItems = triggerCartItems
          .where(
            (item) => isBogoTriggerEligible(
              triggerProduct: trigger,
              offer: offer,
              selectedVariantId: item.variantId,
            ),
          )
          .toList();
      if (eligibleTriggerItems.isNotEmpty) {
        continue;
      }

      final ineligibleTriggerItems = triggerCartItems
          .where(
            (item) => !isBogoTriggerEligible(
              triggerProduct: trigger,
              offer: offer,
              selectedVariantId: item.variantId,
            ),
          )
          .toList();

      if (ineligibleTriggerItems.isNotEmpty) {
        final currentItem = ineligibleTriggerItems.first;
        final currentVariant = _resolveVariant(trigger, currentItem.variantId);
        if (currentVariant == null) continue;

        final eligibleVariants = eligibleBogoTriggerVariants(trigger, offer)
            .where((variant) => variant.variantId != currentVariant.variantId)
            .toList();
        if (eligibleVariants.isEmpty) continue;

        final currentSize = _normalizeQuantity(currentVariant);
        eligibleVariants.sort((a, b) {
          final aDelta = (_normalizeQuantity(a) - currentSize).abs();
          final bDelta = (_normalizeQuantity(b) - currentSize).abs();
          final sizeCompare = aDelta.compareTo(bDelta);
          if (sizeCompare != 0) return sizeCompare;
          return a.price.compareTo(b.price);
        });
        final targetVariant = eligibleVariants.first;
        final quantity = currentItem.quantity.clamp(1, 99999);
        final variantDiscount =
            math.max(0.0, targetVariant.realPrice - targetVariant.price) *
            quantity;
        final freeBenefit = (bestFreeProduct?.price ?? 0) * quantity;
        final benefit = variantDiscount + freeBenefit;
        final extraSpend =
            math.max(0.0, targetVariant.price - currentVariant.price) *
            quantity;

        final action = BasketSuggestionAction(
          type: 'bogo',
          label: 'BOGO Upgrade',
          ctaLabel: 'Upgrade & Unlock',
          payload: {
            'productId': offer.triggerProductId,
            'variantId': targetVariant.variantId,
            'currentVariantId': currentVariant.variantId,
            'mode': 'bogo_upgrade',
            if (bestFreeProduct?.productId != null)
              'freeProductId': bestFreeProduct!.productId!,
          },
          productId: offer.triggerProductId,
          variantId: targetVariant.variantId,
          benefit: benefit,
          extraSpend: extraSpend,
        );

        results.add(
          _Scored(
            extraSpend: extraSpend,
            totalBenefit: benefit,
            score: _scoreFromComponents(
              type: 'bogo',
              conversionProbability: 38,
              userRelevance: 32,
              profitImpact: (benefit * 1.2).clamp(10, 30).toDouble(),
              urgency: extraSpend <= 50 ? 22 : 16,
            ),
            suggestion: BasketSuggestion(
              title:
                  'Upgrade ${_formatVariantLabel(currentVariant)} to ${_formatVariantLabel(targetVariant)}',
              subtitle:
                  'Unlock FREE ${bestFreeProduct?.productName ?? 'gift'} with this pack switch',
              message:
                  'Switch ${trigger.productName} from ${_formatVariantLabel(currentVariant)} to ${_formatVariantLabel(targetVariant)} and unlock FREE ${bestFreeProduct?.productName ?? 'gift'}',
              type: 'bogo',
              priority: 0,
              actions: [action],
              savingAmount: benefit,
              thumbnailUrl: trigger.imageUrl,
              productId: trigger.productId,
              variantId: targetVariant.variantId,
              metadata: {
                'mode': 'bogo_upgrade',
                'currentVariantLabel': _formatVariantLabel(currentVariant),
                'targetVariantLabel': _formatVariantLabel(targetVariant),
                'curLabel': _formatVariantLabel(currentVariant),
                'curPrice': currentVariant.price.toStringAsFixed(0),
                'vLabel': _formatVariantLabel(targetVariant),
                'vPrice': targetVariant.price.toStringAsFixed(0),
                if (bestFreeProduct?.productName != null)
                  'freeProductName': bestFreeProduct!.productName,
              },
            ),
          ),
        );
        continue;
      }

      final action = BasketSuggestionAction(
        type: 'bogo',
        label: 'Buy 1 Get 1 Free',
        ctaLabel: 'Add to Cart',
        payload: {
          'productId': offer.triggerProductId,
          if (offer.triggerVariantId != null)
            'variantId': offer.triggerVariantId!,
          if (bestFreeProduct?.productId != null)
            'freeProductId': bestFreeProduct!.productId!,
        },
        productId: offer.triggerProductId,
        variantId: offer.triggerVariantId,
        benefit: baseBenefit,
        extraSpend: trigger.price,
      );

      results.add(
        _Scored(
          extraSpend: trigger.price,
          totalBenefit: baseBenefit,
          score: _scoreFromComponents(
            type: 'bogo',
            conversionProbability: 28,
            userRelevance: 18,
            profitImpact: (baseBenefit * 1.3).clamp(10, 28).toDouble(),
            urgency: 10,
          ),
          suggestion: BasketSuggestion(
            message: 'Get a free product with ${trigger.productName}',
            type: 'single',
            priority: 0,
            actions: [action],
            savingAmount: baseBenefit,
            thumbnailUrl: trigger.imageUrl,
            productId: trigger.productId,
            variantId: offer.triggerVariantId,
          ),
        ),
      );
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

      final pricing = _computeComboPricing(combo, productMap);
      if (pricing.comboTotal <= 0 || pricing.savings <= 0) continue;

      final action = BasketSuggestionAction(
        type: 'combo',
        label: 'Add ${combo.name}',
        ctaLabel: 'Add Combo',
        payload: {
          'comboId': combo.comboId ?? combo.name,
        },
        comboId: combo.comboId,
        benefit: pricing.savings,
        extraSpend: pricing.comboTotal,
      );

      final comboImageUrls = combo.comboProducts
          .map((cp) => productMap[cp.productId]?.imageUrl)
          .whereType<String>()
          .take(4)
          .join(',');

      results.add(
        _Scored(
          extraSpend: pricing.comboTotal,
          totalBenefit: pricing.savings,
          score: _scoreFromComponents(
            type: 'combo',
            conversionProbability: 34,
            userRelevance: 22,
            profitImpact: (pricing.savings * 1.2).clamp(10, 28).toDouble(),
            urgency: pricing.comboTotal <= 50 ? 14 : 8,
          ),
          suggestion: BasketSuggestion(
            message:
                'Get ${combo.name} for ₹${pricing.comboTotal.toStringAsFixed(0)} and save ₹${pricing.savings.toStringAsFixed(0)}',
            type: 'combo',
            priority: 0,
            actions: [action],
            savingAmount: pricing.savings,
            comboId: combo.comboId,
            thumbnailUrl:
                productMap[combo.comboProducts.first.productId]?.imageUrl,
            metadata: {
              'comboImageUrls': comboImageUrls,
            },
          ),
        ),
      );
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

      final variants = (product.variants ?? [])
          .where((v) => v.isAvailable)
          .toList();
      if (variants.length < 2) continue;

      final current = _resolveVariant(product, item.variantId);
      if (current == null) continue;
      final curNorm = _normalizeQuantity(current);
      if (curNorm <= 0) continue;
      final curUp = current.price / curNorm;

      // Sort variants by quantity — pick ONLY the next immediate larger one
      final sortedVariants = [
        ...variants,
      ]..sort((a, b) => _normalizeQuantity(a).compareTo(_normalizeQuantity(b)));

      ProductVariant? nextVariant;
      for (final v in sortedVariants) {
        if (v.variantId == current.variantId) continue;
        final vNorm = _normalizeQuantity(v);
        if (vNorm <= curNorm) continue;
        final vUp = v.price / vNorm;
        if (vUp >= curUp) continue;
        nextVariant = v; // take the first (smallest next) better-value variant
        break;
      }

      if (nextVariant == null) continue;

      final v = nextVariant;
      final vNorm = _normalizeQuantity(v);
      final projectedSavings = (curUp * vNorm) - v.price;
      final extraSpend = math.max(0.0, v.price - current.price).toDouble();

      final action = BasketSuggestionAction(
        type: 'variant',
        label: 'Upgrade to ${_formatVariantLabel(v)}',
        ctaLabel: 'Upgrade',
        payload: {
          'productId': product.productId ?? '',
          'variantId': v.variantId,
        },
        productId: product.productId,
        variantId: v.variantId,
        benefit: projectedSavings,
        extraSpend: extraSpend,
      );

      results.add(
        _Scored(
          extraSpend: extraSpend,
          totalBenefit: projectedSavings,
          score: _scoreFromComponents(
            type: 'product',
            conversionProbability: 30,
            userRelevance: 26,
            profitImpact: (projectedSavings * 1.3).clamp(8, 26).toDouble(),
            urgency: extraSpend <= 20 ? 12 : 6,
          ),
          suggestion: BasketSuggestion(
            message:
                'Upgrade to ${_formatVariantLabel(v)} & save ₹${projectedSavings.toStringAsFixed(0)}',
            type: 'variant',
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
        ),
      );
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Free delivery product suggestions
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreFreeDeliveryProducts({
    required List<CartItemInput> cartItems,
    required List<Product> freeDeliveryProducts,
    required double cartTotal,
    required DeliveryConfig deliveryConfig,
  }) {
    final results = <_Scored>[];
    final cartProductIds = cartItems.map((item) => item.productId).toSet();

    double currentFee = deliveryConfig.baseDeliveryFee;
    for (final slab in deliveryConfig.slabs) {
      if (cartTotal >= slab.minOrderAmount &&
          cartTotal <= slab.maxOrderAmount) {
        currentFee = slab.fee;
        break;
      }
    }

    if (currentFee <= 0) return results;

    final seen = <String, Product>{};
    for (final p in freeDeliveryProducts) {
      if (p.productId == null) continue;
      final existing = seen[p.productId!];
      if (existing == null || p.price < existing.price) {
        seen[p.productId!] = p;
      }
    }
    final uniqueProducts = seen.values.toList();

    for (final product in uniqueProducts) {
      if (product.productId == null) continue;

      final variant = (product.variants ?? [])
          .where((v) => v.isAvailable)
          .toList()
          .firstOrNull;
      final effectiveVariant =
          variant ??
          ProductVariant(
            variantId: product.productId!,
            price: product.price,
            realPrice: product.price,
            quantityValue: 1,
            quantityUnit: 'piece',
            isAvailable: true,
          );

      if (cartProductIds.contains(product.productId)) continue;

      final savings = currentFee;
      final action = BasketSuggestionAction(
        type: 'product',
        label: 'FREE DELIVERY',
        ctaLabel: 'Add',
        payload: {
          'productId': product.productId ?? '',
          'variantId': effectiveVariant.variantId,
        },
        productId: product.productId,
        variantId: effectiveVariant.variantId,
        benefit: savings,
        extraSpend: effectiveVariant.price,
      );

      final score = _scoreFromComponents(
        type: 'product',
        conversionProbability: 32,
        userRelevance: 22,
        profitImpact: (savings * 1.5).clamp(8, 22).toDouble(),
        urgency: 18,
      );

      results.add(
        _Scored(
          extraSpend: effectiveVariant.price,
          totalBenefit: savings,
          score: score,
          suggestion: BasketSuggestion(
            title: product.productName,
            subtitle: 'Free delivery with this product',
            message: 'Add ${product.productName} for free delivery',
            type: 'product',
            priority: 0,
            actions: [action],
            savingAmount: savings,
            thumbnailUrl: product.imageUrl,
            productId: product.productId,
          ),
        ),
      );
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Combination generator
  // ─────────────────────────────────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────────────────────
  // Scorer: Shop More, Get More
  // ─────────────────────────────────────────────────────────────────────────
  static List<_Scored> _scoreSmgmSuggestions({
    required List<CartItemInput> cartItems,
    required List<ShopMoreGetMoreOffer> smgmOffers,
    required double cartTotal,
    required Map<String, Product> productMap,
  }) {
    if (smgmOffers.isEmpty) return const [];

    final results = <_Scored>[];
    final activeOffers = smgmOffers
        .where((o) => o.isActive)
        .toList()
      ..sort((a, b) => b.minimumOrderAmount.compareTo(a.minimumOrderAmount));

    // Find the best unlocked reward (highest threshold ≤ cart total)
    ShopMoreGetMoreOffer? unlockedReward;
    for (final offer in activeOffers) {
      if (cartTotal >= offer.minimumOrderAmount) {
        unlockedReward = offer;
        break;
      }
    }

    // Find the next unlockable reward (nearest lowest threshold)
    ShopMoreGetMoreOffer? nextTier;
    for (final offer in activeOffers.reversed) {
      if (cartTotal < offer.minimumOrderAmount) {
        nextTier = offer;
        break;
      }
    }

    // Check if the unlocked reward product is already in cart
    final cartProductIds = cartItems.map((item) => item.productId).toSet();
    final rewardAlreadyInCart = unlockedReward != null &&
        cartProductIds.contains(unlockedReward.freeProductId);

    // B. Not yet at threshold — suggest next tier
    if (nextTier != null) {
      final remaining = nextTier.minimumOrderAmount - cartTotal;
      final rewardProduct = productMap[nextTier.freeProductId];
      final rewardPrice = rewardProduct?.price ?? 0;
      final action = _primaryAction(
        type: 'product',
        label: 'Unlock Free Gift',
        ctaLabel: 'Add ₹${remaining.toStringAsFixed(0)} more',
        productId: nextTier.freeProductId,
        variantId: nextTier.freeVariantId,
        benefit: rewardPrice,
        extraSpend: remaining,
      );
      results.add(
        _Scored(
          extraSpend: remaining,
          totalBenefit: rewardPrice,
          score: _scoreFromComponents(
            type: 'smgm_reward',
            conversionProbability: 35,
            userRelevance: 26,
            profitImpact: (rewardPrice * 1.8).clamp(10, 30),
            urgency: remaining <= 50 ? 24 : 16,
          ),
          suggestion: BasketSuggestion(
            message:
                'Add ₹${remaining.toStringAsFixed(0)} more for FREE ${rewardProduct?.productName ?? "gift"}',
            type: 'smgm_reward',
            priority: 0,
            actions: [action],
            progressCurrent: cartTotal,
            progressTarget: nextTier.minimumOrderAmount,
            progressRemaining: remaining,
            savingAmount: rewardPrice,
            thumbnailUrl: rewardProduct?.imageUrl,
            metadata: {'quantity': rewardProduct?.quantity ?? ''},
          ),
        ),
      );

      // C. Higher tier suggestion (next after already unlocked)
      if (unlockedReward != null && rewardAlreadyInCart) {
        final nextRemaining = nextTier.minimumOrderAmount - cartTotal;
        final nextProduct = productMap[nextTier.freeProductId];
        final nextPrice = nextProduct?.price ?? 0;
        final nextAction = _primaryAction(
          type: 'product',
          label: 'Next Reward',
          ctaLabel: 'Spend ₹${nextRemaining.toStringAsFixed(0)} more',
          productId: nextTier.freeProductId,
          variantId: nextTier.freeVariantId,
          benefit: nextPrice,
          extraSpend: nextRemaining,
        );
        results.add(
          _Scored(
            extraSpend: nextRemaining,
            totalBenefit: nextPrice,
            score: _scoreFromComponents(
              type: 'smgm_reward',
              conversionProbability: 28,
              userRelevance: 22,
              profitImpact: (nextPrice * 1.8).clamp(10, 30),
              urgency: nextRemaining <= 50 ? 20 : 14,
            ),
            suggestion: BasketSuggestion(
              message:
                  'Next reward: FREE ${nextProduct?.productName ?? "gift"} at ₹${nextTier.minimumOrderAmount.toStringAsFixed(0)}',
              type: 'smgm_reward',
              priority: 0,
              actions: [nextAction],
              progressCurrent: cartTotal,
              progressTarget: nextTier.minimumOrderAmount,
              progressRemaining: nextRemaining,
              savingAmount: nextPrice,
              thumbnailUrl: nextProduct?.imageUrl,
              metadata: {'quantity': nextProduct?.quantity ?? ''},
            ),
          ),
        );
      }
    }

    // D. Empty cart / low cart — general "start unlocking" suggestion
    if (cartTotal <= 0 && activeOffers.isNotEmpty) {
      final firstTier = activeOffers.last;
      final rewardProduct = productMap[firstTier.freeProductId];
      results.add(
        _Scored(
          extraSpend: firstTier.minimumOrderAmount,
          totalBenefit: rewardProduct?.price ?? 0,
          score: _scoreFromComponents(
            type: 'smgm_reward',
            conversionProbability: 24,
            userRelevance: 18,
            profitImpact: (rewardProduct?.price ?? 0 * 1.5).clamp(8, 22),
            urgency: 12,
          ),
          suggestion: BasketSuggestion(
            message:
                'Shop for ₹${firstTier.minimumOrderAmount.toStringAsFixed(0)} to unlock a free gift!',
            type: 'smgm_reward',
            priority: 0,
            actions: [
              _primaryAction(
                type: 'product',
                label: 'Start Shopping',
                ctaLabel: 'Browse',
                benefit: rewardProduct?.price ?? 0,
                extraSpend: firstTier.minimumOrderAmount,
              ),
            ],
            progressTarget: firstTier.minimumOrderAmount,
            savingAmount: rewardProduct?.price ?? 0,
            thumbnailUrl: rewardProduct?.imageUrl,
            metadata: {'quantity': rewardProduct?.quantity ?? ''},
          ),
        ),
      );
    }

    return results;
  }

  static List<_Scored> _buildCombinations({
    required double cartTotal,
    required List<Coupon> coupons,
    required String? appliedCouponCode,
    required List<_Scored> variantScored,
    required List<_Scored> comboScored,
    required List<_Scored> bogoScored,
    required _Scored? deliveryScored,
    required Set<_Scored> upgradedBaseItems,
  }) {
    final combos = <_Scored>[];

    // A. Variant + Coupon / Delivery
    for (final v in variantScored) {
      final combined = _stackWithThresholds(
        cartTotal: cartTotal,
        coupons: coupons,
        appliedCouponCode: appliedCouponCode,
        base: v,
        deliveryScored: deliveryScored,
        messagePrefix: 'Upgrade pack',
        conversionProbability: 40,
        userRelevance: 28,
        urgency: 18,
      );
      if (combined != null) {
        combos.add(combined);
        upgradedBaseItems.add(v);
      }
    }

    // B. Combo + Coupon / Delivery
    for (final c in comboScored) {
      final combined = _stackWithThresholds(
        cartTotal: cartTotal,
        coupons: coupons,
        appliedCouponCode: appliedCouponCode,
        base: c,
        deliveryScored: deliveryScored,
        messagePrefix: 'Add combo',
        conversionProbability: 42,
        userRelevance: 26,
        urgency: 18,
      );
      if (combined != null) {
        combos.add(combined);
        upgradedBaseItems.add(c);
      }
    }

    // C. BOGO + Coupon / Delivery
    for (final b in bogoScored) {
      if (_isBogoUpgradeScored(b)) continue;
      final combined = _stackWithThresholds(
        cartTotal: cartTotal,
        coupons: coupons,
        appliedCouponCode: appliedCouponCode,
        base: b,
        deliveryScored: deliveryScored,
        messagePrefix: 'Grab the BOGO deal',
        conversionProbability: b.extraSpend <= 0 ? 46 : 38,
        userRelevance: b.extraSpend <= 0 ? 30 : 24,
        urgency: b.extraSpend <= 75 ? 22 : 16,
      );
      if (combined != null) {
        combos.add(combined);
        upgradedBaseItems.add(b);
      }
    }

    // D. BOGO + Combo (+ best one of Coupon / Delivery)
    final bestCombo = _bestScoredByValue(comboScored);
    final bestBogo = _bestScoredByValue(
      bogoScored.where((item) => !_isBogoUpgradeScored(item)).toList(),
    );
    if (bestCombo != null && bestBogo != null) {
      final dual = _buildDualOfferCombination(
        cartTotal: cartTotal,
        coupons: coupons,
        appliedCouponCode: appliedCouponCode,
        combo: bestCombo,
        bogo: bestBogo,
        deliveryScored: deliveryScored,
      );
      if (dual != null) {
        combos.add(dual);
        upgradedBaseItems.add(bestCombo);
        upgradedBaseItems.add(bestBogo);
      }
    }

    return combos;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns true if any cart item is a product with [isFreeDelivery] = true.
  /// Uses [productMap] to find the product detail from the cart items.
  static bool _hasCartFreeDeliveryProduct(
    List<CartItemInput> cartItems,
    Map<String, Product> productMap,
  ) {
    if (cartItems.isEmpty) return false;
    return cartItems.any((item) {
      final product = productMap[item.productId];
      return product != null && product.isFreeDelivery;
    });
  }

  static Future<DeliveryConfig> _getDeliveryConfig(Session session) async {
    if (_cachedDeliveryConfig != null &&
        _cachedDeliveryConfigAt != null &&
        DateTime.now().difference(_cachedDeliveryConfigAt!) < _cacheTtl) {
      return _cachedDeliveryConfig!;
    }
    final config = await DeliveryEngine.getDeliveryConfig(session);
    _cachedDeliveryConfig = config;
    _cachedDeliveryConfigAt = DateTime.now();
    return config;
  }

  static Future<List<Coupon>> _getCoupons(Session session) async {
    if (_cachedCoupons != null &&
        _cachedCouponsAt != null &&
        DateTime.now().difference(_cachedCouponsAt!) < _cacheTtl) {
      return _cachedCoupons!;
    }
    final coupons = await _couponService.fetchCoupons(
      session,
      activeOnly: true,
    );
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

  static Future<List<ShopMoreGetMoreOffer>> _getSmgmOffers(
    Session session,
  ) async {
    if (_cachedSmgmOffers != null &&
        _cachedSmgmAt != null &&
        DateTime.now().difference(_cachedSmgmAt!) < _cacheTtl) {
      return _cachedSmgmOffers!;
    }
    final offers =
        await ShopMoreGetMoreEndpoint().getActiveOffers(session);
    _cachedSmgmOffers = offers;
    _cachedSmgmAt = DateTime.now();
    return offers;
  }

  static ProductVariant? _resolveVariant(Product product, String? variantId) {
    final variants = product.variants ?? [];
    if (variants.isEmpty) return null;
    if (variantId == null) return variants.first;
    return _firstWhereOrNull(variants, (v) => v.variantId == variantId) ??
        variants.first;
  }

  static double _normalizeQuantity(ProductVariant variant) {
    final val = variant.quantityValue;
    final unit = variant.quantityUnit.toLowerCase().trim();
    if (unit == 'kg' || unit == 'l') return val * 1000;
    return val;
  }

  static String _formatVariantLabel(ProductVariant variant) {
    final value = variant.quantityValue;
    final amount = value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return '$amount${variant.quantityUnit}';
  }

  static Product? _bestBogoFreeProduct(
    BogoOffer offer,
    Map<String, Product> productMap,
  ) {
    Product? best;
    for (final freeProductId in offer.freeProductIds) {
      final product = productMap[freeProductId];
      if (product == null) continue;
      if (best == null || product.price > best.price) {
        best = product;
      }
    }
    return best;
  }

  static bool _isBogoUpgradeScored(_Scored scored) {
    return scored.suggestion.type == 'bogo' &&
        scored.suggestion.metadata?['mode'] == 'bogo_upgrade';
  }

  static double _comboItemSellingPrice(Product product, String? variantId) {
    if (variantId == null || variantId.trim().isEmpty) {
      return product.price;
    }
    final variant = _firstWhereOrNull(
      product.variants ?? const <ProductVariant>[],
      (item) => item.variantId == variantId,
    );
    return variant?.price ?? product.price;
  }

  static _ComboPricingSnapshot _computeComboPricing(
    ComboOffer combo,
    Map<String, Product> productMap,
  ) {
    var sellingTotal = 0.0;
    for (final item in combo.comboProducts) {
      final product = productMap[item.productId];
      if (product == null) continue;
      sellingTotal +=
          _comboItemSellingPrice(product, item.variantId) * item.quantity;
    }

    final comboTotal =
        (combo.discountType == 'percentage'
                ? (sellingTotal * (1 - (combo.discountValue / 100))).clamp(
                    0,
                    double.infinity,
                  )
                : (sellingTotal - combo.discountValue).clamp(
                    0,
                    double.infinity,
                  ))
            .toDouble();
    final savings = (sellingTotal - comboTotal)
        .clamp(0, double.infinity)
        .toDouble();
    return _ComboPricingSnapshot(
      sellingTotal: sellingTotal,
      comboTotal: comboTotal,
      savings: savings,
    );
  }
}
