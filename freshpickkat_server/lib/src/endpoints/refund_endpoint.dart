import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class RefundEndpoint extends Endpoint {
  final PostgresRefundService _refundService = PostgresRefundService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

  Future<protocol.RefundRecord> initiateRefund(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _refundService.initiateRefund(session, orderNumber: orderId);
  }

  Future<protocol.RefundRecord?> getRefundStatus(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId.trim()),
    );
    if (order == null || order.userId != user.id) {
      throw Exception('Order does not belong to user.');
    }
    return _refundService.getRefundStatus(session, orderId);
  }
}
