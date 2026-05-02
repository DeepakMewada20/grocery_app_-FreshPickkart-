import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/business/validation_service.dart';
import '../services/notification_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_order_service.dart';

class OrderEndpoint extends Endpoint {
  static const String statusPlaced = 'placed';
  static const String statusConfirmed = 'confirmed';
  static const String statusOutForDelivery = 'out_for_delivery';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';
  static const String paymentPaid = 'paid';

  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();

  Future<String> createOrder(Session session, protocol.Order order) {
    return _orders.createOrder(session, order);
  }

  Future<String> createPendingOrder(
    Session session,
    protocol.Order order,
    String idempotencyKey,
  ) {
    return _orders.createPendingOrder(
      session,
      order: order,
      idempotencyKey: idempotencyKey,
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
  ) {
    return _orders.getUserOrders(session, userId);
  }

  Future<protocol.Order?> getOrderById(Session session, String orderId) {
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
    final existingOrder = await getOrderById(session, orderId);
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

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update_status',
      entityType: 'order',
      entityId: orderId,
      metadata: {'newStatus': newStatus},
    );

    if (existingOrder.userId.isNotEmpty) {
      if (newStatus == statusOutForDelivery) {
        try {
          await NotificationService.notifyDeliveryStarted(
            session: session,
            userId: existingOrder.userId,
            orderId: orderId,
          );
        } catch (_) {}
      } else {
        try {
          await NotificationService.notifyUserStatusUpdate(
            session: session,
            userId: existingOrder.userId,
            orderId: orderId,
            status: newStatus,
          );
        } catch (_) {}
      }
    }

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

  Future<bool> confirmOrder(Session session, String orderId) {
    return _orders.confirmOrder(session, orderId);
  }

  Future<bool> cancelOrder(
    Session session,
    String orderId,
    String userId, {
    String reason = 'user_cancelled',
  }) {
    return _orders.cancelOrder(
      session,
      orderId,
      userId,
      reason: reason,
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
}
