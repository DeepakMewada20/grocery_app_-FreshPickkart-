import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../notification_outbox_service.dart';
import '../order_outbox_service.dart';
import 'postgres_audit_log_service.dart';
import 'postgres_refund_service.dart';
import 'postgres_support.dart';

class PostgresComplaintService {
  static const productType = 'product';
  static const deliveryType = 'delivery';

  static const pendingStatus = 'Pending';
  static const underReviewStatus = 'Under Review';
  static const resolvedStatus = 'Resolved';
  static const rejectedStatus = 'Rejected';
  static const addressChangeField = 'address_change';
  static const deliveryNoteField = 'delivery_note';

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
    'Delivery Location Issue',
    'Order Taking Too Long',
    'Rider Could Not Find Address',
    'Other',
  };

  static const statuses = {
    pendingStatus,
    underReviewStatus,
    resolvedStatus,
    rejectedStatus,
  };

  final PostgresRefundService _refunds = PostgresRefundService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
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

    final deadline = order.deliveredAt!.toUtc().add(const Duration(days: 1));
    if (DateTime.now().toUtc().isAfter(deadline)) {
      throw Exception(
        'Complaint period expired. Complaints can be raised only within 1 day after delivery.',
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

    final address = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );
    final userPhone =
        address?.phoneNumber ?? cleanNullableString(user.phoneNumber) ?? '';

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
        userPhone: userPhone,
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
    String? selectedField,
    Address? requestedAddress,
    String? requestedNote,
    Map<String, String>? extraData,
  }) async {
    final userId = _requireUserId(user);
    final order = await _getOwnedOrder(session, userId, orderNumber);
    if (order.orderStatus == 'delivered') {
      throw Exception('Delivered orders can only use product complaints.');
    }
    if (order.orderStatus == 'cancelled') {
      throw Exception('Cancelled orders cannot receive delivery complaints.');
    }

    final isDeliveryLocation = issueType.trim() == 'Delivery Location Issue';
    _validateCommonFields(
      issueType: issueType,
      allowedIssueTypes: deliveryIssueTypes,
      description: description,
      imageUrls: imageUrls,
      requireImage: false,
      requireDescription: !isDeliveryLocation,
    );

    final cleanIssueType = issueType.trim();
    final cleanField = cleanNullableString(selectedField);
    final cleanNote = cleanNullableString(requestedNote);
    final address = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );
    final userPhone =
        address?.phoneNumber ?? cleanNullableString(user.phoneNumber) ?? '';

    String? resolvedField = cleanField;
    Map<String, String>? resolvedExtraData =
        extraData == null || extraData.isEmpty
        ? null
        : Map<String, String>.from(extraData);

    if (cleanIssueType == 'Delivery Location Issue') {
      resolvedField ??= requestedAddress != null
          ? addressChangeField
          : deliveryNoteField;
      if (resolvedField != addressChangeField &&
          resolvedField != deliveryNoteField) {
        throw Exception('Unsupported delivery location request.');
      }
      if (order.orderStatus != 'out_for_delivery') {
        throw Exception(
          'Delivery location issues can only be requested while the order is out for delivery.',
        );
      }
      if (resolvedField == addressChangeField && requestedAddress == null) {
        throw Exception('Requested address is required.');
      }
      if (resolvedField == deliveryNoteField && cleanNote == null) {
        throw Exception('Delivery note is required.');
      }
      resolvedExtraData = _buildDeliveryRequestExtraData(
        currentAddress: address,
        requestedAddress: requestedAddress,
        requestedNote: cleanNote,
        extraData: resolvedExtraData,
      );
    } else if (resolvedField != null ||
        requestedAddress != null ||
        cleanNote != null) {
      throw Exception(
        'Delivery location metadata is only supported for delivery location issues.',
      );
    }

    await _ensureNoActiveComplaint(session, order.id!, deliveryType);

    final now = DateTime.now().toUtc();
    final row = await ComplaintRow.db.insertRow(
      session,
      ComplaintRow(
        userId: userId,
        orderId: order.id!,
        orderItemId: null,
        complaintType: deliveryType,
        title: cleanNullableString(title) ?? cleanIssueType,
        selectedProducts: const [],
        issueType: cleanIssueType,
        selectedField: resolvedField,
        extraData: resolvedExtraData,
        userPhone: userPhone,
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
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    int limit = 20,
    String? pageToken,
  }) async {
    final userId = _requireUserId(user);
    return _listComplaints(
      session,
      userId: userId,
      status: cleanNullableString(status),
      issueType: cleanNullableString(issueType),
      selectedField: cleanNullableString(selectedField),
      complaintType: cleanNullableString(complaintType),
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<ComplaintPage> listComplaints(
    Session session, {
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    int limit = 20,
    String? pageToken,
  }) {
    return _listComplaints(
      session,
      status: cleanNullableString(status),
      issueType: cleanNullableString(issueType),
      selectedField: cleanNullableString(selectedField),
      complaintType: cleanNullableString(complaintType),
      limit: limit,
      pageToken: pageToken,
    );
  }

  void _validateCommonFields({
    required String issueType,
    required Set<String> allowedIssueTypes,
    required String description,
    required List<String> imageUrls,
    required bool requireImage,
    bool requireDescription = true,
  }) {
    if (!allowedIssueTypes.contains(issueType.trim())) {
      throw Exception('Unsupported complaint issue type.');
    }
    final cleanDescription = description.trim();
    if (requireDescription && cleanDescription.length < 20) {
      throw Exception('Description must be at least 20 characters.');
    }
    if (cleanDescription.length > 2000) {
      throw Exception('Description must be 2000 characters or less.');
    }
    final urls = _cleanImageUrls(imageUrls);
    if (requireImage && urls.isEmpty) {
      throw Exception('Please attach at least one image.');
    }
    if (urls.length > 3) {
      throw Exception('You can attach up to 3 images.');
    }
  }

  Future<ComplaintPage> _listComplaints(
    Session session, {
    UuidValue? userId,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
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
        (issueType != null && issueType.isNotEmpty) ||
        (selectedField != null && selectedField.isNotEmpty) ||
        (complaintType != null && complaintType.isNotEmpty) ||
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
              if (issueType != null && issueType.isNotEmpty) {
                final issueExpression = t.issueType.equals(issueType);
                expression = expression == null
                    ? issueExpression
                    : expression & issueExpression;
              }
              if (selectedField != null && selectedField.isNotEmpty) {
                final fieldExpression = t.selectedField.equals(selectedField);
                expression = expression == null
                    ? fieldExpression
                    : expression & fieldExpression;
              }
              if (complaintType != null && complaintType.isNotEmpty) {
                final typeExpression = t.complaintType.equals(complaintType);
                expression = expression == null
                    ? typeExpression
                    : expression & typeExpression;
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
        userId != null ||
        (status != null && status.isNotEmpty) ||
        (issueType != null && issueType.isNotEmpty) ||
        (selectedField != null && selectedField.isNotEmpty) ||
        (complaintType != null && complaintType.isNotEmpty);
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
              if (issueType != null && issueType.isNotEmpty) {
                final issueExpression = t.issueType.equals(issueType);
                expression = expression == null
                    ? issueExpression
                    : expression & issueExpression;
              }
              if (selectedField != null && selectedField.isNotEmpty) {
                final fieldExpression = t.selectedField.equals(selectedField);
                expression = expression == null
                    ? fieldExpression
                    : expression & fieldExpression;
              }
              if (complaintType != null && complaintType.isNotEmpty) {
                final typeExpression = t.complaintType.equals(complaintType);
                expression = expression == null
                    ? typeExpression
                    : expression & typeExpression;
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

  Future<Complaint> updateComplaintStatus(
    Session session, {
    required String complaintId,
    required String status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    String? actorFirebaseUid,
  }) async {
    final cleanStatus = status.trim();
    if (!statuses.contains(cleanStatus) || cleanStatus == pendingStatus) {
      throw Exception('Unsupported complaint status.');
    }
    final row = await _getComplaintRow(session, complaintId);
    if (row?.id == null) throw Exception('Complaint not found.');
    if (_isAddressChangeRequest(row!)) {
      if (cleanStatus == resolvedStatus) {
        final updated = await _approveAddressChange(
          session,
          row: row,
          adminReply: adminReply,
          adminNote: adminNote,
          resolutionType: resolutionType,
          actorFirebaseUid: actorFirebaseUid,
        );
        await _notifyUserStatus(session, row: updated);
        return (await _hydrateComplaint(session, updated))!;
      }
      if (cleanStatus == rejectedStatus) {
        final updated = await _rejectAddressChange(
          session,
          row: row,
          adminReply: adminReply,
          adminNote: adminNote,
          resolutionType: resolutionType,
          actorFirebaseUid: actorFirebaseUid,
        );
        await _notifyUserStatus(session, row: updated);
        return (await _hydrateComplaint(session, updated))!;
      }
    }
    final updated = await _updateComplaintResolution(
      session,
      row,
      status: cleanStatus,
      adminReply: adminReply,
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
    String? adminReply,
    String? adminNote,
  }) {
    return updateComplaintStatus(
      session,
      complaintId: complaintId,
      status: rejectedStatus,
      adminReply: adminReply,
      adminNote: adminNote,
      resolutionType: 'reject',
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

  Future<Complaint?> getComplaintAdmin(
    Session session, {
    required String complaintId,
  }) async {
    final row = await _getComplaintRow(session, complaintId);
    return row == null ? null : _hydrateComplaint(session, row);
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

  Future<Complaint> refundComplaint(
    Session session, {
    required String complaintId,
    required double amount,
    String? adminReply,
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

    final refund = await _refunds.refund(
      session,
      orderNumber: order.orderNumber,
      amount: cappedAmount,
      source: 'complaint_${row.complaintType}',
      reason: row.title.isEmpty ? row.issueType : row.title,
      complaintId: row.id,
    );
    if (refund.status == 'failed') {
      throw Exception(
        'Refund failed at payment gateway. Please try again.',
      );
    }
    final updated = await _updateComplaintResolution(
      session,
      row,
      status: resolvedStatus,
      adminReply: adminReply,
      adminNote: adminNote,
      resolutionType: row.complaintType == productType
          ? 'refund'
          : 'delivery_refund',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<Complaint> retryDelivery(
    Session session, {
    required String complaintId,
    String? adminReply,
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
      adminReply: adminReply,
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
    String? adminReply,
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
      adminReply: adminReply,
      adminNote: adminNote,
      resolutionType: 'reassign_rider',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
  }

  Future<Complaint> createReplacementOrder(
    Session session, {
    required String complaintId,
    String? adminReply,
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
      adminReply: adminReply,
      adminNote: adminNote == null || adminNote.trim().isEmpty
          ? 'Replacement order $replacementNumber created.'
          : '${adminNote.trim()} Replacement order $replacementNumber created.',
      resolutionType: 'replacement',
    );
    await _notifyUserStatus(session, row: updated);
    return (await _hydrateComplaint(session, updated))!;
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

    final items = itemIds.isEmpty
        ? const <OrderItemRow>[]
        : await OrderItemRow.db.find(
            session,
            where: (t) => t.id.inSet(itemIds),
          );
    final allOrderItems = await OrderItemRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final orderById = {for (final order in orders) order.id!.toString(): order};
    final itemById = {for (final item in items) item.id!.toString(): item};
    final orderItemsByOrderId = <String, List<OrderItemRow>>{};
    for (final item in allOrderItems) {
      final key = item.orderId.toString();
      orderItemsByOrderId.putIfAbsent(key, () => []).add(item);
    }

    final comboOfferIds = allOrderItems
        .map((item) => item.comboOfferId)
        .whereType<UuidValue>()
        .toSet();
    final bogoOfferIds = allOrderItems
        .map((item) => item.bogoOfferId)
        .whereType<UuidValue>()
        .toSet();
    final comboOffers = comboOfferIds.isEmpty
        ? const <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboOfferIds),
          );
    final comboById = {for (final combo in comboOffers) combo.id!: combo};
    final comboOfferItems = comboOfferIds.isEmpty
        ? const <ComboOfferItemRow>[]
        : await ComboOfferItemRow.db.find(
            session,
            where: (t) => t.comboOfferId.inSet(comboOfferIds),
          );
    final comboItemQuantityByKey = <String, int>{};
    for (final item in comboOfferItems) {
      comboItemQuantityByKey[_comboItemKey(
            item.comboOfferId,
            item.productId,
            item.productVariantId,
          )] =
          item.quantity;
    }
    final bogoOffers = bogoOfferIds.isEmpty
        ? const <BogoOfferRow>[]
        : await BogoOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(bogoOfferIds),
          );
    final bogoById = {for (final offer in bogoOffers) offer.id!: offer};

    return [
      for (final row in rows)
        if (orderById[row.orderId.toString()] != null)
          _mapComplaint(
            row,
            order: orderById[row.orderId.toString()]!,
            legacyItem: row.orderItemId == null
                ? null
                : itemById[row.orderItemId.toString()],
            orderItems: orderItemsByOrderId[row.orderId.toString()] ?? [],
            comboById: comboById,
            comboItemQuantityByKey: comboItemQuantityByKey,
            bogoById: bogoById,
            couponById: couponById,
          ),
    ];
  }

  Complaint _mapComplaint(
    ComplaintRow row, {
    required CustomerOrderRow order,
    OrderItemRow? legacyItem,
    List<OrderItemRow> orderItems = const [],
    Map<UuidValue, ComboOfferRow> comboById = const {},
    Map<String, int> comboItemQuantityByKey = const {},
    Map<UuidValue, BogoOfferRow> bogoById = const {},
    Map<UuidValue, CouponRow> couponById = const {},
  }) {
    final orderItemSnapshots = [
      for (final item in orderItems)
        _snapshotProduct(
          item,
          comboById: comboById,
          comboItemQuantityByKey: comboItemQuantityByKey,
          bogoById: bogoById,
        ),
    ];
    final snapshotById = {
      for (final item in orderItemSnapshots) item.orderItemId: item,
    };
    final selected = row.selectedProducts.isNotEmpty
        ? row.selectedProducts
              .map((item) => snapshotById[item.orderItemId] ?? item)
              .toList(growable: false)
        : legacyItem == null
        ? const <ComplaintProductItem>[]
        : [
            _snapshotProduct(
              legacyItem,
              comboById: comboById,
              comboItemQuantityByKey: comboItemQuantityByKey,
              bogoById: bogoById,
            ),
          ];
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
      selectedField: row.selectedField,
      extraData: row.extraData,
      userPhone: row.userPhone,
      description: row.description,
      imageUrls: row.imageUrls,
      status: row.status,
      adminReply: row.adminReply,
      adminNote: row.adminNote,
      resolutionType: row.resolutionType,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deliveredAt: order.deliveredAt,
      orderedAt: order.orderedAt,
      totalAmount: order.totalAmount,
      discountAmount: order.discountAmount,
      couponApplied: order.couponId == null
          ? null
          : couponById[order.couponId!]?.code ?? order.couponId.toString(),
      mrpTotal: order.mrpTotal,
      productDiscountAmount: order.productDiscountAmount,
      comboDiscountAmount: order.comboDiscountAmount,
      bogoDiscountAmount: order.bogoDiscountAmount,
      deliveryFee: order.deliveryFee,
      originalDeliveryFee: order.originalDeliveryFee,
      deliveryDiscountAmount: order.deliveryDiscountAmount,
      freeDeliveryApplied: order.freeDeliveryApplied,
      finalAmount: order.finalAmount,
      orderItems: orderItemSnapshots,
    );
  }

  ComplaintProductItem _snapshotProduct(
    OrderItemRow item, {
    Map<UuidValue, ComboOfferRow> comboById = const {},
    Map<String, int> comboItemQuantityByKey = const {},
    Map<UuidValue, BogoOfferRow> bogoById = const {},
  }) {
    final comboOfferId = item.comboOfferId;
    final combo = comboOfferId == null ? null : comboById[comboOfferId];
    final bogoOfferId = item.bogoOfferId;
    final bogo = bogoOfferId == null ? null : bogoById[bogoOfferId];
    final comboItemQuantity = comboOfferId == null
        ? null
        : comboItemQuantityByKey[_comboItemKey(
            comboOfferId,
            item.productId,
            item.productVariantId,
          )];

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
      isFreeItem: item.isFreeItem,
      triggerProductId: bogo?.triggerProductId.toString(),
      comboId: comboOfferId?.toString(),
      comboName: combo?.name,
      comboDiscountType: combo?.discountType,
      comboDiscountValue: combo?.discountValue,
      comboItemQuantity: comboItemQuantity,
    );
  }

  String _comboItemKey(
    UuidValue comboOfferId,
    UuidValue productId,
    UuidValue? productVariantId,
  ) {
    return [
      comboOfferId.toString(),
      productId.toString(),
      productVariantId?.toString() ?? '',
    ].join('|');
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
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    Transaction? transaction,
  }) async {
    final now = DateTime.now().toUtc();
    final cleanReply = cleanNullableString(adminReply);
    final cleanNote = cleanNullableString(adminNote);
    final cleanResolution = cleanNullableString(resolutionType);
    final updated = await ComplaintRow.db.updateById(
      session,
      row.id!,
      columnValues: (t) => [
        t.status(status),
        if (cleanReply != null) t.adminReply(cleanReply),
        if (cleanNote != null) t.adminNote(cleanNote),
        if (cleanResolution != null) t.resolutionType(cleanResolution),
        t.updatedAt(now),
      ],
      transaction: transaction,
    );
    return updated ??
        row.copyWith(
          status: status,
          adminReply: cleanReply ?? row.adminReply,
          adminNote: cleanNote ?? row.adminNote,
          resolutionType: cleanResolution ?? row.resolutionType,
          updatedAt: now,
        );
  }

  bool _isAddressChangeRequest(ComplaintRow row) {
    return row.complaintType == deliveryType &&
        row.issueType == 'Delivery Location Issue' &&
        row.selectedField == addressChangeField;
  }

  Future<ComplaintRow> _approveAddressChange(
    Session session, {
    required ComplaintRow row,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    String? actorFirebaseUid,
  }) async {
    final order = await CustomerOrderRow.db.findById(session, row.orderId);
    if (order == null) throw Exception('Order not found.');
    await session.db.transaction<void>((transaction) async {
      await _applyAddressChange(
        session,
        order: order,
        row: row,
        transaction: transaction,
      );
      await _updateComplaintResolution(
        session,
        row,
        status: resolvedStatus,
        adminReply: adminReply,
        adminNote: adminNote,
        resolutionType: resolutionType ?? 'address_change_approved',
        transaction: transaction,
      );
      await _audit.write(
        session,
        actorFirebaseUid: actorFirebaseUid,
        action: 'approve_address_change',
        entityType: 'complaint',
        entityId: row.id?.toString(),
        metadata: {
          'orderNumber': order.orderNumber,
          'selectedField': row.selectedField ?? '',
        },
        transaction: transaction,
      );
    });

    await OrderOutboxService.instance.enqueueOrderAddressUpdated(
      session: session,
      orderId: order.orderNumber,
      userId: order.userId.toString(),
      status: order.orderStatus,
    );

    final updated = await _getComplaintRow(session, row.id!.toString());
    if (updated == null) throw Exception('Complaint not found.');
    return updated;
  }

  Future<ComplaintRow> _rejectAddressChange(
    Session session, {
    required ComplaintRow row,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    String? actorFirebaseUid,
  }) async {
    final order = await CustomerOrderRow.db.findById(session, row.orderId);
    if (order == null) throw Exception('Order not found.');
    final cleanNote = cleanNullableString(adminNote);
    if (cleanNote == null) {
      throw Exception('A rejection reason is required.');
    }
    await session.db.transaction<void>((transaction) async {
      await _updateComplaintResolution(
        session,
        row,
        status: rejectedStatus,
        adminReply: adminReply,
        adminNote: cleanNote,
        resolutionType: resolutionType ?? 'address_change_rejected',
        transaction: transaction,
      );
      await _audit.write(
        session,
        actorFirebaseUid: actorFirebaseUid,
        action: 'reject_address_change',
        entityType: 'complaint',
        entityId: row.id?.toString(),
        metadata: {
          'orderNumber': order.orderNumber,
          'selectedField': row.selectedField ?? '',
          'reason': cleanNote,
        },
        transaction: transaction,
      );
    });

    final updated = await _getComplaintRow(session, row.id!.toString());
    if (updated == null) throw Exception('Complaint not found.');
    return updated;
  }

  Future<void> _applyAddressChange(
    Session session, {
    required CustomerOrderRow order,
    required ComplaintRow row,
    required Transaction transaction,
  }) async {
    final requestedAddress = _requestedAddressFromRow(row);
    if (requestedAddress == null) {
      throw Exception('Requested address not found in complaint metadata.');
    }

    final orderAddress = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (orderAddress == null) {
      throw Exception('Order address not found.');
    }

    final now = DateTime.now().toUtc();
    await OrderAddressRow.db.updateById(
      session,
      orderAddress.id!,
      columnValues: (t) => [
        t.streetLine1(requestedAddress.street),
        t.city(requestedAddress.city),
        t.state(requestedAddress.state),
        t.postalCode(requestedAddress.zipCode),
        t.country(requestedAddress.country),
        t.latitude(requestedAddress.latitude),
        t.longitude(requestedAddress.longitude),
      ],
      transaction: transaction,
    );

    final tracking = await OrderTrackingRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    final formattedAddress = _formatAddressSnapshot(requestedAddress);
    if (tracking == null) {
      await OrderTrackingRow.db.insertRow(
        session,
        OrderTrackingRow(
          orderId: order.id!,
          trackingEnabled: order.orderStatus == 'out_for_delivery',
          userLatitude: requestedAddress.latitude,
          userLongitude: requestedAddress.longitude,
          userAddress: formattedAddress,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    } else {
      await OrderTrackingRow.db.updateById(
        session,
        tracking.id!,
        columnValues: (t) => [
          t.userLatitude(requestedAddress.latitude),
          t.userLongitude(requestedAddress.longitude),
          t.userAddress(formattedAddress),
          t.updatedAt(now),
        ],
        transaction: transaction,
      );
    }
  }

  Map<String, String> _buildDeliveryRequestExtraData({
    required OrderAddressRow? currentAddress,
    required Address? requestedAddress,
    required String? requestedNote,
    required Map<String, String>? extraData,
  }) {
    final resolved = <String, String>{
      if (extraData != null) ...extraData,
    };
    if (currentAddress != null) {
      resolved['currentAddressJson'] = jsonEncode(
        _addressSnapshotFromOrderAddress(currentAddress),
      );
    }
    if (requestedAddress != null) {
      resolved['requestedAddressJson'] = jsonEncode(
        _addressSnapshotFromAddress(requestedAddress),
      );
      resolved['requestedStreetLine1'] = requestedAddress.street;
      resolved['requestedCity'] = requestedAddress.city;
      resolved['requestedState'] = requestedAddress.state;
      resolved['requestedPostalCode'] = requestedAddress.zipCode;
      resolved['requestedCountry'] = requestedAddress.country;
      if (requestedAddress.latitude != null) {
        resolved['requestedLatitude'] = requestedAddress.latitude!.toString();
      }
      if (requestedAddress.longitude != null) {
        resolved['requestedLongitude'] = requestedAddress.longitude!.toString();
      }
    }
    if (requestedNote != null) {
      resolved['requestedNote'] = requestedNote;
    }
    return resolved;
  }

  Address? _requestedAddressFromRow(ComplaintRow row) {
    final extraData = row.extraData;
    if (extraData == null) return null;
    final raw = extraData['requestedAddressJson'];
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return Address(
        street: decoded['street']?.toString() ?? '',
        city: decoded['city']?.toString() ?? '',
        state: decoded['state']?.toString() ?? '',
        zipCode: decoded['zipCode']?.toString() ?? '',
        country: decoded['country']?.toString() ?? '',
        latitude: decoded['latitude'] == null
            ? null
            : asDouble(decoded['latitude']),
        longitude: decoded['longitude'] == null
            ? null
            : asDouble(decoded['longitude']),
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _addressSnapshotFromAddress(Address address) {
    return {
      'street': address.street.trim(),
      'city': address.city.trim(),
      'state': address.state.trim(),
      'zipCode': address.zipCode.trim(),
      'country': address.country.trim(),
      if (address.latitude != null) 'latitude': address.latitude,
      if (address.longitude != null) 'longitude': address.longitude,
    };
  }

  Map<String, dynamic> _addressSnapshotFromOrderAddress(
    OrderAddressRow address,
  ) {
    return {
      'street': address.streetLine1,
      'streetLine2': address.streetLine2,
      'landmark': address.landmark,
      'city': address.city,
      'state': address.state,
      'zipCode': address.postalCode,
      'country': address.country,
      'latitude': address.latitude,
      'longitude': address.longitude,
    };
  }

  String _formatAddressSnapshot(Address address) {
    final parts = [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).toList(growable: false);
    return parts.join(', ');
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
    final body = row.status == 'resolved' && row.resolutionType != null
        ? 'Your ${row.complaintType} complaint has been resolved with ${row.resolutionType!.replaceAll('_', ' ')}.'
        : 'Your ${row.complaintType} complaint status is now ${row.status}.';
    await NotificationOutboxService.instance.enqueueTopicNotification(
      session: session,
      topic: _userTopic(firebaseUid),
      title: 'Complaint ${row.status}',
      body: body,
      type: 'complaint_status',
      entityType: 'complaint',
      entityId: row.id?.toString(),
      targetAudience: 'user',
      data: {
        'complaintId': row.id?.toString() ?? '',
        'complaintType': row.complaintType,
        'status': row.status,
        if (row.resolutionType != null) 'resolutionType': row.resolutionType!,
      },
    );
  }

  String _userTopic(String firebaseUid) {
    return 'user-${firebaseUid.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
  }
}
