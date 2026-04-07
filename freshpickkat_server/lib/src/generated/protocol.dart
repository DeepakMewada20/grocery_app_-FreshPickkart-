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
import 'bogo_free_product.dart' as _i16;
import 'bogo_offer.dart' as _i17;
import 'bogo_offer_page.dart' as _i18;
import 'cart_item.dart' as _i19;
import 'cart_item_input.dart' as _i20;
import 'cart_pricing_result.dart' as _i21;
import 'category.dart' as _i22;
import 'category_offer.dart' as _i23;
import 'category_offer_page.dart' as _i24;
import 'combo_offer.dart' as _i25;
import 'combo_offer_page.dart' as _i26;
import 'combo_product_item.dart' as _i27;
import 'coupon.dart' as _i28;
import 'coupon_display.dart' as _i29;
import 'coupon_validation_result.dart' as _i30;
import 'free_delivery_rule.dart' as _i31;
import 'free_delivery_rule_page.dart' as _i32;
import 'free_item_info.dart' as _i33;
import 'order.dart' as _i34;
import 'order_item.dart' as _i35;
import 'order_page.dart' as _i36;
import 'payment_action_result.dart' as _i37;
import 'payment_order_result.dart' as _i38;
import 'payment_verify_result.dart' as _i39;
import 'pricing_line_item.dart' as _i40;
import 'product.dart' as _i41;
import 'product_page.dart' as _i42;
import 'product_variant.dart' as _i43;
import 'refund_record.dart' as _i44;
import 'sub_category.dart' as _i45;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i46;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i47;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i48;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i49;
import 'package:freshpickkat_server/src/generated/category.dart' as _i50;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i51;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i52;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i53;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i54;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i55;
import 'package:freshpickkat_server/src/generated/free_delivery_rule.dart'
    as _i56;
import 'package:freshpickkat_server/src/generated/order.dart' as _i57;
import 'package:freshpickkat_server/src/generated/product.dart' as _i58;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i59;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i60;
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
export 'bogo_free_product.dart';
export 'bogo_offer.dart';
export 'bogo_offer_page.dart';
export 'cart_item.dart';
export 'cart_item_input.dart';
export 'cart_pricing_result.dart';
export 'category.dart';
export 'category_offer.dart';
export 'category_offer_page.dart';
export 'combo_offer.dart';
export 'combo_offer_page.dart';
export 'combo_product_item.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_validation_result.dart';
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
    if (t == _i16.BogoFreeProduct) {
      return _i16.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i17.BogoOffer) {
      return _i17.BogoOffer.fromJson(data) as T;
    }
    if (t == _i18.BogoOfferPage) {
      return _i18.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i19.CartItem) {
      return _i19.CartItem.fromJson(data) as T;
    }
    if (t == _i20.CartItemInput) {
      return _i20.CartItemInput.fromJson(data) as T;
    }
    if (t == _i21.CartPricingResult) {
      return _i21.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i22.Category) {
      return _i22.Category.fromJson(data) as T;
    }
    if (t == _i23.CategoryOffer) {
      return _i23.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i24.CategoryOfferPage) {
      return _i24.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i25.ComboOffer) {
      return _i25.ComboOffer.fromJson(data) as T;
    }
    if (t == _i26.ComboOfferPage) {
      return _i26.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i27.ComboProductItem) {
      return _i27.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i28.Coupon) {
      return _i28.Coupon.fromJson(data) as T;
    }
    if (t == _i29.CouponDisplay) {
      return _i29.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i30.CouponValidationResult) {
      return _i30.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i31.FreeDeliveryRule) {
      return _i31.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i32.FreeDeliveryRulePage) {
      return _i32.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i33.FreeItemInfo) {
      return _i33.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i34.Order) {
      return _i34.Order.fromJson(data) as T;
    }
    if (t == _i35.OrderItem) {
      return _i35.OrderItem.fromJson(data) as T;
    }
    if (t == _i36.OrderPage) {
      return _i36.OrderPage.fromJson(data) as T;
    }
    if (t == _i37.PaymentActionResult) {
      return _i37.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i38.PaymentOrderResult) {
      return _i38.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i39.PaymentVerifyResult) {
      return _i39.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i40.PricingLineItem) {
      return _i40.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i41.Product) {
      return _i41.Product.fromJson(data) as T;
    }
    if (t == _i42.ProductPage) {
      return _i42.ProductPage.fromJson(data) as T;
    }
    if (t == _i43.ProductVariant) {
      return _i43.ProductVariant.fromJson(data) as T;
    }
    if (t == _i44.RefundRecord) {
      return _i44.RefundRecord.fromJson(data) as T;
    }
    if (t == _i45.SubCategory) {
      return _i45.SubCategory.fromJson(data) as T;
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
    if (t == _i1.getType<_i16.BogoFreeProduct?>()) {
      return (data != null ? _i16.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BogoOffer?>()) {
      return (data != null ? _i17.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.BogoOfferPage?>()) {
      return (data != null ? _i18.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CartItem?>()) {
      return (data != null ? _i19.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.CartItemInput?>()) {
      return (data != null ? _i20.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.CartPricingResult?>()) {
      return (data != null ? _i21.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Category?>()) {
      return (data != null ? _i22.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CategoryOffer?>()) {
      return (data != null ? _i23.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.CategoryOfferPage?>()) {
      return (data != null ? _i24.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ComboOffer?>()) {
      return (data != null ? _i25.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ComboOfferPage?>()) {
      return (data != null ? _i26.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ComboProductItem?>()) {
      return (data != null ? _i27.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Coupon?>()) {
      return (data != null ? _i28.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.CouponDisplay?>()) {
      return (data != null ? _i29.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CouponValidationResult?>()) {
      return (data != null ? _i30.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.FreeDeliveryRule?>()) {
      return (data != null ? _i31.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.FreeDeliveryRulePage?>()) {
      return (data != null ? _i32.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.FreeItemInfo?>()) {
      return (data != null ? _i33.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Order?>()) {
      return (data != null ? _i34.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.OrderItem?>()) {
      return (data != null ? _i35.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.OrderPage?>()) {
      return (data != null ? _i36.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.PaymentActionResult?>()) {
      return (data != null ? _i37.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.PaymentOrderResult?>()) {
      return (data != null ? _i38.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.PaymentVerifyResult?>()) {
      return (data != null ? _i39.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.PricingLineItem?>()) {
      return (data != null ? _i40.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.Product?>()) {
      return (data != null ? _i41.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ProductPage?>()) {
      return (data != null ? _i42.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ProductVariant?>()) {
      return (data != null ? _i43.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.RefundRecord?>()) {
      return (data != null ? _i44.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.SubCategory?>()) {
      return (data != null ? _i45.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i10.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.CartItem>) {
      return (data as List).map((e) => deserialize<_i19.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i19.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i19.CartItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14.Banner>) {
      return (data as List).map((e) => deserialize<_i14.Banner>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i16.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i16.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i16.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i16.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i17.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i17.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i13.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i13.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i33.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i40.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i40.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i23.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i23.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i27.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i25.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i31.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i31.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.OrderItem>) {
      return (data as List).map((e) => deserialize<_i35.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i34.Order>) {
      return (data as List).map((e) => deserialize<_i34.Order>(e)).toList()
          as T;
    }
    if (t == List<_i43.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i43.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i43.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i43.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i41.Product>) {
      return (data as List).map((e) => deserialize<_i41.Product>(e)).toList()
          as T;
    }
    if (t == List<_i46.AppUser>) {
      return (data as List).map((e) => deserialize<_i46.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i47.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i47.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.Banner>) {
      return (data as List).map((e) => deserialize<_i48.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i49.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i49.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i50.Category>) {
      return (data as List).map((e) => deserialize<_i50.Category>(e)).toList()
          as T;
    }
    if (t == List<_i51.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i51.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i52.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i52.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i53.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i53.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.Coupon>) {
      return (data as List).map((e) => deserialize<_i54.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i55.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i55.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i56.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i56.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.Order>) {
      return (data as List).map((e) => deserialize<_i57.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i58.Product>) {
      return (data as List).map((e) => deserialize<_i58.Product>(e)).toList()
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
    if (t == List<_i59.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i59.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.CartItem>) {
      return (data as List).map((e) => deserialize<_i60.CartItem>(e)).toList()
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
      _i16.BogoFreeProduct => 'BogoFreeProduct',
      _i17.BogoOffer => 'BogoOffer',
      _i18.BogoOfferPage => 'BogoOfferPage',
      _i19.CartItem => 'CartItem',
      _i20.CartItemInput => 'CartItemInput',
      _i21.CartPricingResult => 'CartPricingResult',
      _i22.Category => 'Category',
      _i23.CategoryOffer => 'CategoryOffer',
      _i24.CategoryOfferPage => 'CategoryOfferPage',
      _i25.ComboOffer => 'ComboOffer',
      _i26.ComboOfferPage => 'ComboOfferPage',
      _i27.ComboProductItem => 'ComboProductItem',
      _i28.Coupon => 'Coupon',
      _i29.CouponDisplay => 'CouponDisplay',
      _i30.CouponValidationResult => 'CouponValidationResult',
      _i31.FreeDeliveryRule => 'FreeDeliveryRule',
      _i32.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i33.FreeItemInfo => 'FreeItemInfo',
      _i34.Order => 'Order',
      _i35.OrderItem => 'OrderItem',
      _i36.OrderPage => 'OrderPage',
      _i37.PaymentActionResult => 'PaymentActionResult',
      _i38.PaymentOrderResult => 'PaymentOrderResult',
      _i39.PaymentVerifyResult => 'PaymentVerifyResult',
      _i40.PricingLineItem => 'PricingLineItem',
      _i41.Product => 'Product',
      _i42.ProductPage => 'ProductPage',
      _i43.ProductVariant => 'ProductVariant',
      _i44.RefundRecord => 'RefundRecord',
      _i45.SubCategory => 'SubCategory',
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
      case _i16.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i17.BogoOffer():
        return 'BogoOffer';
      case _i18.BogoOfferPage():
        return 'BogoOfferPage';
      case _i19.CartItem():
        return 'CartItem';
      case _i20.CartItemInput():
        return 'CartItemInput';
      case _i21.CartPricingResult():
        return 'CartPricingResult';
      case _i22.Category():
        return 'Category';
      case _i23.CategoryOffer():
        return 'CategoryOffer';
      case _i24.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i25.ComboOffer():
        return 'ComboOffer';
      case _i26.ComboOfferPage():
        return 'ComboOfferPage';
      case _i27.ComboProductItem():
        return 'ComboProductItem';
      case _i28.Coupon():
        return 'Coupon';
      case _i29.CouponDisplay():
        return 'CouponDisplay';
      case _i30.CouponValidationResult():
        return 'CouponValidationResult';
      case _i31.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i32.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i33.FreeItemInfo():
        return 'FreeItemInfo';
      case _i34.Order():
        return 'Order';
      case _i35.OrderItem():
        return 'OrderItem';
      case _i36.OrderPage():
        return 'OrderPage';
      case _i37.PaymentActionResult():
        return 'PaymentActionResult';
      case _i38.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i39.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i40.PricingLineItem():
        return 'PricingLineItem';
      case _i41.Product():
        return 'Product';
      case _i42.ProductPage():
        return 'ProductPage';
      case _i43.ProductVariant():
        return 'ProductVariant';
      case _i44.RefundRecord():
        return 'RefundRecord';
      case _i45.SubCategory():
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
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i16.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i17.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i18.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i19.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i20.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i21.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i22.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i23.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i24.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i25.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i26.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i27.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i28.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i29.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i30.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i31.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i32.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i33.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i34.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i35.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i36.OrderPage>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i37.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i38.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i39.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i40.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i41.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i42.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i43.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i44.RefundRecord>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i45.SubCategory>(data['data']);
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
