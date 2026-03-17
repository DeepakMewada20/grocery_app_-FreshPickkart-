import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentConfig {
  static const String razorpayKeyId =
      String.fromEnvironment('RAZORPAY_KEY_ID');
  static const String functionsRegion =
      String.fromEnvironment('FIREBASE_FUNCTIONS_REGION');
  static const String razorpayKeyEndpoint =
      String.fromEnvironment('RAZORPAY_KEY_ENDPOINT');

  static String? _cachedKeyId;

  static bool get hasRazorpayKey =>
      razorpayKeyId.isNotEmpty ||
      dotenv.env['RAZORPAY_KEY_ID']?.isNotEmpty == true ||
      dotenv.env['RAZORPAY_KEY']?.isNotEmpty == true ||
      (_cachedKeyId?.isNotEmpty ?? false);

  static Future<String?> getRazorpayKeyId() async {
    if (razorpayKeyId.isNotEmpty) return razorpayKeyId;
    final envKey =
        dotenv.env['RAZORPAY_KEY_ID'] ?? dotenv.env['RAZORPAY_KEY'];
    if (envKey != null && envKey.isNotEmpty) return envKey;
    if (_cachedKeyId != null && _cachedKeyId!.isNotEmpty) {
      return _cachedKeyId;
    }

    final endpoint = _resolveKeyEndpoint();
    if (endpoint == null || endpoint.isEmpty) return null;

    final keyId = await _fetchKeyId(endpoint);
    if (keyId != null && keyId.isNotEmpty) {
      _cachedKeyId = keyId;
    }
    return keyId;
  }

  static String? _resolveKeyEndpoint() {
    if (razorpayKeyEndpoint.isNotEmpty) return razorpayKeyEndpoint;
    try {
      final app = Firebase.app();
      final projectId = app.options.projectId;
      if (projectId.trim().isEmpty) return null;
      final region =
          functionsRegion.isNotEmpty ? functionsRegion : 'us-central1';
      return 'https://$region-$projectId.cloudfunctions.net/getRazorpayKeyId';
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _fetchKeyId(String endpoint) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(endpoint));
      final response = await request.close();
      if (response.statusCode != 200) return null;
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      if (data is Map<String, dynamic> && data['keyId'] != null) {
        return data['keyId'].toString();
      }
      return null;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
