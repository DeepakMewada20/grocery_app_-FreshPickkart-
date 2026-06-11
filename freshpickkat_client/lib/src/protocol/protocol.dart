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
import 'active_user_statistics.dart' as _i2;
import 'address.dart' as _i3;
import 'admin_analytics.dart' as _i4;
import 'admin_audit_log_entry.dart' as _i5;
import 'admin_auth_result.dart' as _i6;
import 'admin_dashboard_hydrated.dart' as _i7;
import 'admin_dashboard_stats.dart' as _i8;
import 'admin_notification_preference.dart' as _i9;
import 'admin_top_product.dart' as _i10;
import 'api_response.dart' as _i11;
import 'app_user.dart' as _i12;
import 'applied_coupon_info.dart' as _i13;
import 'applied_offer_info.dart' as _i14;
import 'banner.dart' as _i15;
import 'banner_page.dart' as _i16;
import 'basket_suggestion.dart' as _i17;
import 'basket_suggestion_action.dart' as _i18;
import 'basket_suggestion_result.dart' as _i19;
import 'best_coupon_result.dart' as _i20;
import 'bogo_free_product.dart' as _i21;
import 'bogo_offer.dart' as _i22;
import 'bogo_offer_page.dart' as _i23;
import 'broadcast_page.dart' as _i24;
import 'broadcast_request.dart' as _i25;
import 'broadcast_summary.dart' as _i26;
import 'cart_hydrated_data.dart' as _i27;
import 'cart_item.dart' as _i28;
import 'cart_item_input.dart' as _i29;
import 'cart_pricing_result.dart' as _i30;
import 'category.dart' as _i31;
import 'category_hierarchy.dart' as _i32;
import 'category_offer.dart' as _i33;
import 'category_offer_page.dart' as _i34;
import 'checkout_result.dart' as _i35;
import 'combo_offer.dart' as _i36;
import 'combo_offer_page.dart' as _i37;
import 'combo_product_item.dart' as _i38;
import 'complaint.dart' as _i39;
import 'complaint_page.dart' as _i40;
import 'complaint_product_item.dart' as _i41;
import 'coupon.dart' as _i42;
import 'coupon_display.dart' as _i43;
import 'coupon_validation_result.dart' as _i44;
import 'delivery_config.dart' as _i45;
import 'delivery_pricing_result.dart' as _i46;
import 'delivery_rule.dart' as _i47;
import 'delivery_rule_page.dart' as _i48;
import 'delivery_slab.dart' as _i49;
import 'free_delivery_hydrated.dart' as _i50;
import 'free_delivery_rule.dart' as _i51;
import 'free_delivery_rule_page.dart' as _i52;
import 'free_item_info.dart' as _i53;
import 'home_page_hydrated_data.dart' as _i54;
import 'notification_draft.dart' as _i55;
import 'notification_history_item.dart' as _i56;
import 'notification_history_page.dart' as _i57;
import 'notification_preference.dart' as _i58;
import 'offer_conflict_response.dart' as _i59;
import 'offer_mutation_result.dart' as _i60;
import 'offer_search_item.dart' as _i61;
import 'offer_search_page.dart' as _i62;
import 'order.dart' as _i63;
import 'order_detail_hydrated.dart' as _i64;
import 'order_item.dart' as _i65;
import 'order_page.dart' as _i66;
import 'order_realtime_event.dart' as _i67;
import 'order_tracking_data.dart' as _i68;
import 'payment_action_result.dart' as _i69;
import 'payment_order_result.dart' as _i70;
import 'payment_verify_result.dart' as _i71;
import 'pricing_line_item.dart' as _i72;
import 'product.dart' as _i73;
import 'product_form_reference_data.dart' as _i74;
import 'product_page.dart' as _i75;
import 'product_ranking_item.dart' as _i76;
import 'product_variant.dart' as _i77;
import 'refund_record.dart' as _i78;
import 'register_fcm_token_request.dart' as _i79;
import 'sub_category.dart' as _i80;
import 'support_issue.dart' as _i81;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i82;
import 'package:freshpickkat_client/src/protocol/admin_audit_log_entry.dart'
    as _i83;
import 'package:freshpickkat_client/src/protocol/active_user_statistics.dart'
    as _i84;
import 'package:freshpickkat_client/src/protocol/banner.dart' as _i85;
import 'package:freshpickkat_client/src/protocol/bogo_offer.dart' as _i86;
import 'package:freshpickkat_client/src/protocol/cart_item_input.dart' as _i87;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i88;
import 'package:freshpickkat_client/src/protocol/category_offer.dart' as _i89;
import 'package:freshpickkat_client/src/protocol/combo_offer.dart' as _i90;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i91;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i92;
import 'package:freshpickkat_client/src/protocol/delivery_rule.dart' as _i93;
import 'package:freshpickkat_client/src/protocol/admin_notification_preference.dart'
    as _i94;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i95;
import 'package:freshpickkat_client/src/protocol/applied_offer_info.dart'
    as _i96;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i97;
import 'package:freshpickkat_client/src/protocol/product_ranking_item.dart'
    as _i98;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i99;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i100;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i101;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i102;
export 'active_user_statistics.dart';
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_auth_result.dart';
export 'admin_dashboard_hydrated.dart';
export 'admin_dashboard_stats.dart';
export 'admin_notification_preference.dart';
export 'admin_top_product.dart';
export 'api_response.dart';
export 'app_user.dart';
export 'applied_coupon_info.dart';
export 'applied_offer_info.dart';
export 'banner.dart';
export 'banner_page.dart';
export 'basket_suggestion.dart';
export 'basket_suggestion_action.dart';
export 'basket_suggestion_result.dart';
export 'best_coupon_result.dart';
export 'bogo_free_product.dart';
export 'bogo_offer.dart';
export 'bogo_offer_page.dart';
export 'broadcast_page.dart';
export 'broadcast_request.dart';
export 'broadcast_summary.dart';
export 'cart_hydrated_data.dart';
export 'cart_item.dart';
export 'cart_item_input.dart';
export 'cart_pricing_result.dart';
export 'category.dart';
export 'category_hierarchy.dart';
export 'category_offer.dart';
export 'category_offer_page.dart';
export 'checkout_result.dart';
export 'combo_offer.dart';
export 'combo_offer_page.dart';
export 'combo_product_item.dart';
export 'complaint.dart';
export 'complaint_page.dart';
export 'complaint_product_item.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_validation_result.dart';
export 'delivery_config.dart';
export 'delivery_pricing_result.dart';
export 'delivery_rule.dart';
export 'delivery_rule_page.dart';
export 'delivery_slab.dart';
export 'free_delivery_hydrated.dart';
export 'free_delivery_rule.dart';
export 'free_delivery_rule_page.dart';
export 'free_item_info.dart';
export 'home_page_hydrated_data.dart';
export 'notification_draft.dart';
export 'notification_history_item.dart';
export 'notification_history_page.dart';
export 'notification_preference.dart';
export 'offer_conflict_response.dart';
export 'offer_mutation_result.dart';
export 'offer_search_item.dart';
export 'offer_search_page.dart';
export 'order.dart';
export 'order_detail_hydrated.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_realtime_event.dart';
export 'order_tracking_data.dart';
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_verify_result.dart';
export 'pricing_line_item.dart';
export 'product.dart';
export 'product_form_reference_data.dart';
export 'product_page.dart';
export 'product_ranking_item.dart';
export 'product_variant.dart';
export 'refund_record.dart';
export 'register_fcm_token_request.dart';
export 'sub_category.dart';
export 'support_issue.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ActiveUserStatistics) {
      return _i2.ActiveUserStatistics.fromJson(data) as T;
    }
    if (t == _i3.Address) {
      return _i3.Address.fromJson(data) as T;
    }
    if (t == _i4.AdminAnalytics) {
      return _i4.AdminAnalytics.fromJson(data) as T;
    }
    if (t == _i5.AdminAuditLogEntry) {
      return _i5.AdminAuditLogEntry.fromJson(data) as T;
    }
    if (t == _i6.AdminAuthResult) {
      return _i6.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i7.AdminDashboardHydrated) {
      return _i7.AdminDashboardHydrated.fromJson(data) as T;
    }
    if (t == _i8.AdminDashboardStats) {
      return _i8.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i9.AdminNotificationPreference) {
      return _i9.AdminNotificationPreference.fromJson(data) as T;
    }
    if (t == _i10.AdminTopProduct) {
      return _i10.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i11.ApiResponse) {
      return _i11.ApiResponse.fromJson(data) as T;
    }
    if (t == _i12.AppUser) {
      return _i12.AppUser.fromJson(data) as T;
    }
    if (t == _i13.AppliedCouponInfo) {
      return _i13.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i14.AppliedOfferInfo) {
      return _i14.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i15.Banner) {
      return _i15.Banner.fromJson(data) as T;
    }
    if (t == _i16.BannerPage) {
      return _i16.BannerPage.fromJson(data) as T;
    }
    if (t == _i17.BasketSuggestion) {
      return _i17.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i18.BasketSuggestionAction) {
      return _i18.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i19.BasketSuggestionResult) {
      return _i19.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i20.BestCouponResult) {
      return _i20.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i21.BogoFreeProduct) {
      return _i21.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i22.BogoOffer) {
      return _i22.BogoOffer.fromJson(data) as T;
    }
    if (t == _i23.BogoOfferPage) {
      return _i23.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i24.BroadcastPage) {
      return _i24.BroadcastPage.fromJson(data) as T;
    }
    if (t == _i25.BroadcastRequest) {
      return _i25.BroadcastRequest.fromJson(data) as T;
    }
    if (t == _i26.BroadcastSummary) {
      return _i26.BroadcastSummary.fromJson(data) as T;
    }
    if (t == _i27.CartHydratedData) {
      return _i27.CartHydratedData.fromJson(data) as T;
    }
    if (t == _i28.CartItem) {
      return _i28.CartItem.fromJson(data) as T;
    }
    if (t == _i29.CartItemInput) {
      return _i29.CartItemInput.fromJson(data) as T;
    }
    if (t == _i30.CartPricingResult) {
      return _i30.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i31.Category) {
      return _i31.Category.fromJson(data) as T;
    }
    if (t == _i32.CategoryHierarchy) {
      return _i32.CategoryHierarchy.fromJson(data) as T;
    }
    if (t == _i33.CategoryOffer) {
      return _i33.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i34.CategoryOfferPage) {
      return _i34.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i35.CheckoutResult) {
      return _i35.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i36.ComboOffer) {
      return _i36.ComboOffer.fromJson(data) as T;
    }
    if (t == _i37.ComboOfferPage) {
      return _i37.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i38.ComboProductItem) {
      return _i38.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i39.Complaint) {
      return _i39.Complaint.fromJson(data) as T;
    }
    if (t == _i40.ComplaintPage) {
      return _i40.ComplaintPage.fromJson(data) as T;
    }
    if (t == _i41.ComplaintProductItem) {
      return _i41.ComplaintProductItem.fromJson(data) as T;
    }
    if (t == _i42.Coupon) {
      return _i42.Coupon.fromJson(data) as T;
    }
    if (t == _i43.CouponDisplay) {
      return _i43.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i44.CouponValidationResult) {
      return _i44.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i45.DeliveryConfig) {
      return _i45.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i46.DeliveryPricingResult) {
      return _i46.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i47.DeliveryRule) {
      return _i47.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i48.DeliveryRulePage) {
      return _i48.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i49.DeliverySlab) {
      return _i49.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i50.FreeDeliveryHydrated) {
      return _i50.FreeDeliveryHydrated.fromJson(data) as T;
    }
    if (t == _i51.FreeDeliveryRule) {
      return _i51.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i52.FreeDeliveryRulePage) {
      return _i52.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i53.FreeItemInfo) {
      return _i53.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i54.HomePageHydratedData) {
      return _i54.HomePageHydratedData.fromJson(data) as T;
    }
    if (t == _i55.NotificationDraft) {
      return _i55.NotificationDraft.fromJson(data) as T;
    }
    if (t == _i56.NotificationHistoryItem) {
      return _i56.NotificationHistoryItem.fromJson(data) as T;
    }
    if (t == _i57.NotificationHistoryPage) {
      return _i57.NotificationHistoryPage.fromJson(data) as T;
    }
    if (t == _i58.NotificationPreference) {
      return _i58.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i59.OfferConflictResponse) {
      return _i59.OfferConflictResponse.fromJson(data) as T;
    }
    if (t == _i60.OfferMutationResult) {
      return _i60.OfferMutationResult.fromJson(data) as T;
    }
    if (t == _i61.OfferSearchItem) {
      return _i61.OfferSearchItem.fromJson(data) as T;
    }
    if (t == _i62.OfferSearchPage) {
      return _i62.OfferSearchPage.fromJson(data) as T;
    }
    if (t == _i63.Order) {
      return _i63.Order.fromJson(data) as T;
    }
    if (t == _i64.OrderDetailHydrated) {
      return _i64.OrderDetailHydrated.fromJson(data) as T;
    }
    if (t == _i65.OrderItem) {
      return _i65.OrderItem.fromJson(data) as T;
    }
    if (t == _i66.OrderPage) {
      return _i66.OrderPage.fromJson(data) as T;
    }
    if (t == _i67.OrderRealtimeEvent) {
      return _i67.OrderRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i68.OrderTrackingData) {
      return _i68.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i69.PaymentActionResult) {
      return _i69.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i70.PaymentOrderResult) {
      return _i70.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i71.PaymentVerifyResult) {
      return _i71.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i72.PricingLineItem) {
      return _i72.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i73.Product) {
      return _i73.Product.fromJson(data) as T;
    }
    if (t == _i74.ProductFormReferenceData) {
      return _i74.ProductFormReferenceData.fromJson(data) as T;
    }
    if (t == _i75.ProductPage) {
      return _i75.ProductPage.fromJson(data) as T;
    }
    if (t == _i76.ProductRankingItem) {
      return _i76.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i77.ProductVariant) {
      return _i77.ProductVariant.fromJson(data) as T;
    }
    if (t == _i78.RefundRecord) {
      return _i78.RefundRecord.fromJson(data) as T;
    }
    if (t == _i79.RegisterFcmTokenRequest) {
      return _i79.RegisterFcmTokenRequest.fromJson(data) as T;
    }
    if (t == _i80.SubCategory) {
      return _i80.SubCategory.fromJson(data) as T;
    }
    if (t == _i81.SupportIssue) {
      return _i81.SupportIssue.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ActiveUserStatistics?>()) {
      return (data != null ? _i2.ActiveUserStatistics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.Address?>()) {
      return (data != null ? _i3.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdminAnalytics?>()) {
      return (data != null ? _i4.AdminAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AdminAuditLogEntry?>()) {
      return (data != null ? _i5.AdminAuditLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminAuthResult?>()) {
      return (data != null ? _i6.AdminAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminDashboardHydrated?>()) {
      return (data != null ? _i7.AdminDashboardHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.AdminDashboardStats?>()) {
      return (data != null ? _i8.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.AdminNotificationPreference?>()) {
      return (data != null
              ? _i9.AdminNotificationPreference.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.AdminTopProduct?>()) {
      return (data != null ? _i10.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ApiResponse?>()) {
      return (data != null ? _i11.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.AppUser?>()) {
      return (data != null ? _i12.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.AppliedCouponInfo?>()) {
      return (data != null ? _i13.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AppliedOfferInfo?>()) {
      return (data != null ? _i14.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Banner?>()) {
      return (data != null ? _i15.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BannerPage?>()) {
      return (data != null ? _i16.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BasketSuggestion?>()) {
      return (data != null ? _i17.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.BasketSuggestionAction?>()) {
      return (data != null ? _i18.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.BasketSuggestionResult?>()) {
      return (data != null ? _i19.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.BestCouponResult?>()) {
      return (data != null ? _i20.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BogoFreeProduct?>()) {
      return (data != null ? _i21.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.BogoOffer?>()) {
      return (data != null ? _i22.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.BogoOfferPage?>()) {
      return (data != null ? _i23.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BroadcastPage?>()) {
      return (data != null ? _i24.BroadcastPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BroadcastRequest?>()) {
      return (data != null ? _i25.BroadcastRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BroadcastSummary?>()) {
      return (data != null ? _i26.BroadcastSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.CartHydratedData?>()) {
      return (data != null ? _i27.CartHydratedData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.CartItem?>()) {
      return (data != null ? _i28.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.CartItemInput?>()) {
      return (data != null ? _i29.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CartPricingResult?>()) {
      return (data != null ? _i30.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Category?>()) {
      return (data != null ? _i31.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CategoryHierarchy?>()) {
      return (data != null ? _i32.CategoryHierarchy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.CategoryOffer?>()) {
      return (data != null ? _i33.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CategoryOfferPage?>()) {
      return (data != null ? _i34.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CheckoutResult?>()) {
      return (data != null ? _i35.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.ComboOffer?>()) {
      return (data != null ? _i36.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ComboOfferPage?>()) {
      return (data != null ? _i37.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.ComboProductItem?>()) {
      return (data != null ? _i38.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.Complaint?>()) {
      return (data != null ? _i39.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.ComplaintPage?>()) {
      return (data != null ? _i40.ComplaintPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.ComplaintProductItem?>()) {
      return (data != null ? _i41.ComplaintProductItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.Coupon?>()) {
      return (data != null ? _i42.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.CouponDisplay?>()) {
      return (data != null ? _i43.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.CouponValidationResult?>()) {
      return (data != null ? _i44.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.DeliveryConfig?>()) {
      return (data != null ? _i45.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.DeliveryPricingResult?>()) {
      return (data != null ? _i46.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.DeliveryRule?>()) {
      return (data != null ? _i47.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.DeliveryRulePage?>()) {
      return (data != null ? _i48.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.DeliverySlab?>()) {
      return (data != null ? _i49.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.FreeDeliveryHydrated?>()) {
      return (data != null ? _i50.FreeDeliveryHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.FreeDeliveryRule?>()) {
      return (data != null ? _i51.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.FreeDeliveryRulePage?>()) {
      return (data != null ? _i52.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.FreeItemInfo?>()) {
      return (data != null ? _i53.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.HomePageHydratedData?>()) {
      return (data != null ? _i54.HomePageHydratedData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.NotificationDraft?>()) {
      return (data != null ? _i55.NotificationDraft.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.NotificationHistoryItem?>()) {
      return (data != null ? _i56.NotificationHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.NotificationHistoryPage?>()) {
      return (data != null ? _i57.NotificationHistoryPage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.NotificationPreference?>()) {
      return (data != null ? _i58.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.OfferConflictResponse?>()) {
      return (data != null ? _i59.OfferConflictResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.OfferMutationResult?>()) {
      return (data != null ? _i60.OfferMutationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.OfferSearchItem?>()) {
      return (data != null ? _i61.OfferSearchItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.OfferSearchPage?>()) {
      return (data != null ? _i62.OfferSearchPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.Order?>()) {
      return (data != null ? _i63.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.OrderDetailHydrated?>()) {
      return (data != null ? _i64.OrderDetailHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.OrderItem?>()) {
      return (data != null ? _i65.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.OrderPage?>()) {
      return (data != null ? _i66.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.OrderRealtimeEvent?>()) {
      return (data != null ? _i67.OrderRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.OrderTrackingData?>()) {
      return (data != null ? _i68.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.PaymentActionResult?>()) {
      return (data != null ? _i69.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.PaymentOrderResult?>()) {
      return (data != null ? _i70.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.PaymentVerifyResult?>()) {
      return (data != null ? _i71.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.PricingLineItem?>()) {
      return (data != null ? _i72.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.Product?>()) {
      return (data != null ? _i73.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.ProductFormReferenceData?>()) {
      return (data != null
              ? _i74.ProductFormReferenceData.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i75.ProductPage?>()) {
      return (data != null ? _i75.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.ProductRankingItem?>()) {
      return (data != null ? _i76.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.ProductVariant?>()) {
      return (data != null ? _i77.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.RefundRecord?>()) {
      return (data != null ? _i78.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.RegisterFcmTokenRequest?>()) {
      return (data != null ? _i79.RegisterFcmTokenRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.SubCategory?>()) {
      return (data != null ? _i80.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.SupportIssue?>()) {
      return (data != null ? _i81.SupportIssue.fromJson(data) : null) as T;
    }
    if (t == List<_i10.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.CartItem>) {
      return (data as List).map((e) => deserialize<_i28.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i28.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i28.CartItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i15.Banner>) {
      return (data as List).map((e) => deserialize<_i15.Banner>(e)).toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i18.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i18.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i18.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i18.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i17.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i17.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i21.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i21.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i21.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i21.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i22.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i22.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i26.BroadcastSummary>) {
      return (data as List)
              .map((e) => deserialize<_i26.BroadcastSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i43.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i14.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i53.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i53.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i72.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i72.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.Category>) {
      return (data as List).map((e) => deserialize<_i31.Category>(e)).toList()
          as T;
    }
    if (t == List<_i80.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i80.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i33.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i38.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i36.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i41.ComplaintProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i41.ComplaintProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.Complaint>) {
      return (data as List).map((e) => deserialize<_i39.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i49.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i49.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i47.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i51.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.Product>) {
      return (data as List).map((e) => deserialize<_i73.Product>(e)).toList()
          as T;
    }
    if (t == List<_i56.NotificationHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i56.NotificationHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i73.Product>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i73.Product>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i61.OfferSearchItem>) {
      return (data as List)
              .map((e) => deserialize<_i61.OfferSearchItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.OrderItem>) {
      return (data as List).map((e) => deserialize<_i65.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i63.Order>) {
      return (data as List).map((e) => deserialize<_i63.Order>(e)).toList()
          as T;
    }
    if (t == List<_i77.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i77.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i77.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i77.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i82.AppUser>) {
      return (data as List).map((e) => deserialize<_i82.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i83.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i83.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.ActiveUserStatistics>) {
      return (data as List)
              .map((e) => deserialize<_i84.ActiveUserStatistics>(e))
              .toList()
          as T;
    }
    if (t == List<_i85.Banner>) {
      return (data as List).map((e) => deserialize<_i85.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i86.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i86.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i87.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i87.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.Category>) {
      return (data as List).map((e) => deserialize<_i88.Category>(e)).toList()
          as T;
    }
    if (t == List<_i89.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i89.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i90.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i90.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i91.Coupon>) {
      return (data as List).map((e) => deserialize<_i91.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i92.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i92.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i93.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i93.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i87.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i87.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i94.AdminNotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i94.AdminNotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i95.Order>) {
      return (data as List).map((e) => deserialize<_i95.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, dynamic>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
                )
              : null)
          as T;
    }
    if (t == List<List<double>>) {
      return (data as List).map((e) => deserialize<List<double>>(e)).toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i96.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i96.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i97.Product>) {
      return (data as List).map((e) => deserialize<_i97.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i98.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i98.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i99.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i99.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i100.CartItem>) {
      return (data as List).map((e) => deserialize<_i100.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i101.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i102.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ActiveUserStatistics => 'ActiveUserStatistics',
      _i3.Address => 'Address',
      _i4.AdminAnalytics => 'AdminAnalytics',
      _i5.AdminAuditLogEntry => 'AdminAuditLogEntry',
      _i6.AdminAuthResult => 'AdminAuthResult',
      _i7.AdminDashboardHydrated => 'AdminDashboardHydrated',
      _i8.AdminDashboardStats => 'AdminDashboardStats',
      _i9.AdminNotificationPreference => 'AdminNotificationPreference',
      _i10.AdminTopProduct => 'AdminTopProduct',
      _i11.ApiResponse => 'ApiResponse',
      _i12.AppUser => 'AppUser',
      _i13.AppliedCouponInfo => 'AppliedCouponInfo',
      _i14.AppliedOfferInfo => 'AppliedOfferInfo',
      _i15.Banner => 'Banner',
      _i16.BannerPage => 'BannerPage',
      _i17.BasketSuggestion => 'BasketSuggestion',
      _i18.BasketSuggestionAction => 'BasketSuggestionAction',
      _i19.BasketSuggestionResult => 'BasketSuggestionResult',
      _i20.BestCouponResult => 'BestCouponResult',
      _i21.BogoFreeProduct => 'BogoFreeProduct',
      _i22.BogoOffer => 'BogoOffer',
      _i23.BogoOfferPage => 'BogoOfferPage',
      _i24.BroadcastPage => 'BroadcastPage',
      _i25.BroadcastRequest => 'BroadcastRequest',
      _i26.BroadcastSummary => 'BroadcastSummary',
      _i27.CartHydratedData => 'CartHydratedData',
      _i28.CartItem => 'CartItem',
      _i29.CartItemInput => 'CartItemInput',
      _i30.CartPricingResult => 'CartPricingResult',
      _i31.Category => 'Category',
      _i32.CategoryHierarchy => 'CategoryHierarchy',
      _i33.CategoryOffer => 'CategoryOffer',
      _i34.CategoryOfferPage => 'CategoryOfferPage',
      _i35.CheckoutResult => 'CheckoutResult',
      _i36.ComboOffer => 'ComboOffer',
      _i37.ComboOfferPage => 'ComboOfferPage',
      _i38.ComboProductItem => 'ComboProductItem',
      _i39.Complaint => 'Complaint',
      _i40.ComplaintPage => 'ComplaintPage',
      _i41.ComplaintProductItem => 'ComplaintProductItem',
      _i42.Coupon => 'Coupon',
      _i43.CouponDisplay => 'CouponDisplay',
      _i44.CouponValidationResult => 'CouponValidationResult',
      _i45.DeliveryConfig => 'DeliveryConfig',
      _i46.DeliveryPricingResult => 'DeliveryPricingResult',
      _i47.DeliveryRule => 'DeliveryRule',
      _i48.DeliveryRulePage => 'DeliveryRulePage',
      _i49.DeliverySlab => 'DeliverySlab',
      _i50.FreeDeliveryHydrated => 'FreeDeliveryHydrated',
      _i51.FreeDeliveryRule => 'FreeDeliveryRule',
      _i52.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i53.FreeItemInfo => 'FreeItemInfo',
      _i54.HomePageHydratedData => 'HomePageHydratedData',
      _i55.NotificationDraft => 'NotificationDraft',
      _i56.NotificationHistoryItem => 'NotificationHistoryItem',
      _i57.NotificationHistoryPage => 'NotificationHistoryPage',
      _i58.NotificationPreference => 'NotificationPreference',
      _i59.OfferConflictResponse => 'OfferConflictResponse',
      _i60.OfferMutationResult => 'OfferMutationResult',
      _i61.OfferSearchItem => 'OfferSearchItem',
      _i62.OfferSearchPage => 'OfferSearchPage',
      _i63.Order => 'Order',
      _i64.OrderDetailHydrated => 'OrderDetailHydrated',
      _i65.OrderItem => 'OrderItem',
      _i66.OrderPage => 'OrderPage',
      _i67.OrderRealtimeEvent => 'OrderRealtimeEvent',
      _i68.OrderTrackingData => 'OrderTrackingData',
      _i69.PaymentActionResult => 'PaymentActionResult',
      _i70.PaymentOrderResult => 'PaymentOrderResult',
      _i71.PaymentVerifyResult => 'PaymentVerifyResult',
      _i72.PricingLineItem => 'PricingLineItem',
      _i73.Product => 'Product',
      _i74.ProductFormReferenceData => 'ProductFormReferenceData',
      _i75.ProductPage => 'ProductPage',
      _i76.ProductRankingItem => 'ProductRankingItem',
      _i77.ProductVariant => 'ProductVariant',
      _i78.RefundRecord => 'RefundRecord',
      _i79.RegisterFcmTokenRequest => 'RegisterFcmTokenRequest',
      _i80.SubCategory => 'SubCategory',
      _i81.SupportIssue => 'SupportIssue',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'freshpickkat.',
        '',
      );
    }

    switch (data) {
      case _i2.ActiveUserStatistics():
        return 'ActiveUserStatistics';
      case _i3.Address():
        return 'Address';
      case _i4.AdminAnalytics():
        return 'AdminAnalytics';
      case _i5.AdminAuditLogEntry():
        return 'AdminAuditLogEntry';
      case _i6.AdminAuthResult():
        return 'AdminAuthResult';
      case _i7.AdminDashboardHydrated():
        return 'AdminDashboardHydrated';
      case _i8.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i9.AdminNotificationPreference():
        return 'AdminNotificationPreference';
      case _i10.AdminTopProduct():
        return 'AdminTopProduct';
      case _i11.ApiResponse():
        return 'ApiResponse';
      case _i12.AppUser():
        return 'AppUser';
      case _i13.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i14.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i15.Banner():
        return 'Banner';
      case _i16.BannerPage():
        return 'BannerPage';
      case _i17.BasketSuggestion():
        return 'BasketSuggestion';
      case _i18.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i19.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i20.BestCouponResult():
        return 'BestCouponResult';
      case _i21.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i22.BogoOffer():
        return 'BogoOffer';
      case _i23.BogoOfferPage():
        return 'BogoOfferPage';
      case _i24.BroadcastPage():
        return 'BroadcastPage';
      case _i25.BroadcastRequest():
        return 'BroadcastRequest';
      case _i26.BroadcastSummary():
        return 'BroadcastSummary';
      case _i27.CartHydratedData():
        return 'CartHydratedData';
      case _i28.CartItem():
        return 'CartItem';
      case _i29.CartItemInput():
        return 'CartItemInput';
      case _i30.CartPricingResult():
        return 'CartPricingResult';
      case _i31.Category():
        return 'Category';
      case _i32.CategoryHierarchy():
        return 'CategoryHierarchy';
      case _i33.CategoryOffer():
        return 'CategoryOffer';
      case _i34.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i35.CheckoutResult():
        return 'CheckoutResult';
      case _i36.ComboOffer():
        return 'ComboOffer';
      case _i37.ComboOfferPage():
        return 'ComboOfferPage';
      case _i38.ComboProductItem():
        return 'ComboProductItem';
      case _i39.Complaint():
        return 'Complaint';
      case _i40.ComplaintPage():
        return 'ComplaintPage';
      case _i41.ComplaintProductItem():
        return 'ComplaintProductItem';
      case _i42.Coupon():
        return 'Coupon';
      case _i43.CouponDisplay():
        return 'CouponDisplay';
      case _i44.CouponValidationResult():
        return 'CouponValidationResult';
      case _i45.DeliveryConfig():
        return 'DeliveryConfig';
      case _i46.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i47.DeliveryRule():
        return 'DeliveryRule';
      case _i48.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i49.DeliverySlab():
        return 'DeliverySlab';
      case _i50.FreeDeliveryHydrated():
        return 'FreeDeliveryHydrated';
      case _i51.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i52.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i53.FreeItemInfo():
        return 'FreeItemInfo';
      case _i54.HomePageHydratedData():
        return 'HomePageHydratedData';
      case _i55.NotificationDraft():
        return 'NotificationDraft';
      case _i56.NotificationHistoryItem():
        return 'NotificationHistoryItem';
      case _i57.NotificationHistoryPage():
        return 'NotificationHistoryPage';
      case _i58.NotificationPreference():
        return 'NotificationPreference';
      case _i59.OfferConflictResponse():
        return 'OfferConflictResponse';
      case _i60.OfferMutationResult():
        return 'OfferMutationResult';
      case _i61.OfferSearchItem():
        return 'OfferSearchItem';
      case _i62.OfferSearchPage():
        return 'OfferSearchPage';
      case _i63.Order():
        return 'Order';
      case _i64.OrderDetailHydrated():
        return 'OrderDetailHydrated';
      case _i65.OrderItem():
        return 'OrderItem';
      case _i66.OrderPage():
        return 'OrderPage';
      case _i67.OrderRealtimeEvent():
        return 'OrderRealtimeEvent';
      case _i68.OrderTrackingData():
        return 'OrderTrackingData';
      case _i69.PaymentActionResult():
        return 'PaymentActionResult';
      case _i70.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i71.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i72.PricingLineItem():
        return 'PricingLineItem';
      case _i73.Product():
        return 'Product';
      case _i74.ProductFormReferenceData():
        return 'ProductFormReferenceData';
      case _i75.ProductPage():
        return 'ProductPage';
      case _i76.ProductRankingItem():
        return 'ProductRankingItem';
      case _i77.ProductVariant():
        return 'ProductVariant';
      case _i78.RefundRecord():
        return 'RefundRecord';
      case _i79.RegisterFcmTokenRequest():
        return 'RegisterFcmTokenRequest';
      case _i80.SubCategory():
        return 'SubCategory';
      case _i81.SupportIssue():
        return 'SupportIssue';
    }
    className = _i101.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i102.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActiveUserStatistics') {
      return deserialize<_i2.ActiveUserStatistics>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i3.Address>(data['data']);
    }
    if (dataClassName == 'AdminAnalytics') {
      return deserialize<_i4.AdminAnalytics>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogEntry') {
      return deserialize<_i5.AdminAuditLogEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i6.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardHydrated') {
      return deserialize<_i7.AdminDashboardHydrated>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i8.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreference') {
      return deserialize<_i9.AdminNotificationPreference>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i10.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'ApiResponse') {
      return deserialize<_i11.ApiResponse>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i12.AppUser>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i13.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i14.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i15.Banner>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i16.BannerPage>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i17.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i18.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i19.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i20.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i21.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i22.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i23.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'BroadcastPage') {
      return deserialize<_i24.BroadcastPage>(data['data']);
    }
    if (dataClassName == 'BroadcastRequest') {
      return deserialize<_i25.BroadcastRequest>(data['data']);
    }
    if (dataClassName == 'BroadcastSummary') {
      return deserialize<_i26.BroadcastSummary>(data['data']);
    }
    if (dataClassName == 'CartHydratedData') {
      return deserialize<_i27.CartHydratedData>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i28.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i29.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i30.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i31.Category>(data['data']);
    }
    if (dataClassName == 'CategoryHierarchy') {
      return deserialize<_i32.CategoryHierarchy>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i33.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i34.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i35.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i36.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i37.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i38.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i39.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintPage') {
      return deserialize<_i40.ComplaintPage>(data['data']);
    }
    if (dataClassName == 'ComplaintProductItem') {
      return deserialize<_i41.ComplaintProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i42.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i43.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i44.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i45.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i46.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i47.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i48.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i49.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryHydrated') {
      return deserialize<_i50.FreeDeliveryHydrated>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i51.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i52.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i53.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'HomePageHydratedData') {
      return deserialize<_i54.HomePageHydratedData>(data['data']);
    }
    if (dataClassName == 'NotificationDraft') {
      return deserialize<_i55.NotificationDraft>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryItem') {
      return deserialize<_i56.NotificationHistoryItem>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryPage') {
      return deserialize<_i57.NotificationHistoryPage>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i58.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'OfferConflictResponse') {
      return deserialize<_i59.OfferConflictResponse>(data['data']);
    }
    if (dataClassName == 'OfferMutationResult') {
      return deserialize<_i60.OfferMutationResult>(data['data']);
    }
    if (dataClassName == 'OfferSearchItem') {
      return deserialize<_i61.OfferSearchItem>(data['data']);
    }
    if (dataClassName == 'OfferSearchPage') {
      return deserialize<_i62.OfferSearchPage>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i63.Order>(data['data']);
    }
    if (dataClassName == 'OrderDetailHydrated') {
      return deserialize<_i64.OrderDetailHydrated>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i65.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i66.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderRealtimeEvent') {
      return deserialize<_i67.OrderRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i68.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i69.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i70.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i71.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i72.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i73.Product>(data['data']);
    }
    if (dataClassName == 'ProductFormReferenceData') {
      return deserialize<_i74.ProductFormReferenceData>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i75.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i76.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i77.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i78.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RegisterFcmTokenRequest') {
      return deserialize<_i79.RegisterFcmTokenRequest>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i80.SubCategory>(data['data']);
    }
    if (dataClassName == 'SupportIssue') {
      return deserialize<_i81.SupportIssue>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i101.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i102.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i101.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i102.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
