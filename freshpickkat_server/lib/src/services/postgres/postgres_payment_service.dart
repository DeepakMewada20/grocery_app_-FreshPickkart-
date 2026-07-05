import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../analytics/redis_analytics_service.dart';
import '../config/env_service.dart';
import '../background/order_outbox_service.dart';
import '../payments/payment_gateway_service.dart';
import '../orders/snapshot_builder.dart';
import 'postgres_auto_refund_service.dart';
import 'postgres_payment_link_service.dart';
import 'postgres_support.dart';

class PostgresPaymentService {
  PostgresPaymentService({PaymentGatewayService? gateway})
    : _gateway = gateway ?? PaymentGatewayService();

  final PaymentGatewayService _gateway;
  final RedisAnalyticsService _analytics = RedisAnalyticsService.instance;

  Future<PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderNumber,
    double amount,
    String customerPhone,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentOrderResult(success: false, error: 'Order not found');
      }

      final resolvedOrderRow = orderRow!;

      if (resolvedOrderRow.paymentStatus == 'paid') {
        return PaymentOrderResult(
          success: false,
          error: 'Order is already paid',
        );
      }
      if (resolvedOrderRow.orderStatus == 'cancelled') {
        return PaymentOrderResult(
          success: false,
          error: 'Order is cancelled',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(resolvedOrderRow.id!),
      );
      if (paymentRow == null) {
        return PaymentOrderResult(
          success: false,
          error: 'Payment transaction not found',
        );
      }

      final amountInPaise = (amount * 100).round();
      final response = await _gateway.createOrder(
        receipt: orderNumber,
        amountInPaise: amountInPaise,
        customerPhone: customerPhone,
      );

      if (response['statusCode'] != 200) {
        return PaymentOrderResult(
          success: false,
          error: 'Failed to create payment order',
          details: response['body']?.toString(),
        );
      }

      final data = response['data'] as Map<String, dynamic>;
      final razorpayOrderId = data['id']?.toString();
      final now = DateTime.now().toUtc();

      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId,
          paymentStatus: 'pending',
          gatewayStatus: data['status']?.toString() ?? 'created',
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'pending',
          updatedAt: now,
        ),
      );

      return PaymentOrderResult(
        success: true,
        razorpayOrderId: razorpayOrderId,
        amount: data['amount'] is int ? data['amount'] as int : null,
        currency: data['currency']?.toString(),
      );
    } catch (error) {
      return PaymentOrderResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// Called by the mobile client after successful Razorpay checkout.
  /// Validates the HMAC signature and sets payment to VERIFYING state.
  /// Does NOT immediately confirm the order — that requires webhook or
  /// server-side verification via [completePaymentVerification].
  Future<PaymentVerifyResult> verifyPayment(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      // Quick pre-check for gateway order ID mismatch (no lock needed)
      if (paymentRow.gatewayOrderId != null &&
          paymentRow.gatewayOrderId!.isNotEmpty &&
          paymentRow.gatewayOrderId != razorpayOrderId) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Razorpay order mismatch',
        );
      }

      if (paymentRow.paymentStatus == 'verifying') {
        return PaymentVerifyResult(
          success: true,
          verified: false,
          message: 'Payment is being verified',
        );
      }

      // HMAC validation (stays outside lock)
      final enforceHmac = EnvService.get('ENFORCE_PAYMENT_HMAC') == 'true';
      final sig = razorpaySignature.trim();
      if (sig.isEmpty) {
        if (enforceHmac) {
          await markPaymentFailed(session, orderNumber);
          return PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
        session.log(
          'HMAC skipped for order $orderNumber (empty signature)',
          level: LogLevel.warning,
        );
      } else {
        final expected = _gateway.generateSignature(
          razorpayOrderId,
          razorpayPaymentId,
          _gateway.razorpayKeySecret,
        );
        if (expected != sig) {
          await markPaymentFailed(session, orderNumber);
          return PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
      }
      if (!enforceHmac && _gateway.isTestMode) {
        session.log(
          'HMAC validation skipped for order $orderNumber (test mode)',
          level: LogLevel.warning,
        );
      }

      final now = DateTime.now().toUtc();

      PaymentVerifyResult? result;
      await session.db.transaction((transaction) async {
        // 1. Lock BOTH rows to prevent race conditions
        await session.db.unsafeQuery(
          'SELECT "id" FROM "customer_order" WHERE "id" = @id FOR UPDATE',
          parameters: QueryParameters.named({
            'id': resolvedOrderRow.id!.toJson(),
          }),
          transaction: transaction,
        );
        await session.db.unsafeQuery(
          'SELECT "id" FROM "payment_transaction" WHERE "orderId" = @orderId FOR UPDATE',
          parameters: QueryParameters.named({
            'orderId': resolvedOrderRow.id!.toJson(),
          }),
          transaction: transaction,
        );

        // 2. Re-read both rows under lock
        final freshOrder = await CustomerOrderRow.db.findById(
          session,
          resolvedOrderRow.id!,
          transaction: transaction,
        );
        final freshPayment = await PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(resolvedOrderRow.id!),
          transaction: transaction,
        );
        if (freshOrder == null || freshPayment == null) {
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order or payment not found',
          );
          return;
        }

        // 3. Re-validate status under lock
        // Reject closed orders
        if (freshOrder.orderStatus == 'cancelled' ||
            freshOrder.orderStatus == 'payment_expired') {
          if (razorpayPaymentId.isNotEmpty) {
            await _createAutoRefundJob(
              session,
              freshOrder,
              freshPayment,
              razorpayPaymentId,
              razorpayOrderId,
            );
          }
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order no longer accepts payments.',
          );
          return;
        }

        // Already paid — check for duplicate vs retry
        if (freshPayment.paymentStatus == 'paid' &&
            freshOrder.paymentStatus == 'paid') {
          if (freshPayment.gatewayPaymentId != null &&
              freshPayment.gatewayPaymentId!.isNotEmpty &&
              freshPayment.gatewayPaymentId != razorpayPaymentId) {
            await _createAutoRefundJob(
              session,
              freshOrder,
              freshPayment,
              razorpayPaymentId,
              razorpayOrderId,
            );
          }
          result = PaymentVerifyResult(
            success: true,
            verified: true,
            message: 'Payment already verified',
          );
          return;
        }

        // Reject closed/payment-expired or already-paid orders
        if (freshOrder.orderStatus == 'cancelled' ||
            freshOrder.orderStatus == 'payment_expired' ||
            freshOrder.paymentStatus == 'paid' ||
            freshPayment.paymentStatus == 'paid') {
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order is closed or already paid',
          );
          return;
        }

        // 4. Update using FRESH rows
        await PaymentTransactionRow.db.updateRow(
          session,
          freshPayment.copyWith(
            gatewayOrderId: razorpayOrderId,
            gatewayPaymentId: razorpayPaymentId,
            paymentStatus: 'paid',
            gatewayStatus: 'captured',
            paidAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );

        final paymentSnapshotJson = SnapshotBuilder.instance
            .buildPaymentSnapshot(
              gatewayName: 'razorpay',
              gatewayOrderId: razorpayOrderId,
              gatewayPaymentId: razorpayPaymentId,
              paymentStatus: 'paid',
              amount: freshOrder.finalAmount,
              paidAt: now,
            );

        await CustomerOrderRow.db.updateRow(
          session,
          freshOrder.copyWith(
            paymentStatus: 'paid',
            orderStatus: 'confirmed',
            confirmedAt: now,
            paymentSnapshot: paymentSnapshotJson,
            linkStatus: 'DISABLED',
            updatedAt: now,
          ),
          transaction: transaction,
        );

        await _finalizeSuccessfulPaymentSideEffects(
          session,
          order: freshOrder,
          transaction: transaction,
        );

        // Disable any active payment link
        await PostgresPaymentLinkService().disablePaymentLink(
          session,
          freshOrder.orderNumber,
          transaction: transaction,
        );
      });

      if (result != null) {
        if (result!.verified && result!.success) {
          await OrderOutboxService.instance.enqueueOrderPaid(
            session: session,
            orderId: resolvedOrderRow.orderNumber,
            userId: resolvedOrderRow.userId.toString(),
            status: 'confirmed',
            amount: resolvedOrderRow.finalAmount,
            itemCount: resolvedOrderRow.itemCount,
          );
        }
        return result!;
      }

      await _processPaidOrderAnalytics(
        session,
        orderNumber: resolvedOrderRow.orderNumber,
      );

      await OrderOutboxService.instance.enqueueOrderPaid(
        session: session,
        orderId: resolvedOrderRow.orderNumber,
        userId: resolvedOrderRow.userId.toString(),
        status: 'confirmed',
        amount: resolvedOrderRow.finalAmount,
        itemCount: resolvedOrderRow.itemCount,
      );

      session.log(
        'Payment completed for order $orderNumber, '
        'razorpayPaymentId: $razorpayPaymentId',
        level: LogLevel.info,
      );

      return PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (error) {
      return PaymentVerifyResult(
        success: false,
        verified: false,
        error: error.toString(),
      );
    }
  }

  /// Called by the Razorpay webhook or reconciliation cron to
  /// definitively mark a payment as successful.
  /// This is the single source of truth for order confirmation.
  /// Verify payment from the shareable payment link page.
  /// This is called by the browser-based Razorpay Checkout handler.
  Future<Map<String, dynamic>> verifyPaymentFromLink(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    String? paymentLinkToken,
  }) async {
    // First verify via HMAC signature (reuse existing logic)
    final verifyResult = await verifyPayment(
      session,
      orderNumber: orderNumber,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );

    if (!verifyResult.success || !verifyResult.verified) {
      return {
        'success': false,
        'verified': false,
        'message':
            verifyResult.message ?? verifyResult.error ?? 'Verification failed',
      };
    }

    // Store payer info
    if (paidByName != null || paidByPhone != null || paidByEmail != null) {
      try {
        final orderRow = await CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        if (orderRow != null) {
          final now = DateTime.now().toUtc();
          await CustomerOrderRow.db.updateRow(
            session,
            orderRow.copyWith(
              paidByName: paidByName ?? orderRow.paidByName,
              paidByPhone: paidByPhone ?? orderRow.paidByPhone,
              paidByEmail: paidByEmail ?? orderRow.paidByEmail,
              updatedAt: now,
            ),
          );
        }
      } catch (_) {}
    }

    // Mark payment link as used
    if (paymentLinkToken != null && paymentLinkToken.isNotEmpty) {
      try {
        await session.db.unsafeQuery(
          '''
          UPDATE "payment_link"
          SET "isUsed" = true,
              "usedAt" = @now,
              "paidByName" = @paidByName,
              "paidByPhone" = @paidByPhone,
              "paidByEmail" = @paidByEmail,
              "updatedAt" = @now
          WHERE "token" = @token
          ''',
          parameters: QueryParameters.named({
            'token': paymentLinkToken,
            'now': DateTime.now().toUtc().toIso8601String(),
            'paidByName': paidByName,
            'paidByPhone': paidByPhone,
            'paidByEmail': paidByEmail,
          }),
        );
      } catch (_) {}
    }

    return {
      'success': true,
      'verified': true,
      'message': 'Payment verified successfully.',
    };
  }

  Future<PaymentVerifyResult> completePaymentVerification(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    String razorpaySignature = '',
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      final now = DateTime.now().toUtc();

      PaymentVerifyResult? result;
      await session.db.transaction((transaction) async {
        // 1. Lock BOTH rows to prevent race conditions
        await session.db.unsafeQuery(
          'SELECT "id" FROM "customer_order" WHERE "id" = @id FOR UPDATE',
          parameters: QueryParameters.named({
            'id': resolvedOrderRow.id!.toJson(),
          }),
          transaction: transaction,
        );
        await session.db.unsafeQuery(
          'SELECT "id" FROM "payment_transaction" WHERE "orderId" = @orderId FOR UPDATE',
          parameters: QueryParameters.named({
            'orderId': resolvedOrderRow.id!.toJson(),
          }),
          transaction: transaction,
        );

        // 2. Re-read both rows under lock
        final freshOrder = await CustomerOrderRow.db.findById(
          session,
          resolvedOrderRow.id!,
          transaction: transaction,
        );
        final freshPayment = await PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(resolvedOrderRow.id!),
          transaction: transaction,
        );
        if (freshOrder == null || freshPayment == null) {
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order or payment not found',
          );
          return;
        }

        // 3. Re-validate status under lock
        // Reject closed orders (cancelled / payment_expired) — Fix 2
        if (freshOrder.orderStatus == 'cancelled' ||
            freshOrder.orderStatus == 'payment_expired') {
          if (razorpayPaymentId.isNotEmpty) {
            await _createAutoRefundJob(
              session,
              freshOrder,
              freshPayment,
              razorpayPaymentId,
              razorpayOrderId,
            );
          }
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order no longer accepts payments.',
          );
          return;
        }

        // Already paid — check for duplicate vs retry
        if (freshPayment.paymentStatus == 'paid' &&
            freshOrder.paymentStatus == 'paid') {
          if (razorpayPaymentId.isNotEmpty &&
              freshPayment.gatewayPaymentId != null &&
              freshPayment.gatewayPaymentId!.isNotEmpty &&
              freshPayment.gatewayPaymentId != razorpayPaymentId) {
            await _createAutoRefundJob(
              session,
              freshOrder,
              freshPayment,
              razorpayPaymentId,
              razorpayOrderId,
            );
          }
          result = PaymentVerifyResult(
            success: true,
            verified: true,
            message: 'Payment already verified',
          );
          return;
        }

        // Reject closed/payment-expired or already-paid orders
        if (freshOrder.orderStatus == 'cancelled' ||
            freshOrder.orderStatus == 'payment_expired' ||
            freshOrder.paymentStatus == 'paid' ||
            freshPayment.paymentStatus == 'paid') {
          result = PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Order is closed or already paid',
          );
          return;
        }

        // 4. Update using FRESH rows (not stale pre-lock objects)
        await PaymentTransactionRow.db.updateRow(
          session,
          freshPayment.copyWith(
            gatewayOrderId: razorpayOrderId.isNotEmpty
                ? razorpayOrderId
                : freshPayment.gatewayOrderId,
            gatewayPaymentId: razorpayPaymentId.isNotEmpty
                ? razorpayPaymentId
                : freshPayment.gatewayPaymentId,
            paymentStatus: 'paid',
            gatewayStatus: 'captured',
            paidAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );

        final paymentSnapshotJson = SnapshotBuilder.instance
            .buildPaymentSnapshot(
              gatewayName: 'razorpay',
              gatewayOrderId: razorpayOrderId.isNotEmpty
                  ? razorpayOrderId
                  : freshPayment.gatewayOrderId,
              gatewayPaymentId: razorpayPaymentId.isNotEmpty
                  ? razorpayPaymentId
                  : freshPayment.gatewayPaymentId,
              paymentStatus: 'paid',
              amount: freshOrder.finalAmount,
              paidAt: now,
            );

        await CustomerOrderRow.db.updateRow(
          session,
          freshOrder.copyWith(
            paymentStatus: 'paid',
            orderStatus: 'confirmed',
            confirmedAt: now,
            paymentSnapshot: paymentSnapshotJson,
            linkStatus: 'DISABLED',
            updatedAt: now,
          ),
          transaction: transaction,
        );

        await _finalizeSuccessfulPaymentSideEffects(
          session,
          order: freshOrder,
          transaction: transaction,
        );

        // Disable any active payment link
        await PostgresPaymentLinkService().disablePaymentLink(
          session,
          freshOrder.orderNumber,
          transaction: transaction,
        );
      });

      if (result != null) return result!;

      await _processPaidOrderAnalytics(
        session,
        orderNumber: resolvedOrderRow.orderNumber,
      );

      await OrderOutboxService.instance.enqueueOrderPaid(
        session: session,
        orderId: resolvedOrderRow.orderNumber,
        userId: resolvedOrderRow.userId.toString(),
        status: 'confirmed',
        amount: resolvedOrderRow.finalAmount,
        itemCount: resolvedOrderRow.itemCount,
      );

      session.log(
        'Payment completed for order $orderNumber, '
        'razorpayPaymentId: $razorpayPaymentId',
        level: LogLevel.info,
      );

      return PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (error) {
      return PaymentVerifyResult(
        success: false,
        verified: false,
        error: error.toString(),
      );
    }
  }

  /// Mark payment as failed or cancelled.
  /// [failureType] can be 'failed' (actual payment failure) or 'user_cancelled'.
  Future<PaymentActionResult> markPaymentFailed(
    Session session,
    String orderNumber, {
    String failureType = 'failed',
    String? failureReason,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentActionResult(success: false, error: 'Order not found');
      }
      final resolvedOrderRow = orderRow!;

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(resolvedOrderRow.id!),
      );
      final now = DateTime.now().toUtc();

      final isCancelled = failureType == 'user_cancelled';

      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: isCancelled ? 'cancelled' : 'failed',
          orderStatus: 'payment_failed',
          cancelledAt: isCancelled ? now : resolvedOrderRow.cancelledAt,
          cancellationReason: isCancelled
              ? (failureReason ?? 'Payment cancelled by user')
              : (failureReason ?? 'Payment failed'),
          updatedAt: now,
        ),
      );
      if (paymentRow != null) {
        await PaymentTransactionRow.db.updateRow(
          session,
          paymentRow.copyWith(
            paymentStatus: isCancelled ? 'cancelled' : 'failed',
            gatewayStatus: isCancelled ? 'cancelled' : 'failed',
            failureReason: failureReason,
            updatedAt: now,
          ),
        );
      }

      session.log(
        'Payment $failureType for order $orderNumber'
        '${failureReason != null ? ': $failureReason' : ''}',
        level: LogLevel.info,
      );

      return PaymentActionResult(success: true);
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  /// Fetch Razorpay payment status and provide user-friendly result.
  /// Handles Scenario 3: money debited but never reached Razorpay.
  Future<PaymentActionResult> getPaymentStatusWithMessage(
    Session session,
    String orderNumber,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentActionResult(success: false, error: 'Order not found');
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );

      if (paymentRow == null) {
        return PaymentActionResult(
          success: true,
          status: 'unknown',
          message: 'Payment record not found',
        );
      }

      final gatewayPaymentId = cleanNullableString(paymentRow.gatewayPaymentId);
      if (gatewayPaymentId == null) {
        return PaymentActionResult(
          success: true,
          status: paymentRow.paymentStatus,
          message: 'Payment has not been processed yet',
        );
      }

      final statusResult = await _gateway.fetchPaymentStatus(gatewayPaymentId);
      final data = statusResult['data'];
      final gatewayStatus = data is Map<String, dynamic>
          ? data['status']?.toString().toLowerCase().trim()
          : null;

      if (gatewayStatus == 'captured' || gatewayStatus == 'authorized') {
        return PaymentActionResult(
          success: true,
          status: 'paid',
          message: 'Payment successful',
          amount: data?['amount'] is int ? data['amount'] as int : null,
          paymentId: gatewayPaymentId,
        );
      }

      if (gatewayStatus == 'failed') {
        return PaymentActionResult(
          success: true,
          status: 'failed',
          message: 'Payment failed at gateway',
          paymentId: gatewayPaymentId,
        );
      }

      if (gatewayStatus == null || gatewayStatus == 'created') {
        return PaymentActionResult(
          success: true,
          status: 'pending',
          message:
              'Amount was debited from your account but payment is not '
              'confirmed yet. Banks usually reverse such transactions '
              'automatically. Please wait and check again later.',
          paymentId: gatewayPaymentId,
        );
      }

      return PaymentActionResult(
        success: true,
        status: paymentRow.paymentStatus,
        message: 'Payment status: ${paymentRow.paymentStatus}',
        paymentId: gatewayPaymentId,
      );
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  Future<PaymentActionResult> recoverPendingPayments(
    Session session,
    String userReference, {
    int limit = 20,
  }) async {
    try {
      final appUser = await _resolveUser(session, userReference);
      if (appUser?.id == null) {
        return PaymentActionResult(
          success: true,
          status: 'checked',
          message: 'No pending payments',
        );
      }

      final rows = await PaymentTransactionRow.db.find(
        session,
        where: (t) =>
            t.userId.equals(appUser!.id!) &
            (t.paymentStatus.equals('pending') |
                t.paymentStatus.equals('verifying')),
        limit: clampPageLimit(limit, defaultLimit: 20, maxLimit: 50),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      var recovered = 0;
      var failed = 0;

      for (final row in rows) {
        final paymentId = cleanNullableString(row.gatewayPaymentId);
        if (paymentId == null) continue;

        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'];
        final status = data is Map<String, dynamic>
            ? data['status']?.toString().toLowerCase().trim()
            : null;

        final orderRow = await CustomerOrderRow.db.findById(
          session,
          row.orderId,
        );
        if (orderRow == null) continue;

        if (status == 'captured' || status == 'authorized') {
          final verifyResult = await completePaymentVerification(
            session,
            orderNumber: orderRow.orderNumber,
            razorpayOrderId: row.gatewayOrderId ?? '',
            razorpayPaymentId: paymentId,
          );
          if (verifyResult.success && verifyResult.verified) {
            recovered++;
          }
        } else if (status == 'failed' || status == 'refunded') {
          await markPaymentFailed(session, orderRow.orderNumber);
          failed++;
        }
      }

      return PaymentActionResult(
        success: true,
        status: recovered > 0 ? 'recovered' : 'checked',
        message: 'Recovered $recovered payment(s), failed $failed payment(s).',
      );
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  /// Cancel orders with PENDING payment that have exceeded the timeout.
  /// Returns the number of cancelled orders.
  Future<int> autoCancelPendingPayments(
    Session session, {
    Duration timeout = const Duration(minutes: 10),
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final cutoff = now.subtract(timeout);
      final ageCutoff = now.subtract(const Duration(days: 2));
      final result = await session.db.unsafeQuery(
        '''
        SELECT id FROM customer_order
        WHERE "paymentStatus" = @paymentStatus
          AND "orderStatus" = @orderStatus
          AND "createdAt" < @cutoff
          AND "createdAt" >= @ageCutoff
        LIMIT 200
        ''',
        parameters: QueryParameters.named({
          'paymentStatus': 'pending',
          'orderStatus': 'placed',
          'cutoff': cutoff,
          'ageCutoff': ageCutoff,
        }),
      );

      var cancelled = 0;
      for (final row in result) {
        final map = row.toColumnMap();
        final orderId = map['id'] as String?;
        if (orderId == null) continue;

        final parsedId = tryParseUuid(orderId);
        if (parsedId == null) continue;

        final order = await CustomerOrderRow.db.findById(session, parsedId);
        if (order == null) continue;

        final paymentRow = await PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order.id!),
        );
        final now = DateTime.now().toUtc();

        await CustomerOrderRow.db.updateRow(
          session,
          order.copyWith(
            paymentStatus: 'cancelled',
            orderStatus: 'cancelled',
            cancelledAt: now,
            cancellationReason: 'Auto-cancelled: payment timeout exceeded',
            updatedAt: now,
          ),
        );
        if (paymentRow != null) {
          await PaymentTransactionRow.db.updateRow(
            session,
            paymentRow.copyWith(
              paymentStatus: 'cancelled',
              gatewayStatus: 'cancelled',
              updatedAt: now,
            ),
          );
        }

        cancelled++;
      }

      if (cancelled > 0) {
        session.log(
          'Auto-cancelled $cancelled order(s) with pending payment',
          level: LogLevel.info,
        );
      }

      return cancelled;
    } catch (error) {
      session.log(
        'Auto-cancel failed: $error',
        level: LogLevel.error,
      );
      return 0;
    }
  }

  /// Reconcile all pending and verifying payments against Razorpay.
  /// Used by the periodic cron job.
  Future<Map<String, int>> reconcileAllPendingPayments(
    Session session, {
    int limit = 100,
  }) async {
    var recovered = 0;
    var failed = 0;
    var skipped = 0;

    try {
      final now = DateTime.now().toUtc();
      final cutoff = now.subtract(const Duration(hours: 2));
      final ageCutoff = now.subtract(const Duration(hours: 24));

      final rows = await PaymentTransactionRow.db.find(
        session,
        where: (t) =>
            ((t.paymentStatus.equals('pending') |
                    t.paymentStatus.equals('verifying')) &
                (t.createdAt >= ageCutoff)) |
            (t.paymentStatus.equals('failed') &
                t.gatewayPaymentId.notEquals(null) &
                (t.updatedAt >= cutoff)),
        limit: limit,
        orderBy: (t) => t.createdAt,
      );

      for (final row in rows) {
        final paymentId = cleanNullableString(row.gatewayPaymentId);
        if (paymentId == null) {
          skipped++;
          continue;
        }

        final orderRow = await CustomerOrderRow.db.findById(
          session,
          row.orderId,
        );
        if (orderRow == null) {
          skipped++;
          continue;
        }

        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'];
        final status = data is Map<String, dynamic>
            ? data['status']?.toString().toLowerCase().trim()
            : null;

        if (status == 'captured' || status == 'authorized') {
          final result = await completePaymentVerification(
            session,
            orderNumber: orderRow.orderNumber,
            razorpayOrderId: row.gatewayOrderId ?? '',
            razorpayPaymentId: paymentId,
          );
          if (result.success && result.verified) {
            recovered++;
          } else {
            skipped++;
          }
        } else if (status == 'failed' || status == 'refunded') {
          await markPaymentFailed(session, orderRow.orderNumber);
          failed++;
        } else {
          skipped++;
        }
      }

      session.log(
        'Payment reconciliation: $recovered recovered, $failed failed, '
        '$skipped skipped',
        level: LogLevel.info,
      );
    } catch (error) {
      session.log(
        'Payment reconciliation failed: $error',
        level: LogLevel.error,
      );
    }

    return {
      'recovered': recovered,
      'failed': failed,
      'skipped': skipped,
    };
  }

  /// Read-only: Returns aggregated payment detail for admin monitoring.
  Future<PaymentOrderDetailHydrated> getPaymentOrderDetailHydrated(
    Session session,
    String orderNumber,
  ) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (orderRow == null) {
      return PaymentOrderDetailHydrated(error: 'Order not found');
    }

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );

    PaymentTransaction? paymentTransaction;
    if (paymentRow != null) {
      paymentTransaction = PaymentTransaction(
        gatewayOrderId: cleanNullableString(paymentRow.gatewayOrderId),
        gatewayPaymentId: cleanNullableString(paymentRow.gatewayPaymentId),
        amount: paymentRow.amount.toInt(),
        paymentStatus: paymentRow.paymentStatus,
        gatewayStatus: paymentRow.gatewayStatus,
        failureReason: paymentRow.failureReason,
      );
    }

    final refundRows = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 5,
    );

    List<RefundRecord>? refundRecords;
    if (refundRows.isNotEmpty) {
      refundRecords = refundRows
          .map(
            (r) => RefundRecord(
              refundId: r.id?.toString() ?? '',
              orderId: r.orderId.toString(),
              paymentId: r.paymentTransactionId.toString(),
              userId: r.userId.toString(),
              amount: r.amount,
              status: r.refundStatus,
              gatewayRefundId: r.gatewayRefundId,
              source: r.source,
              reason: r.reason,
              complaintId: r.complaintId?.toString(),
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          )
          .toList();
    }

    RazorpayPaymentStatus? razorpayLiveStatus;
    final paymentId = cleanNullableString(paymentRow?.gatewayPaymentId);
    if (paymentId != null) {
      try {
        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'] as Map<String, dynamic>?;
        if (data != null) {
          razorpayLiveStatus = RazorpayPaymentStatus(
            id: data['id'] as String?,
            status: data['status'] as String?,
            amount: data['amount'] as int?,
            currency: data['currency'] as String?,
            orderId: data['order_id'] as String?,
            method: data['method'] as String?,
            captured: data['captured'] as bool?,
            refundStatus: data['refund_status'] as String?,
            amountRefunded: data['amount_refunded'] as int?,
            fee: data['fee'] as int?,
            tax: data['tax'] as int?,
            bank: data['bank'] as String?,
            wallet: data['wallet'] as String?,
            vpa: data['vpa'] as String?,
            email: data['email'] as String?,
            contact: data['contact'] as String?,
            cardId: data['card_id'] as String?,
            acquirerData: data['acquirer_data']?.toString(),
            description: data['description'] as String?,
            notes: data['notes']?.toString(),
            errorCode: data['error_code'] as String?,
            errorDescription: data['error_description'] as String?,
            createdAt: data['created_at'] as int?,
          );
        }
      } catch (_) {}
    }

    RazorpayRefundData? razorpayRefundData;
    final gatewayRefundId = refundRows.isNotEmpty
        ? cleanNullableString(refundRows.first.gatewayRefundId)
        : null;
    if (gatewayRefundId != null && paymentId != null) {
      try {
        final gatewayRefund = await _gateway.fetchRefund(
          paymentId: paymentId,
          refundId: gatewayRefundId,
        );
        final data = gatewayRefund['data'] as Map<String, dynamic>?;
        if (data != null) {
          razorpayRefundData = RazorpayRefundData(
            id: data['id'] as String? ?? '',
            paymentId: data['payment_id'] as String? ?? '',
            amount: data['amount'] as int? ?? 0,
            status: data['status'] as String? ?? '',
            speedProcessed: data['speed_processed'] as String?,
            speedRequested: data['speed_requested'] as String?,
            receipt: data['receipt'] as String?,
            acquirerData: data['acquirer_data']?.toString(),
            notes: data['notes']?.toString(),
            errorCode: data['error_code'] as String?,
            errorDescription: data['error_description'] as String?,
            createdAt: data['created_at'] as int?,
          );
        }
      } catch (_) {}
    }

    return PaymentOrderDetailHydrated(
      paymentTransaction: paymentTransaction,
      refundRecords: refundRecords,
      razorpayLiveStatus: razorpayLiveStatus,
      razorpayRefundData: razorpayRefundData,
    );
  }

  Future<Map<String, dynamic>> getPaymentDetail(
    Session session,
    String orderNumber,
  ) async {
    final result = <String, dynamic>{};

    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (orderRow == null) {
      return {'error': 'Order not found'};
    }
    result['order'] = orderRow.toJson();

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );
    if (paymentRow != null) {
      result['paymentTransaction'] = paymentRow.toJson();
    }

    final refundRow = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 1,
    );
    if (refundRow.isNotEmpty) {
      result['refundRecord'] = refundRow.first.toJson();
    }

    final paymentId = cleanNullableString(paymentRow?.gatewayPaymentId);
    if (paymentId != null) {
      try {
        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        result['razorpayLiveStatus'] = statusResult['data'];
      } catch (_) {}
    }

    return result;
  }

  /// Read-only: Search orders by order number, phone, or customer name.
  Future<OrderPage> searchOrders(
    Session session, {
    String? query,
    String? status,
    String? paymentStatus,
    String? paymentMode,
    String? paymentCollectionMode,
    String? codFilter,
    int limit = 20,
    String? pageToken,
  }) async {
    final conditions = <String>['1=1'];
    final params = <String, dynamic>{};

    final q = query?.trim();
    if (q != null && q.isNotEmpty) {
      conditions.add(
        '(co."orderNumber" ILIKE @query '
        'OR co."id" IN ('
        'SELECT pt."orderId" FROM "payment_transaction" pt '
        'WHERE pt."gatewayPaymentId" ILIKE @query'
        ') '
        'OR co."userId" IN ('
        'SELECT au."id" FROM "app_user" au '
        'WHERE au."phoneNumber" ILIKE @query OR au."email" ILIKE @query'
        '))',
      );
      params['query'] = '%$q%';
    }

    if (status != null && status.trim().isNotEmpty) {
      conditions.add('co."orderStatus" = @status');
      params['status'] = status.trim();
    }

    if (paymentStatus != null && paymentStatus.trim().isNotEmpty) {
      conditions.add('co."paymentStatus" = @paymentStatus');
      params['paymentStatus'] = paymentStatus.trim();
    }

    if (paymentMode != null && paymentMode.trim().isNotEmpty) {
      conditions.add('co."paymentMode" = @paymentMode');
      params['paymentMode'] = paymentMode.trim();
    }

    if (paymentCollectionMode != null &&
        paymentCollectionMode.trim().isNotEmpty) {
      conditions.add('co."paymentCollectionMode" = @paymentCollectionMode');
      params['paymentCollectionMode'] = paymentCollectionMode.trim();
    }

    if (codFilter != null && codFilter.trim().isNotEmpty) {
      switch (codFilter.trim()) {
        case 'cod_pending':
          conditions.add(
            'co."paymentMode" = \'cod\' AND co."paymentStatus" = \'pending\'',
          );
          break;
        case 'cod_paid':
          conditions.add(
            'co."paymentMode" = \'cod\' AND co."paymentStatus" = \'paid\'',
          );
          break;
        case 'online_paid':
          conditions.add(
            'co."paymentMode" = \'standard\' AND co."paymentStatus" = \'paid\'',
          );
          break;
        case 'link_pending':
          conditions.add(
            'co."paymentMode" = \'shareable_link\' AND co."paymentStatus" = \'pending\'',
          );
          break;
      }
    }

    final whereClause = conditions.join(' AND ');
    final limitVal = limit.clamp(1, 100);
    final offsetVal = _decodePageToken(pageToken);

    final countResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM customer_order co WHERE $whereClause',
      parameters: QueryParameters.named({...params}),
    );
    final totalCount = countResult.isNotEmpty
        ? asInt(countResult.first.toColumnMap()['cnt'])
        : 0;

    final rows = await session.db.unsafeQuery(
      '''
      SELECT co.*
      FROM customer_order co
      WHERE $whereClause
      ORDER BY co."orderedAt" DESC
      LIMIT @limitVal OFFSET @offsetVal
      ''',
      parameters: QueryParameters.named({
        ...params,
        'limitVal': limitVal + 1,
        'offsetVal': offsetVal,
      }),
    );

    final orderRows = rows
        .map((r) => CustomerOrderRow.fromJson(r.toColumnMap()))
        .take(limitVal)
        .toList();

    String? nextPageToken;
    if (rows.length > limitVal) {
      nextPageToken = _encodePageToken(offsetVal + limitVal);
    }

    final orders = <Order>[];
    for (final row in orderRows) {
      final addressRow = await OrderAddressRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(row.id!),
      );
      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(row.id!),
      );
      final userRow = await _resolveUser(session, row.userId.toString());
      orders.add(
        Order(
          orderId: row.orderNumber,
          userId: row.userId.toString(),
          userName: userRow?.name,
          userPhone: userRow?.phoneNumber ?? '',
          items: const [],
          itemCount: row.itemCount,
          totalAmount: row.totalAmount,
          discountAmount: row.discountAmount,
          mrpTotal: row.mrpTotal,
          productDiscountAmount: row.productDiscountAmount,
          comboDiscountAmount: row.comboDiscountAmount,
          bogoDiscountAmount: row.bogoDiscountAmount,
          categoryOfferDiscountAmount: row.categoryOfferDiscountAmount,
          deliveryFee: row.deliveryFee,
          originalDeliveryFee: row.originalDeliveryFee,
          deliveryDiscountAmount: row.deliveryDiscountAmount,
          freeDeliveryApplied: row.freeDeliveryApplied,
          freshPointsUsed: row.freshPointsUsed,
          freshPointsValue: row.freshPointsValue,
          actualPaymentAmount: row.actualPaymentAmount,
          finalAmount: row.finalAmount,
          status: row.orderStatus,
          paymentStatus: row.paymentStatus,
          refundStatus: row.refundStatus,
          razorpayOrderId: cleanNullableString(paymentRow?.gatewayOrderId),
          razorpayPaymentId: cleanNullableString(paymentRow?.gatewayPaymentId),
          deliveryAddress: Address(
            street: addressRow?.streetLine1 ?? '',
            city: addressRow?.city ?? '',
            state: addressRow?.state ?? '',
            zipCode: addressRow?.postalCode ?? '',
            country: addressRow?.country ?? '',
            latitude: addressRow?.latitude,
            longitude: addressRow?.longitude,
          ),
          orderedAt: row.orderedAt,
          confirmedAt: row.confirmedAt,
          outForDeliveryAt: row.outForDeliveryAt,
          deliveredAt: row.deliveredAt,
          cancelledAt: row.cancelledAt,
          orderType: row.orderType,
          sourceOrderNumber: row.sourceOrderNumber,
          complaintId: row.complaintId,
        ),
      );
    }

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  /// Read-only: Returns refund details for an order.
  Future<Map<String, dynamic>> getRefundDetail(
    Session session,
    String orderNumber,
  ) async {
    final result = <String, dynamic>{};

    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (orderRow == null) {
      return {'error': 'Order not found'};
    }

    final refunds = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 5,
    );

    if (refunds.isEmpty) {
      return result;
    }

    final refundData = refunds.map((r) => r.toJson()).toList();
    result['refunds'] = refundData;

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );
    final gatewayRefundId = cleanNullableString(refunds.first.gatewayRefundId);
    final paymentId = cleanNullableString(paymentRow?.gatewayPaymentId);

    if (gatewayRefundId != null && paymentId != null) {
      try {
        final gatewayRefund = await _gateway.fetchRefund(
          paymentId: paymentId,
          refundId: gatewayRefundId,
        );
        result['razorpayRefundData'] = gatewayRefund['data'];
      } catch (_) {}
    }

    return result;
  }

  int _decodePageToken(String? token) {
    if (token == null || token.isEmpty) return 0;
    final decoded = int.tryParse(token);
    return decoded ?? 0;
  }

  String _encodePageToken(int offset) {
    return offset.toString();
  }

  Future<AppUserRow?> _resolveUser(
    Session session,
    String userReference,
  ) async {
    final parsedId = tryParseUuid(userReference);
    if (parsedId != null) {
      final byId = await AppUserRow.db.findById(session, parsedId);
      if (byId != null) return byId;
    }

    final trimmed = userReference.trim();
    if (trimmed.isEmpty) return null;
    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(trimmed),
    );
  }

  Future<void> _finalizeSuccessfulPaymentSideEffects(
    Session session, {
    required CustomerOrderRow order,
    Transaction? transaction,
  }) async {
    await UserCartItemRow.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(order.userId),
      transaction: transaction,
    );

    await _deductStockForOrderItems(
      session,
      order.id!,
      transaction: transaction,
    );

    if (order.couponId != null) {
      final couponRow = await CouponRow.db.findById(
        session,
        order.couponId!,
        transaction: transaction,
      );
      if (couponRow != null) {
        await CouponRow.db.updateRow(
          session,
          couponRow.copyWith(
            usedCount: couponRow.usedCount + 1,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }
    }
  }

  Future<void> _processPaidOrderAnalytics(
    Session session, {
    required String orderNumber,
  }) async {
    try {
      await _analytics.processPaidOrder(session, orderNumber);
    } catch (error, stackTrace) {
      session.log(
        'Product analytics processing failed for order $orderNumber: $error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _deductStockForOrderItems(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) async {
    try {
      final orderItems = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderId),
      );

      const unitConversions = <String, double>{
        'gm': 1.0,
        'kg': 1000.0,
        'litre': 1000.0,
        'ml': 1.0,
        'pc': 1.0,
        'pack': 1.0,
      };

      // D3: Pre-validate SMGM reward stock before deduction
      for (final item in orderItems.where(
        (i) => i.rewardSource == 'SHOP_MORE_GET_MORE',
      )) {
        final rp = await ProductRow.db.findById(
          session,
          item.productId,
          transaction: transaction,
        );
        if (rp != null && rp.stock != null && rp.stock! < (item.quantity ?? 1)) {
          session.log(
            'SMGM reward stock insufficient at payment: '
            'product="${rp.name}" stock=${rp.stock} '
            'required=${item.quantity} orderId=$orderId '
            'rewardOfferId=${item.rewardOfferId}',
            level: LogLevel.error,
          );
        }
      }

      for (final item in orderItems) {
        final product = await ProductRow.db.findById(
          session,
          item.productId,
          transaction: transaction,
        );
        if (product == null || product.stock == null) continue;

        double deduction = 0;
        if (item.productVariantId != null) {
          final variant = await ProductVariantRow.db.findById(
            session,
            item.productVariantId!,
            transaction: transaction,
          );
          if (variant != null) {
            final vUnit = variant.quantityUnit.toLowerCase();
            final pUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
                .toLowerCase();
            final inGrams =
                variant.quantityValue * (unitConversions[vUnit] ?? 1.0);
            final inBase = inGrams / (unitConversions[pUnit] ?? 1.0);
            deduction = inBase * item.quantity;
          } else {
            deduction = item.quantity.toDouble();
          }
        } else {
          deduction = item.quantity.toDouble();
        }

        final newStock = product.stock! - deduction;
        bool shouldDisable = false;

        final bUnit = (product.baseUnit ?? 'unit').toLowerCase();
        final sUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
            .toLowerCase();
        final minGrams =
            (product.baseQuantity ?? 0.0) * (unitConversions[bUnit] ?? 1.0);
        final minRequiredInStockUnit =
            minGrams / (unitConversions[sUnit] ?? 1.0);

        if (newStock <= 0 || newStock < minRequiredInStockUnit) {
          shouldDisable = true;
        }

        await ProductRow.db.updateRow(
          session,
          product.copyWith(
            stock: newStock < 0 ? 0 : newStock,
            status: shouldDisable ? 'inactive' : product.status,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }
    } catch (e) {
      session.log(
        'Background stock deduction failed: $e',
        level: LogLevel.error,
      );
    }
  }

  Future<void> _createAutoRefundJob(
    Session session,
    CustomerOrderRow order,
    PaymentTransactionRow payment,
    String incomingPaymentId,
    String incomingOrderId,
  ) async {
    try {
      final job = AutoRefundJobRow(
        orderId: order.id!,
        orderNumber: order.orderNumber,
        customerId: order.userId,
        gatewayPaymentId: incomingPaymentId,
        paymentTransactionId: payment.id!,
        gatewayOrderId: incomingOrderId.isNotEmpty
            ? incomingOrderId
            : payment.gatewayOrderId,
        amount: order.finalAmount,
        currency: 'INR',
      );

      await PostgresAutoRefundService().createJob(session, job: job);

      session.log(
        'Duplicate payment detected: order=${order.orderNumber}, '
        'stored=${payment.gatewayPaymentId}, incoming=$incomingPaymentId. '
        'Auto-refund job created.',
        level: LogLevel.warning,
      );
    } catch (e) {
      session.log(
        'Failed to create auto-refund job for duplicate payment: $e',
        level: LogLevel.error,
      );
    }
  }

  /// Expire stale payment sessions where paymentLinkExpiresAt has passed.
  /// Returns the number of orders expired.
  Future<int> expireStaleSessions(Session session) async {
    final now = DateTime.now().toUtc();
    final ageCutoff = now.subtract(const Duration(days: 2));
    final expiredRows = await CustomerOrderRow.db.find(
      session,
      where: (t) =>
          t.paymentStatus.equals('pending') &
          (t.paymentLinkExpiresAt < now) &
          (t.paymentLinkExpiresAt >= ageCutoff) &
          t.orderStatus.equals('placed'),
    );

    int count = 0;
    for (final order in expiredRows) {
      try {
        // FOR UPDATE lock to prevent races
        final locked = await session.db.unsafeQuery(
          'SELECT id FROM "customer_order" WHERE "id" = @id FOR UPDATE',
          parameters: QueryParameters.named({'id': order.id!.toJson()}),
        );
        if (locked.isEmpty) continue;

        // Re-check under lock
        final current = await CustomerOrderRow.db.findById(session, order.id!);
        if (current == null ||
            current.paymentStatus != 'pending' ||
            current.orderStatus != 'placed') {
          continue;
        }

        final updated = current.copyWith(
          orderStatus: 'payment_expired',
          paymentStatus: 'cancelled',
          linkStatus: 'EXPIRED',
          updatedAt: now,
        );
        await CustomerOrderRow.db.updateRow(session, updated);
        count++;

        session.log(
          'Expired payment session for order ${current.orderNumber}',
          level: LogLevel.info,
        );
      } catch (e) {
        session.log(
          'Failed to expire session for order ${order.orderNumber}: $e',
          level: LogLevel.error,
        );
      }
    }
    return count;
  }

  /// Detect orphan payments: payment_transaction rows marked 'paid' but
  /// the corresponding customer_order is not 'paid'.
  Future<List<Map<String, dynamic>>> detectOrphanPayments(
    Session session,
  ) async {
    final now = DateTime.now().toUtc();
    final ageCutoff = now.subtract(const Duration(days: 7));
    final orphans = await session.db.unsafeQuery(
      '''
      SELECT pt.id AS txnId,
             pt."gatewayPaymentId",
             pt."gatewayOrderId",
             co."orderNumber",
             co."paymentStatus" AS orderPaymentStatus,
             pt."paymentStatus" AS txnPaymentStatus,
             pt."createdAt"
      FROM "payment_transaction" pt
      LEFT JOIN "customer_order" co ON co.id = pt."orderId"
      WHERE pt."paymentStatus" = 'paid'
        AND (co.id IS NULL OR co."paymentStatus" != 'paid')
        AND pt."createdAt" >= @ageCutoff
      ORDER BY pt."createdAt" DESC
      LIMIT 50
    ''',
      parameters: QueryParameters.named({
        'ageCutoff': ageCutoff.toIso8601String(),
      }),
    );

    return orphans.map((row) {
      final map = row.toColumnMap();
      return {
        'txnId': map['txnId']?.toString(),
        'gatewayPaymentId': map['gatewayPaymentId']?.toString(),
        'gatewayOrderId': map['gatewayOrderId']?.toString(),
        'orderNumber': map['orderNumber']?.toString(),
        'orderPaymentStatus': map['orderPaymentStatus']?.toString(),
        'txnPaymentStatus': map['txnPaymentStatus']?.toString(),
        'createdAt': map['createdAt']?.toString(),
      };
    }).toList();
  }

  Future<Map<String, int>> reconcilePaymentLinkOrders(
    Session session, {
    int limit = 50,
    String? singleOrderNumber,
  }) async {
    var recovered = 0;
    var failed = 0;
    var skipped = 0;

    try {
      final now = DateTime.now().toUtc();
      final cutoff = now.subtract(const Duration(minutes: 2));
      final ageCutoff = now.subtract(const Duration(days: 3));

      final rows = await session.db.unsafeQuery(
        '''SELECT co.*, pl."razorpayPaymentLinkId", pl."token"
           FROM customer_order co
           JOIN payment_link pl ON pl."orderId" = co."id"
           WHERE co."paymentStatus" = 'pending'
             AND co."linkStatus" = 'ACTIVE'
             AND co."updatedAt" < @cutoff
             AND co."updatedAt" >= @ageCutoff
           ${singleOrderNumber != null ? 'AND co."orderNumber" = @orderNumber' : ''}
           ORDER BY co."updatedAt" ASC
           LIMIT @limit''',
        parameters: QueryParameters.named({
          'cutoff': cutoff.toIso8601String(),
          'ageCutoff': ageCutoff.toIso8601String(),
          'limit': limit,
          // ignore: use_null_aware_elements
          if (singleOrderNumber != null) 'orderNumber': singleOrderNumber,
        }),
      );

      for (final row in rows) {
        try {
          final map = row.toColumnMap();
          final linkId = map['razorpayPaymentLinkId'] as String?;
          final orderNumber = map['orderNumber'] as String?;
          if (linkId == null ||
              linkId.isEmpty ||
              orderNumber == null ||
              orderNumber.isEmpty) {
            skipped++;
            continue;
          }

          final statusResult = await _gateway.fetchPaymentLinkStatus(linkId);
          final data = statusResult['data'] as Map<String, dynamic>?;
          if (data == null) {
            skipped++;
            continue;
          }

          final linkStatus = data['status']?.toString().toLowerCase();
          if (linkStatus == 'paid') {
            final payments = data['payments'] as List?;
            if (payments != null && payments.isNotEmpty) {
              final paymentId = payments[0]['payment_id']?.toString();
              final razorpayOrderId = payments[0]['order_id']?.toString();
              if (paymentId != null && razorpayOrderId != null) {
                final result = await completePaymentVerification(
                  session,
                  orderNumber: orderNumber,
                  razorpayOrderId: razorpayOrderId,
                  razorpayPaymentId: paymentId,
                );
                if (result.success && result.verified) {
                  recovered++;
                } else {
                  skipped++;
                }
              } else {
                skipped++;
              }
            } else {
              skipped++;
            }
          } else {
            skipped++;
          }
        } catch (e) {
          session.log(
            'Payment link reconciliation row error: $e',
            level: LogLevel.warning,
          );
          skipped++;
        }
      }

      session.log(
        'Payment link reconciliation: $recovered recovered, $failed failed, $skipped skipped',
        level: LogLevel.info,
      );
    } catch (error) {
      session.log(
        'Payment link reconciliation failed: $error',
        level: LogLevel.error,
      );
    }

    return {'recovered': recovered, 'failed': failed, 'skipped': skipped};
  }
}
