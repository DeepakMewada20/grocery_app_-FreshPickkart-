import 'dart:math';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class PostgresDeliveryOtpService {
  static const int otpLength = 6;
  static const int otpValidityMinutes = 10;
  static const int resendCooldownSeconds = 60;
  static const int maxResends = 5;

  final Random _secure = Random.secure();

  Future<Map<String, dynamic>> generateOtp({
    required Session session,
    required String orderNumber,
    required UuidValue adminUserId,
    required String customerName,
    required double orderAmount,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) {
      throw ArgumentError('Order not found: $orderNumber');
    }

    // Deactivate any existing active OTPs for this order
    await DeliveryOtpRow.db.updateWhere(
      session,
      columnValues: (t) => [t.isActive(false)],
      where: (t) =>
          t.orderId.equals(orderRow.id!) & t.isActive.equals(true),
    );

    // Generate secure OTP
    final otp = _generateSecureOtp();
    final otpHash = _hashOtp(otp);
    final expiresAt = DateTime.now().toUtc().add(
      Duration(minutes: otpValidityMinutes),
    );

    await DeliveryOtpRow.db.insertRow(
      session,
      DeliveryOtpRow(
        orderId: orderRow.id!,
        otpHash: otpHash,
        expiresAt: expiresAt,
        generatedByAdminId: adminUserId,
      ),
    );

    // Save plain OTP and expiry to order row for user app display
    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        deliveryOtp: otp,
        deliveryOtpExpiresAt: expiresAt,
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    return {
      'otp': otp,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> verifyOtp({
    required Session session,
    required String orderNumber,
    required String otp,
    required UuidValue adminUserId,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) {
      throw ArgumentError('Order not found: $orderNumber');
    }

    final activeOtp = await DeliveryOtpRow.db.findFirstRow(
      session,
      where: (t) =>
          t.orderId.equals(orderRow.id!) &
          t.isActive.equals(true),
    );

    if (activeOtp == null) {
      throw StateError('No active OTP found for this order. Please generate a new OTP.');
    }

    if (activeOtp.expiresAt.isBefore(DateTime.now().toUtc())) {
      await DeliveryOtpRow.db.updateRow(
        session,
        activeOtp.copyWith(isActive: false),
      );
      throw StateError('OTP has expired. Please generate a new OTP.');
    }

    final hashedInput = _hashOtp(otp);
    if (hashedInput != activeOtp.otpHash) {
      throw ArgumentError('Invalid OTP. Please try again.');
    }

    // Verify OTP
    final now = DateTime.now().toUtc();
    await DeliveryOtpRow.db.updateRow(
      session,
      activeOtp.copyWith(
        isActive: false,
        verifiedAt: now,
        verifiedByAdminId: adminUserId,
      ),
    );

    // Clear OTP from order row
    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        deliveryOtp: null,
        deliveryOtpExpiresAt: null,
        updatedAt: now,
      ),
    );

    return {
      'verified': true,
      'verifiedAt': now.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> resendOtp({
    required Session session,
    required String orderNumber,
    required UuidValue adminUserId,
    required String customerName,
    required double orderAmount,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) {
      throw ArgumentError('Order not found: $orderNumber');
    }

    // Check cooldown
    final lastOtp = await DeliveryOtpRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    if (lastOtp != null) {
      final elapsed = DateTime.now().toUtc().difference(lastOtp.createdAt);
      if (elapsed.inSeconds < resendCooldownSeconds) {
        final remaining = resendCooldownSeconds - elapsed.inSeconds;
        throw StateError(
          'Please wait $remaining seconds before requesting a new OTP.',
        );
      }
    }

    // Deactivate old active OTP
    await DeliveryOtpRow.db.updateWhere(
      session,
      columnValues: (t) => [t.isActive(false)],
      where: (t) =>
          t.orderId.equals(orderRow.id!) & t.isActive.equals(true),
    );

    // Check resend limit
    final resentCount = await DeliveryOtpRow.db.count(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );
    if (resentCount >= maxResends + 1) {
      throw StateError('Maximum OTP resend limit reached (${maxResends + 1} attempts).');
    }

    // Generate new OTP
    final otp = _generateSecureOtp();
    final otpHash = _hashOtp(otp);
    final expiresAt = DateTime.now().toUtc().add(
      Duration(minutes: otpValidityMinutes),
    );

    final newOtp = await DeliveryOtpRow.db.insertRow(
      session,
      DeliveryOtpRow(
        orderId: orderRow.id!,
        otpHash: otpHash,
        expiresAt: expiresAt,
        generatedByAdminId: adminUserId,
        resendCount: resentCount,
      ),
    );

    // Update order row with new OTP and expiry
    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        deliveryOtp: otp,
        deliveryOtpExpiresAt: expiresAt,
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    return {
      'otp': otp,
      'expiresAt': expiresAt.toIso8601String(),
      'resendCount': newOtp.resendCount,
    };
  }

  Future<Map<String, dynamic>?> getActiveOtp({
    required Session session,
    required String orderNumber,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) return null;

    final activeOtp = await DeliveryOtpRow.db.findFirstRow(
      session,
      where: (t) =>
          t.orderId.equals(orderRow.id!) &
          t.isActive.equals(true),
    );

    if (activeOtp == null) return null;

    return {
      'expiresAt': activeOtp.expiresAt.toIso8601String(),
      'isActive': activeOtp.isActive,
      'verifiedAt': activeOtp.verifiedAt?.toIso8601String(),
    };
  }

  String _generateSecureOtp() {
    final min = _minOtp();
    final max = _maxOtp();
    final code = min + _secure.nextInt(max - min);
    return code.toString();
  }

  int _minOtp() {
    var value = 1;
    for (var i = 1; i < otpLength; i++) {
      value *= 10;
    }
    return value;
  }

  int _maxOtp() {
    var value = 1;
    for (var i = 0; i < otpLength; i++) {
      value *= 10;
    }
    return value;
  }

  String _hashOtp(String otp) {
    final bytes = utf8.encode(otp);
    return sha256.convert(bytes).toString();
  }
}
