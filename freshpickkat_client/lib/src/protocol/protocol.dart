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
import 'data_flow/active_user_statistics.dart' as _i2;
import 'data_flow/address.dart' as _i3;
import 'data_flow/admin_analytics.dart' as _i4;
import 'data_flow/admin_audit_log_entry.dart' as _i5;
import 'data_flow/admin_auth_result.dart' as _i6;
import 'data_flow/admin_dashboard_hydrated.dart' as _i7;
import 'data_flow/admin_dashboard_stats.dart' as _i8;
import 'data_flow/admin_notification_preference.dart' as _i9;
import 'data_flow/admin_top_product.dart' as _i10;
import 'data_flow/api_response.dart' as _i11;
import 'data_flow/app_user.dart' as _i12;
import 'data_flow/applied_coupon_info.dart' as _i13;
import 'data_flow/applied_offer_info.dart' as _i14;
import 'data_flow/banner.dart' as _i15;
import 'data_flow/banner_page.dart' as _i16;
import 'data_flow/basket_suggestion.dart' as _i17;
import 'data_flow/basket_suggestion_action.dart' as _i18;
import 'data_flow/basket_suggestion_result.dart' as _i19;
import 'data_flow/best_coupon_result.dart' as _i20;
import 'data_flow/bogo_free_product.dart' as _i21;
import 'data_flow/bogo_offer.dart' as _i22;
import 'data_flow/bogo_offer_page.dart' as _i23;
import 'data_flow/broadcast_page.dart' as _i24;
import 'data_flow/broadcast_request.dart' as _i25;
import 'data_flow/broadcast_summary.dart' as _i26;
import 'data_flow/cart_comparison_data.dart' as _i27;
import 'data_flow/cart_hydrated_data.dart' as _i28;
import 'data_flow/cart_item.dart' as _i29;
import 'data_flow/cart_item_input.dart' as _i30;
import 'data_flow/cart_item_snapshot.dart' as _i31;
import 'data_flow/cart_pricing_result.dart' as _i32;
import 'data_flow/cascade_entity_info.dart' as _i33;
import 'data_flow/cascade_execute_response.dart' as _i34;
import 'data_flow/cascade_impact_response.dart' as _i35;
import 'data_flow/category.dart' as _i36;
import 'data_flow/category_hierarchy.dart' as _i37;
import 'data_flow/category_offer.dart' as _i38;
import 'data_flow/category_offer_page.dart' as _i39;
import 'data_flow/checkout_init_hydrated.dart' as _i40;
import 'data_flow/checkout_result.dart' as _i41;
import 'data_flow/combo_offer.dart' as _i42;
import 'data_flow/combo_offer_page.dart' as _i43;
import 'data_flow/combo_product_item.dart' as _i44;
import 'data_flow/complaint.dart' as _i45;
import 'data_flow/complaint_detail_hydrated.dart' as _i46;
import 'data_flow/complaint_page.dart' as _i47;
import 'data_flow/complaint_product_item.dart' as _i48;
import 'data_flow/coupon.dart' as _i49;
import 'data_flow/coupon_display.dart' as _i50;
import 'data_flow/coupon_validation_result.dart' as _i51;
import 'data_flow/delete_impact_reference.dart' as _i52;
import 'data_flow/delete_impact_response.dart' as _i53;
import 'data_flow/delivery_config.dart' as _i54;
import 'data_flow/delivery_pricing_result.dart' as _i55;
import 'data_flow/delivery_rule.dart' as _i56;
import 'data_flow/delivery_rule_page.dart' as _i57;
import 'data_flow/delivery_slab.dart' as _i58;
import 'data_flow/free_delivery_hydrated.dart' as _i59;
import 'data_flow/free_delivery_rule.dart' as _i60;
import 'data_flow/free_delivery_rule_page.dart' as _i61;
import 'data_flow/free_item_info.dart' as _i62;
import 'data_flow/fresh_points_adjust_request.dart' as _i63;
import 'data_flow/fresh_points_balance.dart' as _i64;
import 'data_flow/fresh_points_settings.dart' as _i65;
import 'data_flow/fresh_points_transaction.dart' as _i66;
import 'data_flow/hard_delete_response.dart' as _i67;
import 'data_flow/home_page_hydrated_data.dart' as _i68;
import 'data_flow/notification_draft.dart' as _i69;
import 'data_flow/notification_history_item.dart' as _i70;
import 'data_flow/notification_history_page.dart' as _i71;
import 'data_flow/notification_preference.dart' as _i72;
import 'data_flow/offer_conflict_response.dart' as _i73;
import 'data_flow/offer_mutation_result.dart' as _i74;
import 'data_flow/offer_search_item.dart' as _i75;
import 'data_flow/offer_search_page.dart' as _i76;
import 'data_flow/order.dart' as _i77;
import 'data_flow/order_detail_hydrated.dart' as _i78;
import 'data_flow/order_item.dart' as _i79;
import 'data_flow/order_page.dart' as _i80;
import 'data_flow/order_realtime_event.dart' as _i81;
import 'data_flow/order_tracking_data.dart' as _i82;
import 'data_flow/payment_action_result.dart' as _i83;
import 'data_flow/payment_event.dart' as _i84;
import 'data_flow/payment_link_data.dart' as _i85;
import 'data_flow/payment_order_detail_hydrated.dart' as _i86;
import 'data_flow/payment_order_result.dart' as _i87;
import 'data_flow/payment_page_data.dart' as _i88;
import 'data_flow/payment_page_item.dart' as _i89;
import 'data_flow/payment_session_data.dart' as _i90;
import 'data_flow/payment_transaction.dart' as _i91;
import 'data_flow/payment_verify_result.dart' as _i92;
import 'data_flow/pending_order_info.dart' as _i93;
import 'data_flow/pricing_line_item.dart' as _i94;
import 'data_flow/product.dart' as _i95;
import 'data_flow/product_form_reference_data.dart' as _i96;
import 'data_flow/product_page.dart' as _i97;
import 'data_flow/product_ranking_item.dart' as _i98;
import 'data_flow/product_variant.dart' as _i99;
import 'data_flow/razorpay_payment_status.dart' as _i100;
import 'data_flow/razorpay_refund_data.dart' as _i101;
import 'data_flow/referral.dart' as _i102;
import 'data_flow/referral_activity.dart' as _i103;
import 'data_flow/referral_admin_stats.dart' as _i104;
import 'data_flow/referral_code_info.dart' as _i105;
import 'data_flow/referral_fraud_result.dart' as _i106;
import 'data_flow/referral_fraud_rule_result.dart' as _i107;
import 'data_flow/referral_onboarding_status.dart' as _i108;
import 'data_flow/referral_settings.dart' as _i109;
import 'data_flow/refund_record.dart' as _i110;
import 'data_flow/register_fcm_token_request.dart' as _i111;
import 'data_flow/sub_category.dart' as _i112;
import 'data_flow/support_issue.dart' as _i113;
import 'data_flow/top_referrer_entry.dart' as _i114;
import 'package:freshpickkat_client/src/protocol/data_flow/app_user.dart'
    as _i115;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_audit_log_entry.dart'
    as _i116;
import 'package:freshpickkat_client/src/protocol/data_flow/active_user_statistics.dart'
    as _i117;
import 'package:freshpickkat_client/src/protocol/data_flow/banner.dart'
    as _i118;
import 'package:freshpickkat_client/src/protocol/data_flow/bogo_offer.dart'
    as _i119;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_item_input.dart'
    as _i120;
import 'package:freshpickkat_client/src/protocol/data_flow/category.dart'
    as _i121;
import 'package:freshpickkat_client/src/protocol/data_flow/category_offer.dart'
    as _i122;
import 'package:freshpickkat_client/src/protocol/data_flow/combo_offer.dart'
    as _i123;
import 'package:freshpickkat_client/src/protocol/data_flow/coupon.dart'
    as _i124;
import 'package:freshpickkat_client/src/protocol/data_flow/coupon_display.dart'
    as _i125;
import 'package:freshpickkat_client/src/protocol/data_flow/delivery_rule.dart'
    as _i126;
import 'package:freshpickkat_client/src/protocol/data_flow/admin_notification_preference.dart'
    as _i127;
import 'package:freshpickkat_client/src/protocol/data_flow/order.dart' as _i128;
import 'package:freshpickkat_client/src/protocol/data_flow/applied_offer_info.dart'
    as _i129;
import 'package:freshpickkat_client/src/protocol/data_flow/product.dart'
    as _i130;
import 'package:freshpickkat_client/src/protocol/data_flow/product_ranking_item.dart'
    as _i131;
import 'package:freshpickkat_client/src/protocol/data_flow/referral_activity.dart'
    as _i132;
import 'package:freshpickkat_client/src/protocol/data_flow/sub_category.dart'
    as _i133;
import 'package:freshpickkat_client/src/protocol/data_flow/support_issue.dart'
    as _i134;
import 'package:freshpickkat_client/src/protocol/data_flow/cart_item.dart'
    as _i135;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i136;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i137;
export 'data_flow/active_user_statistics.dart';
export 'data_flow/address.dart';
export 'data_flow/admin_analytics.dart';
export 'data_flow/admin_audit_log_entry.dart';
export 'data_flow/admin_auth_result.dart';
export 'data_flow/admin_dashboard_hydrated.dart';
export 'data_flow/admin_dashboard_stats.dart';
export 'data_flow/admin_notification_preference.dart';
export 'data_flow/admin_top_product.dart';
export 'data_flow/api_response.dart';
export 'data_flow/app_user.dart';
export 'data_flow/applied_coupon_info.dart';
export 'data_flow/applied_offer_info.dart';
export 'data_flow/banner.dart';
export 'data_flow/banner_page.dart';
export 'data_flow/basket_suggestion.dart';
export 'data_flow/basket_suggestion_action.dart';
export 'data_flow/basket_suggestion_result.dart';
export 'data_flow/best_coupon_result.dart';
export 'data_flow/bogo_free_product.dart';
export 'data_flow/bogo_offer.dart';
export 'data_flow/bogo_offer_page.dart';
export 'data_flow/broadcast_page.dart';
export 'data_flow/broadcast_request.dart';
export 'data_flow/broadcast_summary.dart';
export 'data_flow/cart_comparison_data.dart';
export 'data_flow/cart_hydrated_data.dart';
export 'data_flow/cart_item.dart';
export 'data_flow/cart_item_input.dart';
export 'data_flow/cart_item_snapshot.dart';
export 'data_flow/cart_pricing_result.dart';
export 'data_flow/cascade_entity_info.dart';
export 'data_flow/cascade_execute_response.dart';
export 'data_flow/cascade_impact_response.dart';
export 'data_flow/category.dart';
export 'data_flow/category_hierarchy.dart';
export 'data_flow/category_offer.dart';
export 'data_flow/category_offer_page.dart';
export 'data_flow/checkout_init_hydrated.dart';
export 'data_flow/checkout_result.dart';
export 'data_flow/combo_offer.dart';
export 'data_flow/combo_offer_page.dart';
export 'data_flow/combo_product_item.dart';
export 'data_flow/complaint.dart';
export 'data_flow/complaint_detail_hydrated.dart';
export 'data_flow/complaint_page.dart';
export 'data_flow/complaint_product_item.dart';
export 'data_flow/coupon.dart';
export 'data_flow/coupon_display.dart';
export 'data_flow/coupon_validation_result.dart';
export 'data_flow/delete_impact_reference.dart';
export 'data_flow/delete_impact_response.dart';
export 'data_flow/delivery_config.dart';
export 'data_flow/delivery_pricing_result.dart';
export 'data_flow/delivery_rule.dart';
export 'data_flow/delivery_rule_page.dart';
export 'data_flow/delivery_slab.dart';
export 'data_flow/free_delivery_hydrated.dart';
export 'data_flow/free_delivery_rule.dart';
export 'data_flow/free_delivery_rule_page.dart';
export 'data_flow/free_item_info.dart';
export 'data_flow/fresh_points_adjust_request.dart';
export 'data_flow/fresh_points_balance.dart';
export 'data_flow/fresh_points_settings.dart';
export 'data_flow/fresh_points_transaction.dart';
export 'data_flow/hard_delete_response.dart';
export 'data_flow/home_page_hydrated_data.dart';
export 'data_flow/notification_draft.dart';
export 'data_flow/notification_history_item.dart';
export 'data_flow/notification_history_page.dart';
export 'data_flow/notification_preference.dart';
export 'data_flow/offer_conflict_response.dart';
export 'data_flow/offer_mutation_result.dart';
export 'data_flow/offer_search_item.dart';
export 'data_flow/offer_search_page.dart';
export 'data_flow/order.dart';
export 'data_flow/order_detail_hydrated.dart';
export 'data_flow/order_item.dart';
export 'data_flow/order_page.dart';
export 'data_flow/order_realtime_event.dart';
export 'data_flow/order_tracking_data.dart';
export 'data_flow/payment_action_result.dart';
export 'data_flow/payment_event.dart';
export 'data_flow/payment_link_data.dart';
export 'data_flow/payment_order_detail_hydrated.dart';
export 'data_flow/payment_order_result.dart';
export 'data_flow/payment_page_data.dart';
export 'data_flow/payment_page_item.dart';
export 'data_flow/payment_session_data.dart';
export 'data_flow/payment_transaction.dart';
export 'data_flow/payment_verify_result.dart';
export 'data_flow/pending_order_info.dart';
export 'data_flow/pricing_line_item.dart';
export 'data_flow/product.dart';
export 'data_flow/product_form_reference_data.dart';
export 'data_flow/product_page.dart';
export 'data_flow/product_ranking_item.dart';
export 'data_flow/product_variant.dart';
export 'data_flow/razorpay_payment_status.dart';
export 'data_flow/razorpay_refund_data.dart';
export 'data_flow/referral.dart';
export 'data_flow/referral_activity.dart';
export 'data_flow/referral_admin_stats.dart';
export 'data_flow/referral_code_info.dart';
export 'data_flow/referral_fraud_result.dart';
export 'data_flow/referral_fraud_rule_result.dart';
export 'data_flow/referral_onboarding_status.dart';
export 'data_flow/referral_settings.dart';
export 'data_flow/refund_record.dart';
export 'data_flow/register_fcm_token_request.dart';
export 'data_flow/sub_category.dart';
export 'data_flow/support_issue.dart';
export 'data_flow/top_referrer_entry.dart';
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
    if (t == _i27.CartComparisonData) {
      return _i27.CartComparisonData.fromJson(data) as T;
    }
    if (t == _i28.CartHydratedData) {
      return _i28.CartHydratedData.fromJson(data) as T;
    }
    if (t == _i29.CartItem) {
      return _i29.CartItem.fromJson(data) as T;
    }
    if (t == _i30.CartItemInput) {
      return _i30.CartItemInput.fromJson(data) as T;
    }
    if (t == _i31.CartItemSnapshot) {
      return _i31.CartItemSnapshot.fromJson(data) as T;
    }
    if (t == _i32.CartPricingResult) {
      return _i32.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i33.CascadeEntityInfo) {
      return _i33.CascadeEntityInfo.fromJson(data) as T;
    }
    if (t == _i34.CascadeExecuteResponse) {
      return _i34.CascadeExecuteResponse.fromJson(data) as T;
    }
    if (t == _i35.CascadeImpactResponse) {
      return _i35.CascadeImpactResponse.fromJson(data) as T;
    }
    if (t == _i36.Category) {
      return _i36.Category.fromJson(data) as T;
    }
    if (t == _i37.CategoryHierarchy) {
      return _i37.CategoryHierarchy.fromJson(data) as T;
    }
    if (t == _i38.CategoryOffer) {
      return _i38.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i39.CategoryOfferPage) {
      return _i39.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i40.CheckoutInitHydrated) {
      return _i40.CheckoutInitHydrated.fromJson(data) as T;
    }
    if (t == _i41.CheckoutResult) {
      return _i41.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i42.ComboOffer) {
      return _i42.ComboOffer.fromJson(data) as T;
    }
    if (t == _i43.ComboOfferPage) {
      return _i43.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i44.ComboProductItem) {
      return _i44.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i45.Complaint) {
      return _i45.Complaint.fromJson(data) as T;
    }
    if (t == _i46.ComplaintDetailHydrated) {
      return _i46.ComplaintDetailHydrated.fromJson(data) as T;
    }
    if (t == _i47.ComplaintPage) {
      return _i47.ComplaintPage.fromJson(data) as T;
    }
    if (t == _i48.ComplaintProductItem) {
      return _i48.ComplaintProductItem.fromJson(data) as T;
    }
    if (t == _i49.Coupon) {
      return _i49.Coupon.fromJson(data) as T;
    }
    if (t == _i50.CouponDisplay) {
      return _i50.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i51.CouponValidationResult) {
      return _i51.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i52.DeleteImpactReference) {
      return _i52.DeleteImpactReference.fromJson(data) as T;
    }
    if (t == _i53.DeleteImpactResponse) {
      return _i53.DeleteImpactResponse.fromJson(data) as T;
    }
    if (t == _i54.DeliveryConfig) {
      return _i54.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i55.DeliveryPricingResult) {
      return _i55.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i56.DeliveryRule) {
      return _i56.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i57.DeliveryRulePage) {
      return _i57.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i58.DeliverySlab) {
      return _i58.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i59.FreeDeliveryHydrated) {
      return _i59.FreeDeliveryHydrated.fromJson(data) as T;
    }
    if (t == _i60.FreeDeliveryRule) {
      return _i60.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i61.FreeDeliveryRulePage) {
      return _i61.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i62.FreeItemInfo) {
      return _i62.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i63.FreshPointsAdjustRequest) {
      return _i63.FreshPointsAdjustRequest.fromJson(data) as T;
    }
    if (t == _i64.FreshPointsBalance) {
      return _i64.FreshPointsBalance.fromJson(data) as T;
    }
    if (t == _i65.FreshPointsSettings) {
      return _i65.FreshPointsSettings.fromJson(data) as T;
    }
    if (t == _i66.FreshPointsTransaction) {
      return _i66.FreshPointsTransaction.fromJson(data) as T;
    }
    if (t == _i67.HardDeleteResponse) {
      return _i67.HardDeleteResponse.fromJson(data) as T;
    }
    if (t == _i68.HomePageHydratedData) {
      return _i68.HomePageHydratedData.fromJson(data) as T;
    }
    if (t == _i69.NotificationDraft) {
      return _i69.NotificationDraft.fromJson(data) as T;
    }
    if (t == _i70.NotificationHistoryItem) {
      return _i70.NotificationHistoryItem.fromJson(data) as T;
    }
    if (t == _i71.NotificationHistoryPage) {
      return _i71.NotificationHistoryPage.fromJson(data) as T;
    }
    if (t == _i72.NotificationPreference) {
      return _i72.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i73.OfferConflictResponse) {
      return _i73.OfferConflictResponse.fromJson(data) as T;
    }
    if (t == _i74.OfferMutationResult) {
      return _i74.OfferMutationResult.fromJson(data) as T;
    }
    if (t == _i75.OfferSearchItem) {
      return _i75.OfferSearchItem.fromJson(data) as T;
    }
    if (t == _i76.OfferSearchPage) {
      return _i76.OfferSearchPage.fromJson(data) as T;
    }
    if (t == _i77.Order) {
      return _i77.Order.fromJson(data) as T;
    }
    if (t == _i78.OrderDetailHydrated) {
      return _i78.OrderDetailHydrated.fromJson(data) as T;
    }
    if (t == _i79.OrderItem) {
      return _i79.OrderItem.fromJson(data) as T;
    }
    if (t == _i80.OrderPage) {
      return _i80.OrderPage.fromJson(data) as T;
    }
    if (t == _i81.OrderRealtimeEvent) {
      return _i81.OrderRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i82.OrderTrackingData) {
      return _i82.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i83.PaymentActionResult) {
      return _i83.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i84.PaymentEvent) {
      return _i84.PaymentEvent.fromJson(data) as T;
    }
    if (t == _i85.PaymentLinkData) {
      return _i85.PaymentLinkData.fromJson(data) as T;
    }
    if (t == _i86.PaymentOrderDetailHydrated) {
      return _i86.PaymentOrderDetailHydrated.fromJson(data) as T;
    }
    if (t == _i87.PaymentOrderResult) {
      return _i87.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i88.PaymentPageData) {
      return _i88.PaymentPageData.fromJson(data) as T;
    }
    if (t == _i89.PaymentPageItem) {
      return _i89.PaymentPageItem.fromJson(data) as T;
    }
    if (t == _i90.PaymentSessionData) {
      return _i90.PaymentSessionData.fromJson(data) as T;
    }
    if (t == _i91.PaymentTransaction) {
      return _i91.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i92.PaymentVerifyResult) {
      return _i92.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i93.PendingOrderInfo) {
      return _i93.PendingOrderInfo.fromJson(data) as T;
    }
    if (t == _i94.PricingLineItem) {
      return _i94.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i95.Product) {
      return _i95.Product.fromJson(data) as T;
    }
    if (t == _i96.ProductFormReferenceData) {
      return _i96.ProductFormReferenceData.fromJson(data) as T;
    }
    if (t == _i97.ProductPage) {
      return _i97.ProductPage.fromJson(data) as T;
    }
    if (t == _i98.ProductRankingItem) {
      return _i98.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i99.ProductVariant) {
      return _i99.ProductVariant.fromJson(data) as T;
    }
    if (t == _i100.RazorpayPaymentStatus) {
      return _i100.RazorpayPaymentStatus.fromJson(data) as T;
    }
    if (t == _i101.RazorpayRefundData) {
      return _i101.RazorpayRefundData.fromJson(data) as T;
    }
    if (t == _i102.Referral) {
      return _i102.Referral.fromJson(data) as T;
    }
    if (t == _i103.ReferralActivity) {
      return _i103.ReferralActivity.fromJson(data) as T;
    }
    if (t == _i104.ReferralAdminStats) {
      return _i104.ReferralAdminStats.fromJson(data) as T;
    }
    if (t == _i105.ReferralCodeInfo) {
      return _i105.ReferralCodeInfo.fromJson(data) as T;
    }
    if (t == _i106.ReferralFraudResult) {
      return _i106.ReferralFraudResult.fromJson(data) as T;
    }
    if (t == _i107.ReferralFraudRuleResult) {
      return _i107.ReferralFraudRuleResult.fromJson(data) as T;
    }
    if (t == _i108.ReferralOnboardingStatus) {
      return _i108.ReferralOnboardingStatus.fromJson(data) as T;
    }
    if (t == _i109.ReferralSettings) {
      return _i109.ReferralSettings.fromJson(data) as T;
    }
    if (t == _i110.RefundRecord) {
      return _i110.RefundRecord.fromJson(data) as T;
    }
    if (t == _i111.RegisterFcmTokenRequest) {
      return _i111.RegisterFcmTokenRequest.fromJson(data) as T;
    }
    if (t == _i112.SubCategory) {
      return _i112.SubCategory.fromJson(data) as T;
    }
    if (t == _i113.SupportIssue) {
      return _i113.SupportIssue.fromJson(data) as T;
    }
    if (t == _i114.TopReferrerEntry) {
      return _i114.TopReferrerEntry.fromJson(data) as T;
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
    if (t == _i1.getType<_i27.CartComparisonData?>()) {
      return (data != null ? _i27.CartComparisonData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.CartHydratedData?>()) {
      return (data != null ? _i28.CartHydratedData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.CartItem?>()) {
      return (data != null ? _i29.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CartItemInput?>()) {
      return (data != null ? _i30.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.CartItemSnapshot?>()) {
      return (data != null ? _i31.CartItemSnapshot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CartPricingResult?>()) {
      return (data != null ? _i32.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.CascadeEntityInfo?>()) {
      return (data != null ? _i33.CascadeEntityInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CascadeExecuteResponse?>()) {
      return (data != null ? _i34.CascadeExecuteResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.CascadeImpactResponse?>()) {
      return (data != null ? _i35.CascadeImpactResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.Category?>()) {
      return (data != null ? _i36.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.CategoryHierarchy?>()) {
      return (data != null ? _i37.CategoryHierarchy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.CategoryOffer?>()) {
      return (data != null ? _i38.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.CategoryOfferPage?>()) {
      return (data != null ? _i39.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.CheckoutInitHydrated?>()) {
      return (data != null ? _i40.CheckoutInitHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.CheckoutResult?>()) {
      return (data != null ? _i41.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ComboOffer?>()) {
      return (data != null ? _i42.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ComboOfferPage?>()) {
      return (data != null ? _i43.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.ComboProductItem?>()) {
      return (data != null ? _i44.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.Complaint?>()) {
      return (data != null ? _i45.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.ComplaintDetailHydrated?>()) {
      return (data != null ? _i46.ComplaintDetailHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.ComplaintPage?>()) {
      return (data != null ? _i47.ComplaintPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ComplaintProductItem?>()) {
      return (data != null ? _i48.ComplaintProductItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.Coupon?>()) {
      return (data != null ? _i49.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.CouponDisplay?>()) {
      return (data != null ? _i50.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.CouponValidationResult?>()) {
      return (data != null ? _i51.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.DeleteImpactReference?>()) {
      return (data != null ? _i52.DeleteImpactReference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.DeleteImpactResponse?>()) {
      return (data != null ? _i53.DeleteImpactResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.DeliveryConfig?>()) {
      return (data != null ? _i54.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.DeliveryPricingResult?>()) {
      return (data != null ? _i55.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.DeliveryRule?>()) {
      return (data != null ? _i56.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.DeliveryRulePage?>()) {
      return (data != null ? _i57.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.DeliverySlab?>()) {
      return (data != null ? _i58.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.FreeDeliveryHydrated?>()) {
      return (data != null ? _i59.FreeDeliveryHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.FreeDeliveryRule?>()) {
      return (data != null ? _i60.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.FreeDeliveryRulePage?>()) {
      return (data != null ? _i61.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.FreeItemInfo?>()) {
      return (data != null ? _i62.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.FreshPointsAdjustRequest?>()) {
      return (data != null
              ? _i63.FreshPointsAdjustRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i64.FreshPointsBalance?>()) {
      return (data != null ? _i64.FreshPointsBalance.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.FreshPointsSettings?>()) {
      return (data != null ? _i65.FreshPointsSettings.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.FreshPointsTransaction?>()) {
      return (data != null ? _i66.FreshPointsTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.HardDeleteResponse?>()) {
      return (data != null ? _i67.HardDeleteResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.HomePageHydratedData?>()) {
      return (data != null ? _i68.HomePageHydratedData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.NotificationDraft?>()) {
      return (data != null ? _i69.NotificationDraft.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.NotificationHistoryItem?>()) {
      return (data != null ? _i70.NotificationHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.NotificationHistoryPage?>()) {
      return (data != null ? _i71.NotificationHistoryPage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.NotificationPreference?>()) {
      return (data != null ? _i72.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.OfferConflictResponse?>()) {
      return (data != null ? _i73.OfferConflictResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.OfferMutationResult?>()) {
      return (data != null ? _i74.OfferMutationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i75.OfferSearchItem?>()) {
      return (data != null ? _i75.OfferSearchItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.OfferSearchPage?>()) {
      return (data != null ? _i76.OfferSearchPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.Order?>()) {
      return (data != null ? _i77.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.OrderDetailHydrated?>()) {
      return (data != null ? _i78.OrderDetailHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i79.OrderItem?>()) {
      return (data != null ? _i79.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.OrderPage?>()) {
      return (data != null ? _i80.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.OrderRealtimeEvent?>()) {
      return (data != null ? _i81.OrderRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.OrderTrackingData?>()) {
      return (data != null ? _i82.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.PaymentActionResult?>()) {
      return (data != null ? _i83.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.PaymentEvent?>()) {
      return (data != null ? _i84.PaymentEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.PaymentLinkData?>()) {
      return (data != null ? _i85.PaymentLinkData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.PaymentOrderDetailHydrated?>()) {
      return (data != null
              ? _i86.PaymentOrderDetailHydrated.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i87.PaymentOrderResult?>()) {
      return (data != null ? _i87.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.PaymentPageData?>()) {
      return (data != null ? _i88.PaymentPageData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.PaymentPageItem?>()) {
      return (data != null ? _i89.PaymentPageItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.PaymentSessionData?>()) {
      return (data != null ? _i90.PaymentSessionData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i91.PaymentTransaction?>()) {
      return (data != null ? _i91.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i92.PaymentVerifyResult?>()) {
      return (data != null ? _i92.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i93.PendingOrderInfo?>()) {
      return (data != null ? _i93.PendingOrderInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.PricingLineItem?>()) {
      return (data != null ? _i94.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.Product?>()) {
      return (data != null ? _i95.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.ProductFormReferenceData?>()) {
      return (data != null
              ? _i96.ProductFormReferenceData.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i97.ProductPage?>()) {
      return (data != null ? _i97.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.ProductRankingItem?>()) {
      return (data != null ? _i98.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i99.ProductVariant?>()) {
      return (data != null ? _i99.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.RazorpayPaymentStatus?>()) {
      return (data != null ? _i100.RazorpayPaymentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i101.RazorpayRefundData?>()) {
      return (data != null ? _i101.RazorpayRefundData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i102.Referral?>()) {
      return (data != null ? _i102.Referral.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.ReferralActivity?>()) {
      return (data != null ? _i103.ReferralActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.ReferralAdminStats?>()) {
      return (data != null ? _i104.ReferralAdminStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i105.ReferralCodeInfo?>()) {
      return (data != null ? _i105.ReferralCodeInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i106.ReferralFraudResult?>()) {
      return (data != null ? _i106.ReferralFraudResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.ReferralFraudRuleResult?>()) {
      return (data != null
              ? _i107.ReferralFraudRuleResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i108.ReferralOnboardingStatus?>()) {
      return (data != null
              ? _i108.ReferralOnboardingStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i109.ReferralSettings?>()) {
      return (data != null ? _i109.ReferralSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.RefundRecord?>()) {
      return (data != null ? _i110.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.RegisterFcmTokenRequest?>()) {
      return (data != null
              ? _i111.RegisterFcmTokenRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i112.SubCategory?>()) {
      return (data != null ? _i112.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i113.SupportIssue?>()) {
      return (data != null ? _i113.SupportIssue.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.TopReferrerEntry?>()) {
      return (data != null ? _i114.TopReferrerEntry.fromJson(data) : null) as T;
    }
    if (t == List<_i10.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.CartItem>) {
      return (data as List).map((e) => deserialize<_i29.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i29.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i29.CartItem>(e))
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
    if (t == List<_i31.CartItemSnapshot>) {
      return (data as List)
              .map((e) => deserialize<_i31.CartItemSnapshot>(e))
              .toList()
          as T;
    }
    if (t == List<_i50.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i50.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i14.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i62.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i94.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i94.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.CascadeEntityInfo>) {
      return (data as List)
              .map((e) => deserialize<_i33.CascadeEntityInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.Category>) {
      return (data as List).map((e) => deserialize<_i36.Category>(e)).toList()
          as T;
    }
    if (t == List<_i112.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i112.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i38.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i44.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i42.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i48.ComplaintProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i48.ComplaintProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.Complaint>) {
      return (data as List).map((e) => deserialize<_i45.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i52.DeleteImpactReference>) {
      return (data as List)
              .map((e) => deserialize<_i52.DeleteImpactReference>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i58.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i56.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i56.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i60.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.FreshPointsTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i66.FreshPointsTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i95.Product>) {
      return (data as List).map((e) => deserialize<_i95.Product>(e)).toList()
          as T;
    }
    if (t == List<_i70.NotificationHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i70.NotificationHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i95.Product>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i95.Product>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i75.OfferSearchItem>) {
      return (data as List)
              .map((e) => deserialize<_i75.OfferSearchItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.OrderItem>) {
      return (data as List).map((e) => deserialize<_i79.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i77.Order>) {
      return (data as List).map((e) => deserialize<_i77.Order>(e)).toList()
          as T;
    }
    if (t == List<_i110.RefundRecord>) {
      return (data as List)
              .map((e) => deserialize<_i110.RefundRecord>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i110.RefundRecord>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i110.RefundRecord>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i89.PaymentPageItem>) {
      return (data as List)
              .map((e) => deserialize<_i89.PaymentPageItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i89.PaymentPageItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i89.PaymentPageItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i99.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i99.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i99.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i99.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i114.TopReferrerEntry>) {
      return (data as List)
              .map((e) => deserialize<_i114.TopReferrerEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i107.ReferralFraudRuleResult>) {
      return (data as List)
              .map((e) => deserialize<_i107.ReferralFraudRuleResult>(e))
              .toList()
          as T;
    }
    if (t == List<_i115.AppUser>) {
      return (data as List).map((e) => deserialize<_i115.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i116.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i116.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i117.ActiveUserStatistics>) {
      return (data as List)
              .map((e) => deserialize<_i117.ActiveUserStatistics>(e))
              .toList()
          as T;
    }
    if (t == List<_i118.Banner>) {
      return (data as List).map((e) => deserialize<_i118.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i119.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i119.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i120.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i120.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i121.Category>) {
      return (data as List).map((e) => deserialize<_i121.Category>(e)).toList()
          as T;
    }
    if (t == List<_i122.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i122.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i123.ComboOffer>) {
      return (data as List)
              .map((e) => deserialize<_i123.ComboOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i124.Coupon>) {
      return (data as List).map((e) => deserialize<_i124.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i125.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i125.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i126.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i126.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i120.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i120.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i127.AdminNotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i127.AdminNotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i128.Order>) {
      return (data as List).map((e) => deserialize<_i128.Order>(e)).toList()
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
    if (t == List<_i129.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i129.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i130.Product>) {
      return (data as List).map((e) => deserialize<_i130.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i131.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i131.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i132.ReferralActivity>) {
      return (data as List)
              .map((e) => deserialize<_i132.ReferralActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i133.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i133.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i134.SupportIssue>) {
      return (data as List)
              .map((e) => deserialize<_i134.SupportIssue>(e))
              .toList()
          as T;
    }
    if (t == List<_i135.CartItem>) {
      return (data as List).map((e) => deserialize<_i135.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i136.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i137.Protocol().deserialize<T>(data, t);
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
      _i27.CartComparisonData => 'CartComparisonData',
      _i28.CartHydratedData => 'CartHydratedData',
      _i29.CartItem => 'CartItem',
      _i30.CartItemInput => 'CartItemInput',
      _i31.CartItemSnapshot => 'CartItemSnapshot',
      _i32.CartPricingResult => 'CartPricingResult',
      _i33.CascadeEntityInfo => 'CascadeEntityInfo',
      _i34.CascadeExecuteResponse => 'CascadeExecuteResponse',
      _i35.CascadeImpactResponse => 'CascadeImpactResponse',
      _i36.Category => 'Category',
      _i37.CategoryHierarchy => 'CategoryHierarchy',
      _i38.CategoryOffer => 'CategoryOffer',
      _i39.CategoryOfferPage => 'CategoryOfferPage',
      _i40.CheckoutInitHydrated => 'CheckoutInitHydrated',
      _i41.CheckoutResult => 'CheckoutResult',
      _i42.ComboOffer => 'ComboOffer',
      _i43.ComboOfferPage => 'ComboOfferPage',
      _i44.ComboProductItem => 'ComboProductItem',
      _i45.Complaint => 'Complaint',
      _i46.ComplaintDetailHydrated => 'ComplaintDetailHydrated',
      _i47.ComplaintPage => 'ComplaintPage',
      _i48.ComplaintProductItem => 'ComplaintProductItem',
      _i49.Coupon => 'Coupon',
      _i50.CouponDisplay => 'CouponDisplay',
      _i51.CouponValidationResult => 'CouponValidationResult',
      _i52.DeleteImpactReference => 'DeleteImpactReference',
      _i53.DeleteImpactResponse => 'DeleteImpactResponse',
      _i54.DeliveryConfig => 'DeliveryConfig',
      _i55.DeliveryPricingResult => 'DeliveryPricingResult',
      _i56.DeliveryRule => 'DeliveryRule',
      _i57.DeliveryRulePage => 'DeliveryRulePage',
      _i58.DeliverySlab => 'DeliverySlab',
      _i59.FreeDeliveryHydrated => 'FreeDeliveryHydrated',
      _i60.FreeDeliveryRule => 'FreeDeliveryRule',
      _i61.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i62.FreeItemInfo => 'FreeItemInfo',
      _i63.FreshPointsAdjustRequest => 'FreshPointsAdjustRequest',
      _i64.FreshPointsBalance => 'FreshPointsBalance',
      _i65.FreshPointsSettings => 'FreshPointsSettings',
      _i66.FreshPointsTransaction => 'FreshPointsTransaction',
      _i67.HardDeleteResponse => 'HardDeleteResponse',
      _i68.HomePageHydratedData => 'HomePageHydratedData',
      _i69.NotificationDraft => 'NotificationDraft',
      _i70.NotificationHistoryItem => 'NotificationHistoryItem',
      _i71.NotificationHistoryPage => 'NotificationHistoryPage',
      _i72.NotificationPreference => 'NotificationPreference',
      _i73.OfferConflictResponse => 'OfferConflictResponse',
      _i74.OfferMutationResult => 'OfferMutationResult',
      _i75.OfferSearchItem => 'OfferSearchItem',
      _i76.OfferSearchPage => 'OfferSearchPage',
      _i77.Order => 'Order',
      _i78.OrderDetailHydrated => 'OrderDetailHydrated',
      _i79.OrderItem => 'OrderItem',
      _i80.OrderPage => 'OrderPage',
      _i81.OrderRealtimeEvent => 'OrderRealtimeEvent',
      _i82.OrderTrackingData => 'OrderTrackingData',
      _i83.PaymentActionResult => 'PaymentActionResult',
      _i84.PaymentEvent => 'PaymentEvent',
      _i85.PaymentLinkData => 'PaymentLinkData',
      _i86.PaymentOrderDetailHydrated => 'PaymentOrderDetailHydrated',
      _i87.PaymentOrderResult => 'PaymentOrderResult',
      _i88.PaymentPageData => 'PaymentPageData',
      _i89.PaymentPageItem => 'PaymentPageItem',
      _i90.PaymentSessionData => 'PaymentSessionData',
      _i91.PaymentTransaction => 'PaymentTransaction',
      _i92.PaymentVerifyResult => 'PaymentVerifyResult',
      _i93.PendingOrderInfo => 'PendingOrderInfo',
      _i94.PricingLineItem => 'PricingLineItem',
      _i95.Product => 'Product',
      _i96.ProductFormReferenceData => 'ProductFormReferenceData',
      _i97.ProductPage => 'ProductPage',
      _i98.ProductRankingItem => 'ProductRankingItem',
      _i99.ProductVariant => 'ProductVariant',
      _i100.RazorpayPaymentStatus => 'RazorpayPaymentStatus',
      _i101.RazorpayRefundData => 'RazorpayRefundData',
      _i102.Referral => 'Referral',
      _i103.ReferralActivity => 'ReferralActivity',
      _i104.ReferralAdminStats => 'ReferralAdminStats',
      _i105.ReferralCodeInfo => 'ReferralCodeInfo',
      _i106.ReferralFraudResult => 'ReferralFraudResult',
      _i107.ReferralFraudRuleResult => 'ReferralFraudRuleResult',
      _i108.ReferralOnboardingStatus => 'ReferralOnboardingStatus',
      _i109.ReferralSettings => 'ReferralSettings',
      _i110.RefundRecord => 'RefundRecord',
      _i111.RegisterFcmTokenRequest => 'RegisterFcmTokenRequest',
      _i112.SubCategory => 'SubCategory',
      _i113.SupportIssue => 'SupportIssue',
      _i114.TopReferrerEntry => 'TopReferrerEntry',
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
      case _i27.CartComparisonData():
        return 'CartComparisonData';
      case _i28.CartHydratedData():
        return 'CartHydratedData';
      case _i29.CartItem():
        return 'CartItem';
      case _i30.CartItemInput():
        return 'CartItemInput';
      case _i31.CartItemSnapshot():
        return 'CartItemSnapshot';
      case _i32.CartPricingResult():
        return 'CartPricingResult';
      case _i33.CascadeEntityInfo():
        return 'CascadeEntityInfo';
      case _i34.CascadeExecuteResponse():
        return 'CascadeExecuteResponse';
      case _i35.CascadeImpactResponse():
        return 'CascadeImpactResponse';
      case _i36.Category():
        return 'Category';
      case _i37.CategoryHierarchy():
        return 'CategoryHierarchy';
      case _i38.CategoryOffer():
        return 'CategoryOffer';
      case _i39.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i40.CheckoutInitHydrated():
        return 'CheckoutInitHydrated';
      case _i41.CheckoutResult():
        return 'CheckoutResult';
      case _i42.ComboOffer():
        return 'ComboOffer';
      case _i43.ComboOfferPage():
        return 'ComboOfferPage';
      case _i44.ComboProductItem():
        return 'ComboProductItem';
      case _i45.Complaint():
        return 'Complaint';
      case _i46.ComplaintDetailHydrated():
        return 'ComplaintDetailHydrated';
      case _i47.ComplaintPage():
        return 'ComplaintPage';
      case _i48.ComplaintProductItem():
        return 'ComplaintProductItem';
      case _i49.Coupon():
        return 'Coupon';
      case _i50.CouponDisplay():
        return 'CouponDisplay';
      case _i51.CouponValidationResult():
        return 'CouponValidationResult';
      case _i52.DeleteImpactReference():
        return 'DeleteImpactReference';
      case _i53.DeleteImpactResponse():
        return 'DeleteImpactResponse';
      case _i54.DeliveryConfig():
        return 'DeliveryConfig';
      case _i55.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i56.DeliveryRule():
        return 'DeliveryRule';
      case _i57.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i58.DeliverySlab():
        return 'DeliverySlab';
      case _i59.FreeDeliveryHydrated():
        return 'FreeDeliveryHydrated';
      case _i60.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i61.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i62.FreeItemInfo():
        return 'FreeItemInfo';
      case _i63.FreshPointsAdjustRequest():
        return 'FreshPointsAdjustRequest';
      case _i64.FreshPointsBalance():
        return 'FreshPointsBalance';
      case _i65.FreshPointsSettings():
        return 'FreshPointsSettings';
      case _i66.FreshPointsTransaction():
        return 'FreshPointsTransaction';
      case _i67.HardDeleteResponse():
        return 'HardDeleteResponse';
      case _i68.HomePageHydratedData():
        return 'HomePageHydratedData';
      case _i69.NotificationDraft():
        return 'NotificationDraft';
      case _i70.NotificationHistoryItem():
        return 'NotificationHistoryItem';
      case _i71.NotificationHistoryPage():
        return 'NotificationHistoryPage';
      case _i72.NotificationPreference():
        return 'NotificationPreference';
      case _i73.OfferConflictResponse():
        return 'OfferConflictResponse';
      case _i74.OfferMutationResult():
        return 'OfferMutationResult';
      case _i75.OfferSearchItem():
        return 'OfferSearchItem';
      case _i76.OfferSearchPage():
        return 'OfferSearchPage';
      case _i77.Order():
        return 'Order';
      case _i78.OrderDetailHydrated():
        return 'OrderDetailHydrated';
      case _i79.OrderItem():
        return 'OrderItem';
      case _i80.OrderPage():
        return 'OrderPage';
      case _i81.OrderRealtimeEvent():
        return 'OrderRealtimeEvent';
      case _i82.OrderTrackingData():
        return 'OrderTrackingData';
      case _i83.PaymentActionResult():
        return 'PaymentActionResult';
      case _i84.PaymentEvent():
        return 'PaymentEvent';
      case _i85.PaymentLinkData():
        return 'PaymentLinkData';
      case _i86.PaymentOrderDetailHydrated():
        return 'PaymentOrderDetailHydrated';
      case _i87.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i88.PaymentPageData():
        return 'PaymentPageData';
      case _i89.PaymentPageItem():
        return 'PaymentPageItem';
      case _i90.PaymentSessionData():
        return 'PaymentSessionData';
      case _i91.PaymentTransaction():
        return 'PaymentTransaction';
      case _i92.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i93.PendingOrderInfo():
        return 'PendingOrderInfo';
      case _i94.PricingLineItem():
        return 'PricingLineItem';
      case _i95.Product():
        return 'Product';
      case _i96.ProductFormReferenceData():
        return 'ProductFormReferenceData';
      case _i97.ProductPage():
        return 'ProductPage';
      case _i98.ProductRankingItem():
        return 'ProductRankingItem';
      case _i99.ProductVariant():
        return 'ProductVariant';
      case _i100.RazorpayPaymentStatus():
        return 'RazorpayPaymentStatus';
      case _i101.RazorpayRefundData():
        return 'RazorpayRefundData';
      case _i102.Referral():
        return 'Referral';
      case _i103.ReferralActivity():
        return 'ReferralActivity';
      case _i104.ReferralAdminStats():
        return 'ReferralAdminStats';
      case _i105.ReferralCodeInfo():
        return 'ReferralCodeInfo';
      case _i106.ReferralFraudResult():
        return 'ReferralFraudResult';
      case _i107.ReferralFraudRuleResult():
        return 'ReferralFraudRuleResult';
      case _i108.ReferralOnboardingStatus():
        return 'ReferralOnboardingStatus';
      case _i109.ReferralSettings():
        return 'ReferralSettings';
      case _i110.RefundRecord():
        return 'RefundRecord';
      case _i111.RegisterFcmTokenRequest():
        return 'RegisterFcmTokenRequest';
      case _i112.SubCategory():
        return 'SubCategory';
      case _i113.SupportIssue():
        return 'SupportIssue';
      case _i114.TopReferrerEntry():
        return 'TopReferrerEntry';
    }
    className = _i136.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i137.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CartComparisonData') {
      return deserialize<_i27.CartComparisonData>(data['data']);
    }
    if (dataClassName == 'CartHydratedData') {
      return deserialize<_i28.CartHydratedData>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i29.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i30.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartItemSnapshot') {
      return deserialize<_i31.CartItemSnapshot>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i32.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'CascadeEntityInfo') {
      return deserialize<_i33.CascadeEntityInfo>(data['data']);
    }
    if (dataClassName == 'CascadeExecuteResponse') {
      return deserialize<_i34.CascadeExecuteResponse>(data['data']);
    }
    if (dataClassName == 'CascadeImpactResponse') {
      return deserialize<_i35.CascadeImpactResponse>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i36.Category>(data['data']);
    }
    if (dataClassName == 'CategoryHierarchy') {
      return deserialize<_i37.CategoryHierarchy>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i38.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i39.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutInitHydrated') {
      return deserialize<_i40.CheckoutInitHydrated>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i41.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i42.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i43.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i44.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i45.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintDetailHydrated') {
      return deserialize<_i46.ComplaintDetailHydrated>(data['data']);
    }
    if (dataClassName == 'ComplaintPage') {
      return deserialize<_i47.ComplaintPage>(data['data']);
    }
    if (dataClassName == 'ComplaintProductItem') {
      return deserialize<_i48.ComplaintProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i49.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i50.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i51.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeleteImpactReference') {
      return deserialize<_i52.DeleteImpactReference>(data['data']);
    }
    if (dataClassName == 'DeleteImpactResponse') {
      return deserialize<_i53.DeleteImpactResponse>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i54.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i55.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i56.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i57.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i58.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryHydrated') {
      return deserialize<_i59.FreeDeliveryHydrated>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i60.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i61.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i62.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'FreshPointsAdjustRequest') {
      return deserialize<_i63.FreshPointsAdjustRequest>(data['data']);
    }
    if (dataClassName == 'FreshPointsBalance') {
      return deserialize<_i64.FreshPointsBalance>(data['data']);
    }
    if (dataClassName == 'FreshPointsSettings') {
      return deserialize<_i65.FreshPointsSettings>(data['data']);
    }
    if (dataClassName == 'FreshPointsTransaction') {
      return deserialize<_i66.FreshPointsTransaction>(data['data']);
    }
    if (dataClassName == 'HardDeleteResponse') {
      return deserialize<_i67.HardDeleteResponse>(data['data']);
    }
    if (dataClassName == 'HomePageHydratedData') {
      return deserialize<_i68.HomePageHydratedData>(data['data']);
    }
    if (dataClassName == 'NotificationDraft') {
      return deserialize<_i69.NotificationDraft>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryItem') {
      return deserialize<_i70.NotificationHistoryItem>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryPage') {
      return deserialize<_i71.NotificationHistoryPage>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i72.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'OfferConflictResponse') {
      return deserialize<_i73.OfferConflictResponse>(data['data']);
    }
    if (dataClassName == 'OfferMutationResult') {
      return deserialize<_i74.OfferMutationResult>(data['data']);
    }
    if (dataClassName == 'OfferSearchItem') {
      return deserialize<_i75.OfferSearchItem>(data['data']);
    }
    if (dataClassName == 'OfferSearchPage') {
      return deserialize<_i76.OfferSearchPage>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i77.Order>(data['data']);
    }
    if (dataClassName == 'OrderDetailHydrated') {
      return deserialize<_i78.OrderDetailHydrated>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i79.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i80.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderRealtimeEvent') {
      return deserialize<_i81.OrderRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i82.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i83.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentEvent') {
      return deserialize<_i84.PaymentEvent>(data['data']);
    }
    if (dataClassName == 'PaymentLinkData') {
      return deserialize<_i85.PaymentLinkData>(data['data']);
    }
    if (dataClassName == 'PaymentOrderDetailHydrated') {
      return deserialize<_i86.PaymentOrderDetailHydrated>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i87.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentPageData') {
      return deserialize<_i88.PaymentPageData>(data['data']);
    }
    if (dataClassName == 'PaymentPageItem') {
      return deserialize<_i89.PaymentPageItem>(data['data']);
    }
    if (dataClassName == 'PaymentSessionData') {
      return deserialize<_i90.PaymentSessionData>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i91.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i92.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PendingOrderInfo') {
      return deserialize<_i93.PendingOrderInfo>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i94.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i95.Product>(data['data']);
    }
    if (dataClassName == 'ProductFormReferenceData') {
      return deserialize<_i96.ProductFormReferenceData>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i97.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i98.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i99.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RazorpayPaymentStatus') {
      return deserialize<_i100.RazorpayPaymentStatus>(data['data']);
    }
    if (dataClassName == 'RazorpayRefundData') {
      return deserialize<_i101.RazorpayRefundData>(data['data']);
    }
    if (dataClassName == 'Referral') {
      return deserialize<_i102.Referral>(data['data']);
    }
    if (dataClassName == 'ReferralActivity') {
      return deserialize<_i103.ReferralActivity>(data['data']);
    }
    if (dataClassName == 'ReferralAdminStats') {
      return deserialize<_i104.ReferralAdminStats>(data['data']);
    }
    if (dataClassName == 'ReferralCodeInfo') {
      return deserialize<_i105.ReferralCodeInfo>(data['data']);
    }
    if (dataClassName == 'ReferralFraudResult') {
      return deserialize<_i106.ReferralFraudResult>(data['data']);
    }
    if (dataClassName == 'ReferralFraudRuleResult') {
      return deserialize<_i107.ReferralFraudRuleResult>(data['data']);
    }
    if (dataClassName == 'ReferralOnboardingStatus') {
      return deserialize<_i108.ReferralOnboardingStatus>(data['data']);
    }
    if (dataClassName == 'ReferralSettings') {
      return deserialize<_i109.ReferralSettings>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i110.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RegisterFcmTokenRequest') {
      return deserialize<_i111.RegisterFcmTokenRequest>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i112.SubCategory>(data['data']);
    }
    if (dataClassName == 'SupportIssue') {
      return deserialize<_i113.SupportIssue>(data['data']);
    }
    if (dataClassName == 'TopReferrerEntry') {
      return deserialize<_i114.TopReferrerEntry>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i136.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i137.Protocol().deserializeByClassName(data);
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
      return _i136.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i137.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
