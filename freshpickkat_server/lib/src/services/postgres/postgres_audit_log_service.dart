import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresAuditLogService {
  Future<void> write(
    Session session, {
    String? actorFirebaseUid,
    UuidValue? actorUserId,
    required String action,
    required String entityType,
    String? entityId,
    Map<String, String>? metadata,
    Transaction? transaction,
  }) async {
    final resolvedActorUserId =
        actorUserId ??
        await _resolveActorUserId(
          session,
          actorFirebaseUid: actorFirebaseUid,
          transaction: transaction,
        );

    await AdminAuditLogRow.db.insertRow(
      session,
      AdminAuditLogRow(
        actorUserId: resolvedActorUserId,
        action: action.trim(),
        entityType: entityType.trim(),
        entityId: tryParseUuid(entityId),
        metadata: metadata == null || metadata.isEmpty ? null : metadata,
      ),
      transaction: transaction,
    );
  }

  Future<UuidValue?> _resolveActorUserId(
    Session session, {
    required String? actorFirebaseUid,
    Transaction? transaction,
  }) async {
    final firebaseUid = cleanNullableString(actorFirebaseUid);
    if (firebaseUid == null) return null;

    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(firebaseUid),
      transaction: transaction,
    );
    return user?.id;
  }
}
