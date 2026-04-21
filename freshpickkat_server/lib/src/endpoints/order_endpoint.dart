import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/firebase_service.dart';
import '../services/role_guard_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import '../services/notification_service.dart';
import '../services/orders/order_idempotency_service.dart';
import '../services/refunds/refund_service.dart';
import '../services/coupon_service.dart';
import '../services/bogo/bogo_eligibility.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'package:googleapis/firestore/v1.dart' show FirestoreApi;

class OrderEndpoint extends Endpoint {
  static const String orderCollection = 'orders';
  static const String bogoCollection = 'bogo_offers';
  static const String projectId = 'freshpickkart-a6824';

  static const String statusPlaced = 'placed';
  static const String statusConfirmed = 'confirmed';
  static const String statusPacked = 'packed';
  static const String statusOutForDelivery = 'out_for_delivery';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';

  static const String paymentPending = 'pending';
  static const String paymentPaid = 'paid';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';
  final RefundService _refundService = RefundService();

  T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T value) test) {
    for (final value in values) {
      if (test(value)) return value;
    }
    return null;
  }

  String _generateOrderId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'ORD$random';
  }

  String _generateDeliveryOtp() {
    final now = DateTime.now();
    return '${now.millisecond % 9000 + 1000}';
  }

  Future<String> createOrder(Session session, protocol.Order order) async {
    final firestore = await FirebaseService.getFirestoreClient();

    order.orderId = _generateOrderId();
    order.deliveryOtp = _generateDeliveryOtp();
    order.status = statusPlaced;
    order.paymentStatus = paymentPending;
    order.refundStatus = 'none';
    order.orderedAt = DateTime.now();

    // --- BOGO Validation ---
    // Validate each free item: if the BOGO offer is inactive, remove the item
    final validatedItems = <protocol.OrderItem>[];
    for (final item in order.items) {
      if (item.isFreeItem && item.triggerProductId != null) {
        final triggerItem = _firstWhereOrNull(
          order.items,
          (candidate) =>
              !candidate.isFreeItem &&
              candidate.productId == item.triggerProductId,
        );
        if (triggerItem == null) continue;

        // Check if BOGO offer is still active for the trigger product
        final isValid = await _isBogoOfferActive(
          firestore,
          triggerProductId: item.triggerProductId!,
          freeProductId: item.productId,
          triggerVariantId: triggerItem.variantId,
        );
        if (!isValid) continue; // silently remove invalid free items
      }
      validatedItems.add(item);
    }
    order.items = validatedItems;

    // Recalculate totals after removing invalid free items
    // (totalAmount/finalAmount passed from client are trusted for paid items;
    //  free items never contribute to the total, so no recalc needed here)

    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$orderCollection/${order.orderId}';
    final fields = _orderToFirestore(order);
    fields['trackingEnabled'] = firestore_api.Value(booleanValue: false);
    fields['updatedAt'] = firestore_api.Value(
      timestampValue: DateTime.now().toUtc().toIso8601String(),
    );
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );

    if (order.couponApplied != null && order.couponApplied!.trim().isNotEmpty) {
      await CouponService.incrementCouponUsage(order.couponApplied!);
    }

    return order.orderId;
  }

  Future<String> createPendingOrder(
    Session session,
    protocol.Order order,
    String idempotencyKey,
  ) async {
    final existingOrderId = await _orderIdempotencyService.getOrderIdForKey(
      idempotencyKey,
    );
    if (existingOrderId != null) {
      return existingOrderId;
    }

    final orderId = await createOrder(session, order);
    await _orderIdempotencyService.saveKey(
      key: idempotencyKey,
      userId: order.userId,
      orderId: orderId,
    );

    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$orderCollection/$orderId';
    final fields = <String, firestore_api.Value>{
      'idempotencyKey': firestore_api.Value(stringValue: idempotencyKey),
      'trackingEnabled': firestore_api.Value(booleanValue: false),
      'updatedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    };
    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );
    return orderId;
  }

  /// Returns true if the BOGO offer for [triggerProductId] is active
  /// and [freeProductId] is still in its freeProductIds list.
  Future<bool> _isBogoOfferActive(
    FirestoreApi firestore, {
    required String triggerProductId,
    required String freeProductId,
    required String? triggerVariantId,
  }) async {
    try {
      final database = 'projects/$projectId/databases/(default)/documents';
      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: bogoCollection),
        ],
        where: firestore_api.Filter(
          compositeFilter: firestore_api.CompositeFilter(
            op: 'AND',
            filters: [
              firestore_api.Filter(
                fieldFilter: firestore_api.FieldFilter(
                  field: firestore_api.FieldReference(
                    fieldPath: 'triggerProductId',
                  ),
                  op: 'EQUAL',
                  value: firestore_api.Value(stringValue: triggerProductId),
                ),
              ),
              firestore_api.Filter(
                fieldFilter: firestore_api.FieldFilter(
                  field: firestore_api.FieldReference(
                    fieldPath: 'isActive',
                  ),
                  op: 'EQUAL',
                  value: firestore_api.Value(booleanValue: true),
                ),
              ),
            ],
          ),
        ),
        limit: 1,
      );
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );
      for (final res in response) {
        if (res.document?.fields != null) {
          final fields = res.document!.fields!;
          final freeProductIdsList =
              fields['freeProductIds']?.arrayValue?.values
                  ?.map((v) => v.stringValue ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList() ??
              [];
          if (!freeProductIdsList.contains(freeProductId)) {
            return false;
          }

          final triggerProduct = await _fetchProductById(
            firestore,
            triggerProductId,
          );
          if (triggerProduct == null) return false;

          final offer = protocol.BogoOffer(
            offerId: fields['offerId']?.stringValue,
            triggerProductId:
                fields['triggerProductId']?.stringValue ?? triggerProductId,
            triggerVariantId: fields['triggerVariantId']?.stringValue,
            minTriggerQuantity: 1,
            triggerBaseQuantity: double.tryParse(
              fields['triggerBaseQuantity']?.doubleValue?.toString() ??
                  fields['triggerBaseQuantity']?.integerValue?.toString() ??
                  '',
            ),
            triggerBaseUnit: fields['triggerBaseUnit']?.stringValue,
            freeProductIds: freeProductIdsList,
            freeProducts: null,
            offerTitle: fields['offerTitle']?.stringValue ?? 'Buy 1 Get 1',
            isActive: fields['isActive']?.booleanValue ?? true,
            startDate:
                DateTime.tryParse(fields['startDate']?.timestampValue ?? '') ??
                DateTime.now(),
            endDate:
                DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
                DateTime.now(),
            createdAt:
                DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
                DateTime.now(),
          );

          return isBogoTriggerEligible(
            triggerProduct: triggerProduct,
            offer: offer,
            selectedVariantId: triggerVariantId,
          );
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<protocol.Product?> _fetchProductById(
    FirestoreApi firestore,
    String productId,
  ) async {
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/Products/$productId';
    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      if (doc.fields == null) return null;
      return _mapProductFromFirestore(doc.fields!);
    } catch (_) {
      return null;
    }
  }

  protocol.Product _mapProductFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    final variants = <protocol.ProductVariant>[];
    final rawVariants = fields['variants']?.arrayValue?.values ?? const [];
    for (final value in rawVariants) {
      final variantFields = value.mapValue?.fields;
      if (variantFields == null) continue;
      variants.add(
        protocol.ProductVariant(
          variantId: variantFields['variantId']?.stringValue ?? 'default',
          quantityValue:
              double.tryParse(
                variantFields['quantityValue']?.doubleValue?.toString() ??
                    variantFields['quantityValue']?.integerValue?.toString() ??
                    '1',
              ) ??
              1,
          quantityUnit: variantFields['quantityUnit']?.stringValue ?? 'pc',
          quantityDescription:
              variantFields['quantityDescription']?.stringValue,
          price:
              double.tryParse(
                variantFields['price']?.doubleValue?.toString() ??
                    variantFields['price']?.integerValue?.toString() ??
                    '0',
              ) ??
              0,
          realPrice:
              double.tryParse(
                variantFields['realPrice']?.doubleValue?.toString() ??
                    variantFields['realPrice']?.integerValue?.toString() ??
                    '0',
              ) ??
              0,
          isAvailable: variantFields['isAvailable']?.booleanValue ?? true,
          sortOrder: int.tryParse(
            variantFields['sortOrder']?.integerValue?.toString() ?? '0',
          ),
        ),
      );
    }

    return protocol.Product(
      productId: fields['productId']?.stringValue,
      productName: fields['productName']?.stringValue ?? '',
      category: fields['category']?.stringValue ?? '',
      imageUrl: fields['imageUrl']?.stringValue ?? '',
      price:
          double.tryParse(
            fields['price']?.doubleValue?.toString() ??
                fields['price']?.integerValue?.toString() ??
                '0',
          ) ??
          0,
      realPrice:
          double.tryParse(
            fields['realPrice']?.doubleValue?.toString() ??
                fields['realPrice']?.integerValue?.toString() ??
                '0',
          ) ??
          0,
      discount:
          double.tryParse(
            fields['discount']?.doubleValue?.toString() ??
                fields['discount']?.integerValue?.toString() ??
                '0',
          ) ??
          0,
      isAvailable: fields['isAvailable']?.booleanValue ?? true,
      addedAt:
          DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
          DateTime.now(),
      subcategory: fields['subcategory']?.arrayValue?.values
              ?.map((value) => value.stringValue ?? '')
              .toList() ??
          const <String>[],
      quantity: fields['quantity']?.stringValue ?? '1',
      baseUnit: fields['baseUnit']?.stringValue,
      baseQuantity: double.tryParse(
        fields['baseQuantity']?.doubleValue?.toString() ??
            fields['baseQuantity']?.integerValue?.toString() ??
            '',
      ),
      mostSearch: int.tryParse(fields['mostSearch']?.integerValue ?? '0') ?? 0,
      mostPurchases:
          int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ?? 0,
      variants: variants.isEmpty ? null : variants,
    );
  }

  Future<List<protocol.Order>> getOrders(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final orders = await _fetchAllOrders(session);
    if (status == null) return orders;
    return orders.where((order) => order.status == status).toList();
  }

  Future<protocol.OrderPage> getOrdersPage(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final page = await _fetchOrdersPage(
      session,
      status: status,
      limit: limit,
      pageToken: pageToken,
    );
    final totalCount = await _countOrders(session, status: status);

    return protocol.OrderPage(
      orders: page.orders,
      nextPageToken: page.nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> getOrdersCount(
    Session session, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _countOrders(session, status: status);
  }

  Future<List<protocol.Order>> getTodayOrders(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final allOrders = await _fetchAllOrders(session);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final orders = <protocol.Order>[];
    for (final order in allOrders) {
      if (order.orderedAt.isAfter(startOfDay) ||
          order.orderedAt.isAtSameMomentAs(startOfDay)) {
        orders.add(order);
      }
    }
    return orders;
  }

  Future<List<protocol.Order>> _fetchAllOrders(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: orderCollection)],
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'orderedAt'),
          direction: 'DESCENDING',
        ),
      ],
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final orders = <protocol.Order>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        final order = _orderFromFirestore(
          res.document!.fields!,
          res.document!.name!.split('/').last,
        );
        orders.add(order);
      }
    }
    return orders;
  }

  Future<protocol.OrderPage> _fetchOrdersPage(
    Session session, {
    String? status,
    required int limit,
    String? pageToken,
  }) async {
    try {
      return await _fetchOrdersPageWithOrdering(
        session,
        status: status,
        limit: limit,
        pageToken: pageToken,
        includeOrderId: true,
      );
    } catch (_) {
      try {
        return await _fetchOrdersPageWithOrdering(
          session,
          status: status,
          limit: limit,
          pageToken: pageToken,
          includeOrderId: false,
        );
      } catch (_) {
        return await _fetchOrdersPageInMemory(
          session,
          status: status,
          limit: limit,
          pageToken: pageToken,
        );
      }
    }
  }

  Future<protocol.OrderPage> _fetchOrdersPageWithOrdering(
    Session session, {
    String? status,
    required int limit,
    String? pageToken,
    required bool includeOrderId,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    firestore_api.Filter? filter;
    if (status != null && status.trim().isNotEmpty) {
      filter = firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'status'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: status.trim()),
        ),
      );
    }

    firestore_api.Cursor? cursor;
    final decoded = _decodePageToken(pageToken);
    if (decoded != null) {
      final orderedAtRaw = decoded['orderedAt'];
      final orderId = decoded['orderId'];
      final orderedAt = DateTime.tryParse(orderedAtRaw ?? '');
      if (orderedAt != null) {
        if (includeOrderId && orderId != null && orderId.isNotEmpty) {
          cursor = firestore_api.Cursor(
            values: [
              firestore_api.Value(
                timestampValue: orderedAt.toUtc().toIso8601String(),
              ),
              firestore_api.Value(stringValue: orderId),
            ],
            before: false,
          );
        } else if (!includeOrderId) {
          cursor = firestore_api.Cursor(
            values: [
              firestore_api.Value(
                timestampValue: orderedAt.toUtc().toIso8601String(),
              ),
            ],
            before: false,
          );
        }
      }
    }

    final orderBy = <firestore_api.Order>[
      firestore_api.Order(
        field: firestore_api.FieldReference(fieldPath: 'orderedAt'),
        direction: 'DESCENDING',
      ),
    ];
    if (includeOrderId) {
      orderBy.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'orderId'),
          direction: 'DESCENDING',
        ),
      );
    }

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: orderCollection)],
      where: filter,
      orderBy: orderBy,
      limit: limit,
      startAt: cursor,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final orders = <protocol.Order>[];
    String? lastOrderedAt;
    String? lastOrderId;
    for (final res in response) {
      if (res.document?.fields == null) continue;
      final fields = res.document!.fields!;
      final order = _orderFromFirestore(
        fields,
        res.document!.name!.split('/').last,
      );
      orders.add(order);
      lastOrderedAt = fields['orderedAt']?.timestampValue;
      lastOrderId = fields['orderId']?.stringValue ?? order.orderId;
    }

    String? nextPageToken;
    if (orders.length == limit && lastOrderedAt != null) {
      if (includeOrderId && lastOrderId != null && lastOrderId.isNotEmpty) {
        nextPageToken = _encodePageToken({
          'orderedAt': lastOrderedAt,
          'orderId': lastOrderId,
        });
      } else {
        nextPageToken = _encodePageToken({'orderedAt': lastOrderedAt});
      }
    }

    return protocol.OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: orders.length,
    );
  }

  Future<protocol.OrderPage> _fetchOrdersPageInMemory(
    Session session, {
    String? status,
    required int limit,
    String? pageToken,
  }) async {
    final orders = await _fetchAllOrders(session);
    final filtered = (status == null || status.trim().isEmpty)
        ? orders
        : orders.where((o) => o.status == status.trim()).toList();

    filtered.sort((a, b) {
      final cmp = b.orderedAt.compareTo(a.orderedAt);
      if (cmp != 0) return cmp;
      return b.orderId.compareTo(a.orderId);
    });

    final offset = _decodeOffsetToken(pageToken) ?? 0;
    final pageOrders = filtered.skip(offset).take(limit).toList();
    final nextOffset = offset + pageOrders.length;
    final nextPageToken = nextOffset < filtered.length
        ? _encodeOffsetToken(nextOffset)
        : null;

    return protocol.OrderPage(
      orders: pageOrders,
      nextPageToken: nextPageToken,
      totalCount: filtered.length,
    );
  }

  Future<int> _countOrders(Session session, {String? status}) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    firestore_api.Filter? filter;
    if (status != null && status.trim().isNotEmpty) {
      filter = firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'status'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: status.trim()),
        ),
      );
    }

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: orderCollection)],
      where: filter,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    var count = 0;
    for (final res in response) {
      if (res.document != null) count++;
    }
    return count;
  }

  String _encodePageToken(Map<String, String> payload) {
    return base64Url.encode(utf8.encode(jsonEncode(payload)));
  }

  Map<String, String>? _decodePageToken(String? token) {
    if (token == null || token.trim().isEmpty) return null;
    try {
      final decoded = utf8.decode(base64Url.decode(token));
      final map = jsonDecode(decoded);
      if (map is Map<String, dynamic>) {
        return map.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String _encodeOffsetToken(int offset) {
    return base64Url.encode(utf8.encode(jsonEncode({'offset': offset})));
  }

  int? _decodeOffsetToken(String? token) {
    if (token == null || token.trim().isEmpty) return null;
    try {
      final decoded = utf8.decode(base64Url.decode(token));
      final map = jsonDecode(decoded);
      if (map is Map<String, dynamic>) {
        final raw = map['offset'];
        if (raw is int) return raw;
        return int.tryParse(raw?.toString() ?? '');
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<protocol.Order>> getUserOrders(
    Session session,
    String userId,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: orderCollection)],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'userId'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: userId),
        ),
      ),
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final orders = <protocol.Order>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        orders.add(
          _orderFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    orders.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    return orders;
  }

  Future<protocol.Order?> getOrderById(Session session, String orderId) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$orderCollection/$orderId';

    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      if (doc.fields == null) return null;
      return _orderFromFirestore(doc.fields!, orderId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateOrderStatus(
    Session session,
    String orderId,
    String newStatus, {
    String? cancellationReason,
    required String firebaseUid,
    required String idToken,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
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
    final database = 'projects/$projectId/databases/(default)/documents';

    final now = DateTime.now();
    final updateFields = <String, firestore_api.Value>{
      'status': firestore_api.Value(stringValue: newStatus),
      'trackingEnabled': firestore_api.Value(
        booleanValue: newStatus == statusOutForDelivery,
      ),
      'updatedAt': firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      ),
    };

    if (newStatus == statusConfirmed) {
      updateFields['confirmedAt'] = firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      );
    } else if (newStatus == statusPacked) {
      updateFields['packedAt'] = firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      );
    } else if (newStatus == statusOutForDelivery) {
      updateFields['outForDeliveryAt'] = firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      );
    } else if (newStatus == statusDelivered) {
      updateFields['deliveredAt'] = firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      );
    } else if (newStatus == statusCancelled) {
      updateFields['cancelledAt'] = firestore_api.Value(
        timestampValue: now.toUtc().toIso8601String(),
      );
      if (cancellationReason != null) {
        updateFields['cancellationReason'] = firestore_api.Value(
          stringValue: cancellationReason,
        );
      }
    }

    final docPath = '$database/$orderCollection/$orderId';
    final doc = firestore_api.Document(fields: updateFields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: updateFields.keys.toList(),
    );

    if (newStatus == statusDelivered && existingOrder.userId.isNotEmpty) {
      await _incrementCompletedOrdersCount(existingOrder.userId);
    }
    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
      action: 'update_status',
      entityType: 'order',
      entityId: orderId,
      metadata: {'newStatus': newStatus},
    );

    if (existingOrder.userId.isNotEmpty) {
      if (newStatus == statusOutForDelivery) {
        await NotificationService.notifyDeliveryStarted(
          userId: existingOrder.userId,
          orderId: orderId,
        );
      } else {
        await NotificationService.notifyUserStatusUpdate(
          userId: existingOrder.userId,
          orderId: orderId,
          status: newStatus,
        );
      }
    }

    return true;
  }

  Future<void> _incrementCompletedOrdersCount(String userId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final userDocPath =
        'projects/$projectId/databases/(default)/documents/users/$userId';
    int currentCount = 0;

    try {
      final doc = await firestore.projects.databases.documents.get(userDocPath);
      currentCount =
          int.tryParse(
            doc.fields?['completedOrdersCount']?.integerValue ?? '',
          ) ??
          0;
    } catch (_) {}

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(
        fields: {
          'completedOrdersCount': firestore_api.Value(
            integerValue: (currentCount + 1).toString(),
          ),
        },
      ),
      userDocPath,
      updateMask_fieldPaths: ['completedOrdersCount'],
    );
  }

  Future<bool> updatePaymentStatus(
    Session session,
    String orderId,
    String paymentStatus, {
    String? razorpayPaymentId,
    required String firebaseUid,
    required String idToken,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validatePaymentStatus(paymentStatus);
    final database = 'projects/$projectId/databases/(default)/documents';

    final updateFields = <String, firestore_api.Value>{
      'paymentStatus': firestore_api.Value(stringValue: paymentStatus),
    };

    if (razorpayPaymentId != null) {
      updateFields['razorpayPaymentId'] = firestore_api.Value(
        stringValue: razorpayPaymentId,
      );
    }

    final docPath = '$database/$orderCollection/$orderId';
    final doc = firestore_api.Document(fields: updateFields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: updateFields.keys.toList(),
    );
    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
      action: 'update_payment_status',
      entityType: 'order',
      entityId: orderId,
      metadata: {'paymentStatus': paymentStatus},
    );

    return true;
  }

  Future<bool> confirmOrder(Session session, String orderId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$orderCollection/$orderId';
    final fields = <String, firestore_api.Value>{
      'status': firestore_api.Value(stringValue: statusConfirmed),
      'trackingEnabled': firestore_api.Value(booleanValue: false),
      'updatedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      'confirmedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    };
    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );
    return true;
  }

  Future<bool> cancelOrder(
    Session session,
    String orderId,
    String userId, {
    String reason = 'user_cancelled',
  }) async {
    final order = await getOrderById(session, orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.userId != userId) {
      throw ArgumentError('Order does not belong to user.');
    }
    if (order.status == statusCancelled) {
      return true;
    }

    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$orderCollection/$orderId';
    final fields = <String, firestore_api.Value>{
      'status': firestore_api.Value(stringValue: statusCancelled),
      'trackingEnabled': firestore_api.Value(booleanValue: false),
      'updatedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      'cancelledAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      'cancellationReason': firestore_api.Value(stringValue: reason),
    };

    if (order.paymentStatus == paymentPaid &&
        order.razorpayPaymentId != null &&
        order.razorpayPaymentId!.isNotEmpty) {
      await _refundService.initiateRefund(orderId: orderId, reason: reason);
      fields['refundStatus'] = firestore_api.Value(stringValue: 'initiated');
    }

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );

    if (order.userId.isNotEmpty) {
      await NotificationService.notifyUserStatusUpdate(
        userId: order.userId,
        orderId: orderId,
        status: statusCancelled,
      );
    }
    return true;
  }

  Future<bool> assignDeliveryPerson(
    Session session,
    String orderId,
    String deliveryPersonName,
    String deliveryPersonPhone,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    if (deliveryPersonName.trim().isEmpty ||
        deliveryPersonPhone.trim().isEmpty) {
      throw ArgumentError('Delivery person name and phone are required');
    }
    final database = 'projects/$projectId/databases/(default)/documents';

    final updateFields = <String, firestore_api.Value>{
      'deliveryPersonName': firestore_api.Value(
        stringValue: deliveryPersonName,
      ),
      'deliveryPersonPhone': firestore_api.Value(
        stringValue: deliveryPersonPhone,
      ),
    };

    final docPath = '$database/$orderCollection/$orderId';
    final doc = firestore_api.Document(fields: updateFields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: updateFields.keys.toList(),
    );
    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
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

    double todayRevenue = 0;
    double totalRevenue = 0;
    int pendingCount = 0;
    int confirmedCount = 0;
    int outForDeliveryCount = 0;
    int deliveredCount = 0;
    int cancelledCount = 0;

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

  protocol.Order _orderFromFirestore(
    Map<String, firestore_api.Value> fields,
    String orderId,
  ) {
    return protocol.Order(
      orderId: orderId,
      userId: fields['userId']?.stringValue ?? '',
      userName: fields['userName']?.stringValue,
      userPhone: fields['userPhone']?.stringValue ?? '',
      items:
          fields['items']?.arrayValue?.values
              ?.map((v) => _orderItemFromFirestore(v.mapValue?.fields ?? {}))
              .toList() ??
          [],
      itemCount: int.tryParse(fields['itemCount']?.integerValue ?? '0') ?? 0,
      totalAmount: _getDoubleValue(fields, 'totalAmount'),
      discountAmount: _getDoubleValue(fields, 'discountAmount'),
      deliveryFee: _getDoubleValue(fields, 'deliveryFee'),
      finalAmount: _getDoubleValue(fields, 'finalAmount'),
      status: _normalizeStatus(fields['status']?.stringValue ?? statusPlaced),
      paymentStatus: fields['paymentStatus']?.stringValue ?? paymentPending,
      refundStatus: fields['refundStatus']?.stringValue ?? 'none',
      razorpayOrderId: fields['razorpayOrderId']?.stringValue,
      razorpayPaymentId: fields['razorpayPaymentId']?.stringValue,
      deliveryAddress: _addressFromFirestore(
        fields['deliveryAddress']?.mapValue?.fields ?? {},
      ),
      orderedAt:
          DateTime.tryParse(fields['orderedAt']?.timestampValue ?? '') ??
          DateTime.now(),
      confirmedAt: fields['confirmedAt']?.timestampValue != null
          ? DateTime.tryParse(fields['confirmedAt']!.timestampValue!)
          : null,
      outForDeliveryAt: fields['outForDeliveryAt']?.timestampValue != null
          ? DateTime.tryParse(fields['outForDeliveryAt']!.timestampValue!)
          : null,
      deliveredAt: fields['deliveredAt']?.timestampValue != null
          ? DateTime.tryParse(fields['deliveredAt']!.timestampValue!)
          : null,
      cancelledAt: fields['cancelledAt']?.timestampValue != null
          ? DateTime.tryParse(fields['cancelledAt']!.timestampValue!)
          : null,
      cancellationReason: fields['cancellationReason']?.stringValue,
      deliveryPersonName: fields['deliveryPersonName']?.stringValue,
      deliveryPersonPhone: fields['deliveryPersonPhone']?.stringValue,
      deliveryOtp: fields['deliveryOtp']?.stringValue,
      couponApplied: fields['couponApplied']?.stringValue,
    );
  }

  double _getDoubleValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, firestore_api.Value> _orderToFirestore(protocol.Order order) {
    return {
      'orderId': firestore_api.Value(stringValue: order.orderId),
      'userId': firestore_api.Value(stringValue: order.userId),
      'userPhone': firestore_api.Value(stringValue: order.userPhone),
      'items': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: order.items.map(_orderItemToFirestore).toList(),
        ),
      ),
      'itemCount': firestore_api.Value(
        integerValue: order.itemCount.toString(),
      ),
      'totalAmount': firestore_api.Value(doubleValue: order.totalAmount),
      'discountAmount': firestore_api.Value(doubleValue: order.discountAmount),
      'deliveryFee': firestore_api.Value(doubleValue: order.deliveryFee),
      'finalAmount': firestore_api.Value(doubleValue: order.finalAmount),
      'status': firestore_api.Value(stringValue: order.status),
      'paymentStatus': firestore_api.Value(stringValue: order.paymentStatus),
      'refundStatus': firestore_api.Value(stringValue: order.refundStatus),
      'deliveryAddress': firestore_api.Value(
        mapValue: firestore_api.MapValue(
          fields: _addressToFirestore(order.deliveryAddress),
        ),
      ),
      'orderedAt': firestore_api.Value(
        timestampValue: order.orderedAt.toUtc().toIso8601String(),
      ),
      if (order.razorpayOrderId != null)
        'razorpayOrderId': firestore_api.Value(
          stringValue: order.razorpayOrderId!,
        ),
      if (order.razorpayPaymentId != null)
        'razorpayPaymentId': firestore_api.Value(
          stringValue: order.razorpayPaymentId!,
        ),
      if (order.userName != null)
        'userName': firestore_api.Value(stringValue: order.userName!),
      if (order.confirmedAt != null)
        'confirmedAt': firestore_api.Value(
          timestampValue: order.confirmedAt!.toUtc().toIso8601String(),
        ),
      if (order.outForDeliveryAt != null)
        'outForDeliveryAt': firestore_api.Value(
          timestampValue: order.outForDeliveryAt!.toUtc().toIso8601String(),
        ),
      if (order.deliveredAt != null)
        'deliveredAt': firestore_api.Value(
          timestampValue: order.deliveredAt!.toUtc().toIso8601String(),
        ),
      if (order.cancelledAt != null)
        'cancelledAt': firestore_api.Value(
          timestampValue: order.cancelledAt!.toUtc().toIso8601String(),
        ),
      if (order.cancellationReason != null)
        'cancellationReason': firestore_api.Value(
          stringValue: order.cancellationReason!,
        ),
      if (order.deliveryPersonName != null)
        'deliveryPersonName': firestore_api.Value(
          stringValue: order.deliveryPersonName!,
        ),
      if (order.deliveryPersonPhone != null)
        'deliveryPersonPhone': firestore_api.Value(
          stringValue: order.deliveryPersonPhone!,
        ),
      if (order.deliveryOtp != null)
        'deliveryOtp': firestore_api.Value(stringValue: order.deliveryOtp!),
      if (order.couponApplied != null)
        'couponApplied': firestore_api.Value(stringValue: order.couponApplied!),
    };
  }

  protocol.OrderItem _orderItemFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    return protocol.OrderItem(
      productId: fields['productId']?.stringValue ?? '',
      variantId: fields['variantId']?.stringValue,
      variantLabel: fields['variantLabel']?.stringValue,
      productName: fields['productName']?.stringValue ?? '',
      productImage: fields['productImage']?.stringValue ?? '',
      quantity: int.tryParse(fields['quantity']?.integerValue ?? '0') ?? 0,
      unitPrice: _getDoubleValue(fields, 'unitPrice'),
      totalPrice: _getDoubleValue(fields, 'totalPrice'),
      isFreeItem: fields['isFreeItem']?.booleanValue ?? false,
      triggerProductId: fields['triggerProductId']?.stringValue,
    );
  }

  String _normalizeStatus(String status) {
    final value = status.toLowerCase().trim();
    if (value.isEmpty || value == 'pending') return statusPlaced;
    return value;
  }

  firestore_api.Value _orderItemToFirestore(protocol.OrderItem item) {
    return firestore_api.Value(
      mapValue: firestore_api.MapValue(
        fields: {
          'productId': firestore_api.Value(stringValue: item.productId),
          if (item.variantId != null)
            'variantId': firestore_api.Value(stringValue: item.variantId!),
          if (item.variantLabel != null)
            'variantLabel': firestore_api.Value(
              stringValue: item.variantLabel!,
            ),
          'productName': firestore_api.Value(stringValue: item.productName),
          'productImage': firestore_api.Value(stringValue: item.productImage),
          'quantity': firestore_api.Value(
            integerValue: item.quantity.toString(),
          ),
          'unitPrice': firestore_api.Value(doubleValue: item.unitPrice),
          'totalPrice': firestore_api.Value(doubleValue: item.totalPrice),
          'isFreeItem': firestore_api.Value(booleanValue: item.isFreeItem),
          if (item.triggerProductId != null)
            'triggerProductId': firestore_api.Value(
              stringValue: item.triggerProductId!,
            ),
        },
      ),
    );
  }

  protocol.Address _addressFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    return protocol.Address(
      street: fields['street']?.stringValue ?? '',
      city: fields['city']?.stringValue ?? '',
      state: fields['state']?.stringValue ?? '',
      zipCode: fields['zipCode']?.stringValue ?? '',
      country: fields['country']?.stringValue ?? '',
      latitude: fields['latitude']?.doubleValue,
      longitude: fields['longitude']?.doubleValue,
    );
  }

  Map<String, firestore_api.Value> _addressToFirestore(
    protocol.Address address,
  ) {
    final map = <String, firestore_api.Value>{
      'street': firestore_api.Value(stringValue: address.street),
      'city': firestore_api.Value(stringValue: address.city),
      'state': firestore_api.Value(stringValue: address.state),
      'zipCode': firestore_api.Value(stringValue: address.zipCode),
      'country': firestore_api.Value(stringValue: address.country),
    };
    if (address.latitude != null) {
      map['latitude'] = firestore_api.Value(doubleValue: address.latitude);
    }
    if (address.longitude != null) {
      map['longitude'] = firestore_api.Value(doubleValue: address.longitude);
    }
    return map;
  }
}

final OrderIdempotencyService _orderIdempotencyService =
    OrderIdempotencyService();
