import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../../generated/protocol.dart' as protocol;
import '../firebase_service.dart';
import '../orders/order_document_mapper.dart';

class PendingPaymentRecord {
  PendingPaymentRecord({
    required this.paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.razorpayOrderId,
    this.signature,
    this.orderSnapshotJson,
    this.gatewayStatus,
    this.retryCount = 0,
    this.lastError,
  });

  final String paymentId;
  final String userId;
  final String orderId;
  final double amount;
  final String status;
  final DateTime createdAt;
  final String? razorpayOrderId;
  final String? signature;
  final String? orderSnapshotJson;
  final String? gatewayStatus;
  final int retryCount;
  final String? lastError;

  factory PendingPaymentRecord.fromDocument(
    firestore_api.Document doc,
  ) {
    final fields = doc.fields ?? {};
    return PendingPaymentRecord(
      paymentId: fields['paymentId']?.stringValue ?? '',
      userId: fields['userId']?.stringValue ?? '',
      orderId: fields['orderId']?.stringValue ?? '',
      amount: _getDoubleValue(fields, 'amount'),
      status: fields['status']?.stringValue ?? 'pending',
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now().toUtc(),
      razorpayOrderId: fields['razorpayOrderId']?.stringValue,
      signature: fields['signature']?.stringValue,
      orderSnapshotJson: fields['orderSnapshotJson']?.stringValue,
      gatewayStatus: fields['gatewayStatus']?.stringValue,
      retryCount: int.tryParse(fields['retryCount']?.integerValue ?? '0') ?? 0,
      lastError: fields['lastError']?.stringValue,
    );
  }

  static double _getDoubleValue(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }
}

class PaymentFirestoreService {
  PaymentFirestoreService({OrderDocumentMapper? mapper})
      : mapper = mapper ?? OrderDocumentMapper();

  static const String ordersCollection = 'orders';
  static const String pendingPaymentsCollection = 'pending_payments';

  final OrderDocumentMapper mapper;

  String _docPath(String collection, String id) {
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    return '$database/$collection/$id';
  }

  Future<firestore_api.Document?> getOrderDocument(String orderId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    try {
      return await firestore.projects.databases.documents.get(
        _docPath(ordersCollection, orderId),
      );
    } catch (_) {
      return null;
    }
  }

  Future<protocol.Order?> getOrder(String orderId) async {
    final doc = await getOrderDocument(orderId);
    if (doc?.fields == null) return null;
    return mapper.fromFirestore(doc!.fields!, orderId);
  }

  Future<void> updateOrderFields(
    String orderId,
    Map<String, firestore_api.Value> fields,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath(ordersCollection, orderId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<void> upsertOrder(protocol.Order order) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final fields = mapper.toFirestore(order);
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath(ordersCollection, order.orderId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<void> ensurePendingPaymentFromOrder({
    required protocol.Order order,
    required String paymentId,
    required double amount,
    required String status,
    String? razorpayOrderId,
    String? signature,
    String? gatewayStatus,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final fields = <String, firestore_api.Value>{
      'paymentId': firestore_api.Value(stringValue: paymentId),
      'userId': firestore_api.Value(stringValue: order.userId),
      'orderId': firestore_api.Value(stringValue: order.orderId),
      'amount': firestore_api.Value(doubleValue: amount),
      'status': firestore_api.Value(stringValue: status),
      'orderSnapshotJson': firestore_api.Value(
        stringValue: mapper.toJsonString(order),
      ),
      'retryCount': firestore_api.Value(integerValue: '0'),
      'createdAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      'updatedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
      if (razorpayOrderId != null)
        'razorpayOrderId': firestore_api.Value(stringValue: razorpayOrderId),
      if (signature != null && signature.isNotEmpty)
        'signature': firestore_api.Value(stringValue: signature),
      if (gatewayStatus != null)
        'gatewayStatus': firestore_api.Value(stringValue: gatewayStatus),
    };
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath(pendingPaymentsCollection, paymentId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<void> markPendingPaymentStatus(
    String paymentId,
    String status, {
    String? orderId,
    String? error,
    int? retryCount,
  }) async {
    final fields = <String, firestore_api.Value>{
      'status': firestore_api.Value(stringValue: status),
      'updatedAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    };
    if (orderId != null) {
      fields['orderId'] = firestore_api.Value(stringValue: orderId);
    }
    if (error != null && error.isNotEmpty) {
      fields['lastError'] = firestore_api.Value(stringValue: error);
    }
    if (retryCount != null) {
      fields['retryCount'] = firestore_api.Value(
        integerValue: retryCount.toString(),
      );
    }
    await updatePendingPaymentFields(paymentId, fields);
  }

  Future<void> updatePendingPaymentFields(
    String paymentId,
    Map<String, firestore_api.Value> fields,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath(pendingPaymentsCollection, paymentId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<void> updateUserFields(
    String userId,
    Map<String, firestore_api.Value> fields,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath('users', userId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<List<PendingPaymentRecord>> getPendingPayments({
    String? userId,
    int limit = 20,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';

    final filters = <firestore_api.Filter>[
      firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'status'),
          op: 'EQUAL',
          value: firestore_api.Value(stringValue: 'pending'),
        ),
      ),
    ];
    if (userId != null && userId.isNotEmpty) {
      filters.add(
        firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'userId'),
            op: 'EQUAL',
            value: firestore_api.Value(stringValue: userId),
          ),
        ),
      );
    }

    final query = firestore_api.StructuredQuery(
      from: [
        firestore_api.CollectionSelector(collectionId: pendingPaymentsCollection),
      ],
      where: filters.length == 1
          ? filters.first
          : firestore_api.Filter(
              compositeFilter: firestore_api.CompositeFilter(
                op: 'AND',
                filters: filters,
              ),
            ),
      limit: limit,
    );

    final results = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    return results
        .map((item) => item.document)
        .whereType<firestore_api.Document>()
        .where((doc) => doc.fields != null)
        .map(PendingPaymentRecord.fromDocument)
        .where((record) => record.paymentId.isNotEmpty)
        .toList();
  }
}
