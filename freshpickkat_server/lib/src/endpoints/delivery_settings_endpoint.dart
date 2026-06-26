import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_delivery_settings_service.dart';

class DeliverySettingsEndpoint extends Endpoint {
  final PostgresDeliverySettingsService _settings =
      PostgresDeliverySettingsService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<protocol.DeliverySettings> getSettings(Session session) async {
    return _settings.getOrCreateSettings(session);
  }

  Future<protocol.DeliverySettings> updateSettings(
    Session session,
    protocol.DeliverySettings settings,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _settings.updateSettings(
      session,
      settings,
      adminFirebaseUid: firebaseUid,
    );
  }
}
