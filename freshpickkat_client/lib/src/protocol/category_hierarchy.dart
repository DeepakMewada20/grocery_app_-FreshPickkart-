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
import 'sub_category.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class CategoryHierarchy implements _i1.SerializableModel {
  CategoryHierarchy._({
    required this.categories,
    required this.subCategories,
  });

  factory CategoryHierarchy({
    required List<_i2.Category> categories,
    required List<_i3.SubCategory> subCategories,
  }) = _CategoryHierarchyImpl;

  factory CategoryHierarchy.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryHierarchy(
      categories: _i4.Protocol().deserialize<List<_i2.Category>>(
        jsonSerialization['categories'],
      ),
      subCategories: _i4.Protocol().deserialize<List<_i3.SubCategory>>(
        jsonSerialization['subCategories'],
      ),
    );
  }

  List<_i2.Category> categories;

  List<_i3.SubCategory> subCategories;

  /// Returns a shallow copy of this [CategoryHierarchy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryHierarchy copyWith({
    List<_i2.Category>? categories,
    List<_i3.SubCategory>? subCategories,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryHierarchy',
      'categories': categories.toJson(valueToJson: (v) => v.toJson()),
      'subCategories': subCategories.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CategoryHierarchyImpl extends CategoryHierarchy {
  _CategoryHierarchyImpl({
    required List<_i2.Category> categories,
    required List<_i3.SubCategory> subCategories,
  }) : super._(
         categories: categories,
         subCategories: subCategories,
       );

  /// Returns a shallow copy of this [CategoryHierarchy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryHierarchy copyWith({
    List<_i2.Category>? categories,
    List<_i3.SubCategory>? subCategories,
  }) {
    return CategoryHierarchy(
      categories:
          categories ?? this.categories.map((e0) => e0.copyWith()).toList(),
      subCategories:
          subCategories ??
          this.subCategories.map((e0) => e0.copyWith()).toList(),
    );
  }
}
