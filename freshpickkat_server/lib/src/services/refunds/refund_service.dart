import '../../generated/protocol.dart' as protocol;
import '../firebase_service.dart';
import '../payments/payment_gateway_service.dart';
import '../payments/payment_firestore_service.dart';
import '../orders/order_document_mapper.dart';
import '../notification_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class RefundService {
  RefundService({
    PaymentGatewayService? gateway,
    PaymentFirestoreService? paymentStore,
    OrderDocumentMapper? mapper,
  })  : gateway = gateway ?? PaymentGatewayService(),
        paymentStore = paymentStore ?? PaymentFirestoreService(mapper: mapper),
        mapper = mapper ?? OrderDocumentMapper();

  static const String refundsCollection = 'refunds';

  final PaymentGatewayService gateway;
  final PaymentFirestoreService paymentStore;
  final OrderDocumentMapper mapper;

  String _refundDocPath(String refundId) {
    return 'projects/${FirebaseService.projectId}/databases/(default)/documents/$refundsCollection/$refundId';
  }

  Future<protocol.RefundRecord?> getRefundByOrderId(String orderId) async {
    final firestore = await _firestore();
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: refundsCollection)],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'orderId'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: orderId),
        ),
      ),
      limit: 1,
    );
    final results = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );
    for (final result in results) {
      final doc = result.document;
      if (doc?.fields != null) {
        return _refundFromFirestore(doc!.fields!, doc.name!.split('/').last);
      }
    }
    return null;
  }

  Future<protocol.RefundRecord?> getRefundStatus(String orderId) {
    return _getRefundStatus(orderId);
  }

  Future<protocol.RefundRecord> initiateRefund({
    required String orderId,
    String reason = 'user_cancelled',
  }) async {
    final order = await paymentStore.getOrder(orderId);
    if (order == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (order.razorpayPaymentId == null || order.razorpayPaymentId!.isEmpty) {
      throw ArgumentError('Order has no payment id: $orderId');
    }

    final paymentStatus = await gateway.fetchPaymentStatus(order.razorpayPaymentId!);
    final paymentData = paymentStatus['data'];
    final gatewayPaymentStatus = paymentData is Map
        ? paymentData['status']?.toString().toLowerCase().trim()
        : null;
    if (gatewayPaymentStatus != 'captured') {
      throw StateError(
        'Refund is allowed only for captured payments. Current status: $gatewayPaymentStatus',
      );
    }

    final existing = await getRefundByOrderId(orderId);
    if (existing != null) {
      return existing;
    }

    final amountInPaise = (order.finalAmount * 100).round();
    final refundResponse = await gateway.createRefund(
      paymentId: order.razorpayPaymentId!,
      amountInPaise: amountInPaise,
      receipt: 'refund_$orderId',
      notes: {
        'order_id': orderId,
        'reason': reason,
      },
    );

    if (refundResponse['statusCode'] != 200 && refundResponse['statusCode'] != 201) {
      await paymentStore.updateOrderFields(orderId, {
        'refundStatus': firestore_api.Value(stringValue: 'failed'),
      });
      throw StateError(
        'Refund initiation failed: ${refundResponse['body']}',
      );
    }

    final data = refundResponse['data'] as Map<String, dynamic>;
    final refundRecord = protocol.RefundRecord(
      refundId: 'RFD${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      paymentId: order.razorpayPaymentId!,
      userId: order.userId,
      amount: order.finalAmount,
      status: data['status']?.toString() ?? 'pending',
      gatewayRefundId: data['id']?.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _upsertRefund(refundRecord);
    await paymentStore.updateOrderFields(orderId, {
      'refundStatus': firestore_api.Value(stringValue: 'initiated'),
      'status': firestore_api.Value(stringValue: 'cancelled'),
      'cancelledAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      'cancellationReason': firestore_api.Value(stringValue: reason),
    });
    if (order.userId.isNotEmpty) {
      await NotificationService.notifyUserStatusUpdate(
        userId: order.userId,
        orderId: orderId,
        status: 'cancelled',
      );
    }
    return refundRecord;
  }

  Future<void> updateRefundFromWebhook({
    required String paymentId,
    required String status,
    String? gatewayRefundId,
  }) async {
    final firestore = await _firestore();
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: refundsCollection)],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'paymentId'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: paymentId),
        ),
      ),
      limit: 1,
    );
    final results = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );
    protocol.RefundRecord? record;
    for (final result in results) {
      final doc = result.document;
      if (doc?.fields != null) {
        record = _refundFromFirestore(doc!.fields!, doc.name!.split('/').last);
        break;
      }
    }
    if (record == null) return;

    final normalizedOrderStatus = status == 'processed' ? 'processed' : 'failed';
    await _upsertRefund(
      record.copyWith(
        status: normalizedOrderStatus,
        gatewayRefundId: gatewayRefundId ?? record.gatewayRefundId,
        updatedAt: DateTime.now(),
      ),
    );
    await paymentStore.updateOrderFields(record.orderId, {
      'refundStatus': firestore_api.Value(
        stringValue: normalizedOrderStatus == 'processed'
            ? 'processed'
            : 'failed',
      ),
      if (normalizedOrderStatus == 'processed')
        'paymentStatus': firestore_api.Value(stringValue: 'refunded'),
    });
  }

  Future<firestore_api.FirestoreApi> _firestore() =>
      FirebaseService.getFirestoreClient();

  Future<void> _upsertRefund(protocol.RefundRecord refund) async {
    final firestore = await _firestore();
    final fields = <String, firestore_api.Value>{
      'refundId': firestore_api.Value(stringValue: refund.refundId),
      'orderId': firestore_api.Value(stringValue: refund.orderId),
      'paymentId': firestore_api.Value(stringValue: refund.paymentId),
      'userId': firestore_api.Value(stringValue: refund.userId),
      'amount': firestore_api.Value(doubleValue: refund.amount),
      'status': firestore_api.Value(stringValue: refund.status),
      'createdAt': firestore_api.Value(
        timestampValue: refund.createdAt.toUtc().toIso8601String(),
      ),
      if (refund.gatewayRefundId != null)
        'gatewayRefundId': firestore_api.Value(stringValue: refund.gatewayRefundId!),
      if (refund.updatedAt != null)
        'updatedAt': firestore_api.Value(
          timestampValue: refund.updatedAt!.toUtc().toIso8601String(),
        ),
    };
    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      _refundDocPath(refund.refundId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  protocol.RefundRecord _refundFromFirestore(
    Map<String, firestore_api.Value> fields,
    String refundId,
  ) {
    return protocol.RefundRecord(
      refundId: refundId,
      orderId: fields['orderId']?.stringValue ?? '',
      paymentId: fields['paymentId']?.stringValue ?? '',
      userId: fields['userId']?.stringValue ?? '',
      amount: mapper.getDoubleValue(fields, 'amount'),
      status: fields['status']?.stringValue ?? 'pending',
      gatewayRefundId: fields['gatewayRefundId']?.stringValue,
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
      updatedAt: fields['updatedAt']?.timestampValue != null
          ? DateTime.tryParse(fields['updatedAt']!.timestampValue!)
          : null,
    );
  }

  Future<protocol.RefundRecord?> _getRefundStatus(String orderId) async {
    final record = await getRefundByOrderId(orderId);
    if (record == null) return null;
    if (record.gatewayRefundId == null || record.gatewayRefundId!.isEmpty) {
      return record;
    }

    final response = await gateway.fetchRefund(
      paymentId: record.paymentId,
      refundId: record.gatewayRefundId!,
    );
    if (response['statusCode'] != 200) {
      return record;
    }

    final data = response['data'] as Map<String, dynamic>;
    final updated = record.copyWith(
      status: data['status']?.toString() ?? record.status,
      updatedAt: DateTime.now(),
    );
    await _upsertRefund(updated);
    return updated;
  }
}
