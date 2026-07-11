import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../payments/payment_gateway_service.dart';
import '../realtime/realtime_service.dart';

class PostgresPaymentSessionService {
  static const Duration qrExpiryDuration = Duration(minutes: 5);
  final _gateway = PaymentGatewayService();

  PaymentSessionData _buildSessionData(
    PaymentSessionRow session, {
    bool success = true,
    String? error,
  }) {
    return PaymentSessionData(
      success: success,
      sessionId: session.id?.toString(),
      orderId: session.orderId.toString(),
      amount: session.amount,
      status: session.status,
      razorpayQrId: session.razorpayQrId,
      qrImageUrl: session.qrImageUrl,
      expiresAt: session.expiresAt,
      expiresInSeconds: _computeExpiresInSeconds(session.expiresAt),
      gatewayPaymentId: session.gatewayPaymentId,
      paidAt: session.paidAt,
      error: error,
    );
  }

  int _computeExpiresInSeconds(DateTime expiresAt) {
    return expiresAt.difference(DateTime.now().toUtc()).inSeconds.clamp(0, 99999);
  }

  Future<PaymentSessionData> createQrPaymentSession(
    Session session, {
    required String orderId,
    required String adminFirebaseUid,
  }) async {
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(qrExpiryDuration);

    return session.db.transaction((transaction) async {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderId),
        transaction: transaction,
      );
      if (orderRow?.id == null) {
        return _buildSessionData(
          PaymentSessionRow(
            orderId: UuidValue.fromString('00000000-0000-0000-0000-000000000000'),
            customerId: UuidValue.fromString('00000000-0000-0000-0000-000000000000'),
            createdByAdminId: adminFirebaseUid,
            amount: 0,
            status: 'FAILED',
            expiresAt: now,
          ),
          success: false,
          error: 'Order not found',
        );
      }

      // FOR UPDATE lock
      await session.db.unsafeQuery(
        'SELECT "id" FROM "customer_order" WHERE "id" = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': orderRow!.id!.toJson()}),
        transaction: transaction,
      );

      // Re-read under lock
      final lockedOrder = await CustomerOrderRow.db.findById(
        session,
        orderRow.id!,
        transaction: transaction,
      );
      if (lockedOrder == null) {
        return _buildSessionData(
          PaymentSessionRow(
            orderId: orderRow.id!,
            customerId: orderRow.userId,
            createdByAdminId: adminFirebaseUid,
            amount: 0,
            status: 'FAILED',
            expiresAt: now,
          ),
          success: false,
          error: 'Order not found',
        );
      }

      if (lockedOrder.paymentMode != 'cod') {
        return _buildSessionData(
          PaymentSessionRow(
            orderId: lockedOrder.id!,
            customerId: lockedOrder.userId,
            createdByAdminId: adminFirebaseUid,
            amount: 0,
            status: 'FAILED',
            expiresAt: now,
          ),
          success: false,
          error: 'Order is not a COD order',
        );
      }

      if (lockedOrder.paymentStatus == 'paid') {
        return _buildSessionData(
          PaymentSessionRow(
            orderId: lockedOrder.id!,
            customerId: lockedOrder.userId,
            createdByAdminId: adminFirebaseUid,
            amount: 0,
            status: 'FAILED',
            expiresAt: now,
          ),
          success: false,
          error: 'COD payment has already been collected for this order',
        );
      }

      // Check existing active session
      final existing = await PaymentSessionRow.db.findFirstRow(
        session,
        where: (t) =>
            t.orderId.equals(lockedOrder.id!) &
            t.status.equals('ACTIVE'),
        transaction: transaction,
      );
      if (existing != null) {
        // Return existing active session
        return _buildSessionData(existing);
      }

      // Create session
      final newSession = PaymentSessionRow(
        orderId: lockedOrder.id!,
        customerId: lockedOrder.userId,
        createdByAdminId: adminFirebaseUid,
        amount: lockedOrder.finalAmount,
        status: 'ACTIVE',
        expiresAt: expiresAt,
        createdAt: now,
        updatedAt: now,
      );

      final insertedSession = await PaymentSessionRow.db.insertRow(
        session,
        newSession,
        transaction: transaction,
      );

      // Call Razorpay QR API
      final amountInPaise = (lockedOrder.finalAmount * 100).round();
      final qrResponse = await _gateway.createUpiQr(
        amountInPaise: amountInPaise,
        description: 'COD payment - Order ${lockedOrder.orderNumber}',
        notes: {
          'order_id': lockedOrder.orderNumber,
          'session_id': insertedSession.id?.toString() ?? '',
        },
        expiryMinutes: 15,
      );

      if (qrResponse['statusCode'] != 200) {
        // Rollback: delete the inserted session row
        if (insertedSession.id != null) {
          await PaymentSessionRow.db.delete(
            session,
            [insertedSession],
            transaction: transaction,
          );
        }

        session.log(
          'Failed to create Razorpay UPI QR: ${qrResponse['body']}',
          level: LogLevel.error,
        );

        return _buildSessionData(
          PaymentSessionRow(
            orderId: lockedOrder.id!,
            customerId: lockedOrder.userId,
            createdByAdminId: adminFirebaseUid,
            amount: 0,
            status: 'FAILED',
            expiresAt: now,
          ),
          success: false,
          error: 'Failed to create UPI QR',
        );
      }

      final qrData = qrResponse['data'] as Map<String, dynamic>;
      final razorpayQrId = qrData['id']?.toString() ?? '';
      final qrImageUrl = qrData['image_url']?.toString() ?? '';

      session.log(
        'Razorpay UPI QR created: id=$razorpayQrId image_url=$qrImageUrl',
      );
      if (qrImageUrl.isEmpty) {
        session.log(
          'WARNING: qrImageUrl is empty for order ${lockedOrder.orderNumber}',
          level: LogLevel.warning,
        );
      }

      await PaymentSessionRow.db.updateRow(
        session,
        insertedSession.copyWith(
          razorpayQrId: razorpayQrId.isNotEmpty ? razorpayQrId : null,
          qrImageUrl: qrImageUrl.isNotEmpty ? qrImageUrl : null,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final result = await PaymentSessionRow.db.findById(
        session,
        insertedSession.id!,
        transaction: transaction,
      );

      return _buildSessionData(result ?? insertedSession);
    });
  }

  Future<PaymentSessionData> getQrPaymentSession(
    Session session, {
    required String orderId,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (orderRow?.id == null) {
      return PaymentSessionData(
        success: false,
        error: 'Order not found',
      );
    }

    final sessionRow = await PaymentSessionRow.db.findFirstRow(
      session,
      where: (t) =>
          t.orderId.equals(orderRow!.id!) &
          t.status.equals('ACTIVE'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (sessionRow == null) {
      // Also check for PAID/EXPIRED sessions
      final lastSession = await PaymentSessionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      if (lastSession == null) {
        return PaymentSessionData(
          success: false,
          error: 'No payment session found',
        );
      }
      return _buildSessionData(lastSession);
    }

    // Auto-expire if ACTIVE but past expiry
    if (sessionRow.expiresAt.isBefore(DateTime.now().toUtc())) {
      await PaymentSessionRow.db.updateRow(
        session,
        sessionRow.copyWith(
          status: 'EXPIRED',
          expiredAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      // Check Razorpay one last time before returning expired
      final recovered = await _checkRazorpayForPayment(session, sessionRow);
      if (recovered != null) return _buildSessionData(recovered);
      return _buildSessionData(sessionRow.copyWith(
        status: 'EXPIRED',
        expiredAt: DateTime.now().toUtc(),
      ));
    }

    // Check Razorpay for captured payments (handles missing webhooks)
    final recovered = await _checkRazorpayForPayment(session, sessionRow);
    if (recovered != null) return _buildSessionData(recovered);

    return _buildSessionData(sessionRow);
  }

  /// Checks Razorpay for captured payments on the session's QR code.
  /// Returns updated [PaymentSessionRow] if payment recovered, null otherwise.
  Future<PaymentSessionRow?> _checkRazorpayForPayment(
    Session session,
    PaymentSessionRow sessionRow,
  ) async {
    if (sessionRow.razorpayQrId == null ||
        sessionRow.razorpayQrId!.isEmpty) {
      return null;
    }
    try {
      final qrPaymentsResult =
          await _gateway.fetchQrPayments(sessionRow.razorpayQrId!);
      final data = qrPaymentsResult['data'];
      if (data is! Map<String, dynamic>) return null;
      final items = data['items'] as List<dynamic>? ?? [];
      for (final item in items) {
        if (item is Map<String, dynamic> && item['status'] == 'captured') {
          final capturedPaymentId = item['id']?.toString();
          final paidInPaise = (item['amount'] as num?)?.toDouble() ?? 0;
          final capturedAmount = paidInPaise / 100.0;
          if (capturedPaymentId != null && capturedPaymentId.isNotEmpty) {
            if ((sessionRow.amount - capturedAmount).abs() > 1.0) continue;
            final result = await _applyQrPaymentToOrder(
              session,
              sessionRow,
              gatewayPaymentId: capturedPaymentId,
            );
            if (result['success'] == true) {
              session.log(
                'QR poll: auto-recovered payment for session ${sessionRow.id} '
                '(razorpayPaymentId=$capturedPaymentId)',
                level: LogLevel.info,
              );
              final paidSession = await PaymentSessionRow.db.findById(
                session,
                sessionRow.id!,
              );
              return paidSession;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<PaymentSessionData> regenerateQrPaymentSession(
    Session session, {
    required String orderId,
    required String adminFirebaseUid,
  }) async {
    await expireCurrentSession(session, orderId: orderId);
    return createQrPaymentSession(
      session,
      orderId: orderId,
      adminFirebaseUid: adminFirebaseUid,
    );
  }

  Future<void> expireCurrentSession(
    Session session, {
    required String orderId,
  }) async {
    final now = DateTime.now().toUtc();
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (orderRow?.id == null) return;

    final activeSession = await PaymentSessionRow.db.findFirstRow(
      session,
      where: (t) =>
          t.orderId.equals(orderRow!.id!) &
          t.status.equals('ACTIVE'),
    );
    if (activeSession == null) return;

    // Close QR on Razorpay
    if (activeSession.razorpayQrId != null &&
        activeSession.razorpayQrId!.isNotEmpty) {
      try {
        await _gateway.closeQrCode(activeSession.razorpayQrId!);
      } catch (_) {
        // Non-fatal: QR may already be closed on Razorpay side
      }
    }

    await PaymentSessionRow.db.updateRow(
      session,
      activeSession.copyWith(
        status: 'EXPIRED',
        expiredAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> markSessionPaid(
    Session session,
    UuidValue sessionId, {
    required String gatewayPaymentId,
    required DateTime paidAt,
    Transaction? transaction,
  }) async {
    final row = await PaymentSessionRow.db.findById(
      session,
      sessionId,
      transaction: transaction,
    );
    if (row == null || row.status != 'ACTIVE') return;

    await PaymentSessionRow.db.updateRow(
      session,
      row.copyWith(
        status: 'PAID',
        gatewayPaymentId: gatewayPaymentId,
        paidAt: paidAt,
        updatedAt: paidAt,
      ),
      transaction: transaction,
    );
  }

  /// Core helper: mark session PAID and update order in a transaction.
  /// Used by both the webhook handler and the reconciliation cron.
  Future<Map<String, dynamic>> _applyQrPaymentToOrder(
    Session session,
    PaymentSessionRow sessionRow, {
    required String gatewayPaymentId,
  }) async {
    final now = DateTime.now().toUtc();

    return session.db.transaction((transaction) async {
      final orderRow = await CustomerOrderRow.db.findById(
        session,
        sessionRow.orderId,
        transaction: transaction,
      );
      if (orderRow == null) {
        return {'success': false, 'error': 'Order not found'};
      }

      await session.db.unsafeQuery(
        'SELECT "id" FROM "customer_order" WHERE "id" = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': orderRow.id!.toJson()}),
        transaction: transaction,
      );

      if (orderRow.paymentStatus == 'paid') {
        return {'success': false, 'error': 'Already paid'};
      }

      await markSessionPaid(
        session,
        sessionRow.id!,
        gatewayPaymentId: gatewayPaymentId,
        paidAt: now,
        transaction: transaction,
      );

      await CustomerOrderRow.db.updateRow(
        session,
        orderRow.copyWith(
          paymentStatus: 'paid',
          paymentCollectedAt: now,
          paymentCollectedBy: sessionRow.createdByAdminId,
          paymentCollectionMode: 'upi_qr',
          updatedAt: now,
        ),
        transaction: transaction,
      );

      session.log(
        'COD online payment completed for order ${orderRow.orderNumber} via QR session ${sessionRow.id}',
        level: LogLevel.info,
      );

      try {
        final event = OrderRealtimeEvent(
          eventType: 'payment_completed',
          orderId: orderRow.orderNumber,
          status: 'paid',
          userId: orderRow.userId.toString(),
        );
        await RealtimeService().sendAdminOrderUpdate(session, event);
        await RealtimeService().sendDashboardUpdate(session, event);
      } catch (_) {
        // Non-fatal — polling fallback will pick up the payment
      }

      return {'success': true};
    });
  }

  /// Close QR on Razorpay (best-effort) and mark session EXPIRED.
  Future<void> _closeAndExpireSession(
    Session session,
    PaymentSessionRow sessionRow,
  ) async {
    final now = DateTime.now().toUtc();

    if (sessionRow.razorpayQrId != null &&
        sessionRow.razorpayQrId!.isNotEmpty) {
      try {
        await _gateway.closeQrCode(sessionRow.razorpayQrId!);
      } catch (_) {
        // Non-fatal
      }
    }

    await PaymentSessionRow.db.updateRow(
      session,
      sessionRow.copyWith(
        status: 'EXPIRED',
        expiredAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Map<String, dynamic>> handleQrWebhookPayment(
    Session session, {
    required String razorpayQrId,
    required String gatewayPaymentId,
    required double paidAmount,
  }) async {
    try {
      final sessionRow = await PaymentSessionRow.db.findFirstRow(
        session,
        where: (t) => t.razorpayQrId.equals(razorpayQrId),
      );
      if (sessionRow == null) {
        session.log(
          'QR webhook: no session found for qrId=$razorpayQrId',
          level: LogLevel.warning,
        );
        return {'success': false, 'error': 'Session not found'};
      }

      if (sessionRow.status != 'ACTIVE') {
        session.log(
          'QR webhook: session ${sessionRow.id} has status ${sessionRow.status}',
          level: LogLevel.warning,
        );
        return {'success': false, 'error': 'Session is not active'};
      }

      // Validate amount (tolerance of 1 rupee)
      if ((sessionRow.amount - paidAmount).abs() > 1.0) {
        session.log(
          'QR webhook: amount mismatch — expected ${sessionRow.amount}, got $paidAmount',
          level: LogLevel.warning,
        );
        return {'success': false, 'error': 'Amount mismatch'};
      }

      return _applyQrPaymentToOrder(
        session,
        sessionRow,
        gatewayPaymentId: gatewayPaymentId,
      );
    } catch (error) {
      session.log(
        'QR webhook handler error: $error',
        level: LogLevel.error,
      );
      return {'success': false, 'error': error.toString()};
    }
  }

  /// On-demand recovery for a single order's QR payment.
  /// Checks eligibility (pending + COD + active/recently expired session),
  /// calls Razorpay to verify actual payment status, and recovers if found.
  /// Returns {recovered: bool, gatewayPaymentId: String?}.
  Future<Map<String, dynamic>> recoverQrPaymentForOrder(
    Session session, {
    required String orderNumber,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return {'recovered': false, 'reason': 'Order not found'};
      }

      // Eligibility: must be pending COD
      if (orderRow!.paymentStatus != 'pending') {
        return {'recovered': false, 'reason': 'Payment not pending'};
      }
      if (orderRow.paymentMode != 'cod') {
        return {'recovered': false, 'reason': 'Not a COD order'};
      }

      // Load the most recent payment session
      final sessionRow = await PaymentSessionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow.id!),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      if (sessionRow == null) {
        return {'recovered': false, 'reason': 'No payment session found'};
      }
      if (sessionRow.razorpayQrId == null ||
          sessionRow.razorpayQrId!.isEmpty) {
        return {'recovered': false, 'reason': 'No Razorpay QR ID on session'};
      }

      // Session must be ACTIVE or recently EXPIRED (within 15 min)
      final now = DateTime.now().toUtc();
      if (sessionRow.status != 'ACTIVE') {
        if (sessionRow.status != 'EXPIRED') {
          return {'recovered': false, 'reason': 'Session status is ${sessionRow.status}'};
        }
        final expiryCutoff = now.subtract(const Duration(minutes: 15));
        if (sessionRow.expiredAt == null || sessionRow.expiredAt!.isBefore(expiryCutoff)) {
          return {'recovered': false, 'reason': 'Session expired too long ago'};
        }
      }

      // Call Razorpay to list payments for this QR code
      final qrPaymentsResult =
          await _gateway.fetchQrPayments(sessionRow.razorpayQrId!);
      final data = qrPaymentsResult['data'];

      String? capturedPaymentId;
      double? capturedAmount;

      if (data is Map<String, dynamic>) {
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          if (item is Map<String, dynamic> &&
              item['status'] == 'captured') {
            capturedPaymentId = item['id']?.toString();
            final paidInPaise =
                (item['amount'] as num?)?.toDouble() ?? 0;
            capturedAmount = paidInPaise / 100.0;
            break;
          }
        }
      }

      if (capturedPaymentId == null || capturedAmount == null) {
        return {'recovered': false, 'reason': 'No captured payment found on Razorpay'};
      }

      // Validate amount (tolerance of 1 rupee)
      if ((sessionRow.amount - capturedAmount).abs() > 1.0) {
        session.log(
          'QR recovery: amount mismatch for session ${sessionRow.id} '
          '— expected ${sessionRow.amount}, got $capturedAmount',
          level: LogLevel.warning,
        );
        return {'recovered': false, 'reason': 'Amount mismatch'};
      }

      // Apply the payment
      final result = await _applyQrPaymentToOrder(
        session,
        sessionRow,
        gatewayPaymentId: capturedPaymentId,
      );

      if (result['success'] == true) {
        session.log(
          'QR recovery: recovered payment for order $orderNumber '
          '(razorpayPaymentId=$capturedPaymentId)',
          level: LogLevel.info,
        );
        return {'recovered': true, 'gatewayPaymentId': capturedPaymentId};
      }

      return {'recovered': false, 'reason': result['error'] ?? 'Apply failed'};
    } catch (error) {
      session.log(
        'QR recovery error for order $orderNumber: $error',
        level: LogLevel.error,
      );
      return {'recovered': false, 'reason': error.toString()};
    }
  }

  /// Reconcile expired ACTIVE QR payment sessions.
  /// For each expired session, checks Razorpay to see if the QR was actually paid
  /// (webhook was missed). If paid, recovers the order. Otherwise, expires it.
  Future<Map<String, int>> reconcileExpiredQrSessions(
    Session session, {
    int limit = 50,
  }) async {
    var recovered = 0;
    var expired = 0;
    var skipped = 0;

    try {
      final now = DateTime.now().toUtc();

      final expiredSessions = await PaymentSessionRow.db.find(
        session,
        where: (t) =>
            t.status.equals('ACTIVE') & (t.expiresAt < now),
        limit: limit,
        orderBy: (t) => t.expiresAt,
      );

      for (final sessionRow in expiredSessions) {
        if (sessionRow.razorpayQrId == null ||
            sessionRow.razorpayQrId!.isEmpty) {
          await _closeAndExpireSession(session, sessionRow);
          expired++;
          continue;
        }

        try {
          final qrPaymentsResult =
              await _gateway.fetchQrPayments(sessionRow.razorpayQrId!);
          final data = qrPaymentsResult['data'];

          String? capturedPaymentId;
          double? capturedAmount;

          if (data is Map<String, dynamic>) {
            final items = data['items'] as List<dynamic>? ?? [];
            for (final item in items) {
              if (item is Map<String, dynamic> &&
                  item['status'] == 'captured') {
                capturedPaymentId = item['id']?.toString();
                final paidInPaise =
                    (item['amount'] as num?)?.toDouble() ?? 0;
                capturedAmount = paidInPaise / 100.0;
                break;
              }
            }
          }

          if (capturedPaymentId != null && capturedAmount != null) {
            // Validate amount (tolerance of 1 rupee)
            if ((sessionRow.amount - capturedAmount).abs() > 1.0) {
              session.log(
                'QR reconciliation: amount mismatch for session ${sessionRow.id} '
                '— expected ${sessionRow.amount}, got $capturedAmount',
                level: LogLevel.warning,
              );
              skipped++;
              continue;
            }

            final result = await _applyQrPaymentToOrder(
              session,
              sessionRow,
              gatewayPaymentId: capturedPaymentId,
            );
            if (result['success'] == true) {
              recovered++;
              session.log(
                'QR reconciliation: recovered payment for session ${sessionRow.id} '
                '(razorpayPaymentId=$capturedPaymentId)',
                level: LogLevel.info,
              );
            } else {
              skipped++;
            }
          } else {
            await _closeAndExpireSession(session, sessionRow);
            expired++;
          }
        } catch (e) {
          session.log(
            'QR reconciliation error for session ${sessionRow.id}: $e',
            level: LogLevel.error,
          );
          skipped++;
        }
      }

      if (recovered + expired + skipped > 0) {
        session.log(
          'QR session reconciliation: $recovered recovered, $expired expired, $skipped skipped',
          level: LogLevel.info,
        );
      }
    } catch (error) {
      session.log(
        'QR reconciliation failed: $error',
        level: LogLevel.error,
      );
    }

    return {'recovered': recovered, 'expired': expired, 'skipped': skipped};
  }
}
