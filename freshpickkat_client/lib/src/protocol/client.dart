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
import 'package:freshpickkat_client/src/protocol/data_flow/admin_auth_result.dart'
    as _i3;
import 'package:freshpickkat_client/src/protocol/data_flow/app_user.dart'
    as _i4;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_dashboard_stats.dart'
    as _i5;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_analytics.dart'
    as _i6;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_dashboard_hydrated.dart'
    as _i7;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_audit_log_entry.dart'
    as _i8;
import 'package:freshpickkat_client/src/protocol/data_flow/active_user_statistics.dart'
    as _i9;
import 'package:freshpickkat_client/src/protocol/data_flow/banner.dart' as _i10;
import 'package:freshpickkat_client/src/protocol/data_flow/banner_page.dart'
    as _i11;
import 'package:freshpickkat_client/src/protocol/data_flow/delete_impact_response.dart'
    as _i12;
import 'package:freshpickkat_client/src/protocol/data_flow/hard_delete_response.dart'
    as _i13;
import 'package:freshpickkat_client/src/protocol/data_flow/offer_mutation_result.dart'
    as _i14;
import 'package:freshpickkat_client/src/protocol/data_flow/bogo_offer.dart'
    as _i15;
import 'package:freshpickkat_client/src/protocol/data_flow/notification_draft.dart'
    as _i16;
import 'package:freshpickkat_client/src/protocol/data_flow/bogo_offer_page.dart'
    as _i17;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_hydrated_data.dart'
    as _i18;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_item_input.dart'
    as _i19;
import 'package:freshpickkat_client/src/protocol/data_flow/category.dart'
    as _i20;
import 'package:freshpickkat_client/src/protocol/data_flow/category_hierarchy.dart'
    as _i21;
import 'package:freshpickkat_client/src/protocol/data_flow/category_offer.dart'
    as _i22;
import 'package:freshpickkat_client/src/protocol/data_flow/category_offer_page.dart'
    as _i23;
import 'package:freshpickkat_client/src/protocol/data_flow/checkout_init_hydrated.dart'
    as _i24;
import 'package:freshpickkat_client/src/protocol/data_flow/checkout_result.dart'
    as _i25;
import 'package:freshpickkat_client/src/protocol/data_flow/order.dart' as _i26;
import 'package:freshpickkat_client/src/protocol/data_flow/combo_offer.dart'
    as _i27;
import 'package:freshpickkat_client/src/protocol/data_flow/combo_offer_page.dart'
    as _i28;
import 'package:freshpickkat_client/src/protocol/data_flow/complaint.dart'
    as _i29;
import 'package:freshpickkat_client/src/protocol/data_flow/address.dart'
    as _i30;
import 'package:freshpickkat_client/src/protocol/data_flow/complaint_page.dart'
    as _i31;
import 'package:freshpickkat_client/src/protocol/data_flow/complaint_detail_hydrated.dart'
    as _i32;
import 'package:freshpickkat_client/src/protocol/data_flow/refund_record.dart'
    as _i33;
import 'package:freshpickkat_client/src/protocol/data_flow/coupon.dart' as _i34;
import 'package:freshpickkat_client/src/protocol/data_flow/coupon_display.dart'
    as _i35;
import 'package:freshpickkat_client/src/protocol/data_flow/coupon_validation_result.dart'
    as _i36;
import 'package:freshpickkat_client/src/protocol/data_flow/best_coupon_result.dart'
    as _i37;
import 'package:freshpickkat_client/src/protocol/data_flow/delivery_config.dart'
    as _i38;
import 'package:freshpickkat_client/src/protocol/data_flow/delivery_pricing_result.dart'
    as _i39;
import 'package:freshpickkat_client/src/protocol/data_flow/delivery_rule.dart'
    as _i40;
import 'package:freshpickkat_client/src/protocol/data_flow/delivery_rule_page.dart'
    as _i41;
import 'package:freshpickkat_client/src/protocol/data_flow/free_delivery_hydrated.dart'
    as _i42;
import 'package:freshpickkat_client/src/protocol/data_flow/home_page_hydrated_data.dart'
    as _i43;
import 'package:freshpickkat_client/src/protocol/data_flow/notification_preference.dart'
    as _i44;
import 'package:freshpickkat_client/src/protocol/data_flow/notification_history_page.dart'
    as _i45;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_notification_preference.dart'
    as _i46;
import 'package:freshpickkat_client/src/protocol/data_flow/broadcast_summary.dart'
    as _i47;
import 'package:freshpickkat_client/src/protocol/data_flow/broadcast_request.dart'
    as _i48;
import 'package:freshpickkat_client/src/protocol/data_flow/broadcast_page.dart'
    as _i49;
import 'package:freshpickkat_client/src/protocol/data_flow/order_detail_hydrated.dart'
    as _i50;
import 'package:freshpickkat_client/src/protocol/data_flow/order_page.dart'
    as _i51;
import 'package:freshpickkat_client/src/protocol/data_flow/payment_action_result.dart'
    as _i52;
import 'package:freshpickkat_client/src/protocol/data_flow/order_realtime_event.dart'
    as _i53;
import 'package:freshpickkat_client/src/protocol/data_flow/order_tracking_data.dart'
    as _i54;
import 'package:freshpickkat_client/src/protocol/data_flow/payment_order_result.dart'
    as _i55;
import 'package:freshpickkat_client/src/protocol/data_flow/payment_verify_result.dart'
    as _i56;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_pricing_result.dart'
    as _i57;
import 'package:freshpickkat_client/src/protocol/data_flow/applied_offer_info.dart'
    as _i58;
import 'package:freshpickkat_client/src/protocol/data_flow/basket_suggestion_result.dart'
    as _i59;
import 'package:freshpickkat_client/src/protocol/data_flow/product.dart'
    as _i60;
import 'package:freshpickkat_client/src/protocol/data_flow/product_page.dart'
    as _i61;
import 'package:freshpickkat_client/src/protocol/data_flow/offer_search_page.dart'
    as _i62;
import 'package:freshpickkat_client/src/protocol/data_flow/product_form_reference_data.dart'
    as _i63;
import 'package:freshpickkat_client/src/protocol/data_flow/product_ranking_item.dart'
    as _i64;
import 'package:freshpickkat_client/src/protocol/data_flow/sub_category.dart'
    as _i65;
import 'package:freshpickkat_client/src/protocol/data_flow/support_issue.dart'
    as _i66;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_item.dart'
    as _i67;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i68;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i69;
import 'protocol.dart' as _i70;

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

  _i2.Future<_i7.AdminDashboardHydrated> getDashboardHydrated(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i7.AdminDashboardHydrated>(
    'admin',
    'getDashboardHydrated',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i8.AdminAuditLogEntry>> getAuditLogs(
    String firebaseUid,
    String idToken, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i8.AdminAuditLogEntry>>(
    'admin',
    'getAuditLogs',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
    },
  );

  _i2.Future<List<_i9.ActiveUserStatistics>> getActiveUsersWithStats(
    String firebaseUid,
    String idToken, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i9.ActiveUserStatistics>>(
    'admin',
    'getActiveUsersWithStats',
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

  _i2.Future<List<_i10.Banner>> getInactiveBanners() =>
      caller.callServerEndpoint<List<_i10.Banner>>(
        'banner',
        'getInactiveBanners',
        {},
      );

  _i2.Future<List<_i10.Banner>> getAllAdminBanners(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i10.Banner>>(
    'banner',
    'getAllAdminBanners',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i10.Banner>> getBanners({
    String? screen,
    required bool activeOnly,
  }) => caller.callServerEndpoint<List<_i10.Banner>>(
    'banner',
    'getBanners',
    {
      'screen': screen,
      'activeOnly': activeOnly,
    },
  );

  _i2.Future<_i11.BannerPage> getBannersPage({
    required int limit,
    String? pageToken,
    required bool activeOnly,
    String? screen,
    String? firebaseUid,
    String? idToken,
  }) => caller.callServerEndpoint<_i11.BannerPage>(
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

  _i2.Future<_i10.Banner?> getBannerById(String bannerId) =>
      caller.callServerEndpoint<_i10.Banner?>(
        'banner',
        'getBannerById',
        {'bannerId': bannerId},
      );

  _i2.Future<_i10.Banner> createBanner(
    _i10.Banner banner,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i10.Banner>(
    'banner',
    'createBanner',
    {
      'banner': banner,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i10.Banner> updateBanner(
    _i10.Banner banner,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i10.Banner>(
    'banner',
    'updateBanner',
    {
      'banner': banner,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<String> deleteBanner(
    String bannerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'banner',
    'deleteBanner',
    {
      'bannerId': bannerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkBannerDeleteImpact(
    String bannerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'banner',
    'checkBannerDeleteImpact',
    {
      'bannerId': bannerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteBanner(
    String bannerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'banner',
    'hardDeleteBanner',
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

  _i2.Future<_i14.OfferMutationResult> upsertOfferWithConflicts(
    _i15.BogoOffer offer,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
    required bool confirmDisableConflictingCombo,
    required bool forceDisableFreeDelivery,
  }) => caller.callServerEndpoint<_i14.OfferMutationResult>(
    'bogo',
    'upsertOfferWithConflicts',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
      'confirmDisableConflictingCombo': confirmDisableConflictingCombo,
      'forceDisableFreeDelivery': forceDisableFreeDelivery,
    },
  );

  _i2.Future<bool> upsertOffer(
    _i15.BogoOffer offer,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
  }) => caller.callServerEndpoint<bool>(
    'bogo',
    'upsertOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
    },
  );

  _i2.Future<String> deleteOffer(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'bogo',
    'deleteOffer',
    {
      'triggerProductId': triggerProductId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkBogoDeleteImpact(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'bogo',
    'checkBogoDeleteImpact',
    {
      'triggerProductId': triggerProductId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteBogoOffer(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'bogo',
    'hardDeleteBogoOffer',
    {
      'triggerProductId': triggerProductId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> setBogoOfferActive(
    String triggerProductId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'bogo',
    'setBogoOfferActive',
    {
      'triggerProductId': triggerProductId,
      'isActive': isActive,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i15.BogoOffer>> getInactiveBogoOffers() =>
      caller.callServerEndpoint<List<_i15.BogoOffer>>(
        'bogo',
        'getInactiveBogoOffers',
        {},
      );

  _i2.Future<List<_i15.BogoOffer>> getAllOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i15.BogoOffer>>(
    'bogo',
    'getAllOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i17.BogoOfferPage> getOffersPage({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i17.BogoOfferPage>(
    'bogo',
    'getOffersPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<List<_i15.BogoOffer>> getActiveOffers() =>
      caller.callServerEndpoint<List<_i15.BogoOffer>>(
        'bogo',
        'getActiveOffers',
        {},
      );

  _i2.Future<_i15.BogoOffer?> getActiveOfferForProduct(String productId) =>
      caller.callServerEndpoint<_i15.BogoOffer?>(
        'bogo',
        'getActiveOfferForProduct',
        {'productId': productId},
      );

  _i2.Future<List<_i15.BogoOffer>> getActiveBogoOffersForProducts(
    List<String> productIds,
  ) => caller.callServerEndpoint<List<_i15.BogoOffer>>(
    'bogo',
    'getActiveBogoOffersForProducts',
    {'productIds': productIds},
  );

  _i2.Future<_i15.BogoOffer?> getOfferForProduct(
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i15.BogoOffer?>(
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
class EndpointCart extends _i1.EndpointRef {
  EndpointCart(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cart';

  _i2.Future<_i18.CartHydratedData> getCartHydratedData(
    List<_i19.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    required bool autoApplyCoupons,
    required String basketMode,
  }) => caller.callServerEndpoint<_i18.CartHydratedData>(
    'cart',
    'getCartHydratedData',
    {
      'items': items,
      'userId': userId,
      'appliedCouponCode': appliedCouponCode,
      'autoApplyCoupons': autoApplyCoupons,
      'basketMode': basketMode,
    },
  );
}

/// {@category Endpoint}
class EndpointCategory extends _i1.EndpointRef {
  EndpointCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'category';

  _i2.Future<List<_i20.Category>> getCategories() =>
      caller.callServerEndpoint<List<_i20.Category>>(
        'category',
        'getCategories',
        {},
      );

  _i2.Future<List<_i20.Category>> getInactiveCategories() =>
      caller.callServerEndpoint<List<_i20.Category>>(
        'category',
        'getInactiveCategories',
        {},
      );

  _i2.Future<List<_i20.Category>> getAllCategories() =>
      caller.callServerEndpoint<List<_i20.Category>>(
        'category',
        'getAllCategories',
        {},
      );

  _i2.Future<_i21.CategoryHierarchy> getCategoryHierarchy() =>
      caller.callServerEndpoint<_i21.CategoryHierarchy>(
        'category',
        'getCategoryHierarchy',
        {},
      );

  _i2.Future<bool> uploadCategory(
    _i20.Category category,
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
    _i20.Category category,
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

  _i2.Future<String> deleteCategory(
    String categoryName,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'category',
    'deleteCategory',
    {
      'categoryName': categoryName,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> setCategoryActive(
    String categoryName,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'category',
    'setCategoryActive',
    {
      'categoryName': categoryName,
      'isActive': isActive,
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
    _i22.CategoryOffer offer,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
  }) => caller.callServerEndpoint<bool>(
    'categoryOffer',
    'upsertCategoryOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
    },
  );

  _i2.Future<String> deleteCategoryOffer(
    String offerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'categoryOffer',
    'deleteCategoryOffer',
    {
      'offerId': offerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkCategoryOfferDeleteImpact(
    String offerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'categoryOffer',
    'checkCategoryOfferDeleteImpact',
    {
      'offerId': offerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteCategoryOffer(
    String offerId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'categoryOffer',
    'hardDeleteCategoryOffer',
    {
      'offerId': offerId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i22.CategoryOffer>> getActiveCategoryOffers() =>
      caller.callServerEndpoint<List<_i22.CategoryOffer>>(
        'categoryOffer',
        'getActiveCategoryOffers',
        {},
      );

  _i2.Future<List<_i22.CategoryOffer>> getInactiveCategoryOffers() =>
      caller.callServerEndpoint<List<_i22.CategoryOffer>>(
        'categoryOffer',
        'getInactiveCategoryOffers',
        {},
      );

  _i2.Future<List<_i22.CategoryOffer>> getAllCategoryOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i22.CategoryOffer>>(
    'categoryOffer',
    'getAllCategoryOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i23.CategoryOfferPage> getCategoryOffersPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i23.CategoryOfferPage>(
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

  _i2.Future<_i24.CheckoutInitHydrated> getCheckoutInitHydrated(
    List<_i19.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    required bool autoApplyCoupons,
    required String basketMode,
  }) => caller.callServerEndpoint<_i24.CheckoutInitHydrated>(
    'checkout',
    'getCheckoutInitHydrated',
    {
      'items': items,
      'userId': userId,
      'appliedCouponCode': appliedCouponCode,
      'autoApplyCoupons': autoApplyCoupons,
      'basketMode': basketMode,
    },
  );

  _i2.Future<_i25.CheckoutResult> createOrderAndPayment(
    _i26.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) => caller.callServerEndpoint<_i25.CheckoutResult>(
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

  _i2.Future<_i14.OfferMutationResult> upsertComboOfferWithConflicts(
    _i27.ComboOffer offer,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
    required bool force,
  }) => caller.callServerEndpoint<_i14.OfferMutationResult>(
    'comboOffer',
    'upsertComboOfferWithConflicts',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
      'force': force,
    },
  );

  _i2.Future<bool> upsertComboOffer(
    _i27.ComboOffer offer,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
  }) => caller.callServerEndpoint<bool>(
    'comboOffer',
    'upsertComboOffer',
    {
      'offer': offer,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
    },
  );

  _i2.Future<String> deleteComboOffer(
    String comboId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'comboOffer',
    'deleteComboOffer',
    {
      'comboId': comboId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkComboDeleteImpact(
    String comboId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'comboOffer',
    'checkComboDeleteImpact',
    {
      'comboId': comboId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteComboOffer(
    String comboId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'comboOffer',
    'hardDeleteComboOffer',
    {
      'comboId': comboId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i27.ComboOffer>> getActiveComboOffers() =>
      caller.callServerEndpoint<List<_i27.ComboOffer>>(
        'comboOffer',
        'getActiveComboOffers',
        {},
      );

  _i2.Future<List<_i27.ComboOffer>> getActiveComboOffersForProducts(
    List<String> productIds,
  ) => caller.callServerEndpoint<List<_i27.ComboOffer>>(
    'comboOffer',
    'getActiveComboOffersForProducts',
    {'productIds': productIds},
  );

  _i2.Future<List<_i27.ComboOffer>> getInactiveComboOffers() =>
      caller.callServerEndpoint<List<_i27.ComboOffer>>(
        'comboOffer',
        'getInactiveComboOffers',
        {},
      );

  _i2.Future<List<_i27.ComboOffer>> getAllComboOffers(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i27.ComboOffer>>(
    'comboOffer',
    'getAllComboOffers',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i28.ComboOfferPage> getComboOffersPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i28.ComboOfferPage>(
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

  _i2.Future<List<_i27.ComboOffer>> checkApplicableCombos(
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i27.ComboOffer>>(
    'comboOffer',
    'checkApplicableCombos',
    {'cartItems': cartItems},
  );
}

/// {@category Endpoint}
class EndpointComplaint extends _i1.EndpointRef {
  EndpointComplaint(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'complaint';

  _i2.Future<_i29.Complaint> createComplaint({
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'createComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'orderNumber': orderNumber,
      'orderItemId': orderItemId,
      'issueType': issueType,
      'description': description,
      'imageUrls': imageUrls,
    },
  );

  _i2.Future<_i29.Complaint> createProductComplaint({
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required List<String> selectedOrderItemIds,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'createProductComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'orderNumber': orderNumber,
      'selectedOrderItemIds': selectedOrderItemIds,
      'issueType': issueType,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
    },
  );

  _i2.Future<_i29.Complaint> createDeliveryComplaint({
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
    String? selectedField,
    _i30.Address? requestedAddress,
    String? requestedNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'createDeliveryComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'orderNumber': orderNumber,
      'issueType': issueType,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'selectedField': selectedField,
      'requestedAddress': requestedAddress,
      'requestedNote': requestedNote,
    },
  );

  _i2.Future<_i29.Complaint?> getActiveComplaintForOrder({
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String complaintType,
  }) => caller.callServerEndpoint<_i29.Complaint?>(
    'complaint',
    'getActiveComplaintForOrder',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'orderNumber': orderNumber,
      'complaintType': complaintType,
    },
  );

  _i2.Future<_i31.ComplaintPage> listMyComplaints({
    required String firebaseUid,
    required String idToken,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i31.ComplaintPage>(
    'complaint',
    'listMyComplaints',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'status': status,
      'issueType': issueType,
      'selectedField': selectedField,
      'complaintType': complaintType,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i29.Complaint?> getMyComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i29.Complaint?>(
    'complaint',
    'getMyComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  _i2.Future<_i29.Complaint?> getComplaintForOrderItem({
    required String firebaseUid,
    required String idToken,
    required String orderItemId,
  }) => caller.callServerEndpoint<_i29.Complaint?>(
    'complaint',
    'getComplaintForOrderItem',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'orderItemId': orderItemId,
    },
  );

  _i2.Future<_i31.ComplaintPage> listComplaints({
    required String firebaseUid,
    required String idToken,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i31.ComplaintPage>(
    'complaint',
    'listComplaints',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'status': status,
      'issueType': issueType,
      'selectedField': selectedField,
      'complaintType': complaintType,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i29.Complaint?> getComplaintAdmin({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i29.Complaint?>(
    'complaint',
    'getComplaintAdmin',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  _i2.Future<_i29.Complaint> updateComplaintStatus({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'updateComplaintStatus',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'status': status,
      'adminReply': adminReply,
      'adminNote': adminNote,
      'resolutionType': resolutionType,
    },
  );

  _i2.Future<double> calculateRefundCap({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<double>(
    'complaint',
    'calculateRefundCap',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  _i2.Future<_i29.Complaint> refundComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required double amount,
    String? adminReply,
    String? adminNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'refundComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'amount': amount,
      'adminReply': adminReply,
      'adminNote': adminNote,
    },
  );

  _i2.Future<_i29.Complaint> createReplacementOrder({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'createReplacementOrder',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'adminReply': adminReply,
      'adminNote': adminNote,
    },
  );

  _i2.Future<_i29.Complaint> retryDelivery({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'retryDelivery',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'adminReply': adminReply,
      'adminNote': adminNote,
    },
  );

  _i2.Future<_i29.Complaint> reassignRider({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String riderName,
    required String riderPhone,
    String? adminReply,
    String? adminNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'reassignRider',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'adminReply': adminReply,
      'adminNote': adminNote,
    },
  );

  _i2.Future<_i29.Complaint> rejectComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'rejectComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'adminReply': adminReply,
      'adminNote': adminNote,
    },
  );

  _i2.Future<_i29.Complaint> replyToComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String adminReply,
  }) => caller.callServerEndpoint<_i29.Complaint>(
    'complaint',
    'replyToComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
      'adminReply': adminReply,
    },
  );

  /// Admin: Get complaint detail hydrated with refund.
  _i2.Future<_i32.ComplaintDetailHydrated> getComplaintDetailHydrated({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i32.ComplaintDetailHydrated>(
    'complaint',
    'getComplaintDetailHydrated',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  /// User: Get complaint detail hydrated with refund.
  _i2.Future<_i32.ComplaintDetailHydrated> getUserComplaintDetailHydrated({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i32.ComplaintDetailHydrated>(
    'complaint',
    'getUserComplaintDetailHydrated',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  /// Admin: Get refund details for a complaint.
  _i2.Future<_i33.RefundRecord?> getRefundForComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i33.RefundRecord?>(
    'complaint',
    'getRefundForComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );

  /// User: Get refund details for their complaint.
  _i2.Future<_i33.RefundRecord?> getUserRefundForComplaint({
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) => caller.callServerEndpoint<_i33.RefundRecord?>(
    'complaint',
    'getUserRefundForComplaint',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'complaintId': complaintId,
    },
  );
}

/// {@category Endpoint}
class EndpointCoupon extends _i1.EndpointRef {
  EndpointCoupon(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'coupon';

  _i2.Future<List<_i34.Coupon>> getInactiveCoupons() =>
      caller.callServerEndpoint<List<_i34.Coupon>>(
        'coupon',
        'getInactiveCoupons',
        {},
      );

  _i2.Future<List<_i34.Coupon>> fetchCoupons(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i34.Coupon>>(
    'coupon',
    'fetchCoupons',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> uploadCoupon(
    _i34.Coupon coupon,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
  }) => caller.callServerEndpoint<bool>(
    'coupon',
    'uploadCoupon',
    {
      'coupon': coupon,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
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
    _i34.Coupon coupon,
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

  _i2.Future<String> deleteCoupon(
    String code,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'coupon',
    'deleteCoupon',
    {
      'code': code,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkCouponDeleteImpact(
    String code,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'coupon',
    'checkCouponDeleteImpact',
    {
      'code': code,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteCoupon(
    String code,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'coupon',
    'hardDeleteCoupon',
    {
      'code': code,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i35.CouponDisplay>> fetchApplicableCoupons(
    double orderAmount,
  ) => caller.callServerEndpoint<List<_i35.CouponDisplay>>(
    'coupon',
    'fetchApplicableCoupons',
    {'orderAmount': orderAmount},
  );

  _i2.Future<_i36.CouponValidationResult> validateCoupon(
    String couponCode,
    double orderAmount,
  ) => caller.callServerEndpoint<_i36.CouponValidationResult>(
    'coupon',
    'validateCoupon',
    {
      'couponCode': couponCode,
      'orderAmount': orderAmount,
    },
  );

  _i2.Future<_i36.CouponValidationResult> applyCoupon(
    String userId,
    String couponCode,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i36.CouponValidationResult>(
    'coupon',
    'applyCoupon',
    {
      'userId': userId,
      'couponCode': couponCode,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<List<_i35.CouponDisplay>> getAvailableCoupons(
    String userId,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<List<_i35.CouponDisplay>>(
    'coupon',
    'getAvailableCoupons',
    {
      'userId': userId,
      'cartSubtotal': cartSubtotal,
      'cartItems': cartItems,
    },
  );

  _i2.Future<_i37.BestCouponResult> getBestCoupon(
    String userId,
    double cartSubtotal,
    List<_i19.CartItemInput> cartItems,
  ) => caller.callServerEndpoint<_i37.BestCouponResult>(
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

  _i2.Future<_i38.DeliveryConfig> getDeliveryConfig() =>
      caller.callServerEndpoint<_i38.DeliveryConfig>(
        'freeDelivery',
        'getDeliveryConfig',
        {},
      );

  _i2.Future<_i39.DeliveryPricingResult> getUserDeliveryOffer(String userId) =>
      caller.callServerEndpoint<_i39.DeliveryPricingResult>(
        'freeDelivery',
        'getUserDeliveryOffer',
        {'userId': userId},
      );

  _i2.Future<_i14.OfferMutationResult> setProductFreeDelivery(
    String productId,
    bool isFreeDelivery,
    String firebaseUid,
    String idToken, {
    required bool confirmDisableConflictingCombo,
    required bool forceDisableBogo,
  }) => caller.callServerEndpoint<_i14.OfferMutationResult>(
    'freeDelivery',
    'setProductFreeDelivery',
    {
      'productId': productId,
      'isFreeDelivery': isFreeDelivery,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'confirmDisableConflictingCombo': confirmDisableConflictingCombo,
      'forceDisableBogo': forceDisableBogo,
    },
  );

  _i2.Future<bool> upsertDeliveryConfig(
    _i38.DeliveryConfig config,
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

  _i2.Future<List<_i40.DeliveryRule>> getInactiveDeliveryRules() =>
      caller.callServerEndpoint<List<_i40.DeliveryRule>>(
        'freeDelivery',
        'getInactiveDeliveryRules',
        {},
      );

  _i2.Future<List<_i40.DeliveryRule>> getAllDeliveryRules(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i40.DeliveryRule>>(
    'freeDelivery',
    'getAllDeliveryRules',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i41.DeliveryRulePage> getDeliveryRulesPage(
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i41.DeliveryRulePage>(
    'freeDelivery',
    'getDeliveryRulesPage',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i42.FreeDeliveryHydrated> getFreeDeliveryHydrated(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i42.FreeDeliveryHydrated>(
    'freeDelivery',
    'getFreeDeliveryHydrated',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> upsertDeliveryRule(
    _i40.DeliveryRule rule,
    String firebaseUid,
    String idToken, {
    _i16.NotificationDraft? notificationDraft,
  }) => caller.callServerEndpoint<bool>(
    'freeDelivery',
    'upsertDeliveryRule',
    {
      'rule': rule,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'notificationDraft': notificationDraft,
    },
  );

  _i2.Future<String> deleteDeliveryRule(
    String ruleId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
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

  _i2.Future<_i39.DeliveryPricingResult> calculateDeliveryPricing(
    double cartTotal, {
    String? userId,
    String? location,
    List<_i19.CartItemInput>? cartItems,
  }) => caller.callServerEndpoint<_i39.DeliveryPricingResult>(
    'freeDelivery',
    'calculateDeliveryPricing',
    {
      'cartTotal': cartTotal,
      'userId': userId,
      'location': location,
      'cartItems': cartItems,
    },
  );
}

/// {@category Endpoint}
class EndpointHome extends _i1.EndpointRef {
  EndpointHome(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'home';

  _i2.Future<_i43.HomePageHydratedData> getHomePageHydrated({
    String? userId,
    required int productLimit,
    required int rankingLimit,
  }) => caller.callServerEndpoint<_i43.HomePageHydratedData>(
    'home',
    'getHomePageHydrated',
    {
      'userId': userId,
      'productLimit': productLimit,
      'rankingLimit': rankingLimit,
    },
  );
}

/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _i2.Future<bool> registerFcmToken(
    String firebaseUid,
    String token,
    String deviceId,
    String platform,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'registerFcmToken',
    {
      'firebaseUid': firebaseUid,
      'token': token,
      'deviceId': deviceId,
      'platform': platform,
    },
  );

  _i2.Future<bool> unregisterFcmToken(
    String firebaseUid,
    String deviceId, {
    String? token,
  }) => caller.callServerEndpoint<bool>(
    'notification',
    'unregisterFcmToken',
    {
      'firebaseUid': firebaseUid,
      'deviceId': deviceId,
      'token': token,
    },
  );

  _i2.Future<_i44.NotificationPreference> getPreferences(String firebaseUid) =>
      caller.callServerEndpoint<_i44.NotificationPreference>(
        'notification',
        'getPreferences',
        {'firebaseUid': firebaseUid},
      );

  _i2.Future<_i44.NotificationPreference> updatePreferences(
    String firebaseUid,
    _i44.NotificationPreference preferences,
  ) => caller.callServerEndpoint<_i44.NotificationPreference>(
    'notification',
    'updatePreferences',
    {
      'firebaseUid': firebaseUid,
      'preferences': preferences,
    },
  );

  _i2.Future<_i45.NotificationHistoryPage> listNotifications(
    String firebaseUid, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i45.NotificationHistoryPage>(
    'notification',
    'listNotifications',
    {
      'firebaseUid': firebaseUid,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> markNotificationRead(
    String firebaseUid,
    String campaignId,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'markNotificationRead',
    {
      'firebaseUid': firebaseUid,
      'campaignId': campaignId,
    },
  );

  _i2.Future<bool> deleteNotification(
    String firebaseUid,
    String campaignId,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'deleteNotification',
    {
      'firebaseUid': firebaseUid,
      'campaignId': campaignId,
    },
  );

  _i2.Future<bool> createAnnouncement(
    _i16.NotificationDraft draft,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'createAnnouncement',
    {
      'draft': draft,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i46.AdminNotificationPreference>>
  getAdminNotificationPreferences(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i46.AdminNotificationPreference>>(
    'notification',
    'getAdminNotificationPreferences',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i46.AdminNotificationPreference>
  updateAdminNotificationPreference(
    String firebaseUid,
    String idToken,
    String key,
    bool pushEnabled,
    bool soundEnabled,
  ) => caller.callServerEndpoint<_i46.AdminNotificationPreference>(
    'notification',
    'updateAdminNotificationPreference',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'key': key,
      'pushEnabled': pushEnabled,
      'soundEnabled': soundEnabled,
    },
  );

  _i2.Future<bool> registerAdminFcmToken(
    String firebaseUid,
    String idToken,
    String token,
    String deviceId,
    String platform,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'registerAdminFcmToken',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'token': token,
      'deviceId': deviceId,
      'platform': platform,
    },
  );

  _i2.Future<bool> unregisterAdminFcmToken(
    String firebaseUid,
    String idToken,
    String deviceId, {
    String? token,
  }) => caller.callServerEndpoint<bool>(
    'notification',
    'unregisterAdminFcmToken',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'deviceId': deviceId,
      'token': token,
    },
  );

  _i2.Future<_i47.BroadcastSummary> createBroadcast(
    _i48.BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i47.BroadcastSummary>(
    'notification',
    'createBroadcast',
    {
      'request': request,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i47.BroadcastSummary> saveBroadcastDraft(
    _i48.BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i47.BroadcastSummary>(
    'notification',
    'saveBroadcastDraft',
    {
      'request': request,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i47.BroadcastSummary> sendBroadcastDraft(
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) => caller.callServerEndpoint<_i47.BroadcastSummary>(
    'notification',
    'sendBroadcastDraft',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'broadcastId': broadcastId,
    },
  );

  _i2.Future<_i49.BroadcastPage> listBroadcasts(
    String firebaseUid,
    String idToken, {
    String? status,
    String? query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i49.BroadcastPage>(
    'notification',
    'listBroadcasts',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'status': status,
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<bool> deleteBroadcastDraft(
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'deleteBroadcastDraft',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'broadcastId': broadcastId,
    },
  );
}

/// {@category Endpoint}
class EndpointOrderDetail extends _i1.EndpointRef {
  EndpointOrderDetail(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'orderDetail';

  _i2.Future<_i50.OrderDetailHydrated> getOrderDetailHydrated(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i50.OrderDetailHydrated>(
    'orderDetail',
    'getOrderDetailHydrated',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );
}

/// {@category Endpoint}
class EndpointOrder extends _i1.EndpointRef {
  EndpointOrder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'order';

  _i2.Future<String> createOrder(_i26.Order order) =>
      caller.callServerEndpoint<String>(
        'order',
        'createOrder',
        {'order': order},
      );

  _i2.Future<String> createPendingOrder(
    _i26.Order order,
    String idempotencyKey,
  ) => caller.callServerEndpoint<String>(
    'order',
    'createPendingOrder',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<List<_i26.Order>> getOrders({
    String? status,
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<List<_i26.Order>>(
    'order',
    'getOrders',
    {
      'status': status,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i51.OrderPage> getOrdersPage({
    String? status,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i51.OrderPage>(
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

  _i2.Future<List<_i26.Order>> getTodayOrders(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<List<_i26.Order>>(
    'order',
    'getTodayOrders',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<List<_i26.Order>> getUserOrders(
    String userId,
    String idToken,
  ) => caller.callServerEndpoint<List<_i26.Order>>(
    'order',
    'getUserOrders',
    {
      'userId': userId,
      'idToken': idToken,
    },
  );

  _i2.Future<_i26.Order?> getOrderById(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i26.Order?>(
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

  _i2.Future<_i26.Order?> updateDeliveryAddress(
    String orderId,
    _i30.Address deliveryAddress,
    String firebaseUid,
    String idToken, {
    String? deliveryNote,
  }) => caller.callServerEndpoint<_i26.Order?>(
    'order',
    'updateDeliveryAddress',
    {
      'orderId': orderId,
      'deliveryAddress': deliveryAddress,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'deliveryNote': deliveryNote,
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

  _i2.Future<_i52.PaymentActionResult> cancelOrder(
    String orderId,
    String userId, {
    required String idToken,
    required String reason,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'order',
    'cancelOrder',
    {
      'orderId': orderId,
      'userId': userId,
      'idToken': idToken,
      'reason': reason,
    },
  );

  /// User requests cancellation for Stage 2/3 orders (needs admin approval).
  _i2.Future<_i52.PaymentActionResult> requestCancellation(
    String orderId,
    String userId, {
    required String idToken,
    required String reason,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'order',
    'requestCancellation',
    {
      'orderId': orderId,
      'userId': userId,
      'idToken': idToken,
      'reason': reason,
    },
  );

  /// Admin: List all cancellation requests.
  _i2.Future<_i51.OrderPage> listCancellationRequests({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i51.OrderPage>(
    'order',
    'listCancellationRequests',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  /// Admin: Approve cancellation request and initiate refund.
  _i2.Future<_i52.PaymentActionResult> approveCancellationRequest(
    String orderId, {
    required String firebaseUid,
    required String idToken,
    double? fixedRefundAmount,
    required String adminNote,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'order',
    'approveCancellationRequest',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'fixedRefundAmount': fixedRefundAmount,
      'adminNote': adminNote,
    },
  );

  /// Admin: Reject cancellation request and restore order.
  _i2.Future<_i52.PaymentActionResult> rejectCancellationRequest(
    String orderId, {
    required String firebaseUid,
    required String idToken,
    required String adminNote,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'order',
    'rejectCancellationRequest',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'adminNote': adminNote,
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

  _i2.Future<bool> generateDeliveryOtp(
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'generateDeliveryOtp',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> verifyDeliveryOtp(
    String orderId,
    String otp, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'verifyDeliveryOtp',
    {
      'orderId': orderId,
      'otp': otp,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> resendDeliveryOtp(
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<bool>(
    'order',
    'resendDeliveryOtp',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<Map<String, dynamic>?> getActiveDeliveryOtp(
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<Map<String, dynamic>?>(
    'order',
    'getActiveDeliveryOtp',
    {
      'orderId': orderId,
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
    _i26.Order order,
    String idempotencyKey,
  ) => caller.callServerEndpoint<String>(
    'orderPg',
    'createPendingOrder',
    {
      'order': order,
      'idempotencyKey': idempotencyKey,
    },
  );

  _i2.Future<_i51.OrderPage> getOrdersForUser({
    required String userReference,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i51.OrderPage>(
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

  _i2.Stream<_i53.OrderRealtimeEvent> watchAdminOrders(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i53.OrderRealtimeEvent>,
        _i53.OrderRealtimeEvent
      >(
        'orderRealtime',
        'watchAdminOrders',
        {
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Stream<_i53.OrderRealtimeEvent> watchDashboardUpdates(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i53.OrderRealtimeEvent>,
        _i53.OrderRealtimeEvent
      >(
        'orderRealtime',
        'watchDashboardUpdates',
        {
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Stream<_i53.OrderRealtimeEvent> watchUserOrders(
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i53.OrderRealtimeEvent>,
        _i53.OrderRealtimeEvent
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

  _i2.Future<_i54.OrderTrackingData?> getTrackingForUser(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i54.OrderTrackingData?>(
    'orderTracking',
    'getTrackingForUser',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i54.OrderTrackingData?> getTrackingForAdmin(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i54.OrderTrackingData?>(
    'orderTracking',
    'getTrackingForAdmin',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Stream<_i54.OrderTrackingData> streamTrackingForUser(
    String orderId,
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i54.OrderTrackingData>,
        _i54.OrderTrackingData
      >(
        'orderTracking',
        'streamTrackingForUser',
        {
          'orderId': orderId,
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Stream<_i54.OrderTrackingData> streamTrackingForAdmin(
    String orderId,
    String firebaseUid,
    String idToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i54.OrderTrackingData>,
        _i54.OrderTrackingData
      >(
        'orderTracking',
        'streamTrackingForAdmin',
        {
          'orderId': orderId,
          'firebaseUid': firebaseUid,
          'idToken': idToken,
        },
        {},
      );

  _i2.Future<_i54.OrderTrackingData> seedUserLocation(
    String orderId,
    String firebaseUid,
    String idToken,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
  ) => caller.callServerEndpoint<_i54.OrderTrackingData>(
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

  _i2.Future<_i54.OrderTrackingData> updateTrackingEnabled(
    String orderId,
    bool enabled,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i54.OrderTrackingData>(
    'orderTracking',
    'updateTrackingEnabled',
    {
      'orderId': orderId,
      'enabled': enabled,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i54.OrderTrackingData> updateRiderLocation(
    String orderId,
    double riderLatitude,
    double riderLongitude,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i54.OrderTrackingData>(
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

  _i2.Future<_i55.PaymentOrderResult> createPaymentOrder(
    String orderId,
    double amount,
    String customerPhone,
  ) => caller.callServerEndpoint<_i55.PaymentOrderResult>(
    'payment',
    'createPaymentOrder',
    {
      'orderId': orderId,
      'amount': amount,
      'customerPhone': customerPhone,
    },
  );

  _i2.Future<_i56.PaymentVerifyResult> verifyPayment(
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) => caller.callServerEndpoint<_i56.PaymentVerifyResult>(
    'payment',
    'verifyPayment',
    {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    },
  );

  _i2.Future<_i52.PaymentActionResult> markPaymentFailed(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'payment',
    'markPaymentFailed',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i52.PaymentActionResult> initiateRefund(
    String razorpayPaymentId,
    double amount,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'payment',
    'initiateRefund',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'amount': amount,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i52.PaymentActionResult> getPaymentStatus(
    String razorpayPaymentId,
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'payment',
    'getPaymentStatus',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i56.PaymentVerifyResult> completePaymentVerification(
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
  ) => caller.callServerEndpoint<_i56.PaymentVerifyResult>(
    'payment',
    'completePaymentVerification',
    {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
    },
  );

  _i2.Future<_i52.PaymentActionResult> getPaymentStatusWithMessage(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'payment',
    'getPaymentStatusWithMessage',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i52.PaymentActionResult> adminReconcileAllPendingPayments({
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
    'payment',
    'adminReconcileAllPendingPayments',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<Map<String, dynamic>> adminGetPaymentDetail(
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'payment',
    'adminGetPaymentDetail',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i51.OrderPage> adminSearchOrders({
    String? query,
    String? status,
    String? paymentStatus,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i51.OrderPage>(
    'payment',
    'adminSearchOrders',
    {
      'query': query,
      'status': status,
      'paymentStatus': paymentStatus,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<Map<String, dynamic>> adminGetLivePaymentStatus(
    String razorpayPaymentId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'payment',
    'adminGetLivePaymentStatus',
    {
      'razorpayPaymentId': razorpayPaymentId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<Map<String, dynamic>> adminGetRefundDetail(
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'payment',
    'adminGetRefundDetail',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i52.PaymentActionResult> recoverPendingPayments(
    String userId, {
    required String idToken,
    required int limit,
  }) => caller.callServerEndpoint<_i52.PaymentActionResult>(
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

  _i2.Future<_i57.CartPricingResult> calculateCartPricing(
    List<_i19.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    required bool autoApplyCoupons,
  }) => caller.callServerEndpoint<_i57.CartPricingResult>(
    'pricing',
    'calculateCartPricing',
    {
      'items': items,
      'userId': userId,
      'appliedCouponCode': appliedCouponCode,
      'autoApplyCoupons': autoApplyCoupons,
    },
  );

  _i2.Future<List<_i58.AppliedOfferInfo>> getApplicableOffers(
    List<_i19.CartItemInput> items,
  ) => caller.callServerEndpoint<List<_i58.AppliedOfferInfo>>(
    'pricing',
    'getApplicableOffers',
    {'items': items},
  );

  _i2.Future<_i59.BasketSuggestionResult> basketSuggestions(
    List<_i19.CartItemInput>? items, {
    double? cartTotal,
    required String mode,
    String? userId,
    String? appliedCouponCode,
  }) => caller.callServerEndpoint<_i59.BasketSuggestionResult>(
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

  _i2.Future<List<_i60.Product>> getProductsByIds(List<String> productIds) =>
      caller.callServerEndpoint<List<_i60.Product>>(
        'product',
        'getProductsByIds',
        {'productIds': productIds},
      );

  _i2.Future<List<_i60.Product>> getProducts({
    required int limit,
    String? lastProductName,
    String? lastProductId,
    String? category,
    List<String>? subcategories,
    required String sortBy,
    bool? freeDelivery,
  }) => caller.callServerEndpoint<List<_i60.Product>>(
    'product',
    'getProducts',
    {
      'limit': limit,
      'lastProductName': lastProductName,
      'lastProductId': lastProductId,
      'category': category,
      'subcategories': subcategories,
      'sortBy': sortBy,
      'freeDelivery': freeDelivery,
    },
  );

  _i2.Future<_i61.ProductPage> getProductsPage({
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<_i61.ProductPage>(
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

  _i2.Future<_i61.ProductPage> getInactiveProductsPage({
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) => caller.callServerEndpoint<_i61.ProductPage>(
    'product',
    'getInactiveProductsPage',
    {
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
    _i60.Product product,
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

  _i2.Future<_i60.Product?> updateProduct(
    _i60.Product product,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i60.Product?>(
    'product',
    'updateProduct',
    {
      'product': product,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<String> checkProductUpdateConflicts(
    _i60.Product product,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'product',
    'checkProductUpdateConflicts',
    {
      'product': product,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<String> deleteProduct(
    String productId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
    'product',
    'deleteProduct',
    {
      'productId': productId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i12.DeleteImpactResponse> checkProductDeleteImpact(
    String productId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i12.DeleteImpactResponse>(
    'product',
    'checkProductDeleteImpact',
    {
      'productId': productId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i13.HardDeleteResponse> hardDeleteProduct(
    String productId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i13.HardDeleteResponse>(
    'product',
    'hardDeleteProduct',
    {
      'productId': productId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<bool> deactivateProduct(
    String productId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<bool>(
    'product',
    'deactivateProduct',
    {
      'productId': productId,
      'isActive': isActive,
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

  _i2.Future<_i61.ProductPage> searchProducts(
    String query, {
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i61.ProductPage>(
    'product',
    'searchProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i62.OfferSearchPage> getProductsByOffer({
    required String offerType,
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i62.OfferSearchPage>(
    'product',
    'getProductsByOffer',
    {
      'offerType': offerType,
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i62.OfferSearchPage> getComboProducts({
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i62.OfferSearchPage>(
    'product',
    'getComboProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i62.OfferSearchPage> getBogoProducts({
    required String query,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i62.OfferSearchPage>(
    'product',
    'getBogoProducts',
    {
      'query': query,
      'limit': limit,
      'pageToken': pageToken,
    },
  );

  _i2.Future<_i62.OfferSearchPage> searchProductsWithOfferFilters({
    required String query,
    required String offerFilter,
    required int limit,
    String? pageToken,
  }) => caller.callServerEndpoint<_i62.OfferSearchPage>(
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
class EndpointProductForm extends _i1.EndpointRef {
  EndpointProductForm(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'productForm';

  _i2.Future<_i63.ProductFormReferenceData> getProductFormReferenceData(
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i63.ProductFormReferenceData>(
    'productForm',
    'getProductFormReferenceData',
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

  _i2.Future<_i61.ProductPage> getActiveProductsPage({
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
  }) => caller.callServerEndpoint<_i61.ProductPage>(
    'productPg',
    'getActiveProductsPage',
    {
      'limit': limit,
      'pageToken': pageToken,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
    },
  );

  _i2.Future<_i61.ProductPage> searchActiveProducts({
    required String query,
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
    required double similarityThreshold,
  }) => caller.callServerEndpoint<_i61.ProductPage>(
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

  _i2.Future<List<_i64.ProductRankingItem>> getTrendingProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i64.ProductRankingItem>>(
    'productRanking',
    'getTrendingProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i64.ProductRankingItem>> getMostSellingProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i64.ProductRankingItem>>(
    'productRanking',
    'getMostSellingProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i64.ProductRankingItem>> getMostViewedProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i64.ProductRankingItem>>(
    'productRanking',
    'getMostViewedProducts',
    {'limit': limit},
  );

  _i2.Future<List<_i64.ProductRankingItem>> getFrequentlyReorderedProducts({
    required int limit,
  }) => caller.callServerEndpoint<List<_i64.ProductRankingItem>>(
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

  _i2.Future<_i33.RefundRecord> initiateRefund(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.RefundRecord>(
    'refund',
    'initiateRefund',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i33.RefundRecord?> getRefundStatus(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.RefundRecord?>(
    'refund',
    'getRefundStatus',
    {
      'orderId': orderId,
      'firebaseUid': firebaseUid,
      'idToken': idToken,
    },
  );

  _i2.Future<_i33.RefundRecord?> adminGetRefundStatus(
    String orderId,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<_i33.RefundRecord?>(
    'refund',
    'adminGetRefundStatus',
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

  _i2.Future<List<_i65.SubCategory>> getSubCategories() =>
      caller.callServerEndpoint<List<_i65.SubCategory>>(
        'subCategory',
        'getSubCategories',
        {},
      );

  _i2.Future<bool> uploadSubCategory(
    _i65.SubCategory subCategory,
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
    _i65.SubCategory subCategory,
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

  _i2.Future<String> deleteSubCategory(
    String categoryName,
    String subCategoryName,
    String firebaseUid,
    String idToken,
  ) => caller.callServerEndpoint<String>(
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
class EndpointSupport extends _i1.EndpointRef {
  EndpointSupport(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'support';

  _i2.Future<_i66.SupportIssue> submitIssue({
    required String firebaseUid,
    required String idToken,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
  }) => caller.callServerEndpoint<_i66.SupportIssue>(
    'support',
    'submitIssue',
    {
      'firebaseUid': firebaseUid,
      'idToken': idToken,
      'issueType': issueType,
      'title': title,
      'description': description,
      'screenshotUrl': screenshotUrl,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'deviceInfo': deviceInfo,
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
    List<_i67.CartItem> cart,
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
    serverpod_auth_idp = _i68.Caller(client);
    serverpod_auth_core = _i69.Caller(client);
  }

  late final _i68.Caller serverpod_auth_idp;

  late final _i69.Caller serverpod_auth_core;
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
         _i70.Protocol(),
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
    cart = EndpointCart(this);
    category = EndpointCategory(this);
    categoryOffer = EndpointCategoryOffer(this);
    checkout = EndpointCheckout(this);
    comboOffer = EndpointComboOffer(this);
    complaint = EndpointComplaint(this);
    coupon = EndpointCoupon(this);
    freeDelivery = EndpointFreeDelivery(this);
    home = EndpointHome(this);
    notification = EndpointNotification(this);
    orderDetail = EndpointOrderDetail(this);
    order = EndpointOrder(this);
    orderPg = EndpointOrderPg(this);
    orderRealtime = EndpointOrderRealtime(this);
    orderTracking = EndpointOrderTracking(this);
    payment = EndpointPayment(this);
    pricing = EndpointPricing(this);
    product = EndpointProduct(this);
    productForm = EndpointProductForm(this);
    productPg = EndpointProductPg(this);
    productRanking = EndpointProductRanking(this);
    refund = EndpointRefund(this);
    subCategory = EndpointSubCategory(this);
    support = EndpointSupport(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAuth auth;

  late final EndpointBanner banner;

  late final EndpointBogo bogo;

  late final EndpointCart cart;

  late final EndpointCategory category;

  late final EndpointCategoryOffer categoryOffer;

  late final EndpointCheckout checkout;

  late final EndpointComboOffer comboOffer;

  late final EndpointComplaint complaint;

  late final EndpointCoupon coupon;

  late final EndpointFreeDelivery freeDelivery;

  late final EndpointHome home;

  late final EndpointNotification notification;

  late final EndpointOrderDetail orderDetail;

  late final EndpointOrder order;

  late final EndpointOrderPg orderPg;

  late final EndpointOrderRealtime orderRealtime;

  late final EndpointOrderTracking orderTracking;

  late final EndpointPayment payment;

  late final EndpointPricing pricing;

  late final EndpointProduct product;

  late final EndpointProductForm productForm;

  late final EndpointProductPg productPg;

  late final EndpointProductRanking productRanking;

  late final EndpointRefund refund;

  late final EndpointSubCategory subCategory;

  late final EndpointSupport support;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'admin': admin,
    'auth': auth,
    'banner': banner,
    'bogo': bogo,
    'cart': cart,
    'category': category,
    'categoryOffer': categoryOffer,
    'checkout': checkout,
    'comboOffer': comboOffer,
    'complaint': complaint,
    'coupon': coupon,
    'freeDelivery': freeDelivery,
    'home': home,
    'notification': notification,
    'orderDetail': orderDetail,
    'order': order,
    'orderPg': orderPg,
    'orderRealtime': orderRealtime,
    'orderTracking': orderTracking,
    'payment': payment,
    'pricing': pricing,
    'product': product,
    'productForm': productForm,
    'productPg': productPg,
    'productRanking': productRanking,
    'refund': refund,
    'subCategory': subCategory,
    'support': support,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
