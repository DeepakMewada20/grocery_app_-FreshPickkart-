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

abstract class AdminTopProduct
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminTopProduct._({
    required this.name,
    required this.mostPurchases,
    this.quantity,
  });

  factory AdminTopProduct({
    required String name,
    required int mostPurchases,
    String? quantity,
  }) = _AdminTopProductImpl;

  factory AdminTopProduct.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminTopProduct(
      name: jsonSerialization['name'] as String,
      mostPurchases: jsonSerialization['mostPurchases'] as int,
      quantity: jsonSerialization['quantity'] as String?,
    );
  }

  String name;

  int mostPurchases;

  String? quantity;

  /// Returns a shallow copy of this [AdminTopProduct]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminTopProduct copyWith({
    String? name,
    int? mostPurchases,
    String? quantity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminTopProduct',
      'name': name,
      'mostPurchases': mostPurchases,
      if (quantity != null) 'quantity': quantity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminTopProduct',
      'name': name,
      'mostPurchases': mostPurchases,
      if (quantity != null) 'quantity': quantity,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminTopProductImpl extends AdminTopProduct {
  _AdminTopProductImpl({
    required String name,
    required int mostPurchases,
    String? quantity,
  }) : super._(
         name: name,
         mostPurchases: mostPurchases,
         quantity: quantity,
       );

  /// Returns a shallow copy of this [AdminTopProduct]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminTopProduct copyWith({
    String? name,
    int? mostPurchases,
    Object? quantity = _Undefined,
  }) {
    return AdminTopProduct(
      name: name ?? this.name,
      mostPurchases: mostPurchases ?? this.mostPurchases,
      quantity: quantity is String? ? quantity : this.quantity,
    );
  }
}
