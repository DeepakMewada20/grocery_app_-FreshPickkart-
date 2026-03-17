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
import 'product.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class ProductPage
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProductPage._({
    required this.products,
    this.nextPageToken,
    required this.totalCount,
  });

  factory ProductPage({
    required List<_i2.Product> products,
    String? nextPageToken,
    required int totalCount,
  }) = _ProductPageImpl;

  factory ProductPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductPage(
      products: _i3.Protocol().deserialize<List<_i2.Product>>(
        jsonSerialization['products'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.Product> products;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [ProductPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductPage copyWith({
    List<_i2.Product>? products,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductPage',
      'products': products.toJson(valueToJson: (v) => v.toJson()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'totalCount': totalCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductPage',
      'products': products.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'totalCount': totalCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductPageImpl extends ProductPage {
  _ProductPageImpl({
    required List<_i2.Product> products,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         products: products,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [ProductPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductPage copyWith({
    List<_i2.Product>? products,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return ProductPage(
      products: products ?? this.products.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
