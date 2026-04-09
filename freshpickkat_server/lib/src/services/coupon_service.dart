import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../generated/protocol.dart';
import 'firebase_service.dart';

class CouponService {
  static const String _projectId = 'freshpickkart-a6824';
  static const String _database =
      'projects/$_projectId/databases/(default)/documents';
  static const String _couponCollection = 'coupons';
  static const String _userCollection = 'users';
  static const String _orderCollection = 'orders';

  static Future<List<Coupon>> fetchCoupons({bool activeOnly = false}) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: _couponCollection),
        ],
        where: activeOnly
            ? firestore_api.Filter(
                fieldFilter: firestore_api.FieldFilter(
                  field: firestore_api.FieldReference(fieldPath: 'isActive'),
                  op: 'EQUAL',
                  value: firestore_api.Value(booleanValue: true),
                ),
              )
            : null,
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      final coupons = <Coupon>[];
      for (final item in response) {
        final document = item.document;
        if (document?.fields == null) continue;
        coupons.add(_couponFromDocument(document!));
      }
      return coupons;
    } catch (_) {
      return [];
    }
  }

  static Future<Coupon?> fetchCouponByCode(String couponCode) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: _couponCollection),
        ],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'code'),
            op: 'EQUAL',
            value: firestore_api.Value(stringValue: couponCode.toUpperCase()),
          ),
        ),
        limit: 1,
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      for (final item in response) {
        final document = item.document;
        if (document?.fields == null) continue;
        return _couponFromDocument(document!);
      }
    } catch (_) {}
    return null;
  }

  static Future<CouponValidationResult> applyCoupon({
    required String userId,
    required String couponCode,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupon = await fetchCouponByCode(couponCode);
    if (coupon == null) {
      return CouponValidationResult(
        isValid: false,
        couponCode: couponCode.toUpperCase(),
        errorMessage: 'Invalid coupon code',
        discountAmount: 0,
        isDeliveryDiscount: false,
      );
    }

    final evaluation = await _evaluateCoupon(
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

  static Future<List<CouponDisplay>> getAvailableCoupons({
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupons = await fetchCoupons(activeOnly: false);
    if (coupons.isEmpty) return [];

    final evaluations = await _evaluateCoupons(
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

  static Future<BestCouponResult> getBestCoupon({
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final coupons = await fetchCoupons(activeOnly: false);
    if (coupons.isEmpty) {
      return BestCouponResult(bestCouponCode: null, discountAmount: 0);
    }

    final evaluations = await _evaluateCoupons(
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

  static Future<void> incrementCouponUsage(String couponCode) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: _couponCollection)],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'code'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: couponCode.toUpperCase()),
        ),
      ),
      limit: 1,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      _database,
    );

    for (final item in response) {
      final document = item.document;
      if (document?.fields == null || document?.name == null) continue;
      final coupon = _couponFromDocument(document!);
      final nextUsedCount = coupon.usedCount + 1;
      await firestore.projects.databases.documents.patch(
        firestore_api.Document(
          fields: {
            'usedCount': firestore_api.Value(
              integerValue: nextUsedCount.toString(),
            ),
          },
        ),
        document.name!,
        updateMask_fieldPaths: ['usedCount'],
      );
      break;
    }
  }

  static Map<String, firestore_api.Value> toFirestoreFields(Coupon coupon) {
    final normalizedType = _resolveCouponType(coupon);
    final normalizedDiscountType = _resolveDiscountType(
      coupon,
      normalizedType,
    );
    final maxDiscount = (coupon.maxDiscountAmount ?? coupon.maxDiscount)
        ?.toDouble();
    final expiryDate = coupon.expiryDate ?? coupon.endDate;

    final fields = <String, firestore_api.Value>{
      'id': firestore_api.Value(stringValue: coupon.id ?? coupon.code),
      'code': firestore_api.Value(stringValue: coupon.code.toUpperCase()),
      'description': firestore_api.Value(stringValue: coupon.description),
      'type': firestore_api.Value(stringValue: normalizedType),
      'discountType': firestore_api.Value(stringValue: normalizedDiscountType),
      'discountValue': coupon.discountValue != null
          ? firestore_api.Value(doubleValue: coupon.discountValue)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'minOrderAmount': firestore_api.Value(
        doubleValue: coupon.minOrderAmount,
      ),
      'maxDiscount': maxDiscount != null
          ? firestore_api.Value(doubleValue: maxDiscount)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'maxDiscountAmount': maxDiscount != null
          ? firestore_api.Value(doubleValue: maxDiscount)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'startDate': firestore_api.Value(
        timestampValue: coupon.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: expiryDate.toUtc().toIso8601String(),
      ),
      'expiryDate': firestore_api.Value(
        timestampValue: expiryDate.toUtc().toIso8601String(),
      ),
      'usageLimit': coupon.usageLimit != null
          ? firestore_api.Value(integerValue: coupon.usageLimit.toString())
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'usedCount': firestore_api.Value(
        integerValue: coupon.usedCount.toString(),
      ),
      'isActive': firestore_api.Value(booleanValue: coupon.isActive),
      'couponCategory': firestore_api.Value(
        stringValue: coupon.couponCategory,
      ),
      'loyaltyRequiredOrders': coupon.loyaltyRequiredOrders != null
          ? firestore_api.Value(
              integerValue: coupon.loyaltyRequiredOrders.toString(),
            )
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'productIds': coupon.productIds != null
          ? firestore_api.Value(
              arrayValue: firestore_api.ArrayValue(
                values: coupon.productIds!
                    .map((value) => firestore_api.Value(stringValue: value))
                    .toList(),
              ),
            )
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
    };

    return fields;
  }

  static Coupon _couponFromDocument(firestore_api.Document document) {
    final fields = document.fields ?? const <String, firestore_api.Value>{};
    final documentId = document.name?.split('/').last;
    final maxDiscount = _getDouble(fields, 'maxDiscount');
    final maxDiscountAmount =
        _getDouble(fields, 'maxDiscountAmount') ?? maxDiscount;
    final endDate =
        _getDateTime(fields, 'expiryDate') ??
        _getDateTime(fields, 'endDate') ??
        DateTime.now().add(const Duration(days: 30));

    return Coupon(
      id: fields['id']?.stringValue ?? documentId,
      code: fields['code']?.stringValue ?? '',
      description: fields['description']?.stringValue ?? '',
      type: fields['type']?.stringValue,
      discountType: fields['discountType']?.stringValue,
      discountValue: _getDouble(fields, 'discountValue'),
      minOrderAmount: _getDouble(fields, 'minOrderAmount') ?? 0,
      maxDiscount: maxDiscountAmount,
      maxDiscountAmount: maxDiscountAmount,
      productIds: fields['productIds']?.arrayValue?.values
          ?.map((value) => value.stringValue ?? '')
          .where((value) => value.isNotEmpty)
          .toList(),
      loyaltyRequiredOrders: _getInt(fields, 'loyaltyRequiredOrders'),
      startDate:
          _getDateTime(fields, 'startDate') ??
          DateTime.now().subtract(const Duration(days: 1)),
      endDate: endDate,
      expiryDate: endDate,
      usageLimit: _getInt(fields, 'usageLimit'),
      usedCount: _getInt(fields, 'usedCount') ?? 0,
      isActive: fields['isActive']?.booleanValue ?? true,
      couponCategory: fields['couponCategory']?.stringValue ?? 'All',
    );
  }

  static CouponDisplay _toCouponDisplay(
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
      discountType: coupon.discountType,
      isDeliveryDiscount: false,
      isApplicable: evaluation.isApplicable,
      status: evaluation.isApplicable ? 'applicable' : 'not_applicable',
      reason: evaluation.reason,
      discountAmount: evaluation.discountAmount,
      isBest: isBest,
    );
  }

  static Future<List<_CouponEvaluation>> _evaluateCoupons({
    required List<Coupon> coupons,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final products = await _fetchProducts(cartItems);
    final completedOrdersCount = await _getCompletedOrdersCount(userId);

    final evaluations = <_CouponEvaluation>[];
    for (final coupon in coupons) {
      evaluations.add(
        _evaluateCouponWithContext(
          coupon: coupon,
          userId: userId,
          cartSubtotal: cartSubtotal,
          cartItems: cartItems,
          products: products,
          completedOrdersCount: completedOrdersCount,
        ),
      );
    }
    return evaluations;
  }

  static Future<_CouponEvaluation> _evaluateCoupon({
    required Coupon coupon,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
  }) async {
    final products = await _fetchProducts(cartItems);
    final completedOrdersCount = await _getCompletedOrdersCount(userId);
    return _evaluateCouponWithContext(
      coupon: coupon,
      userId: userId,
      cartSubtotal: cartSubtotal,
      cartItems: cartItems,
      products: products,
      completedOrdersCount: completedOrdersCount,
    );
  }

  static _CouponEvaluation _evaluateCouponWithContext({
    required Coupon coupon,
    required String userId,
    required double cartSubtotal,
    required List<CartItemInput> cartItems,
    required Map<String, Product> products,
    required int completedOrdersCount,
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

    double eligibleSubtotal = normalizedSubtotal;
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

  static _CouponEvaluation? _pickBestCoupon(
    List<_CouponEvaluation> evaluations,
  ) {
    _CouponEvaluation? best;
    for (final evaluation in evaluations) {
      if (!evaluation.isApplicable) continue;
      if (evaluation.discountAmount <= 0) continue;
      if (best == null || evaluation.discountAmount > best.discountAmount) {
        best = evaluation;
      }
    }
    return best;
  }

  static double _calculateEligibleProductSubtotal({
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

  static double _calculateDiscountAmount({
    required Coupon coupon,
    required String couponType,
    required double eligibleSubtotal,
  }) {
    if (eligibleSubtotal <= 0) return 0;

    final normalizedDiscountType = _resolveDiscountType(coupon, couponType);
    final maxDiscount = coupon.maxDiscountAmount ?? coupon.maxDiscount;
    double discount = 0;

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

  static String _resolveDiscountType(Coupon coupon, String couponType) {
    final explicitType = coupon.discountType?.toLowerCase().trim();
    if (explicitType == 'percentage' || explicitType == 'flat') {
      return explicitType!;
    }
    return couponType == 'PERCENTAGE_DISCOUNT' ? 'percentage' : 'flat';
  }

  static String _resolveCouponType(Coupon coupon) {
    final explicitType = coupon.type?.trim();
    if (explicitType != null && explicitType.isNotEmpty) {
      return explicitType.toUpperCase();
    }

    final discountType = coupon.discountType?.toLowerCase().trim();
    if ((coupon.productIds ?? const <String>[]).isNotEmpty) {
      return 'PRODUCT_BASED';
    }
    if ((coupon.loyaltyRequiredOrders ?? 0) > 0) {
      return 'LOYALTY';
    }
    if (discountType == 'percentage') {
      return 'PERCENTAGE_DISCOUNT';
    }
    return 'FLAT_DISCOUNT';
  }

  static Future<Map<String, Product>> _fetchProducts(
    List<CartItemInput> cartItems,
  ) async {
    final productIds = cartItems.map((item) => item.productId).toSet().toList();
    if (productIds.isEmpty) return {};

    final productMap = <String, Product>{};
    final firestore = await FirebaseService.getFirestoreClient();
    for (final productId in productIds) {
      try {
        final document = await firestore.projects.databases.documents.get(
          '$_database/Products/$productId',
        );
        if (document.fields == null) continue;
        productMap[productId] = _productFromFirestore(document.fields!);
      } catch (_) {}
    }
    return productMap;
  }

  static Future<int> _getCompletedOrdersCount(String userId) async {
    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty) return 0;

    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final userDocument = await firestore.projects.databases.documents.get(
        '$_database/$_userCollection/$normalizedUserId',
      );
      final count = _getInt(userDocument.fields ?? {}, 'completedOrdersCount');
      if (count != null) return count;
    } catch (_) {}

    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: _orderCollection),
        ],
        where: firestore_api.Filter(
          compositeFilter: firestore_api.CompositeFilter(
            op: 'AND',
            filters: [
              firestore_api.Filter(
                fieldFilter: firestore_api.FieldFilter(
                  field: firestore_api.FieldReference(fieldPath: 'userId'),
                  op: 'EQUAL',
                  value: firestore_api.Value(stringValue: normalizedUserId),
                ),
              ),
              firestore_api.Filter(
                fieldFilter: firestore_api.FieldFilter(
                  field: firestore_api.FieldReference(fieldPath: 'status'),
                  op: 'EQUAL',
                  value: firestore_api.Value(stringValue: 'delivered'),
                ),
              ),
            ],
          ),
        ),
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      var count = 0;
      for (final item in response) {
        if (item.document != null) count++;
      }
      return count;
    } catch (_) {
      return 0;
    }
  }

  static Product _productFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    final variants = <ProductVariant>[];
    final variantValues = fields['variants']?.arrayValue?.values;
    if (variantValues != null) {
      for (final value in variantValues) {
        final variantFields = value.mapValue?.fields;
        if (variantFields == null) continue;
        variants.add(
          ProductVariant(
            variantId: variantFields['variantId']?.stringValue ?? '',
            quantityValue: _getDouble(variantFields, 'quantityValue') ?? 0,
            quantityUnit: variantFields['quantityUnit']?.stringValue ?? '',
            quantityDescription:
                variantFields['quantityDescription']?.stringValue,
            price: _getDouble(variantFields, 'price') ?? 0,
            realPrice: _getDouble(variantFields, 'realPrice') ?? 0,
            isAvailable: variantFields['isAvailable']?.booleanValue ?? true,
            sortOrder: _getInt(variantFields, 'sortOrder'),
          ),
        );
      }
    }

    return Product(
      productId: fields['productId']?.stringValue,
      productName: fields['productName']?.stringValue ?? '',
      category: fields['category']?.stringValue ?? '',
      imageUrl: fields['imageUrl']?.stringValue ?? '',
      price: _getDouble(fields, 'price') ?? 0,
      realPrice: _getDouble(fields, 'realPrice') ?? 0,
      discount: _getDouble(fields, 'discount') ?? 0,
      discountType: fields['discountType']?.stringValue,
      discountValue: _getDouble(fields, 'discountValue'),
      isAvailable: fields['isAvailable']?.booleanValue ?? true,
      addedAt:
          _getDateTime(fields, 'addedAt') ??
          DateTime.now().subtract(const Duration(days: 1)),
      subcategory:
          fields['subcategory']?.arrayValue?.values
              ?.map((value) => value.stringValue ?? '')
              .where((value) => value.isNotEmpty)
              .toList() ??
          const <String>[],
      quantity: fields['quantity']?.stringValue ?? '',
      baseUnit: fields['baseUnit']?.stringValue,
      baseQuantity: _getDouble(fields, 'baseQuantity'),
      quantityDescription: fields['quantityDescription']?.stringValue,
      countryOfOrigin: fields['countryOfOrigin']?.stringValue,
      searchKeywords: fields['searchKeywords']?.arrayValue?.values
          ?.map((value) => value.stringValue ?? '')
          .where((value) => value.isNotEmpty)
          .toList(),
      mostSearch: _getInt(fields, 'mostSearch') ?? 0,
      mostPurchases: _getInt(fields, 'mostPurchases') ?? 0,
      bogoFreeProductIds: fields['bogoFreeProductIds']?.arrayValue?.values
          ?.map((value) => value.stringValue ?? '')
          .where((value) => value.isNotEmpty)
          .toList(),
      variants: variants.isEmpty ? null : variants,
    );
  }

  static double _resolveItemPrice(Product product, String? variantId) {
    final normalizedVariantId = variantId?.trim();
    if (normalizedVariantId != null &&
        normalizedVariantId.isNotEmpty &&
        product.variants != null) {
      for (final variant in product.variants!) {
        if (variant.variantId == normalizedVariantId) {
          return variant.price;
        }
      }
    }
    return product.price;
  }

  static double? _getDouble(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    if (value == null) return null;
    if (value.doubleValue != null) return value.doubleValue;
    if (value.integerValue != null) {
      return double.tryParse(value.integerValue!);
    }
    if (value.stringValue != null && value.stringValue!.isNotEmpty) {
      return double.tryParse(value.stringValue!);
    }
    return null;
  }

  static int? _getInt(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    if (value == null) return null;
    if (value.integerValue != null) {
      return int.tryParse(value.integerValue!);
    }
    if (value.doubleValue != null) {
      return value.doubleValue!.round();
    }
    if (value.stringValue != null && value.stringValue!.isNotEmpty) {
      return int.tryParse(value.stringValue!);
    }
    return null;
  }

  static DateTime? _getDateTime(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    final raw = value?.timestampValue ?? value?.stringValue;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

class _CouponEvaluation {
  _CouponEvaluation({
    required this.coupon,
    required this.isApplicable,
    required this.discountAmount,
    this.reason,
  });

  factory _CouponEvaluation.applicable(Coupon coupon, double discountAmount) {
    return _CouponEvaluation(
      coupon: coupon,
      isApplicable: true,
      discountAmount: discountAmount,
    );
  }

  factory _CouponEvaluation.notApplicable(Coupon coupon, String reason) {
    return _CouponEvaluation(
      coupon: coupon,
      isApplicable: false,
      discountAmount: 0,
      reason: reason,
    );
  }

  final Coupon coupon;
  final bool isApplicable;
  final double discountAmount;
  final String? reason;
}
