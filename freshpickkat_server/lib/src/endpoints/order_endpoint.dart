import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/business/validation_service.dart';
import '../services/firebase/firebase_notification_service.dart';
import '../services/background/order_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_delivery_otp_service.dart';
import '../services/postgres/postgres_delivery_verification_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_order_tracking_service.dart';
import '../services/postgres/postgres_referral_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';
import '../services/realtime/realtime_service.dart';

class OrderEndpoint extends Endpoint {
  static const String statusPaymentPending = 'payment_pending';
  static const String statusPlaced = 'placed';
  static const String statusPaymentVerification = 'payment_verification';
  static const String statusConfirmed = 'confirmed';
  static const String statusPacked = 'packed';
  static const String statusOutForDelivery = 'out_for_delivery';
  static const String statusDeliveryOtpPending = 'delivery_otp_pending';
  static const String statusDeliveryPhotoPending = 'delivery_photo_pending';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';
  static const String statusCancelledByUser = 'cancelled_by_user';
  static const String statusPaymentExpired = 'payment_expired';
  static const String statusPaymentFailed = 'payment_failed';
  static const String statusRefunded = 'refunded';
  static const String paymentModeCod = 'cod';
  static const String paymentPending = 'pending';
  static const String paymentVerifying = 'verifying';
  static const String paymentPaid = 'paid';
  static const String paymentFailed = 'failed';
  static const String paymentCancelled = 'cancelled';
  static const String paymentRefunded = 'refunded';

  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresOrderTrackingService _tracking = PostgresOrderTrackingService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final PostgresRefundService _pgRefunds = PostgresRefundService();
  final PostgresDeliveryOtpService _deliveryOtp = PostgresDeliveryOtpService();
  final PostgresDeliveryVerificationService _deliveryVerification =
      PostgresDeliveryVerificationService();
  final FirebaseNotificationService _notifications =
      FirebaseNotificationService();
  final PostgresReferralService _referral = PostgresReferralService();

  Future<String> createOrder(Session session, protocol.Order order) {
    return _orders.createOrder(session, order);
  }

  Future<String> createPendingOrder(
    Session session,
    protocol.Order order,
    String idempotencyKey, {
    int freshPointsToRedeem = 0,
  }) {
    return _orders.createPendingOrder(
      session,
      order: order,
      idempotencyKey: idempotencyKey,
      freshPointsToRedeem: freshPointsToRedeem,
    );
  }

  Future<String> createCodOrder(
    Session session,
    protocol.Order order,
    String idempotencyKey, {
    int freshPointsToRedeem = 0,
  }) {
    return _orders.createCodOrder(
      session,
      order: order,
      idempotencyKey: idempotencyKey,
      freshPointsToRedeem: freshPointsToRedeem,
    );
  }

  Future<List<protocol.Order>> getOrders(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.getOrders(session, status: status);
  }

  Future<protocol.OrderPage> getOrdersPage(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.getOrdersPage(
      session,
      status: status,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<int> getOrdersCount(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.getOrdersCount(session, status: status);
  }

  Future<List<protocol.Order>> getTodayOrders(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.getTodayOrders(session);
  }

  Future<List<protocol.Order>> getUserOrders(
    Session session,
    String userId,
    String idToken,
  ) async {
    await _userGuard.ensureUser(
      session,
      firebaseUid: userId,
      idToken: idToken,
    );
    return _orders.getUserOrders(session, userId);
  }

  Future<protocol.Order?> getOrderById(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.getOrderById(session, orderId);
  }

  Future<bool> updateOrderStatus(
    Session session,
    String orderId,
    String newStatus, {
    String? cancellationReason,
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final existingOrder = await _orders.getOrderById(session, orderId);
    if (existingOrder == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    ValidationService.validateOrderStatusTransition(
      currentStatus: existingOrder.status,
      newStatus: newStatus,
      cancellationReason: cancellationReason,
    );

    final updated = await _orders.updateOrderStatus(
      session,
      orderId,
      newStatus,
      cancellationReason: cancellationReason,
    );
    if (!updated) return false;

    if (newStatus == statusOutForDelivery) {
      await _tracking.updateTrackingEnabled(
        session,
        orderNumber: orderId,
        enabled: true,
      );
    } else if (newStatus == statusDelivered || newStatus == statusCancelled) {
      await _tracking.updateTrackingEnabled(
        session,
        orderNumber: orderId,
        enabled: false,
      );
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update_status',
      entityType: 'order',
      entityId: orderId,
      metadata: {'newStatus': newStatus},
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    await OrderOutboxService.instance.enqueueOrderStatusChanged(
      session: session,
      orderId: orderId,
      userId: updatedOrder?.userId,
      status: newStatus,
    );

    await _referral.checkOrderForReward(session, orderId);

    return true;
  }

  Future<bool> updatePaymentStatus(
    Session session,
    String orderId,
    String paymentStatus, {
    String? razorpayPaymentId,
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validatePaymentStatus(paymentStatus);

    final updated = await _orders.updatePaymentStatus(
      session,
      orderId,
      paymentStatus,
      gatewayPaymentId: razorpayPaymentId,
    );
    if (!updated) return false;

    if (paymentStatus == paymentPaid) {
      final order = await _orders.getOrderById(session, orderId);
      if (order != null) {
        await OrderOutboxService.instance.enqueueOrderPaid(
          session: session,
          orderId: orderId,
          userId: order.userId,
          status: order.status,
          amount: order.finalAmount,
          itemCount: order.itemCount,
        );
      }
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update_payment_status',
      entityType: 'order',
      entityId: orderId,
      metadata: {'paymentStatus': paymentStatus},
    );
    return true;
  }

  Future<protocol.Order?> updateDeliveryAddress(
    Session session,
    String orderId,
    protocol.Address deliveryAddress,
    String firebaseUid,
    String idToken, {
    String? deliveryNote,
  }) async {
    final actor = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final updated = await _orders.updateDeliveryAddress(
      session,
      orderNumber: orderId,
      deliveryAddress: deliveryAddress,
      deliveryNote: deliveryNote,
    );
    if (updated == null) return null;

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update_delivery_address',
      entityType: 'order',
      entityId: orderId,
      metadata: {
        'street': deliveryAddress.street,
        'city': deliveryAddress.city,
        'state': deliveryAddress.state,
        'zipCode': deliveryAddress.zipCode,
        'country': deliveryAddress.country,
      },
    );

    await OrderOutboxService.instance.enqueueOrderAddressUpdated(
      session: session,
      orderId: orderId,
      userId: updated.userId,
      status: updated.status,
    );
    return updated;
  }

  Future<bool> confirmOrder(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw Exception('Order not found.');
    }
    if (order.paymentStatus.toLowerCase().trim() != paymentPaid) {
      throw Exception('Only paid orders can be confirmed.');
    }
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final updated = await _orders.confirmOrder(session, orderId);
    if (updated) {
      final order = await _orders.getOrderById(session, orderId);
      if (order != null) {
        await OrderOutboxService.instance.enqueueOrderStatusChanged(
          session: session,
          orderId: orderId,
          userId: order.userId,
          status: 'confirmed',
        );

        await _referral.checkOrderForReward(session, orderId);
      }
    }
    return updated;
  }

  Future<protocol.PaymentActionResult> cancelOrder(
    Session session,
    String orderId,
    String userId, {
    required String idToken,
    String reason = 'user_cancelled',
  }) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: userId,
      idToken: idToken,
    );

    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      return protocol.PaymentActionResult(
        success: false,
        error: 'Order not found',
      );
    }

    if (order.paymentStatus == 'paid') {
      // Step 1: Cancel the order first in the database
      final updated = await _orders.cancelOrder(
        session,
        orderId,
        userId,
        reason: reason,
      );
      if (!updated) {
        return protocol.PaymentActionResult(
          success: false,
          error: 'Failed to cancel the order. Please try again.',
        );
      }

      // Step 2: Call the refund API
      try {
        final refundRecord = await _pgRefunds.refund(
          session,
          orderNumber: orderId,
          amount: order.finalAmount,
          source: 'cancellation',
          reason: reason,
        );

        if (refundRecord.status == 'failed') {
          return protocol.PaymentActionResult(
            success: true,
            status: 'cancelled',
            message:
                'Order cancelled, but refund could not be initiated automatically. Please contact support.',
          );
        }

        await OrderOutboxService.instance.enqueueOrderStatusChanged(
          session: session,
          orderId: orderId,
          userId: order.userId,
          status: 'cancelled',
        );

        await _referral.checkOrderForReward(session, orderId);

        return protocol.PaymentActionResult(
          success: true,
          status: 'refunded',
          amount: (refundRecord.amount * 100).round(),
          message:
              'Refund has been initiated successfully. Full refund of ₹${refundRecord.amount.toStringAsFixed(2)}. Depending on your payment method and bank processing time, the amount may take up to 2–5 business days to reflect in your account.',
        );
      } catch (e, stackTrace) {
        session.log(
          'Refund failed during user cancellation: $e',
          level: LogLevel.error,
          exception: e,
          stackTrace: stackTrace,
        );
        return protocol.PaymentActionResult(
          success: true,
          status: 'cancelled',
          message:
              'Order cancelled, but refund could not be processed automatically. Please contact support.',
        );
      }
    }

    final updated = await _orders.cancelOrder(
      session,
      orderId,
      userId,
      reason: reason,
    );
    if (!updated) {
      return protocol.PaymentActionResult(
        success: false,
        error: 'Failed to cancel order',
      );
    }

    await OrderOutboxService.instance.enqueueOrderStatusChanged(
      session: session,
      orderId: orderId,
      userId: order.userId,
      status: 'cancelled',
    );

    await _referral.checkOrderForReward(session, orderId);

    return protocol.PaymentActionResult(
      success: true,
      message: 'Order cancelled successfully.',
    );
  }

  /// User requests cancellation for Stage 2/3 orders (needs admin approval).
  Future<protocol.PaymentActionResult> requestCancellation(
    Session session,
    String orderId,
    String userId, {
    required String idToken,
    String reason = 'User requested cancellation',
  }) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: userId,
      idToken: idToken,
    );
    final updated = await _orders.requestCancellation(
      session,
      orderId,
      userId,
      reason: reason,
    );
    return protocol.PaymentActionResult(
      success: updated,
      status: updated ? 'cancellation_requested' : 'error',
      message: updated
          ? 'Your cancellation request has been submitted successfully. Our team will review your request and notify you once a decision is made.'
          : 'Failed to request cancellation.',
    );
  }

  /// Admin: List all cancellation requests.
  Future<protocol.OrderPage> listCancellationRequests(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _orders.listCancellationRequests(
      session,
      limit: limit,
      pageToken: pageToken,
    );
  }

  /// Admin: Approve cancellation request and initiate refund.
  Future<protocol.PaymentActionResult> approveCancellationRequest(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
    double? fixedRefundAmount,
    String adminNote = '',
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final refundRecord = await _orders.approveCancellationRequest(
        session,
        orderId,
        fixedRefundAmount: fixedRefundAmount,
        adminNote: adminNote,
      );
      return protocol.PaymentActionResult(
        success: true,
        status: 'refunded',
        amount: (refundRecord.amount * 100).round(),
        message:
            'Your cancellation request has been approved. Refund processing has been started. Refund of ₹${refundRecord.amount.toStringAsFixed(2)} initiated.',
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Admin: Reject cancellation request and restore order.
  Future<protocol.PaymentActionResult> rejectCancellationRequest(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
    String adminNote = '',
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final updated = await _orders.rejectCancellationRequest(
      session,
      orderId,
      adminNote: adminNote,
    );
    return protocol.PaymentActionResult(
      success: updated,
      status: updated ? 'cancellation_rejected' : 'error',
      message: updated
          ? 'Your cancellation request was not approved. The order will continue through the normal delivery process.'
          : 'Failed to reject cancellation.',
    );
  }

  Future<bool> assignDeliveryPerson(
    Session session,
    String orderId,
    String deliveryPersonName,
    String deliveryPersonPhone,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    if (deliveryPersonName.trim().isEmpty ||
        deliveryPersonPhone.trim().isEmpty) {
      throw ArgumentError('Delivery person name and phone are required');
    }

    final updated = await _orders.assignDeliveryPerson(
      session,
      orderId,
      deliveryPersonName,
      deliveryPersonPhone,
    );
    if (!updated) return false;

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'assign_delivery_person',
      entityType: 'order',
      entityId: orderId,
      metadata: {'deliveryPersonName': deliveryPersonName},
    );
    return true;
  }

  Future<bool> generateDeliveryOtp(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.paymentMode == paymentModeCod &&
        order.paymentStatus != paymentPaid) {
      throw StateError(
        'COD payment must be collected before delivery. '
        'Current payment status: ${order.paymentStatus}',
      );
    }
    if (order.status != statusOutForDelivery &&
        order.status != statusDeliveryOtpPending) {
      throw StateError(
        'Order status must be "out_for_delivery" to generate delivery OTP. '
        'Current status: ${order.status}',
      );
    }

    // Set delivery verification method to OTP
    await _orders.setDeliveryVerificationMethod(
      session,
      orderId,
      'otp',
    );

    final result = await _deliveryOtp.generateOtp(
      session: session,
      orderNumber: orderId,
      adminUserId: actor.id!,
      customerName: order.userName ?? 'Customer',
      orderAmount: order.finalAmount,
    );

    // Send FCM notification to user
    try {
      await _notifications.sendDeliveryOtp(
        session: session,
        userId: order.userId,
        orderId: orderId,
        otp: result['otp'] as String,
        customerName: order.userName ?? 'Customer',
        orderAmount: order.finalAmount,
      );
    } catch (e, st) {
      session.log(
        'Failed to send delivery OTP notification: $e',
        level: LogLevel.warning,
        exception: e,
        stackTrace: st,
      );
      throw StateError(
        'Failed to send OTP notification to customer. Please try again.',
      );
    }

    // Update order status to delivery_otp_pending
    final updated = await _orders.updateOrderStatus(
      session,
      orderId,
      statusDeliveryOtpPending,
    );
    if (!updated) {
      throw StateError('Failed to update order status.');
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'generate_delivery_otp',
      entityType: 'order',
      entityId: orderId,
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    if (updatedOrder != null) {
      await OrderOutboxService.instance.enqueueOrderStatusChanged(
        session: session,
        orderId: orderId,
        userId: updatedOrder.userId,
        status: statusDeliveryOtpPending,
      );
      await _referral.checkOrderForReward(session, orderId);
      await RealtimeService().broadcastOrderEvent(
        session,
        protocol.OrderRealtimeEvent(
          eventType: 'status_changed',
          orderId: orderId,
          status: statusDeliveryOtpPending,
          userId: updatedOrder.userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }

  Future<bool> markDeliveryPhotoPending(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.paymentMode == paymentModeCod &&
        order.paymentStatus != paymentPaid) {
      throw StateError(
        'COD payment must be collected before delivery. '
        'Current payment status: ${order.paymentStatus}',
      );
    }
    if (order.status != statusOutForDelivery) {
      throw StateError(
        'Order status must be "out_for_delivery" to start photo delivery. '
        'Current status: ${order.status}',
      );
    }

    final updated = await _orders.updateOrderStatus(
      session,
      orderId,
      statusDeliveryPhotoPending,
    );
    if (!updated) {
      throw StateError('Failed to update order status.');
    }

    // Set delivery verification method to photo
    await _orders.setDeliveryVerificationMethod(
      session,
      orderId,
      'photo',
    );

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'mark_delivery_photo_pending',
      entityType: 'order',
      entityId: orderId,
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    if (updatedOrder != null) {
      await OrderOutboxService.instance.enqueueOrderStatusChanged(
        session: session,
        orderId: orderId,
        userId: updatedOrder.userId,
        status: statusDeliveryPhotoPending,
      );
      await RealtimeService().broadcastOrderEvent(
        session,
        protocol.OrderRealtimeEvent(
          eventType: 'status_changed',
          orderId: orderId,
          status: statusDeliveryPhotoPending,
          userId: updatedOrder.userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }

  Future<bool> cancelDeliveryPhotoPending(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.status != statusDeliveryPhotoPending) {
      throw StateError(
        'Order status must be "delivery_photo_pending" to cancel photo delivery. '
        'Current status: ${order.status}',
      );
    }

    final updated = await _orders.updateOrderStatus(
      session,
      orderId,
      statusOutForDelivery,
    );
    if (!updated) {
      throw StateError('Failed to update order status.');
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'cancel_delivery_photo_pending',
      entityType: 'order',
      entityId: orderId,
      metadata: {'revertedTo': 'out_for_delivery'},
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    if (updatedOrder != null) {
      await OrderOutboxService.instance.enqueueOrderStatusChanged(
        session: session,
        orderId: orderId,
        userId: updatedOrder.userId,
        status: statusOutForDelivery,
      );
      await RealtimeService().broadcastOrderEvent(
        session,
        protocol.OrderRealtimeEvent(
          eventType: 'status_changed',
          orderId: orderId,
          status: statusOutForDelivery,
          userId: updatedOrder.userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }

  Future<bool> verifyDeliveryOtp(
    Session session,
    String orderId,
    String otp, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }

    await _deliveryOtp.verifyOtp(
      session: session,
      orderNumber: orderId,
      otp: otp,
      adminUserId: actor.id!,
    );

    // Update order to delivered
    final updated = await _orders.updateOrderStatus(
      session,
      orderId,
      statusDelivered,
    );
    if (!updated) {
      throw StateError('Failed to update order status.');
    }

    // Record delivered-by metadata
    await _deliveryVerification.recordOtpDeliveryMetadata(
      session,
      orderId: orderId,
      adminFirebaseUid: firebaseUid,
      adminName: actor.name ?? actor.firebaseUid ?? 'Admin',
    );

    // Disable tracking
    await _tracking.updateTrackingEnabled(
      session,
      orderNumber: orderId,
      enabled: false,
    );

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'verify_delivery_otp',
      entityType: 'order',
      entityId: orderId,
      metadata: {'deliveryCompleted': 'true'},
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    if (updatedOrder != null) {
      await OrderOutboxService.instance.enqueueOrderStatusChanged(
        session: session,
        orderId: orderId,
        userId: updatedOrder.userId,
        status: statusDelivered,
      );
      await _referral.checkOrderForReward(session, orderId);
      await RealtimeService().broadcastOrderEvent(
        session,
        protocol.OrderRealtimeEvent(
          eventType: 'status_changed',
          orderId: orderId,
          status: statusDelivered,
          userId: updatedOrder.userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }

  Future<bool> resendDeliveryOtp(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }

    final result = await _deliveryOtp.resendOtp(
      session: session,
      orderNumber: orderId,
      adminUserId: actor.id!,
      customerName: order.userName ?? 'Customer',
      orderAmount: order.finalAmount,
    );

    // Send FCM with new OTP
    try {
      await _notifications.sendDeliveryOtp(
        session: session,
        userId: order.userId,
        orderId: orderId,
        otp: result['otp'] as String,
        customerName: order.userName ?? 'Customer',
        orderAmount: order.finalAmount,
      );
    } catch (e, st) {
      session.log(
        'Failed to resend delivery OTP notification: $e',
        level: LogLevel.warning,
        exception: e,
        stackTrace: st,
      );
      throw StateError(
        'Failed to send OTP notification to customer. Please try again.',
      );
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'resend_delivery_otp',
      entityType: 'order',
      entityId: orderId,
      metadata: {'resendCount': result['resendCount'].toString()},
    );

    return true;
  }

  Future<Map<String, dynamic>?> getActiveDeliveryOtp(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) return null;

    return _deliveryOtp.getActiveOtp(
      session: session,
      orderNumber: orderId,
    );
  }

  Future<Map<String, dynamic>> getDashboardStats(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final allOrders = await getOrders(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final todayOrders = await getTodayOrders(session, firebaseUid, idToken);

    var todayRevenue = 0.0;
    var totalRevenue = 0.0;
    var pendingCount = 0;
    var confirmedCount = 0;
    var outForDeliveryCount = 0;
    var deliveredCount = 0;
    var cancelledCount = 0;

    for (final order in allOrders) {
      if (order.paymentStatus == paymentPaid &&
          order.status != statusCancelled) {
        totalRevenue += order.finalAmount;
      }
      switch (order.status) {
        case statusPlaced:
          pendingCount++;
          break;
        case statusConfirmed:
          confirmedCount++;
          break;
        case statusOutForDelivery:
          outForDeliveryCount++;
          break;
        case statusDeliveryOtpPending:
          outForDeliveryCount++;
          break;
        case statusDelivered:
          deliveredCount++;
          break;
        case statusCancelled:
          cancelledCount++;
          break;
      }
    }

    for (final order in todayOrders) {
      if (order.paymentStatus == paymentPaid &&
          order.status != statusCancelled) {
        todayRevenue += order.finalAmount;
      }
    }

    return {
      'todayOrders': todayOrders.length,
      'todayRevenue': todayRevenue,
      'totalOrders': allOrders.length,
      'totalRevenue': totalRevenue,
      'pendingOrders': pendingCount,
      'confirmedOrders': confirmedCount,
      'outForDeliveryOrders': outForDeliveryCount,
      'deliveredOrders': deliveredCount,
      'cancelledOrders': cancelledCount,
    };
  }

  Future<bool> completePhotoDelivery(
    Session session,
    String orderId,
    String imageUrl,
    double latitude,
    double longitude,
    double gpsAccuracy, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.paymentMode == paymentModeCod &&
        order.paymentStatus != paymentPaid) {
      throw StateError(
        'COD payment must be collected before delivery. '
        'Current payment status: ${order.paymentStatus}',
      );
    }
    if (order.status != statusOutForDelivery &&
        order.status != statusDeliveryPhotoPending) {
      throw StateError(
        'Order status must be "out_for_delivery" or "delivery_photo_pending" to complete photo delivery. '
        'Current status: ${order.status}',
      );
    }

    await _deliveryVerification.completePhotoDelivery(
      session,
      orderId: orderId,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      gpsAccuracy: gpsAccuracy,
      adminFirebaseUid: firebaseUid,
      adminName: actor.name ?? actor.firebaseUid ?? 'Admin',
    );

    // Disable tracking
    await _tracking.updateTrackingEnabled(
      session,
      orderNumber: orderId,
      enabled: false,
    );

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'complete_photo_delivery',
      entityType: 'order',
      entityId: orderId,
      metadata: {
        'deliveryMethod': 'photo',
        'gpsAccuracy': gpsAccuracy.toStringAsFixed(1),
        'latitude': latitude.toStringAsFixed(6),
        'longitude': longitude.toStringAsFixed(6),
      },
    );

    final updatedOrder = await _orders.getOrderById(session, orderId);
    if (updatedOrder != null) {
      await OrderOutboxService.instance.enqueueOrderStatusChanged(
        session: session,
        orderId: orderId,
        userId: updatedOrder.userId,
        status: statusDelivered,
      );
      await _referral.checkOrderForReward(session, orderId);
      await RealtimeService().broadcastOrderEvent(
        session,
        protocol.OrderRealtimeEvent(
          eventType: 'status_changed',
          orderId: orderId,
          status: statusDelivered,
          userId: updatedOrder.userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }

  Future<bool> collectCodPayment(
    Session session,
    String orderId,
    String collectionMode, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }

    await _orders.collectCodPayment(
      session,
      orderId: orderId,
      collectionMode: collectionMode,
      adminFirebaseUid: firebaseUid,
    );

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'collect_cod_payment',
      entityType: 'order',
      entityId: orderId,
      metadata: {'collectionMode': collectionMode},
    );

    return true;
  }

  Future<void> _ensureOrderOwner(
    Session session, {
    required String orderId,
    required String firebaseUid,
    required String idToken,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw Exception('Order not found.');
    }
    final dbUserId = user.id?.toString();
    if (order.userId != firebaseUid && order.userId != dbUserId) {
      throw Exception('Order does not belong to user.');
    }
  }
}
