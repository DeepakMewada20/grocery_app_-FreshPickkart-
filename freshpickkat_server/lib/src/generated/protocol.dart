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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'address.dart' as _i5;
import 'admin_analytics.dart' as _i6;
import 'admin_audit_log_entry.dart' as _i7;
import 'admin_auth_result.dart' as _i8;
import 'admin_dashboard_stats.dart' as _i9;
import 'admin_top_product.dart' as _i10;
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
import 'cart_item.dart' as _i23;
import 'cart_item_input.dart' as _i24;
import 'cart_pricing_result.dart' as _i25;
import 'category.dart' as _i26;
import 'category_offer.dart' as _i27;
import 'category_offer_page.dart' as _i28;
import 'checkout_result.dart' as _i29;
import 'combo_offer.dart' as _i30;
import 'combo_offer_page.dart' as _i31;
import 'combo_product_item.dart' as _i32;
import 'coupon.dart' as _i33;
import 'coupon_display.dart' as _i34;
import 'coupon_validation_result.dart' as _i35;
import 'delivery_config.dart' as _i36;
import 'delivery_pricing_result.dart' as _i37;
import 'delivery_rule.dart' as _i38;
import 'delivery_rule_page.dart' as _i39;
import 'delivery_slab.dart' as _i40;
import 'free_delivery_rule.dart' as _i41;
import 'free_delivery_rule_page.dart' as _i42;
import 'free_item_info.dart' as _i43;
import 'order.dart' as _i44;
import 'order_item.dart' as _i45;
import 'order_page.dart' as _i46;
import 'payment_action_result.dart' as _i47;
import 'payment_order_result.dart' as _i48;
import 'payment_verify_result.dart' as _i49;
import 'pricing_line_item.dart' as _i50;
import 'product.dart' as _i51;
import 'product_page.dart' as _i52;
import 'product_variant.dart' as _i53;
import 'refund_record.dart' as _i54;
import 'sub_category.dart' as _i55;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i56;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i57;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i58;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i59;
import 'package:freshpickkat_server/src/generated/category.dart' as _i60;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i61;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i62;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i63;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i64;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i65;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i66;
import 'package:freshpickkat_server/src/generated/order.dart' as _i67;
import 'package:freshpickkat_server/src/generated/applied_offer_info.dart'
    as _i68;
import 'package:freshpickkat_server/src/generated/product.dart' as _i69;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i70;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i71;
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
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_verify_result.dart';
export 'pricing_line_item.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_variant.dart';
export 'refund_record.dart';
export 'sub_category.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.Address) {
      return _i5.Address.fromJson(data) as T;
    }
    if (t == _i6.AdminAnalytics) {
      return _i6.AdminAnalytics.fromJson(data) as T;
    }
    if (t == _i7.AdminAuditLogEntry) {
      return _i7.AdminAuditLogEntry.fromJson(data) as T;
    }
    if (t == _i8.AdminAuthResult) {
      return _i8.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i9.AdminDashboardStats) {
      return _i9.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i10.AdminTopProduct) {
      return _i10.AdminTopProduct.fromJson(data) as T;
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
    if (t == _i23.CartItem) {
      return _i23.CartItem.fromJson(data) as T;
    }
    if (t == _i24.CartItemInput) {
      return _i24.CartItemInput.fromJson(data) as T;
    }
    if (t == _i25.CartPricingResult) {
      return _i25.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i26.Category) {
      return _i26.Category.fromJson(data) as T;
    }
    if (t == _i27.CategoryOffer) {
      return _i27.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i28.CategoryOfferPage) {
      return _i28.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i29.CheckoutResult) {
      return _i29.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i30.ComboOffer) {
      return _i30.ComboOffer.fromJson(data) as T;
    }
    if (t == _i31.ComboOfferPage) {
      return _i31.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i32.ComboProductItem) {
      return _i32.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i33.Coupon) {
      return _i33.Coupon.fromJson(data) as T;
    }
    if (t == _i34.CouponDisplay) {
      return _i34.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i35.CouponValidationResult) {
      return _i35.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i36.DeliveryConfig) {
      return _i36.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i37.DeliveryPricingResult) {
      return _i37.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i38.DeliveryRule) {
      return _i38.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i39.DeliveryRulePage) {
      return _i39.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i40.DeliverySlab) {
      return _i40.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i41.FreeDeliveryRule) {
      return _i41.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i42.FreeDeliveryRulePage) {
      return _i42.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i43.FreeItemInfo) {
      return _i43.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i44.Order) {
      return _i44.Order.fromJson(data) as T;
    }
    if (t == _i45.OrderItem) {
      return _i45.OrderItem.fromJson(data) as T;
    }
    if (t == _i46.OrderPage) {
      return _i46.OrderPage.fromJson(data) as T;
    }
    if (t == _i47.PaymentActionResult) {
      return _i47.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i48.PaymentOrderResult) {
      return _i48.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i49.PaymentVerifyResult) {
      return _i49.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i50.PricingLineItem) {
      return _i50.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i51.Product) {
      return _i51.Product.fromJson(data) as T;
    }
    if (t == _i52.ProductPage) {
      return _i52.ProductPage.fromJson(data) as T;
    }
    if (t == _i53.ProductVariant) {
      return _i53.ProductVariant.fromJson(data) as T;
    }
    if (t == _i54.RefundRecord) {
      return _i54.RefundRecord.fromJson(data) as T;
    }
    if (t == _i55.SubCategory) {
      return _i55.SubCategory.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Address?>()) {
      return (data != null ? _i5.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminAnalytics?>()) {
      return (data != null ? _i6.AdminAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminAuditLogEntry?>()) {
      return (data != null ? _i7.AdminAuditLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AdminAuthResult?>()) {
      return (data != null ? _i8.AdminAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AdminDashboardStats?>()) {
      return (data != null ? _i9.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.AdminTopProduct?>()) {
      return (data != null ? _i10.AdminTopProduct.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i23.CartItem?>()) {
      return (data != null ? _i23.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.CartItemInput?>()) {
      return (data != null ? _i24.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.CartPricingResult?>()) {
      return (data != null ? _i25.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.Category?>()) {
      return (data != null ? _i26.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.CategoryOffer?>()) {
      return (data != null ? _i27.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.CategoryOfferPage?>()) {
      return (data != null ? _i28.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.CheckoutResult?>()) {
      return (data != null ? _i29.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.ComboOffer?>()) {
      return (data != null ? _i30.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.ComboOfferPage?>()) {
      return (data != null ? _i31.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.ComboProductItem?>()) {
      return (data != null ? _i32.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Coupon?>()) {
      return (data != null ? _i33.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CouponDisplay?>()) {
      return (data != null ? _i34.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CouponValidationResult?>()) {
      return (data != null ? _i35.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.DeliveryConfig?>()) {
      return (data != null ? _i36.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.DeliveryPricingResult?>()) {
      return (data != null ? _i37.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.DeliveryRule?>()) {
      return (data != null ? _i38.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.DeliveryRulePage?>()) {
      return (data != null ? _i39.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.DeliverySlab?>()) {
      return (data != null ? _i40.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.FreeDeliveryRule?>()) {
      return (data != null ? _i41.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.FreeDeliveryRulePage?>()) {
      return (data != null ? _i42.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.FreeItemInfo?>()) {
      return (data != null ? _i43.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.Order?>()) {
      return (data != null ? _i44.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.OrderItem?>()) {
      return (data != null ? _i45.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.OrderPage?>()) {
      return (data != null ? _i46.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.PaymentActionResult?>()) {
      return (data != null ? _i47.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.PaymentOrderResult?>()) {
      return (data != null ? _i48.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.PaymentVerifyResult?>()) {
      return (data != null ? _i49.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.PricingLineItem?>()) {
      return (data != null ? _i50.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.Product?>()) {
      return (data != null ? _i51.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ProductPage?>()) {
      return (data != null ? _i52.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.ProductVariant?>()) {
      return (data != null ? _i53.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.RefundRecord?>()) {
      return (data != null ? _i54.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.SubCategory?>()) {
      return (data != null ? _i55.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i10.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.CartItem>) {
      return (data as List).map((e) => deserialize<_i23.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i23.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i23.CartItem>(e))
                    .toList()
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
    if (t == List<_i13.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i13.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i43.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i50.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i50.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i27.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i27.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i32.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i30.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i40.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i40.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i38.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i41.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.OrderItem>) {
      return (data as List).map((e) => deserialize<_i45.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i44.Order>) {
      return (data as List).map((e) => deserialize<_i44.Order>(e)).toList()
          as T;
    }
    if (t == List<_i53.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i53.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i53.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i53.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i51.Product>) {
      return (data as List).map((e) => deserialize<_i51.Product>(e)).toList()
          as T;
    }
    if (t == List<_i56.AppUser>) {
      return (data as List).map((e) => deserialize<_i56.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i57.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i57.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.Banner>) {
      return (data as List).map((e) => deserialize<_i58.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i59.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i59.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i60.Category>) {
      return (data as List).map((e) => deserialize<_i60.Category>(e)).toList()
          as T;
    }
    if (t == List<_i61.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i61.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i62.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i63.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i63.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.Coupon>) {
      return (data as List).map((e) => deserialize<_i64.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i65.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i65.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i66.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.Order>) {
      return (data as List).map((e) => deserialize<_i67.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i68.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i68.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i63.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i63.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i69.Product>) {
      return (data as List).map((e) => deserialize<_i69.Product>(e)).toList()
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
    if (t == List<_i70.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i70.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.CartItem>) {
      return (data as List).map((e) => deserialize<_i71.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.Address => 'Address',
      _i6.AdminAnalytics => 'AdminAnalytics',
      _i7.AdminAuditLogEntry => 'AdminAuditLogEntry',
      _i8.AdminAuthResult => 'AdminAuthResult',
      _i9.AdminDashboardStats => 'AdminDashboardStats',
      _i10.AdminTopProduct => 'AdminTopProduct',
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
      _i23.CartItem => 'CartItem',
      _i24.CartItemInput => 'CartItemInput',
      _i25.CartPricingResult => 'CartPricingResult',
      _i26.Category => 'Category',
      _i27.CategoryOffer => 'CategoryOffer',
      _i28.CategoryOfferPage => 'CategoryOfferPage',
      _i29.CheckoutResult => 'CheckoutResult',
      _i30.ComboOffer => 'ComboOffer',
      _i31.ComboOfferPage => 'ComboOfferPage',
      _i32.ComboProductItem => 'ComboProductItem',
      _i33.Coupon => 'Coupon',
      _i34.CouponDisplay => 'CouponDisplay',
      _i35.CouponValidationResult => 'CouponValidationResult',
      _i36.DeliveryConfig => 'DeliveryConfig',
      _i37.DeliveryPricingResult => 'DeliveryPricingResult',
      _i38.DeliveryRule => 'DeliveryRule',
      _i39.DeliveryRulePage => 'DeliveryRulePage',
      _i40.DeliverySlab => 'DeliverySlab',
      _i41.FreeDeliveryRule => 'FreeDeliveryRule',
      _i42.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i43.FreeItemInfo => 'FreeItemInfo',
      _i44.Order => 'Order',
      _i45.OrderItem => 'OrderItem',
      _i46.OrderPage => 'OrderPage',
      _i47.PaymentActionResult => 'PaymentActionResult',
      _i48.PaymentOrderResult => 'PaymentOrderResult',
      _i49.PaymentVerifyResult => 'PaymentVerifyResult',
      _i50.PricingLineItem => 'PricingLineItem',
      _i51.Product => 'Product',
      _i52.ProductPage => 'ProductPage',
      _i53.ProductVariant => 'ProductVariant',
      _i54.RefundRecord => 'RefundRecord',
      _i55.SubCategory => 'SubCategory',
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
      case _i5.Address():
        return 'Address';
      case _i6.AdminAnalytics():
        return 'AdminAnalytics';
      case _i7.AdminAuditLogEntry():
        return 'AdminAuditLogEntry';
      case _i8.AdminAuthResult():
        return 'AdminAuthResult';
      case _i9.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i10.AdminTopProduct():
        return 'AdminTopProduct';
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
      case _i23.CartItem():
        return 'CartItem';
      case _i24.CartItemInput():
        return 'CartItemInput';
      case _i25.CartPricingResult():
        return 'CartPricingResult';
      case _i26.Category():
        return 'Category';
      case _i27.CategoryOffer():
        return 'CategoryOffer';
      case _i28.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i29.CheckoutResult():
        return 'CheckoutResult';
      case _i30.ComboOffer():
        return 'ComboOffer';
      case _i31.ComboOfferPage():
        return 'ComboOfferPage';
      case _i32.ComboProductItem():
        return 'ComboProductItem';
      case _i33.Coupon():
        return 'Coupon';
      case _i34.CouponDisplay():
        return 'CouponDisplay';
      case _i35.CouponValidationResult():
        return 'CouponValidationResult';
      case _i36.DeliveryConfig():
        return 'DeliveryConfig';
      case _i37.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i38.DeliveryRule():
        return 'DeliveryRule';
      case _i39.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i40.DeliverySlab():
        return 'DeliverySlab';
      case _i41.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i42.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i43.FreeItemInfo():
        return 'FreeItemInfo';
      case _i44.Order():
        return 'Order';
      case _i45.OrderItem():
        return 'OrderItem';
      case _i46.OrderPage():
        return 'OrderPage';
      case _i47.PaymentActionResult():
        return 'PaymentActionResult';
      case _i48.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i49.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i50.PricingLineItem():
        return 'PricingLineItem';
      case _i51.Product():
        return 'Product';
      case _i52.ProductPage():
        return 'ProductPage';
      case _i53.ProductVariant():
        return 'ProductVariant';
      case _i54.RefundRecord():
        return 'RefundRecord';
      case _i55.SubCategory():
        return 'SubCategory';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.Address>(data['data']);
    }
    if (dataClassName == 'AdminAnalytics') {
      return deserialize<_i6.AdminAnalytics>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogEntry') {
      return deserialize<_i7.AdminAuditLogEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i8.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i9.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i10.AdminTopProduct>(data['data']);
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
    if (dataClassName == 'CartItem') {
      return deserialize<_i23.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i24.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i25.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i26.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i27.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i28.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i29.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i30.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i31.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i32.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i33.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i34.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i35.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i36.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i37.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i38.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i39.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i40.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i41.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i42.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i43.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i44.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i45.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i46.OrderPage>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i47.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i48.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i49.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i50.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i51.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i52.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i53.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i54.RefundRecord>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i55.SubCategory>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'freshpickkat';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
