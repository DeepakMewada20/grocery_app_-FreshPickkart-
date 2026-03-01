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
import 'app_user.dart' as _i6;
import 'cart_item.dart' as _i7;
import 'category.dart' as _i8;
import 'coupon.dart' as _i9;
import 'coupon_display.dart' as _i10;
import 'coupon_validation_result.dart' as _i11;
import 'product.dart' as _i12;
import 'sub_category.dart' as _i13;
import 'package:freshpickkat_server/src/generated/category.dart' as _i14;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i15;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i16;
import 'package:freshpickkat_server/src/generated/product.dart' as _i17;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i18;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i19;
export 'address.dart';
export 'app_user.dart';
export 'cart_item.dart';
export 'category.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_validation_result.dart';
export 'product.dart';
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
    if (t == _i6.AppUser) {
      return _i6.AppUser.fromJson(data) as T;
    }
    if (t == _i7.CartItem) {
      return _i7.CartItem.fromJson(data) as T;
    }
    if (t == _i8.Category) {
      return _i8.Category.fromJson(data) as T;
    }
    if (t == _i9.Coupon) {
      return _i9.Coupon.fromJson(data) as T;
    }
    if (t == _i10.CouponDisplay) {
      return _i10.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i11.CouponValidationResult) {
      return _i11.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i12.Product) {
      return _i12.Product.fromJson(data) as T;
    }
    if (t == _i13.SubCategory) {
      return _i13.SubCategory.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Address?>()) {
      return (data != null ? _i5.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AppUser?>()) {
      return (data != null ? _i6.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CartItem?>()) {
      return (data != null ? _i7.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Category?>()) {
      return (data != null ? _i8.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Coupon?>()) {
      return (data != null ? _i9.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CouponDisplay?>()) {
      return (data != null ? _i10.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CouponValidationResult?>()) {
      return (data != null ? _i11.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Product?>()) {
      return (data != null ? _i12.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SubCategory?>()) {
      return (data != null ? _i13.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i7.CartItem>) {
      return (data as List).map((e) => deserialize<_i7.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.CartItem>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i7.CartItem>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
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
    if (t == List<_i14.Category>) {
      return (data as List).map((e) => deserialize<_i14.Category>(e)).toList()
          as T;
    }
    if (t == List<_i15.Coupon>) {
      return (data as List).map((e) => deserialize<_i15.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i16.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i16.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.Product>) {
      return (data as List).map((e) => deserialize<_i17.Product>(e)).toList()
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
    if (t == List<_i18.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i18.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.CartItem>) {
      return (data as List).map((e) => deserialize<_i19.CartItem>(e)).toList()
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
      _i6.AppUser => 'AppUser',
      _i7.CartItem => 'CartItem',
      _i8.Category => 'Category',
      _i9.Coupon => 'Coupon',
      _i10.CouponDisplay => 'CouponDisplay',
      _i11.CouponValidationResult => 'CouponValidationResult',
      _i12.Product => 'Product',
      _i13.SubCategory => 'SubCategory',
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
      case _i6.AppUser():
        return 'AppUser';
      case _i7.CartItem():
        return 'CartItem';
      case _i8.Category():
        return 'Category';
      case _i9.Coupon():
        return 'Coupon';
      case _i10.CouponDisplay():
        return 'CouponDisplay';
      case _i11.CouponValidationResult():
        return 'CouponValidationResult';
      case _i12.Product():
        return 'Product';
      case _i13.SubCategory():
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
    if (dataClassName == 'AppUser') {
      return deserialize<_i6.AppUser>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i7.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i8.Category>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i9.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i10.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i11.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i12.Product>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i13.SubCategory>(data['data']);
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
