import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_order_service.dart';
import 'order_endpoint.dart';
import 'payment_endpoint.dart';

class CheckoutEndpoint extends Endpoint {
  final _orderEndpoint = OrderEndpoint();
  final _paymentEndpoint = PaymentEndpoint();
  final PostgresOrderService _orders = PostgresOrderService();

  Future<protocol.CheckoutResult> createOrderAndPayment(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) async {
    try {
      // 1. Create order (server calculates all pricing internally)
      final orderId = await _orderEndpoint.createPendingOrder(
        session,
        order,
        idempotencyKey,
      );

      // 2. Get server-calculated final amount (ignore client-provided amount)
      final serverFinalAmount = await _orders.getOrderFinalAmount(
        session,
        orderId,
      );

      // 3. Create payment order with server-calculated amount
      final paymentResult = await _paymentEndpoint.createPaymentOrder(
        session,
        orderId,
        serverFinalAmount,
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
