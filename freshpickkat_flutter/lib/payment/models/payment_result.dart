enum PaymentResultStatus { success, failed, cancelled, pending }

class PaymentResult {
  final PaymentResultStatus status;
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final String? razorpaySignature;
  final String? errorMessage;
  final String? errorCode;

  const PaymentResult({
    required this.status,
    this.razorpayPaymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    this.errorMessage,
    this.errorCode,
  });

  const PaymentResult.success({
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    this.razorpaySignature,
  }) : status = PaymentResultStatus.success,
       errorMessage = null,
       errorCode = null;

  const PaymentResult.failed({
    this.errorMessage,
    this.errorCode,
    this.razorpayPaymentId,
    this.razorpayOrderId,
  }) : status = PaymentResultStatus.failed,
       razorpaySignature = null;

  const PaymentResult.cancelled({
    this.errorMessage,
    this.errorCode,
    this.razorpayPaymentId,
    this.razorpayOrderId,
  }) : status = PaymentResultStatus.cancelled,
       razorpaySignature = null;

  const PaymentResult.pending()
      : status = PaymentResultStatus.pending,
        razorpayPaymentId = null,
        razorpayOrderId = null,
        razorpaySignature = null,
        errorMessage = null,
        errorCode = null;
}
