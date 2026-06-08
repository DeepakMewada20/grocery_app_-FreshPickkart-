import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../analytics/redis_analytics_service.dart';
import '../order_outbox_service.dart';
import '../payments/payment_gateway_service.dart';
import 'postgres_support.dart';

class PostgresPaymentService {
  PostgresPaymentService({PaymentGatewayService? gateway})
    : _gateway = gateway ?? PaymentGatewayService();

  final PaymentGatewayService _gateway;
  final RedisAnalyticsService _analytics = RedisAnalyticsService.instance;

  Future<PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderNumber,
    double amount,
    String customerPhone,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentOrderResult(success: false, error: 'Order not found');
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentOrderResult(
          success: false,
          error: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      final amountInPaise = (amount * 100).round();
      final response = await _gateway.createOrder(
        receipt: orderNumber,
        amountInPaise: amountInPaise,
        customerPhone: customerPhone,
      );

      if (response['statusCode'] != 200) {
        return PaymentOrderResult(
          success: false,
          error: 'Failed to create payment order',
          details: response['body']?.toString(),
        );
      }

      final data = response['data'] as Map<String, dynamic>;
      final razorpayOrderId = data['id']?.toString();
      final now = DateTime.now().toUtc();

      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId,
          paymentStatus: 'pending',
          gatewayStatus: data['status']?.toString() ?? 'created',
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'pending',
          updatedAt: now,
        ),
      );

      return PaymentOrderResult(
        success: true,
        razorpayOrderId: razorpayOrderId,
        amount: data['amount'] is int ? data['amount'] as int : null,
        currency: data['currency']?.toString(),
      );
    } catch (error) {
      return PaymentOrderResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// Called by the mobile client after successful Razorpay checkout.
  /// Validates the HMAC signature and sets payment to VERIFYING state.
  /// Does NOT immediately confirm the order — that requires webhook or
  /// server-side verification via [completePaymentVerification].
  Future<PaymentVerifyResult> verifyPayment(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      if (paymentRow.gatewayOrderId != null &&
          paymentRow.gatewayOrderId!.isNotEmpty &&
          paymentRow.gatewayOrderId != razorpayOrderId) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Razorpay order mismatch',
        );
      }

      if (paymentRow.paymentStatus == 'paid' &&
          resolvedOrderRow.paymentStatus == 'paid') {
        await OrderOutboxService.instance.enqueueOrderPaid(
          session: session,
          orderId: resolvedOrderRow.orderNumber,
          userId: resolvedOrderRow.userId.toString(),
          status: 'confirmed',
          amount: resolvedOrderRow.finalAmount,
          itemCount: resolvedOrderRow.itemCount,
        );
        return PaymentVerifyResult(
          success: true,
          verified: true,
          message: 'Payment already verified',
        );
      }

      if (paymentRow.paymentStatus == 'verifying') {
        return PaymentVerifyResult(
          success: true,
          verified: false,
          message: 'Payment is being verified',
        );
      }

      final shouldValidate =
          !_gateway.isTestMode && razorpaySignature.trim().isNotEmpty;
      if (shouldValidate) {
        final expected = _gateway.generateSignature(
          razorpayOrderId,
          razorpayPaymentId,
          _gateway.razorpayKeySecret,
        );
        if (expected != razorpaySignature) {
          await markPaymentFailed(session, orderNumber);
          return PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
      }

      final now = DateTime.now().toUtc();
      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId,
          gatewayPaymentId: razorpayPaymentId,
          paymentStatus: 'verifying',
          gatewayStatus: 'verifying',
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'verifying',
          orderStatus: 'payment_verification',
          updatedAt: now,
        ),
      );

      session.log(
        'Payment verification started for order $orderNumber, '
        'razorpayPaymentId: $razorpayPaymentId',
        level: LogLevel.info,
      );

      return PaymentVerifyResult(
        success: true,
        verified: false,
        message:
            'Payment is being verified. Please wait for confirmation.',
      );
    } catch (error) {
      return PaymentVerifyResult(
        success: false,
        verified: false,
        error: error.toString(),
      );
    }
  }

  /// Called by the Razorpay webhook or reconciliation cron to
  /// definitively mark a payment as successful.
  /// This is the single source of truth for order confirmation.
  Future<PaymentVerifyResult> completePaymentVerification(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    String razorpaySignature = '',
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      if (paymentRow.paymentStatus == 'paid' &&
          resolvedOrderRow.paymentStatus == 'paid') {
        return PaymentVerifyResult(
          success: true,
          verified: true,
          message: 'Payment already verified',
        );
      }

      final now = DateTime.now().toUtc();
      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId.isNotEmpty
              ? razorpayOrderId
              : paymentRow.gatewayOrderId,
          gatewayPaymentId: razorpayPaymentId.isNotEmpty
              ? razorpayPaymentId
              : paymentRow.gatewayPaymentId,
          paymentStatus: 'paid',
          gatewayStatus: 'captured',
          paidAt: now,
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'paid',
          orderStatus: 'confirmed',
          confirmedAt: now,
          updatedAt: now,
        ),
      );

      await _processPaidOrderAnalytics(
        session,
        orderNumber: resolvedOrderRow.orderNumber,
      );

      await OrderOutboxService.instance.enqueueOrderPaid(
        session: session,
        orderId: resolvedOrderRow.orderNumber,
        userId: resolvedOrderRow.userId.toString(),
        status: 'confirmed',
        amount: resolvedOrderRow.finalAmount,
        itemCount: resolvedOrderRow.itemCount,
      );

      await _finalizeSuccessfulPaymentSideEffects(
        session,
        order: resolvedOrderRow,
      );

      session.log(
        'Payment completed for order $orderNumber, '
        'razorpayPaymentId: $razorpayPaymentId',
        level: LogLevel.info,
      );

      return PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (error) {
      return PaymentVerifyResult(
        success: false,
        verified: false,
        error: error.toString(),
      );
    }
  }

  /// Mark payment as failed or cancelled.
  /// [failureType] can be 'failed' (actual payment failure) or 'user_cancelled'.
  Future<PaymentActionResult> markPaymentFailed(
    Session session,
    String orderNumber, {
    String failureType = 'failed',
    String? failureReason,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentActionResult(success: false, error: 'Order not found');
      }
      final resolvedOrderRow = orderRow!;

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(resolvedOrderRow.id!),
      );
      final now = DateTime.now().toUtc();

      final isCancelled = failureType == 'user_cancelled';

      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: isCancelled ? 'cancelled' : 'failed',
          orderStatus: 'payment_failed',
          cancelledAt: isCancelled ? now : resolvedOrderRow.cancelledAt,
          cancellationReason: isCancelled
              ? (failureReason ?? 'Payment cancelled by user')
              : (failureReason ?? 'Payment failed'),
          updatedAt: now,
        ),
      );
      if (paymentRow != null) {
        await PaymentTransactionRow.db.updateRow(
          session,
          paymentRow.copyWith(
            paymentStatus: isCancelled ? 'cancelled' : 'failed',
            gatewayStatus: isCancelled ? 'cancelled' : 'failed',
            failureReason: failureReason,
            updatedAt: now,
          ),
        );
      }

      session.log(
        'Payment $failureType for order $orderNumber'
        '${failureReason != null ? ': $failureReason' : ''}',
        level: LogLevel.info,
      );

      return PaymentActionResult(success: true);
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  /// Fetch Razorpay payment status and provide user-friendly result.
  /// Handles Scenario 3: money debited but never reached Razorpay.
  Future<PaymentActionResult> getPaymentStatusWithMessage(
    Session session,
    String orderNumber,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentActionResult(success: false, error: 'Order not found');
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );

      if (paymentRow == null) {
        return PaymentActionResult(
          success: true,
          status: 'unknown',
          message: 'Payment record not found',
        );
      }

      final gatewayPaymentId = cleanNullableString(paymentRow.gatewayPaymentId);
      if (gatewayPaymentId == null) {
        return PaymentActionResult(
          success: true,
          status: paymentRow.paymentStatus,
          message: 'Payment has not been processed yet',
        );
      }

      final statusResult = await _gateway.fetchPaymentStatus(gatewayPaymentId);
      final data = statusResult['data'];
      final gatewayStatus = data is Map<String, dynamic>
          ? data['status']?.toString().toLowerCase().trim()
          : null;

      if (gatewayStatus == 'captured' || gatewayStatus == 'authorized') {
        return PaymentActionResult(
          success: true,
          status: 'paid',
          message: 'Payment successful',
          amount: data?['amount'] is int ? data['amount'] as int : null,
          paymentId: gatewayPaymentId,
        );
      }

      if (gatewayStatus == 'failed') {
        return PaymentActionResult(
          success: true,
          status: 'failed',
          message: 'Payment failed at gateway',
          paymentId: gatewayPaymentId,
        );
      }

      if (gatewayStatus == null || gatewayStatus == 'created') {
        return PaymentActionResult(
          success: true,
          status: 'pending',
          message:
              'Amount was debited from your account but payment is not '
              'confirmed yet. Banks usually reverse such transactions '
              'automatically. Please wait and check again later.',
          paymentId: gatewayPaymentId,
        );
      }

      return PaymentActionResult(
        success: true,
        status: paymentRow.paymentStatus,
        message: 'Payment status: ${paymentRow.paymentStatus}',
        paymentId: gatewayPaymentId,
      );
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  Future<PaymentActionResult> recoverPendingPayments(
    Session session,
    String userReference, {
    int limit = 20,
  }) async {
    try {
      final appUser = await _resolveUser(session, userReference);
      if (appUser?.id == null) {
        return PaymentActionResult(
          success: true,
          status: 'checked',
          message: 'No pending payments',
        );
      }

      final rows = await PaymentTransactionRow.db.find(
        session,
        where: (t) =>
            t.userId.equals(appUser!.id!) &
            (t.paymentStatus.equals('pending') |
                t.paymentStatus.equals('verifying')),
        limit: clampPageLimit(limit, defaultLimit: 20, maxLimit: 50),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      var recovered = 0;
      var failed = 0;

      for (final row in rows) {
        final paymentId = cleanNullableString(row.gatewayPaymentId);
        if (paymentId == null) continue;

        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'];
        final status = data is Map<String, dynamic>
            ? data['status']?.toString().toLowerCase().trim()
            : null;

        final orderRow = await CustomerOrderRow.db.findById(
          session,
          row.orderId,
        );
        if (orderRow == null) continue;

        if (status == 'captured' || status == 'authorized') {
          final verifyResult = await completePaymentVerification(
            session,
            orderNumber: orderRow.orderNumber,
            razorpayOrderId: row.gatewayOrderId ?? '',
            razorpayPaymentId: paymentId,
          );
          if (verifyResult.success && verifyResult.verified) {
            recovered++;
          }
        } else if (status == 'failed' || status == 'refunded') {
          await markPaymentFailed(session, orderRow.orderNumber);
          failed++;
        }
      }

      return PaymentActionResult(
        success: true,
        status: recovered > 0 ? 'recovered' : 'checked',
        message: 'Recovered $recovered payment(s), failed $failed payment(s).',
      );
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  /// Cancel orders with PENDING payment that have exceeded the timeout.
  /// Returns the number of cancelled orders.
  Future<int> autoCancelPendingPayments(
    Session session, {
    Duration timeout = const Duration(minutes: 10),
  }) async {
    try {
      final cutoff = DateTime.now().toUtc().subtract(timeout);
      final result = await session.db.unsafeQuery(
        '''
        SELECT id FROM customer_order
        WHERE paymentStatus = @paymentStatus
          AND orderStatus = @orderStatus
          AND "createdAt" < @cutoff
        LIMIT 200
        ''',
        parameters: QueryParameters.named({
          'paymentStatus': 'pending',
          'orderStatus': 'placed',
          'cutoff': cutoff,
        }),
      );

      var cancelled = 0;
      for (final row in result) {
        final map = row.toColumnMap();
        final orderId = map['id'] as String?;
        if (orderId == null) continue;

        final parsedId = tryParseUuid(orderId);
        if (parsedId == null) continue;

        final order = await CustomerOrderRow.db.findById(session, parsedId);
        if (order == null) continue;

        final paymentRow = await PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order.id!),
        );
        final now = DateTime.now().toUtc();

        await CustomerOrderRow.db.updateRow(
          session,
          order.copyWith(
            paymentStatus: 'cancelled',
            orderStatus: 'cancelled',
            cancelledAt: now,
            cancellationReason: 'Auto-cancelled: payment timeout exceeded',
            updatedAt: now,
          ),
        );
        if (paymentRow != null) {
          await PaymentTransactionRow.db.updateRow(
            session,
            paymentRow.copyWith(
              paymentStatus: 'cancelled',
              gatewayStatus: 'cancelled',
              updatedAt: now,
            ),
          );
        }

        cancelled++;
      }

      if (cancelled > 0) {
        session.log(
          'Auto-cancelled $cancelled order(s) with pending payment',
          level: LogLevel.info,
        );
      }

      return cancelled;
    } catch (error) {
      session.log(
        'Auto-cancel failed: $error',
        level: LogLevel.error,
      );
      return 0;
    }
  }

  /// Reconcile all pending and verifying payments against Razorpay.
  /// Used by the periodic cron job.
  Future<Map<String, int>> reconcileAllPendingPayments(
    Session session, {
    int limit = 100,
  }) async {
    var recovered = 0;
    var failed = 0;
    var skipped = 0;

    try {
      final rows = await PaymentTransactionRow.db.find(
        session,
        where: (t) =>
            t.paymentStatus.equals('pending') |
            t.paymentStatus.equals('verifying'),
        limit: limit,
        orderBy: (t) => t.createdAt,
      );

      for (final row in rows) {
        final paymentId = cleanNullableString(row.gatewayPaymentId);
        if (paymentId == null) {
          skipped++;
          continue;
        }

        final orderRow = await CustomerOrderRow.db.findById(
          session,
          row.orderId,
        );
        if (orderRow == null) {
          skipped++;
          continue;
        }

        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'];
        final status = data is Map<String, dynamic>
            ? data['status']?.toString().toLowerCase().trim()
            : null;

        if (status == 'captured' || status == 'authorized') {
          final result = await completePaymentVerification(
            session,
            orderNumber: orderRow.orderNumber,
            razorpayOrderId: row.gatewayOrderId ?? '',
            razorpayPaymentId: paymentId,
          );
          if (result.success && result.verified) {
            recovered++;
          } else {
            skipped++;
          }
        } else if (status == 'failed' || status == 'refunded') {
          await markPaymentFailed(session, orderRow.orderNumber);
          failed++;
        } else {
          skipped++;
        }
      }

      session.log(
        'Payment reconciliation: $recovered recovered, $failed failed, '
        '$skipped skipped',
        level: LogLevel.info,
      );
    } catch (error) {
      session.log(
        'Payment reconciliation failed: $error',
        level: LogLevel.error,
      );
    }

    return {
      'recovered': recovered,
      'failed': failed,
      'skipped': skipped,
    };
  }

  /// Read-only: Returns aggregated payment detail for admin monitoring.
  Future<Map<String, dynamic>> getPaymentDetail(
    Session session,
    String orderNumber,
  ) async {
    final result = <String, dynamic>{};

    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (orderRow == null) {
      return {'error': 'Order not found'};
    }
    result['order'] = orderRow.toJson();

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );
    if (paymentRow != null) {
      result['paymentTransaction'] = paymentRow.toJson();
    }

    final refundRow = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 1,
    );
    if (refundRow.isNotEmpty) {
      result['refundRecord'] = refundRow.first.toJson();
    }

    final paymentId = cleanNullableString(paymentRow?.gatewayPaymentId);
    if (paymentId != null) {
      try {
        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        result['razorpayLiveStatus'] = statusResult['data'];
      } catch (_) {}
    }

    return result;
  }

  /// Read-only: Search orders by order number, phone, or customer name.
  Future<OrderPage> searchOrders(
    Session session, {
    String? query,
    String? status,
    String? paymentStatus,
    int limit = 20,
    String? pageToken,
  }) async {
    final conditions = <String>['1=1'];
    final params = <String, dynamic>{};

    final q = query?.trim();
    if (q != null && q.isNotEmpty) {
      conditions.add('co."orderNumber" ILIKE @query');
      params['query'] = '%$q%';
    }

    if (status != null && status.trim().isNotEmpty) {
      conditions.add('co."orderStatus" = @status');
      params['status'] = status.trim();
    }

    if (paymentStatus != null && paymentStatus.trim().isNotEmpty) {
      conditions.add('co."paymentStatus" = @paymentStatus');
      params['paymentStatus'] = paymentStatus.trim();
    }

    final whereClause = conditions.join(' AND ');
    final limitVal = limit.clamp(1, 100);
    final offsetVal = _decodePageToken(pageToken);

    final countResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM customer_order co WHERE $whereClause',
      parameters: QueryParameters.named({...params}),
    );
    final totalCount = countResult.isNotEmpty
        ? asInt(countResult.first.toColumnMap()['cnt'])
        : 0;

    final rows = await session.db.unsafeQuery(
      '''
      SELECT co.*
      FROM customer_order co
      WHERE $whereClause
      ORDER BY co."orderedAt" DESC
      LIMIT @limitVal OFFSET @offsetVal
      ''',
      parameters: QueryParameters.named({
        ...params,
        'limitVal': limitVal + 1,
        'offsetVal': offsetVal,
      }),
    );

    final orderRows = rows
        .map((r) => CustomerOrderRow.fromJson(r.toColumnMap()))
        .take(limitVal)
        .toList();

    String? nextPageToken;
    if (rows.length > limitVal) {
      nextPageToken = _encodePageToken(offsetVal + limitVal);
    }

    final orders = <Order>[];
    for (final row in orderRows) {
      final addressRow = await OrderAddressRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(row.id!),
      );
      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(row.id!),
      );
      final userRow = await _resolveUser(session, row.userId.toString());
      orders.add(Order(
        orderId: row.orderNumber,
        userId: row.userId.toString(),
        userName: userRow?.name,
        userPhone: userRow?.phoneNumber ?? '',
        items: const [],
        itemCount: row.itemCount,
        totalAmount: row.totalAmount,
        discountAmount: row.discountAmount,
        mrpTotal: row.mrpTotal,
        productDiscountAmount: row.productDiscountAmount,
        comboDiscountAmount: row.comboDiscountAmount,
        bogoDiscountAmount: row.bogoDiscountAmount,
        deliveryFee: row.deliveryFee,
        originalDeliveryFee: row.originalDeliveryFee,
        deliveryDiscountAmount: row.deliveryDiscountAmount,
        freeDeliveryApplied: row.freeDeliveryApplied,
        finalAmount: row.finalAmount,
        status: row.orderStatus,
        paymentStatus: row.paymentStatus,
        refundStatus: row.refundStatus,
        razorpayOrderId: cleanNullableString(paymentRow?.gatewayOrderId),
        razorpayPaymentId: cleanNullableString(paymentRow?.gatewayPaymentId),
        deliveryAddress: Address(
          street: addressRow?.streetLine1 ?? '',
          city: addressRow?.city ?? '',
          state: addressRow?.state ?? '',
          zipCode: addressRow?.postalCode ?? '',
          country: addressRow?.country ?? '',
          latitude: addressRow?.latitude,
          longitude: addressRow?.longitude,
        ),
        orderedAt: row.orderedAt,
        confirmedAt: row.confirmedAt,
        outForDeliveryAt: row.outForDeliveryAt,
        deliveredAt: row.deliveredAt,
        cancelledAt: row.cancelledAt,
        orderType: row.orderType,
        sourceOrderNumber: row.sourceOrderNumber,
        complaintId: row.complaintId,
      ));
    }

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  /// Read-only: Returns refund details for an order.
  Future<Map<String, dynamic>> getRefundDetail(
    Session session,
    String orderNumber,
  ) async {
    final result = <String, dynamic>{};

    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (orderRow == null) {
      return {'error': 'Order not found'};
    }

    final refunds = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 5,
    );

    if (refunds.isEmpty) {
      return result;
    }

    final refundData = refunds.map((r) => r.toJson()).toList();
    result['refunds'] = refundData;

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );
    final gatewayRefundId = cleanNullableString(refunds.first.gatewayRefundId);
    final paymentId = cleanNullableString(paymentRow?.gatewayPaymentId);

    if (gatewayRefundId != null && paymentId != null) {
      try {
        final gatewayRefund = await _gateway.fetchRefund(
          paymentId: paymentId,
          refundId: gatewayRefundId,
        );
        result['razorpayRefundData'] = gatewayRefund['data'];
      } catch (_) {}
    }

    return result;
  }

  int _decodePageToken(String? token) {
    if (token == null || token.isEmpty) return 0;
    final decoded = int.tryParse(token);
    return decoded ?? 0;
  }

  String _encodePageToken(int offset) {
    return offset.toString();
  }

  Future<AppUserRow?> _resolveUser(
    Session session,
    String userReference,
  ) async {
    final parsedId = tryParseUuid(userReference);
    if (parsedId != null) {
      final byId = await AppUserRow.db.findById(session, parsedId);
      if (byId != null) return byId;
    }

    final trimmed = userReference.trim();
    if (trimmed.isEmpty) return null;
    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(trimmed),
    );
  }

  Future<void> _finalizeSuccessfulPaymentSideEffects(
    Session session, {
    required CustomerOrderRow order,
  }) async {
    await UserCartItemRow.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(order.userId),
    );

    await _deductStockForOrderItems(session, order.id!);

    if (order.couponId != null) {
      final couponRow = await CouponRow.db.findById(session, order.couponId!);
      if (couponRow != null) {
        await CouponRow.db.updateRow(
          session,
          couponRow.copyWith(
            usedCount: couponRow.usedCount + 1,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    }
  }

  Future<void> _processPaidOrderAnalytics(
    Session session, {
    required String orderNumber,
  }) async {
    try {
      await _analytics.processPaidOrder(session, orderNumber);
    } catch (error, stackTrace) {
      session.log(
        'Product analytics processing failed for order $orderNumber: $error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _deductStockForOrderItems(
    Session session,
    UuidValue orderId,
  ) async {
    try {
      final orderItems = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderId),
      );

      const unitConversions = <String, double>{
        'gm': 1.0,
        'kg': 1000.0,
        'litre': 1000.0,
        'ml': 1.0,
        'pc': 1.0,
        'pack': 1.0,
      };

      for (final item in orderItems) {
        final product = await ProductRow.db.findById(session, item.productId);
        if (product == null || product.stock == null) continue;

        double deduction = 0;
        if (item.productVariantId != null) {
          final variant = await ProductVariantRow.db.findById(
            session,
            item.productVariantId!,
          );
          if (variant != null) {
            final vUnit = variant.quantityUnit.toLowerCase();
            final pUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
                .toLowerCase();
            final inGrams =
                variant.quantityValue * (unitConversions[vUnit] ?? 1.0);
            final inBase = inGrams / (unitConversions[pUnit] ?? 1.0);
            deduction = inBase * item.quantity;
          } else {
            deduction = item.quantity.toDouble();
          }
        } else {
          deduction = item.quantity.toDouble();
        }

        final newStock = product.stock! - deduction;
        bool shouldDisable = false;

        final bUnit = (product.baseUnit ?? 'unit').toLowerCase();
        final sUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
            .toLowerCase();
        final minGrams =
            (product.baseQuantity ?? 0.0) * (unitConversions[bUnit] ?? 1.0);
        final minRequiredInStockUnit =
            minGrams / (unitConversions[sUnit] ?? 1.0);

        if (newStock <= 0 || newStock < minRequiredInStockUnit) {
          shouldDisable = true;
        }

        await ProductRow.db.updateRow(
          session,
          product.copyWith(
            stock: newStock < 0 ? 0 : newStock,
            status: shouldDisable ? 'inactive' : product.status,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    } catch (e) {
      session.log(
        'Background stock deduction failed: $e',
        level: LogLevel.error,
      );
    }
  }
}
