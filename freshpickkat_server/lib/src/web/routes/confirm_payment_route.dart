import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_support.dart';

class ConfirmPaymentRoute extends Route {
  ConfirmPaymentRoute() : super(methods: {Method.post});

  final PostgresPaymentService _payments = PostgresPaymentService();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    try {
      final bodyText = await request.readAsString();
      final body = jsonDecode(bodyText) as Map<String, dynamic>;

      final token = body['token'] as String? ?? '';
      final razorpayPaymentId = body['razorpay_payment_id'] as String? ?? '';
      final razorpayOrderId = body['razorpay_order_id'] as String? ?? '';
      final razorpaySignature = body['razorpay_signature'] as String? ?? '';
      final paidByName = body['paidByName'] as String?;
      final paidByPhone = body['paidByPhone'] as String?;
      final paidByEmail = body['paidByEmail'] as String?;

      if (token.isEmpty ||
          razorpayPaymentId.isEmpty ||
          razorpayOrderId.isEmpty ||
          razorpaySignature.isEmpty) {
        return _jsonResponse({'success': false, 'message': 'Missing required parameters.'});
      }

      // Validate payment link
      final linkRows = await session.db.unsafeQuery(
        'SELECT * FROM "payment_link" WHERE "token" = @token LIMIT 1',
        parameters: QueryParameters.named({'token': token}),
      );
      if (linkRows.isEmpty) {
        return _jsonResponse({'success': false, 'message': 'Payment link not found.'});
      }

      final linkMap = linkRows.first.toColumnMap();
      if (linkMap['isUsed'] as bool? ?? false) {
        return _jsonResponse({'success': false, 'message': 'This payment link has already been used.'});
      }

      final expiresAtStr = linkMap['expiresAt']?.toString();
      if (expiresAtStr != null) {
        final expiresAt = DateTime.tryParse(expiresAtStr)?.toUtc();
        if (expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt)) {
          return _jsonResponse({'success': false, 'message': 'This payment link has expired.'});
        }
      }

      final orderIdStr = linkMap['orderId']?.toString() ?? '';
      final parsedOrderId = tryParseUuid(orderIdStr);
      if (parsedOrderId == null) {
        return _jsonResponse({'success': false, 'message': 'Invalid order reference.'});
      }

      final orderRow = await session.db.unsafeQuery(
        'SELECT "orderNumber" FROM "customer_order" WHERE "id" = @id LIMIT 1',
        parameters: QueryParameters.named({'id': parsedOrderId.toJson()}),
      );
      if (orderRow.isEmpty) {
        return _jsonResponse({'success': false, 'message': 'Order not found.'});
      }

      final orderNumber = orderRow.first.toColumnMap()['orderNumber'] as String? ?? '';

      // Verify payment via Razorpay signature
      final result = await _payments.verifyPaymentFromLink(
        session,
        orderNumber: orderNumber,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
        paidByName: paidByName,
        paidByPhone: paidByPhone,
        paidByEmail: paidByEmail,
        paymentLinkToken: token,
      );

      return _jsonResponse({
        'success': result['success'] == true && result['verified'] == true,
        'message': result['success'] == true && result['verified'] == true
            ? 'Payment confirmed successfully.'
            : result['message'] as String? ?? 'Payment verification failed.',
      });
    } catch (e) {
      return _jsonResponse({'success': false, 'message': 'Server error. Please contact support.'});
    }
  }

  Result _jsonResponse(Map<String, dynamic> data) {
    return Response.ok(
      body: Body.fromString(
        jsonEncode(data),
        mimeType: MimeType.json,
      ),
    );
  }
}
