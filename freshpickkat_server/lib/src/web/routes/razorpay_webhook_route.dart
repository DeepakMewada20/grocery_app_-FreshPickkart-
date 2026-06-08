import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../services/env_service.dart';
import '../../services/postgres/postgres_payment_service.dart';
import '../../services/postgres/postgres_refund_service.dart';

class RazorpayWebhookRoute extends Route {
  RazorpayWebhookRoute() : super(methods: {Method.post});

  final PostgresPaymentService _payments = PostgresPaymentService();
  final PostgresRefundService _refunds = PostgresRefundService();

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

    if (_isRefundProcessedEvent(event) || _isRefundFailedEvent(event)) {
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
        session.log(
          'Webhook: payment $paymentId already marked as paid for order $orderNumber',
          level: LogLevel.info,
        );
        return _jsonOk({'success': true, 'message': 'Already paid'});
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
        session.log(
          'Webhook: payment $paymentId successfully completed for order $orderNumber',
          level: LogLevel.info,
        );
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
}
