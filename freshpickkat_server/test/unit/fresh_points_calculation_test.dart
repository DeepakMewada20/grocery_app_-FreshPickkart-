import 'package:freshpickkat_server/src/services/postgres/postgres_fresh_points_service.dart';
import 'package:test/test.dart';

void main() {
  group('FreshPoints calculateMaxRedeemable', () {
    test('returns full balance when payable and limit allow', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 500,
        payableAfterCoupon: 1000.0,
        redemptionLimitPercent: 50,
      );
      expect(result, equals(500));
    });

    test('caps at redemptionPercentageLimit of payable', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 1000,
        payableAfterCoupon: 400.0,
        redemptionLimitPercent: 50,
      );
      expect(result, equals(200));
    });

    test('returns 0 when payable is 0', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 500,
        payableAfterCoupon: 0.0,
        redemptionLimitPercent: 50,
      );
      expect(result, equals(0));
    });

    test('returns 0 when balance is 0', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 0,
        payableAfterCoupon: 1000.0,
        redemptionLimitPercent: 50,
      );
      expect(result, equals(0));
    });

    test('respects custom redemption limit percentage', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 500,
        payableAfterCoupon: 1000.0,
        redemptionLimitPercent: 25,
      );
      expect(result, equals(250));
    });

    test('does not allow negative value for negative payable', () {
      final result = PostgresFreshPointsService.calculateMaxRedeemable(
        balance: 500,
        payableAfterCoupon: -100.0,
        redemptionLimitPercent: 50,
      );
      expect(result, equals(0));
    });
  });
}
