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
import '../data_flow/referral_fraud_rule_result.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class ReferralFraudResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralFraudResult._({
    required this.totalScore,
    required this.outcome,
    required this.rules,
    required this.hardReject,
    this.hardRejectReason,
  });

  factory ReferralFraudResult({
    required int totalScore,
    required String outcome,
    required List<_i2.ReferralFraudRuleResult> rules,
    required bool hardReject,
    String? hardRejectReason,
  }) = _ReferralFraudResultImpl;

  factory ReferralFraudResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralFraudResult(
      totalScore: jsonSerialization['totalScore'] as int,
      outcome: jsonSerialization['outcome'] as String,
      rules: _i3.Protocol().deserialize<List<_i2.ReferralFraudRuleResult>>(
        jsonSerialization['rules'],
      ),
      hardReject: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hardReject'],
      ),
      hardRejectReason: jsonSerialization['hardRejectReason'] as String?,
    );
  }

  int totalScore;

  String outcome;

  List<_i2.ReferralFraudRuleResult> rules;

  bool hardReject;

  String? hardRejectReason;

  /// Returns a shallow copy of this [ReferralFraudResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralFraudResult copyWith({
    int? totalScore,
    String? outcome,
    List<_i2.ReferralFraudRuleResult>? rules,
    bool? hardReject,
    String? hardRejectReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralFraudResult',
      'totalScore': totalScore,
      'outcome': outcome,
      'rules': rules.toJson(valueToJson: (v) => v.toJson()),
      'hardReject': hardReject,
      if (hardRejectReason != null) 'hardRejectReason': hardRejectReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralFraudResult',
      'totalScore': totalScore,
      'outcome': outcome,
      'rules': rules.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'hardReject': hardReject,
      if (hardRejectReason != null) 'hardRejectReason': hardRejectReason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralFraudResultImpl extends ReferralFraudResult {
  _ReferralFraudResultImpl({
    required int totalScore,
    required String outcome,
    required List<_i2.ReferralFraudRuleResult> rules,
    required bool hardReject,
    String? hardRejectReason,
  }) : super._(
         totalScore: totalScore,
         outcome: outcome,
         rules: rules,
         hardReject: hardReject,
         hardRejectReason: hardRejectReason,
       );

  /// Returns a shallow copy of this [ReferralFraudResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralFraudResult copyWith({
    int? totalScore,
    String? outcome,
    List<_i2.ReferralFraudRuleResult>? rules,
    bool? hardReject,
    Object? hardRejectReason = _Undefined,
  }) {
    return ReferralFraudResult(
      totalScore: totalScore ?? this.totalScore,
      outcome: outcome ?? this.outcome,
      rules: rules ?? this.rules.map((e0) => e0.copyWith()).toList(),
      hardReject: hardReject ?? this.hardReject,
      hardRejectReason: hardRejectReason is String?
          ? hardRejectReason
          : this.hardRejectReason,
    );
  }
}
