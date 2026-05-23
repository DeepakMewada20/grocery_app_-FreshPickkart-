import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/business/validation_service.dart';
import '../services/order_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_order_tracking_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class OrderEndpoint extends Endpoint {
  static const String statusPlaced = 'placed';
  static const String statusConfirmed = 'confirmed';
  static const String statusOutForDelivery = 'out_for_delivery';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';
  static const String paymentPaid = 'paid';

  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresOrderTrackingService _tracking = PostgresOrderTrackingService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
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
      }
    }
    return updated;
  }

  Future<bool> cancelOrder(
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
    final updated = await _orders.cancelOrder(
      session,
      orderId,
      userId,
      reason: reason,
    );
    if (updated) {
      final order = await _orders.getOrderById(session, orderId);
      if (order != null) {
        await OrderOutboxService.instance.enqueueOrderStatusChanged(
          session: session,
          orderId: orderId,
          userId: order.userId,
          status: 'cancelled',
        );
      }
    }
    return updated;
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
