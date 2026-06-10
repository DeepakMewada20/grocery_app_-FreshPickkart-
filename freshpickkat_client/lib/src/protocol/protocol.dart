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
import 'admin_dashboard_stats.dart' as _i7;
import 'admin_notification_preference.dart' as _i8;
import 'admin_top_product.dart' as _i9;
import 'api_response.dart' as _i10;
import 'app_user.dart' as _i11;
import 'applied_coupon_info.dart' as _i12;
import 'applied_offer_info.dart' as _i13;
import 'banner.dart' as _i14;
import 'banner_page.dart' as _i15;
import 'basket_suggestion.dart' as _i16;
import 'basket_suggestion_action.dart' as _i17;
import 'basket_suggestion_result.dart' as _i18;
import 'best_coupon_result.dart' as _i19;
import 'bogo_free_product.dart' as _i20;
import 'bogo_offer.dart' as _i21;
import 'bogo_offer_page.dart' as _i22;
import 'broadcast_page.dart' as _i23;
import 'broadcast_request.dart' as _i24;
import 'broadcast_summary.dart' as _i25;
import 'cart_item.dart' as _i26;
import 'cart_item_input.dart' as _i27;
import 'cart_pricing_result.dart' as _i28;
import 'category.dart' as _i29;
import 'category_offer.dart' as _i30;
import 'category_offer_page.dart' as _i31;
import 'checkout_result.dart' as _i32;
import 'combo_offer.dart' as _i33;
import 'combo_offer_page.dart' as _i34;
import 'combo_product_item.dart' as _i35;
import 'complaint.dart' as _i36;
import 'complaint_page.dart' as _i37;
import 'complaint_product_item.dart' as _i38;
import 'coupon.dart' as _i39;
import 'coupon_display.dart' as _i40;
import 'coupon_validation_result.dart' as _i41;
import 'delivery_config.dart' as _i42;
import 'delivery_pricing_result.dart' as _i43;
import 'delivery_rule.dart' as _i44;
import 'delivery_rule_page.dart' as _i45;
import 'delivery_slab.dart' as _i46;
import 'free_delivery_rule.dart' as _i47;
import 'free_delivery_rule_page.dart' as _i48;
import 'free_item_info.dart' as _i49;
import 'notification_draft.dart' as _i50;
import 'notification_history_item.dart' as _i51;
import 'notification_history_page.dart' as _i52;
import 'notification_preference.dart' as _i53;
import 'offer_conflict_response.dart' as _i54;
import 'offer_mutation_result.dart' as _i55;
import 'offer_search_item.dart' as _i56;
import 'offer_search_page.dart' as _i57;
import 'order.dart' as _i58;
import 'order_item.dart' as _i59;
import 'order_page.dart' as _i60;
import 'order_realtime_event.dart' as _i61;
import 'order_tracking_data.dart' as _i62;
import 'payment_action_result.dart' as _i63;
import 'payment_order_result.dart' as _i64;
import 'payment_verify_result.dart' as _i65;
import 'pricing_line_item.dart' as _i66;
import 'product.dart' as _i67;
import 'product_page.dart' as _i68;
import 'product_ranking_item.dart' as _i69;
import 'product_variant.dart' as _i70;
import 'refund_record.dart' as _i71;
import 'register_fcm_token_request.dart' as _i72;
import 'sub_category.dart' as _i73;
import 'support_issue.dart' as _i74;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i75;
import 'package:freshpickkat_client/src/protocol/admin_audit_log_entry.dart'
    as _i76;
import 'package:freshpickkat_client/src/protocol/active_user_statistics.dart'
    as _i77;
import 'package:freshpickkat_client/src/protocol/banner.dart' as _i78;
import 'package:freshpickkat_client/src/protocol/bogo_offer.dart' as _i79;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i80;
import 'package:freshpickkat_client/src/protocol/category_offer.dart' as _i81;
import 'package:freshpickkat_client/src/protocol/combo_offer.dart' as _i82;
import 'package:freshpickkat_client/src/protocol/cart_item_input.dart' as _i83;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i84;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i85;
import 'package:freshpickkat_client/src/protocol/delivery_rule.dart' as _i86;
import 'package:freshpickkat_client/src/protocol/admin_notification_preference.dart'
    as _i87;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i88;
import 'package:freshpickkat_client/src/protocol/applied_offer_info.dart'
    as _i89;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i90;
import 'package:freshpickkat_client/src/protocol/product_ranking_item.dart'
    as _i91;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i92;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i93;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i94;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i95;
export 'active_user_statistics.dart';
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_auth_result.dart';
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
export 'cart_item.dart';
export 'cart_item_input.dart';
export 'cart_pricing_result.dart';
export 'category.dart';
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
export 'free_delivery_rule.dart';
export 'free_delivery_rule_page.dart';
export 'free_item_info.dart';
export 'notification_draft.dart';
export 'notification_history_item.dart';
export 'notification_history_page.dart';
export 'notification_preference.dart';
export 'offer_conflict_response.dart';
export 'offer_mutation_result.dart';
export 'offer_search_item.dart';
export 'offer_search_page.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_realtime_event.dart';
export 'order_tracking_data.dart';
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_verify_result.dart';
export 'pricing_line_item.dart';
export 'product.dart';
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
    if (t == _i7.AdminDashboardStats) {
      return _i7.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i8.AdminNotificationPreference) {
      return _i8.AdminNotificationPreference.fromJson(data) as T;
    }
    if (t == _i9.AdminTopProduct) {
      return _i9.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i10.ApiResponse) {
      return _i10.ApiResponse.fromJson(data) as T;
    }
    if (t == _i11.AppUser) {
      return _i11.AppUser.fromJson(data) as T;
    }
    if (t == _i12.AppliedCouponInfo) {
      return _i12.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i13.AppliedOfferInfo) {
      return _i13.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i14.Banner) {
      return _i14.Banner.fromJson(data) as T;
    }
    if (t == _i15.BannerPage) {
      return _i15.BannerPage.fromJson(data) as T;
    }
    if (t == _i16.BasketSuggestion) {
      return _i16.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i17.BasketSuggestionAction) {
      return _i17.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i18.BasketSuggestionResult) {
      return _i18.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i19.BestCouponResult) {
      return _i19.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i20.BogoFreeProduct) {
      return _i20.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i21.BogoOffer) {
      return _i21.BogoOffer.fromJson(data) as T;
    }
    if (t == _i22.BogoOfferPage) {
      return _i22.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i23.BroadcastPage) {
      return _i23.BroadcastPage.fromJson(data) as T;
    }
    if (t == _i24.BroadcastRequest) {
      return _i24.BroadcastRequest.fromJson(data) as T;
    }
    if (t == _i25.BroadcastSummary) {
      return _i25.BroadcastSummary.fromJson(data) as T;
    }
    if (t == _i26.CartItem) {
      return _i26.CartItem.fromJson(data) as T;
    }
    if (t == _i27.CartItemInput) {
      return _i27.CartItemInput.fromJson(data) as T;
    }
    if (t == _i28.CartPricingResult) {
      return _i28.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i29.Category) {
      return _i29.Category.fromJson(data) as T;
    }
    if (t == _i30.CategoryOffer) {
      return _i30.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i31.CategoryOfferPage) {
      return _i31.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i32.CheckoutResult) {
      return _i32.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i33.ComboOffer) {
      return _i33.ComboOffer.fromJson(data) as T;
    }
    if (t == _i34.ComboOfferPage) {
      return _i34.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i35.ComboProductItem) {
      return _i35.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i36.Complaint) {
      return _i36.Complaint.fromJson(data) as T;
    }
    if (t == _i37.ComplaintPage) {
      return _i37.ComplaintPage.fromJson(data) as T;
    }
    if (t == _i38.ComplaintProductItem) {
      return _i38.ComplaintProductItem.fromJson(data) as T;
    }
    if (t == _i39.Coupon) {
      return _i39.Coupon.fromJson(data) as T;
    }
    if (t == _i40.CouponDisplay) {
      return _i40.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i41.CouponValidationResult) {
      return _i41.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i42.DeliveryConfig) {
      return _i42.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i43.DeliveryPricingResult) {
      return _i43.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i44.DeliveryRule) {
      return _i44.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i45.DeliveryRulePage) {
      return _i45.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i46.DeliverySlab) {
      return _i46.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i47.FreeDeliveryRule) {
      return _i47.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i48.FreeDeliveryRulePage) {
      return _i48.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i49.FreeItemInfo) {
      return _i49.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i50.NotificationDraft) {
      return _i50.NotificationDraft.fromJson(data) as T;
    }
    if (t == _i51.NotificationHistoryItem) {
      return _i51.NotificationHistoryItem.fromJson(data) as T;
    }
    if (t == _i52.NotificationHistoryPage) {
      return _i52.NotificationHistoryPage.fromJson(data) as T;
    }
    if (t == _i53.NotificationPreference) {
      return _i53.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i54.OfferConflictResponse) {
      return _i54.OfferConflictResponse.fromJson(data) as T;
    }
    if (t == _i55.OfferMutationResult) {
      return _i55.OfferMutationResult.fromJson(data) as T;
    }
    if (t == _i56.OfferSearchItem) {
      return _i56.OfferSearchItem.fromJson(data) as T;
    }
    if (t == _i57.OfferSearchPage) {
      return _i57.OfferSearchPage.fromJson(data) as T;
    }
    if (t == _i58.Order) {
      return _i58.Order.fromJson(data) as T;
    }
    if (t == _i59.OrderItem) {
      return _i59.OrderItem.fromJson(data) as T;
    }
    if (t == _i60.OrderPage) {
      return _i60.OrderPage.fromJson(data) as T;
    }
    if (t == _i61.OrderRealtimeEvent) {
      return _i61.OrderRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i62.OrderTrackingData) {
      return _i62.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i63.PaymentActionResult) {
      return _i63.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i64.PaymentOrderResult) {
      return _i64.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i65.PaymentVerifyResult) {
      return _i65.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i66.PricingLineItem) {
      return _i66.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i67.Product) {
      return _i67.Product.fromJson(data) as T;
    }
    if (t == _i68.ProductPage) {
      return _i68.ProductPage.fromJson(data) as T;
    }
    if (t == _i69.ProductRankingItem) {
      return _i69.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i70.ProductVariant) {
      return _i70.ProductVariant.fromJson(data) as T;
    }
    if (t == _i71.RefundRecord) {
      return _i71.RefundRecord.fromJson(data) as T;
    }
    if (t == _i72.RegisterFcmTokenRequest) {
      return _i72.RegisterFcmTokenRequest.fromJson(data) as T;
    }
    if (t == _i73.SubCategory) {
      return _i73.SubCategory.fromJson(data) as T;
    }
    if (t == _i74.SupportIssue) {
      return _i74.SupportIssue.fromJson(data) as T;
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
    if (t == _i1.getType<_i7.AdminDashboardStats?>()) {
      return (data != null ? _i7.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.AdminNotificationPreference?>()) {
      return (data != null
              ? _i8.AdminNotificationPreference.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.AdminTopProduct?>()) {
      return (data != null ? _i9.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ApiResponse?>()) {
      return (data != null ? _i10.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.AppUser?>()) {
      return (data != null ? _i11.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.AppliedCouponInfo?>()) {
      return (data != null ? _i12.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.AppliedOfferInfo?>()) {
      return (data != null ? _i13.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Banner?>()) {
      return (data != null ? _i14.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.BannerPage?>()) {
      return (data != null ? _i15.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BasketSuggestion?>()) {
      return (data != null ? _i16.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BasketSuggestionAction?>()) {
      return (data != null ? _i17.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.BasketSuggestionResult?>()) {
      return (data != null ? _i18.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.BestCouponResult?>()) {
      return (data != null ? _i19.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.BogoFreeProduct?>()) {
      return (data != null ? _i20.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BogoOffer?>()) {
      return (data != null ? _i21.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.BogoOfferPage?>()) {
      return (data != null ? _i22.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.BroadcastPage?>()) {
      return (data != null ? _i23.BroadcastPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BroadcastRequest?>()) {
      return (data != null ? _i24.BroadcastRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BroadcastSummary?>()) {
      return (data != null ? _i25.BroadcastSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CartItem?>()) {
      return (data != null ? _i26.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.CartItemInput?>()) {
      return (data != null ? _i27.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.CartPricingResult?>()) {
      return (data != null ? _i28.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Category?>()) {
      return (data != null ? _i29.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CategoryOffer?>()) {
      return (data != null ? _i30.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.CategoryOfferPage?>()) {
      return (data != null ? _i31.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CheckoutResult?>()) {
      return (data != null ? _i32.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.ComboOffer?>()) {
      return (data != null ? _i33.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.ComboOfferPage?>()) {
      return (data != null ? _i34.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.ComboProductItem?>()) {
      return (data != null ? _i35.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.Complaint?>()) {
      return (data != null ? _i36.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ComplaintPage?>()) {
      return (data != null ? _i37.ComplaintPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.ComplaintProductItem?>()) {
      return (data != null ? _i38.ComplaintProductItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.Coupon?>()) {
      return (data != null ? _i39.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.CouponDisplay?>()) {
      return (data != null ? _i40.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.CouponValidationResult?>()) {
      return (data != null ? _i41.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.DeliveryConfig?>()) {
      return (data != null ? _i42.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.DeliveryPricingResult?>()) {
      return (data != null ? _i43.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.DeliveryRule?>()) {
      return (data != null ? _i44.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.DeliveryRulePage?>()) {
      return (data != null ? _i45.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.DeliverySlab?>()) {
      return (data != null ? _i46.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.FreeDeliveryRule?>()) {
      return (data != null ? _i47.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.FreeDeliveryRulePage?>()) {
      return (data != null ? _i48.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.FreeItemInfo?>()) {
      return (data != null ? _i49.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.NotificationDraft?>()) {
      return (data != null ? _i50.NotificationDraft.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.NotificationHistoryItem?>()) {
      return (data != null ? _i51.NotificationHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.NotificationHistoryPage?>()) {
      return (data != null ? _i52.NotificationHistoryPage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.NotificationPreference?>()) {
      return (data != null ? _i53.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.OfferConflictResponse?>()) {
      return (data != null ? _i54.OfferConflictResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.OfferMutationResult?>()) {
      return (data != null ? _i55.OfferMutationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.OfferSearchItem?>()) {
      return (data != null ? _i56.OfferSearchItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.OfferSearchPage?>()) {
      return (data != null ? _i57.OfferSearchPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.Order?>()) {
      return (data != null ? _i58.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.OrderItem?>()) {
      return (data != null ? _i59.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.OrderPage?>()) {
      return (data != null ? _i60.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.OrderRealtimeEvent?>()) {
      return (data != null ? _i61.OrderRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.OrderTrackingData?>()) {
      return (data != null ? _i62.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.PaymentActionResult?>()) {
      return (data != null ? _i63.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.PaymentOrderResult?>()) {
      return (data != null ? _i64.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.PaymentVerifyResult?>()) {
      return (data != null ? _i65.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.PricingLineItem?>()) {
      return (data != null ? _i66.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.Product?>()) {
      return (data != null ? _i67.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.ProductPage?>()) {
      return (data != null ? _i68.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.ProductRankingItem?>()) {
      return (data != null ? _i69.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.ProductVariant?>()) {
      return (data != null ? _i70.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.RefundRecord?>()) {
      return (data != null ? _i71.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.RegisterFcmTokenRequest?>()) {
      return (data != null ? _i72.RegisterFcmTokenRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.SubCategory?>()) {
      return (data != null ? _i73.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.SupportIssue?>()) {
      return (data != null ? _i74.SupportIssue.fromJson(data) : null) as T;
    }
    if (t == List<_i9.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i9.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.CartItem>) {
      return (data as List).map((e) => deserialize<_i26.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i26.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i26.CartItem>(e))
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
    if (t == List<_i14.Banner>) {
      return (data as List).map((e) => deserialize<_i14.Banner>(e)).toList()
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
    if (t == List<_i17.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i17.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i16.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i16.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i16.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i16.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i20.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i20.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i21.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i21.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i25.BroadcastSummary>) {
      return (data as List)
              .map((e) => deserialize<_i25.BroadcastSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i13.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i13.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i49.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i49.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i66.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i30.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i35.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i33.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i38.ComplaintProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i38.ComplaintProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.Complaint>) {
      return (data as List).map((e) => deserialize<_i36.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i46.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i46.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i44.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i47.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.NotificationHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i51.NotificationHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.Product>) {
      return (data as List).map((e) => deserialize<_i67.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i67.Product>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i67.Product>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i56.OfferSearchItem>) {
      return (data as List)
              .map((e) => deserialize<_i56.OfferSearchItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.OrderItem>) {
      return (data as List).map((e) => deserialize<_i59.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i58.Order>) {
      return (data as List).map((e) => deserialize<_i58.Order>(e)).toList()
          as T;
    }
    if (t == List<_i70.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i70.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i70.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i70.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i75.AppUser>) {
      return (data as List).map((e) => deserialize<_i75.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i76.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i76.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i77.ActiveUserStatistics>) {
      return (data as List)
              .map((e) => deserialize<_i77.ActiveUserStatistics>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.Banner>) {
      return (data as List).map((e) => deserialize<_i78.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i79.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i79.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i80.Category>) {
      return (data as List).map((e) => deserialize<_i80.Category>(e)).toList()
          as T;
    }
    if (t == List<_i81.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i81.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i82.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i82.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i83.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i83.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.Coupon>) {
      return (data as List).map((e) => deserialize<_i84.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i85.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i85.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i86.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i83.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i83.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i87.AdminNotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i87.AdminNotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.Order>) {
      return (data as List).map((e) => deserialize<_i88.Order>(e)).toList()
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
    if (t == List<_i89.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i89.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i90.Product>) {
      return (data as List).map((e) => deserialize<_i90.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i91.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i91.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i92.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i92.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i93.CartItem>) {
      return (data as List).map((e) => deserialize<_i93.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i94.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i95.Protocol().deserialize<T>(data, t);
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
      _i7.AdminDashboardStats => 'AdminDashboardStats',
      _i8.AdminNotificationPreference => 'AdminNotificationPreference',
      _i9.AdminTopProduct => 'AdminTopProduct',
      _i10.ApiResponse => 'ApiResponse',
      _i11.AppUser => 'AppUser',
      _i12.AppliedCouponInfo => 'AppliedCouponInfo',
      _i13.AppliedOfferInfo => 'AppliedOfferInfo',
      _i14.Banner => 'Banner',
      _i15.BannerPage => 'BannerPage',
      _i16.BasketSuggestion => 'BasketSuggestion',
      _i17.BasketSuggestionAction => 'BasketSuggestionAction',
      _i18.BasketSuggestionResult => 'BasketSuggestionResult',
      _i19.BestCouponResult => 'BestCouponResult',
      _i20.BogoFreeProduct => 'BogoFreeProduct',
      _i21.BogoOffer => 'BogoOffer',
      _i22.BogoOfferPage => 'BogoOfferPage',
      _i23.BroadcastPage => 'BroadcastPage',
      _i24.BroadcastRequest => 'BroadcastRequest',
      _i25.BroadcastSummary => 'BroadcastSummary',
      _i26.CartItem => 'CartItem',
      _i27.CartItemInput => 'CartItemInput',
      _i28.CartPricingResult => 'CartPricingResult',
      _i29.Category => 'Category',
      _i30.CategoryOffer => 'CategoryOffer',
      _i31.CategoryOfferPage => 'CategoryOfferPage',
      _i32.CheckoutResult => 'CheckoutResult',
      _i33.ComboOffer => 'ComboOffer',
      _i34.ComboOfferPage => 'ComboOfferPage',
      _i35.ComboProductItem => 'ComboProductItem',
      _i36.Complaint => 'Complaint',
      _i37.ComplaintPage => 'ComplaintPage',
      _i38.ComplaintProductItem => 'ComplaintProductItem',
      _i39.Coupon => 'Coupon',
      _i40.CouponDisplay => 'CouponDisplay',
      _i41.CouponValidationResult => 'CouponValidationResult',
      _i42.DeliveryConfig => 'DeliveryConfig',
      _i43.DeliveryPricingResult => 'DeliveryPricingResult',
      _i44.DeliveryRule => 'DeliveryRule',
      _i45.DeliveryRulePage => 'DeliveryRulePage',
      _i46.DeliverySlab => 'DeliverySlab',
      _i47.FreeDeliveryRule => 'FreeDeliveryRule',
      _i48.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i49.FreeItemInfo => 'FreeItemInfo',
      _i50.NotificationDraft => 'NotificationDraft',
      _i51.NotificationHistoryItem => 'NotificationHistoryItem',
      _i52.NotificationHistoryPage => 'NotificationHistoryPage',
      _i53.NotificationPreference => 'NotificationPreference',
      _i54.OfferConflictResponse => 'OfferConflictResponse',
      _i55.OfferMutationResult => 'OfferMutationResult',
      _i56.OfferSearchItem => 'OfferSearchItem',
      _i57.OfferSearchPage => 'OfferSearchPage',
      _i58.Order => 'Order',
      _i59.OrderItem => 'OrderItem',
      _i60.OrderPage => 'OrderPage',
      _i61.OrderRealtimeEvent => 'OrderRealtimeEvent',
      _i62.OrderTrackingData => 'OrderTrackingData',
      _i63.PaymentActionResult => 'PaymentActionResult',
      _i64.PaymentOrderResult => 'PaymentOrderResult',
      _i65.PaymentVerifyResult => 'PaymentVerifyResult',
      _i66.PricingLineItem => 'PricingLineItem',
      _i67.Product => 'Product',
      _i68.ProductPage => 'ProductPage',
      _i69.ProductRankingItem => 'ProductRankingItem',
      _i70.ProductVariant => 'ProductVariant',
      _i71.RefundRecord => 'RefundRecord',
      _i72.RegisterFcmTokenRequest => 'RegisterFcmTokenRequest',
      _i73.SubCategory => 'SubCategory',
      _i74.SupportIssue => 'SupportIssue',
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
      case _i7.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i8.AdminNotificationPreference():
        return 'AdminNotificationPreference';
      case _i9.AdminTopProduct():
        return 'AdminTopProduct';
      case _i10.ApiResponse():
        return 'ApiResponse';
      case _i11.AppUser():
        return 'AppUser';
      case _i12.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i13.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i14.Banner():
        return 'Banner';
      case _i15.BannerPage():
        return 'BannerPage';
      case _i16.BasketSuggestion():
        return 'BasketSuggestion';
      case _i17.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i18.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i19.BestCouponResult():
        return 'BestCouponResult';
      case _i20.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i21.BogoOffer():
        return 'BogoOffer';
      case _i22.BogoOfferPage():
        return 'BogoOfferPage';
      case _i23.BroadcastPage():
        return 'BroadcastPage';
      case _i24.BroadcastRequest():
        return 'BroadcastRequest';
      case _i25.BroadcastSummary():
        return 'BroadcastSummary';
      case _i26.CartItem():
        return 'CartItem';
      case _i27.CartItemInput():
        return 'CartItemInput';
      case _i28.CartPricingResult():
        return 'CartPricingResult';
      case _i29.Category():
        return 'Category';
      case _i30.CategoryOffer():
        return 'CategoryOffer';
      case _i31.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i32.CheckoutResult():
        return 'CheckoutResult';
      case _i33.ComboOffer():
        return 'ComboOffer';
      case _i34.ComboOfferPage():
        return 'ComboOfferPage';
      case _i35.ComboProductItem():
        return 'ComboProductItem';
      case _i36.Complaint():
        return 'Complaint';
      case _i37.ComplaintPage():
        return 'ComplaintPage';
      case _i38.ComplaintProductItem():
        return 'ComplaintProductItem';
      case _i39.Coupon():
        return 'Coupon';
      case _i40.CouponDisplay():
        return 'CouponDisplay';
      case _i41.CouponValidationResult():
        return 'CouponValidationResult';
      case _i42.DeliveryConfig():
        return 'DeliveryConfig';
      case _i43.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i44.DeliveryRule():
        return 'DeliveryRule';
      case _i45.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i46.DeliverySlab():
        return 'DeliverySlab';
      case _i47.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i48.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i49.FreeItemInfo():
        return 'FreeItemInfo';
      case _i50.NotificationDraft():
        return 'NotificationDraft';
      case _i51.NotificationHistoryItem():
        return 'NotificationHistoryItem';
      case _i52.NotificationHistoryPage():
        return 'NotificationHistoryPage';
      case _i53.NotificationPreference():
        return 'NotificationPreference';
      case _i54.OfferConflictResponse():
        return 'OfferConflictResponse';
      case _i55.OfferMutationResult():
        return 'OfferMutationResult';
      case _i56.OfferSearchItem():
        return 'OfferSearchItem';
      case _i57.OfferSearchPage():
        return 'OfferSearchPage';
      case _i58.Order():
        return 'Order';
      case _i59.OrderItem():
        return 'OrderItem';
      case _i60.OrderPage():
        return 'OrderPage';
      case _i61.OrderRealtimeEvent():
        return 'OrderRealtimeEvent';
      case _i62.OrderTrackingData():
        return 'OrderTrackingData';
      case _i63.PaymentActionResult():
        return 'PaymentActionResult';
      case _i64.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i65.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i66.PricingLineItem():
        return 'PricingLineItem';
      case _i67.Product():
        return 'Product';
      case _i68.ProductPage():
        return 'ProductPage';
      case _i69.ProductRankingItem():
        return 'ProductRankingItem';
      case _i70.ProductVariant():
        return 'ProductVariant';
      case _i71.RefundRecord():
        return 'RefundRecord';
      case _i72.RegisterFcmTokenRequest():
        return 'RegisterFcmTokenRequest';
      case _i73.SubCategory():
        return 'SubCategory';
      case _i74.SupportIssue():
        return 'SupportIssue';
    }
    className = _i94.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i95.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i7.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreference') {
      return deserialize<_i8.AdminNotificationPreference>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i9.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'ApiResponse') {
      return deserialize<_i10.ApiResponse>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i11.AppUser>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i12.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i13.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i14.Banner>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i15.BannerPage>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i16.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i17.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i18.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i19.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i20.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i21.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i22.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'BroadcastPage') {
      return deserialize<_i23.BroadcastPage>(data['data']);
    }
    if (dataClassName == 'BroadcastRequest') {
      return deserialize<_i24.BroadcastRequest>(data['data']);
    }
    if (dataClassName == 'BroadcastSummary') {
      return deserialize<_i25.BroadcastSummary>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i26.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i27.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i28.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i29.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i30.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i31.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i32.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i33.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i34.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i35.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i36.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintPage') {
      return deserialize<_i37.ComplaintPage>(data['data']);
    }
    if (dataClassName == 'ComplaintProductItem') {
      return deserialize<_i38.ComplaintProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i39.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i40.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i41.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i42.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i43.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i44.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i45.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i46.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i47.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i48.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i49.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'NotificationDraft') {
      return deserialize<_i50.NotificationDraft>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryItem') {
      return deserialize<_i51.NotificationHistoryItem>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryPage') {
      return deserialize<_i52.NotificationHistoryPage>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i53.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'OfferConflictResponse') {
      return deserialize<_i54.OfferConflictResponse>(data['data']);
    }
    if (dataClassName == 'OfferMutationResult') {
      return deserialize<_i55.OfferMutationResult>(data['data']);
    }
    if (dataClassName == 'OfferSearchItem') {
      return deserialize<_i56.OfferSearchItem>(data['data']);
    }
    if (dataClassName == 'OfferSearchPage') {
      return deserialize<_i57.OfferSearchPage>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i58.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i59.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i60.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderRealtimeEvent') {
      return deserialize<_i61.OrderRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i62.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i63.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i64.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i65.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i66.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i67.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i68.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i69.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i70.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i71.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RegisterFcmTokenRequest') {
      return deserialize<_i72.RegisterFcmTokenRequest>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i73.SubCategory>(data['data']);
    }
    if (dataClassName == 'SupportIssue') {
      return deserialize<_i74.SupportIssue>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i94.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i95.Protocol().deserializeByClassName(data);
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
      return _i94.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i95.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
