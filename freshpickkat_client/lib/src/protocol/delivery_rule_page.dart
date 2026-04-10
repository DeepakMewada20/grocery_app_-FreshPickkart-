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
import 'delivery_rule.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class DeliveryRulePage implements _i1.SerializableModel {
  DeliveryRulePage._({
    required this.rules,
    this.nextPageToken,
    required this.totalCount,
  });

  factory DeliveryRulePage({
    required List<_i2.DeliveryRule> rules,
    String? nextPageToken,
    required int totalCount,
  }) = _DeliveryRulePageImpl;

  factory DeliveryRulePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryRulePage(
      rules: _i3.Protocol().deserialize<List<_i2.DeliveryRule>>(
        jsonSerialization['rules'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.DeliveryRule> rules;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [DeliveryRulePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryRulePage copyWith({
    List<_i2.DeliveryRule>? rules,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryRulePage',
      'rules': rules.toJson(valueToJson: (v) => v.toJson()),
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

class _DeliveryRulePageImpl extends DeliveryRulePage {
  _DeliveryRulePageImpl({
    required List<_i2.DeliveryRule> rules,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         rules: rules,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [DeliveryRulePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryRulePage copyWith({
    List<_i2.DeliveryRule>? rules,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return DeliveryRulePage(
      rules: rules ?? this.rules.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
