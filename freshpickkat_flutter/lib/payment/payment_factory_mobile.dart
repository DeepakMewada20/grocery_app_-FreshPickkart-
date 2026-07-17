import 'package:freshpickkat_flutter/payment/platform/payment_platform.dart';
import 'package:freshpickkat_flutter/payment/platform/mobile_payment_platform.dart';

PaymentPlatform createPaymentPlatform() => MobilePaymentPlatform();
