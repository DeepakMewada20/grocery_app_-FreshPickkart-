import 'package:freshpickkat_flutter/payment/models/payment_request.dart';
import 'package:freshpickkat_flutter/payment/models/payment_result.dart';

abstract class PaymentPlatform {
  Future<PaymentResult> startPayment(PaymentRequest request);
  void dispose();
}
