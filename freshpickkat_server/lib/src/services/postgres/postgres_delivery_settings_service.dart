import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_audit_log_service.dart';

class PostgresDeliverySettingsService {
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();

  Future<DeliverySettings> getOrCreateSettings(Session session) async {
    final existing = await DeliverySettingsRow.db.findFirstRow(session);
    if (existing != null) return _mapSettings(existing);

    final now = DateTime.now().toUtc();
    final inserted = await DeliverySettingsRow.db.insertRow(
      session,
      DeliverySettingsRow(
        defaultVerificationMethod: 'otp',
        cameraOnlyCapture: true,
        gpsRequired: true,
        strictDistanceValidation: true,
        maxAllowedRadiusMeters: 200,
        updatedAt: now,
      ),
    );
    return _mapSettings(inserted);
  }

  Future<DeliverySettings> updateSettings(
    Session session,
    DeliverySettings settings, {
    required String adminFirebaseUid,
  }) async {
    final now = DateTime.now().toUtc();

    final row = await DeliverySettingsRow.db.findFirstRow(session);
    final updated = await DeliverySettingsRow.db.updateRow(
      session,
      (row ?? DeliverySettingsRow()).copyWith(
        defaultVerificationMethod: settings.defaultVerificationMethod,
        cameraOnlyCapture: settings.cameraOnlyCapture,
        gpsRequired: settings.gpsRequired,
        strictDistanceValidation: settings.strictDistanceValidation,
        maxAllowedRadiusMeters: settings.maxAllowedRadiusMeters,
        updatedAt: now,
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: adminFirebaseUid,
      action: 'UPDATE_DELIVERY_SETTINGS',
      entityType: 'delivery_settings',
      metadata: {
        'defaultVerificationMethod': settings.defaultVerificationMethod,
        'cameraOnlyCapture': settings.cameraOnlyCapture.toString(),
        'gpsRequired': settings.gpsRequired.toString(),
        'strictDistanceValidation': settings.strictDistanceValidation.toString(),
        'maxAllowedRadiusMeters': settings.maxAllowedRadiusMeters.toString(),
      },
    );

    return _mapSettings(updated);
  }

  DeliverySettings _mapSettings(DeliverySettingsRow row) {
    return DeliverySettings(
      defaultVerificationMethod: row.defaultVerificationMethod,
      cameraOnlyCapture: row.cameraOnlyCapture,
      gpsRequired: row.gpsRequired,
      strictDistanceValidation: row.strictDistanceValidation,
      maxAllowedRadiusMeters: row.maxAllowedRadiusMeters,
      updatedAt: row.updatedAt,
    );
  }
}
