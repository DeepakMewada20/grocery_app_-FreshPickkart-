import 'dart:math' as math;
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import '../../endpoints/bogo_endpoint.dart';
import '../../endpoints/category_endpoint.dart';
import '../../endpoints/combo_offer_endpoint.dart';
import '../../endpoints/product_endpoint.dart';
import '../../generated/protocol.dart';
import '../firebase_service.dart';
import '../coupon_service.dart';
import '../delivery/delivery_engine.dart';
import '../orders/order_document_mapper.dart';

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
    List<CartItemInput>? items,
    double? cartTotal,
    String mode = 'cart',
    String? userId,
    String? appliedCouponCode,
  }) async {
    final normalizedItems = (items ?? const <CartItemInput>[])
        .where((item) => item.productId.trim().isNotEmpty && item.quantity > 0)
        .toList();

    final effectiveMode =
        mode == 'empty' || normalizedItems.isEmpty ? 'empty' : 'cart';
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

    final deliveryConfig = await _getDeliveryConfig();
    final coupons = await _getCoupons();
    final bogoOffers = await _getBogoOffers(session);

    // ── 2. Build all individual scored suggestions ──────────────────────────
    final scored = <_Scored>[];

    final deliveryScored = _scoreDelivery(
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

    // ── 3. Build combination suggestions ────────────────────────────────────
    final upgradedBaseItems = <_Scored>{};
    final combinations = _buildCombinations(
      cartTotal: cartTotal ?? 0,
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
      _getDeliveryConfig(),
      _getCoupons(),
      normalizedUserId == null || normalizedUserId.isEmpty
          ? Future.value(const <Order>[])
          : _getRecentOrders(session, normalizedUserId),
    ]);

    final bestSellers = futures[0] as List<Product>;
    final trending = futures[1] as List<Product>;
    final categories = futures[2] as List<Category>;
    final bogoOffers = futures[3] as List<BogoOffer>;
    final comboOffers = futures[4] as List<ComboOffer>;
    final deliveryConfig = futures[5] as DeliveryConfig;
    final coupons = futures[6] as List<Coupon>;
    final recentOrders = futures[7] as List<Order>;

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

  static BasketSuggestionResult _finalizeResults(List<_Scored> scored) {
    final results = <BasketSuggestion>[];
    for (var i = 0; i < scored.length && results.length < 5; i++) {
      final item = scored[i];
      final isBest = i == 0;
      final action = item.suggestion.action ??
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
          ? results.skip(1).take(4).toList(growable: false)
          : const [],
      suggestions: results.toList(growable: false),
    );
  }

  static String _buildSuggestionId(BasketSuggestion suggestion, int index) {
    final action = suggestion.action ??
        (suggestion.actions?.isNotEmpty == true ? suggestion.actions!.first : null);
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
      'product' => 8.0,
      'category' => 5.0,
      _ => 0.0,
    };
    return typeBias + conversionProbability + userRelevance + profitImpact + urgency;
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
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/freshpickkart-a6824/databases/(default)/documents';
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'orders')],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'userId'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: userId),
        ),
      ),
      limit: 10,
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final mapper = OrderDocumentMapper();
      final orders = <Order>[];
      for (final res in response) {
        if (res.document?.fields == null) continue;
        orders.add(
          mapper.fromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
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

    return entries.take(5).map((entry) {
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
        conversionProbability: 38 + (entry.value * 6).clamp(0, 24).toDouble(),
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
    }).whereType<_Scored>().toList();
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
      if (appliedCouponCode?.toUpperCase() == coupon.code.toUpperCase()) continue;
      final expiry = (coupon.expiryDate ?? coupon.endDate).toUtc();
      if (now.isAfter(expiry)) continue;
      if (best == null) {
        best = coupon;
        continue;
      }
      final bestValue = (best.discountValue ?? 0);
      final candidateValue = (coupon.discountValue ?? 0);
      if (candidateValue > bestValue ||
          (candidateValue == bestValue && coupon.minOrderAmount < best.minOrderAmount)) {
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
    final nextMilestone = config.slabs
        .where((slab) => slab.fee == 0)
        .fold<DeliverySlab?>(null, (best, slab) {
          if (best == null || slab.minOrderAmount < best.minOrderAmount) {
            return slab;
          }
          return best;
        }) ??
        config.slabs.first;

    final remaining = nextMilestone.minOrderAmount;
    final savings = currentFee - nextMilestone.fee;
    final action = _primaryAction(
      type: 'navigate',
      label: 'Shop for free delivery',
      ctaLabel: 'Explore',
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
        message: 'Free delivery above ₹${nextMilestone.minOrderAmount.toStringAsFixed(0)}',
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

    final topProduct = availableProducts.isNotEmpty ? availableProducts.first : null;
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
    if (bogo.isNotEmpty) {
      final offer = bogo.first;
      final trigger = productMap[offer.triggerProductId];
      if (trigger != null) {
        final action = _primaryAction(
          type: 'add_to_cart',
          label: 'Get ${trigger.productName}',
          ctaLabel: 'Add Item',
          payload: {
            'productId': trigger.productId ?? '',
            if (offer.triggerVariantId != null) 'variantId': offer.triggerVariantId!,
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
    if (combo.isNotEmpty) {
      final offer = combo.first;
      final comboId = offer.comboId ?? offer.name;
      final comboLeadProduct = offer.comboProducts.isNotEmpty
          ? productMap[offer.comboProducts.first.productId]
          : null;
      if (comboLeadProduct != null) {
        final savings = offer.discountType == 'percentage'
            ? comboLeadProduct.price * (offer.discountValue / 100)
            : offer.discountValue;
        final action = _primaryAction(
          type: 'navigate',
          label: 'View ${offer.name}',
          ctaLabel: 'View Combo',
          payload: {'comboId': comboId},
          comboId: comboId,
          benefit: savings,
        );
        final score = _scoreFromComponents(
          type: 'combo',
          conversionProbability: 30,
          userRelevance: 18,
          profitImpact: (savings / 2).clamp(8, 20).toDouble(),
          urgency: 14,
        );
        scored.add(
          _Scored(
            extraSpend: comboLeadProduct.price,
            totalBenefit: savings,
            score: score,
            suggestion: _buildSuggestion(
              id: 'combo:$comboId',
              type: 'combo',
              title: offer.name,
              subtitle: 'Bundle deal',
              message: 'Save ₹${savings.toStringAsFixed(0)} with ${offer.name}',
              priority: 3,
              action: action,
              score: score,
              comboId: comboId,
              thumbnailUrl: comboLeadProduct.imageUrl,
              savingAmount: savings,
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

    final sortedCategories = categories
        .where((category) => category.categoryName.trim().isNotEmpty)
        .toList()
      ..sort((a, b) {
        final countA = counts[a.categoryName] ?? 0;
        final countB = counts[b.categoryName] ?? 0;
        final countCompare = countB.compareTo(countA);
        if (countCompare != 0) return countCompare;
        return a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase());
      });

    return sortedCategories.take(2).map((category) {
      final productHint = productPool.firstWhereOrNull(
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
    final comboOffer = offers.firstWhereOrNull(
      (entry) => entry.suggestion.type == 'combo',
    );
    if (coupon == null && delivery == null && comboOffer == null) {
      return const [];
    }

    final actions = <BasketSuggestionAction>[
      if (comboOffer?.suggestion.action != null) comboOffer!.suggestion.action!,
      if (coupon?.suggestion.action != null) coupon!.suggestion.action!,
      if (delivery?.suggestion.action != null) delivery!.suggestion.action!,
    ];
    if (actions.isEmpty) return const [];

    final totalBenefit =
        (coupon?.totalBenefit ?? 0) +
        (delivery?.totalBenefit ?? 0) +
        (comboOffer?.totalBenefit ?? 0);
    final score = _scoreFromComponents(
      type: 'combined',
      conversionProbability: 40,
      userRelevance: 28,
      profitImpact: (totalBenefit / 2).clamp(12, 28).toDouble(),
      urgency: 18,
    );

    final primaryAction = actions.first;
    return [
      _Scored(
        extraSpend: [
          coupon?.extraSpend ?? 0,
          delivery?.extraSpend ?? 0,
          comboOffer?.extraSpend ?? 0,
        ].reduce(math.max),
        totalBenefit: totalBenefit,
        score: score,
        suggestion: _buildSuggestion(
          id: 'combined:${actions.map((a) => a.type).join('+')}',
          type: 'combined',
          title: 'Stacked savings',
          subtitle: 'Coupon + offer combo',
          message: 'Stack a coupon with the strongest live offer',
          priority: 1,
          action: primaryAction,
          actions: actions,
          score: score,
          savingAmount: totalBenefit,
        ),
      ),
    ];
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
        payload: {
          'productId': offer.triggerProductId,
          if (offer.triggerVariantId != null) 'variantId': offer.triggerVariantId!,
        },
        productId: offer.triggerProductId,
        variantId: offer.triggerVariantId,
        benefit: benefit,
        extraSpend: extraSpend,
      );

      results.add(_Scored(
        extraSpend: extraSpend,
        totalBenefit: benefit,
        score: _scoreFromComponents(
          type: 'bogo',
          conversionProbability: triggerInCart ? 42 : 28,
          userRelevance: triggerInCart ? 24 : 18,
          profitImpact: (benefit * 1.3).clamp(10, 28).toDouble(),
          urgency: triggerInCart ? 14 : 10,
        ),
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
        payload: {
          'comboId': combo.comboId ?? combo.name,
        },
        comboId: combo.comboId,
        benefit: savings,
        extraSpend: extraSpend,
      );

      results.add(_Scored(
        extraSpend: extraSpend,
        totalBenefit: savings,
        score: _scoreFromComponents(
          type: 'combo',
          conversionProbability: 34,
          userRelevance: 22,
          profitImpact: (savings * 1.2).clamp(10, 28).toDouble(),
          urgency: extraSpend <= 50 ? 14 : 8,
        ),
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
          payload: {
            'productId': product.productId ?? '',
            'variantId': v.variantId,
          },
          productId: product.productId,
          variantId: v.variantId,
          benefit: projectedSavings,
          extraSpend: extraSpend,
        );

        results.add(_Scored(
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
          payload: {
            'couponCode': cUnlocked.code,
          },
          couponCode: cUnlocked.code,
          benefit: cUnlocked.discountValue,
          extraSpend: 0,
        ),
      ];

      combos.add(_Scored(
        extraSpend: v.extraSpend,
        totalBenefit: benefit,
        score: _scoreFromComponents(
          type: 'combined',
          conversionProbability: 40,
          userRelevance: 28,
          profitImpact: (benefit * 1.2).clamp(14, 32).toDouble(),
          urgency: 18,
        ),
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
          payload: {
            'couponCode': cUnlocked.code,
          },
          couponCode: cUnlocked.code,
          benefit: cUnlocked.discountValue,
          extraSpend: 0,
        ),
      ];

      combos.add(_Scored(
        extraSpend: c.extraSpend,
        totalBenefit: benefit,
        score: _scoreFromComponents(
          type: 'combined',
          conversionProbability: 42,
          userRelevance: 26,
          profitImpact: (benefit * 1.2).clamp(14, 32).toDouble(),
          urgency: 18,
        ),
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
            score: _scoreFromComponents(
              type: 'combined',
              conversionProbability: 44,
              userRelevance: 28,
              profitImpact: (benefit * 1.1).clamp(16, 34).toDouble(),
              urgency: 20,
            ),
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
