import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_payment_link_service.dart';
import '../services/postgres/postgres_payment_service.dart';
import '../services/postgres/postgres_support.dart';
import 'payment_endpoint.dart';

class PaymentLinkEndpoint extends Endpoint {
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();
  final PostgresPaymentService _payments = PostgresPaymentService();
  final PaymentEndpoint _paymentEndpoint = PaymentEndpoint();

  /// Create an order with a shareable payment link.
  /// Returns order details + payment link data.
  Future<Map<String, dynamic>> createShareablePaymentLink(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) async {
    try {
      // 1. Create the order in PAYMENT_PENDING status
      final orderNumber = await _orders.createPendingOrder(
        session,
        order: order,
        idempotencyKey: idempotencyKey,
      );

      // 2. Get server-calculated final amount
      final serverFinalAmount = await _orders.getOrderFinalAmount(
        session,
        orderNumber,
      );

      // 3. Create Razorpay order (locks the amount)
      final paymentResult = await _paymentEndpoint.createPaymentOrder(
        session,
        orderNumber,
        serverFinalAmount,
        customerPhone,
      );

      if (paymentResult.success != true) {
        return {
          'success': false,
          'error': paymentResult.error ?? 'Failed to create payment order',
          'orderId': orderNumber,
        };
      }

      // 4. Update order status to PAYMENT_PENDING
      await _updateOrderToPaymentPending(session, orderNumber);

      // 5. Create payment link
      final linkResult = await _paymentLinks.createPaymentLink(
        session,
        orderId: orderNumber,
      );

      if (linkResult['success'] != true) {
        return {
          'success': false,
          'error': linkResult['error'] ?? 'Failed to create payment link',
          'orderId': orderNumber,
        };
      }

      return {
        'success': true,
        'orderId': orderNumber,
        'token': linkResult['token'],
        'paymentLink': linkResult['paymentLink'],
        'expiresAt': linkResult['expiresAt'],
        'razorpayOrderId': paymentResult.razorpayOrderId,
        'amount': paymentResult.amount,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Validate a payment link token and return order page data.
  /// This endpoint is unauthenticated — the token is the auth.
  Future<Map<String, dynamic>> getPaymentPageData(
    Session session,
    String token,
  ) async {
    return _paymentLinks.validateToken(session, token);
  }

  /// Confirm payment from the payment page (called after Razorpay success).
  /// This endpoint is unauthenticated — the token is the auth.
  Future<Map<String, dynamic>> confirmPayment(
    Session session,
    String token,
    String razorpayPaymentId,
    String razorpayOrderId,
    String razorpaySignature, {
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
  }) async {
    try {
      // 1. Find the payment link
      final linkRows = await session.db.unsafeQuery(
        '''
        SELECT * FROM "payment_link"
        WHERE "token" = @token
        LIMIT 1
        ''',
        parameters: QueryParameters.named({'token': token}),
      );
      if (linkRows.isEmpty) {
        return {'success': false, 'message': 'Payment link not found.'};
      }
      final linkMap = linkRows.first.toColumnMap();

      if (linkMap['isUsed'] as bool? ?? false) {
        return {'success': false, 'message': 'This payment link has already been used.'};
      }

      final expiresAtStr = linkMap['expiresAt'] as String?;
      if (expiresAtStr != null) {
        final expiresAt = DateTime.tryParse(expiresAtStr)?.toUtc();
        if (expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt)) {
          return {'success': false, 'message': 'This payment link has expired.'};
        }
      }

      final orderId = (linkMap['orderId'] as String?) ?? '';
      final parsedOrderId = tryParseUuid(orderId);
      if (parsedOrderId == null) {
        return {'success': false, 'message': 'Invalid order reference.'};
      }

      final orderRow = await protocol.CustomerOrderRow.db.findById(session, parsedOrderId);
      if (orderRow == null) {
        return {'success': false, 'message': 'Order not found.'};
      }

      // 2. Use existing payment verification flow
      final result = await _payments.verifyPaymentFromLink(
        session,
        orderNumber: orderRow.orderNumber,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
        paidByName: paidByName,
        paidByPhone: paidByPhone,
        paidByEmail: paidByEmail,
        paymentLinkToken: token,
      );

      if (result['success'] == true && result['verified'] == true) {
        return {'success': true, 'message': 'Payment confirmed successfully.'};
      }

      return {
        'success': false,
        'message': result['message'] as String? ??
            result['error'] as String? ??
            'Payment verification failed.',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> _updateOrderToPaymentPending(
    Session session,
    String orderNumber,
  ) async {
    final row = await protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return;

    await protocol.CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        orderStatus: 'payment_pending',
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }
}
