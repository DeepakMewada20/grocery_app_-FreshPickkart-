import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresOrderTrackingService {
  Future<OrderTrackingData?> getTracking(
    Session session,
    String orderNumber,
  ) async {
    final order = await _findOrder(session, orderNumber);
    if (order?.id == null) return null;

    final address = await _findAddress(session, order!.id!);
    final tracking = await _findTracking(session, order.id!);
    return _toData(order, address, tracking);
  }

  Future<OrderTrackingData> seedUserLocation(
    Session session, {
    required String orderNumber,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
  }) {
    return _upsertTracking(
      session,
      orderNumber: orderNumber,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      userAddress: userAddress,
      userLocationType: userLocationType,
    );
  }

  Future<OrderTrackingData> updateTrackingEnabled(
    Session session, {
    required String orderNumber,
    required bool enabled,
  }) {
    return _upsertTracking(
      session,
      orderNumber: orderNumber,
      trackingEnabled: enabled,
    );
  }

  Future<OrderTrackingData> updateRiderLocation(
    Session session, {
    required String orderNumber,
    required double riderLatitude,
    required double riderLongitude,
  }) {
    return _upsertTracking(
      session,
      orderNumber: orderNumber,
      trackingEnabled: true,
      riderLatitude: riderLatitude,
      riderLongitude: riderLongitude,
    );
  }

  Future<OrderTrackingData> _upsertTracking(
    Session session, {
    required String orderNumber,
    bool? trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
  }) {
    return session.db.transaction<OrderTrackingData>((transaction) async {
      final order = await _findOrder(
        session,
        orderNumber,
        transaction: transaction,
        lockMode: LockMode.forUpdate,
      );
      if (order?.id == null) {
        throw Exception('Order not found: $orderNumber');
      }

      final orderId = order!.id!;
      final now = DateTime.now().toUtc();
      final existing = await _findTracking(
        session,
        orderId,
        transaction: transaction,
        lockMode: LockMode.forUpdate,
      );

      final tracking = existing == null
          ? await OrderTrackingRow.db.insertRow(
              session,
              OrderTrackingRow(
                orderId: orderId,
                trackingEnabled: trackingEnabled ?? false,
                userLatitude: userLatitude,
                userLongitude: userLongitude,
                userAddress: cleanNullableString(userAddress),
                userLocationType: cleanNullableString(userLocationType),
                riderLatitude: riderLatitude,
                riderLongitude: riderLongitude,
                createdAt: now,
                updatedAt: now,
              ),
              transaction: transaction,
            )
          : await OrderTrackingRow.db.updateRow(
              session,
              existing.copyWith(
                trackingEnabled: trackingEnabled ?? existing.trackingEnabled,
                userLatitude: userLatitude ?? existing.userLatitude,
                userLongitude: userLongitude ?? existing.userLongitude,
                userAddress:
                    cleanNullableString(userAddress) ?? existing.userAddress,
                userLocationType:
                    cleanNullableString(userLocationType) ??
                    existing.userLocationType,
                riderLatitude: riderLatitude ?? existing.riderLatitude,
                riderLongitude: riderLongitude ?? existing.riderLongitude,
                updatedAt: now,
              ),
              transaction: transaction,
            );

      final address = await _findAddress(
        session,
        orderId,
        transaction: transaction,
      );
      return _toData(order, address, tracking);
    });
  }

  Future<CustomerOrderRow?> _findOrder(
    Session session,
    String orderNumber, {
    Transaction? transaction,
    LockMode? lockMode,
  }) {
    return CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
      transaction: transaction,
      lockMode: lockMode,
    );
  }

  Future<OrderAddressRow?> _findAddress(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) {
    return OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderId),
      transaction: transaction,
    );
  }

  Future<OrderTrackingRow?> _findTracking(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
    LockMode? lockMode,
  }) {
    return OrderTrackingRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderId),
      transaction: transaction,
      lockMode: lockMode,
    );
  }

  OrderTrackingData _toData(
    CustomerOrderRow order,
    OrderAddressRow? address,
    OrderTrackingRow? tracking,
  ) {
    return OrderTrackingData(
      orderId: order.orderNumber,
      status: order.orderStatus,
      trackingEnabled: tracking?.trackingEnabled ?? false,
      userLatitude: tracking?.userLatitude ?? address?.latitude,
      userLongitude: tracking?.userLongitude ?? address?.longitude,
      userAddress: tracking?.userAddress ?? _formatAddress(address),
      userLocationType: tracking?.userLocationType,
      riderLatitude: tracking?.riderLatitude,
      riderLongitude: tracking?.riderLongitude,
      updatedAt: tracking?.updatedAt ?? order.updatedAt,
    );
  }

  String? _formatAddress(OrderAddressRow? address) {
    if (address == null) return null;
    final parts = [
      address.streetLine1,
      address.city,
      address.state,
      address.postalCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).toList(growable: false);
    return parts.isEmpty ? null : parts.join(', ');
  }
}
