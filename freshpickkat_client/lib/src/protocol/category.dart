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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i2;

abstract class Category implements _i1.SerializableModel {
  Category._({
    required this.categoryName,
    required this.categoryImageUrl,
    required this.subCategory,
  });

  factory Category({
    required String categoryName,
    required String categoryImageUrl,
    required Map<String, String> subCategory,
  }) = _CategoryImpl;

  factory Category.fromJson(Map<String, dynamic> jsonSerialization) {
    return Category(
      categoryName: jsonSerialization['categoryName'] as String,
      categoryImageUrl: jsonSerialization['categoryImageUrl'] as String,
      subCategory: _i2.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['subCategory'],
      ),
    );
  }

  String categoryName;

  String categoryImageUrl;

  Map<String, String> subCategory;

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Category copyWith({
    String? categoryName,
    String? categoryImageUrl,
    Map<String, String>? subCategory,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Category',
      'categoryName': categoryName,
      'categoryImageUrl': categoryImageUrl,
      'subCategory': subCategory.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CategoryImpl extends Category {
  _CategoryImpl({
    required String categoryName,
    required String categoryImageUrl,
    required Map<String, String> subCategory,
  }) : super._(
         categoryName: categoryName,
         categoryImageUrl: categoryImageUrl,
         subCategory: subCategory,
       );

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Category copyWith({
    String? categoryName,
    String? categoryImageUrl,
    Map<String, String>? subCategory,
  }) {
    return Category(
      categoryName: categoryName ?? this.categoryName,
      categoryImageUrl: categoryImageUrl ?? this.categoryImageUrl,
      subCategory:
          subCategory ??
          this.subCategory.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
