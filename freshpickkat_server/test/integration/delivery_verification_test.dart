import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_delivery_verification_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_delivery_settings_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Delivery Verification', (sessionBuilder, endpoints) {
    late PostgresDeliveryVerificationService verificationService;
    late PostgresDeliverySettingsService settingsService;

    setUp(() {
      verificationService = PostgresDeliveryVerificationService();
      settingsService = PostgresDeliverySettingsService();
    });

    // ── Photo Delivery ──────────────────────────────────────────────────────

    test('Photo delivery: completes successfully with valid GPS and distance',
        () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999501');
        final order = await _seedOrder(session, user.id!, 'OD-9501',
            orderStatus: 'out_for_delivery');
        await _seedOrderAddress(session, order.id!, latitude: 28.6129, longitude: 77.2295);
        await _seedDeliverySettings(session);

        await verificationService.completePhotoDelivery(
          session,
          orderId: 'OD-9501',
          imageUrl: 'https://storage.example.com/delivery/od-9501.jpg',
          latitude: 28.6130,
          longitude: 77.2296,
          gpsAccuracy: 5.0,
          adminFirebaseUid: 'admin-fb-001',
          adminName: 'Test Admin',
        );

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals('OD-9501'),
        );
        expect(updated!.orderStatus, equals('delivered'));
        expect(updated.deliveryVerificationMethod, equals('photo'));
        expect(updated.deliveryProofImageUrl,
            equals('https://storage.example.com/delivery/od-9501.jpg'));
        expect(updated.deliveryProofLatitude, closeTo(28.6130, 0.0001));
        expect(updated.deliveryProofLongitude, closeTo(77.2296, 0.0001));
        expect(updated.deliveryProofGpsAccuracy, equals(5.0));
        expect(updated.deliveryProofDistanceMeters, lessThan(50));
        expect(updated.deliveredByName, equals('Test Admin'));
        expect(updated.deliveredByRole, equals('admin'));
        expect(updated.deliveredAt, isNotNull);
        expect(updated.deliveryCompletedAt, isNotNull);
        expect(updated.deliveryProofTimestamp, isNotNull);
      } finally {
        await session.close();
      }
    });

    test('Photo delivery: rejects wrong order status', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999502');
        final order = await _seedOrder(session, user.id!, 'OD-9502',
            orderStatus: 'pending');

        await expectLater(
          verificationService.completePhotoDelivery(
            session,
            orderId: 'OD-9502',
            imageUrl: 'https://storage.example.com/delivery/od-9502.jpg',
            latitude: 28.6129,
            longitude: 77.2295,
            gpsAccuracy: 5.0,
            adminFirebaseUid: 'admin-fb-001',
            adminName: 'Test Admin',
          ),
          throwsA(isA<StateError>()),
        );
      } finally {
        await session.close();
      }
    });

    test('Photo delivery: rejects poor GPS accuracy', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999503');
        final order = await _seedOrder(session, user.id!, 'OD-9503',
            orderStatus: 'out_for_delivery');
        await _seedOrderAddress(session, order.id!, latitude: 28.6129, longitude: 77.2295);
        await _seedDeliverySettings(session);

        await expectLater(
          verificationService.completePhotoDelivery(
            session,
            orderId: 'OD-9503',
            imageUrl: 'https://storage.example.com/delivery/od-9503.jpg',
            latitude: 28.6130,
            longitude: 77.2296,
            gpsAccuracy: 50.0, // exceeds 30m
            adminFirebaseUid: 'admin-fb-001',
            adminName: 'Test Admin',
          ),
          throwsA(isA<StateError>()),
        );
      } finally {
        await session.close();
      }
    });

    test('Photo delivery: rejects distance beyond allowed radius', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999504');
        final order = await _seedOrder(session, user.id!, 'OD-9504',
            orderStatus: 'out_for_delivery');
        await _seedOrderAddress(session, order.id!,
            latitude: 28.6129, longitude: 77.2295);
        // Use strict radius of 100m
        await _seedDeliverySettings(session,
            strictDistanceValidation: true, maxAllowedRadiusMeters: 100);

        // ~500m away: Delhi to nearby but outside 100m
        await expectLater(
          verificationService.completePhotoDelivery(
            session,
            orderId: 'OD-9504',
            imageUrl: 'https://storage.example.com/delivery/od-9504.jpg',
            latitude: 28.6170,
            longitude: 77.2340,
            gpsAccuracy: 5.0,
            adminFirebaseUid: 'admin-fb-001',
            adminName: 'Test Admin',
          ),
          throwsA(isA<StateError>()),
        );
      } finally {
        await session.close();
      }
    });

    test('Photo delivery: no address coordinates throws StateError', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999505');
        final order = await _seedOrder(session, user.id!, 'OD-9505',
            orderStatus: 'out_for_delivery');
        await _seedOrderAddress(session, order.id!,
            latitude: null, longitude: null);
        await _seedDeliverySettings(session);

        await expectLater(
          verificationService.completePhotoDelivery(
            session,
            orderId: 'OD-9505',
            imageUrl: 'https://storage.example.com/delivery/od-9505.jpg',
            latitude: 28.6129,
            longitude: 77.2295,
            gpsAccuracy: 5.0,
            adminFirebaseUid: 'admin-fb-001',
            adminName: 'Test Admin',
          ),
          throwsA(isA<StateError>()),
        );
      } finally {
        await session.close();
      }
    });

    test('Photo delivery: unknown order throws ArgumentError', () async {
      final session = sessionBuilder.build();
      try {
        await expectLater(
          verificationService.completePhotoDelivery(
            session,
            orderId: 'OD-NONEXISTENT',
            imageUrl: 'https://storage.example.com/delivery/x.jpg',
            latitude: 28.6129,
            longitude: 77.2295,
            gpsAccuracy: 5.0,
            adminFirebaseUid: 'admin-fb-001',
            adminName: 'Test Admin',
          ),
          throwsA(isA<ArgumentError>()),
        );
      } finally {
        await session.close();
      }
    });

    // ── OTP Delivery ────────────────────────────────────────────────────────

    test('OTP delivery: records metadata', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(session, '9999999511');
        final order = await _seedOrder(session, user.id!, 'OD-9511',
            orderStatus: 'out_for_delivery');

        await verificationService.recordOtpDeliveryMetadata(
          session,
          orderId: 'OD-9511',
          adminFirebaseUid: 'admin-fb-002',
          adminName: 'OTP Admin',
        );

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals('OD-9511'),
        );
        expect(updated!.deliveryVerificationMethod, equals('otp'));
        expect(updated.deliveryOtpVerifiedAt, isNotNull);
        expect(updated.deliveredByName, equals('OTP Admin'));
        expect(updated.deliveredByRole, equals('admin'));
        expect(updated.deliveryCompletedAt, isNotNull);
      } finally {
        await session.close();
      }
    });

    // ── Delivery Settings ───────────────────────────────────────────────────

    test('Delivery settings: getOrCreateSettings creates defaults', () async {
      final session = sessionBuilder.build();
      try {
        final settings = await settingsService.getOrCreateSettings(session);
        expect(settings.defaultVerificationMethod, equals('otp'));
        expect(settings.cameraOnlyCapture, isTrue);
        expect(settings.gpsRequired, isTrue);
        expect(settings.strictDistanceValidation, isTrue);
        expect(settings.maxAllowedRadiusMeters, equals(200));
      } finally {
        await session.close();
      }
    });

    test('Delivery settings: getOrCreateSettings returns existing', () async {
      final session = sessionBuilder.build();
      try {
        await _seedDeliverySettings(session,
            defaultVerificationMethod: 'photo',
            maxAllowedRadiusMeters: 500);

        final settings = await settingsService.getOrCreateSettings(session);
        expect(settings.defaultVerificationMethod, equals('photo'));
        expect(settings.maxAllowedRadiusMeters, equals(500));
      } finally {
        await session.close();
      }
    });

    test('Delivery settings: updateSettings persists changes', () async {
      final session = sessionBuilder.build();
      try {
        await _seedDeliverySettings(session);

        final now = DateTime.now().toUtc();
      final updated = await settingsService.updateSettings(
          session,
          protocol.DeliverySettings(
            defaultVerificationMethod: 'photo',
            cameraOnlyCapture: false,
            gpsRequired: false,
            strictDistanceValidation: false,
            maxAllowedRadiusMeters: 1000,
            updatedAt: now,
          ),
          adminFirebaseUid: 'admin-fb-003',
        );

        expect(updated.defaultVerificationMethod, equals('photo'));
        expect(updated.cameraOnlyCapture, isFalse);
        expect(updated.gpsRequired, isFalse);
        expect(updated.strictDistanceValidation, isFalse);
        expect(updated.maxAllowedRadiusMeters, equals(1000));

        // Verify persisted in DB
        final fromDb = await settingsService.getOrCreateSettings(session);
        expect(fromDb.maxAllowedRadiusMeters, equals(1000));
      } finally {
        await session.close();
      }
    });

    // ── Endpoint integration ────────────────────────────────────────────────

    test('Delivery settings endpoint: getSettings returns settings', () async {
      final settings = await endpoints.deliverySettings.getSettings(sessionBuilder);
      expect(settings.defaultVerificationMethod, isNotEmpty);
      expect(settings.maxAllowedRadiusMeters, greaterThan(0));
    });
  });
}

// ── Helpers ─────────────────────────────────────────────────────────────────────

Future<protocol.AppUserRow> _seedUser(
  Session session,
  String phone, {
  String? referralCode,
  int currentFreshPoints = 0,
}) async {
  return await protocol.AppUserRow.db.insertRow(
    session,
    protocol.AppUserRow(
      phoneNumber: phone,
      name: 'User $phone',
      referralCode: referralCode,
      currentFreshPoints: currentFreshPoints,
    ),
  );
}

Future<protocol.CustomerOrderRow> _seedOrder(
  Session session,
  UuidValue userId,
  String orderNumber, {
  String orderStatus = 'pending',
}) async {
  final now = DateTime.now().toUtc();
  return await protocol.CustomerOrderRow.db.insertRow(
    session,
    protocol.CustomerOrderRow(
      userId: userId,
      orderNumber: orderNumber,
      orderStatus: orderStatus,
      paymentStatus: 'pending',
      refundStatus: 'none',
      itemCount: 1,
      totalAmount: 100.0,
      discountAmount: 0.0,
      deliveryFee: 0.0,
      finalAmount: 100.0,
      orderType: 'regular',
      paymentMode: 'standard',
      orderedAt: now,
    ),
  );
}

Future<protocol.OrderAddressRow> _seedOrderAddress(
  Session session,
  UuidValue orderId, {
  double? latitude,
  double? longitude,
}) async {
  return await protocol.OrderAddressRow.db.insertRow(
    session,
    protocol.OrderAddressRow(
      orderId: orderId,
      streetLine1: 'Test Street',
      city: 'Test City',
      state: 'Test State',
      postalCode: '110001',
      country: 'India',
      latitude: latitude,
      longitude: longitude,
    ),
  );
}

Future<protocol.DeliverySettingsRow> _seedDeliverySettings(
  Session session, {
  String defaultVerificationMethod = 'otp',
  bool cameraOnlyCapture = true,
  bool gpsRequired = true,
  bool strictDistanceValidation = true,
  int maxAllowedRadiusMeters = 200,
}) async {
  final now = DateTime.now().toUtc();
  return await protocol.DeliverySettingsRow.db.insertRow(
    session,
    protocol.DeliverySettingsRow(
      defaultVerificationMethod: defaultVerificationMethod,
      cameraOnlyCapture: cameraOnlyCapture,
      gpsRequired: gpsRequired,
      strictDistanceValidation: strictDistanceValidation,
      maxAllowedRadiusMeters: maxAllowedRadiusMeters,
      updatedAt: now,
    ),
  );
}
