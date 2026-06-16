import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresPaymentLinkService {
  static const Duration defaultExpiry = Duration(minutes: 30);
  static const int _tokenByteLength = 32;
  static final Random _secureRandom = Random.secure();

  /// Generate a cryptographically secure random token string.
  String generateSecureToken() {
    final bytes = List<int>.generate(_tokenByteLength, (_) {
      const chars =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      return chars.codeUnitAt(_secureRandom.nextInt(chars.length));
    });
    return String.fromCharCodes(bytes);
  }

  /// Create a payment link record for an order.
  Future<Map<String, dynamic>> createPaymentLink(
    Session session, {
    required String orderId,
    Duration? expiryDuration,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderId),
      );
      if (orderRow?.id == null) {
        return {'success': false, 'error': 'Order not found'};
      }

      // Check if a payment link already exists for this order
      final existing = await _getExistingLink(session, orderRow!.id!);
      if (existing != null) {
        return {
          'success': true,
          'token': existing['token'],
          'paymentLink': existing['paymentLink'],
          'expiresAt': existing['expiresAt'],
          'orderId': orderId,
        };
      }

      final now = DateTime.now().toUtc();
      final expiresAt =
          now.add(expiryDuration ?? defaultExpiry);
      final token = generateSecureToken();
      final baseUrl = _getBaseUrl(session);
      final paymentLink = '$baseUrl/pay/$token';

      await session.db.unsafeQuery(
        '''
        INSERT INTO "payment_link"
          ("orderId", "token", "expiresAt", "isUsed", "createdAt", "updatedAt")
        VALUES
          (@orderId, @token, @expiresAt, false, @now, @now)
        ''',
        parameters: QueryParameters.named({
          'orderId': orderRow.id!.toJson(),
          'token': token,
          'expiresAt': expiresAt.toIso8601String(),
          'now': now.toIso8601String(),
        }),
      );

      // Update order with payment mode and expiry
      await CustomerOrderRow.db.updateRow(
        session,
        orderRow.copyWith(
          paymentMode: 'shareable_link',
          paymentExpiresAt: expiresAt,
          updatedAt: now,
        ),
      );

      session.log(
        'Payment link created for order $orderId: $token',
        level: LogLevel.info,
      );

      return {
        'success': true,
        'token': token,
        'paymentLink': paymentLink,
        'expiresAt': expiresAt.toIso8601String(),
        'orderId': orderId,
      };
    } catch (error) {
      session.log(
        'Failed to create payment link: $error',
        level: LogLevel.error,
      );
      return {'success': false, 'error': error.toString()};
    }
  }

  /// Validate a payment link token. Returns order data if valid,
  /// or an error map if invalid.
  Future<Map<String, dynamic>> validateToken(
    Session session,
    String token,
  ) async {
    try {
      final linkRows = await session.db.unsafeQuery(
        '''
        SELECT * FROM "payment_link"
        WHERE "token" = @token
        LIMIT 1
        ''',
        parameters: QueryParameters.named({'token': token}),
      );

      if (linkRows.isEmpty) {
        return {'valid': false, 'errorMessage': 'This payment link is no longer valid.'};
      }

      final linkMap = linkRows.first.toColumnMap();
      final orderId = (linkMap['orderId'] as String?) ?? '';
      final expiresAtStr = linkMap['expiresAt'] as String?;
      final isUsed = linkMap['isUsed'] as bool? ?? false;

      // Check if used
      if (isUsed) {
        return {'valid': false, 'errorMessage': 'This payment link has already been used.'};
      }

      // Check if expired
      if (expiresAtStr != null) {
        final expiresAt = DateTime.tryParse(expiresAtStr)?.toUtc();
        if (expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt)) {
          return {'valid': false, 'errorMessage': 'This payment link has expired.'};
        }
      }

      // Fetch the order
      final parsedOrderId = tryParseUuid(orderId);
      if (parsedOrderId == null) {
        return {'valid': false, 'errorMessage': 'This payment link is no longer valid.'};
      }

      final orderRow = await CustomerOrderRow.db.findById(session, parsedOrderId);
      if (orderRow == null) {
        return {'valid': false, 'errorMessage': 'This payment link is no longer valid.'};
      }

      // Check order is still unpaid
      if (orderRow.paymentStatus == 'paid') {
        return {'valid': false, 'errorMessage': 'This payment has already been completed.'};
      }

      if (orderRow.orderStatus == 'cancelled') {
        return {'valid': false, 'errorMessage': 'This order has been cancelled.'};
      }

      // Build order summary
      final addressRow = await OrderAddressRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow.id!),
      );

      final items = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderRow.id!),
      );

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow.id!),
      );

      final addressStr = addressRow == null
          ? ''
          : '${addressRow.streetLine1}, ${addressRow.city}, ${addressRow.state} - ${addressRow.postalCode}';

      final itemList = items.map((item) => {
        'productName': item.productNameSnapshot,
        'variantLabel': item.variantLabelSnapshot,
        'quantity': item.quantity,
        'unitPrice': item.unitPrice,
        'totalPrice': item.totalPrice,
        'productImage': item.productImageUrlSnapshot,
      }).toList();

      final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

      return {
        'valid': true,
        'errorMessage': null,
        'orderId': orderRow.orderNumber,
        'orderNumber': orderRow.orderNumber,
        'finalAmount': orderRow.finalAmount,
        'itemCount': orderRow.itemCount,
        'deliveryAddress': addressStr,
        'items': itemList,
        'razorpayOrderId': cleanNullableString(paymentRow?.gatewayOrderId) ?? '',
        'amountPaise': (orderRow.finalAmount * 100).round(),
        'currency': 'INR',
        'expiresAt': expiresAt?.toIso8601String(),
        'createdAt': orderRow.createdAt.toIso8601String(),
      };
    } catch (error) {
      return {'valid': false, 'errorMessage': 'This payment link is no longer valid.'};
    }
  }

  /// Mark a payment link as used after successful payment.
  Future<bool> markUsed(
    Session session,
    String token, {
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      await session.db.unsafeQuery(
        '''
        UPDATE "payment_link"
        SET "isUsed" = true,
            "usedAt" = @now,
            "paidByName" = @paidByName,
            "paidByPhone" = @paidByPhone,
            "paidByEmail" = @paidByEmail,
            "updatedAt" = @now
        WHERE "token" = @token
        ''',
        parameters: QueryParameters.named({
          'token': token,
          'now': now.toIso8601String(),
          'paidByName': paidByName,
          'paidByPhone': paidByPhone,
          'paidByEmail': paidByEmail,
        }),
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  /// Find the payment link token for a given order.
  Future<String?> getTokenForOrder(Session session, UuidValue orderId) async {
    final rows = await session.db.unsafeQuery(
      '''
      SELECT "token" FROM "payment_link"
      WHERE "orderId" = @orderId
      ORDER BY "createdAt" DESC
      LIMIT 1
      ''',
      parameters: QueryParameters.named({
        'orderId': orderId.toJson(),
      }),
    );
    if (rows.isEmpty) return null;
    return rows.first.toColumnMap()['token'] as String?;
  }

  /// Get payment link info for an order.
  Future<Map<String, dynamic>?> getPaymentLinkForOrder(
    Session session,
    String orderNumber,
  ) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow?.id == null) return null;

    return _getExistingLink(session, orderRow!.id!);
  }

  /// Mark all expired payment links and cancel their orders.
  /// Returns count of cancelled orders.
  Future<int> expireExpiredLinks(Session session) async {
    try {
      final now = DateTime.now().toUtc();
      final expiredRows = await session.db.unsafeQuery(
        '''
        SELECT pl."orderId" FROM "payment_link" pl
        JOIN "customer_order" co ON co."id" = pl."orderId"
        WHERE pl."isUsed" = false
          AND pl."expiresAt" < @now
          AND co."orderStatus" = 'payment_pending'
          AND co."paymentStatus" = 'pending'
        LIMIT 100
        ''',
        parameters: QueryParameters.named({
          'now': now.toIso8601String(),
        }),
      );

      var expiredCount = 0;
      for (final row in expiredRows) {
        final map = row.toColumnMap();
        final orderIdStr = map['orderId'] as String?;
        if (orderIdStr == null) continue;

        final parsedId = tryParseUuid(orderIdStr);
        if (parsedId == null) continue;

        final order = await CustomerOrderRow.db.findById(session, parsedId);
        if (order == null) continue;

        await session.db.transaction((transaction) async {
          // Cancel the order
          await CustomerOrderRow.db.updateRow(
            session,
            order.copyWith(
              orderStatus: 'cancelled',
              paymentStatus: 'cancelled',
              cancelledAt: now,
              cancellationReason: 'PAYMENT_LINK_EXPIRED',
              updatedAt: now,
            ),
            transaction: transaction,
          );

          // Mark payment link as used/expired
          await session.db.unsafeQuery(
            '''
            UPDATE "payment_link"
            SET "isUsed" = true,
                "usedAt" = @now,
                "updatedAt" = @now
            WHERE "orderId" = @orderId
            ''',
            parameters: QueryParameters.named({
              'orderId': parsedId.toJson(),
              'now': now.toIso8601String(),
            }),
            transaction: transaction,
          );
        });
        expiredCount++;
      }

      if (expiredCount > 0) {
        session.log(
          'Expired $expiredCount payment link(s)',
          level: LogLevel.info,
        );
      }
      return expiredCount;
    } catch (error) {
      session.log(
        'Failed to expire payment links: $error',
        level: LogLevel.error,
      );
      return 0;
    }
  }

  Future<Map<String, dynamic>?> _getExistingLink(
    Session session,
    UuidValue orderId,
  ) async {
    final rows = await session.db.unsafeQuery(
      '''
      SELECT * FROM "payment_link"
      WHERE "orderId" = @orderId
      ORDER BY "createdAt" DESC
      LIMIT 1
      ''',
      parameters: QueryParameters.named({
        'orderId': orderId.toJson(),
      }),
    );
    if (rows.isEmpty) return null;

    final map = rows.first.toColumnMap();
    return {
      'token': map['token'] as String?,
      'expiresAt': map['expiresAt']?.toString(),
      'isUsed': map['isUsed'] as bool? ?? false,
    };
  }

  String _getBaseUrl(Session session) {
    try {
      final config = session.serverpod.config;
      final publicHost = config.apiServer.publicHost;
      final port = config.apiServer.port;
      final isSecure = config.apiServer.publicPort == 443;
      final scheme = isSecure ? 'https' : 'http';
      if (port == 80 || port == 443) {
        return '$scheme://$publicHost';
      }
      return '$scheme://$publicHost:$port';
    } catch (_) {
      return 'https://freshpickkat.com';
    }
  }
}
