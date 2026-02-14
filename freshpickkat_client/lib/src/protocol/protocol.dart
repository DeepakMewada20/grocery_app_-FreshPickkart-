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
import 'category.dart' as _i2;
import 'product.dart' as _i3;
import 'sub_category.dart' as _i4;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i5;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i6;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i7;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i9;
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

    if (t == _i2.Category) {
      return _i2.Category.fromJson(data) as T;
    }
    if (t == _i3.Product) {
      return _i3.Product.fromJson(data) as T;
    }
    if (t == _i4.SubCategory) {
      return _i4.SubCategory.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Category?>()) {
      return (data != null ? _i2.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Product?>()) {
      return (data != null ? _i3.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.SubCategory?>()) {
      return (data != null ? _i4.SubCategory.fromJson(data) : null) as T;
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
    if (t == List<_i5.Category>) {
      return (data as List).map((e) => deserialize<_i5.Category>(e)).toList()
          as T;
    }
    if (t == List<_i6.Product>) {
      return (data as List).map((e) => deserialize<_i6.Product>(e)).toList()
          as T;
    }
    if (t == List<_i7.SubCategory>) {
      return (data as List).map((e) => deserialize<_i7.SubCategory>(e)).toList()
          as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i9.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Category => 'Category',
      _i3.Product => 'Product',
      _i4.SubCategory => 'SubCategory',
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
      case _i2.Category():
        return 'Category';
      case _i3.Product():
        return 'Product';
      case _i4.SubCategory():
        return 'SubCategory';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i9.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Category') {
      return deserialize<_i2.Category>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i3.Product>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i4.SubCategory>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i8.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i9.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
