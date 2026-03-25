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
import 'bogo_free_product.dart' as _i9;
import 'bogo_offer.dart' as _i10;
import 'cart_item.dart' as _i11;
import 'category.dart' as _i12;
import 'coupon.dart' as _i13;
import 'coupon_display.dart' as _i14;
import 'coupon_validation_result.dart' as _i15;
import 'order.dart' as _i16;
import 'order_item.dart' as _i17;
import 'order_page.dart' as _i18;
import 'payment_action_result.dart' as _i19;
import 'payment_order_result.dart' as _i20;
import 'payment_verify_result.dart' as _i21;
import 'product.dart' as _i22;
import 'product_page.dart' as _i23;
import 'sub_category.dart' as _i24;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i25;
import 'package:freshpickkat_client/src/protocol/admin_audit_log_entry.dart'
    as _i26;
import 'package:freshpickkat_client/src/protocol/bogo_offer.dart' as _i27;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i28;
import 'package:freshpickkat_client/src/protocol/coupon.dart' as _i29;
import 'package:freshpickkat_client/src/protocol/coupon_display.dart' as _i30;
import 'package:freshpickkat_client/src/protocol/order.dart' as _i31;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i32;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i33;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i34;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i35;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i36;
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_auth_result.dart';
export 'admin_dashboard_stats.dart';
export 'admin_top_product.dart';
export 'app_user.dart';
export 'bogo_free_product.dart';
export 'bogo_offer.dart';
export 'cart_item.dart';
export 'category.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_validation_result.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_verify_result.dart';
export 'product.dart';
export 'product_page.dart';
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
    if (t == _i9.BogoFreeProduct) {
      return _i9.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i10.BogoOffer) {
      return _i10.BogoOffer.fromJson(data) as T;
    }
    if (t == _i11.CartItem) {
      return _i11.CartItem.fromJson(data) as T;
    }
    if (t == _i12.Category) {
      return _i12.Category.fromJson(data) as T;
    }
    if (t == _i13.Coupon) {
      return _i13.Coupon.fromJson(data) as T;
    }
    if (t == _i14.CouponDisplay) {
      return _i14.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i15.CouponValidationResult) {
      return _i15.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i16.Order) {
      return _i16.Order.fromJson(data) as T;
    }
    if (t == _i17.OrderItem) {
      return _i17.OrderItem.fromJson(data) as T;
    }
    if (t == _i18.OrderPage) {
      return _i18.OrderPage.fromJson(data) as T;
    }
    if (t == _i19.PaymentActionResult) {
      return _i19.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i20.PaymentOrderResult) {
      return _i20.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i21.PaymentVerifyResult) {
      return _i21.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i22.Product) {
      return _i22.Product.fromJson(data) as T;
    }
    if (t == _i23.ProductPage) {
      return _i23.ProductPage.fromJson(data) as T;
    }
    if (t == _i24.SubCategory) {
      return _i24.SubCategory.fromJson(data) as T;
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
    if (t == _i1.getType<_i9.BogoFreeProduct?>()) {
      return (data != null ? _i9.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BogoOffer?>()) {
      return (data != null ? _i10.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CartItem?>()) {
      return (data != null ? _i11.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Category?>()) {
      return (data != null ? _i12.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Coupon?>()) {
      return (data != null ? _i13.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CouponDisplay?>()) {
      return (data != null ? _i14.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CouponValidationResult?>()) {
      return (data != null ? _i15.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.Order?>()) {
      return (data != null ? _i16.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.OrderItem?>()) {
      return (data != null ? _i17.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.OrderPage?>()) {
      return (data != null ? _i18.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.PaymentActionResult?>()) {
      return (data != null ? _i19.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.PaymentOrderResult?>()) {
      return (data != null ? _i20.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.PaymentVerifyResult?>()) {
      return (data != null ? _i21.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.Product?>()) {
      return (data != null ? _i22.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ProductPage?>()) {
      return (data != null ? _i23.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.SubCategory?>()) {
      return (data != null ? _i24.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i7.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i7.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i11.CartItem>) {
      return (data as List).map((e) => deserialize<_i11.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.CartItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i9.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i9.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == List<_i17.OrderItem>) {
      return (data as List).map((e) => deserialize<_i17.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i16.Order>) {
      return (data as List).map((e) => deserialize<_i16.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i22.Product>) {
      return (data as List).map((e) => deserialize<_i22.Product>(e)).toList()
          as T;
    }
    if (t == List<_i25.AppUser>) {
      return (data as List).map((e) => deserialize<_i25.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i26.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i26.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i27.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i28.Category>) {
      return (data as List).map((e) => deserialize<_i28.Category>(e)).toList()
          as T;
    }
    if (t == List<_i29.Coupon>) {
      return (data as List).map((e) => deserialize<_i29.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i30.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i30.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.Order>) {
      return (data as List).map((e) => deserialize<_i31.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i32.Product>) {
      return (data as List).map((e) => deserialize<_i32.Product>(e)).toList()
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
    if (t == List<_i33.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i33.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CartItem>) {
      return (data as List).map((e) => deserialize<_i34.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i35.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i36.Protocol().deserialize<T>(data, t);
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
      _i9.BogoFreeProduct => 'BogoFreeProduct',
      _i10.BogoOffer => 'BogoOffer',
      _i11.CartItem => 'CartItem',
      _i12.Category => 'Category',
      _i13.Coupon => 'Coupon',
      _i14.CouponDisplay => 'CouponDisplay',
      _i15.CouponValidationResult => 'CouponValidationResult',
      _i16.Order => 'Order',
      _i17.OrderItem => 'OrderItem',
      _i18.OrderPage => 'OrderPage',
      _i19.PaymentActionResult => 'PaymentActionResult',
      _i20.PaymentOrderResult => 'PaymentOrderResult',
      _i21.PaymentVerifyResult => 'PaymentVerifyResult',
      _i22.Product => 'Product',
      _i23.ProductPage => 'ProductPage',
      _i24.SubCategory => 'SubCategory',
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
      case _i9.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i10.BogoOffer():
        return 'BogoOffer';
      case _i11.CartItem():
        return 'CartItem';
      case _i12.Category():
        return 'Category';
      case _i13.Coupon():
        return 'Coupon';
      case _i14.CouponDisplay():
        return 'CouponDisplay';
      case _i15.CouponValidationResult():
        return 'CouponValidationResult';
      case _i16.Order():
        return 'Order';
      case _i17.OrderItem():
        return 'OrderItem';
      case _i18.OrderPage():
        return 'OrderPage';
      case _i19.PaymentActionResult():
        return 'PaymentActionResult';
      case _i20.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i21.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i22.Product():
        return 'Product';
      case _i23.ProductPage():
        return 'ProductPage';
      case _i24.SubCategory():
        return 'SubCategory';
    }
    className = _i35.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i36.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i9.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i10.BogoOffer>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i11.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i12.Category>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i13.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i14.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i15.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i16.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i17.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i18.OrderPage>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i19.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i20.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i21.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i22.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i23.ProductPage>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i24.SubCategory>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i35.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i36.Protocol().deserializeByClassName(data);
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
      return _i35.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i36.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
