import 'package:serverpod/serverpod.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../generated/protocol.dart' as protocol;
import '../services/business/seller_access_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_service.dart';
import '../services/role_guard_service.dart';

class AdminEndpoint extends Endpoint {
  static const String projectId = FirebaseService.projectId;
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  Future<bool> isAdminSetupCompleted(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    return SellerAccessService.hasCompletedAdminSetup(firestore: firestore);
  }

  Future<String> resolveAdminLoginEmail(
    Session session,
    String usernameOrEmail,
  ) async {
    final normalized = SellerAccessService.normalizeUsername(usernameOrEmail);
    if (normalized.isEmpty) return '';

    if (normalized.contains('@')) {
      if (!_emailRegex.hasMatch(normalized)) return '';
      return normalized;
    }
    if (!SellerAccessService.isValidUsername(normalized)) return '';

    final firestore = await FirebaseService.getFirestoreClient();
    final sellers = await SellerAccessService.listSellerDocs(
      firestore: firestore,
      limit: 100,
    );
    if (sellers.isEmpty) return '';

    final matching = sellers.where((seller) {
      final username = SellerAccessService.normalizeUsername(
        seller['username'] as String? ?? '',
      );
      return username == normalized;
    }).toList();
    if (matching.length != 1) return '';

    final email = (matching.first['email'] as String? ?? '')
        .trim()
        .toLowerCase();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) return '';

    return email;
  }

  Future<Map<String, dynamic>> firebaseLogin(
    Session session,
    String idToken,
  ) async {
    final token = await FirebaseAuthService.verifyIdToken(idToken);
    if (token == null) {
      final verifyError = FirebaseAuthService.getLastVerifyError();
      return {
        'ok': false,
        'message': verifyError == null || verifyError.trim().isEmpty
            ? 'Invalid or expired Firebase token.'
            : 'Invalid or expired Firebase token. $verifyError',
      };
    }

    if (!token.emailVerified) {
      return {
        'ok': false,
        'message': 'Email verification required.',
      };
    }

    final firestore = await FirebaseService.getFirestoreClient();
    final seller = await SellerAccessService.getSellerDocByUid(
      firestore: firestore,
      firebaseUid: token.uid,
    );
    if (seller == null) {
      return {
        'ok': false,
        'message':
            'Seller profile not found for this account. Please complete setup again.',
      };
    }

    final role = seller['role'] as String?;
    if (!SellerAccessService.isAdminSellerRole(role)) {
      return {
        'ok': false,
        'message': 'Access denied: ADMIN_SELLER role required.',
      };
    }

    return {'ok': true};
  }

  Future<List<protocol.AppUser>> getAllUsers(
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

    final sellers = await SellerAccessService.listSellerDocs(
      firestore: firestore,
      limit: 50,
    );

    return sellers
        .map(
          (seller) => protocol.AppUser(
            firebaseUid: seller['firebaseUid'] as String? ?? '',
            phoneNumber: '',
            name: seller['email'] as String?,
            role:
                seller['role'] as String? ??
                SellerAccessService.adminSellerRole,
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>> getDashboardStats(
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

    final orders = await _getAllOrders(session);
    final users = await getAllUsers(session, firebaseUid, idToken);

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final todayOrders = orders
        .where(
          (o) =>
              o.orderedAt.isAfter(startOfDay) ||
              o.orderedAt.isAtSameMomentAs(startOfDay),
        )
        .toList();

    double todayRevenue = 0;
    double totalRevenue = 0;
    int pendingCount = 0;
    int confirmedCount = 0;
    int outForDeliveryCount = 0;
    int deliveredCount = 0;
    int cancelledCount = 0;

    for (final order in orders) {
      if (order.paymentStatus == 'paid' && order.status != 'cancelled') {
        totalRevenue += order.finalAmount;
      }
      switch (order.status) {
        case 'pending':
          pendingCount++;
          break;
        case 'confirmed':
          confirmedCount++;
          break;
        case 'out_for_delivery':
          outForDeliveryCount++;
          break;
        case 'delivered':
          deliveredCount++;
          break;
        case 'cancelled':
          cancelledCount++;
          break;
      }
    }

    for (final order in todayOrders) {
      if (order.paymentStatus == 'paid' && order.status != 'cancelled') {
        todayRevenue += order.finalAmount;
      }
    }

    return {
      'todayOrders': todayOrders.length,
      'todayRevenue': todayRevenue,
      'totalOrders': orders.length,
      'totalRevenue': totalRevenue,
      'totalUsers': users.length,
      'pendingOrders': pendingCount,
      'confirmedOrders': confirmedCount,
      'outForDeliveryOrders': outForDeliveryCount,
      'deliveredOrders': deliveredCount,
      'cancelledOrders': cancelledCount,
    };
  }

  Future<Map<String, dynamic>> getAnalytics(
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

    final database = 'projects/$projectId/databases/(default)/documents';

    final orders = await _getAllOrders(session);
    final productsQuery = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'mostPurchases'),
          direction: 'DESCENDING',
        ),
      ],
      limit: 10,
    );

    final productsResponse = await firestore.projects.databases.documents
        .runQuery(
          firestore_api.RunQueryRequest(structuredQuery: productsQuery),
          database,
        );

    int lowStockCount = 0;
    final topProducts = <Map<String, dynamic>>[];
    for (final row in productsResponse) {
      final fields = row.document?.fields;
      if (fields == null) continue;
      final quantityText = fields['quantity']?.stringValue ?? '';
      final parsed = _extractLeadingNumber(quantityText);
      if (parsed != null && parsed <= 5) {
        lowStockCount++;
      }

      topProducts.add({
        'name': fields['productName']?.stringValue ?? '',
        'mostPurchases':
            int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ?? 0,
        'quantity': quantityText,
      });
    }

    final cancelled = orders.where((o) => o.status == 'cancelled').length;
    final cancellationRate = orders.isEmpty
        ? 0.0
        : (cancelled / orders.length) * 100;

    return {
      'cancellationRate': cancellationRate,
      'lowStockCount': lowStockCount,
      'topProducts': topProducts,
    };
  }

  Future<List<Map<String, dynamic>>> getAuditLogs(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 50,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final database = 'projects/$projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'auditLogs')],
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'createdAt'),
          direction: 'DESCENDING',
        ),
      ],
      limit: limit,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final logs = <Map<String, dynamic>>[];
    for (final row in response) {
      final fields = row.document?.fields;
      if (fields == null) continue;
      logs.add({
        'id': row.document!.name!.split('/').last,
        'actorUid': fields['actorUid']?.stringValue ?? '',
        'action': fields['action']?.stringValue ?? '',
        'entityType': fields['entityType']?.stringValue ?? '',
        'entityId': fields['entityId']?.stringValue ?? '',
        'createdAt': fields['createdAt']?.timestampValue ?? '',
      });
    }
    return logs;
  }

  Future<List<protocol.Order>> _getAllOrders(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'orders')],
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
        orders.add(
          _orderFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    return orders;
  }

  protocol.Order _orderFromFirestore(
    Map<String, firestore_api.Value> fields,
    String orderId,
  ) {
    double getDoubleValue(String key) {
      final value = fields[key];
      if (value == null) return 0.0;
      if (value.doubleValue != null) return value.doubleValue!;
      if (value.integerValue != null && value.integerValue!.isNotEmpty) {
        return double.tryParse(value.integerValue!) ?? 0.0;
      }
      return 0.0;
    }

    return protocol.Order(
      orderId: orderId,
      userId: fields['userId']?.stringValue ?? '',
      userName: fields['userName']?.stringValue,
      userPhone: fields['userPhone']?.stringValue ?? '',
      items: [],
      itemCount: int.tryParse(fields['itemCount']?.integerValue ?? '0') ?? 0,
      totalAmount: getDoubleValue('totalAmount'),
      discountAmount: getDoubleValue('discountAmount'),
      deliveryFee: getDoubleValue('deliveryFee'),
      finalAmount: getDoubleValue('finalAmount'),
      status: fields['status']?.stringValue ?? 'pending',
      paymentStatus: fields['paymentStatus']?.stringValue ?? 'pending',
      deliveryAddress: protocol.Address(
        street:
            fields['deliveryAddress']
                ?.mapValue
                ?.fields?['street']
                ?.stringValue ??
            '',
        city:
            fields['deliveryAddress']?.mapValue?.fields?['city']?.stringValue ??
            '',
        state:
            fields['deliveryAddress']
                ?.mapValue
                ?.fields?['state']
                ?.stringValue ??
            '',
        zipCode:
            fields['deliveryAddress']
                ?.mapValue
                ?.fields?['zipCode']
                ?.stringValue ??
            '',
        country:
            fields['deliveryAddress']
                ?.mapValue
                ?.fields?['country']
                ?.stringValue ??
            '',
      ),
      orderedAt:
          DateTime.tryParse(fields['orderedAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  double? _extractLeadingNumber(String input) {
    final match = RegExp(r'^\s*([0-9]+(\.[0-9]+)?)').firstMatch(input);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }
}
