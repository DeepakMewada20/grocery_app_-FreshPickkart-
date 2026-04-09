/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:freshpickkat_client/src/protocol/admin_auth_result.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i4;
import 'package:freshpickkat_client/src/protocol/admin_dashboard_stats.dart'
    as _i5;
import 'package:freshpickkat_client/src/protocol/admin_analytics.dart' as _i6;
import 'package:freshpickkat_client/src/protocol/admin_audit_log_entry.dart'
    as _i7;
import 'package:freshpickkat_client/src/protocol/banner.dart' as _i8;
import 'package:freshpickkat_client/src/protocol/banner_page.dart' as _i9;
import 'package:freshpickkat_client/src/protocol/bogo_offer.dart' as _i10;
import 'package:freshpickkat_client/src/protocol/bogo_offer_page.dart' as _i11;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i12;
import 'package:freshpickkat_client/src/protocol/category_offer.dart' as _i13;
import 'package:freshpickkat_client/src/protocol/category_offer_page.dart'
    as _i14;
import 'package:freshpickkat_client/src/protocol/combo_offer.dart' as _i15;
import 'package:freshpickkat_client/src/protocol/combo_offer_page.dart' as _i16;
import 'package:freshpickkat_client/src/protocol/cart_item_input.dart' as _i17;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i18;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i19;
import 'package:freshpickkat_client/src/protocol/coupon_validation_result.dart'
    as _i20;
import 'package:freshpickkat_client/src/protocol/best_coupon_result.dart'
    as _i21;
import 'package:freshpickkat_client/src/protocol/free_delivery_rule.dart'
    as _i22;
import 'package:freshpickkat_client/src/protocol/free_delivery_rule_page.dart'
    as _i23;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i24;
import 'package:freshpickkat_client/src/protocol/order_page.dart' as _i25;
import 'package:freshpickkat_client/src/protocol/payment_order_result.dart'
    as _i26;
import 'package:freshpickkat_client/src/protocol/payment_verify_result.dart'
    as _i27;
import 'package:freshpickkat_client/src/protocol/payment_action_result.dart'
    as _i28;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i29;
import 'package:freshpickkat_client/src/protocol/product_page.dart' as _i30;
import 'package:freshpickkat_client/src/protocol/refund_record.dart' as _i31;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i32;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i33;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i34;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i35;
import 'protocol.dart' as _i36;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<bool> isAdminSetupCompleted() => caller.callServerEndpoint<bool>(
    'admin',
    'isAdminSetupCompleted',
    {},
  );

  _i2.Future<String> resolveAdminLoginEmail(String usernameOrEmail) =>
      caller.callServerEndpoint<String>(
        'admin',
        'resolveAdminLoginEmail',
        {'usernameOrEmail': usernameOrEmail},
      );

  _i2.Future<_i3.AdminAuthResult> firebaseLogin(String idToken) =>
      caller.callServerEndpoint<_i3.AdminAuthResult>(
        'admin',
        'firebaseLogin',
        {'idToken': idToken},
      );

  _i2.Future<List<_i4.AppUser>> getAllUsers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i4.AppUser>>(
    'admin',
    'getAllUsers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i5.AdminDashboardStats> getDashboardStats(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i5.AdminDashboardStats>(
    'admin',
    'getDashboardStats',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i6.AdminAnalytics> getAnalytics(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i6.AdminAnalytics>(
    'admin',
    'getAnalytics',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i7.AdminAuditLogEntry>> getAuditLogs(
    String firebaseUid,
    String idToken, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i7.AdminAuditLogEntry>>(
    'admin',
    'getAuditLogs',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _i2.Future<bool> signOut(String uid) => caller.callServerEndpoint<bool>(
    'auth',
    'signOut',
    {'uid': uid},
  );
}

/// {@category Endpoint}
class EndpointBanner extends _i1.EndpointRef {
  EndpointBanner(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'banner';

  _i2.Future<List<_i8.Banner>> getBanners({
    String? screen,
    required bool activeOnly,
  }) => caller.callServerEndpoint<List<_i8.Banner>>(
    'banner',
    'getBanners',
    {
      'screen': screen,
      'activeOnly': activeOnly,
    },
  );

  _i2.Future<_i9.BannerPage> getBannersPage({
    required int limit,
    String? pageToken,
    required bool activeOnly,
    String? screen,
  }) => caller.callServerEndpoint<_i9.BannerPage>(
    'banner',
    'getBannersPage',
    {
      'limit': limit,
      'pageToken': pageToken,
      'activeOnly': activeOnly,
      'screen': screen,
    },
  );

  _i2.Future<_i8.Banner?> getBannerById(String bannerId) =>
      caller.callServerEndpoint<_i8.Banner?>(
        'banner',
        'getBannerById',
        {'bannerId': bannerId},
      );

  _i2.Future<_i8.Banner> createBanner(_i8.Banner banner) =>
      caller.callServerEndpoint<_i8.Banner>(
        'banner',
        'createBanner',
        {'banner': banner},
      );

  _i2.Future<_i8.Banner> updateBanner(_i8.Banner banner) =>
      caller.callServerEndpoint<_i8.Banner>(
        'banner',
        'updateBanner',
        {'banner': banner},
      );

  _i2.Future<void> deleteBanner(String bannerId) =>
      caller.callServerEndpoint<void>(
        'banner',
        'deleteBanner',
        {'bannerId': bannerId},
      );

  _i2.Future<void> toggleBannerActive(
    String bannerId,
    bool active,
  ) => caller.callServerEndpoint<void>(
    'banner',
    'toggleBannerActive',
    {
      'bannerId': bannerId,
      'active': active,
    },
  );

  _i2.Future<void> updateBannerPriority(
    String bannerId,
    int priority,
  ) => caller.callServerEndpoint<void>(
    'banner',
    'updateBannerPriority',
    {
      'bannerId': bannerId,
      'priority': priority,
    },
  );
}

/// {@category Endpoint}
class EndpointBogo extends _i1.EndpointRef {
  EndpointBogo(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'bogo';

  _i2.Future<bool> upsertOffer(_i10.BogoOffer offer) =>
      caller.callServerEndpoint<bool>(
        'bogo',
        'upsertOffer',
        {'offer': offer},
      );

  _i2.Future<bool> deleteOffer(String triggerProductId) =>
      caller.callServerEndpoint<bool>(
        'bogo',
        'deleteOffer',
        {'triggerProductId': triggerProductId},
      );

  _i2.Future<List<_i10.BogoOffer>> getAllOffers() =>
      caller.callServerEndpoint<List<_i10.BogoOffer>>(
        'bogo',
        'getAllOffers',
        {},
      );

  _i2.Future<_i11.BogoOfferPage> getOffersPage({
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i11.BogoOfferPage>(
    'bogo',
    'getOffersPage',
    {
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<List<_i10.BogoOffer>> getActiveOffers() =>
      caller.callServerEndpoint<List<_i10.BogoOffer>>(
        'bogo',
        'getActiveOffers',
        {},
      );

  _i2.Future<_i10.BogoOffer?> getOfferForProduct(String triggerProductId) =>
      caller.callServerEndpoint<_i10.BogoOffer?>(
        'bogo',
        'getOfferForProduct',
        {'triggerProductId': triggerProductId},
      );
}

/// {@category Endpoint}
class EndpointCategory extends _i1.EndpointRef {
  EndpointCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'category';

  _i2.Future<List<_i12.Category>> getCategories() =>
      caller.callServerEndpoint<List<_i12.Category>>(
        'category',
        'getCategories',
        {},
      );

  _i2.Future<bool> uploadCategory(
    _i12.Category category,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'category',
    'uploadCategory',
    {
      'category': category,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointCategoryOffer extends _i1.EndpointRef {
  EndpointCategoryOffer(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'categoryOffer';

  _i2.Future<bool> upsertCategoryOffer(
    _i13.CategoryOffer offer,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'categoryOffer',
    'upsertCategoryOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteCategoryOffer(
    String offerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'categoryOffer',
    'deleteCategoryOffer',
    {
      'offerId': offerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i13.CategoryOffer>> getActiveCategoryOffers() =>
      caller.callServerEndpoint<List<_i13.CategoryOffer>>(
        'categoryOffer',
        'getActiveCategoryOffers',
        {},
      );

  _i2.Future<List<_i13.CategoryOffer>> getAllCategoryOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i13.CategoryOffer>>(
    'categoryOffer',
    'getAllCategoryOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i14.CategoryOfferPage> getCategoryOffersPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i14.CategoryOfferPage>(
    'categoryOffer',
    'getCategoryOffersPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> setCategoryOfferActive(
    String offerId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'categoryOffer',
    'setCategoryOfferActive',
    {
      'offerId': offerId,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointComboOffer extends _i1.EndpointRef {
  EndpointComboOffer(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'comboOffer';

  _i2.Future<bool> upsertComboOffer(
    _i15.ComboOffer offer,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'comboOffer',
    'upsertComboOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteComboOffer(
    String comboId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'comboOffer',
    'deleteComboOffer',
    {
      'comboId': comboId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i15.ComboOffer>> getActiveComboOffers() =>
      caller.callServerEndpoint<List<_i15.ComboOffer>>(
        'comboOffer',
        'getActiveComboOffers',
        {},
      );

  _i2.Future<List<_i15.ComboOffer>> getAllComboOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i15.ComboOffer>>(
    'comboOffer',
    'getAllComboOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i16.ComboOfferPage> getComboOffersPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i16.ComboOfferPage>(
    'comboOffer',
    'getComboOffersPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> setComboOfferActive(
    String comboId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'comboOffer',
    'setComboOfferActive',
    {
      'comboId': comboId,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i15.ComboOffer>> checkApplicableCombos(
    List<_i17.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i15.ComboOffer>>(
    'comboOffer',
    'checkApplicableCombos',
    {'cartItems': cartItems},
  );
}

/// {@category Endpoint}
class EndpointCoupon extends _i1.EndpointRef {
  EndpointCoupon(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'coupon';

  /// Fetch coupons for admin panel.
  _i2.Future<List<_i18.Coupon>> fetchCoupons(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i18.Coupon>>(
    'coupon',
    'fetchCoupons',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  /// Upload a new coupon to Firestore
  _i2.Future<bool> uploadCoupon(
    _i18.Coupon coupon,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'coupon',
    'uploadCoupon',
    {
      'coupon': coupon,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> setCouponActive(
    String code,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'coupon',
    'setCouponActive',
    {
      'code': code,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> updateCoupon(
    _i18.Coupon coupon,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'coupon',
    'updateCoupon',
    {
      'coupon': coupon,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i19.CouponDisplay>> fetchApplicableCoupons(
    double orderAmount,
  ) => caller.callServerEndpoint<List<_i19.CouponDisplay>>(
    'coupon',
    'fetchApplicableCoupons',
    {'orderAmount': orderAmount},
  );

  _i2.Future<_i20.CouponValidationResult> validateCoupon(
    String couponCode,
    double orderAmount,
  ) => caller.callServerEndpoint<_i20.CouponValidationResult>(
    'coupon',
    'validateCoupon',
    {
      'couponCode': couponCode,
      'orderAmount': orderAmount,
    },
  );

  _i2.Future<_i20.CouponValidationResult> applyCoupon(
    String userId,
    String couponCode,
    double cartSubtotal,
    List<_i17.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i20.CouponValidationResult>(
    'coupon',
    'applyCoupon',
    {
      'userId': userId,
      'couponCode': couponCode,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<List<_i19.CouponDisplay>> getAvailableCoupons(
    String userId,
    double cartSubtotal,
    List<_i17.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i19.CouponDisplay>>(
    'coupon',
    'getAvailableCoupons',
    {
      'userId': userId,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<_i21.BestCouponResult> getBestCoupon(
    String userId,
    double cartSubtotal,
    List<_i17.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i21.BestCouponResult>(
    'coupon',
    'getBestCoupon',
    {
      'userId': userId,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );
}

/// {@category Endpoint}
class EndpointFreeDelivery extends _i1.EndpointRef {
  EndpointFreeDelivery(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'freeDelivery';

  _i2.Future<bool> upsertFreeDeliveryRule(
    _i22.FreeDeliveryRule rule,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'upsertFreeDeliveryRule',
    {
      'rule': rule,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteFreeDeliveryRule(
    String ruleId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'deleteFreeDeliveryRule',
    {
      'ruleId': ruleId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i22.FreeDeliveryRule>> getActiveFreeDeliveryRules() =>
      caller.callServerEndpoint<List<_i22.FreeDeliveryRule>>(
        'freeDelivery',
        'getActiveFreeDeliveryRules',
        {},
      );

  _i2.Future<List<_i22.FreeDeliveryRule>> getAllFreeDeliveryRules(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i22.FreeDeliveryRule>>(
    'freeDelivery',
    'getAllFreeDeliveryRules',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i23.FreeDeliveryRulePage> getFreeDeliveryRulesPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i23.FreeDeliveryRulePage>(
    'freeDelivery',
    'getFreeDeliveryRulesPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> setFreeDeliveryRuleActive(
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'setFreeDeliveryRuleActive',
    {
      'ruleId': ruleId,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<double> calculateDeliveryFee(
    double orderAmount,
    int itemCount,
    String? couponCode,
    String? userId,
  ) => caller.callServerEndpoint<double>(
    'freeDelivery',
    'calculateDeliveryFee',
    {
      'orderAmount': orderAmount,
      'itemCount': itemCount,
      'couponCode': couponCode,
      'userId': userId,
    },
  );
}

/// {@category Endpoint}
class EndpointOrder extends _i1.EndpointRef {
  EndpointOrder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'order';

  _i2.Future<String> createOrder(_i24.Order order) =>
      caller.callServerEndpoint<String>(
        'order',
        'createOrder',
        {'order': order},
      );

  _i2.Future<String> createPendingOrder(
    _i24.Order order,
    String idempotencyKey,
  ) => caller.callServerEndpoint<String>(
    'order',
    'createPendingOrder',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<List<_i24.Order>> getOrders({
    String? status,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<List<_i24.Order>>(
    'order',
    'getOrders',
    {
      'status': status,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i25.OrderPage> getOrdersPage({
    String? status,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i25.OrderPage>(
    'order',
    'getOrdersPage',
    {
      'status': status,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<int> getOrdersCount({
    String? status,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<int>(
    'order',
    'getOrdersCount',
    {
      'status': status,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i24.Order>> getTodayOrders(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i24.Order>>(
    'order',
    'getTodayOrders',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i24.Order>> getUserOrders(String userId) =>
      caller.callServerEndpoint<List<_i24.Order>>(
        'order',
        'getUserOrders',
        {'userId': userId},
      );

  _i2.Future<_i24.Order?> getOrderById(String orderId) =>
      caller.callServerEndpoint<_i24.Order?>(
        'order',
        'getOrderById',
        {'orderId': orderId},
      );

  _i2.Future<bool> updateOrderStatus(
    String orderId,
    String newStatus, {
    String? cancellationReason,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'updateOrderStatus',
    {
      'orderId': orderId,
      'newStatus': newStatus,
      'cancellationReason': cancellationReason,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> updatePaymentStatus(
    String orderId,
    String paymentStatus, {
    String? razorpayPaymentId,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'updatePaymentStatus',
    {
      'orderId': orderId,
      'paymentStatus': paymentStatus,
      'razorpayPaymentId': razorpayPaymentId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> confirmOrder(String orderId) =>
      caller.callServerEndpoint<bool>(
        'order',
        'confirmOrder',
        {'orderId': orderId},
      );

  _i2.Future<bool> cancelOrder(
    String orderId,
    String userId, {
    required String reason,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'cancelOrder',
    {
      'orderId': orderId,
      'userId': userId,
      'reason': reason,
    },
  );

  _i2.Future<bool> assignDeliveryPerson(
    String orderId,
    String deliveryPersonName,
    String deliveryPersonPhone,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'order',
    'assignDeliveryPerson',
    {
      'orderId': orderId,
      'deliveryPersonName': deliveryPersonName,
      'deliveryPersonPhone': deliveryPersonPhone,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<Map<String, dynamic>> getDashboardStats(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'order',
    'getDashboardStats',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointPayment extends _i1.EndpointRef {
  EndpointPayment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i2.Future<_i26.PaymentOrderResult> createPaymentOrder(
    String orderId,
    double amount,
    String customerPhone,
  ) => caller.callServerEndpoint<_i26.PaymentOrderResult>(
    'payment',
    'createPaymentOrder',
    {
      'orderId': orderId,
      'amount': amount,
      'customerPhone': customerPhone,
    },
  );

  _i2.Future<_i27.PaymentVerifyResult> verifyPayment(
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) => caller.callServerEndpoint<_i27.PaymentVerifyResult>(
    'payment',
    'verifyPayment',
    {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    },
  );

  _i2.Future<_i28.PaymentActionResult> markPaymentFailed(String orderId) =>
      caller.callServerEndpoint<_i28.PaymentActionResult>(
        'payment',
        'markPaymentFailed',
        {'orderId': orderId},
      );

  _i2.Future<_i28.PaymentActionResult> initiateRefund(
    String razorpayPaymentId,
    double amount,
  ) => caller.callServerEndpoint<_i28.PaymentActionResult>(
    'payment',
    'initiateRefund',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'amount': amount,
    },
  );

  _i2.Future<_i28.PaymentActionResult> getPaymentStatus(
    String razorpayPaymentId,
  ) => caller.callServerEndpoint<_i28.PaymentActionResult>(
    'payment',
    'getPaymentStatus',
    {'razorpayPaymentId': razorpayPaymentId},
  );

  _i2.Future<_i28.PaymentActionResult> recoverPendingPayments(
    String userId, {
    required int limit,
  }) => caller.callServerEndpoint<_i28.PaymentActionResult>(
    'payment',
    'recoverPendingPayments',
    {
      'userId': userId,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointPricing extends _i1.EndpointRef {
  EndpointPricing(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pricing';
}

/// {@category Endpoint}
class EndpointProduct extends _i1.EndpointRef {
  EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<List<_i29.Product>> getProductsByIds(List<String> productIds) =>
      caller.callServerEndpoint<List<_i29.Product>>(
        'product',
        'getProductsByIds',
        {'productIds': productIds},
      );

  _i2.Future<List<_i29.Product>> getProducts({
    required int limit,
    String? lastProductName,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<List<_i29.Product>>(
    'product',
    'getProducts',
    {
      'limit': limit,
      'lastProductName': lastProductName,
      'category': category,
      'subcategories': subcategories,
      'sortBy': sortBy,
    },
  );

  _i2.Future<_i30.ProductPage> getProductsPage({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<_i30.ProductPage>(
    'product',
    'getProductsPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
      'category': category,
      'subcategories': subcategories,
      'sortBy': sortBy,
    },
  );

  _i2.Future<int> getProductsCount({
    required String firebaseUid,
    required String idToken,
    String? category,
    List<String>? subcategories,
  }) => caller.callServerEndpoint<int>(
    'product',
    'getProductsCount',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'category': category,
      'subcategories': subcategories,
    },
  );

  /// Upload a product to Firestore 'Products' collection
  _i2.Future<String?> uploadProduct(
    _i29.Product product,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String?>(
    'product',
    'uploadProduct',
    {
      'product': product,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> updateProduct(
    _i29.Product product,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'product',
    'updateProduct',
    {
      'product': product,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteProduct(
    String productId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'product',
    'deleteProduct',
    {
      'productId': productId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<String>> getProductSuggestions(String query) =>
      caller.callServerEndpoint<List<String>>(
        'product',
        'getProductSuggestions',
        {'query': query},
      );

  _i2.Future<List<_i29.Product>> searchProducts(String query) =>
      caller.callServerEndpoint<List<_i29.Product>>(
        'product',
        'searchProducts',
        {'query': query},
      );

  _i2.Future<int> migrateProducts() => caller.callServerEndpoint<int>(
    'product',
    'migrateProducts',
    {},
  );

  /// Initialize mostSearch and mostPurchases fields for all products
  _i2.Future<int> initializeProductMetrics() => caller.callServerEndpoint<int>(
    'product',
    'initializeProductMetrics',
    {},
  );

  /// Increment the search count for a product
  _i2.Future<bool> incrementProductSearch(String productId) =>
      caller.callServerEndpoint<bool>(
        'product',
        'incrementProductSearch',
        {'productId': productId},
      );

  /// Increment the purchase count for a product
  _i2.Future<bool> incrementProductPurchase(String productId) =>
      caller.callServerEndpoint<bool>(
        'product',
        'incrementProductPurchase',
        {'productId': productId},
      );

  /// Seed all products with random test data (mostSearch & mostPurchases)
  /// Call this from wallet_screen to fill all products with random values (1-30)
  /// for testing that Trending and Best Sellers sections display correctly
  _i2.Future<int> seedProductMetricsForTesting() =>
      caller.callServerEndpoint<int>(
        'product',
        'seedProductMetricsForTesting',
        {},
      );
}

/// {@category Endpoint}
class EndpointRefund extends _i1.EndpointRef {
  EndpointRefund(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refund';

  _i2.Future<_i31.RefundRecord> initiateRefund(String orderId) =>
      caller.callServerEndpoint<_i31.RefundRecord>(
        'refund',
        'initiateRefund',
        {'orderId': orderId},
      );

  _i2.Future<_i31.RefundRecord?> getRefundStatus(String orderId) =>
      caller.callServerEndpoint<_i31.RefundRecord?>(
        'refund',
        'getRefundStatus',
        {'orderId': orderId},
      );
}

/// {@category Endpoint}
class EndpointSubCategory extends _i1.EndpointRef {
  EndpointSubCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subCategory';

  /// Fetch all subcategories from Firestore 'subCategories' collection
  _i2.Future<List<_i32.SubCategory>> getSubCategories() =>
      caller.callServerEndpoint<List<_i32.SubCategory>>(
        'subCategory',
        'getSubCategories',
        {},
      );

  /// Upload a subcategory to Firestore 'subCategories' collection
  _i2.Future<bool> uploadSubCategory(
    _i32.SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'subCategory',
    'uploadSubCategory',
    {
      'subCategory': subCategory,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i4.AppUser?> getUserByFirebaseUid(String uid) =>
      caller.callServerEndpoint<_i4.AppUser?>(
        'user',
        'getUserByFirebaseUid',
        {'uid': uid},
      );

  _i2.Future<_i4.AppUser> createOrUpdateUser(_i4.AppUser user) =>
      caller.callServerEndpoint<_i4.AppUser>(
        'user',
        'createOrUpdateUser',
        {'user': user},
      );

  _i2.Future<bool> updateCart(
    String uid,
    List<_i33.CartItem> cart,
  ) => caller.callServerEndpoint<bool>(
    'user',
    'updateCart',
    {
      'uid': uid,
      'cart': cart,
    },
  );

  _i2.Future<bool> updateFcmToken(
    String uid,
    String token,
  ) => caller.callServerEndpoint<bool>(
    'user',
    'updateFcmToken',
    {
      'uid': uid,
      'token': token,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i34.Caller(client);
    serverpod_auth_core = _i35.Caller(client);
  }

  late final _i34.Caller serverpod_auth_idp;

  late final _i35.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i36.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    admin = EndpointAdmin(this);
    auth = EndpointAuth(this);
    banner = EndpointBanner(this);
    bogo = EndpointBogo(this);
    category = EndpointCategory(this);
    categoryOffer = EndpointCategoryOffer(this);
    comboOffer = EndpointComboOffer(this);
    coupon = EndpointCoupon(this);
    freeDelivery = EndpointFreeDelivery(this);
    order = EndpointOrder(this);
    payment = EndpointPayment(this);
    pricing = EndpointPricing(this);
    product = EndpointProduct(this);
    refund = EndpointRefund(this);
    subCategory = EndpointSubCategory(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAuth auth;

  late final EndpointBanner banner;

  late final EndpointBogo bogo;

  late final EndpointCategory category;

  late final EndpointCategoryOffer categoryOffer;

  late final EndpointComboOffer comboOffer;

  late final EndpointCoupon coupon;

  late final EndpointFreeDelivery freeDelivery;

  late final EndpointOrder order;

  late final EndpointPayment payment;

  late final EndpointPricing pricing;

  late final EndpointProduct product;

  late final EndpointRefund refund;

  late final EndpointSubCategory subCategory;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'admin': admin,
    'auth': auth,
    'banner': banner,
    'bogo': bogo,
    'category': category,
    'categoryOffer': categoryOffer,
    'comboOffer': comboOffer,
    'coupon': coupon,
    'freeDelivery': freeDelivery,
    'order': order,
    'payment': payment,
    'pricing': pricing,
    'product': product,
    'refund': refund,
    'subCategory': subCategory,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
