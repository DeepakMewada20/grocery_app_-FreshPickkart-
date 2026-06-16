import 'dart:convert';
import 'dart:io';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class PaymentLinkService {
  PaymentLinkService._();

  static PaymentLinkService get instance => Get.isRegistered<PaymentLinkService>()
      ? Get.find<PaymentLinkService>()
      : Get.put(PaymentLinkService._(), permanent: true);

  final _client = ServerpodClient().client;
  String get _baseUrl => ServerpodClient.baseUrl;

  /// Create an order with a shareable payment link.
  /// Returns a map with payment link details.
  Future<Map<String, dynamic>> createShareablePaymentLink({
    required Order draftOrder,
    required String idempotencyKey,
    required double amount,
    required String customerPhone,
  }) async {
    final httpClient = HttpClient();

    try {
      final uri = Uri.parse('$_baseUrl/api/v1/payment-link/create-shareable-payment-link');
      final request = await httpClient.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');

      final body = jsonEncode({
        'order': draftOrder.toJson(),
        'idempotencyKey': idempotencyKey,
        'amount': amount,
        'customerPhone': customerPhone,
      });
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final result = jsonDecode(responseBody) as Map<String, dynamic>;

      return result;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      httpClient.close();
    }
  }
}
