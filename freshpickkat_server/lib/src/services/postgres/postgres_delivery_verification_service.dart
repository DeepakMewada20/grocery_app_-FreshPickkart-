import 'dart:math';

import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../business/validation_service.dart';
import 'postgres_delivery_settings_service.dart';

class PostgresDeliveryVerificationService {
  final PostgresDeliverySettingsService _settingsService =
      PostgresDeliverySettingsService();

  /// Haversine distance between two (lat, lng) points in meters.
  static double calculateDistanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  /// Completes delivery via photo proof.
  /// Validates GPS accuracy, distance from customer address, writes all proof
  /// fields, and sets order status to delivered.
  Future<void> completePhotoDelivery(
    Session session, {
    required String orderId,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required double gpsAccuracy,
    required String adminFirebaseUid,
    required String adminName,
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (row == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (row.orderStatus != ValidationService.statusOutForDelivery) {
      throw StateError(
        'Order status must be "out_for_delivery" to complete photo delivery. '
        'Current status: ${row.orderStatus}',
      );
    }

    // Look up admin user
    final admin = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(adminFirebaseUid),
    );

    // Get customer delivery address coordinates
    final address = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(row.id!),
    );
    if (address == null || address.latitude == null || address.longitude == null) {
      throw StateError(
        'Customer delivery address does not have valid coordinates.',
      );
    }

    final settings = await _settingsService.getOrCreateSettings(session);

    // 1. GPS accuracy validation
    if (settings.gpsRequired && gpsAccuracy > 30) {
      throw StateError(
        'GPS signal too weak (accuracy: ${gpsAccuracy.toStringAsFixed(0)}m). '
        'Please move to an open area and retry (minimum 30m accuracy required).',
      );
    }

    // 2. Distance validation
    final distanceMeters = calculateDistanceMeters(
      address.latitude!,
      address.longitude!,
      latitude,
      longitude,
    );
    if (settings.strictDistanceValidation &&
        distanceMeters > settings.maxAllowedRadiusMeters) {
      throw StateError(
        'Delivery cannot be completed because the proof location is outside '
        'the allowed delivery radius of ${settings.maxAllowedRadiusMeters}m '
        '(actual distance: ${distanceMeters.toStringAsFixed(0)}m).',
      );
    }

    // 3. Update order row with proof fields
    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        deliveryVerificationMethod: 'photo',
        deliveryProofImageUrl: imageUrl,
        deliveryProofLatitude: latitude,
        deliveryProofLongitude: longitude,
        deliveryProofTimestamp: now,
        deliveryProofDistanceMeters: distanceMeters,
        deliveryProofGpsAccuracy: gpsAccuracy,
        deliveredByUserId: admin?.id?.toString() ?? adminFirebaseUid,
        deliveredByName: adminName,
        deliveredByRole: 'admin',
        deliveryCompletedAt: now,
        orderStatus: 'delivered',
        deliveredAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Records delivered-by metadata after successful OTP verification.
  Future<void> recordOtpDeliveryMetadata(
    Session session, {
    required String orderId,
    required String adminFirebaseUid,
    required String adminName,
  }) async {
    final admin = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(adminFirebaseUid),
    );

    final now = DateTime.now().toUtc();
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (row == null) return;

    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        deliveryVerificationMethod: 'otp',
        deliveryOtpVerifiedAt: now,
        deliveredByUserId: admin?.id?.toString() ?? adminFirebaseUid,
        deliveredByName: adminName,
        deliveredByRole: 'admin',
        deliveryCompletedAt: now,
        updatedAt: now,
      ),
    );
  }
}
