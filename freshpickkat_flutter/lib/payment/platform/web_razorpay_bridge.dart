import 'dart:js_util';

Future<Map<String, dynamic>> openRazorpayCheckoutBridge(
    Map<String, dynamic> options) async {
  final jsOptions = jsify(options);
  final promise = callMethod(globalThis, 'razorpayCheckout', [jsOptions]);
  final result = await promiseToFuture(promise);
  if (result is Map) {
    return Map<String, dynamic>.from(
      result.map((k, v) => MapEntry('$k', v is Map ? Map.from(v) : v)),
    );
  }
  return <String, dynamic>{};
}
