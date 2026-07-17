class PaymentRequest {
  final String keyId;
  final int amountPaise;
  final String currency;
  final String razorpayOrderId;
  final String customerPhone;
  final String customerEmail;
  final String orderId;
  final String? upiAppPackageName;
  final String? vpa;

  const PaymentRequest({
    required this.keyId,
    required this.amountPaise,
    required this.currency,
    required this.razorpayOrderId,
    required this.customerPhone,
    required this.customerEmail,
    required this.orderId,
    this.upiAppPackageName,
    this.vpa,
  });
}
