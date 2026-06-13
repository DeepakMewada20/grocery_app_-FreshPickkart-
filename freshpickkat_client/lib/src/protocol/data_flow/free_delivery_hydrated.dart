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
import '../data_flow/delivery_config.dart' as _i2;
import '../data_flow/delivery_rule.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class FreeDeliveryHydrated implements _i1.SerializableModel {
  FreeDeliveryHydrated._({
    required this.deliveryConfig,
    required this.deliveryRules,
    required this.totalCount,
  });

  factory FreeDeliveryHydrated({
    required _i2.DeliveryConfig deliveryConfig,
    required List<_i3.DeliveryRule> deliveryRules,
    required int totalCount,
  }) = _FreeDeliveryHydratedImpl;

  factory FreeDeliveryHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FreeDeliveryHydrated(
      deliveryConfig: _i4.Protocol().deserialize<_i2.DeliveryConfig>(
        jsonSerialization['deliveryConfig'],
      ),
      deliveryRules: _i4.Protocol().deserialize<List<_i3.DeliveryRule>>(
        jsonSerialization['deliveryRules'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  _i2.DeliveryConfig deliveryConfig;

  List<_i3.DeliveryRule> deliveryRules;

  int totalCount;

  /// Returns a shallow copy of this [FreeDeliveryHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreeDeliveryHydrated copyWith({
    _i2.DeliveryConfig? deliveryConfig,
    List<_i3.DeliveryRule>? deliveryRules,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreeDeliveryHydrated',
      'deliveryConfig': deliveryConfig.toJson(),
      'deliveryRules': deliveryRules.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FreeDeliveryHydratedImpl extends FreeDeliveryHydrated {
  _FreeDeliveryHydratedImpl({
    required _i2.DeliveryConfig deliveryConfig,
    required List<_i3.DeliveryRule> deliveryRules,
    required int totalCount,
  }) : super._(
         deliveryConfig: deliveryConfig,
         deliveryRules: deliveryRules,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [FreeDeliveryHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreeDeliveryHydrated copyWith({
    _i2.DeliveryConfig? deliveryConfig,
    List<_i3.DeliveryRule>? deliveryRules,
    int? totalCount,
  }) {
    return FreeDeliveryHydrated(
      deliveryConfig: deliveryConfig ?? this.deliveryConfig.copyWith(),
      deliveryRules:
          deliveryRules ??
          this.deliveryRules.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
