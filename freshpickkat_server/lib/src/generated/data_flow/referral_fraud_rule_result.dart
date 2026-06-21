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

abstract class ReferralFraudRuleResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralFraudRuleResult._({
    required this.ruleName,
    required this.weight,
    required this.score,
    required this.passed,
    required this.description,
  });

  factory ReferralFraudRuleResult({
    required String ruleName,
    required int weight,
    required int score,
    required bool passed,
    required String description,
  }) = _ReferralFraudRuleResultImpl;

  factory ReferralFraudRuleResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReferralFraudRuleResult(
      ruleName: jsonSerialization['ruleName'] as String,
      weight: jsonSerialization['weight'] as int,
      score: jsonSerialization['score'] as int,
      passed: _i1.BoolJsonExtension.fromJson(jsonSerialization['passed']),
      description: jsonSerialization['description'] as String,
    );
  }

  String ruleName;

  int weight;

  int score;

  bool passed;

  String description;

  /// Returns a shallow copy of this [ReferralFraudRuleResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralFraudRuleResult copyWith({
    String? ruleName,
    int? weight,
    int? score,
    bool? passed,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralFraudRuleResult',
      'ruleName': ruleName,
      'weight': weight,
      'score': score,
      'passed': passed,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralFraudRuleResult',
      'ruleName': ruleName,
      'weight': weight,
      'score': score,
      'passed': passed,
      'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferralFraudRuleResultImpl extends ReferralFraudRuleResult {
  _ReferralFraudRuleResultImpl({
    required String ruleName,
    required int weight,
    required int score,
    required bool passed,
    required String description,
  }) : super._(
         ruleName: ruleName,
         weight: weight,
         score: score,
         passed: passed,
         description: description,
       );

  /// Returns a shallow copy of this [ReferralFraudRuleResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralFraudRuleResult copyWith({
    String? ruleName,
    int? weight,
    int? score,
    bool? passed,
    String? description,
  }) {
    return ReferralFraudRuleResult(
      ruleName: ruleName ?? this.ruleName,
      weight: weight ?? this.weight,
      score: score ?? this.score,
      passed: passed ?? this.passed,
      description: description ?? this.description,
    );
  }
}
