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
import 'bogo_free_product.dart' as _i15;
import 'bogo_offer.dart' as _i16;
import 'cart_item.dart' as _i17;
import 'cart_item_input.dart' as _i18;
import 'cart_pricing_result.dart' as _i19;
import 'category.dart' as _i20;
import 'category_offer.dart' as _i21;
import 'combo_offer.dart' as _i22;
import 'combo_product_item.dart' as _i23;
import 'coupon.dart' as _i24;
import 'coupon_display.dart' as _i25;
import 'coupon_validation_result.dart' as _i26;
import 'free_delivery_rule.dart' as _i27;
import 'free_item_info.dart' as _i28;
import 'order.dart' as _i29;
import 'order_item.dart' as _i30;
import 'order_page.dart' as _i31;
import 'payment_action_result.dart' as _i32;
import 'payment_order_result.dart' as _i33;
import 'payment_verify_result.dart' as _i34;
import 'pricing_line_item.dart' as _i35;
import 'product.dart' as _i36;
import 'product_page.dart' as _i37;
import 'product_variant.dart' as _i38;
import 'sub_category.dart' as _i39;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i40;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i41;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i42;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i43;
import 'package:freshpickkat_server/src/generated/category.dart' as _i44;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i45;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i46;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i47;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i48;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i49;
import 'package:freshpickkat_server/src/generated/free_delivery_rule.dart'
    as _i50;
import 'package:freshpickkat_server/src/generated/order.dart' as _i51;
import 'package:freshpickkat_server/src/generated/product.dart' as _i52;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i53;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i54;
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
export 'bogo_free_product.dart';
export 'bogo_offer.dart';
export 'cart_item.dart';
export 'cart_item_input.dart';
export 'cart_pricing_result.dart';
export 'category.dart';
export 'category_offer.dart';
export 'combo_offer.dart';
export 'combo_product_item.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_validation_result.dart';
export 'free_delivery_rule.dart';
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
    if (t == _i15.BogoFreeProduct) {
      return _i15.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i16.BogoOffer) {
      return _i16.BogoOffer.fromJson(data) as T;
    }
    if (t == _i17.CartItem) {
      return _i17.CartItem.fromJson(data) as T;
    }
    if (t == _i18.CartItemInput) {
      return _i18.CartItemInput.fromJson(data) as T;
    }
    if (t == _i19.CartPricingResult) {
      return _i19.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i20.Category) {
      return _i20.Category.fromJson(data) as T;
    }
    if (t == _i21.CategoryOffer) {
      return _i21.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i22.ComboOffer) {
      return _i22.ComboOffer.fromJson(data) as T;
    }
    if (t == _i23.ComboProductItem) {
      return _i23.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i24.Coupon) {
      return _i24.Coupon.fromJson(data) as T;
    }
    if (t == _i25.CouponDisplay) {
      return _i25.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i26.CouponValidationResult) {
      return _i26.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i27.FreeDeliveryRule) {
      return _i27.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i28.FreeItemInfo) {
      return _i28.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i29.Order) {
      return _i29.Order.fromJson(data) as T;
    }
    if (t == _i30.OrderItem) {
      return _i30.OrderItem.fromJson(data) as T;
    }
    if (t == _i31.OrderPage) {
      return _i31.OrderPage.fromJson(data) as T;
    }
    if (t == _i32.PaymentActionResult) {
      return _i32.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i33.PaymentOrderResult) {
      return _i33.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i34.PaymentVerifyResult) {
      return _i34.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i35.PricingLineItem) {
      return _i35.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i36.Product) {
      return _i36.Product.fromJson(data) as T;
    }
    if (t == _i37.ProductPage) {
      return _i37.ProductPage.fromJson(data) as T;
    }
    if (t == _i38.ProductVariant) {
      return _i38.ProductVariant.fromJson(data) as T;
    }
    if (t == _i39.SubCategory) {
      return _i39.SubCategory.fromJson(data) as T;
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
    if (t == _i1.getType<_i15.BogoFreeProduct?>()) {
      return (data != null ? _i15.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BogoOffer?>()) {
      return (data != null ? _i16.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CartItem?>()) {
      return (data != null ? _i17.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CartItemInput?>()) {
      return (data != null ? _i18.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CartPricingResult?>()) {
      return (data != null ? _i19.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Category?>()) {
      return (data != null ? _i20.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.CategoryOffer?>()) {
      return (data != null ? _i21.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ComboOffer?>()) {
      return (data != null ? _i22.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ComboProductItem?>()) {
      return (data != null ? _i23.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Coupon?>()) {
      return (data != null ? _i24.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.CouponDisplay?>()) {
      return (data != null ? _i25.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CouponValidationResult?>()) {
      return (data != null ? _i26.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.FreeDeliveryRule?>()) {
      return (data != null ? _i27.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.FreeItemInfo?>()) {
      return (data != null ? _i28.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Order?>()) {
      return (data != null ? _i29.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.OrderItem?>()) {
      return (data != null ? _i30.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.OrderPage?>()) {
      return (data != null ? _i31.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.PaymentActionResult?>()) {
      return (data != null ? _i32.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.PaymentOrderResult?>()) {
      return (data != null ? _i33.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.PaymentVerifyResult?>()) {
      return (data != null ? _i34.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.PricingLineItem?>()) {
      return (data != null ? _i35.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.Product?>()) {
      return (data != null ? _i36.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ProductPage?>()) {
      return (data != null ? _i37.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.ProductVariant?>()) {
      return (data != null ? _i38.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.SubCategory?>()) {
      return (data != null ? _i39.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i10.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.CartItem>) {
      return (data as List).map((e) => deserialize<_i17.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.CartItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i15.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i15.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i15.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i15.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i13.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i28.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i35.PricingLineItem>(e))
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
    if (t == List<_i23.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i23.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.OrderItem>) {
      return (data as List).map((e) => deserialize<_i30.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i29.Order>) {
      return (data as List).map((e) => deserialize<_i29.Order>(e)).toList()
          as T;
    }
    if (t == List<_i38.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i38.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i38.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i38.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i36.Product>) {
      return (data as List).map((e) => deserialize<_i36.Product>(e)).toList()
          as T;
    }
    if (t == List<_i40.AppUser>) {
      return (data as List).map((e) => deserialize<_i40.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i41.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i41.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.Banner>) {
      return (data as List).map((e) => deserialize<_i42.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i43.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i43.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i44.Category>) {
      return (data as List).map((e) => deserialize<_i44.Category>(e)).toList()
          as T;
    }
    if (t == List<_i45.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i45.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i46.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i47.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i47.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.Coupon>) {
      return (data as List).map((e) => deserialize<_i48.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i49.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i49.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i50.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i50.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.Order>) {
      return (data as List).map((e) => deserialize<_i51.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i52.Product>) {
      return (data as List).map((e) => deserialize<_i52.Product>(e)).toList()
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
    if (t == List<_i53.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i53.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.CartItem>) {
      return (data as List).map((e) => deserialize<_i54.CartItem>(e)).toList()
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
      _i15.BogoFreeProduct => 'BogoFreeProduct',
      _i16.BogoOffer => 'BogoOffer',
      _i17.CartItem => 'CartItem',
      _i18.CartItemInput => 'CartItemInput',
      _i19.CartPricingResult => 'CartPricingResult',
      _i20.Category => 'Category',
      _i21.CategoryOffer => 'CategoryOffer',
      _i22.ComboOffer => 'ComboOffer',
      _i23.ComboProductItem => 'ComboProductItem',
      _i24.Coupon => 'Coupon',
      _i25.CouponDisplay => 'CouponDisplay',
      _i26.CouponValidationResult => 'CouponValidationResult',
      _i27.FreeDeliveryRule => 'FreeDeliveryRule',
      _i28.FreeItemInfo => 'FreeItemInfo',
      _i29.Order => 'Order',
      _i30.OrderItem => 'OrderItem',
      _i31.OrderPage => 'OrderPage',
      _i32.PaymentActionResult => 'PaymentActionResult',
      _i33.PaymentOrderResult => 'PaymentOrderResult',
      _i34.PaymentVerifyResult => 'PaymentVerifyResult',
      _i35.PricingLineItem => 'PricingLineItem',
      _i36.Product => 'Product',
      _i37.ProductPage => 'ProductPage',
      _i38.ProductVariant => 'ProductVariant',
      _i39.SubCategory => 'SubCategory',
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
      case _i15.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i16.BogoOffer():
        return 'BogoOffer';
      case _i17.CartItem():
        return 'CartItem';
      case _i18.CartItemInput():
        return 'CartItemInput';
      case _i19.CartPricingResult():
        return 'CartPricingResult';
      case _i20.Category():
        return 'Category';
      case _i21.CategoryOffer():
        return 'CategoryOffer';
      case _i22.ComboOffer():
        return 'ComboOffer';
      case _i23.ComboProductItem():
        return 'ComboProductItem';
      case _i24.Coupon():
        return 'Coupon';
      case _i25.CouponDisplay():
        return 'CouponDisplay';
      case _i26.CouponValidationResult():
        return 'CouponValidationResult';
      case _i27.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i28.FreeItemInfo():
        return 'FreeItemInfo';
      case _i29.Order():
        return 'Order';
      case _i30.OrderItem():
        return 'OrderItem';
      case _i31.OrderPage():
        return 'OrderPage';
      case _i32.PaymentActionResult():
        return 'PaymentActionResult';
      case _i33.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i34.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i35.PricingLineItem():
        return 'PricingLineItem';
      case _i36.Product():
        return 'Product';
      case _i37.ProductPage():
        return 'ProductPage';
      case _i38.ProductVariant():
        return 'ProductVariant';
      case _i39.SubCategory():
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
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i15.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i16.BogoOffer>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i17.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i18.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i19.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i20.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i21.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i22.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i23.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i24.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i25.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i26.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i27.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i28.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i29.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i30.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i31.OrderPage>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i32.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i33.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i34.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i35.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i36.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i37.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i38.ProductVariant>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i39.SubCategory>(data['data']);
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
