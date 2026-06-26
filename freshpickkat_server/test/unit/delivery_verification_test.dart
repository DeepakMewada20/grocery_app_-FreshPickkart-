import 'package:test/test.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_delivery_verification_service.dart';

void main() {
  group('Haversine distance calculation', () {
    test('same point returns 0', () {
      final distance = PostgresDeliveryVerificationService.calculateDistanceMeters(
        28.6129,
        77.2295,
        28.6129,
        77.2295,
      );
      expect(distance, closeTo(0, 0.1));
    });

    test('known distance Delhi to Noida (~20km)', () {
      // Delhi (Connaught Place): 28.6295° N, 77.2092° E
      // Noida Sector 62: 28.5940° N, 77.3700° E
      final distance = PostgresDeliveryVerificationService.calculateDistanceMeters(
        28.6295,
        77.2092,
        28.5940,
        77.3700,
      );
      expect(distance, greaterThan(14000));
      expect(distance, lessThan(17000));
    });

    test('short distance ~50m', () {
      final distance = PostgresDeliveryVerificationService.calculateDistanceMeters(
        28.612900,
        77.229500,
        28.613200,
        77.229800,
      );
      expect(distance, greaterThan(30));
      expect(distance, lessThan(70));
    });

    test('coordinates are commutative (A->B == B->A)', () {
      final d1 = PostgresDeliveryVerificationService.calculateDistanceMeters(
        28.6129, 77.2295, 19.0760, 72.8777,
      );
      final d2 = PostgresDeliveryVerificationService.calculateDistanceMeters(
        19.0760, 72.8777, 28.6129, 77.2295,
      );
      expect(d1, closeTo(d2, 0.1));
    });
  });
}
