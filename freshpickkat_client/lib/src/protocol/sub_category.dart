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

abstract class SubCategory implements _i1.SerializableModel {
  SubCategory._({
    required this.categoryId,
    required this.subCategoriesName,
    required this.subCategoriesUrl,
  });

  factory SubCategory({
    required String categoryId,
    required List<String> subCategoriesName,
    required String subCategoriesUrl,
  }) = _SubCategoryImpl;

  factory SubCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubCategory(
      categoryId: jsonSerialization['categoryId'] as String,
      subCategoriesName: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['subCategoriesName'],
      ),
      subCategoriesUrl: jsonSerialization['subCategoriesUrl'] as String,
    );
  }

  String categoryId;

  List<String> subCategoriesName;

  String subCategoriesUrl;

  /// Returns a shallow copy of this [SubCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubCategory copyWith({
    String? categoryId,
    List<String>? subCategoriesName,
    String? subCategoriesUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubCategory',
      'categoryId': categoryId,
      'subCategoriesName': subCategoriesName.toJson(),
      'subCategoriesUrl': subCategoriesUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SubCategoryImpl extends SubCategory {
  _SubCategoryImpl({
    required String categoryId,
    required List<String> subCategoriesName,
    required String subCategoriesUrl,
  }) : super._(
         categoryId: categoryId,
         subCategoriesName: subCategoriesName,
         subCategoriesUrl: subCategoriesUrl,
       );

  /// Returns a shallow copy of this [SubCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubCategory copyWith({
    String? categoryId,
    List<String>? subCategoriesName,
    String? subCategoriesUrl,
  }) {
    return SubCategory(
      categoryId: categoryId ?? this.categoryId,
      subCategoriesName:
          subCategoriesName ?? this.subCategoriesName.map((e0) => e0).toList(),
      subCategoriesUrl: subCategoriesUrl ?? this.subCategoriesUrl,
    );
  }
}
