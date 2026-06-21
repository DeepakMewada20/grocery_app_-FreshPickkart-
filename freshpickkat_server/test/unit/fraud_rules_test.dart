import 'package:test/test.dart';
import 'package:freshpickkat_server/src/services/fraud/fraud_rule.dart';

void main() {
  group('FraudRuleResult', () {
    test('toJson serializes correctly', () {
      final result = FraudRuleResult(
        ruleName: 'test_rule',
        weight: 20,
        score: 30,
        passed: false,
        description: 'Test description',
      );

      final json = result.toJson();
      expect(json['ruleName'], equals('test_rule'));
      expect(json['weight'], equals(20));
      expect(json['score'], equals(30));
      expect(json['passed'], isFalse);
      expect(json['description'], equals('Test description'));
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'ruleName': 'test_rule',
        'weight': 20,
        'score': 30,
        'passed': false,
        'description': 'Test description',
      };

      final result = FraudRuleResult.fromJson(json);
      expect(result.ruleName, equals('test_rule'));
      expect(result.weight, equals(20));
      expect(result.score, equals(30));
      expect(result.passed, isFalse);
      expect(result.description, equals('Test description'));
    });

    test('passed result serializes correctly', () {
      final result = FraudRuleResult(
        ruleName: 'passed_rule',
        weight: 10,
        score: 0,
        passed: true,
        description: 'All clear',
      );

      final json = result.toJson();
      expect(json['passed'], isTrue);
      expect(json['score'], equals(0));
    });
  });
}
