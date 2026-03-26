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

abstract class PricingLineItem implements _i1.SerializableModel {
  PricingLineItem._({
    required this.label,
    required this.amount,
    required this.type,
  });

  factory PricingLineItem({
    required String label,
    required double amount,
    required String type,
  }) = _PricingLineItemImpl;

  factory PricingLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return PricingLineItem(
      label: jsonSerialization['label'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
    );
  }

  String label;

  double amount;

  String type;

  /// Returns a shallow copy of this [PricingLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PricingLineItem copyWith({
    String? label,
    double? amount,
    String? type,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PricingLineItem',
      'label': label,
      'amount': amount,
      'type': type,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PricingLineItemImpl extends PricingLineItem {
  _PricingLineItemImpl({
    required String label,
    required double amount,
    required String type,
  }) : super._(
         label: label,
         amount: amount,
         type: type,
       );

  /// Returns a shallow copy of this [PricingLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PricingLineItem copyWith({
    String? label,
    double? amount,
    String? type,
  }) {
    return PricingLineItem(
      label: label ?? this.label,
      amount: amount ?? this.amount,
      type: type ?? this.type,
    );
  }
}
