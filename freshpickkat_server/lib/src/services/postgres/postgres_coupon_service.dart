import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../dependency_checker.dart';
import 'postgres_product_compat_service.dart';
import 'postgres_support.dart';

class PostgresCouponService {
  PostgresCouponService({PostgresProductCompatService? products})
    : _products = products ?? PostgresProductCompatService();

  final PostgresProductCompatService _products;

  Future<List<Coupon>> getInactiveCoupons(Session session) async {
    final rows = await CouponRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.code,
      orderDescending: false,
    );
    return _hydrateCoupons(session, rows);
  }

  Future<List<Coupon>> fetchCoupons(
    Session session, {
    bool activeOnly = false,
  }) async {
    final rows = await CouponRow.db.find(
      session,
      where: activeOnly ? (t) => t.status.equals('active') : null,
      orderBy: (t) => t.code,
      orderDescending: false,
    );
    return _hydrateCoupons(session, rows);
  }

  Future<Coupon?> fetchCouponByCode(
    Session session,
    String couponCode, {
    bool includeInactive = false,
  }) async {
    final normalizedCode = couponCode.trim().toUpperCase();
    if (normalizedCode.isEmpty) return null;

    final row = await CouponRow.db.findFirstRow(
      session,
      where: (t) => includeInactive
          ? t.code.equals(normalizedCode)
          : t.code.equals(normalizedCode) & t.status.equals('active'),
    );
    if (row == null) return null;

    final hydrated = await _hydrateCoupons(session, [row]);
    return hydrated.isEmpty ? null : hydrated.first;
  }

  Future<bool> uploadCoupon(Session session, Coupon coupon) async {
    final normalizedCode = coupon.code.trim().toUpperCase();
    if (normalizedCode.isEmpty) {
      throw Exception('Coupon code is required.');
    }

    return session.db.transaction<bool>((transaction) async {
      final existing = await CouponRow.db.findFirstRow(
        session,
        where: (t) => t.code.equals(normalizedCode),
        transaction: transaction,
      );
      if (existing != null) {
        throw Exception('Coupon code already exists.');
      }

      final now = DateTime.now().toUtc();
      final inserted = await CouponRow.db.insertRow(
        session,
        CouponRow(
          code: normalizedCode,
          description: cleanNullableString(coupon.description),
          couponType: _resolveCouponType(coupon),
          couponCategory: cleanNullableString(coupon.couponCategory) ?? 'All',
          discountValue: coupon.discountValue,
          minOrderAmount: coupon.minOrderAmount,
          maxDiscountAmount: coupon.maxDiscountAmount ?? coupon.maxDiscount,
          maxUsageTotal: coupon.usageLimit,
          maxUsagePerUser: null,
          loyaltyRequiredOrders: coupon.loyaltyRequiredOrders,
          usedCount: coupon.usedCount,
          startsAt: coupon.startDate.toUtc(),
          endsAt: _resolveCouponExpiry(coupon).toUtc(),
          status: coupon.isActive ? 'active' : 'inactive',
          deactivatedAt: coupon.isActive ? null : now,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await _syncProductScopes(
        session,
        couponId: inserted.id!,
        productIds: coupon.productIds ?? const <String>[],
        transaction: transaction,
      );
      return true;
    });
  }

  Future<bool> updateCoupon(Session session, Coupon coupon) async {
    final normalizedCode = coupon.code.trim().toUpperCase();
    if (normalizedCode.isEmpty) {
      throw Exception('Coupon code is required.');
    }

    return session.db.transaction<bool>((transaction) async {
      final existing = await CouponRow.db.findFirstRow(
        session,
        where: (t) => t.code.equals(normalizedCode),
        transaction: transaction,
      );
      if (existing == null) {
        throw Exception('Coupon not found.');
      }

      final now = DateTime.now().toUtc();
      await CouponRow.db.updateRow(
        session,
        existing.copyWith(
          description: cleanNullableString(coupon.description),
          couponType: _resolveCouponType(coupon),
          couponCategory: cleanNullableString(coupon.couponCategory) ?? 'All',
          discountValue: coupon.discountValue,
          minOrderAmount: coupon.minOrderAmount,
          maxDiscountAmount: coupon.maxDiscountAmount ?? coupon.maxDiscount,
          maxUsageTotal: coupon.usageLimit,
          maxUsagePerUser: existing.maxUsagePerUser,
          loyaltyRequiredOrders: coupon.loyaltyRequiredOrders,
          usedCount: coupon.usedCount,
          startsAt: coupon.startDate.toUtc(),
          endsAt: _resolveCouponExpiry(coupon).toUtc(),
          status: coupon.isActive ? 'active' : 'inactive',
          deactivatedAt: coupon.isActive ? null : now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await _syncProductScopes(
        session,
        couponId: existing.id!,
        productIds: coupon.productIds ?? const <String>[],
        transaction: transaction,
      );
      return true;
    });
  }

  Future<bool> setCouponActive(
    Session session,
    String code,
    bool isActive,
  ) async {
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode.isEmpty) return false;

    final existing = await CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalizedCode),
    );
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await CouponRow.db.updateRow(
      session,
      existing.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<String> deleteCoupon(Session session, String code) async {
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode.isEmpty) return 'Invalid coupon code';

    final row = await CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalizedCode),
    );
    if (row == null) return 'Coupon not found';

    final refs = await DependencyChecker.checkCoupon(session, row.id!);
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    final now = DateTime.now().toUtc();
    await CouponRow.db.updateRow(
      session,
      row.copyWith(
        status: 'inactive',
        deactivatedAt: now,
        updatedAt: now,
      ),
    );
    return '';
  }

  Future<CouponValidationResult> applyCoupon(
    Session session, {
    required String userId,
    required String couponCode,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupon = await fetchCouponByCode(session, couponCode);
    if (coupon == null) {
      return CouponValidationResult(
        isValid: false,
        couponCode: couponCode.trim().toUpperCase(),
        errorMessage: 'Invalid coupon code',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    final evaluation = await _evaluateCoupon(
      session,
      coupon: coupon,
      userId: userId,
      cartSubtotal: cartSubtotal,
      cartItems: cartItems,
    );

    return CouponValidationResult(
      isValid: evaluation.isApplicable,
      couponCode: coupon.code,
      couponId: coupon.id,
      couponType: _resolveCouponType(coupon),
      errorMessage: evaluation.reason,
      discountAmount: evaluation.discountAmount,
      isDeliveryDiscount: false,
    );
  }

  Future<List<CouponDisplay>> getAvailableCoupons(
    Session session, {
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupons = await fetchCoupons(session, activeOnly: false);
    if (coupons.isEmpty) return const [];

    final evaluations = await _evaluateCoupons(
      session,
      coupons: coupons,
      userId: userId,
      cartSubtotal: cartSubtotal,
      cartItems: cartItems,
    );

    final bestCoupon = _pickBestCoupon(evaluations);
    return evaluations
        .map(
          (evaluation) => _toCouponDisplay(
            evaluation,
            isBest: bestCoupon?.coupon.code == evaluation.coupon.code,
          ),
        )
        .toList();
  }

  Future<BestCouponResult> getBestCoupon(
    Session session, {
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupons = await fetchCoupons(session, activeOnly: false);
    if (coupons.isEmpty) {
      return BestCouponResult(bestCouponCode: null, discountAmount: 0);
    }

    final evaluations = await _evaluateCoupons(
      session,
      coupons: coupons,
      userId: userId,
      cartSubtotal: cartSubtotal,
      cartItems: cartItems,
    );
    final bestCoupon = _pickBestCoupon(evaluations);
    return BestCouponResult(
      bestCouponCode: bestCoupon?.coupon.code,
      discountAmount: bestCoupon?.discountAmount ?? 0,
    );
  }

  Future<void> incrementCouponUsage(
    Session session,
    String couponCode, {
    Transaction? transaction,
  }) async {
    final normalizedCode = couponCode.trim().toUpperCase();
    if (normalizedCode.isEmpty) return;

    final row = await CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalizedCode),
      transaction: transaction,
    );
    if (row == null) return;

    await CouponRow.db.updateRow(
      session,
      row.copyWith(
        usedCount: row.usedCount + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  Future<List<Coupon>> _hydrateCoupons(
    Session session,
    List<CouponRow> rows,
  ) async {
    if (rows.isEmpty) return const [];

    final couponIds = rows.map((row) => row.id!).toSet();
    final scopes = await CouponProductScopeRow.db.find(
      session,
      where: (t) => t.couponId.inSet(couponIds),
    );
    final scopeProductIdsByCoupon = <String, List<String>>{};
    for (final scope in scopes) {
      scopeProductIdsByCoupon
          .putIfAbsent(scope.couponId.toString(), () => [])
          .add(scope.productId.toString());
    }

    return rows
        .map(
          (row) => Coupon(
            id: row.id!.toString(),
            code: row.code,
            description: row.description ?? '',
            type: row.couponType,
            discountValue: row.discountValue,
            minOrderAmount: row.minOrderAmount,
            maxDiscount: row.maxDiscountAmount,
            maxDiscountAmount: row.maxDiscountAmount,
            productIds: scopeProductIdsByCoupon[row.id!.toString()],
            loyaltyRequiredOrders: row.loyaltyRequiredOrders,
            startDate: row.startsAt,
            endDate: row.endsAt,
            expiryDate: row.endsAt,
            usageLimit: row.maxUsageTotal,
            usedCount: row.usedCount,
            isActive: row.status == 'active',
            couponCategory: row.couponCategory,
          ),
        )
        .toList();
  }

  Future<void> _syncProductScopes(
    Session session, {
    required UuidValue couponId,
    required List<String> productIds,
    required Transaction transaction,
  }) async {
    final desiredIds = productIds
        .map(tryParseUuid)
        .whereType<UuidValue>()
        .toSet();

    final existing = await CouponProductScopeRow.db.find(
      session,
      where: (t) => t.couponId.equals(couponId),
      transaction: transaction,
    );
    final existingByProductId = {
      for (final row in existing) row.productId.toString(): row,
    };

    final toDelete = existing.where(
      (row) => !desiredIds.contains(row.productId),
    );
    if (toDelete.isNotEmpty) {
      await CouponProductScopeRow.db.delete(
        session,
        toDelete.toList(),
        transaction: transaction,
      );
    }

    for (final productId in desiredIds) {
      if (existingByProductId.containsKey(productId.toString())) continue;
      await CouponProductScopeRow.db.insertRow(
        session,
        CouponProductScopeRow(
          couponId: couponId,
          productId: productId,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    }
  }

  Future<List<_CouponEvaluation>> _evaluateCoupons(
    Session session, {
    required List<Coupon> coupons,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final products = await _fetchProducts(session, cartItems);
    final completedOrdersCount = await _getCompletedOrdersCount(session, userId);

    final results = <_CouponEvaluation>[];
    for (final coupon in coupons) {
      final userCouponUsageCount = await _countUserCouponUsage(
        session,
        userId,
        coupon.id ?? '',
      );
      results.add(_evaluateCouponWithContext(
        coupon: coupon,
        userId: userId,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
        products: products,
        completedOrdersCount: completedOrdersCount,
        userCouponUsageCount: userCouponUsageCount,
      ));
    }
    return results;
  }

  Future<_CouponEvaluation> _evaluateCoupon(
    Session session, {
    required Coupon coupon,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final products = await _fetchProducts(session, cartItems);
    final completedOrdersCount = await _getCompletedOrdersCount(session, userId);
    final userCouponUsageCount = await _countUserCouponUsage(
      session,
      userId,
      coupon.id ?? '',
    );
    return _evaluateCouponWithContext(
      coupon: coupon,
      userId: userId,
      cartSubtotal: cartSubtotal,
      cartItems: cartItems,
      products: products,
      completedOrdersCount: completedOrdersCount,
      userCouponUsageCount: userCouponUsageCount,
    );
  }

  _CouponEvaluation _evaluateCouponWithContext({
    required Coupon coupon,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
    required Map<String, Product> products,
    required int completedOrdersCount,
    int userCouponUsageCount = 0,
  }) {
    final now = DateTime.now().toUtc();
    final normalizedSubtotal = cartSubtotal < 0 ? 0.0 : cartSubtotal;
    final couponType = _resolveCouponType(coupon);
    final expiryDate = (coupon.expiryDate ?? coupon.endDate).toUtc();
    final startDate = coupon.startDate.toUtc();

    if (coupon.code.trim().isEmpty) {
      return _CouponEvaluation.notApplicable(coupon, 'Invalid coupon code');
    }
    if (!coupon.isActive) {
      return _CouponEvaluation.notApplicable(coupon, 'Coupon is inactive');
    }
    if (now.isBefore(startDate)) {
      return _CouponEvaluation.notApplicable(
        coupon,
        'Coupon is not active yet',
      );
    }
    if (now.isAfter(expiryDate)) {
      return _CouponEvaluation.notApplicable(coupon, 'Coupon has expired');
    }
    if (coupon.usageLimit != null && coupon.usedCount >= coupon.usageLimit!) {
      return _CouponEvaluation.notApplicable(
        coupon,
        'Coupon usage limit has been reached',
      );
    }
    if (normalizedSubtotal < coupon.minOrderAmount) {
      return _CouponEvaluation.notApplicable(
        coupon,
        'Minimum order amount is ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
      );
    }
    if ((couponType == 'FIRST_ORDER' || couponType == 'LOYALTY') &&
        userId.trim().isEmpty) {
      return _CouponEvaluation.notApplicable(coupon, 'Login required');
    }
    if (couponType == 'FIRST_ORDER' && completedOrdersCount > 0) {
      return _CouponEvaluation.notApplicable(coupon, 'Not first order');
    }
    if (couponType == 'LOYALTY') {
      final requiredOrders = coupon.loyaltyRequiredOrders ?? 0;
      if (completedOrdersCount < requiredOrders) {
        return _CouponEvaluation.notApplicable(
          coupon,
          'Requires $requiredOrders completed orders',
        );
      }
    }

    if (userCouponUsageCount > 0) {
      return _CouponEvaluation.notApplicable(
        coupon,
        'Coupon already used',
        code: 'USED',
      );
    }

    var eligibleSubtotal = normalizedSubtotal;
    if (couponType == 'PRODUCT_BASED') {
      eligibleSubtotal = _calculateEligibleProductSubtotal(
        coupon: coupon,
        cartItems: cartItems,
        products: products,
      );
      if (eligibleSubtotal <= 0) {
        return _CouponEvaluation.notApplicable(
          coupon,
          'Eligible products are not in the cart',
        );
      }
    }

    final discountAmount = _calculateDiscountAmount(
      coupon: coupon,
      couponType: couponType,
      eligibleSubtotal: eligibleSubtotal,
    );
    if (discountAmount <= 0) {
      return _CouponEvaluation.notApplicable(coupon, 'Coupon does not apply');
    }

    return _CouponEvaluation.applicable(coupon, discountAmount);
  }

  Future<Map<String, Product>> _fetchProducts(
    Session session,
    List<CartItemInput> cartItems,
  ) async {
    final productIds = cartItems.map((item) => item.productId).toSet().toList();
    if (productIds.isEmpty) return const {};

    final hydrated = await _products.getProductsByIds(session, productIds);
    return {
      for (final product in hydrated)
        if (product.productId != null) product.productId!: product,
    };
  }

  Future<int> _getCompletedOrdersCount(Session session, String userId) async {
    final normalized = userId.trim();
    if (normalized.isEmpty) return 0;

    AppUserRow? appUser;
    final parsedId = tryParseUuid(normalized);
    if (parsedId != null) {
      appUser = await AppUserRow.db.findById(session, parsedId);
    }
    appUser ??= await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(normalized),
    );
    if (appUser?.id == null) return 0;

    return CustomerOrderRow.db.count(
      session,
      where: (t) =>
          t.userId.equals(appUser!.id!) & t.orderStatus.equals('delivered'),
    );
  }

  Future<int> _countUserCouponUsage(
    Session session,
    String userId,
    String couponId,
  ) async {
    final normalized = userId.trim();
    if (normalized.isEmpty) return 0;

    AppUserRow? appUser;
    final parsedId = tryParseUuid(normalized);
    if (parsedId != null) {
      appUser = await AppUserRow.db.findById(session, parsedId);
    }
    appUser ??= await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(normalized),
    );
    if (appUser?.id == null) return 0;

    final parsedCouponId = tryParseUuid(couponId);
    if (parsedCouponId == null) return 0;

    return CustomerOrderRow.db.count(
      session,
      where: (t) =>
          t.userId.equals(appUser!.id!) &
          t.couponId.equals(parsedCouponId) &
          t.paymentStatus.equals('paid'),
    );
  }

  CouponDisplay _toCouponDisplay(
    _CouponEvaluation evaluation, {
    required bool isBest,
  }) {
    final coupon = evaluation.coupon;
    return CouponDisplay(
      id: coupon.id,
      code: coupon.code,
      description: coupon.description,
      type: _resolveCouponType(coupon),
      couponCategory: coupon.couponCategory,
      minOrderAmount: coupon.minOrderAmount,
      maxDiscount: coupon.maxDiscountAmount ?? coupon.maxDiscount,
      maxDiscountAmount: coupon.maxDiscountAmount ?? coupon.maxDiscount,
      discountValue: coupon.discountValue,
      isDeliveryDiscount: false,
      isApplicable: evaluation.isApplicable,
      status: evaluation.isApplicable
          ? 'applicable'
          : (evaluation.notApplicableCode ?? 'not_applicable'),
      reason: evaluation.reason,
      discountAmount: evaluation.discountAmount,
      isBest: isBest,
    );
  }

  _CouponEvaluation? _pickBestCoupon(List<_CouponEvaluation> evaluations) {
    _CouponEvaluation? best;
    for (final evaluation in evaluations) {
      if (!evaluation.isApplicable || evaluation.discountAmount <= 0) continue;
      if (best == null || evaluation.discountAmount > best.discountAmount) {
        best = evaluation;
      }
    }
    return best;
  }

  double _calculateEligibleProductSubtotal({
    required Coupon coupon,
    required List<CartItemInput> cartItems,
    required Map<String, Product> products,
  }) {
    final eligibleIds = (coupon.productIds ?? const <String>[])
        .where((value) => value.trim().isNotEmpty)
        .toSet();
    if (eligibleIds.isEmpty) return 0;

    var subtotal = 0.0;
    for (final item in cartItems) {
      if (!eligibleIds.contains(item.productId)) continue;
      final product = products[item.productId];
      if (product == null) continue;
      subtotal += _resolveItemPrice(product, item.variantId) * item.quantity;
    }
    return subtotal;
  }

  double _calculateDiscountAmount({
    required Coupon coupon,
    required String couponType,
    required double eligibleSubtotal,
  }) {
    if (eligibleSubtotal <= 0) return 0;

    final normalizedDiscountType = _resolveDiscountType(couponType);
    final maxDiscount = coupon.maxDiscountAmount ?? coupon.maxDiscount;
    var discount = 0.0;

    if (normalizedDiscountType == 'percentage') {
      final percent = coupon.discountValue ?? 0;
      discount = eligibleSubtotal * (percent / 100);
      if (maxDiscount != null && discount > maxDiscount) {
        discount = maxDiscount;
      }
    } else {
      discount = coupon.discountValue ?? 0;
    }

    if (discount < 0) return 0;
    if (discount > eligibleSubtotal) return eligibleSubtotal;
    return discount;
  }

  double _resolveItemPrice(Product product, String? variantId) {
    if (variantId != null &&
        variantId.trim().isNotEmpty &&
        product.variants != null) {
      for (final variant in product.variants!) {
        if (variant.variantId == variantId) {
          return variant.price;
        }
      }
    }
    return product.price;
  }

  String _resolveDiscountType(String couponType) {
    return couponType == 'PERCENTAGE_DISCOUNT' ? 'percentage' : 'flat';
  }

  String _resolveCouponType(Coupon coupon) {
    final explicitType = coupon.type?.trim();
    if (explicitType != null && explicitType.isNotEmpty) {
      return explicitType.toUpperCase();
    }
    return 'FLAT_DISCOUNT';
  }

  DateTime _resolveCouponExpiry(Coupon coupon) {
    return (coupon.expiryDate ?? coupon.endDate);
  }
}

class _CouponEvaluation {
  _CouponEvaluation({
    required this.coupon,
    required this.isApplicable,
    required this.discountAmount,
    required this.reason,
    this.notApplicableCode,
  });

  factory _CouponEvaluation.applicable(Coupon coupon, double discountAmount) {
    return _CouponEvaluation(
      coupon: coupon,
      isApplicable: true,
      discountAmount: discountAmount,
      reason: null,
    );
  }

  factory _CouponEvaluation.notApplicable(
    Coupon coupon,
    String reason, {
    String? code,
  }) {
    return _CouponEvaluation(
      coupon: coupon,
      isApplicable: false,
      discountAmount: 0,
      reason: reason,
      notApplicableCode: code,
    );
  }

  final Coupon coupon;
  final bool isApplicable;
  final double discountAmount;
  final String? reason;
  final String? notApplicableCode;
}
