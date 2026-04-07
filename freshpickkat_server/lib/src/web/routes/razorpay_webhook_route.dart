import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'package:serverpod/serverpod.dart';

import '../../services/env_service.dart';
import '../../services/firebase_service.dart';
import '../../services/payments/payment_recovery_service.dart';

class RazorpayWebhookRoute extends Route {
  RazorpayWebhookRoute() : super(methods: {Method.post});

  final PaymentRecoveryService _recovery = PaymentRecoveryService();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final secret = EnvService.get('RAZORPAY_WEBHOOK_SECRET');
    if (secret == null || secret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString('Missing RAZORPAY_WEBHOOK_SECRET'),
      );
    }

    final signature = _firstHeader(
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

    final orderId = _extractOrderId(payload);
    if (orderId == null || orderId.isEmpty) {
      return _jsonOk({'success': true, 'message': 'Order id not found'});
    }

    final orderDoc = await _getOrderDoc(orderId);
    final currentStatus = orderDoc?.fields?['paymentStatus']?.stringValue;

    final paymentId = _extractPaymentId(payload);
    final razorpayOrderId = _extractRazorpayOrderId(payload);
    final amountPaise = _extractAmountPaise(payload);
    final currency = _extractCurrency(payload);

    if (_isPaidEvent(event) && orderDoc?.fields != null) {
      if (currency != null && currency.toUpperCase() != 'INR') {
        return Response.badRequest(
          body: Body.fromString('Invalid currency'),
        );
      }
      if (amountPaise != null) {
        final expected =
            (_getDoubleValue(orderDoc!.fields!, 'finalAmount') * 100).round();
        if ((expected - amountPaise).abs() > 1) {
          return Response.badRequest(
            body: Body.fromString('Amount mismatch'),
          );
        }
      }
    }

    if (_isPaidEvent(event)) {
      if (currentStatus == 'paid' && paymentId != null && paymentId.isNotEmpty) {
        return _jsonOk({'success': true, 'message': 'Already paid'});
      }
    } else if (_isFailedEvent(event)) {
      await _recovery.markPaymentFailed(
        orderId,
        paymentId: paymentId,
        reason: 'Webhook payment failed',
      );
    } else if (_isRefundEvent(event)) {
      await _updateOrder(orderId, {
        'paymentStatus': firestore_api.Value(stringValue: 'refunded'),
      });
    } else if (_isPaidEvent(event) &&
        paymentId != null &&
        paymentId.isNotEmpty &&
        razorpayOrderId != null &&
        razorpayOrderId.isNotEmpty) {
      await _recovery.handleWebhookPaidEvent(
        orderId: orderId,
        paymentId: paymentId,
        razorpayOrderId: razorpayOrderId,
      );
    } else if (_isRefundProcessedEvent(event) || _isRefundFailedEvent(event)) {
      if (paymentId != null && paymentId.isNotEmpty) {
        final refundId = _extractRefundId(payload);
        await _recovery.handleRefundWebhook(
          paymentId: paymentId,
          status: _isRefundProcessedEvent(event) ? 'processed' : 'failed',
          gatewayRefundId: refundId,
        );
      }
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

  String? _extractOrderId(Map<String, dynamic> payload) {
    final orderEntity =
        payload['payload']?['order']?['entity'] as Map<String, dynamic>?;
    final receipt = orderEntity?['receipt']?.toString();
    if (receipt != null && receipt.isNotEmpty) return receipt;

    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    final notes = paymentEntity?['notes'] as Map<String, dynamic>?;
    final orderId = notes?['order_id']?.toString();
    return orderId;
  }

  String? _extractPaymentId(Map<String, dynamic> payload) {
    final paymentEntity =
        payload['payload']?['payment']?['entity'] as Map<String, dynamic>?;
    return paymentEntity?['id']?.toString();
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
    return event == 'payment.captured' || event == 'order.paid';
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

  Future<firestore_api.Document?> _getOrderDoc(String orderId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    final docPath = '$database/orders/$orderId';
    try {
      return await firestore.projects.databases.documents.get(docPath);
    } catch (_) {
      return null;
    }
  }

  double _getDoubleValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  Future<void> _updateOrder(
    String orderId,
    Map<String, firestore_api.Value> fields,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    final docPath = '$database/orders/$orderId';
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
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
