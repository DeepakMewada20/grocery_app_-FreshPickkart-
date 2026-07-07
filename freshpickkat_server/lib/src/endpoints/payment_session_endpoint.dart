import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/payments/postgres_payment_session_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';

class PaymentSessionEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresPaymentSessionService _paymentSessions =
      PostgresPaymentSessionService();

  Future<PaymentSessionData> createQrPaymentSession(
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

    return _paymentSessions.createQrPaymentSession(
      session,
      orderId: orderId,
      adminFirebaseUid: firebaseUid,
    );
  }

  Future<PaymentSessionData> getQrPaymentSession(
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

    return _paymentSessions.getQrPaymentSession(
      session,
      orderId: orderId,
    );
  }

  Future<PaymentSessionData> regenerateQrPaymentSession(
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

    return _paymentSessions.regenerateQrPaymentSession(
      session,
      orderId: orderId,
      adminFirebaseUid: firebaseUid,
    );
  }
}
