import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class RealtimeService {
  static const String adminOrdersChannel = 'admin_orders';
  static const String dashboardUpdatesChannel = 'dashboard_updates';

  static String userOrdersChannel(String userId) {
    final normalized = userId.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('userId is required.');
    }
    return 'user_orders_$normalized';
  }

  Future<void> sendAdminOrderUpdate(
    Session session,
    OrderRealtimeEvent event,
  ) async {
    await session.messages.postMessage(adminOrdersChannel, event);
  }

  Future<void> sendDashboardUpdate(
    Session session,
    OrderRealtimeEvent event,
  ) async {
    await session.messages.postMessage(dashboardUpdatesChannel, event);
  }

  Future<void> sendUserOrderUpdate(
    Session session,
    String userId,
    OrderRealtimeEvent event,
  ) async {
    await session.messages.postMessage(userOrdersChannel(userId), event);
  }

  Future<void> broadcastOrderEvent(
    Session session,
    OrderRealtimeEvent event, {
    bool includeAdminOrders = true,
    bool includeDashboardUpdates = true,
    bool includeUserOrders = true,
  }) async {
    if (includeAdminOrders) {
      await sendAdminOrderUpdate(session, event);
    }
    if (includeDashboardUpdates) {
      await sendDashboardUpdate(session, event);
    }
    final userId = event.userId;
    if (includeUserOrders && userId != null && userId.trim().isNotEmpty) {
      await sendUserOrderUpdate(session, userId, event);
    }
  }
}
