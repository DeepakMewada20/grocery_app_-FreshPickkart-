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
import 'app_user.dart' as _i3;
import 'cart_item.dart' as _i4;
import 'category.dart' as _i5;
import 'product.dart' as _i6;
import 'sub_category.dart' as _i7;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i8;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i9;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i10;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i11;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i12;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i13;
export 'address.dart';
export 'app_user.dart';
export 'cart_item.dart';
export 'category.dart';
export 'product.dart';
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
    if (t == _i3.AppUser) {
      return _i3.AppUser.fromJson(data) as T;
    }
    if (t == _i4.CartItem) {
      return _i4.CartItem.fromJson(data) as T;
    }
    if (t == _i5.Category) {
      return _i5.Category.fromJson(data) as T;
    }
    if (t == _i6.Product) {
      return _i6.Product.fromJson(data) as T;
    }
    if (t == _i7.SubCategory) {
      return _i7.SubCategory.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Address?>()) {
      return (data != null ? _i2.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppUser?>()) {
      return (data != null ? _i3.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CartItem?>()) {
      return (data != null ? _i4.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Category?>()) {
      return (data != null ? _i5.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Product?>()) {
      return (data != null ? _i6.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.SubCategory?>()) {
      return (data != null ? _i7.SubCategory.fromJson(data) : null) as T;
    }
    if (t == List<_i4.CartItem>) {
      return (data as List).map((e) => deserialize<_i4.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i4.CartItem>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i4.CartItem>(e)).toList()
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
    if (t == List<_i8.Category>) {
      return (data as List).map((e) => deserialize<_i8.Category>(e)).toList()
          as T;
    }
    if (t == List<_i9.Product>) {
      return (data as List).map((e) => deserialize<_i9.Product>(e)).toList()
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
    if (t == List<_i10.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i10.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i11.CartItem>) {
      return (data as List).map((e) => deserialize<_i11.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i12.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Address => 'Address',
      _i3.AppUser => 'AppUser',
      _i4.CartItem => 'CartItem',
      _i5.Category => 'Category',
      _i6.Product => 'Product',
      _i7.SubCategory => 'SubCategory',
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
      case _i3.AppUser():
        return 'AppUser';
      case _i4.CartItem():
        return 'CartItem';
      case _i5.Category():
        return 'Category';
      case _i6.Product():
        return 'Product';
      case _i7.SubCategory():
        return 'SubCategory';
    }
    className = _i12.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i13.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AppUser') {
      return deserialize<_i3.AppUser>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i4.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i5.Category>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i6.Product>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i7.SubCategory>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i12.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i13.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
