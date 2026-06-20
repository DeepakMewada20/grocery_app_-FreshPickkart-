import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/config/env_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_payment_link_service.dart';
import '../services/postgres/postgres_payment_service.dart';
import '../services/postgres/postgres_support.dart';
import '../services/postgres/postgres_user_guard_service.dart';
import 'payment_endpoint.dart';

class PaymentLinkEndpoint extends Endpoint {
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();
  final PostgresPaymentService _payments = PostgresPaymentService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final PaymentEndpoint _paymentEndpoint = PaymentEndpoint();

  /// Create an order with a shareable payment link.
  /// Returns order details + payment link data.
  Future<protocol.PaymentLinkData> createShareablePaymentLink(
    Session session,
    protocol.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
    String firebaseUid,
    String idToken, {
    String? pendingOrderAction,
  }) async {
    try {
      // Security: verify customer is logged in and owns this request
      final user = await _userGuard.ensureUser(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      final generatedBy = user.id.toString();

      // Handle pending order actions
      if (pendingOrderAction == 'cancel' && firebaseUid.isNotEmpty) {
        final existing = await _orders.findActivePendingOrder(
          session,
          firebaseUid,
        );
        if (existing != null) {
          await _orders.cancelPendingOrder(
            session,
            existing.orderNumber,
            firebaseUid,
            reason: 'Cancelled by user — switching to payment link',
          );
        }
      } else if (firebaseUid.isNotEmpty) {
        // Check for existing active pending order — prevent duplicate pending orders
        final existingPending = await _orders.findActivePendingOrder(
          session,
          firebaseUid,
        );
        if (existingPending != null) {
          return protocol.PaymentLinkData(
            success: false,
            error: 'ACTIVE_PENDING_ORDER:${existingPending.orderNumber}',
            orderId: existingPending.orderNumber,
          );
        }
      }

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

      final amountInPaise = (serverFinalAmount * 100).round();
      final enableWebCheckout = EnvService.get('ENABLE_WEB_CHECKOUT') == 'true';

      if (enableWebCheckout) {
        // === BROWSER CHECKOUT FLOW (existing) ===
        // 3a. Create Razorpay order (locks the amount)
        final paymentResult = await _paymentEndpoint.createPaymentOrder(
          session,
          orderNumber,
          serverFinalAmount,
          customerPhone,
        );

        if (paymentResult.success != true) {
          await _orders.cancelPendingOrder(
            session,
            orderNumber,
            firebaseUid,
            reason: 'Failed to create payment order',
          );
          return protocol.PaymentLinkData(
            success: false,
            error: paymentResult.error ?? 'Failed to create payment order',
            orderId: orderNumber,
          );
        }

        // 4a. Update order status to PAYMENT_PENDING
        await _updateOrderToPaymentPending(session, orderNumber);

        // 5a. Create browser payment link
        final linkResult = await _paymentLinks.createPaymentLink(
          session,
          orderId: orderNumber,
          generatedBy: generatedBy,
        );

        if (linkResult['success'] != true) {
          await _orders.cancelPendingOrder(
            session,
            orderNumber,
            firebaseUid,
            reason: 'Failed to create web checkout payment link',
          );
          return protocol.PaymentLinkData(
            success: false,
            error:
                linkResult['error'] as String? ??
                'Failed to create payment link',
            orderId: orderNumber,
          );
        }

        final expiresAtStr = linkResult['expiresAt'] as String?;
        return protocol.PaymentLinkData(
          success: true,
          token: linkResult['token'] as String?,
          paymentLink: linkResult['paymentLink'] as String?,
          expiresAt: expiresAtStr != null
              ? DateTime.tryParse(expiresAtStr)
              : null,
          razorpayOrderId: paymentResult.razorpayOrderId,
          amount: paymentResult.amount,
          orderId: orderNumber,
        );
      } else {
        // === RAZORPAY PAYMENT LINKS API FLOW ===
        // 3b. Update order status to PAYMENT_PENDING
        await _updateOrderToPaymentPending(session, orderNumber);

        // 4b. Create Razorpay Payment Link (creates internal order + hosted page)
        final linkResult = await _paymentLinks.createRazorpayPaymentLink(
          session,
          orderNumber: orderNumber,
          amountInPaise: amountInPaise,
          customerPhone: customerPhone,
          customerName: order.userName ?? '',
          generatedBy: generatedBy,
        );

        if (linkResult['success'] != true) {
          await _orders.cancelPendingOrder(
            session,
            orderNumber,
            firebaseUid,
            reason: 'Failed to create Razorpay payment link',
          );
          return protocol.PaymentLinkData(
            success: false,
            error:
                linkResult['error'] as String? ??
                'Failed to create payment link',
            orderId: orderNumber,
          );
        }

        final expiresAtStr = linkResult['expiresAt'] as String?;
        return protocol.PaymentLinkData(
          success: true,
          token: linkResult['token'] as String?,
          paymentLink: linkResult['paymentLink'] as String?,
          expiresAt: expiresAtStr != null
              ? DateTime.tryParse(expiresAtStr)
              : null,
          razorpayOrderId: linkResult['razorpayOrderId'] as String?,
          amount: amountInPaise,
          orderId: orderNumber,
        );
      }
    } catch (e) {
      return protocol.PaymentLinkData(
        success: false,
        error: e.toString(),
      );
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
        return {
          'success': false,
          'message': 'This payment link has already been used.',
        };
      }

      final expiresAtStr = linkMap['expiresAt'] as String?;
      if (expiresAtStr != null) {
        final expiresAt = DateTime.tryParse(expiresAtStr)?.toUtc();
        if (expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt)) {
          return {
            'success': false,
            'message': 'This payment link has expired.',
          };
        }
      }

      final orderId = (linkMap['orderId'] as String?) ?? '';
      final parsedOrderId = tryParseUuid(orderId);
      if (parsedOrderId == null) {
        return {'success': false, 'message': 'Invalid order reference.'};
      }

      final orderRow = await protocol.CustomerOrderRow.db.findById(
        session,
        parsedOrderId,
      );
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
        'message':
            result['message'] as String? ??
            result['error'] as String? ??
            'Payment verification failed.',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Get the current payment session status for a pending order.
  Future<Map<String, dynamic>> getPaymentSessionStatus(
    Session session,
    String orderNumber,
  ) async {
    try {
      return await _paymentLinks.getPaymentSessionStatus(
        session,
        orderNumber,
      );
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Get or create a payment link for a pending order (lazy creation).
  Future<String> getOrCreatePaymentLink(
    Session session,
    String orderNumber,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _userGuard.ensureUser(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );

      final result = await _paymentLinks.getOrCreatePaymentLink(
        session,
        orderNumber: orderNumber,
      );

      return jsonEncode(result);
    } catch (e) {
      return jsonEncode({'success': false, 'error': e.toString()});
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
