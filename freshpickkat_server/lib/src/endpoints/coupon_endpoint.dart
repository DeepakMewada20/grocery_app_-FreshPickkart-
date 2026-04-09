import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/coupon_service.dart';
import '../services/role_guard_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class CouponEndpoint extends Endpoint {
  final String _database =
      'projects/freshpickkart-a6824/databases/(default)/documents';

  /// Fetch coupons for admin panel.
  Future<List<Coupon>> fetchCoupons(
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
    return _fetchCouponsInternal(session);
  }

  Future<List<Coupon>> _fetchCouponsInternal(Session session) async {
    try {
      final coupons = await CouponService.fetchCoupons(activeOnly: false);
      session.log('Total coupons fetched from Firestore: ${coupons.length}');
      return coupons;
    } catch (e) {
      session.log('Error fetching coupons: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Upload a new coupon to Firestore
  Future<bool> uploadCoupon(
    Session session,
    Coupon coupon,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      await RoleGuardService.ensureAdminSeller(
        firestore: firestore,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      ValidationService.validateCoupon(coupon);

      final document = firestore_api.Document(
        fields: CouponService.toFirestoreFields(coupon),
      );

      await firestore.projects.databases.documents.createDocument(
        document,
        _database,
        'coupons',
      );
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'create',
        entityType: 'coupon',
        entityId: coupon.code,
      );
      return true;
    } catch (e) {
      session.log('Error uploading coupon: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<bool> setCouponActive(
    Session session,
    String code,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      await RoleGuardService.ensureAdminSeller(
        firestore: firestore,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'coupons')],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'code'),
            op: 'EQUAL',
            value: firestore_api.Value(stringValue: code),
          ),
        ),
        limit: 1,
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      firestore_api.Document? document;
      for (final item in response) {
        if (item.document != null) {
          document = item.document;
          break;
        }
      }

      if (document == null || document.name == null) {
        throw Exception('Coupon not found');
      }

      final doc = firestore_api.Document(
        fields: {'isActive': firestore_api.Value(booleanValue: isActive)},
      );

      await firestore.projects.databases.documents.patch(
        doc,
        document.name!,
        updateMask_fieldPaths: ['isActive'],
      );
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: isActive ? 'enable' : 'disable',
        entityType: 'coupon',
        entityId: code,
      );
      return true;
    } catch (e) {
      session.log(
        'Error updating coupon active state: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<bool> updateCoupon(
    Session session,
    Coupon coupon,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      await RoleGuardService.ensureAdminSeller(
        firestore: firestore,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'coupons')],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'code'),
            op: 'EQUAL',
            value: firestore_api.Value(stringValue: coupon.code),
          ),
        ),
        limit: 1,
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      firestore_api.Document? document;
      for (final item in response) {
        if (item.document != null) {
          document = item.document;
          break;
        }
      }
      if (document == null || document.name == null) {
        throw Exception('Coupon not found');
      }

      final fields = CouponService.toFirestoreFields(coupon);

      await firestore.projects.databases.documents.patch(
        firestore_api.Document(fields: fields),
        document.name!,
        updateMask_fieldPaths: fields.keys.toList(),
      );

      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'update',
        entityType: 'coupon',
        entityId: coupon.code,
      );
      return true;
    } catch (e) {
      session.log('Error updating coupon: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<bool> deleteCoupon(
    Session session,
    String code,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      await RoleGuardService.ensureAdminSeller(
        firestore: firestore,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'coupons')],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'code'),
            op: 'EQUAL',
            value: firestore_api.Value(stringValue: code),
          ),
        ),
        limit: 1,
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      firestore_api.Document? document;
      for (final item in response) {
        if (item.document != null) {
          document = item.document;
          break;
        }
      }
      if (document == null || document.name == null) {
        throw Exception('Coupon not found');
      }

      await firestore.projects.databases.documents.delete(document.name!);
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'delete',
        entityType: 'coupon',
        entityId: code,
      );
      return true;
    } catch (e) {
      session.log('Error deleting coupon: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<List<CouponDisplay>> fetchApplicableCoupons(
    Session session,
    double orderAmount,
  ) async {
    return getAvailableCoupons(session, '', orderAmount, const []);
  }

  Future<CouponValidationResult> validateCoupon(
    Session session,
    String couponCode,
    double orderAmount,
  ) async {
    return applyCoupon(session, '', couponCode, orderAmount, const []);
  }

  Future<CouponValidationResult> applyCoupon(
    Session session,
    String userId,
    String couponCode,
    double cartSubtotal,
    List<CartItemInput> cartItems,
  ) async {
    try {
      return await CouponService.applyCoupon(
        userId: userId,
        couponCode: couponCode,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (e) {
      session.log('Error applying coupon: $e', level: LogLevel.error);
      return CouponValidationResult(
        isValid: false,
        couponCode: couponCode.toUpperCase(),
        errorMessage: 'Error validating coupon',
        discountAmount: 0.0,
        isDeliveryDiscount: false,
      );
    }
  }

  Future<List<CouponDisplay>> getAvailableCoupons(
    Session session,
    String userId,
    double cartSubtotal,
    List<CartItemInput> cartItems,
  ) async {
    try {
      return await CouponService.getAvailableCoupons(
        userId: userId,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (e) {
      session.log(
        'Error getting available coupons: $e',
        level: LogLevel.error,
      );
      return [];
    }
  }

  Future<BestCouponResult> getBestCoupon(
    Session session,
    String userId,
    double cartSubtotal,
    List<CartItemInput> cartItems,
  ) async {
    try {
      return await CouponService.getBestCoupon(
        userId: userId,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (e) {
      session.log('Error getting best coupon: $e', level: LogLevel.error);
      return BestCouponResult(bestCouponCode: null, discountAmount: 0);
    }
  }
}
