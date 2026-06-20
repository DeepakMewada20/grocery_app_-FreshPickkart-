import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/cascade_deactivation_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';

class CascadeEndpoint extends Endpoint {
  final CascadeDeactivationService _cascade = CascadeDeactivationService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<CascadeImpactResponse> analyzeCascadeDeactivation(
    Session session,
    String entityType,
    String entityId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _cascade.analyzeDeactivation(session, entityType, entityId);
  }

  Future<CascadeExecuteResponse> executeCascadeDeactivation(
    Session session,
    String entityType,
    String entityId,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _cascade.executeDeactivation(
      session,
      entityType,
      entityId,
      actor.id.toString(),
    );
  }
}
