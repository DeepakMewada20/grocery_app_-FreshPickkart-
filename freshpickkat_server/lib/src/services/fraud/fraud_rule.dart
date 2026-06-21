import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class FraudRuleResult {
  final String ruleName;
  final int weight;
  final int score;
  final bool passed;
  final String description;

  const FraudRuleResult({
    required this.ruleName,
    required this.weight,
    required this.score,
    required this.passed,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'ruleName': ruleName,
    'weight': weight,
    'score': score,
    'passed': passed,
    'description': description,
  };

  factory FraudRuleResult.fromJson(Map<String, dynamic> json) =>
      FraudRuleResult(
        ruleName: json['ruleName'] as String,
        weight: json['weight'] as int,
        score: json['score'] as int,
        passed: json['passed'] as bool,
        description: json['description'] as String,
      );
}

abstract class FraudRule {
  String get name;
  int get weight;
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  );
}
