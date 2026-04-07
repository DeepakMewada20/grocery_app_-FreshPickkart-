import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/refunds/refund_service.dart';

class RefundEndpoint extends Endpoint {
  final RefundService _refundService = RefundService();

  Future<protocol.RefundRecord> initiateRefund(
    Session session,
    String orderId,
  ) {
    return _refundService.initiateRefund(orderId: orderId);
  }

  Future<protocol.RefundRecord?> getRefundStatus(
    Session session,
    String orderId,
  ) {
    return _refundService.getRefundStatus(orderId);
  }
}
