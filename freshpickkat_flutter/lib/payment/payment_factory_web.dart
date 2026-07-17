import 'package:freshpickkat_flutter/payment/platform/payment_platform.dart';
import 'package:freshpickkat_flutter/payment/platform/web_payment_platform.dart';

PaymentPlatform createPaymentPlatform() => WebPaymentPlatform();
