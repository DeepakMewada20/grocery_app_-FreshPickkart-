import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PendingPaymentRecord {
  PendingPaymentRecord({
    required this.paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.createdAt,
    required this.razorpayOrderId,
    this.signature,
    this.retryCount = 0,
    this.lastError,
  });

  final String paymentId;
  final String userId;
  final String orderId;
  final double amount;
  final DateTime createdAt;
  final String razorpayOrderId;
  final String? signature;
  final int retryCount;
  final String? lastError;

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'razorpayOrderId': razorpayOrderId,
      'signature': signature,
      'retryCount': retryCount,
      'lastError': lastError,
    };
  }

  factory PendingPaymentRecord.fromMap(Map<String, dynamic> map) {
    return PendingPaymentRecord(
      paymentId: (map['paymentId'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      orderId: (map['orderId'] ?? '').toString(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      razorpayOrderId: (map['razorpayOrderId'] ?? '').toString(),
      signature: map['signature']?.toString(),
      retryCount: (map['retryCount'] as num?)?.toInt() ?? 0,
      lastError: map['lastError']?.toString(),
    );
  }

  PendingPaymentRecord copyWith({
    int? retryCount,
    String? lastError,
  }) {
    return PendingPaymentRecord(
      paymentId: paymentId,
      userId: userId,
      orderId: orderId,
      amount: amount,
      createdAt: createdAt,
      razorpayOrderId: razorpayOrderId,
      signature: signature,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }
}

class PaymentRecoveryRepository {
  PaymentRecoveryRepository._();

  static PaymentRecoveryRepository get instance =>
      Get.isRegistered<PaymentRecoveryRepository>()
          ? Get.find<PaymentRecoveryRepository>()
          : Get.put(PaymentRecoveryRepository._(), permanent: true);

  static const String _localPendingPaymentsKey = 'pending_payment_recovery_v1';

  final GetStorage _storage = GetStorage();

  Future<void> cachePendingPaymentLocally(PendingPaymentRecord record) async {
    final items = _readPendingPaymentMaps();
    items.removeWhere((item) => item['paymentId'] == record.paymentId);
    items.add(record.toJson());
    await _storage.write(_localPendingPaymentsKey, items);
  }

  Future<List<PendingPaymentRecord>> readLocalPendingPaymentsForUser(
    String userId,
  ) async {
    return _readPendingPaymentMaps()
        .where((item) => item['userId']?.toString() == userId)
        .map(PendingPaymentRecord.fromMap)
        .where(
          (item) =>
              item.paymentId.isNotEmpty &&
              item.orderId.isNotEmpty &&
              item.razorpayOrderId.isNotEmpty,
        )
        .toList();
  }

  Future<void> removeLocalPendingPayment(String paymentId) async {
    final items = _readPendingPaymentMaps();
    items.removeWhere((item) => item['paymentId'] == paymentId);
    await _storage.write(_localPendingPaymentsKey, items);
  }

  Future<void> updateLocalRetry(
    String paymentId, {
    required int retryCount,
    String? lastError,
  }) async {
    final items = _readPendingPaymentMaps();
    final index = items.indexWhere((item) => item['paymentId'] == paymentId);
    if (index == -1) return;
    final updated = Map<String, dynamic>.from(items[index])
      ..['retryCount'] = retryCount
      ..['lastError'] = lastError;
    items[index] = updated;
    await _storage.write(_localPendingPaymentsKey, items);
  }

  List<Map<String, dynamic>> _readPendingPaymentMaps() {
    final raw = _storage.read(_localPendingPaymentsKey);
    if (raw is! List) return <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
