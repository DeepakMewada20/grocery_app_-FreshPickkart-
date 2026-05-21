import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../notification_outbox_service.dart';
import 'postgres_refund_service.dart';
import 'postgres_support.dart';

class PostgresComplaintService {
  static const productType = 'product';
  static const deliveryType = 'delivery';

  static const pendingStatus = 'Pending';
  static const underReviewStatus = 'Under Review';
  static const resolvedStatus = 'Resolved';
  static const rejectedStatus = 'Rejected';

  static const productIssueTypes = {
    'Wrong Product',
    'Damaged Product',
    'Defective Product',
    'Missing Item',
    'Expired Product',
    'Other',
  };

  static const deliveryIssueTypes = {
    'Late Delivery',
    'Rider Not Reachable',
    'Wrong Address Attempt',
    'Order Not Received',
    'Damaged During Delivery',
    'Other',
  };

  static const statuses = {
    pendingStatus,
    underReviewStatus,
    resolvedStatus,
    rejectedStatus,
  };

  final PostgresRefundService _refunds = PostgresRefundService();
  final Random _random = Random();

  Future<Complaint> createComplaint(
    Session session, {
    required AppUserRow user,
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) {
    return createProductComplaint(
      session,
      user: user,
      orderNumber: orderNumber,
      selectedOrderItemIds: [orderItemId],
      issueType: issueType,
      title: issueType,
      description: description,
      imageUrls: imageUrls,
    );
  }

  Future<Complaint> createProductComplaint(
    Session session, {
    required AppUserRow user,
    required String orderNumber,
    required List<String> selectedOrderItemIds,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
  }) async {
    final userId = _requireUserId(user);
    final order = await _getOwnedOrder(session, userId, orderNumber);
    if (order.orderStatus != 'delivered' || order.deliveredAt == null) {
      throw Exception('Product complaints can be raised after delivery.');
    }

    final deadline = order.deliveredAt!.toUtc().add(const Duration(days: 3));
    if (DateTime.now().toUtc().isAfter(deadline)) {
      throw Exception(
        'Complaint period expired. Complaints can be raised only within 3 days after delivery.',
      );
    }

    _validateCommonFields(
      issueType: issueType,
      allowedIssueTypes: productIssueTypes,
      description: description,
      imageUrls: imageUrls,
      requireImage: true,
    );

    final cleanIds = selectedOrderItemIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (cleanIds.isEmpty) {
      throw Exception('Select at least one affected product.');
    }

    final itemUuids = cleanIds
        .map((id) => parseUuid(id, fieldName: 'orderItemId'))
        .toSet();
    final items = await OrderItemRow.db.find(
      session,
      where: (t) => t.orderId.equals(order.id!) & t.id.inSet(itemUuids),
    );
    if (items.length != itemUuids.length) {
      throw Exception(
        'One or more selected products were not found in this order.',
      );
    }

    await _ensureNoActiveComplaint(session, order.id!, productType);

    final products = items.map(_snapshotProduct).toList(growable: false);
    final now = DateTime.now().toUtc();
    final firstItem = items.first;
    final row = await ComplaintRow.db.insertRow(
      session,
      ComplaintRow(
        userId: userId,
        orderId: order.id!,
        orderItemId: firstItem.id,
        complaintType: productType,
        title: cleanNullableString(title) ?? issueType.trim(),
        selectedProducts: products,
        issueType: issueType.trim(),
        description: description.trim(),
        imageUrls: _cleanImageUrls(imageUrls),
        status: pendingStatus,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await _notifyAdmin(session, row: row, orderNumber: order.orderNumber);
    return _mapComplaint(row, order: order);
  }

  Future<Complaint> createDeliveryComplaint(
    Session session, {
    required AppUserRow user,
    required String orderNumber,
    required String issueType,
    String? title,
    required String description,
    List<String> imageUrls = const [],
  }) async {
    final userId = _requireUserId(user);
    final order = await _getOwnedOrder(session, userId, orderNumber);
    if (order.orderStatus == 'delivered') {
      throw Exception('Delivered orders can only use product complaints.');
    }
    if (order.orderStatus == 'cancelled') {
      throw Exception('Cancelled orders cannot receive delivery complaints.');
    }

    _validateCommonFields(
      issueType: issueType,
      allowedIssueTypes: deliveryIssueTypes,
      description: description,
      imageUrls: imageUrls,
      requireImage: false,
    );
    await _ensureNoActiveComplaint(session, order.id!, deliveryType);

    final now = DateTime.now().toUtc();
    final row = await ComplaintRow.db.insertRow(
      session,
      ComplaintRow(
        userId: userId,
        orderId: order.id!,
        orderItemId: null,
        complaintType: deliveryType,
        title: cleanNullableString(title) ?? issueType.trim(),
        selectedProducts: const [],
        issueType: issueType.trim(),
        description: description.trim(),
        imageUrls: _cleanImageUrls(imageUrls),
        status: pendingStatus,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await _notifyAdmin(session, row: row, orderNumber: order.orderNumber);
    return _mapComplaint(row, order: order);
  }

  Future<Complaint?> getActiveComplaintForOrder(
    Session session, {
    required AppUserRow user,
    required String orderNumber,
    required String complaintType,
  }) async {
    final userId = _requireUserId(user);
    final order = await _getOwnedOrder(session, userId, orderNumber);
    final row = await _findActiveComplaint(
      session,
      order.id!,
      _normalizeComplaintType(complaintType),
    );
    return row == null ? null : _hydrateComplaint(session, row);
  }

  Future<ComplaintPage> listMyComplaints(
    Session session, {
    required AppUserRow user,
    int limit = 20,
    String? pageToken,
  }) async {
    final userId = _requireUserId(user);
    return _listComplaints(
      session,
      userId: userId,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<ComplaintPage> listComplaints(
    Session session, {
    String? status,
    int limit = 20,
    String? pageToken,
  }) {
    return _listComplaints(
      session,
      status: cleanNullableString(status),
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<Complaint?> getMyComplaint(
    Session session, {
    required AppUserRow user,
    required String complaintId,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    if (row == null) return null;
    if (row.userId != user.id) throw Exception('Complaint not found.');
    return _hydrateComplaint(session, row);
  }

  Future<Complaint?> getComplaintAdmin(
    Session session, {
    required String complaintId,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    return row == null ? null : _hydrateComplaint(session, row);
  }

  Future<Complaint?> getComplaintForOrderItem(
    Session session, {
    required AppUserRow user,
    required String orderItemId,
  }) async {
    final itemUuid = parseUuid(orderItemId, fieldName: 'orderItemId');
    final row = await ComplaintRow.db.findFirstRow(
      session,
      where: (t) => t.orderItemId.equals(itemUuid),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    if (row == null) return null;
    if (row.userId != user.id) throw Exception('Complaint not found.');
    return _hydrateComplaint(session, row);
  }

  Future<Complaint> updateComplaintStatus(
    Session session, {
    required String complaintId,
    required String status,
    String? adminNote,
    String? resolutionType,
  }) async {
    final cleanStatus = status.trim();
    if (!statuses.contains(cleanStatus) || cleanStatus == pendingStatus) {
      throw Exception('Unsupported complaint status.');
    }
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    final updated = await _updateComplaintResolution(
      session,
      row!,
      status: cleanStatus,
      adminNote: adminNote,
      resolutionType: resolutionType,
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<Complaint> replyToComplaint(
    Session session, {
    required String complaintId,
    required String adminReply,
  }) async {
    final reply = adminReply.trim();
    if (reply.isEmpty) throw Exception('Admin reply is required.');
    if (reply.length > 2000) {
      throw Exception('Admin reply must be 2000 characters or less.');
    }
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    final now = DateTime.now().toUtc();
    final updated = await ComplaintRow.db.updateById(
      session,
      row!.id!,
      columnValues: (t) => [
        t.adminReply(reply),
        t.updatedAt(now),
      ],
    );
    return (await _hydrateComplaint(
      session,
      updated ?? row.copyWith(adminReply: reply, updatedAt: now),
    ))!;
  }

  Future<Complaint> rejectComplaint(
    Session session, {
    required String complaintId,
    String? adminNote,
  }) {
    return updateComplaintStatus(
      session,
      complaintId: complaintId,
      status: rejectedStatus,
      adminNote: adminNote,
      resolutionType: 'reject',
    );
  }

  Future<Complaint> refundComplaint(
    Session session, {
    required String complaintId,
    required double amount,
    String? adminNote,
  }) async {
    if (amount <= 0) {
      throw Exception('Refund amount must be greater than zero.');
    }
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    final order = await CustomerOrderRow.db.findById(session, row!.orderId);
    if (order == null) throw Exception('Order not found.');

    final cappedAmount = await _capComplaintRefundAmount(
      session,
      row: row,
      order: order,
      requestedAmount: amount,
    );
    if (cappedAmount <= 0) {
      throw Exception('No refundable amount remains for this complaint.');
    }

    await _refunds.refund(
      session,
      orderNumber: order.orderNumber,
      amount: cappedAmount,
      source: 'complaint_${row.complaintType}',
      reason: row.title.isEmpty ? row.issueType : row.title,
      complaintId: row.id,
    );
    final updated = await _updateComplaintResolution(
      session,
      row,
      status: resolvedStatus,
      adminNote: adminNote,
      resolutionType: row.complaintType == productType
          ? 'refund'
          : 'delivery_refund',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<double> calculateRefundCap(
    Session session, {
    required String complaintId,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    final order = await CustomerOrderRow.db.findById(session, row!.orderId);
    if (order == null) throw Exception('Order not found.');
    return _capComplaintRefundAmount(
      session,
      row: row,
      order: order,
      requestedAmount: double.maxFinite,
    );
  }

  Future<Complaint> retryDelivery(
    Session session, {
    required String complaintId,
    String? adminNote,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    if (row!.complaintType != deliveryType) {
      throw Exception(
        'Retry delivery is available only for delivery complaints.',
      );
    }
    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateById(
      session,
      row.orderId,
      columnValues: (t) => [
        t.orderStatus('confirmed'),
        t.updatedAt(now),
      ],
    );
    final updated = await _updateComplaintResolution(
      session,
      row,
      status: resolvedStatus,
      adminNote: adminNote,
      resolutionType: 'retry_delivery',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<Complaint> reassignRider(
    Session session, {
    required String complaintId,
    required String riderName,
    required String riderPhone,
    String? adminNote,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    if (row!.complaintType != deliveryType) {
      throw Exception(
        'Rider reassignment is available only for delivery complaints.',
      );
    }
    final name = riderName.trim();
    final phone = riderPhone.trim();
    if (name.isEmpty || phone.isEmpty) {
      throw Exception('Rider name and phone are required.');
    }
    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateById(
      session,
      row.orderId,
      columnValues: (t) => [
        t.deliveryPersonName(name),
        t.deliveryPersonPhone(phone),
        t.orderStatus('out_for_delivery'),
        t.updatedAt(now),
      ],
    );
    final updated = await _updateComplaintResolution(
      session,
      row,
      status: resolvedStatus,
      adminNote: adminNote,
      resolutionType: 'reassign_rider',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<Complaint> createReplacementOrder(
    Session session, {
    required String complaintId,
    String? adminNote,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    if (row!.complaintType != productType) {
      throw Exception('Replacement is available only for product complaints.');
    }
    if (row.selectedProducts.isEmpty) {
      throw Exception('Replacement requires selected products.');
    }
    final order = await CustomerOrderRow.db.findById(session, row.orderId);
    if (order == null) throw Exception('Order not found.');
    final address = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );
    if (address == null) throw Exception('Order address not found.');

    final now = DateTime.now().toUtc();
    final replacementNumber = _generateReplacementOrderNumber();
    await session.db.transaction<void>((transaction) async {
      final replacement = await CustomerOrderRow.db.insertRow(
        session,
        CustomerOrderRow(
          userId: order.userId,
          orderNumber: replacementNumber,
          orderStatus: 'confirmed',
          paymentStatus: 'paid',
          refundStatus: 'none',
          itemCount: row.selectedProducts.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          ),
          totalAmount: row.selectedProducts.fold<double>(
            0,
            (sum, item) => sum + item.totalPrice,
          ),
          discountAmount: 0,
          deliveryFee: 0,
          finalAmount: 0,
          placedAt: now,
          confirmedAt: now,
          deliveryOtp: (_random.nextInt(9000) + 1000).toString(),
          orderType: 'replacement',
          sourceOrderNumber: order.orderNumber,
          complaintId: row.id!.toString(),
          orderedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
      await OrderAddressRow.db.insertRow(
        session,
        OrderAddressRow(
          orderId: replacement.id!,
          recipientName: address.recipientName,
          phoneNumber: address.phoneNumber,
          streetLine1: address.streetLine1,
          city: address.city,
          state: address.state,
          postalCode: address.postalCode,
          country: address.country,
          latitude: address.latitude,
          longitude: address.longitude,
          createdAt: now,
        ),
        transaction: transaction,
      );
      await OrderItemRow.db.insert(
        session,
        row.selectedProducts
            .map(
              (item) => OrderItemRow(
                orderId: replacement.id!,
                productId: parseUuid(item.productId, fieldName: 'productId'),
                productVariantId: tryParseUuid(item.variantId),
                productNameSnapshot: item.productName,
                productImageUrlSnapshot: cleanNullableString(item.productImage),
                variantLabelSnapshot: cleanNullableString(item.variantLabel),
                quantity: item.quantity,
                unitPrice: 0,
                totalPrice: 0,
                isFreeItem: false,
                createdAt: now,
              ),
            )
            .toList(),
        transaction: transaction,
      );
    });

    final updated = await _updateComplaintResolution(
      session,
      row,
      status: resolvedStatus,
      adminNote: adminNote == null || adminNote.trim().isEmpty
          ? 'Replacement order $replacementNumber created.'
          : '${adminNote.trim()} Replacement order $replacementNumber created.',
      resolutionType: 'replacement',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  void _validateCommonFields({
    required String issueType,
    required Set<String> allowedIssueTypes,
    required String description,
    required List<String> imageUrls,
    required bool requireImage,
  }) {
    if (!allowedIssueTypes.contains(issueType.trim())) {
      throw Exception('Unsupported complaint issue type.');
    }
    final cleanDescription = description.trim();
    if (cleanDescription.length < 20) {
      throw Exception('Description must be at least 20 characters.');
    }
    if (cleanDescription.length > 2000) {
      throw Exception('Description must be 2000 characters or less.');
    }
    final urls = _cleanImageUrls(imageUrls);
    if (requireImage && urls.isEmpty) {
      throw Exception('Please attach at least one image.');
    }
    if (urls.length > 3) throw Exception('You can attach up to 3 images.');
  }

  Future<ComplaintPage> _listComplaints(
    Session session, {
    UuidValue? userId,
    String? status,
    int limit = 20,
    String? pageToken,
  }) async {
    final cursor = decodeCursor(pageToken);
    final before = cursor?['createdAt'] is String
        ? DateTime.tryParse(cursor!['createdAt'] as String)
        : null;
    final safeLimit = clampPageLimit(limit);

    final hasRowFilter =
        userId != null ||
        (status != null && status.isNotEmpty) ||
        before != null;
    final rows = await ComplaintRow.db.find(
      session,
      where: hasRowFilter
          ? (t) {
              Expression<dynamic>? expression;
              if (userId != null) expression = t.userId.equals(userId);
              if (status != null && status.isNotEmpty) {
                final statusExpression = t.status.equals(status);
                expression = expression == null
                    ? statusExpression
                    : expression & statusExpression;
              }
              if (before != null) {
                final beforeExpression = t.createdAt < before;
                expression = expression == null
                    ? beforeExpression
                    : expression & beforeExpression;
              }
              return expression!;
            }
          : null,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: safeLimit + 1,
    );

    final pageRows = rows.take(safeLimit).toList();
    final complaints = await _hydrateComplaints(session, pageRows);
    final hasCountFilter =
        userId != null || (status != null && status.isNotEmpty);
    final totalCount = await ComplaintRow.db.count(
      session,
      where: hasCountFilter
          ? (t) {
              Expression<dynamic>? expression;
              if (userId != null) expression = t.userId.equals(userId);
              if (status != null && status.isNotEmpty) {
                final statusExpression = t.status.equals(status);
                expression = expression == null
                    ? statusExpression
                    : expression & statusExpression;
              }
              return expression!;
            }
          : null,
    );

    return ComplaintPage(
      complaints: complaints,
      nextPageToken: rows.length > safeLimit
          ? encodeCursor({
              'createdAt': pageRows.last.createdAt.toIso8601String(),
            })
          : null,
      totalCount: totalCount,
    );
  }

  Future<ComplaintRow?> _getComplaintRow(Session session, String complaintId) {
    final uuid = parseUuid(complaintId, fieldName: 'complaintId');
    return ComplaintRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(uuid),
    );
  }

  Future<Complaint?> _hydrateComplaint(
    Session session,
    ComplaintRow row,
  ) async {
    final complaints = await _hydrateComplaints(session, [row]);
    return complaints.isEmpty ? null : complaints.single;
  }

  Future<List<Complaint>> _hydrateComplaints(
    Session session,
    List<ComplaintRow> rows,
  ) async {
    if (rows.isEmpty) return const [];
    final orderIds = rows.map((row) => row.orderId).toSet();
    final itemIds = rows
        .map((row) => row.orderItemId)
        .whereType<UuidValue>()
        .toSet();

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.id.inSet(orderIds),
    );
    final items = itemIds.isEmpty
        ? const <OrderItemRow>[]
        : await OrderItemRow.db.find(
            session,
            where: (t) => t.id.inSet(itemIds),
          );
    final orderById = {for (final order in orders) order.id!.toString(): order};
    final itemById = {for (final item in items) item.id!.toString(): item};

    return [
      for (final row in rows)
        if (orderById[row.orderId.toString()] != null)
          _mapComplaint(
            row,
            order: orderById[row.orderId.toString()]!,
            legacyItem: row.orderItemId == null
                ? null
                : itemById[row.orderItemId.toString()],
          ),
    ];
  }

  Complaint _mapComplaint(
    ComplaintRow row, {
    required CustomerOrderRow order,
    OrderItemRow? legacyItem,
  }) {
    final selected = row.selectedProducts.isNotEmpty
        ? row.selectedProducts
        : legacyItem == null
        ? const <ComplaintProductItem>[]
        : [_snapshotProduct(legacyItem)];
    final first = selected.isEmpty ? null : selected.first;
    return Complaint(
      complaintId: row.id?.toString() ?? '',
      userId: row.userId.toString(),
      orderId: row.orderId.toString(),
      orderNumber: order.orderNumber,
      complaintType: row.complaintType,
      title: row.title.isEmpty ? row.issueType : row.title,
      orderItemId: row.orderItemId?.toString() ?? first?.orderItemId,
      productId: first?.productId,
      variantId: first?.variantId,
      productName: first?.productName,
      productImage: first?.productImage,
      variantLabel: first?.variantLabel,
      quantity: first?.quantity,
      selectedProducts: selected,
      issueType: row.issueType,
      description: row.description,
      imageUrls: row.imageUrls,
      status: row.status,
      adminReply: row.adminReply,
      adminNote: row.adminNote,
      resolutionType: row.resolutionType,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deliveredAt: order.deliveredAt,
    );
  }

  ComplaintProductItem _snapshotProduct(OrderItemRow item) {
    return ComplaintProductItem(
      orderItemId: item.id?.toString() ?? '',
      productId: item.productId.toString(),
      variantId: item.productVariantId?.toString(),
      productName: item.productNameSnapshot,
      productImage: item.productImageUrlSnapshot ?? '',
      variantLabel: item.variantLabelSnapshot,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalPrice: item.totalPrice,
    );
  }

  Future<CustomerOrderRow> _getOwnedOrder(
    Session session,
    UuidValue userId,
    String orderNumber,
  ) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (order?.id == null) throw Exception('Order not found.');
    if (order!.userId != userId) {
      throw Exception('Order does not belong to you.');
    }
    return order;
  }

  UuidValue _requireUserId(AppUserRow user) {
    final userId = user.id;
    if (userId == null) throw Exception('Active user account required.');
    return userId;
  }

  String _normalizeComplaintType(String complaintType) {
    final normalized = complaintType.trim().toLowerCase();
    if (normalized == productType || normalized == deliveryType) {
      return normalized;
    }
    throw Exception('Unsupported complaint type.');
  }

  Future<void> _ensureNoActiveComplaint(
    Session session,
    UuidValue orderId,
    String complaintType,
  ) async {
    final existing = await _findActiveComplaint(
      session,
      orderId,
      complaintType,
    );
    if (existing != null) {
      throw Exception(
        'An active $complaintType complaint already exists for this order.',
      );
    }
  }

  Future<ComplaintRow?> _findActiveComplaint(
    Session session,
    UuidValue orderId,
    String complaintType,
  ) {
    return ComplaintRow.db.findFirstRow(
      session,
      where: (t) =>
          t.orderId.equals(orderId) &
          t.complaintType.equals(complaintType) &
          (t.status.equals(pendingStatus) | t.status.equals(underReviewStatus)),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  Future<ComplaintRow> _updateComplaintResolution(
    Session session,
    ComplaintRow row, {
    required String status,
    String? adminNote,
    String? resolutionType,
  }) async {
    final now = DateTime.now().toUtc();
    final cleanNote = cleanNullableString(adminNote);
    final cleanResolution = cleanNullableString(resolutionType);
    final updated = await ComplaintRow.db.updateById(
      session,
      row.id!,
      columnValues: (t) => [
        t.status(status),
        if (cleanNote != null) t.adminNote(cleanNote),
        if (cleanResolution != null) t.resolutionType(cleanResolution),
        t.updatedAt(now),
      ],
    );
    return updated ??
        row.copyWith(
          status: status,
          adminNote: cleanNote ?? row.adminNote,
          resolutionType: cleanResolution ?? row.resolutionType,
          updatedAt: now,
        );
  }

  Future<double> _capComplaintRefundAmount(
    Session session, {
    required ComplaintRow row,
    required CustomerOrderRow order,
    required double requestedAmount,
  }) async {
    final rows = await RefundRecordRow.db.find(
      session,
      where: (t) =>
          t.orderId.equals(order.id!) &
          (t.refundStatus.equals('pending') |
              t.refundStatus.equals('processed')),
    );
    final alreadyRefunded = rows.fold<double>(
      0,
      (sum, refund) => sum + refund.amount,
    );
    final remainingOrderRefundable = max<double>(
      0.0,
      order.finalAmount - alreadyRefunded,
    );
    if (row.complaintType == productType) {
      final selectedSubtotal = row.selectedProducts.fold<double>(
        0,
        (sum, item) => sum + item.totalPrice,
      );
      final productRefunds = rows
          .where((refund) => refund.source == 'complaint_product')
          .fold<double>(0, (sum, refund) => sum + refund.amount);
      final remainingProductRefundable = max<double>(
        0.0,
        selectedSubtotal - productRefunds,
      );
      return min<double>(
        requestedAmount,
        min<double>(remainingProductRefundable, remainingOrderRefundable),
      );
    }
    return min<double>(requestedAmount, remainingOrderRefundable);
  }

  List<String> _cleanImageUrls(List<String> imageUrls) {
    return imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  String _generateReplacementOrderNumber() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final suffix = (_random.nextInt(900) + 100).toString();
    return 'REP$millis$suffix';
  }

  Future<void> _notifyAdmin(
    Session session, {
    required ComplaintRow row,
    required String orderNumber,
  }) async {
    final label = row.complaintType == deliveryType ? 'Delivery' : 'Product';
    await NotificationOutboxService.instance.enqueueTopicNotification(
      session: session,
      topic: 'admin',
      title: 'New $label Complaint',
      body: 'User reported ${row.complaintType} issue for Order #$orderNumber',
      type: 'complaint_created',
      entityType: 'complaint',
      entityId: row.id?.toString(),
      data: {
        'complaintId': row.id?.toString() ?? '',
        'orderId': orderNumber,
        'complaintType': row.complaintType,
        if (row.orderItemId != null) 'orderItemId': row.orderItemId.toString(),
      },
    );
  }

  Future<void> _notifyUserStatus(
    Session session, {
    required ComplaintRow row,
  }) async {
    final user = await AppUserRow.db.findById(session, row.userId);
    final firebaseUid = user?.firebaseUid;
    if (firebaseUid == null || firebaseUid.trim().isEmpty) return;
    await NotificationOutboxService.instance.enqueueTopicNotification(
      session: session,
      topic: _userTopic(firebaseUid),
      title: 'Complaint ${row.status}',
      body: 'Your ${row.complaintType} complaint status is now ${row.status}.',
      type: 'complaint_status',
      entityType: 'complaint',
      entityId: row.id?.toString(),
      targetAudience: 'user',
      data: {
        'complaintId': row.id?.toString() ?? '',
        'complaintType': row.complaintType,
        'status': row.status,
      },
    );
  }

  String _userTopic(String firebaseUid) {
    return 'user-${firebaseUid.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
  }
}
