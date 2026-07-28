import 'dart:js_util';

Future<Map<String, dynamic>> openRazorpayCheckoutBridge(
    Map<String, dynamic> options) async {
  final jsOptions = jsify(options);
  final promise = callMethod(globalThis, 'razorpayCheckout', [jsOptions]);
  final raw = await promiseToFuture(promise);

  if (raw is Map) {
    return Map<String, dynamic>.from(
      raw.map((k, v) => MapEntry('$k', v is Map ? Map.from(v) : v)),
    );
  }

  final map = <String, dynamic>{};
  if (raw == null) return map;

  try {
    final status = getProperty(raw, 'status');
    if (status != null) map['status'] = status.toString();

    final paymentId = getProperty(raw, 'razorpay_payment_id');
    if (paymentId != null) map['razorpay_payment_id'] = paymentId.toString();

    final orderId = getProperty(raw, 'razorpay_order_id');
    if (orderId != null) map['razorpay_order_id'] = orderId.toString();

    final signature = getProperty(raw, 'razorpay_signature');
    if (signature != null) map['razorpay_signature'] = signature.toString();

    final error = getProperty(raw, 'error');
    if (error != null) {
      final errorMap = <String, dynamic>{};
      final desc = getProperty(error, 'description');
      if (desc != null) errorMap['description'] = desc.toString();
      final reason = getProperty(error, 'reason');
      if (reason != null) errorMap['reason'] = reason.toString();
      final metadata = getProperty(error, 'metadata');
      if (metadata != null) {
        if (metadata is Map) {
          errorMap['metadata'] = Map<String, dynamic>.from(metadata);
        } else {
          final metaPaymentId = getProperty(metadata, 'payment_id');
          if (metaPaymentId != null) {
            errorMap['metadata'] = {'payment_id': metaPaymentId.toString()};
          }
        }
      }
      map['error'] = errorMap;
    }
  } catch (_) {}

  return map;
}
