import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresOrderService {
  static const int _defaultLimit = 20;
  static const int _maxLimit = 50;
  static const String _idempotencyScope = 'order_create';
  static final Random _random = Random();

  Future<String> createPendingOrder(
    Session session, {
    required Order order,
    required String idempotencyKey,
    String gatewayName = 'razorpay',
  }) async {
    final normalizedKey = idempotencyKey.trim();
    if (normalizedKey.isEmpty) {
      throw Exception('idempotencyKey is required.');
    }
    if (order.items.isEmpty) {
      throw Exception('Order must contain at least one item.');
    }

    try {
      return await session.db.transaction<String>((transaction) async {
        final appUser = await _resolveOrCreateUser(
          session,
          userReference: order.userId,
          phoneNumber: order.userPhone,
          userName: order.userName,
          transaction: transaction,
          createIfMissing: true,
        );
        if (appUser == null || appUser.id == null) {
          throw Exception('Unable to resolve the order user.');
        }
        final userId = appUser.id!;

        final existing = await IdempotencyRecordRow.db.findFirstRow(
          session,
          where: (t) =>
              t.scope.equals(_idempotencyScope) &
              t.idempotencyKey.equals(normalizedKey),
          transaction: transaction,
          lockMode: LockMode.forUpdate,
        );

        if (existing != null) {
          if (existing.responseReference != null &&
              existing.responseReference!.trim().isNotEmpty) {
            return existing.responseReference!;
          }

          if (existing.orderId != null) {
            final existingOrder = await CustomerOrderRow.db.findById(
              session,
              existing.orderId!,
              transaction: transaction,
            );
            if (existingOrder != null) {
              return existingOrder.orderNumber;
            }
          }

          throw Exception('Order is already being processed for this key.');
        }

        final coupon = await _resolveCoupon(
          session,
          couponReference: order.couponApplied,
          transaction: transaction,
        );

        final now = DateTime.now().toUtc();
        final orderNumber = _generateOrderNumber();
        final deliveryOtp = _generateDeliveryOtp();
        final requestHash = jsonEncode(order.toJsonForProtocol());

        final createdOrder = await CustomerOrderRow.db.insertRow(
          session,
          CustomerOrderRow(
            userId: userId,
            orderNumber: orderNumber,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            couponId: coupon?.id,
            itemCount: order.itemCount,
            totalAmount: order.totalAmount,
            discountAmount: order.discountAmount,
            deliveryFee: order.deliveryFee,
            finalAmount: order.finalAmount,
            placedAt: now,
            deliveryOtp: deliveryOtp,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (createdOrder.id == null) {
          throw Exception('Failed to allocate order id.');
        }
        final createdOrderId = createdOrder.id!;

        await OrderAddressRow.db.insertRow(
          session,
          OrderAddressRow(
            orderId: createdOrderId,
            recipientName: cleanNullableString(order.userName),
            phoneNumber: cleanNullableString(order.userPhone),
            streetLine1: order.deliveryAddress.street.trim(),
            city: order.deliveryAddress.city.trim(),
            state: order.deliveryAddress.state.trim(),
            postalCode: order.deliveryAddress.zipCode.trim(),
            country: order.deliveryAddress.country.trim(),
            latitude: order.deliveryAddress.latitude,
            longitude: order.deliveryAddress.longitude,
            createdAt: now,
          ),
          transaction: transaction,
        );

        final orderItemRows = order.items.map((item) {
          final productId = parseUuid(item.productId, fieldName: 'productId');

          return OrderItemRow(
            orderId: createdOrderId,
            productId: productId,
            productVariantId: tryParseUuid(item.variantId),
            comboOfferId: tryParseUuid(item.comboId),
            bogoOfferId: null,
            productNameSnapshot: item.productName.trim(),
            productImageUrlSnapshot: cleanNullableString(item.productImage),
            variantLabelSnapshot: cleanNullableString(item.variantLabel),
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            isFreeItem: item.isFreeItem,
            createdAt: now,
          );
        }).toList();

        await OrderItemRow.db.insert(
          session,
          orderItemRows,
          transaction: transaction,
        );

        final paymentTransaction = await PaymentTransactionRow.db.insertRow(
          session,
          PaymentTransactionRow(
            orderId: createdOrderId,
            userId: userId,
            idempotencyKey: normalizedKey,
            gatewayName: gatewayName.trim().isEmpty
                ? 'razorpay'
                : gatewayName.trim(),
            amount: order.finalAmount,
            currencyCode: 'INR',
            paymentStatus: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (paymentTransaction.id == null) {
          throw Exception('Failed to allocate payment transaction id.');
        }
        final paymentTransactionId = paymentTransaction.id!;

        await IdempotencyRecordRow.db.insertRow(
          session,
          IdempotencyRecordRow(
            scope: _idempotencyScope,
            idempotencyKey: normalizedKey,
            userId: userId,
            orderId: createdOrderId,
            paymentTransactionId: paymentTransactionId,
            requestHash: requestHash,
            responseReference: orderNumber,
            createdAt: now,
          ),
          transaction: transaction,
        );

        return orderNumber;
      });
    } catch (error) {
      final existingOrderNumber = await _findExistingOrderNumberForKey(
        session,
        normalizedKey,
      );
      if (existingOrderNumber != null) {
        return existingOrderNumber;
      }
      rethrow;
    }
  }

  Future<OrderPage> getOrdersForUser(
    Session session, {
    required String userReference,
    int limit = _defaultLimit,
    String? pageToken,
  }) async {
    final appUser = await _resolveOrCreateUser(
      session,
      userReference: userReference,
      createIfMissing: false,
    );

    if (appUser == null) {
      return OrderPage(orders: const [], nextPageToken: null, totalCount: 0);
    }

    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final cursor = _decodeOrderCursor(pageToken);

    final totalCountResult = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM customer_order
      WHERE "userId" = @userId::uuid
      ''',
      parameters: QueryParameters.named({'userId': appUser.id.toString()}),
    );
    final totalCount = totalCountResult.isEmpty
        ? 0
        : asInt(totalCountResult.first.toColumnMap()['totalCount']);

    var whereClause = 'WHERE "userId" = @userId::uuid';
    final params = <String, dynamic>{
      'userId': appUser.id.toString(),
      'limit': pageSize + 1,
    };

    if (cursor != null) {
      whereClause += '''
        AND (
          "orderedAt" < @cursorOrderedAt::timestamp
          OR (
            "orderedAt" = @cursorOrderedAt::timestamp
            AND id::text < @cursorOrderId::text
          )
        )''';
      params['cursorOrderedAt'] = cursor.orderedAt.toIso8601String();
      params['cursorOrderId'] = cursor.orderId;
    }

    final orderPageResult = await session.db.unsafeQuery(
      '''
      SELECT
        id::text AS "orderId",
        "orderedAt" AS "orderedAt"
      FROM customer_order
      $whereClause
      ORDER BY "orderedAt" DESC, id DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named(params),
    );

    final orderedIds = <String>[];
    final cursors = <_OrderCursor>[];
    for (final row in orderPageResult) {
      final map = row.toColumnMap();
      final orderId = map['orderId']?.toString();
      if (orderId == null || orderId.isEmpty) continue;

      final orderedAt = asDateTime(map['orderedAt']);
      orderedIds.add(orderId);
      cursors.add(_OrderCursor(orderId: orderId, orderedAt: orderedAt));
    }

    final hasMore = orderedIds.length > pageSize;
    if (hasMore) {
      orderedIds.removeLast();
      cursors.removeLast();
    }

    final orders = await _hydrateOrders(
      session,
      orderedIds: orderedIds,
    );

    final nextPageToken = hasMore && cursors.isNotEmpty
        ? encodeCursor({
            'orderId': cursors.last.orderId,
            'orderedAt': cursors.last.orderedAt.toUtc().toIso8601String(),
          })
        : null;

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<AppUserRow?> _resolveOrCreateUser(
    Session session, {
    required String userReference,
    String? phoneNumber,
    String? userName,
    Transaction? transaction,
    bool createIfMissing = false,
  }) async {
    final trimmedReference = userReference.trim();
    final parsedUserId = tryParseUuid(trimmedReference);

    if (parsedUserId != null) {
      final byId = await AppUserRow.db.findById(
        session,
        parsedUserId,
        transaction: transaction,
      );
      if (byId != null && byId.status == 'active') {
        return byId;
      }
    }

    if (trimmedReference.isNotEmpty) {
      final byFirebaseUid = await AppUserRow.db.findFirstRow(
        session,
        where: (t) =>
            t.firebaseUid.equals(trimmedReference) & t.status.equals('active'),
        transaction: transaction,
      );
      if (byFirebaseUid != null) {
        return byFirebaseUid;
      }
    }

    if (!createIfMissing) {
      return null;
    }

    final normalizedPhone = cleanNullableString(phoneNumber);
    if (normalizedPhone == null) {
      throw Exception('phoneNumber is required to create a user.');
    }

    return AppUserRow.db.insertRow(
      session,
      AppUserRow(
        firebaseUid: trimmedReference.isEmpty ? null : trimmedReference,
        phoneNumber: normalizedPhone,
        name: cleanNullableString(userName),
      ),
      transaction: transaction,
    );
  }

  Future<CouponRow?> _resolveCoupon(
    Session session, {
    required String? couponReference,
    Transaction? transaction,
  }) async {
    final normalized = cleanNullableString(couponReference);
    if (normalized == null) return null;

    final couponId = tryParseUuid(normalized);
    if (couponId != null) {
      final byId = await CouponRow.db.findById(
        session,
        couponId,
        transaction: transaction,
      );
      if (byId != null && byId.status == 'active') {
        return byId;
      }
    }

    return CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalized) & t.status.equals('active'),
      transaction: transaction,
    );
  }

  Future<String?> _findExistingOrderNumberForKey(
    Session session,
    String idempotencyKey,
  ) async {
    final existing = await IdempotencyRecordRow.db.findFirstRow(
      session,
      where: (t) =>
          t.scope.equals(_idempotencyScope) &
          t.idempotencyKey.equals(idempotencyKey),
    );
    if (existing == null) return null;

    if (existing.responseReference != null &&
        existing.responseReference!.trim().isNotEmpty) {
      return existing.responseReference!;
    }

    if (existing.orderId == null) return null;
    final order = await CustomerOrderRow.db.findById(
      session,
      existing.orderId!,
    );
    return order?.orderNumber;
  }

  Future<List<Order>> _hydrateOrders(
    Session session, {
    required List<String> orderedIds,
  }) async {
    if (orderedIds.isEmpty) return const [];

    final orderIds = orderedIds
        .map((id) => parseUuid(id, fieldName: 'orderId'))
        .toSet();

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.id.inSet(orderIds),
    );
    if (orders.isEmpty) return const [];

    final orderById = {for (final order in orders) order.id!.toString(): order};
    final userIds = orders.map((order) => order.userId).toSet();
    final users = await AppUserRow.db.find(
      session,
      where: (t) => t.id.inSet(userIds),
    );
    final userById = {for (final user in users) user.id!.toString(): user};

    final items = await OrderItemRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final itemsByOrder = <String, List<OrderItemRow>>{};
    for (final item in items) {
      itemsByOrder.putIfAbsent(item.orderId.toString(), () => []).add(item);
    }

    final addresses = await OrderAddressRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final addressByOrder = {
      for (final address in addresses) address.orderId.toString(): address,
    };

    final payments = await PaymentTransactionRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final paymentByOrder = <String, PaymentTransactionRow>{};
    for (final payment in payments) {
      final key = payment.orderId.toString();
      final existing = paymentByOrder[key];
      if (existing == null || payment.createdAt.isAfter(existing.createdAt)) {
        paymentByOrder[key] = payment;
      }
    }

    final couponIds = orders
        .map((order) => order.couponId)
        .whereType<UuidValue>()
        .toSet();
    final coupons = couponIds.isEmpty
        ? const <CouponRow>[]
        : await CouponRow.db.find(
            session,
            where: (t) => t.id.inSet(couponIds),
          );
    final couponById = {for (final coupon in coupons) coupon.id!: coupon};

    final hydrated = <Order>[];
    for (final orderId in orderedIds) {
      final order = orderById[orderId];
      if (order == null) continue;

      final address = addressByOrder[orderId];
      if (address == null) continue;

      final mappedItems = (itemsByOrder[orderId] ?? const <OrderItemRow>[])
          .map(
            (item) => OrderItem(
              productId: item.productId.toString(),
              variantId: item.productVariantId?.toString(),
              variantLabel: item.variantLabelSnapshot,
              productName: item.productNameSnapshot,
              productImage: item.productImageUrlSnapshot ?? '',
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              totalPrice: item.totalPrice,
              isFreeItem: item.isFreeItem,
              comboId: item.comboOfferId?.toString(),
            ),
          )
          .toList();

      final payment = paymentByOrder[orderId];
      final appUser = userById[order.userId.toString()];

      hydrated.add(
        Order(
          orderId: order.orderNumber,
          userId: appUser?.firebaseUid ?? order.userId.toString(),
          userName: appUser?.name,
          userPhone: appUser?.phoneNumber ?? '',
          items: mappedItems,
          itemCount: order.itemCount,
          totalAmount: order.totalAmount,
          discountAmount: order.discountAmount,
          deliveryFee: order.deliveryFee,
          finalAmount: order.finalAmount,
          status: order.orderStatus,
          paymentStatus: order.paymentStatus,
          refundStatus: order.refundStatus,
          razorpayOrderId: payment?.gatewayOrderId,
          razorpayPaymentId: payment?.gatewayPaymentId,
          deliveryAddress: Address(
            street: address.streetLine1,
            city: address.city,
            state: address.state,
            zipCode: address.postalCode,
            country: address.country,
            latitude: address.latitude,
            longitude: address.longitude,
          ),
          orderedAt: order.orderedAt,
          confirmedAt: order.confirmedAt,
          outForDeliveryAt: order.outForDeliveryAt,
          deliveredAt: order.deliveredAt,
          cancelledAt: order.cancelledAt,
          cancellationReason: order.cancellationReason,
          deliveryPersonName: order.deliveryPersonName,
          deliveryPersonPhone: order.deliveryPersonPhone,
          deliveryOtp: order.deliveryOtp,
          couponApplied: order.couponId == null
              ? null
              : couponById[order.couponId!]?.code ?? order.couponId.toString(),
        ),
      );
    }

    return hydrated;
  }

  _OrderCursor? _decodeOrderCursor(String? token) {
    final data = decodeCursor(token);
    if (data == null) return null;

    final orderId = data['orderId']?.toString();
    final orderedAtRaw = data['orderedAt'];
    if (orderId == null || orderedAtRaw == null) {
      throw Exception('Invalid page token.');
    }

    return _OrderCursor(
      orderId: orderId,
      orderedAt: DateTime.parse(orderedAtRaw.toString()),
    );
  }

  String _generateOrderNumber() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final suffix = (_random.nextInt(900) + 100).toString();
    return 'ORD$millis$suffix';
  }

  String _generateDeliveryOtp() {
    return (_random.nextInt(9000) + 1000).toString();
  }

  Future<String> createOrder(
    Session session,
    Order order,
  ) {
    return createPendingOrder(
      session,
      order: order,
      idempotencyKey:
          'direct-${DateTime.now().millisecondsSinceEpoch}-${order.userId}',
    );
  }

  Future<List<Order>> getUserOrders(
    Session session,
    String userReference,
  ) async {
    final page = await getOrdersForUser(
      session,
      userReference: userReference,
      limit: 200,
    );
    return page.orders;
  }

  Future<Order?> getOrderById(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row?.id == null) return null;

    final orders = await _hydrateOrders(
      session,
      orderedIds: [row!.id!.toString()],
    );
    return orders.isEmpty ? null : orders.first;
  }

  Future<List<Order>> getOrders(
    Session session, {
    int limit = 20,
    String? status,
  }) async {
    final page = await getOrdersPage(
      session,
      limit: limit,
      status: status,
    );
    return page.orders;
  }

  Future<OrderPage> getOrdersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    String? status,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final cursor = _decodeOrderCursor(pageToken);
    final totalCount = await getOrdersCount(
      session,
      status: status,
    );

    final rows = await CustomerOrderRow.db.find(
      session,
      where: status == null || status.trim().isEmpty
          ? null
          : (t) => t.orderStatus.equals(status.trim()),
      limit: pageSize + 1,
      orderBy: (t) => t.orderedAt,
      orderDescending: true,
    );

    final filtered = cursor == null
        ? rows
        : rows.where((row) {
            final rowId = row.id?.toString();
            if (rowId == null) return false;
            return row.orderedAt.isBefore(cursor.orderedAt) ||
                (row.orderedAt.isAtSameMomentAs(cursor.orderedAt) &&
                    rowId.compareTo(cursor.orderId) < 0);
          }).toList();

    final hasMore = filtered.length > pageSize;
    final pageRows = hasMore ? filtered.take(pageSize).toList() : filtered;
    final orders = await _hydrateOrders(
      session,
      orderedIds: pageRows.map((row) => row.id!.toString()).toList(),
    );

    final nextPageToken = hasMore && pageRows.isNotEmpty
        ? encodeCursor({
            'orderId': pageRows.last.id!.toString(),
            'orderedAt': pageRows.last.orderedAt.toUtc().toIso8601String(),
          })
        : null;

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> getOrdersCount(
    Session session, {
    String? status,
  }) {
    return CustomerOrderRow.db.count(
      session,
      where: status == null || status.trim().isEmpty
          ? null
          : (t) => t.orderStatus.equals(status.trim()),
    );
  }

  Future<List<Order>> getTodayOrders(Session session) async {
    final now = DateTime.now().toUtc();
    final start = DateTime.utc(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final rows = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.orderedAt.between(start, end),
      orderBy: (t) => t.orderedAt,
      orderDescending: true,
    );
    return _hydrateOrders(
      session,
      orderedIds: rows.map((row) => row.id!.toString()).toList(),
    );
  }

  Future<bool> updateOrderStatus(
    Session session,
    String orderNumber,
    String newStatus, {
    String? cancellationReason,
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        orderStatus: newStatus,
        confirmedAt: newStatus == 'confirmed' ? now : row.confirmedAt,
        packedAt: newStatus == 'packed' ? now : row.packedAt,
        outForDeliveryAt: newStatus == 'out_for_delivery'
            ? now
            : row.outForDeliveryAt,
        deliveredAt: newStatus == 'delivered' ? now : row.deliveredAt,
        cancelledAt: newStatus == 'cancelled' ? now : row.cancelledAt,
        cancellationReason: newStatus == 'cancelled'
            ? cancellationReason
            : row.cancellationReason,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<bool> updatePaymentStatus(
    Session session,
    String orderNumber,
    String paymentStatus, {
    String? gatewayPaymentId,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) return false;

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        paymentStatus: paymentStatus,
        updatedAt: now,
      ),
    );
    if (paymentRow != null) {
      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          paymentStatus: paymentStatus,
          gatewayPaymentId: gatewayPaymentId ?? paymentRow.gatewayPaymentId,
          paidAt: paymentStatus == 'paid' ? now : paymentRow.paidAt,
          updatedAt: now,
        ),
      );
    }
    return true;
  }

  Future<bool> confirmOrder(
    Session session,
    String orderNumber,
  ) {
    return updateOrderStatus(
      session,
      orderNumber,
      'confirmed',
    );
  }

  Future<bool> cancelOrder(
    Session session,
    String orderNumber,
    String userReference, {
    String reason = 'user_cancelled',
  }) async {
    final order = await getOrderById(session, orderNumber);
    if (order == null) return false;
    if (order.userId != userReference) {
      final appUser = await _resolveOrCreateUser(
        session,
        userReference: userReference,
        createIfMissing: false,
      );
      if (appUser == null || appUser.id?.toString() != order.userId) {
        throw Exception('Order does not belong to user.');
      }
    }
    return updateOrderStatus(
      session,
      orderNumber,
      'cancelled',
      cancellationReason: reason,
    );
  }

  Future<bool> assignDeliveryPerson(
    Session session,
    String orderNumber,
    String deliveryPersonName,
    String deliveryPersonPhone,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        deliveryPersonName: deliveryPersonName.trim(),
        deliveryPersonPhone: deliveryPersonPhone.trim(),
        updatedAt: now,
      ),
    );
    return true;
  }
}

class _OrderCursor {
  _OrderCursor({
    required this.orderId,
    required this.orderedAt,
  });

  final String orderId;
  final DateTime orderedAt;
}
