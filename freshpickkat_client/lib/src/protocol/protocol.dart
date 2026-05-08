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
import 'address.dart' as _i2;
import 'admin_analytics.dart' as _i3;
import 'admin_audit_log_entry.dart' as _i4;
import 'admin_auth_result.dart' as _i5;
import 'admin_dashboard_stats.dart' as _i6;
import 'admin_top_product.dart' as _i7;
import 'app_user.dart' as _i8;
import 'applied_coupon_info.dart' as _i9;
import 'applied_offer_info.dart' as _i10;
import 'banner.dart' as _i11;
import 'banner_page.dart' as _i12;
import 'basket_suggestion.dart' as _i13;
import 'basket_suggestion_action.dart' as _i14;
import 'basket_suggestion_result.dart' as _i15;
import 'best_coupon_result.dart' as _i16;
import 'bogo_free_product.dart' as _i17;
import 'bogo_offer.dart' as _i18;
import 'bogo_offer_page.dart' as _i19;
import 'cart_item.dart' as _i20;
import 'cart_item_input.dart' as _i21;
import 'cart_pricing_result.dart' as _i22;
import 'category.dart' as _i23;
import 'category_offer.dart' as _i24;
import 'category_offer_page.dart' as _i25;
import 'checkout_result.dart' as _i26;
import 'combo_offer.dart' as _i27;
import 'combo_offer_page.dart' as _i28;
import 'combo_product_item.dart' as _i29;
import 'coupon.dart' as _i30;
import 'coupon_display.dart' as _i31;
import 'coupon_validation_result.dart' as _i32;
import 'delivery_config.dart' as _i33;
import 'delivery_pricing_result.dart' as _i34;
import 'delivery_rule.dart' as _i35;
import 'delivery_rule_page.dart' as _i36;
import 'delivery_slab.dart' as _i37;
import 'free_delivery_rule.dart' as _i38;
import 'free_delivery_rule_page.dart' as _i39;
import 'free_item_info.dart' as _i40;
import 'order.dart' as _i41;
import 'order_item.dart' as _i42;
import 'order_page.dart' as _i43;
import 'order_tracking_data.dart' as _i44;
import 'payment_action_result.dart' as _i45;
import 'payment_order_result.dart' as _i46;
import 'payment_verify_result.dart' as _i47;
import 'pricing_line_item.dart' as _i48;
import 'product.dart' as _i49;
import 'product_page.dart' as _i50;
import 'product_variant.dart' as _i51;
import 'refund_record.dart' as _i52;
import 'sub_category.dart' as _i53;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i54;
import 'package:freshpickkat_client/src/protocol/admin_audit_log_entry.dart'
    as _i55;
import 'package:freshpickkat_client/src/protocol/banner.dart' as _i56;
import 'package:freshpickkat_client/src/protocol/bogo_offer.dart' as _i57;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i58;
import 'package:freshpickkat_client/src/protocol/category_offer.dart' as _i59;
import 'package:freshpickkat_client/src/protocol/combo_offer.dart' as _i60;
import 'package:freshpickkat_client/src/protocol/cart_item_input.dart' as _i61;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i62;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i63;
import 'package:freshpickkat_client/src/protocol/delivery_rule.dart' as _i64;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i65;
import 'package:freshpickkat_client/src/protocol/applied_offer_info.dart'
    as _i66;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i67;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i68;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i69;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i70;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i71;
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_auth_result.dart';
export 'admin_dashboard_stats.dart';
export 'admin_top_product.dart';
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
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_tracking_data.dart';
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_verify_result.dart';
export 'pricing_line_item.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_variant.dart';
export 'refund_record.dart';
export 'sub_category.dart';
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

    if (t == _i2.Address) {
      return _i2.Address.fromJson(data) as T;
    }
    if (t == _i3.AdminAnalytics) {
      return _i3.AdminAnalytics.fromJson(data) as T;
    }
    if (t == _i4.AdminAuditLogEntry) {
      return _i4.AdminAuditLogEntry.fromJson(data) as T;
    }
    if (t == _i5.AdminAuthResult) {
      return _i5.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i6.AdminDashboardStats) {
      return _i6.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i7.AdminTopProduct) {
      return _i7.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i8.AppUser) {
      return _i8.AppUser.fromJson(data) as T;
    }
    if (t == _i9.AppliedCouponInfo) {
      return _i9.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i10.AppliedOfferInfo) {
      return _i10.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i11.Banner) {
      return _i11.Banner.fromJson(data) as T;
    }
    if (t == _i12.BannerPage) {
      return _i12.BannerPage.fromJson(data) as T;
    }
    if (t == _i13.BasketSuggestion) {
      return _i13.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i14.BasketSuggestionAction) {
      return _i14.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i15.BasketSuggestionResult) {
      return _i15.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i16.BestCouponResult) {
      return _i16.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i17.BogoFreeProduct) {
      return _i17.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i18.BogoOffer) {
      return _i18.BogoOffer.fromJson(data) as T;
    }
    if (t == _i19.BogoOfferPage) {
      return _i19.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i20.CartItem) {
      return _i20.CartItem.fromJson(data) as T;
    }
    if (t == _i21.CartItemInput) {
      return _i21.CartItemInput.fromJson(data) as T;
    }
    if (t == _i22.CartPricingResult) {
      return _i22.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i23.Category) {
      return _i23.Category.fromJson(data) as T;
    }
    if (t == _i24.CategoryOffer) {
      return _i24.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i25.CategoryOfferPage) {
      return _i25.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i26.CheckoutResult) {
      return _i26.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i27.ComboOffer) {
      return _i27.ComboOffer.fromJson(data) as T;
    }
    if (t == _i28.ComboOfferPage) {
      return _i28.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i29.ComboProductItem) {
      return _i29.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i30.Coupon) {
      return _i30.Coupon.fromJson(data) as T;
    }
    if (t == _i31.CouponDisplay) {
      return _i31.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i32.CouponValidationResult) {
      return _i32.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i33.DeliveryConfig) {
      return _i33.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i34.DeliveryPricingResult) {
      return _i34.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i35.DeliveryRule) {
      return _i35.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i36.DeliveryRulePage) {
      return _i36.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i37.DeliverySlab) {
      return _i37.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i38.FreeDeliveryRule) {
      return _i38.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i39.FreeDeliveryRulePage) {
      return _i39.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i40.FreeItemInfo) {
      return _i40.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i41.Order) {
      return _i41.Order.fromJson(data) as T;
    }
    if (t == _i42.OrderItem) {
      return _i42.OrderItem.fromJson(data) as T;
    }
    if (t == _i43.OrderPage) {
      return _i43.OrderPage.fromJson(data) as T;
    }
    if (t == _i44.OrderTrackingData) {
      return _i44.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i45.PaymentActionResult) {
      return _i45.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i46.PaymentOrderResult) {
      return _i46.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i47.PaymentVerifyResult) {
      return _i47.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i48.PricingLineItem) {
      return _i48.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i49.Product) {
      return _i49.Product.fromJson(data) as T;
    }
    if (t == _i50.ProductPage) {
      return _i50.ProductPage.fromJson(data) as T;
    }
    if (t == _i51.ProductVariant) {
      return _i51.ProductVariant.fromJson(data) as T;
    }
    if (t == _i52.RefundRecord) {
      return _i52.RefundRecord.fromJson(data) as T;
    }
    if (t == _i53.SubCategory) {
      return _i53.SubCategory.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Address?>()) {
      return (data != null ? _i2.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AdminAnalytics?>()) {
      return (data != null ? _i3.AdminAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdminAuditLogEntry?>()) {
      return (data != null ? _i4.AdminAuditLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AdminAuthResult?>()) {
      return (data != null ? _i5.AdminAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminDashboardStats?>()) {
      return (data != null ? _i6.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.AdminTopProduct?>()) {
      return (data != null ? _i7.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AppUser?>()) {
      return (data != null ? _i8.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AppliedCouponInfo?>()) {
      return (data != null ? _i9.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AppliedOfferInfo?>()) {
      return (data != null ? _i10.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Banner?>()) {
      return (data != null ? _i11.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BannerPage?>()) {
      return (data != null ? _i12.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.BasketSuggestion?>()) {
      return (data != null ? _i13.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BasketSuggestionAction?>()) {
      return (data != null ? _i14.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.BasketSuggestionResult?>()) {
      return (data != null ? _i15.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.BestCouponResult?>()) {
      return (data != null ? _i16.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BogoFreeProduct?>()) {
      return (data != null ? _i17.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.BogoOffer?>()) {
      return (data != null ? _i18.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.BogoOfferPage?>()) {
      return (data != null ? _i19.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.CartItem?>()) {
      return (data != null ? _i20.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.CartItemInput?>()) {
      return (data != null ? _i21.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.CartPricingResult?>()) {
      return (data != null ? _i22.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Category?>()) {
      return (data != null ? _i23.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.CategoryOffer?>()) {
      return (data != null ? _i24.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.CategoryOfferPage?>()) {
      return (data != null ? _i25.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CheckoutResult?>()) {
      return (data != null ? _i26.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ComboOffer?>()) {
      return (data != null ? _i27.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ComboOfferPage?>()) {
      return (data != null ? _i28.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ComboProductItem?>()) {
      return (data != null ? _i29.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Coupon?>()) {
      return (data != null ? _i30.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.CouponDisplay?>()) {
      return (data != null ? _i31.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CouponValidationResult?>()) {
      return (data != null ? _i32.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.DeliveryConfig?>()) {
      return (data != null ? _i33.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.DeliveryPricingResult?>()) {
      return (data != null ? _i34.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.DeliveryRule?>()) {
      return (data != null ? _i35.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.DeliveryRulePage?>()) {
      return (data != null ? _i36.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.DeliverySlab?>()) {
      return (data != null ? _i37.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.FreeDeliveryRule?>()) {
      return (data != null ? _i38.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.FreeDeliveryRulePage?>()) {
      return (data != null ? _i39.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.FreeItemInfo?>()) {
      return (data != null ? _i40.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.Order?>()) {
      return (data != null ? _i41.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.OrderItem?>()) {
      return (data != null ? _i42.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.OrderPage?>()) {
      return (data != null ? _i43.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.OrderTrackingData?>()) {
      return (data != null ? _i44.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.PaymentActionResult?>()) {
      return (data != null ? _i45.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.PaymentOrderResult?>()) {
      return (data != null ? _i46.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.PaymentVerifyResult?>()) {
      return (data != null ? _i47.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.PricingLineItem?>()) {
      return (data != null ? _i48.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.Product?>()) {
      return (data != null ? _i49.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ProductPage?>()) {
      return (data != null ? _i50.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.ProductVariant?>()) {
      return (data != null ? _i51.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.RefundRecord?>()) {
      return (data != null ? _i52.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.SubCategory?>()) {
      return (data != null ? _i53.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i7.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i7.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.CartItem>) {
      return (data as List).map((e) => deserialize<_i20.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.CartItem>(e))
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
    if (t == List<_i11.Banner>) {
      return (data as List).map((e) => deserialize<_i11.Banner>(e)).toList()
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
    if (t == List<_i14.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i14.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i14.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i14.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i13.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i17.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i17.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i18.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i18.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i10.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i10.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i40.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i40.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i48.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i24.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i29.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i27.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i37.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i37.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i35.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i38.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.OrderItem>) {
      return (data as List).map((e) => deserialize<_i42.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i41.Order>) {
      return (data as List).map((e) => deserialize<_i41.Order>(e)).toList()
          as T;
    }
    if (t == List<_i51.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i51.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i51.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i51.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i49.Product>) {
      return (data as List).map((e) => deserialize<_i49.Product>(e)).toList()
          as T;
    }
    if (t == List<_i54.AppUser>) {
      return (data as List).map((e) => deserialize<_i54.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i55.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i55.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i56.Banner>) {
      return (data as List).map((e) => deserialize<_i56.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i57.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i57.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i58.Category>) {
      return (data as List).map((e) => deserialize<_i58.Category>(e)).toList()
          as T;
    }
    if (t == List<_i59.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i59.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i60.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i61.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i61.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.Coupon>) {
      return (data as List).map((e) => deserialize<_i62.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i63.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i63.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i64.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.Order>) {
      return (data as List).map((e) => deserialize<_i65.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i66.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i66.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i61.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i61.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i67.Product>) {
      return (data as List).map((e) => deserialize<_i67.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i68.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i68.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.CartItem>) {
      return (data as List).map((e) => deserialize<_i69.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i70.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i71.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Address => 'Address',
      _i3.AdminAnalytics => 'AdminAnalytics',
      _i4.AdminAuditLogEntry => 'AdminAuditLogEntry',
      _i5.AdminAuthResult => 'AdminAuthResult',
      _i6.AdminDashboardStats => 'AdminDashboardStats',
      _i7.AdminTopProduct => 'AdminTopProduct',
      _i8.AppUser => 'AppUser',
      _i9.AppliedCouponInfo => 'AppliedCouponInfo',
      _i10.AppliedOfferInfo => 'AppliedOfferInfo',
      _i11.Banner => 'Banner',
      _i12.BannerPage => 'BannerPage',
      _i13.BasketSuggestion => 'BasketSuggestion',
      _i14.BasketSuggestionAction => 'BasketSuggestionAction',
      _i15.BasketSuggestionResult => 'BasketSuggestionResult',
      _i16.BestCouponResult => 'BestCouponResult',
      _i17.BogoFreeProduct => 'BogoFreeProduct',
      _i18.BogoOffer => 'BogoOffer',
      _i19.BogoOfferPage => 'BogoOfferPage',
      _i20.CartItem => 'CartItem',
      _i21.CartItemInput => 'CartItemInput',
      _i22.CartPricingResult => 'CartPricingResult',
      _i23.Category => 'Category',
      _i24.CategoryOffer => 'CategoryOffer',
      _i25.CategoryOfferPage => 'CategoryOfferPage',
      _i26.CheckoutResult => 'CheckoutResult',
      _i27.ComboOffer => 'ComboOffer',
      _i28.ComboOfferPage => 'ComboOfferPage',
      _i29.ComboProductItem => 'ComboProductItem',
      _i30.Coupon => 'Coupon',
      _i31.CouponDisplay => 'CouponDisplay',
      _i32.CouponValidationResult => 'CouponValidationResult',
      _i33.DeliveryConfig => 'DeliveryConfig',
      _i34.DeliveryPricingResult => 'DeliveryPricingResult',
      _i35.DeliveryRule => 'DeliveryRule',
      _i36.DeliveryRulePage => 'DeliveryRulePage',
      _i37.DeliverySlab => 'DeliverySlab',
      _i38.FreeDeliveryRule => 'FreeDeliveryRule',
      _i39.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i40.FreeItemInfo => 'FreeItemInfo',
      _i41.Order => 'Order',
      _i42.OrderItem => 'OrderItem',
      _i43.OrderPage => 'OrderPage',
      _i44.OrderTrackingData => 'OrderTrackingData',
      _i45.PaymentActionResult => 'PaymentActionResult',
      _i46.PaymentOrderResult => 'PaymentOrderResult',
      _i47.PaymentVerifyResult => 'PaymentVerifyResult',
      _i48.PricingLineItem => 'PricingLineItem',
      _i49.Product => 'Product',
      _i50.ProductPage => 'ProductPage',
      _i51.ProductVariant => 'ProductVariant',
      _i52.RefundRecord => 'RefundRecord',
      _i53.SubCategory => 'SubCategory',
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
      case _i2.Address():
        return 'Address';
      case _i3.AdminAnalytics():
        return 'AdminAnalytics';
      case _i4.AdminAuditLogEntry():
        return 'AdminAuditLogEntry';
      case _i5.AdminAuthResult():
        return 'AdminAuthResult';
      case _i6.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i7.AdminTopProduct():
        return 'AdminTopProduct';
      case _i8.AppUser():
        return 'AppUser';
      case _i9.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i10.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i11.Banner():
        return 'Banner';
      case _i12.BannerPage():
        return 'BannerPage';
      case _i13.BasketSuggestion():
        return 'BasketSuggestion';
      case _i14.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i15.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i16.BestCouponResult():
        return 'BestCouponResult';
      case _i17.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i18.BogoOffer():
        return 'BogoOffer';
      case _i19.BogoOfferPage():
        return 'BogoOfferPage';
      case _i20.CartItem():
        return 'CartItem';
      case _i21.CartItemInput():
        return 'CartItemInput';
      case _i22.CartPricingResult():
        return 'CartPricingResult';
      case _i23.Category():
        return 'Category';
      case _i24.CategoryOffer():
        return 'CategoryOffer';
      case _i25.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i26.CheckoutResult():
        return 'CheckoutResult';
      case _i27.ComboOffer():
        return 'ComboOffer';
      case _i28.ComboOfferPage():
        return 'ComboOfferPage';
      case _i29.ComboProductItem():
        return 'ComboProductItem';
      case _i30.Coupon():
        return 'Coupon';
      case _i31.CouponDisplay():
        return 'CouponDisplay';
      case _i32.CouponValidationResult():
        return 'CouponValidationResult';
      case _i33.DeliveryConfig():
        return 'DeliveryConfig';
      case _i34.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i35.DeliveryRule():
        return 'DeliveryRule';
      case _i36.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i37.DeliverySlab():
        return 'DeliverySlab';
      case _i38.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i39.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i40.FreeItemInfo():
        return 'FreeItemInfo';
      case _i41.Order():
        return 'Order';
      case _i42.OrderItem():
        return 'OrderItem';
      case _i43.OrderPage():
        return 'OrderPage';
      case _i44.OrderTrackingData():
        return 'OrderTrackingData';
      case _i45.PaymentActionResult():
        return 'PaymentActionResult';
      case _i46.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i47.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i48.PricingLineItem():
        return 'PricingLineItem';
      case _i49.Product():
        return 'Product';
      case _i50.ProductPage():
        return 'ProductPage';
      case _i51.ProductVariant():
        return 'ProductVariant';
      case _i52.RefundRecord():
        return 'RefundRecord';
      case _i53.SubCategory():
        return 'SubCategory';
    }
    className = _i70.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i71.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Address') {
      return deserialize<_i2.Address>(data['data']);
    }
    if (dataClassName == 'AdminAnalytics') {
      return deserialize<_i3.AdminAnalytics>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogEntry') {
      return deserialize<_i4.AdminAuditLogEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i5.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i6.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i7.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i8.AppUser>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i9.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i10.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i11.Banner>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i12.BannerPage>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i13.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i14.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i15.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i16.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i17.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i18.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i19.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i20.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i21.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i22.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i23.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i24.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i25.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i26.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i27.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i28.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i29.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i30.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i31.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i32.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i33.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i34.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i35.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i36.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i37.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i38.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i39.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i40.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i41.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i42.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i43.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i44.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i45.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i46.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i47.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i48.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i49.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i50.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i51.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i52.RefundRecord>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i53.SubCategory>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i70.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i71.Protocol().deserializeByClassName(data);
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
      return _i70.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i71.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
