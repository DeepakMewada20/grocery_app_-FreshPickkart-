import 'dart:io';
import 'dart:math';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../payments/payment_gateway_service.dart';
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
    String? generatedBy,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderId),
      );
      if (orderRow?.id == null) {
        return {'success': false, 'error': 'Order not found'};
      }

      // Security: reject if order is already paid or cancelled
      if (orderRow!.paymentStatus == 'paid') {
        return {'success': false, 'error': 'Order is already paid'};
      }
      if (orderRow.orderStatus == 'cancelled') {
        return {'success': false, 'error': 'Order has been cancelled'};
      }

      // Check if a valid active link already exists (one active link per order)
      final existing = await _getExistingLink(session, orderRow.id!);
      if (existing != null) {
        final isExpired = existing['expiresAt'] != null &&
            DateTime.now().toUtc().isAfter(
              DateTime.parse(existing['expiresAt'] as String).toUtc(),
            );
        final isUsed = existing['isUsed'] == true;
        if (!isExpired && !isUsed) {
          return {
            'success': true,
            'token': existing['token'],
            'paymentLink': existing['paymentLink'],
            'expiresAt': existing['expiresAt'],
            'orderId': orderId,
          };
        }
        // Existing link is expired/used — allow creating a new one
      }

      final now = DateTime.now().toUtc();
      final expiresAt =
          now.add(expiryDuration ?? defaultExpiry);
      final token = generateSecureToken();
      final baseUrl = await _getBaseUrl(session);
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
        'Payment link created for order $orderId: $paymentLink',
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

  /// Create a Razorpay Payment Link (hosted rzp.io page).
  /// Used when ENABLE_WEB_CHECKOUT=false.
  Future<Map<String, dynamic>> createRazorpayPaymentLink(
    Session session, {
    required String orderNumber,
    required int amountInPaise,
    required String customerPhone,
    String customerName = '',
    String customerEmail = '',
    String? generatedBy,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return {'success': false, 'error': 'Order not found'};
      }

      // Security: reject if order is already paid or cancelled
      if (orderRow!.paymentStatus == 'paid') {
        return {'success': false, 'error': 'Order is already paid'};
      }
      if (orderRow.orderStatus == 'cancelled') {
        return {'success': false, 'error': 'Order has been cancelled'};
      }

      // Check if a valid active link already exists (one active link per order)
      final existing = await _getExistingLink(session, orderRow.id!);
      if (existing != null) {
        final isExpired = existing['expiresAt'] != null &&
            DateTime.now().toUtc().isAfter(
              DateTime.parse(existing['expiresAt'] as String).toUtc(),
            );
        final isUsed = existing['isUsed'] == true;
        if (!isExpired && !isUsed) {
          return {
            'success': true,
            'token': existing['token'],
            'paymentLink': existing['paymentLink'],
            'expiresAt': existing['expiresAt'],
            'orderId': orderNumber,
          };
        }
        // Existing link is expired/used — allow creating a new one
      }

      final gateway = PaymentGatewayService();
      final now = DateTime.now().toUtc();
      final expiresAt = now.add(const Duration(minutes: 20));
      final token = generateSecureToken();

      // Call Razorpay Payment Links API
      final response = await gateway.createPaymentLink(
        amountInPaise: amountInPaise,
        description: 'Order #$orderNumber',
        customer: {
          'name': customerName,
          'contact': customerPhone,
          'email': customerEmail,
        },
        notes: {
          'order_id': orderNumber,
          'token': token,
        },
        expiryMinutes: 20,
      );

      if (response['statusCode'] != 200) {
        session.log(
          'Failed to create Razorpay payment link: ${response['body']}',
          level: LogLevel.error,
        );
        return {
          'success': false,
          'error': 'Failed to create payment link',
          'details': response['body']?.toString(),
        };
      }

      final data = response['data'] as Map<String, dynamic>;
      final razorpayPaymentLinkId = data['id']?.toString() ?? '';
      final razorpayPaymentLinkUrl = data['short_url']?.toString() ?? '';
      final razorpayOrderId = data['order_id']?.toString() ?? '';

      // Insert payment_link row
      await session.db.unsafeQuery(
        '''
        INSERT INTO "payment_link"
          ("orderId", "token", "expiresAt", "isUsed", "linkType",
           "razorpayPaymentLinkId", "razorpayPaymentLinkUrl",
           "generatedBy", "createdAt", "updatedAt")
        VALUES
          (@orderId, @token, @expiresAt, false, 'razorpay',
           @razorpayPaymentLinkId, @razorpayPaymentLinkUrl,
           @generatedBy, @now, @now)
        ''',
        parameters: QueryParameters.named({
          'orderId': orderRow.id!.toJson(),
          'token': token,
          'expiresAt': expiresAt.toIso8601String(),
          'razorpayPaymentLinkId': razorpayPaymentLinkId,
          'razorpayPaymentLinkUrl': razorpayPaymentLinkUrl,
          'generatedBy': generatedBy,
          'now': now.toIso8601String(),
        }),
      );

      // Update PaymentTransactionRow with the Razorpay order ID
      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow.id!),
      );
      if (paymentRow != null) {
        await PaymentTransactionRow.db.updateRow(
          session,
          paymentRow.copyWith(
            gatewayOrderId: razorpayOrderId,
            paymentStatus: 'pending',
            gatewayStatus: 'created',
            updatedAt: now,
          ),
        );
      }

      // Update order with payment mode and expiry
      await CustomerOrderRow.db.updateRow(
        session,
        orderRow.copyWith(
          paymentMode: 'THIRD_PARTY_LINK',
          paymentExpiresAt: expiresAt,
          updatedAt: now,
        ),
      );

      session.log(
        'Razorpay payment link created for order $orderNumber: $razorpayPaymentLinkUrl',
        level: LogLevel.info,
      );

      return {
        'success': true,
        'token': token,
        'paymentLink': razorpayPaymentLinkUrl,
        'razorpayPaymentLinkId': razorpayPaymentLinkId,
        'razorpayOrderId': razorpayOrderId,
        'expiresAt': expiresAt.toIso8601String(),
        'orderId': orderNumber,
      };
    } catch (error) {
      session.log(
        'Failed to create Razorpay payment link: $error',
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
      final orderId = linkMap['orderId']?.toString() ?? '';
      final expiresAtStr = linkMap['expiresAt']?.toString();
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
        final orderIdStr = map['orderId']?.toString();
        if (orderIdStr == null || orderIdStr.isEmpty) continue;

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

  /// Initialize a payment session for a newly created pending order.
  /// Generates and stores a [paymentSessionId] UUID on the order row.
  Future<void> initializePaymentSession(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null || row.id == null) return;

    final uuidResult = await session.db.unsafeQuery(
      'SELECT gen_random_uuid()::text AS id',
    );
    final uuidStr = uuidResult.first.toColumnMap()['id'] as String? ?? '';

    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        paymentSessionId: UuidValue.fromString(uuidStr),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Get or create a payment link for a pending order.
  /// Returns the existing ACTIVE link if one exists, otherwise creates a new one.
  /// Rejects if linkStatus is DISABLED or EXPIRED.
  Future<Map<String, dynamic>> getOrCreatePaymentLink(
    Session session, {
    required String orderNumber,
    String? generatedBy,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow?.id == null) {
      return {'success': false, 'error': 'Order not found'};
    }

    if (orderRow!.paymentStatus == 'paid') {
      return {'success': false, 'error': 'This order has already been paid.'};
    }
    if (orderRow.linkStatus == 'DISABLED') {
      return {'success': false, 'error': 'This payment link has been disabled.'};
    }
    if (orderRow.linkStatus == 'EXPIRED') {
      return {'success': false, 'error': 'This payment link has expired.'};
    }

    // Check if an existing active link exists on this order
    final existing = await _getExistingLink(session, orderRow.id!);
    if (existing != null) {
      final isExpired = existing['expiresAt'] != null &&
          DateTime.now().toUtc().isAfter(
            DateTime.parse(existing['expiresAt'] as String).toUtc(),
          );
      final isUsed = existing['isUsed'] == true;
      if (!isExpired && !isUsed) {
        // Reuse the existing link — update customer_order fields if not set
        if (orderRow.paymentLinkUrl == null) {
          await CustomerOrderRow.db.updateRow(
            session,
            orderRow.copyWith(
              paymentLinkId: tryParseUuid(existing['paymentLinkId'] as String? ?? ''),
              paymentLinkUrl: existing['paymentLink'] as String?,
              paymentLinkExpiresAt: existing['expiresAt'] != null
                  ? DateTime.parse(existing['expiresAt'] as String).toUtc()
                  : null,
              linkStatus: 'ACTIVE',
              updatedAt: DateTime.now().toUtc(),
            ),
          );
        }
        return {
          'success': true,
          'token': existing['token'],
          'paymentLink': existing['paymentLink'],
          'expiresAt': existing['expiresAt'],
          'orderId': orderNumber,
        };
      }
    }

    // No active link exists — create a new one
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(defaultExpiry);
    final token = generateSecureToken();
    final baseUrl = await _getBaseUrl(session);
    final paymentLink = '$baseUrl/pay/$token';

    await session.db.unsafeQuery(
      '''
      INSERT INTO "payment_link"
        ("orderId", "token", "expiresAt", "linkStatus", "isUsed", "createdAt", "updatedAt")
      VALUES
        (@orderId, @token, @expiresAt, 'ACTIVE', false, @now, @now)
      ''',
      parameters: QueryParameters.named({
        'orderId': orderRow.id!.toJson(),
        'token': token,
        'expiresAt': expiresAt.toIso8601String(),
        'now': now.toIso8601String(),
      }),
    );

    // Retrieve the new link row to get its id
    final linkRows = await session.db.unsafeQuery(
      'SELECT id FROM "payment_link" WHERE "token" = @token LIMIT 1',
      parameters: QueryParameters.named({'token': token}),
    );
    final linkId = linkRows.isNotEmpty
        ? (linkRows.first.toColumnMap()['id'] as String?)
        : null;

    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        paymentMode: 'shareable_link',
        paymentSessionId: orderRow.paymentSessionId ??
            UuidValue.fromString(
              (await session.db.unsafeQuery('SELECT gen_random_uuid()::text AS id'))
                  .first
                  .toColumnMap()['id'] as String,
            ),
        paymentLinkId: linkId != null ? tryParseUuid(linkId) : null,
        paymentLinkUrl: paymentLink,
        paymentLinkExpiresAt: expiresAt,
        linkStatus: 'ACTIVE',
        paymentExpiresAt: expiresAt,
        updatedAt: now,
      ),
    );

    session.log(
      'Payment link created for order $orderNumber: $paymentLink',
      level: LogLevel.info,
    );

    return {
      'success': true,
      'token': token,
      'paymentLink': paymentLink,
      'expiresAt': expiresAt.toIso8601String(),
      'orderId': orderNumber,
    };
  }

  /// Get the current payment session status for an order.
  Future<Map<String, dynamic>> getPaymentSessionStatus(
    Session session,
    String orderNumber,
  ) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) {
      return {'error': 'Order not found'};
    }

    final expiresAt = orderRow.paymentLinkExpiresAt;
    int expiresInSeconds = 0;
    if (expiresAt != null) {
      expiresInSeconds = expiresAt.difference(DateTime.now().toUtc()).inSeconds.clamp(0, 999999);
    }

    return {
      'orderNumber': orderRow.orderNumber,
      'finalAmount': orderRow.finalAmount,
      'paymentStatus': orderRow.paymentStatus,
      'orderStatus': orderRow.orderStatus,
      'paymentLinkUrl': orderRow.paymentLinkUrl,
      'paymentLinkExpiresAt': expiresAt?.toIso8601String(),
      'linkStatus': orderRow.linkStatus,
      'expiresInSeconds': expiresInSeconds,
    };
  }

  /// Disable the payment link for an order (sets linkStatus to DISABLED).
  Future<void> disablePaymentLink(
    Session session,
    String orderNumber, {
    Transaction? transaction,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
      transaction: transaction,
    );
    if (orderRow == null || orderRow.id == null) return;

    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        linkStatus: 'DISABLED',
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );

    // Also update the payment_link row if one exists
    final linkRows = await session.db.unsafeQuery(
      'SELECT id FROM "payment_link" WHERE "orderId" = @orderId AND "isUsed" = false ORDER BY "createdAt" DESC LIMIT 1',
      parameters: QueryParameters.named({
        'orderId': orderRow.id!.toJson(),
      }),
      transaction: transaction,
    );
    if (linkRows.isNotEmpty) {
      final linkId = linkRows.first.toColumnMap()['id'] as String?;
      if (linkId != null) {
        await session.db.unsafeQuery(
          'UPDATE "payment_link" SET "linkStatus" = \'DISABLED\', "updatedAt" = @now WHERE "id" = @id',
          parameters: QueryParameters.named({
            'id': linkId,
            'now': DateTime.now().toUtc().toIso8601String(),
          }),
          transaction: transaction,
        );
      }
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
    final token = map['token'] as String? ?? '';
    final linkType = map['linkType'] as String? ?? 'browser';

    String paymentLink;
    if (linkType == 'razorpay') {
      paymentLink = map['razorpayPaymentLinkUrl'] as String? ?? '';
    } else {
      final baseUrl = await _getBaseUrl(session);
      paymentLink = '$baseUrl/pay/$token';
    }

    return {
      'paymentLinkId': map['id']?.toString(),
      'token': token,
      'paymentLink': paymentLink,
      'expiresAt': map['expiresAt']?.toString(),
      'isUsed': map['isUsed'] as bool? ?? false,
      'linkType': linkType,
      'razorpayPaymentLinkId': map['razorpayPaymentLinkId']?.toString(),
      'razorpayPaymentLinkUrl': map['razorpayPaymentLinkUrl']?.toString(),
    };
  }

  Future<String> _getBaseUrl(Session session) async {
    try {
      final config = session.serverpod.config;
      final webConfig = config.webServer ?? config.apiServer;
      var publicHost = webConfig.publicHost;
      final publicPort = webConfig.publicPort;
      final scheme = webConfig.publicScheme;

      session.log(
        '_getBaseUrl: raw publicHost=$publicHost, publicPort=$publicPort, scheme=$scheme',
        level: LogLevel.info,
      );

      if (publicHost == '0.0.0.0' ||
          publicHost == 'localhost' ||
          publicHost == '127.0.0.1') {
        publicHost = await _resolveLocalIp();
        session.log(
          '_getBaseUrl: resolved publicHost=$publicHost',
          level: LogLevel.info,
        );
      }

      final url = publicPort == 80 || publicPort == 443
          ? '$scheme://$publicHost'
          : '$scheme://$publicHost:$publicPort';

      session.log(
        '_getBaseUrl: final URL=$url',
        level: LogLevel.info,
      );
      return url;
    } catch (e) {
      session.log(
        '_getBaseUrl: error=$e, falling back to freshpickkat.com',
        level: LogLevel.error,
      );
      return 'https://freshpickkat.com';
    }
  }

  Future<String> _resolveLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      // Prefer physical network interfaces (WiFi/Ethernet) over virtual/Docker
      String? fallback;
      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) {
            fallback ??= addr.address;
          }
        }
        // Skip loopback, docker, virtual bridge, and veth interfaces
        if (name == 'lo' ||
            name.startsWith('docker') ||
            name.startsWith('br-') ||
            name.startsWith('veth') ||
            name.startsWith('vboxnet') ||
            name.startsWith('vmnet') ||
            name.startsWith('virbr')) {
          continue;
        }
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) {
            return addr.address;
          }
        }
      }
      // If no physical interface found, use fallback (first non-loopback)
      if (fallback != null) return fallback;
    } catch (_) {}
    return 'localhost';
  }
}
