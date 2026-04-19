import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import 'order_endpoint.dart';
import 'payment_endpoint.dart';

class CheckoutEndpoint extends Endpoint {
  final _orderEndpoint = OrderEndpoint();
  final _paymentEndpoint = PaymentEndpoint();

  Future<protocol.CheckoutResult> createOrderAndPayment(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) async {
    try {
      // 1. Create order
      final orderId = await _orderEndpoint.createPendingOrder(
        session,
        order,
        idempotencyKey,
      );

      // 2. Create payment order
      final paymentResult = await _paymentEndpoint.createPaymentOrder(
        session,
        orderId,
        amount,
        customerPhone,
      );

      if (paymentResult.success != true) {
        return protocol.CheckoutResult(
          success: false,
          error: paymentResult.error ?? 'Failed to create payment order',
          orderId: orderId,
        );
      }

      return protocol.CheckoutResult(
        success: true,
        orderId: orderId,
        paymentOrder: paymentResult,
      );
    } catch (e) {
      return protocol.CheckoutResult(
        success: false,
        error: e.toString(),
      );
    }
  }
}
