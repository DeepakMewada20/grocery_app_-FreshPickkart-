import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../services/env_service.dart';
import '../../services/postgres/postgres_auto_refund_service.dart';
import '../../services/postgres/postgres_payment_link_service.dart';
import '../../services/postgres/postgres_payment_service.dart';
import '../../services/postgres/postgres_refund_service.dart';
import '../../services/notification_service.dart';

class RazorpayWebhookRoute extends Route {
  RazorpayWebhookRoute() : super(methods: {Method.post});

  final PostgresPaymentService _payments = PostgresPaymentService();
  final PostgresRefundService _refunds = PostgresRefundService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final secret = EnvService.get('RAZORPAY_WEBHOOK_SECRET');
    if (secret == null || secret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString('Missing RAZORPAY_WEBHOOK_SECRET'),
      );
    }

    final signature =
        _firstHeader(
          request.headers,
          'x-razorpay-signature',
        ) ??
        _firstHeader(request.headers, 'X-Razorpay-Signature');
    if (signature == null || signature.isEmpty) {
      return Response.badRequest(
        body: Body.fromString('Missing signature'),
      );
    }

    final bodyBytes = await _readBodyBytes(request);
    final expectedSignature = _hmacSha256Hex(bodyBytes, secret);
    if (expectedSignature != signature) {
      return Response.unauthorized(
        body: Body.fromString('Invalid signature'),
      );
    }

    final bodyString = utf8.decode(bodyBytes);
    final payload = jsonDecode(bodyString) as Map<String, dynamic>;
    final event = (payload['event'] ?? '').toString();

    final paymentId = _extractPaymentId(payload);
    final razorpayOrderId = _extractRazorpayOrderId(payload);
    final orderNumber = _extractOrderNumber(payload);
    final order = orderNumber == null || orderNumber.isEmpty
        ? null
        : await _getOrderByNumber(session, orderNumber);
    final amountPaise = _extractAmountPaise(payload);
    final currency = _extractCurrency(payload);

    session.log(
      'Webhook received: event=$event, paymentId=$paymentId, '
      'razorpayOrderId=$razorpayOrderId, orderNumber=$orderNumber',
      level: LogLevel.info,
    );

    if (_isPaidEvent(event) && order != null) {
      if (currency != null && currency.toUpperCase() != 'INR') {
        session.log(
          'Webhook rejected: invalid currency $currency for order $orderNumber',
          level: LogLevel.warning,
        );
        return Response.badRequest(
          body: Body.fromString('Invalid currency'),
        );
      }
      if (amountPaise != null) {
        final expected = (order.finalAmount * 100).round();
        if ((expected - amountPaise).abs() > 1) {
          session.log(
            'Webhook rejected: amount mismatch for order $orderNumber. '
            'Expected $expected paise, got $amountPaise paise',
            level: LogLevel.warning,
          );
          return Response.badRequest(
            body: Body.fromString('Amount mismatch'),
          );
        }
      }
    }

    if (_isPaymentLinkPaidEvent(event)) {
      await _handlePaymentLinkPaid(session, payload, event);
    } else if (_isPaymentLinkLifecycleEvent(event)) {
      await _handlePaymentLinkLifecycle(session, payload, event);
    } else if (_isRefundProcessedEvent(event) || _isRefundFailedEvent(event)) {
      if (paymentId != null && paymentId.isNotEmpty) {
        session.log(
          'Webhook processing refund event: $event for payment $paymentId',
          level: LogLevel.info,
        );
        await _refunds.handleRefundWebhook(
          session,
          paymentId: paymentId,
          status: _isRefundProcessedEvent(event) ? 'processed' : 'failed',
          gatewayRefundId: _extractRefundId(payload),
        );
      }
    } else if (_isRefundEvent(event)) {
      if (paymentId != null && paymentId.isNotEmpty) {
        session.log(
          'Webhook processing refund event: $event for payment $paymentId',
          level: LogLevel.info,
        );
        await _refunds.handleRefundWebhook(
          session,
          paymentId: paymentId,
          status: _extractRefundStatus(payload) ?? 'pending',
          gatewayRefundId: _extractRefundId(payload),
        );
      }
    } else if (_isPaidEvent(event)) {
      if (order == null) {
        session.log(
          'Webhook: order not found for payment $paymentId',
          level: LogLevel.warning,
        );
        return _jsonOk({'success': true, 'message': 'Order not found'});
      }
      if (order.paymentStatus == 'paid') {
        // Check if this is a duplicate payment (different payment ID) vs webhook retry (same)
        if (paymentId != null && paymentId.isNotEmpty) {
          // Find the stored payment transaction to check the gateway payment ID
          final existingTxns = await session.db.unsafeQuery(
            '''SELECT "gatewayPaymentId" FROM "payment_transaction"
               WHERE "orderId" = @orderId AND "paymentStatus" = 'paid'
               LIMIT 1''',
            parameters: QueryParameters.named({
              'orderId': (await CustomerOrderRow.db.findFirstRow(
                session,
                where: (t) => t.orderNumber.equals(order.orderId),
              ))?.id?.toJson() ?? '',
            }),
          );
          if (existingTxns.isNotEmpty) {
            final storedPaymentId =
                existingTxns.first.toColumnMap()['gatewayPaymentId'] as String?;
            if (storedPaymentId != null &&
                storedPaymentId.isNotEmpty &&
                storedPaymentId != paymentId) {
              // Different payment — duplicate payment detected
              try {
                final orderRow = await CustomerOrderRow.db.findFirstRow(
                  session,
                  where: (t) => t.orderNumber.equals(order.orderId),
                );
                if (orderRow?.id != null) {
                  final paymentRow = await PaymentTransactionRow.db.findFirstRow(
                    session,
                    where: (t) => t.orderId.equals(orderRow!.id!),
                  );
                  if (paymentRow != null) {
                    await _createAutoRefundJob(
                      session,
                      orderRow!,
                      paymentRow,
                      paymentId,
                      razorpayOrderId ?? '',
                    );
                  }
                }
              } catch (e) {
                session.log(
                  'Webhook: failed to create auto-refund job: $e',
                  level: LogLevel.error,
                );
              }
            }
          }
        }

        session.log(
          'Webhook: payment $paymentId already marked as paid for order $orderNumber',
          level: LogLevel.info,
        );
        return _jsonOk({'success': true, 'message': 'Already paid'});
      }
      // Fresh state check for closed orders (cancelled / payment_expired)
      final freshOrderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(order.orderId),
      );
      if (freshOrderRow != null &&
          (freshOrderRow.orderStatus == 'cancelled' ||
           freshOrderRow.orderStatus == 'payment_expired')) {
        if (paymentId != null && paymentId.isNotEmpty) {
          final paymentRow = await PaymentTransactionRow.db.findFirstRow(
            session,
            where: (t) => t.orderId.equals(freshOrderRow.id!),
          );
            if (paymentRow != null) {
              await _createAutoRefundJob(
                session, freshOrderRow, paymentRow,
                paymentId, razorpayOrderId ?? '');
            }
          }
          session.log(
            'PAYMENT_RECEIVED_FOR_CLOSED_ORDER: order=$orderNumber, payment=$paymentId',
            level: LogLevel.warning,
          );
          return _jsonOk({'success': true, 'message': 'Order closed, auto-refund created'});
        }

      if (paymentId != null && paymentId.isNotEmpty) {
        session.log(
          'Webhook completing payment verification: payment $paymentId, '
          'order $orderNumber',
          level: LogLevel.info,
        );
        final result = await _payments.completePaymentVerification(
          session,
          orderNumber: order.orderId,
          razorpayOrderId: razorpayOrderId ?? '',
          razorpayPaymentId: paymentId,
        );
        if (!result.success || !result.verified) {
          session.log(
            'Webhook: payment verification failed for payment $paymentId, '
            'order $orderNumber: ${result.message ?? result.error}',
            level: LogLevel.error,
          );
          return Response.badRequest(
            body: Body.fromString(result.message ?? result.error ?? 'Failed'),
          );
        }

        // Mark payment link as used (for shareable link orders)
        try {
          final paymentEntity =
              payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
          final notes = paymentEntity?['notes'] as Map<String, dynamic>?;
          final paidByName = notes?['paidByName']?.toString();
          final paidByPhone = notes?['paidByPhone']?.toString();
          final paidByEmail = notes?['paidByEmail']?.toString();

          if (order.orderId.isNotEmpty) {
            final orderRow = await CustomerOrderRow.db.findFirstRow(
              session,
              where: (t) => t.orderNumber.equals(order.orderId),
            );
            if (orderRow?.id != null) {
              final token = await _paymentLinks.getTokenForOrder(
                session,
                orderRow!.id!,
              );
              if (token != null) {
                await _paymentLinks.markUsed(
                  session,
                  token,
                  paidByName: paidByName,
                  paidByPhone: paidByPhone,
                  paidByEmail: paidByEmail,
                );

                // Also store payer info on the order
                if (paidByName != null || paidByPhone != null || paidByEmail != null) {
                  await CustomerOrderRow.db.updateRow(
                    session,
                    orderRow.copyWith(
                      paidByName: paidByName ?? orderRow.paidByName,
                      paidByPhone: paidByPhone ?? orderRow.paidByPhone,
                      paidByEmail: paidByEmail ?? orderRow.paidByEmail,
                      updatedAt: DateTime.now().toUtc(),
                    ),
                  );
                }
              }
            }
          }
        } catch (e) {
          session.log(
            'Failed to mark payment link as used: $e',
            level: LogLevel.warning,
          );
        }

        session.log(
          'Webhook: payment $paymentId successfully completed for order $orderNumber',
          level: LogLevel.info,
        );
        try {
          final safeOrderId = orderNumber ?? '';
          await session.messages.postMessage(
            'payment_$safeOrderId',
            PaymentEvent(
              eventType: 'payment_completed',
              orderId: safeOrderId,
              paymentStatus: 'paid',
            ),
          );
        } catch (_) {}
      }
    } else if (_isFailedEvent(event) && order != null) {
      session.log(
        'Webhook: marking payment as failed for order $orderNumber, '
        'payment $paymentId',
        level: LogLevel.info,
      );
      await _payments.markPaymentFailed(
        session,
        order.orderId,
        failureType: 'failed',
        failureReason: event,
      );
    }

    return _jsonOk({'success': true});
  }

  Future<List<int>> _readBodyBytes(Request request) async {
    final chunks = await request.read().toList();
    final bytes = <int>[];
    for (final chunk in chunks) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  String _hmacSha256Hex(List<int> bytes, String secret) {
    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(bytes);
    return digest.toString();
  }

  String? _extractOrderNumber(Map<String, dynamic> payload) {
    final orderEntity =
        payload['payload']?['order']?['entity'] as Map<String, dynamic>?;
    final receipt = orderEntity?['receipt']?.toString();
    if (receipt != null && receipt.isNotEmpty) return receipt;

    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    final notes = paymentEntity?['notes'] as Map<String, dynamic>?;
    final orderId = notes?['order_id']?.toString();
    if (orderId != null && orderId.isNotEmpty) return orderId;

    final refundEntity =
        payload['payload']?['refund']?['entity'] as Map<String, dynamic>?;
    final refundNotes = refundEntity?['notes'] as Map<String, dynamic>?;
    final refundOrderId = refundNotes?['order_id']?.toString();
    if (refundOrderId != null && refundOrderId.isNotEmpty) return refundOrderId;
    return null;
  }

  String? _extractPaymentId(Map<String, dynamic> payload) {
    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    final paymentId = paymentEntity?['id']?.toString();
    if (paymentId != null && paymentId.isNotEmpty) return paymentId;

    final refundEntity =
        payload['payload']?['refund']?['entity'] as Map<String, dynamic>?;
    final refundPaymentId = refundEntity?['payment_id']?.toString();
    if (refundPaymentId != null && refundPaymentId.isNotEmpty) {
      return refundPaymentId;
    }
    return null;
  }

  String? _extractRazorpayOrderId(Map<String, dynamic> payload) {
    final orderEntity =
        payload['payload']?['order']?['entity'] as Map<String, dynamic>?;
    final orderId = orderEntity?['id']?.toString();
    if (orderId != null && orderId.isNotEmpty) return orderId;

    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    return paymentEntity?['order_id']?.toString();
  }

  int? _extractAmountPaise(Map<String, dynamic> payload) {
    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    final paymentAmount = paymentEntity?['amount'];
    if (paymentAmount is int) return paymentAmount;
    if (paymentAmount is num) return paymentAmount.round();

    final orderEntity =
        payload['payload']?['order']?['entity'] as Map<String, dynamic>?;
    final orderAmount = orderEntity?['amount'];
    if (orderAmount is int) return orderAmount;
    if (orderAmount is num) return orderAmount.round();

    return null;
  }

  String? _extractCurrency(Map<String, dynamic> payload) {
    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    final paymentCurrency = paymentEntity?['currency']?.toString();
    if (paymentCurrency != null && paymentCurrency.isNotEmpty) {
      return paymentCurrency;
    }

    final orderEntity =
        payload['payload']?['order']?['entity'] as Map<String, dynamic>?;
    final orderCurrency = orderEntity?['currency']?.toString();
    if (orderCurrency != null && orderCurrency.isNotEmpty) {
      return orderCurrency;
    }

    return null;
  }

  bool _isPaidEvent(String event) {
    return event == 'payment.captured' ||
        event == 'payment.authorized' ||
        event == 'order.paid';
  }

  bool _isFailedEvent(String event) {
    return event == 'payment.failed';
  }

  bool _isRefundEvent(String event) {
    return event.startsWith('refund.');
  }

  bool _isRefundProcessedEvent(String event) {
    return event == 'refund.processed';
  }

  bool _isRefundFailedEvent(String event) {
    return event == 'refund.failed';
  }

  String? _extractRefundId(Map<String, dynamic> payload) {
    final refundEntity =
        payload['payload']?['refund']?['entity'] as Map<String, dynamic>?;
    return refundEntity?['id']?.toString();
  }

  String? _extractRefundStatus(Map<String, dynamic> payload) {
    final refundEntity =
        payload['payload']?['refund']?['entity'] as Map<String, dynamic>?;
    final status = refundEntity?['status']?.toString().trim();
    if (status == null || status.isEmpty) return null;
    return status;
  }

  Future<Order?> _getOrderByNumber(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (row == null) return null;
    return Order(
      orderId: row.orderNumber,
      userId: row.userId.toString(),
      userPhone: '',
      items: const [],
      itemCount: row.itemCount,
      totalAmount: row.totalAmount,
      discountAmount: row.discountAmount,
      deliveryFee: row.deliveryFee,
      finalAmount: row.finalAmount,
      status: row.orderStatus,
      paymentStatus: row.paymentStatus,
      refundStatus: row.refundStatus,
      deliveryAddress: Address(
        street: '',
        city: '',
        state: '',
        zipCode: '',
        country: '',
      ),
      orderedAt: row.orderedAt,
      orderType: row.orderType,
      sourceOrderNumber: row.sourceOrderNumber,
      complaintId: row.complaintId,
    );
  }

  Response _jsonOk(Map<String, dynamic> data) {
    return Response.ok(
      body: Body.fromString(
        jsonEncode(data),
        mimeType: MimeType.json,
      ),
    );
  }

  String? _firstHeader(Headers headers, String name) {
    final values = headers[name];
    if (values == null) return null;
    final iterator = values.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }

  // --- Payment Link Webhook Handlers ---

  bool _isPaymentLinkPaidEvent(String event) => event == 'payment_link.paid';

  bool _isPaymentLinkLifecycleEvent(String event) =>
      event == 'payment_link.cancelled' || event == 'payment_link.expired';

  Future<void> _handlePaymentLinkPaid(
    Session session,
    Map<String, dynamic> payload,
    String event,
  ) async {
    try {
      final paymentLinkEntity =
          payload['payload']?['payment_link']?['entity'] as Map<String, dynamic>?;
      final paymentEntity =
          payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;

      if (paymentLinkEntity == null) {
        session.log('payment_link.paid: missing payment_link entity', level: LogLevel.warning);
        return;
      }

      final razorpayPaymentLinkId = paymentLinkEntity['id']?.toString();
      final notes = paymentLinkEntity['notes'] as Map<String, dynamic>?;
      final orderNumber = notes?['order_id']?.toString();
      final token = notes?['token']?.toString();

      if (razorpayPaymentLinkId == null || orderNumber == null) {
        session.log(
          'payment_link.paid: missing linkId or orderNumber',
          level: LogLevel.warning,
        );
        return;
      }

      final paymentId = paymentEntity?['id']?.toString();
      final razorpayOrderId = paymentEntity?['order_id']?.toString();
      final amountPaise = paymentEntity?['amount'];

      // Fetch order details for validation
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber.trim()),
      );
      if (orderRow == null) {
        session.log(
          'payment_link.paid: order $orderNumber not found',
          level: LogLevel.warning,
        );
        return;
      }
      final dbPaymentStatus = orderRow.paymentStatus;
      final dbFinalAmount = orderRow.finalAmount;

      // Security: prevent duplicate webhook processing
      if (paymentId != null && paymentId.isNotEmpty) {
        final existingTxns = await session.db.unsafeQuery(
          '''
          SELECT "id" FROM "payment_transaction"
          WHERE "gatewayPaymentId" = @paymentId
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'paymentId': paymentId}),
        );
        if (existingTxns.isNotEmpty) {
          session.log(
            'payment_link.paid: payment $paymentId already processed for $orderNumber',
            level: LogLevel.info,
          );
          return;
        }
      }

      // Security: verify payment_link_id matches stored record
      if (token != null && token.isNotEmpty) {
        final linkRows = await session.db.unsafeQuery(
          '''
          SELECT "razorpayPaymentLinkId" FROM "payment_link"
          WHERE "token" = @token
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'token': token}),
        );
        if (linkRows.isNotEmpty) {
          final storedLinkId = linkRows.first.toColumnMap()['razorpayPaymentLinkId'] as String?;
          if (storedLinkId != null && storedLinkId != razorpayPaymentLinkId) {
            session.log(
              'payment_link.paid: link ID mismatch for $orderNumber (stored: $storedLinkId, webhook: $razorpayPaymentLinkId)',
              level: LogLevel.error,
            );
            return;
          }
        }
      }

      // Already paid check — with duplicate detection
      if (dbPaymentStatus == 'paid') {
        // Check if this is a different payment ID (duplicate) vs webhook retry
        if (paymentId != null && paymentId.isNotEmpty) {
          final existingTxns = await session.db.unsafeQuery(
            '''SELECT "gatewayPaymentId" FROM "payment_transaction"
               WHERE "orderId" = @orderId AND "paymentStatus" = 'paid'
               LIMIT 1''',
            parameters: QueryParameters.named({
              'orderId': orderRow.id!.toJson(),
            }),
          );
          if (existingTxns.isNotEmpty) {
            final storedPaymentId =
                existingTxns.first.toColumnMap()['gatewayPaymentId'] as String?;
            if (storedPaymentId != null &&
                storedPaymentId.isNotEmpty &&
                storedPaymentId != paymentId) {
              // Different payment — duplicate detected, create refund job
              final paymentRow = await PaymentTransactionRow.db.findFirstRow(
                session,
                where: (t) => t.orderId.equals(orderRow.id!),
              );
              if (paymentRow != null) {
                await _createAutoRefundJob(
                  session,
                  orderRow,
                  paymentRow,
                  paymentId,
                  razorpayOrderId ?? '',
                );
              }
            }
          }
        }
        session.log(
          'payment_link.paid: order $orderNumber already paid',
          level: LogLevel.info,
        );
        return;
      }

      // Validate amount
      if (amountPaise is int) {
        final expected = (dbFinalAmount * 100).round();
        if ((expected - amountPaise).abs() > 1) {
          session.log(
            'payment_link.paid: amount mismatch for $orderNumber',
            level: LogLevel.warning,
          );
          return;
        }
      }

      // Fresh state check for closed orders
      if (orderRow.orderStatus == 'cancelled' || orderRow.orderStatus == 'payment_expired') {
        if (paymentId != null && paymentId.isNotEmpty) {
          final paymentRow = await PaymentTransactionRow.db.findFirstRow(
            session,
            where: (t) => t.orderId.equals(orderRow.id!),
          );
          if (paymentRow != null) {
            await _createAutoRefundJob(
              session, orderRow, paymentRow,
              paymentId, razorpayOrderId ?? '');
          }
        }
        session.log(
          'PAYMENT_RECEIVED_FOR_CLOSED_ORDER: order=$orderNumber, payment=$paymentId',
          level: LogLevel.warning,
        );
        return;
      }

      if (paymentId != null && razorpayOrderId != null) {
        final result = await _payments.completePaymentVerification(
          session,
          orderNumber: orderRow.orderNumber,
          razorpayOrderId: razorpayOrderId,
          razorpayPaymentId: paymentId,
        );

        if (!result.success || !result.verified) {
          session.log(
            'payment_link.paid: verification failed for $orderNumber: ${result.message}',
            level: LogLevel.error,
          );
          return;
        }

        // Mark payment link as used
        if (token != null && token.isNotEmpty) {
          final now = DateTime.now().toUtc();
          final customer = paymentLinkEntity['customer'] as Map<String, dynamic>?;
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
              'token': token,
              'now': now.toIso8601String(),
              'paidByName': customer?['name']?.toString(),
              'paidByPhone': customer?['contact']?.toString(),
              'paidByEmail': customer?['email']?.toString(),
            }),
          );
        }

        session.log(
          'payment_link.paid: order $orderNumber completed successfully',
          level: LogLevel.info,
        );
        try {
          final safeOrderId = orderNumber;
          await session.messages.postMessage(
            'payment_$safeOrderId',
            PaymentEvent(
              eventType: 'payment_completed',
              orderId: safeOrderId,
              paymentStatus: 'paid',
            ),
          );
        } catch (_) {}

        // Send FCM push notification to the user
        try {
          final userRow = await AppUserRow.db.findById(session, orderRow.userId);
          await NotificationService.notifyPaymentLinkPaid(
            session: session,
            userId: orderRow.userId.toString(),
            orderId: orderRow.orderNumber,
            amount: orderRow.finalAmount,
            itemCount: orderRow.itemCount,
            userName: userRow?.name ?? 'Customer',
            orderStatus: 'confirmed',
            paymentStatus: 'paid',
          );
        } catch (_) {}
      }
    } catch (e) {
      session.log(
        'payment_link.paid handler error: $e',
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
        gatewayOrderId: incomingOrderId.isNotEmpty ? incomingOrderId : payment.gatewayOrderId,
        amount: order.finalAmount,
        currency: 'INR',
      );

      await PostgresAutoRefundService().createJob(session, job: job);

      session.log(
        'Duplicate payment detected via webhook: order=${order.orderNumber}, '
        'stored=${payment.gatewayPaymentId}, incoming=$incomingPaymentId. '
        'Auto-refund job created.',
        level: LogLevel.warning,
      );
    } catch (e) {
      session.log(
        'Failed to create auto-refund job from webhook: $e',
        level: LogLevel.error,
      );
    }
  }

  Future<void> _handlePaymentLinkLifecycle(
    Session session,
    Map<String, dynamic> payload,
    String event,
  ) async {
    try {
      final paymentLinkEntity =
          payload['payload']?['payment_link']?['entity'] as Map<String, dynamic>?;
      if (paymentLinkEntity == null) return;

      final notes = paymentLinkEntity['notes'] as Map<String, dynamic>?;
      final orderNumber = notes?['order_id']?.toString();
      if (orderNumber == null || orderNumber.isEmpty) return;

      if (event == 'payment_link.cancelled') {
        session.log(
          'payment_link.cancelled for order $orderNumber',
          level: LogLevel.info,
        );

        final orderRow = await CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        if (orderRow == null || orderRow.orderStatus == 'cancelled') return;

        final now = DateTime.now().toUtc();
        await CustomerOrderRow.db.updateRow(
          session,
          orderRow.copyWith(
            orderStatus: 'cancelled',
            paymentStatus: 'cancelled',
            cancelledAt: now,
            cancellationReason: 'PAYMENT_LINK_CANCELLED',
            updatedAt: now,
          ),
        );
      } else if (event == 'payment_link.expired') {
        session.log(
          'payment_link.expired for order $orderNumber',
          level: LogLevel.info,
        );
        // expireExpiredLinks cron will handle this as fallback
      }
    } catch (e) {
      session.log(
        'payment_link lifecycle handler error: $e',
        level: LogLevel.error,
      );
    }
  }
}
