import 'package:freshpickkat_server/src/services/postgres/postgres_referral_service.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresReferralService.generateReferralCode', () {
    test('format is FPK + 4 alphanumeric chars', () {
      final code = PostgresReferralService.generateReferralCode();
      expect(code.length, equals(7));
      expect(code.startsWith('FPK'), isTrue);
      expect(code.substring(3), matches(RegExp(r'^[A-Z2-9]{4}$')));
    });

    test('generates diverse codes on repeated calls', () {
      final codes = <String>{};
      for (var i = 0; i < 100; i++) {
        codes.add(PostgresReferralService.generateReferralCode());
      }
      expect(codes.length, greaterThan(90));
    });

    test('does not contain ambiguous characters (I, O, 0, 1)', () {
      for (var i = 0; i < 500; i++) {
        final code = PostgresReferralService.generateReferralCode();
        final suffix = code.substring(3);
        expect(suffix.contains('I'), isFalse);
        expect(suffix.contains('O'), isFalse);
        expect(suffix.contains('0'), isFalse);
        expect(suffix.contains('1'), isFalse);
      }
    });

    test('prefix is always uppercase FPK', () {
      for (var i = 0; i < 50; i++) {
        final code = PostgresReferralService.generateReferralCode();
        expect(code.startsWith('FPK'), isTrue);
      }
    });
  });
}
