import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../notification_outbox_service.dart';
import 'postgres_support.dart';

class PostgresComplaintService {
  static const pendingStatus = 'Pending';
  static const underReviewStatus = 'Under Review';
  static const resolvedStatus = 'Resolved';
  static const rejectedStatus = 'Rejected';

  static const issueTypes = {
    'Wrong Product',
    'Damaged Product',
    'Defective Product',
    'Missing Item',
    'Expired Product',
    'Other',
  };

  static const statuses = {
    pendingStatus,
    underReviewStatus,
    resolvedStatus,
    rejectedStatus,
  };

  Future<Complaint> createComplaint(
    Session session, {
    required AppUserRow user,
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) async {
    final userId = user.id;
    if (userId == null) {
      throw Exception('Active user account required.');
    }

    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (order?.id == null) {
      throw Exception('Order not found.');
    }
    if (order!.userId != userId) {
      throw Exception('Order does not belong to you.');
    }
    if (order.orderStatus != 'delivered' || order.deliveredAt == null) {
      throw Exception('Complaints can be raised after delivery.');
    }

    final now = DateTime.now().toUtc();
    final deadline = order.deliveredAt!.toUtc().add(const Duration(days: 3));
    if (now.isAfter(deadline)) {
      throw Exception(
        'Complaint period expired. Complaints can be raised only within 3 days after delivery.',
      );
    }

    final itemUuid = parseUuid(orderItemId, fieldName: 'orderItemId');
    final item = await OrderItemRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemUuid) & t.orderId.equals(order.id!),
    );
    if (item?.id == null) throw Exception('Order item not found.');

    await _validateComplaintFields(
      issueType: issueType,
      description: description,
      imageUrls: imageUrls,
    );

    final existing = await ComplaintRow.db.findFirstRow(
      session,
      where: (t) => t.orderItemId.equals(itemUuid),
    );
    if (existing != null) {
      throw Exception('A complaint has already been submitted for this item.');
    }

    final rowData = ComplaintRow(
      userId: userId,
      orderId: order.id!,
      orderItemId: itemUuid,
      issueType: issueType.trim(),
      description: description.trim(),
      imageUrls: _cleanImageUrls(imageUrls),
      status: pendingStatus,
      createdAt: now,
      updatedAt: now,
    );

    ComplaintRow row;
    try {
      row = await ComplaintRow.db.insertRow(session, rowData);
    } catch (_) {
      final duplicate = await ComplaintRow.db.findFirstRow(
        session,
        where: (t) => t.orderItemId.equals(itemUuid),
      );
      if (duplicate != null) {
        throw Exception(
          'A complaint has already been submitted for this item.',
        );
      }
      rethrow;
    }

    await _notifyAdmin(session, row: row, orderNumber: order.orderNumber);
    return _mapComplaint(row, order: order, item: item!);
  }

  Future<ComplaintPage> listMyComplaints(
    Session session, {
    required AppUserRow user,
    int limit = 20,
    String? pageToken,
  }) async {
    final userId = user.id;
    if (userId == null) throw Exception('Active user account required.');
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
    );
    if (row == null) return null;
    if (row.userId != user.id) throw Exception('Complaint not found.');
    return _hydrateComplaint(session, row);
  }

  Future<Complaint> updateComplaintStatus(
    Session session, {
    required String complaintId,
    required String status,
  }) async {
    final cleanStatus = status.trim();
    if (!statuses.contains(cleanStatus) || cleanStatus == pendingStatus) {
      throw Exception('Unsupported complaint status.');
    }
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    final now = DateTime.now().toUtc();
    final updated = await ComplaintRow.db.updateById(
      session,
      row!.id!,
      columnValues: (t) => [
        t.status(cleanStatus),
        t.updatedAt(now),
      ],
    );
    final latest = updated ?? row.copyWith(status: cleanStatus, updatedAt: now);
    await _notifyUserStatus(session, row: latest);
    return (await _hydrateComplaint(session, latest))!;
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

  Future<void> _validateComplaintFields({
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) async {
    if (!issueTypes.contains(issueType.trim())) {
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
    if (urls.isEmpty) throw Exception('Please attach at least one image.');
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

  Future<ComplaintRow?> _getComplaintRow(
    Session session,
    String complaintId,
  ) {
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
    final itemIds = rows.map((row) => row.orderItemId).toSet();

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.id.inSet(orderIds),
    );
    final items = await OrderItemRow.db.find(
      session,
      where: (t) => t.id.inSet(itemIds),
    );
    final orderById = {for (final order in orders) order.id!.toString(): order};
    final itemById = {for (final item in items) item.id!.toString(): item};

    return [
      for (final row in rows)
        if (orderById[row.orderId.toString()] != null &&
            itemById[row.orderItemId.toString()] != null)
          _mapComplaint(
            row,
            order: orderById[row.orderId.toString()]!,
            item: itemById[row.orderItemId.toString()]!,
          ),
    ];
  }

  Complaint _mapComplaint(
    ComplaintRow row, {
    required CustomerOrderRow order,
    required OrderItemRow item,
  }) {
    return Complaint(
      complaintId: row.id?.toString() ?? '',
      userId: row.userId.toString(),
      orderId: row.orderId.toString(),
      orderNumber: order.orderNumber,
      orderItemId: row.orderItemId.toString(),
      productId: item.productId.toString(),
      variantId: item.productVariantId?.toString(),
      productName: item.productNameSnapshot,
      productImage: item.productImageUrlSnapshot ?? '',
      variantLabel: item.variantLabelSnapshot,
      quantity: item.quantity,
      issueType: row.issueType,
      description: row.description,
      imageUrls: row.imageUrls,
      status: row.status,
      adminReply: row.adminReply,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deliveredAt: order.deliveredAt,
    );
  }

  List<String> _cleanImageUrls(List<String> imageUrls) {
    return imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  Future<void> _notifyAdmin(
    Session session, {
    required ComplaintRow row,
    required String orderNumber,
  }) async {
    await NotificationOutboxService.instance.enqueueTopicNotification(
      session: session,
      topic: 'admin',
      title: 'New Product Complaint',
      body: 'User reported issue for Order #$orderNumber',
      type: 'complaint_created',
      entityType: 'complaint',
      entityId: row.id?.toString(),
      data: {
        'complaintId': row.id?.toString() ?? '',
        'orderId': orderNumber,
        'orderItemId': row.orderItemId.toString(),
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
    final title = 'Complaint ${row.status}';
    await NotificationOutboxService.instance.enqueueTopicNotification(
      session: session,
      topic: _userTopic(firebaseUid),
      title: title,
      body: 'Your product complaint status is now ${row.status}.',
      type: 'complaint_status',
      entityType: 'complaint',
      entityId: row.id?.toString(),
      targetAudience: 'user',
      data: {
        'complaintId': row.id?.toString() ?? '',
        'orderItemId': row.orderItemId.toString(),
        'status': row.status,
      },
    );
  }

  String _userTopic(String firebaseUid) {
    return 'user-${firebaseUid.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
  }
}
