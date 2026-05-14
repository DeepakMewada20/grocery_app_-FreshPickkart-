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
import 'package:freshpickkat_client/src/protocol/checkout_result.dart' as _i15;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i16;
import 'package:freshpickkat_client/src/protocol/combo_offer.dart' as _i17;
import 'package:freshpickkat_client/src/protocol/combo_offer_page.dart' as _i18;
import 'package:freshpickkat_client/src/protocol/cart_item_input.dart' as _i19;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i20;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i21;
import 'package:freshpickkat_client/src/protocol/coupon_validation_result.dart'
    as _i22;
import 'package:freshpickkat_client/src/protocol/best_coupon_result.dart'
    as _i23;
import 'package:freshpickkat_client/src/protocol/delivery_config.dart' as _i24;
import 'package:freshpickkat_client/src/protocol/delivery_rule.dart' as _i25;
import 'package:freshpickkat_client/src/protocol/delivery_rule_page.dart'
    as _i26;
import 'package:freshpickkat_client/src/protocol/delivery_pricing_result.dart'
    as _i27;
import 'package:freshpickkat_client/src/protocol/order_page.dart' as _i28;
import 'package:freshpickkat_client/src/protocol/order_realtime_event.dart'
    as _i29;
import 'package:freshpickkat_client/src/protocol/order_tracking_data.dart'
    as _i30;
import 'package:freshpickkat_client/src/protocol/payment_order_result.dart'
    as _i31;
import 'package:freshpickkat_client/src/protocol/payment_verify_result.dart'
    as _i32;
import 'package:freshpickkat_client/src/protocol/payment_action_result.dart'
    as _i33;
import 'package:freshpickkat_client/src/protocol/cart_pricing_result.dart'
    as _i34;
import 'package:freshpickkat_client/src/protocol/applied_offer_info.dart'
    as _i35;
import 'package:freshpickkat_client/src/protocol/basket_suggestion_result.dart'
    as _i36;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i37;
import 'package:freshpickkat_client/src/protocol/product_page.dart' as _i38;
import 'package:freshpickkat_client/src/protocol/offer_search_page.dart'
    as _i39;
import 'package:freshpickkat_client/src/protocol/product_ranking_item.dart'
    as _i40;
import 'package:freshpickkat_client/src/protocol/refund_record.dart' as _i41;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i42;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i43;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i44;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i45;
import 'protocol.dart' as _i46;

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

  _i2.Future<_i3.AdminAuthResult> completeFirebaseSetup(
    String idToken,
    String username,
  ) => caller.callServerEndpoint<_i3.AdminAuthResult>(
    'admin',
    'completeFirebaseSetup',
    {
      'idToken': idToken,
      'username': username,
    },
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
    String? firebaseUid,
    String? idToken,
  }) => caller.callServerEndpoint<_i9.BannerPage>(
    'banner',
    'getBannersPage',
    {
      'limit': limit,
      'pageToken': pageToken,
      'activeOnly': activeOnly,
      'screen': screen,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i8.Banner?> getBannerById(String bannerId) =>
      caller.callServerEndpoint<_i8.Banner?>(
        'banner',
        'getBannerById',
        {'bannerId': bannerId},
      );

  _i2.Future<_i8.Banner> createBanner(
    _i8.Banner banner,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i8.Banner>(
    'banner',
    'createBanner',
    {
      'banner': banner,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i8.Banner> updateBanner(
    _i8.Banner banner,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i8.Banner>(
    'banner',
    'updateBanner',
    {
      'banner': banner,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<void> deleteBanner(
    String bannerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<void>(
    'banner',
    'deleteBanner',
    {
      'bannerId': bannerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<void> toggleBannerActive(
    String bannerId,
    bool active,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<void>(
    'banner',
    'toggleBannerActive',
    {
      'bannerId': bannerId,
      'active': active,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<void> updateBannerPriority(
    String bannerId,
    int priority,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<void>(
    'banner',
    'updateBannerPriority',
    {
      'bannerId': bannerId,
      'priority': priority,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointBogo extends _i1.EndpointRef {
  EndpointBogo(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'bogo';

  _i2.Future<bool> upsertOffer(
    _i10.BogoOffer offer,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'bogo',
    'upsertOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteOffer(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'bogo',
    'deleteOffer',
    {
      'triggerProductId': triggerProductId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i10.BogoOffer>> getAllOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i10.BogoOffer>>(
    'bogo',
    'getAllOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i11.BogoOfferPage> getOffersPage({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i11.BogoOfferPage>(
    'bogo',
    'getOffersPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
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

  _i2.Future<_i10.BogoOffer?> getActiveOfferForProduct(String productId) =>
      caller.callServerEndpoint<_i10.BogoOffer?>(
        'bogo',
        'getActiveOfferForProduct',
        {'productId': productId},
      );

  _i2.Future<List<_i10.BogoOffer>> getActiveBogoOffersForProducts(
    List<String> productIds,
  ) => caller.callServerEndpoint<List<_i10.BogoOffer>>(
    'bogo',
    'getActiveBogoOffersForProducts',
    {'productIds': productIds},
  );

  _i2.Future<_i10.BogoOffer?> getOfferForProduct(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i10.BogoOffer?>(
    'bogo',
    'getOfferForProduct',
    {
      'triggerProductId': triggerProductId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
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

  _i2.Future<bool> updateCategory(
    String oldName,
    _i12.Category category,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'category',
    'updateCategory',
    {
      'oldName': oldName,
      'category': category,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteCategory(
    String categoryName,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'category',
    'deleteCategory',
    {
      'categoryName': categoryName,
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
class EndpointCheckout extends _i1.EndpointRef {
  EndpointCheckout(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checkout';

  _i2.Future<_i15.CheckoutResult> createOrderAndPayment(
    _i16.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) => caller.callServerEndpoint<_i15.CheckoutResult>(
    'checkout',
    'createOrderAndPayment',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
      'amount': amount,
      'customerPhone': customerPhone,
    },
  );
}

/// {@category Endpoint}
class EndpointComboOffer extends _i1.EndpointRef {
  EndpointComboOffer(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'comboOffer';

  _i2.Future<bool> upsertComboOffer(
    _i17.ComboOffer offer,
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

  _i2.Future<List<_i17.ComboOffer>> getActiveComboOffers() =>
      caller.callServerEndpoint<List<_i17.ComboOffer>>(
        'comboOffer',
        'getActiveComboOffers',
        {},
      );

  _i2.Future<List<_i17.ComboOffer>> getActiveComboOffersForProducts(
    List<String> productIds,
  ) => caller.callServerEndpoint<List<_i17.ComboOffer>>(
    'comboOffer',
    'getActiveComboOffersForProducts',
    {'productIds': productIds},
  );

  _i2.Future<List<_i17.ComboOffer>> getAllComboOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i17.ComboOffer>>(
    'comboOffer',
    'getAllComboOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i18.ComboOfferPage> getComboOffersPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i18.ComboOfferPage>(
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

  _i2.Future<List<_i17.ComboOffer>> checkApplicableCombos(
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i17.ComboOffer>>(
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

  _i2.Future<List<_i20.Coupon>> fetchCoupons(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i20.Coupon>>(
    'coupon',
    'fetchCoupons',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> uploadCoupon(
    _i20.Coupon coupon,
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
    _i20.Coupon coupon,
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

  _i2.Future<bool> deleteCoupon(
    String code,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'coupon',
    'deleteCoupon',
    {
      'code': code,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i21.CouponDisplay>> fetchApplicableCoupons(
    double orderAmount,
  ) => caller.callServerEndpoint<List<_i21.CouponDisplay>>(
    'coupon',
    'fetchApplicableCoupons',
    {'orderAmount': orderAmount},
  );

  _i2.Future<_i22.CouponValidationResult> validateCoupon(
    String couponCode,
    double orderAmount,
  ) => caller.callServerEndpoint<_i22.CouponValidationResult>(
    'coupon',
    'validateCoupon',
    {
      'couponCode': couponCode,
      'orderAmount': orderAmount,
    },
  );

  _i2.Future<_i22.CouponValidationResult> applyCoupon(
    String userId,
    String couponCode,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i22.CouponValidationResult>(
    'coupon',
    'applyCoupon',
    {
      'userId': userId,
      'couponCode': couponCode,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<List<_i21.CouponDisplay>> getAvailableCoupons(
    String userId,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i21.CouponDisplay>>(
    'coupon',
    'getAvailableCoupons',
    {
      'userId': userId,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<_i23.BestCouponResult> getBestCoupon(
    String userId,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i23.BestCouponResult>(
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

  _i2.Future<_i24.DeliveryConfig> getDeliveryConfig() =>
      caller.callServerEndpoint<_i24.DeliveryConfig>(
        'freeDelivery',
        'getDeliveryConfig',
        {},
      );

  _i2.Future<bool> upsertDeliveryConfig(
    _i24.DeliveryConfig config,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'upsertDeliveryConfig',
    {
      'config': config,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i25.DeliveryRule>> getAllDeliveryRules(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i25.DeliveryRule>>(
    'freeDelivery',
    'getAllDeliveryRules',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i26.DeliveryRulePage> getDeliveryRulesPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i26.DeliveryRulePage>(
    'freeDelivery',
    'getDeliveryRulesPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> upsertDeliveryRule(
    _i25.DeliveryRule rule,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'upsertDeliveryRule',
    {
      'rule': rule,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteDeliveryRule(
    String ruleId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'deleteDeliveryRule',
    {
      'ruleId': ruleId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> setDeliveryRuleActive(
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'setDeliveryRuleActive',
    {
      'ruleId': ruleId,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i27.DeliveryPricingResult> calculateDeliveryPricing(
    double cartTotal, {
    String? userId,
    String? location,
  }) => caller.callServerEndpoint<_i27.DeliveryPricingResult>(
    'freeDelivery',
    'calculateDeliveryPricing',
    {
      'cartTotal': cartTotal,
      'userId': userId,
      'location': location,
    },
  );
}

/// {@category Endpoint}
class EndpointOrder extends _i1.EndpointRef {
  EndpointOrder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'order';

  _i2.Future<String> createOrder(_i16.Order order) =>
      caller.callServerEndpoint<String>(
        'order',
        'createOrder',
        {'order': order},
      );

  _i2.Future<String> createPendingOrder(
    _i16.Order order,
    String idempotencyKey,
  ) => caller.callServerEndpoint<String>(
    'order',
    'createPendingOrder',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<List<_i16.Order>> getOrders({
    String? status,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<List<_i16.Order>>(
    'order',
    'getOrders',
    {
      'status': status,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i28.OrderPage> getOrdersPage({
    String? status,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i28.OrderPage>(
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

  _i2.Future<List<_i16.Order>> getTodayOrders(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i16.Order>>(
    'order',
    'getTodayOrders',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i16.Order>> getUserOrders(
    String userId,
    String idToken,
  ) => caller.callServerEndpoint<List<_i16.Order>>(
    'order',
    'getUserOrders',
    {
      'userId': userId,
      'idToken': idToken,
    },
  );

  _i2.Future<_i16.Order?> getOrderById(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i16.Order?>(
    'order',
    'getOrderById',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
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

  _i2.Future<bool> confirmOrder(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'order',
    'confirmOrder',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> cancelOrder(
    String orderId,
    String userId, {
    required String idToken,
    required String reason,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'cancelOrder',
    {
      'orderId': orderId,
      'userId': userId,
      'idToken': idToken,
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
class EndpointOrderPg extends _i1.EndpointRef {
  EndpointOrderPg(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'orderPg';

  _i2.Future<String> createPendingOrder(
    _i16.Order order,
    String idempotencyKey,
  ) => caller.callServerEndpoint<String>(
    'orderPg',
    'createPendingOrder',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<_i28.OrderPage> getOrdersForUser({
    required String userReference,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i28.OrderPage>(
    'orderPg',
    'getOrdersForUser',
    {
      'userReference': userReference,
      'limit': limit,
      'pageToken': pageToken,
    },
  );
}

/// {@category Endpoint}
class EndpointOrderRealtime extends _i1.EndpointRef {
  EndpointOrderRealtime(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'orderRealtime';

  _i2.Stream<_i29.OrderRealtimeEvent> watchAdminOrders(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i29.OrderRealtimeEvent>,
        _i29.OrderRealtimeEvent
      >(
        'orderRealtime',
        'watchAdminOrders',
        {
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Stream<_i29.OrderRealtimeEvent> watchDashboardUpdates(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i29.OrderRealtimeEvent>,
        _i29.OrderRealtimeEvent
      >(
        'orderRealtime',
        'watchDashboardUpdates',
        {
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Stream<_i29.OrderRealtimeEvent> watchUserOrders(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i29.OrderRealtimeEvent>,
        _i29.OrderRealtimeEvent
      >(
        'orderRealtime',
        'watchUserOrders',
        {
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );
}

/// {@category Endpoint}
class EndpointOrderTracking extends _i1.EndpointRef {
  EndpointOrderTracking(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'orderTracking';

  _i2.Future<_i30.OrderTrackingData?> getTrackingForUser(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i30.OrderTrackingData?>(
    'orderTracking',
    'getTrackingForUser',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i30.OrderTrackingData?> getTrackingForAdmin(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i30.OrderTrackingData?>(
    'orderTracking',
    'getTrackingForAdmin',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i30.OrderTrackingData> seedUserLocation(
    String orderId,
    String firebaseUid,
    String idToken,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
  ) => caller.callServerEndpoint<_i30.OrderTrackingData>(
    'orderTracking',
    'seedUserLocation',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'userAddress': userAddress,
      'userLocationType': userLocationType,
    },
  );

  _i2.Future<_i30.OrderTrackingData> updateTrackingEnabled(
    String orderId,
    bool enabled,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i30.OrderTrackingData>(
    'orderTracking',
    'updateTrackingEnabled',
    {
      'orderId': orderId,
      'enabled': enabled,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i30.OrderTrackingData> updateRiderLocation(
    String orderId,
    double riderLatitude,
    double riderLongitude,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i30.OrderTrackingData>(
    'orderTracking',
    'updateRiderLocation',
    {
      'orderId': orderId,
      'riderLatitude': riderLatitude,
      'riderLongitude': riderLongitude,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<List<double>>> getDeliveryRoute(
    String orderId,
    double riderLatitude,
    double riderLongitude,
    double userLatitude,
    double userLongitude,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<List<double>>>(
    'orderTracking',
    'getDeliveryRoute',
    {
      'orderId': orderId,
      'riderLatitude': riderLatitude,
      'riderLongitude': riderLongitude,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
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

  _i2.Future<_i31.PaymentOrderResult> createPaymentOrder(
    String orderId,
    double amount,
    String customerPhone,
  ) => caller.callServerEndpoint<_i31.PaymentOrderResult>(
    'payment',
    'createPaymentOrder',
    {
      'orderId': orderId,
      'amount': amount,
      'customerPhone': customerPhone,
    },
  );

  _i2.Future<_i32.PaymentVerifyResult> verifyPayment(
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) => caller.callServerEndpoint<_i32.PaymentVerifyResult>(
    'payment',
    'verifyPayment',
    {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    },
  );

  _i2.Future<_i33.PaymentActionResult> markPaymentFailed(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.PaymentActionResult>(
    'payment',
    'markPaymentFailed',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i33.PaymentActionResult> initiateRefund(
    String razorpayPaymentId,
    double amount,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.PaymentActionResult>(
    'payment',
    'initiateRefund',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'amount': amount,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i33.PaymentActionResult> getPaymentStatus(
    String razorpayPaymentId,
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.PaymentActionResult>(
    'payment',
    'getPaymentStatus',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i33.PaymentActionResult> recoverPendingPayments(
    String userId, {
    required String idToken,
    required int limit,
  }) => caller.callServerEndpoint<_i33.PaymentActionResult>(
    'payment',
    'recoverPendingPayments',
    {
      'userId': userId,
      'idToken': idToken,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointPricing extends _i1.EndpointRef {
  EndpointPricing(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pricing';

  _i2.Future<_i34.CartPricingResult> calculateCartPricing(
    List<_i19.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    required bool autoApplyCoupons,
  }) => caller.callServerEndpoint<_i34.CartPricingResult>(
    'pricing',
    'calculateCartPricing',
    {
      'items': items,
      'userId': userId,
      'appliedCouponCode': appliedCouponCode,
      'autoApplyCoupons': autoApplyCoupons,
    },
  );

  _i2.Future<List<_i35.AppliedOfferInfo>> getApplicableOffers(
    List<_i19.CartItemInput> items,
  ) => caller.callServerEndpoint<List<_i35.AppliedOfferInfo>>(
    'pricing',
    'getApplicableOffers',
    {'items': items},
  );

  _i2.Future<_i36.BasketSuggestionResult> basketSuggestions(
    List<_i19.CartItemInput>? items, {
    double? cartTotal,
    required String mode,
    String? userId,
    String? appliedCouponCode,
  }) => caller.callServerEndpoint<_i36.BasketSuggestionResult>(
    'pricing',
    'basketSuggestions',
    {
      'items': items,
      'cartTotal': cartTotal,
      'mode': mode,
      'userId': userId,
      'appliedCouponCode': appliedCouponCode,
    },
  );

  _i2.Future<double> calculateDeliveryFee(
    double orderAmount,
    int itemCount,
    String? couponCode,
    String? userId,
  ) => caller.callServerEndpoint<double>(
    'pricing',
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
class EndpointProduct extends _i1.EndpointRef {
  EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<List<_i37.Product>> getProductsByIds(List<String> productIds) =>
      caller.callServerEndpoint<List<_i37.Product>>(
        'product',
        'getProductsByIds',
        {'productIds': productIds},
      );

  _i2.Future<List<_i37.Product>> getProducts({
    required int limit,
    String? lastProductName,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<List<_i37.Product>>(
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

  _i2.Future<_i38.ProductPage> getProductsPage({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<_i38.ProductPage>(
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

  _i2.Future<String?> uploadProduct(
    _i37.Product product,
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
    _i37.Product product,
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

  _i2.Future<_i38.ProductPage> searchProducts(
    String query, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i38.ProductPage>(
    'product',
    'searchProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i39.OfferSearchPage> getProductsByOffer({
    required String offerType,
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i39.OfferSearchPage>(
    'product',
    'getProductsByOffer',
    {
      'offerType': offerType,
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i39.OfferSearchPage> getComboProducts({
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i39.OfferSearchPage>(
    'product',
    'getComboProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i39.OfferSearchPage> getBogoProducts({
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i39.OfferSearchPage>(
    'product',
    'getBogoProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i39.OfferSearchPage> searchProductsWithOfferFilters({
    required String query,
    required String offerFilter,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i39.OfferSearchPage>(
    'product',
    'searchProductsWithOfferFilters',
    {
      'query': query,
      'offerFilter': offerFilter,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<int> migrateProducts(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<int>(
    'product',
    'migrateProducts',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<int> initializeProductMetrics(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<int>(
    'product',
    'initializeProductMetrics',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> incrementProductSearch(String productId) =>
      caller.callServerEndpoint<bool>(
        'product',
        'incrementProductSearch',
        {'productId': productId},
      );

  _i2.Future<bool> incrementProductPurchase(String productId) =>
      caller.callServerEndpoint<bool>(
        'product',
        'incrementProductPurchase',
        {'productId': productId},
      );

  _i2.Future<int> seedProductMetricsForTesting(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<int>(
    'product',
    'seedProductMetricsForTesting',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointProductPg extends _i1.EndpointRef {
  EndpointProductPg(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'productPg';

  _i2.Future<_i38.ProductPage> getActiveProductsPage({
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
  }) => caller.callServerEndpoint<_i38.ProductPage>(
    'productPg',
    'getActiveProductsPage',
    {
      'limit': limit,
      'pageToken': pageToken,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
    },
  );

  _i2.Future<_i38.ProductPage> searchActiveProducts({
    required String query,
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
    required double similarityThreshold,
  }) => caller.callServerEndpoint<_i38.ProductPage>(
    'productPg',
    'searchActiveProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'similarityThreshold': similarityThreshold,
    },
  );

  _i2.Future<void> enqueueSearchRebuild({
    required String productId,
    required String reason,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<void>(
    'productPg',
    'enqueueSearchRebuild',
    {
      'productId': productId,
      'reason': reason,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<int> processPendingSearchRebuildJobs({
    required String firebaseUid,
    required String idToken,
    required int limit,
  }) => caller.callServerEndpoint<int>(
    'productPg',
    'processPendingSearchRebuildJobs',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointProductRanking extends _i1.EndpointRef {
  EndpointProductRanking(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'productRanking';

  _i2.Future<bool> recordProductView(String productId) =>
      caller.callServerEndpoint<bool>(
        'productRanking',
        'recordProductView',
        {'productId': productId},
      );

  _i2.Future<List<_i40.ProductRankingItem>> getTrendingProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i40.ProductRankingItem>>(
    'productRanking',
    'getTrendingProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i40.ProductRankingItem>> getMostSellingProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i40.ProductRankingItem>>(
    'productRanking',
    'getMostSellingProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i40.ProductRankingItem>> getMostViewedProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i40.ProductRankingItem>>(
    'productRanking',
    'getMostViewedProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i40.ProductRankingItem>> getFrequentlyReorderedProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i40.ProductRankingItem>>(
    'productRanking',
    'getFrequentlyReorderedProducts',
    {'limit': limit},
  );
}

/// {@category Endpoint}
class EndpointRefund extends _i1.EndpointRef {
  EndpointRefund(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refund';

  _i2.Future<_i41.RefundRecord> initiateRefund(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i41.RefundRecord>(
    'refund',
    'initiateRefund',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i41.RefundRecord?> getRefundStatus(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i41.RefundRecord?>(
    'refund',
    'getRefundStatus',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointSubCategory extends _i1.EndpointRef {
  EndpointSubCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subCategory';

  _i2.Future<List<_i42.SubCategory>> getSubCategories() =>
      caller.callServerEndpoint<List<_i42.SubCategory>>(
        'subCategory',
        'getSubCategories',
        {},
      );

  _i2.Future<bool> uploadSubCategory(
    _i42.SubCategory subCategory,
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

  _i2.Future<bool> updateSubCategory(
    String categoryName,
    String oldSubName,
    _i42.SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'subCategory',
    'updateSubCategory',
    {
      'categoryName': categoryName,
      'oldSubName': oldSubName,
      'subCategory': subCategory,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deleteSubCategory(
    String categoryName,
    String subCategoryName,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'subCategory',
    'deleteSubCategory',
    {
      'categoryName': categoryName,
      'subCategoryName': subCategoryName,
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
    List<_i43.CartItem> cart,
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
    serverpod_auth_idp = _i44.Caller(client);
    serverpod_auth_core = _i45.Caller(client);
  }

  late final _i44.Caller serverpod_auth_idp;

  late final _i45.Caller serverpod_auth_core;
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
         _i46.Protocol(),
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
    checkout = EndpointCheckout(this);
    comboOffer = EndpointComboOffer(this);
    coupon = EndpointCoupon(this);
    freeDelivery = EndpointFreeDelivery(this);
    order = EndpointOrder(this);
    orderPg = EndpointOrderPg(this);
    orderRealtime = EndpointOrderRealtime(this);
    orderTracking = EndpointOrderTracking(this);
    payment = EndpointPayment(this);
    pricing = EndpointPricing(this);
    product = EndpointProduct(this);
    productPg = EndpointProductPg(this);
    productRanking = EndpointProductRanking(this);
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

  late final EndpointCheckout checkout;

  late final EndpointComboOffer comboOffer;

  late final EndpointCoupon coupon;

  late final EndpointFreeDelivery freeDelivery;

  late final EndpointOrder order;

  late final EndpointOrderPg orderPg;

  late final EndpointOrderRealtime orderRealtime;

  late final EndpointOrderTracking orderTracking;

  late final EndpointPayment payment;

  late final EndpointPricing pricing;

  late final EndpointProduct product;

  late final EndpointProductPg productPg;

  late final EndpointProductRanking productRanking;

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
    'checkout': checkout,
    'comboOffer': comboOffer,
    'coupon': coupon,
    'freeDelivery': freeDelivery,
    'order': order,
    'orderPg': orderPg,
    'orderRealtime': orderRealtime,
    'orderTracking': orderTracking,
    'payment': payment,
    'pricing': pricing,
    'product': product,
    'productPg': productPg,
    'productRanking': productRanking,
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
