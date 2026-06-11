import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_complaint_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class OrderDetailEndpoint extends Endpoint {
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresRefundService _refunds = PostgresRefundService();
  final PostgresComplaintService _complaints = PostgresComplaintService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

  Future<OrderDetailHydrated> getOrderDetailHydrated(
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

    final order = await _orders.getOrderById(session, orderId);
    final refund = order != null
        ? await _refunds.getRefundStatus(session, orderId)
        : null;

    Complaint? activeProductComplaint;
    Complaint? activeDeliveryComplaint;
    if (order != null) {
      final complaintsResult = await Future.wait([
        _complaints.getActiveComplaintForOrder(
          session,
          user: user,
          orderNumber: orderId,
          complaintType: 'product',
        ),
        _complaints.getActiveComplaintForOrder(
          session,
          user: user,
          orderNumber: orderId,
          complaintType: 'delivery',
        ),
      ]);
      activeProductComplaint = complaintsResult[0];
      activeDeliveryComplaint = complaintsResult[1];
    }

    return OrderDetailHydrated(
      order: order,
      refund: refund,
      activeProductComplaint: activeProductComplaint,
      activeDeliveryComplaint: activeDeliveryComplaint,
    );
  }
}
