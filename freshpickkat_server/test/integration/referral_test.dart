import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_referral_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Referral system', (sessionBuilder, endpoints) {
    late PostgresReferralService referralService;

    setUp(() {
      referralService = PostgresReferralService();
    });

    // ── Code Generation + Storage ───────────────────────────────────────────

    test('getOrCreateReferralCodeForUser creates code on new user', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999001');
        final code = await referralService.getOrCreateReferralCodeForUser(
          session,
          user.id!,
        );
        expect(code, startsWith('FPK'));
        expect(code.length, equals(7));

        final reloaded = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(reloaded!.referralCode, equals(code));
      } finally {
        await session.close();
      }
    });

    test('getOrCreateReferralCodeForUser returns existing code', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999002', referralCode: 'FPKTEST');
        final code = await referralService.getOrCreateReferralCodeForUser(
          session,
          user.id!,
        );
        expect(code, equals('FPKTEST'));
      } finally {
        await session.close();
      }
    });

    // ── Validation ──────────────────────────────────────────────────────────

    test('validateReferralCode returns referrer info for valid code', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999003', name: 'Referrer', referralCode: 'FPKVALID');
        final invitee = await _seedUser(sessionBuilder, '9999999004');
        final result = await referralService.validateReferralCode(
          session, 'FPKVALID', invitee.id!);
        expect(result, isNotNull);
        expect(result!['referrerName'], equals('Referrer'));
        expect(result['referrerUserId'], equals(referrer.id.toString()));
      } finally {
        await session.close();
      }
    });

    test('validateReferralCode returns null for invalid code', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999005');
        final result = await referralService.validateReferralCode(
          session, 'INVALID', user.id!);
        expect(result, isNull);
      } finally {
        await session.close();
      }
    });

    test('validateReferralCode returns null for self-referral', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999006', referralCode: 'FPKSELF');
        final result = await referralService.validateReferralCode(
          session, 'FPKSELF', user.id!);
        expect(result, isNull);
      } finally {
        await session.close();
      }
    });

    // ── Apply Referral ──────────────────────────────────────────────────────

    test('applyReferral creates referral with status SIGNED_UP', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999007', referralCode: 'FPKAPP1');
        final invitee = await _seedUser(sessionBuilder, '9999999008');
        await referralService.applyReferral(
          session, invitee.id!, '9999999008', 'FPKAPP1');

        final referral = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee.id!),
        );
        expect(referral, isNotNull);
        expect(referral!.referrerUserId, equals(referrer.id));
        expect(referral.status, equals('SIGNED_UP'));
        expect(referral.referralCodeUsed, equals('FPKAPP1'));
      } finally {
        await session.close();
      }
    });

    test('applyReferral throws for invalid code', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999009');
        await expectLater(
          referralService.applyReferral(session, user.id!, '9999999009', 'BADCODE'),
          throwsException,
        );
      } finally {
        await session.close();
      }
    });

    test('applyReferral throws for already referred user', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999010', referralCode: 'FPKDUP');
        final invitee = await _seedUser(sessionBuilder, '9999999011');
        await referralService.applyReferral(session, invitee.id!, '9999999011', 'FPKDUP');
        await expectLater(
          referralService.applyReferral(session, invitee.id!, '9999999011', 'FPKDUP'),
          throwsException,
        );
      } finally {
        await session.close();
      }
    });

    // ── Referral Code Info + Activity ──────────────────────────────────────

    test('getMyReferralCodeInfo returns correct stats', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999012', referralCode: 'FPKSTAT');
        final info = await referralService.getMyReferralCodeInfo(session, referrer.id!);
        expect(info.referralCode, equals('FPKSTAT'));
        expect(info.totalReferred, equals(0));
        expect(info.totalQualified, equals(0));
        expect(info.totalRewardsEarned, equals(0));
        expect(info.shareLink, contains('FPKSTAT'));
      } finally {
        await session.close();
      }
    });

    test('getMyReferralCodeInfo counts rewarded referrals', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999013', referralCode: 'FPKCNT');
        final invitee = await _seedUser(sessionBuilder, '9999999014');
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999014',
            'FPKCNT', 'REWARDED', rewardPointsIssued: 100);

        final info = await referralService.getMyReferralCodeInfo(session, referrer.id!);
        expect(info.totalReferred, equals(1));
        expect(info.totalQualified, equals(1));
        expect(info.totalRewardsEarned, equals(100));
      } finally {
        await session.close();
      }
    });

    test('getMyReferralActivity returns activity list', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999015', referralCode: 'FPKACT');
        final invitee = await _seedUser(sessionBuilder, '9999999016');
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999016',
            'FPKACT', 'REWARDED', rewardPointsIssued: 50);

        final activity = await referralService.getMyReferralActivity(session, referrer.id!);
        expect(activity, hasLength(1));
        expect(activity.first.pointsEarned, equals(50));
        expect(activity.first.type, equals('REWARDED'));
      } finally {
        await session.close();
      }
    });

    // ── Check Order For Reward — Happy Path ────────────────────────────────

    test('checkOrderForReward processes reward for delivered order', () async {
      final session = sessionBuilder.build();
      try {
        await _seedSettingsRow(sessionBuilder, enableFraudScoring: false);
        final settings = await referralService.getOrCreateSettingsRow(session);
        final referrer = await _seedUser(sessionBuilder, '9999999017', referralCode: 'FPKREW',
            currentFreshPoints: 100, totalEarned: 100);
        final invitee = await _seedUser(sessionBuilder, '9999999018');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'rew-${now.microsecondsSinceEpoch}',
              userId: invitee.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999018',
            'FPKREW', 'SIGNED_UP');

        await referralService.checkOrderForReward(session, order.orderNumber);

        final updated = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee.id!),
        );
        expect(updated!.status, equals('REWARDED'));
        expect(updated.rewardPointsIssued, equals(settings.referrerRewardPoints));

        final coupon = await protocol.CouponRow.db.findFirstRow(
          session,
          where: (t) => t.code.equals('WELCOME${updated.referralCodeUsed}'),
        );
        expect(coupon, isNotNull);
        expect(coupon!.discountValue, equals(settings.inviteeCouponAmount));
        expect(coupon.maxUsageTotal, equals(1));

        final refReload = await protocol.AppUserRow.db.findById(session, referrer.id!);
        expect(refReload!.currentFreshPoints, equals(100 + settings.referrerRewardPoints));
      } finally {
        await session.close();
      }
    });

    // ── Check Order For Reward — Edge Cases ────────────────────────────────

    test('checkOrderForReward does nothing below min amount', () async {
      final session = sessionBuilder.build();
      try {
        await _seedSettingsRow(sessionBuilder, minimumQualifyingAmount: 500);
        final referrer = await _seedUser(sessionBuilder, '9999999019', referralCode: 'FPKMIN');
        final invitee = await _seedUser(sessionBuilder, '9999999020');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'min-${now.microsecondsSinceEpoch}',
              userId: invitee.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 100.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 100.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999020',
            'FPKMIN', 'SIGNED_UP');

        await referralService.checkOrderForReward(session, order.orderNumber);

        final updated = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee.id!),
        );
        expect(updated!.status, equals('SIGNED_UP'));
      } finally {
        await session.close();
      }
    });

    test('checkOrderForReward does nothing before trigger status', () async {
      final session = sessionBuilder.build();
      try {
        await _seedSettingsRow(sessionBuilder, rewardTriggerStatus: 'DELIVERED');
        final referrer = await _seedUser(sessionBuilder, '9999999021', referralCode: 'FPKTRG');
        final invitee = await _seedUser(sessionBuilder, '9999999022');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'trg-${now.microsecondsSinceEpoch}',
              userId: invitee.id!,
              orderStatus: 'confirmed',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999022',
            'FPKTRG', 'SIGNED_UP');

        await referralService.checkOrderForReward(session, order.orderNumber);

        final updated = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee.id!),
        );
        expect(updated!.status, equals('SIGNED_UP'));
      } finally {
        await session.close();
      }
    });

    test('checkOrderForReward does nothing if already rewarded', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999023', referralCode: 'FPKDUP2');
        final invitee = await _seedUser(sessionBuilder, '9999999024');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'dup-${now.microsecondsSinceEpoch}',
              userId: invitee.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!, '9999999024',
            'FPKDUP2', 'REWARDED');

        await referralService.checkOrderForReward(session, order.orderNumber);

        final updated = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee.id!),
        );
        expect(updated!.status, equals('REWARDED'));
      } finally {
        await session.close();
      }
    });

    test('checkOrderForReward enforces monthly cap', () async {
      final session = sessionBuilder.build();
      try {
        await _seedSettingsRow(sessionBuilder, maxRewardedPerMonth: 1, enableFraudScoring: false);
        final referrer = await _seedUser(sessionBuilder, '9999999025', referralCode: 'FPKMON');
        final invitee1 = await _seedUser(sessionBuilder, '9999999026');
        final invitee2 = await _seedUser(sessionBuilder, '9999999027');
        final now = DateTime.now().toUtc();

        final order1 = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'mon1-${now.microsecondsSinceEpoch}',
              userId: invitee1.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 3)),
            ));
        final order2 = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'mon2-${now.microsecondsSinceEpoch}',
              userId: invitee2.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));

        await _seedReferralRow(sessionBuilder, referrer.id!, invitee1.id!, '9999999026',
            'FPKMON', 'REWARDED', rewardPointsIssued: 50, rewardIssuedAt: now);
        await _seedReferralRow(sessionBuilder, referrer.id!, invitee2.id!, '9999999027',
            'FPKMON', 'SIGNED_UP');

        await referralService.checkOrderForReward(session, order2.orderNumber);

        final referral2 = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(invitee2.id!),
        );
        expect(referral2!.status, equals('SIGNED_UP'));
      } finally {
        await session.close();
      }
    });

    test('checkOrderForReward rejects self-referral', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(sessionBuilder, '9999999028', referralCode: 'FPKSELF2');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'self-${now.microsecondsSinceEpoch}',
              userId: user.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 200.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 200.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        await _seedReferralRow(sessionBuilder, user.id!, user.id!, '9999999028',
            'FPKSELF2', 'SIGNED_UP');

        await referralService.checkOrderForReward(session, order.orderNumber);

        final updated = await protocol.ReferralRow.db.findFirstRow(
          session,
          where: (t) => t.inviteeUserId.equals(user.id!),
        );
        expect(updated!.status, equals('REJECTED'));
        expect(updated.fraudNotes, contains('Self-referral'));
      } finally {
        await session.close();
      }
    });

    // ── Settings CRUD ───────────────────────────────────────────────────────

    test('getSettings returns null when no settings exist', () async {
      final session = sessionBuilder.build();
      try {
        final result = await referralService.getSettings(session);
        expect(result, isNull);
      } finally {
        await session.close();
      }
    });

    test('getOrCreateSettings creates defaults', () async {
      final session = sessionBuilder.build();
      try {
        final settings = await referralService.getOrCreateSettings(session);
        expect(settings.isEnabled, isTrue);
        expect(settings.referrerRewardPoints, equals(50));
        expect(settings.inviteeCouponAmount, equals(50.0));
        expect(settings.rewardTriggerStatus, equals('DELIVERED'));
        expect(settings.maxRewardedPerMonth, equals(20));
      } finally {
        await session.close();
      }
    });

    test('updateSettings updates values and persists', () async {
      final session = sessionBuilder.build();
      try {
        await _seedUser(sessionBuilder, '9999999029', firebaseUid: 'admin_fb_uid');

        await referralService.getOrCreateSettings(session);
        final updated = await referralService.updateSettings(
          session,
          protocol.ReferralSettings(
            isEnabled: false,
            inviteeCouponEnabled: false,
            inviteeCouponAmount: 100.0,
            inviteeCouponCodeTemplate: 'TEST{CODE}',
            referrerPointsEnabled: true,
            referrerRewardPoints: 75,
            minimumQualifyingAmount: 50.0,
            rewardTriggerStatus: 'OUT_FOR_DELIVERY',
            maxRewardedPerMonth: 5,
            enableFraudProtection: false,
            enableReferralExpiry: true,
            referralExpiryDays: 30,
            shareMessageTemplate: 'Custom share {CODE}',
            enableFraudScoring: true,
            autoApproveThreshold: 40,
            manualReviewThreshold: 69,
            autoRejectThreshold: 90,
            enableRewardHold: true,
            holdDurationHours: 72,
            enableAutoReject: true,
            minimumActualPaymentForQualification: 0,
            maxRewardedPerDay: 3,
            maxPendingReferrals: 50,
            maxSharesPerDay: 100,
            maxSharesPerMonth: 1000,
            referralVelocityScore: 30,
            velocityTimeWindowHours: 24,
            velocityThreshold: 3,
            newAccountScore: 20,
            newAccountHours: 48,
            autoReversalWindowDays: 30,
            updatedAt: DateTime.now().toUtc(),
          ),
          adminFirebaseUid: 'admin_fb_uid',
        );

        expect(updated.isEnabled, isFalse);
        expect(updated.referrerRewardPoints, equals(75));
        expect(updated.rewardTriggerStatus, equals('OUT_FOR_DELIVERY'));
        expect(updated.maxRewardedPerMonth, equals(5));

        final reloaded = await referralService.getSettings(session);
        expect(reloaded!.referrerRewardPoints, equals(75));
        expect(reloaded.isEnabled, isFalse);
      } finally {
        await session.close();
      }
    });

    test('updateSettings works without admin user (audit log graceful)', () async {
      final session = sessionBuilder.build();
      try {
        await referralService.getOrCreateSettings(session);
        final updated = await referralService.updateSettings(
          session,
          protocol.ReferralSettings(
            isEnabled: true,
            inviteeCouponEnabled: true,
            inviteeCouponAmount: 25.0,
            inviteeCouponCodeTemplate: 'WELCOME{CODE}',
            referrerPointsEnabled: true,
            referrerRewardPoints: 30,
            minimumQualifyingAmount: 0.0,
            rewardTriggerStatus: 'DELIVERED',
            maxRewardedPerMonth: 10,
            enableFraudProtection: true,
            enableReferralExpiry: false,
            referralExpiryDays: 90,
            shareMessageTemplate: 'Join! {CODE}',
            enableFraudScoring: true,
            autoApproveThreshold: 40,
            manualReviewThreshold: 69,
            autoRejectThreshold: 90,
            enableRewardHold: true,
            holdDurationHours: 72,
            enableAutoReject: true,
            minimumActualPaymentForQualification: 0,
            maxRewardedPerDay: 3,
            maxPendingReferrals: 50,
            maxSharesPerDay: 100,
            maxSharesPerMonth: 1000,
            referralVelocityScore: 30,
            velocityTimeWindowHours: 24,
            velocityThreshold: 3,
            newAccountScore: 20,
            newAccountHours: 48,
            autoReversalWindowDays: 30,
            updatedAt: DateTime.now().toUtc(),
          ),
          adminFirebaseUid: 'non_existent_admin',
        );
        expect(updated.referrerRewardPoints, equals(30));
      } finally {
        await session.close();
      }
    });

    // ── Admin Analytics ─────────────────────────────────────────────────────

    test('getReferralAnalytics returns correct counts', () async {
      final session = sessionBuilder.build();
      try {
        final r1 = await _seedUser(sessionBuilder, '9999999030', referralCode: 'FPKAN1');
        final r2 = await _seedUser(sessionBuilder, '9999999031', referralCode: 'FPKAN2');
        final i1 = await _seedUser(sessionBuilder, '9999999032');
        final i2 = await _seedUser(sessionBuilder, '9999999033');
        final i3 = await _seedUser(sessionBuilder, '9999999034');

        await _seedReferralRow(sessionBuilder, r1.id!, i1.id!, '9999999032', 'FPKAN1', 'REWARDED',
            rewardPointsIssued: 50, inviteeCouponIssued: true);
        await _seedReferralRow(sessionBuilder, r1.id!, i2.id!, '9999999033', 'FPKAN1', 'SIGNED_UP');
        await _seedReferralRow(sessionBuilder, r2.id!, i3.id!, '9999999034', 'FPKAN2', 'REJECTED');

        final analytics = await referralService.getReferralAnalytics(session);
        expect(analytics.totalReferrals, equals(3));
        expect(analytics.rewardedReferrals, equals(1));
        expect(analytics.rejectedReferrals, equals(1));
        expect(analytics.pendingReferrals, greaterThanOrEqualTo(1));
        expect(analytics.totalPointsIssued, equals(50));
        expect(analytics.totalCouponsIssued, equals(1));
        expect(analytics.topReferrers, hasLength(2));
      } finally {
        await session.close();
      }
    });

    // ── Admin List ──────────────────────────────────────────────────────────

    test('listReferrals returns paginated results', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999035', referralCode: 'FPKLST');
        for (var i = 0; i < 5; i++) {
          final invitee = await _seedUser(sessionBuilder, '9999999${36 + i}');
          await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!,
              '9999999${36 + i}', 'FPKLST', i % 2 == 0 ? 'REWARDED' : 'SIGNED_UP',
              rewardPointsIssued: i % 2 == 0 ? 50 : 0);
        }

        final page1 = await referralService.listReferrals(session, limit: 3);
        final items1 = page1['referrals'] as List;
        expect(items1, hasLength(3));
        expect(page1['nextPageToken'], isNotNull);

        final page2 = await referralService.listReferrals(
          session, limit: 3, pageToken: page1['nextPageToken'] as String?);
        final items2 = page2['referrals'] as List;
        expect(items2, hasLength(2));
        expect(page2['nextPageToken'], isNull);
      } finally {
        await session.close();
      }
    });

    test('listReferrals filters by status', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999041', referralCode: 'FPKFIL');
        final i1 = await _seedUser(sessionBuilder, '9999999042');
        final i2 = await _seedUser(sessionBuilder, '9999999043');
        await _seedReferralRow(sessionBuilder, referrer.id!, i1.id!, '9999999042', 'FPKFIL', 'REWARDED');
        await _seedReferralRow(sessionBuilder, referrer.id!, i2.id!, '9999999043', 'FPKFIL', 'REJECTED');

        final filtered = await referralService.listReferrals(
          session, statusFilter: 'REJECTED');
        final items = filtered['referrals'] as List;
        expect(items, hasLength(1));
        expect(items.first['status'], equals('REJECTED'));
      } finally {
        await session.close();
      }
    });

    // ── Admin Approve / Reject ──────────────────────────────────────────────

    test('rejectReward sets status to REJECTED', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999044', referralCode: 'FPKREJ');
        final invitee = await _seedUser(sessionBuilder, '9999999045');
        final referral = await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!,
            '9999999045', 'FPKREJ', 'QUALIFIED');

        await referralService.rejectReward(
          session, referral.id.toString(), 'Fraud detected', 'admin_fb_rej');

        final updated = await protocol.ReferralRow.db.findById(session, referral.id!);
        expect(updated!.status, equals('REJECTED'));
        expect(updated.fraudNotes, equals('Fraud detected'));
      } finally {
        await session.close();
      }
    });

    test('approveReward processes reward for QUALIFIED referral', () async {
      final session = sessionBuilder.build();
      try {
        final referrer = await _seedUser(sessionBuilder, '9999999046', referralCode: 'FPKAPR',
            currentFreshPoints: 200, totalEarned: 200);
        final invitee = await _seedUser(sessionBuilder, '9999999047');
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(session,
            protocol.CustomerOrderRow(
              orderNumber: 'apr-${now.microsecondsSinceEpoch}',
              userId: invitee.id!,
              orderStatus: 'delivered',
              paymentStatus: 'paid',
              refundStatus: 'none',
              itemCount: 1,
              totalAmount: 300.0,
              discountAmount: 0.0,
              deliveryFee: 0.0,
              finalAmount: 300.0,
              orderType: 'regular',
              paymentMode: 'standard',
              orderedAt: now.subtract(const Duration(hours: 2)),
            ));
        final referral = await _seedReferralRow(sessionBuilder, referrer.id!, invitee.id!,
            '9999999047', 'FPKAPR', 'QUALIFIED',
            qualifyingOrderId: order.id);

        await referralService.approveReward(
          session, referral.id.toString(), 'admin_fb_appr');

        final updated = await protocol.ReferralRow.db.findById(session, referral.id!);
        expect(updated!.status, equals('REWARDED'));
        expect(updated.rewardPointsIssued, greaterThan(0));
      } finally {
        await session.close();
      }
    });
  });
}

// ── Helpers ──────────────────────────────────────────────────────────────────

Future<protocol.AppUserRow> _seedUser(
  TestSessionBuilder sessionBuilder,
  String phone, {
  String? name,
  String? referralCode,
  String? firebaseUid,
  int currentFreshPoints = 0,
  int totalEarned = 0,
}) async {
  final session = sessionBuilder.build();
  try {
    return await protocol.AppUserRow.db.insertRow(
      session,
      protocol.AppUserRow(
        phoneNumber: phone,
        name: name ?? 'Test User $phone',
        role: 'customer',
        status: 'active',
        currentFreshPoints: currentFreshPoints,
        totalEarned: totalEarned,
        referralCode: referralCode,
        firebaseUid: firebaseUid,
      ),
    );
  } finally {
    await session.close();
  }
}

Future<protocol.ReferralSettingsRow> _seedSettingsRow(
  TestSessionBuilder sessionBuilder, {
  double minimumQualifyingAmount = 0.0,
  int maxRewardedPerMonth = 20,
  String rewardTriggerStatus = 'DELIVERED',
  bool enableFraudScoring = false,
}) async {
  final session = sessionBuilder.build();
  try {
    return await protocol.ReferralSettingsRow.db.insertRow(
      session,
      protocol.ReferralSettingsRow(
        minimumQualifyingAmount: minimumQualifyingAmount,
        maxRewardedPerMonth: maxRewardedPerMonth,
        rewardTriggerStatus: rewardTriggerStatus,
        enableFraudScoring: enableFraudScoring,
      ),
    );
  } finally {
    await session.close();
  }
}

Future<protocol.ReferralRow> _seedReferralRow(
  TestSessionBuilder sessionBuilder,
  UuidValue referrerUserId,
  UuidValue? inviteeUserId,
  String inviteePhone,
  String referralCodeUsed,
  String status, {
  int rewardPointsIssued = 0,
  bool inviteeCouponIssued = false,
  UuidValue? qualifyingOrderId,
  DateTime? rewardIssuedAt,
}) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    return await protocol.ReferralRow.db.insertRow(
      session,
      protocol.ReferralRow(
        referrerUserId: referrerUserId,
        inviteeUserId: inviteeUserId,
        inviteePhone: inviteePhone,
        referralCodeUsed: referralCodeUsed,
        status: status,
        qualifyingOrderId: qualifyingOrderId,
        rewardPointsIssued: rewardPointsIssued,
        inviteeCouponIssued: inviteeCouponIssued,
        rewardIssuedAt: rewardIssuedAt,
        createdAt: now,
        updatedAt: now,
      ),
    );
  } finally {
    await session.close();
  }
}
