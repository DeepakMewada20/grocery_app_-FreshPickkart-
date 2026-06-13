import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/validation_service.dart';
import '../services/delete_impact_service.dart';
import '../services/notification_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_coupon_service.dart';

class CouponEndpoint extends Endpoint {
  final PostgresCouponService _coupons = PostgresCouponService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();

  Future<List<Coupon>> getInactiveCoupons(Session session) async {
    return _coupons.getInactiveCoupons(session);
  }

  Future<List<Coupon>> fetchCoupons(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _coupons.fetchCoupons(session, activeOnly: false);
  }

  Future<bool> uploadCoupon(
    Session session,
    Coupon coupon,
    String firebaseUid,
    String idToken, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      ValidationService.validateCoupon(coupon);
      final result = await _coupons.uploadCoupon(session, coupon);
      if (result) {
        await NotificationOutboxService.instance.enqueueCampaign(
          session: session,
          draft: notificationDraft,
          fallbackEntityType: 'coupon',
          fallbackEntityId: coupon.id ?? coupon.code,
          extraData: {'couponCode': coupon.code.trim().toUpperCase()},
        );
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'create',
          entityType: 'coupon',
          entityId: coupon.id,
          metadata: {'entityRef': coupon.code.trim().toUpperCase()},
        );
      }
      return result;
    } catch (error) {
      session.log('Error uploading coupon: $error', level: LogLevel.error);
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
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      final result = await _coupons.setCouponActive(session, code, isActive);
      if (result) {
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: isActive ? 'enable' : 'disable',
          entityType: 'coupon',
          metadata: {'entityRef': code.trim().toUpperCase()},
        );
      }
      return result;
    } catch (error) {
      session.log(
        'Error updating coupon active state: $error',
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
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      ValidationService.validateCoupon(coupon);
      final result = await _coupons.updateCoupon(session, coupon);
      if (result) {
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'update',
          entityType: 'coupon',
          entityId: coupon.id,
          metadata: {'entityRef': coupon.code.trim().toUpperCase()},
        );
      }
      return result;
    } catch (error) {
      session.log('Error updating coupon: $error', level: LogLevel.error);
      return false;
    }
  }

  Future<String> deleteCoupon(
    Session session,
    String code,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      final result = await _coupons.deleteCoupon(session, code);
      if (result.isEmpty) {
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'delete',
          entityType: 'coupon',
          metadata: {'entityRef': code.trim().toUpperCase()},
        );
      }
      return result;
    } catch (error) {
      session.log('Error deleting coupon: $error', level: LogLevel.error);
      return 'Error deleting coupon';
    }
  }

  Future<DeleteImpactResponse> checkCouponDeleteImpact(
    Session session,
    String code,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalizedCode = code.trim().toUpperCase();
    final row = await CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalizedCode),
    );
    if (row == null || row.id == null) {
      return DeleteImpactResponse(canHardDelete: true, references: []);
    }
    return DeleteImpactService.checkCouponImpact(session, row.id!);
  }

  Future<HardDeleteResponse> hardDeleteCoupon(
    Session session,
    String code,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _coupons.hardDeleteCoupon(session, code);
    if (result.success) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
        action: 'hard_delete',
        entityType: 'coupon',
        metadata: {'entityRef': code.trim().toUpperCase()},
      );
    }
    return result;
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
      return _coupons.applyCoupon(
        session,
        userId: userId,
        couponCode: couponCode,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (error) {
      session.log('Error applying coupon: $error', level: LogLevel.error);
      return CouponValidationResult(
        isValid: false,
        couponCode: couponCode.trim().toUpperCase(),
        errorMessage: 'Error validating coupon',
        discountAmount: 0,
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
      return _coupons.getAvailableCoupons(
        session,
        userId: userId,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (error) {
      session.log(
        'Error getting available coupons: $error',
        level: LogLevel.error,
      );
      return const [];
    }
  }

  Future<BestCouponResult> getBestCoupon(
    Session session,
    String userId,
    double cartSubtotal,
    List<CartItemInput> cartItems,
  ) async {
    try {
      return _coupons.getBestCoupon(
        session,
        userId: userId,
        cartSubtotal: cartSubtotal,
        cartItems: cartItems,
      );
    } catch (error) {
      session.log('Error getting best coupon: $error', level: LogLevel.error);
      return BestCouponResult(bestCouponCode: null, discountAmount: 0);
    }
  }
}
