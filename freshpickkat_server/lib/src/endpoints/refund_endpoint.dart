import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_refund_service.dart';

class RefundEndpoint extends Endpoint {
  final PostgresRefundService _refundService = PostgresRefundService();

  Future<protocol.RefundRecord> initiateRefund(
    Session session,
    String orderId,
  ) {
    return _refundService.initiateRefund(session, orderNumber: orderId);
  }

  Future<protocol.RefundRecord?> getRefundStatus(
    Session session,
    String orderId,
  ) {
    return _refundService.getRefundStatus(session, orderId);
  }
}
