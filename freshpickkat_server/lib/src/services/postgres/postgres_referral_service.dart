import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../notifications/notification_service.dart';
import 'postgres_audit_log_service.dart';
import 'postgres_support.dart';

class PostgresReferralService {
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();

  static const _codePrefix = 'FPK';
  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  // ── Code Generation ───────────────────────────────────────────────────────

  static String generateReferralCode() {
    final random = Random();
    final suffix = String.fromCharCodes(Iterable.generate(
      4,
      (_) => _codeChars.codeUnitAt(random.nextInt(_codeChars.length)),
    ));
    return '$_codePrefix$suffix';
  }

  // ── User Referral Code ────────────────────────────────────────────────────

  Future<String> getOrCreateReferralCodeForUser(
    Session session,
    UuidValue userId,
  ) async {
    final user = await AppUserRow.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    if (user.referralCode != null) return user.referralCode!;

    String code;
    var attempts = 0;
    do {
      code = generateReferralCode();
      final existing = await AppUserRow.db.findFirstRow(
        session,
        where: (t) => t.referralCode.equals(code),
      );
      if (existing == null) break;
      attempts++;
    } while (attempts < 10);

    if (attempts >= 10) {
      throw Exception('Failed to generate unique referral code');
    }

    await AppUserRow.db.updateRow(
      session,
      user.copyWith(referralCode: code),
    );
    return code;
  }

  // ── Validation ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> validateReferralCode(
    Session session,
    String code,
    UuidValue currentUserId,
  ) async {
    final normalized = code.trim().toUpperCase();
    final referrer = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.referralCode.equals(normalized),
    );
    if (referrer == null) return null;
    if (referrer.id == currentUserId) return null;

    final existing = await ReferralRow.db.findFirstRow(
      session,
      where: (t) => t.inviteeUserId.equals(currentUserId),
    );
    if (existing != null) return null;

    return {
      'referrerUserId': referrer.id.toString(),
      'referrerName': referrer.name ?? 'Someone',
    };
  }

  // ── Apply Referral ────────────────────────────────────────────────────────

  Future<void> applyReferral(
    Session session,
    UuidValue inviteeUserId,
    String inviteePhone,
    String referralCode,
  ) async {
    final normalized = referralCode.trim().toUpperCase();

    final referrer = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.referralCode.equals(normalized),
    );
    if (referrer == null || referrer.id == inviteeUserId) {
      throw Exception('Invalid referral code');
    }

    final existing = await ReferralRow.db.findFirstRow(
      session,
      where: (t) => t.inviteeUserId.equals(inviteeUserId),
    );
    if (existing != null) throw Exception('Already referred');

    final now = DateTime.now().toUtc();
    await ReferralRow.db.insertRow(
      session,
      ReferralRow(
        referrerUserId: referrer.id!,
        inviteeUserId: inviteeUserId,
        inviteePhone: inviteePhone,
        referralCodeUsed: normalized,
        status: 'SIGNED_UP',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: 'referral_system',
      action: 'REFERRAL_CODE_APPLIED',
      entityType: 'referral',
      metadata: {
        'referrerUserId': referrer.id.toString(),
        'inviteeUserId': inviteeUserId.toString(),
        'referralCode': normalized,
      },
    );
  }

  // ── Lookup ────────────────────────────────────────────────────────────────

  Future<ReferralRow?> getReferralByInvitee(
    Session session,
    UuidValue userId,
  ) async {
    return ReferralRow.db.findFirstRow(
      session,
      where: (t) => t.inviteeUserId.equals(userId),
    );
  }

  // ── User Facing ───────────────────────────────────────────────────────────

  Future<ReferralCodeInfo> getMyReferralCodeInfo(
    Session session,
    UuidValue userId,
  ) async {
    final code = await getOrCreateReferralCodeForUser(session, userId);
    final settings = await getOrCreateSettings(session);

    final shareLink = 'https://freshpickkat.com/invite?ref=$code';
    final shareMessage =
        settings.shareMessageTemplate.replaceAll('{CODE}', code);

    final referrals = await ReferralRow.db.find(
      session,
      where: (t) => t.referrerUserId.equals(userId),
    );

    return ReferralCodeInfo(
      referralCode: code,
      shareLink: shareLink,
      shareMessage: shareMessage,
      totalReferred: referrals.length,
      totalQualified:
          referrals.where((r) => r.status == 'REWARDED').length,
      totalRewardsEarned: referrals.fold<int>(
        0,
        (sum, r) => sum + r.rewardPointsIssued,
      ),
    );
  }

  Future<List<ReferralActivity>> getMyReferralActivity(
    Session session,
    UuidValue userId,
  ) async {
    final referrals = await ReferralRow.db.find(
      session,
      where: (t) => t.referrerUserId.equals(userId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 50,
    );

    return referrals.map((ref) {
      final phone = ref.inviteePhone;
      final masked = phone.length >= 4
          ? '${phone.substring(0, 2)}****${phone.substring(phone.length - 2)}'
          : '****';

      return ReferralActivity(
        type: ref.status,
        inviteePhone: masked,
        description: switch (ref.status) {
          'SIGNED_UP' => 'Friend signed up using your referral code',
          'REWARDED' =>
            'You earned ${ref.rewardPointsIssued} FreshPoints for this referral',
          'REJECTED' => 'Referral reward was not approved',
          'EXPIRED' => 'Referral has expired',
          _ => 'Referral status: ${ref.status}',
        },
        pointsEarned:
            ref.rewardPointsIssued > 0 ? ref.rewardPointsIssued : null,
        createdAt: ref.updatedAt,
      );
    }).toList();
  }

  // ── Reward Engine ─────────────────────────────────────────────────────────

  Future<void> checkOrderForReward(Session session, String orderId) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (order == null) return;
    if (order.userId == null) return;
    if (order.finalAmount == null) return;

    final referral = await ReferralRow.db.findFirstRow(
      session,
      where: (t) => t.inviteeUserId.equals(order.userId),
    );
    if (referral == null) return;
    if (referral.status == 'REWARDED' ||
        referral.status == 'REJECTED' ||
        referral.status == 'EXPIRED') return;

    final settings = await getOrCreateSettings(session);
    if (!settings.isEnabled) return;
    if ((order.finalAmount ?? 0) < settings.minimumQualifyingAmount) return;
    if (!_isStatusAtOrAfter(
        order.orderStatus, settings.rewardTriggerStatus)) return;

    final alreadyRewarded = await ReferralRow.db.findFirstRow(
      session,
      where: (t) =>
          t.inviteeUserId.equals(order.userId) &
          t.status.equals('REWARDED'),
    );
    if (alreadyRewarded != null) return;

    if (settings.maxRewardedPerMonth > 0) {
      final now = DateTime.now().toUtc();
      final monthStart = DateTime(now.year, now.month, 1).toUtc();
      final monthly = await ReferralRow.db.find(
        session,
        where: (t) =>
            t.referrerUserId.equals(referral.referrerUserId) &
            t.status.equals('REWARDED') &
            t.rewardIssuedAt.notEquals(null) &
            (t.rewardIssuedAt >= monthStart),
      );
      if (monthly.length >= settings.maxRewardedPerMonth) return;
    }

    if (referral.referrerUserId == referral.inviteeUserId) {
      await ReferralRow.db.updateRow(
        session,
        referral.copyWith(
          status: 'REJECTED',
          fraudNotes: 'Self-referral detected',
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      return;
    }

    final settingsRow = await ReferralSettingsRow.db.findFirstRow(session);
    await _processReward(session, referral, order, settingsRow);
  }

  bool _isStatusAtOrAfter(String current, String trigger) {
    const order = [
      'placed',
      'confirmed',
      'packed',
      'out_for_delivery',
      'delivered',
      'cancelled',
      'returned',
    ];
    final curIdx = order.indexOf(current.toLowerCase());
    final trigIdx = order.indexOf(trigger.toLowerCase());
    if (curIdx == -1 || trigIdx == -1) return false;
    return curIdx >= trigIdx;
  }

  Future<void> _processReward(
    Session session,
    ReferralRow referral,
    CustomerOrderRow order,
    ReferralSettingsRow? settingsRow,
  ) async {
    final settings = settingsRow ?? await getOrCreateSettingsRow(session);
    final now = DateTime.now().toUtc();
    final couponCode =
        settings.inviteeCouponCodeTemplate.replaceAll('{CODE}', referral.referralCodeUsed);

    var pointsIssued = 0;

    await session.db.transaction((transaction) async {
      // 1 — Invitee coupon
      if (settings.inviteeCouponEnabled) {
        final existing = await CouponRow.db.findFirstRow(
          session,
          where: (t) => t.code.equals(couponCode),
          transaction: transaction,
        );
        if (existing == null) {
          await CouponRow.db.insertRow(
            session,
            CouponRow(
              code: couponCode,
              description:
                  'Welcome reward for using referral code ${referral.referralCodeUsed}',
              couponType: 'FLAT_DISCOUNT',
              discountValue: settings.inviteeCouponAmount,
              minOrderAmount: 0,
              maxUsageTotal: 1,
              maxUsagePerUser: 1,
              startsAt: now,
              endsAt: now.add(const Duration(days: 30)),
              status: 'active',
              createdAt: now,
              updatedAt: now,
            ),
            transaction: transaction,
          );
        }
      }

      // 2 — Referrer FreshPoints (directly within transaction)
      if (settings.referrerPointsEnabled && settings.referrerRewardPoints > 0) {
        pointsIssued = settings.referrerRewardPoints;
        final referrer = await AppUserRow.db.findById(
          session,
          referral.referrerUserId,
          transaction: transaction,
        );
        if (referrer != null) {
          final newBalance = referrer.currentFreshPoints + pointsIssued;
          await AppUserRow.db.updateRow(
            session,
            referrer.copyWith(
              currentFreshPoints: newBalance,
              totalEarned: referrer.totalEarned + pointsIssued,
            ),
            transaction: transaction,
          );

          await FreshPointsTransactionRow.db.insertRow(
            session,
            FreshPointsTransactionRow(
              userId: referral.referrerUserId,
              transactionType: 'REFERRAL_REWARD',
              points: pointsIssued,
              balanceBefore: referrer.currentFreshPoints,
              balanceAfter: newBalance,
              referenceType: 'referral',
              referenceId: referral.id,
              description:
                  'Referral reward: ${referral.inviteePhone}',
              createdBy: 'referral_system',
              createdAt: now,
            ),
            transaction: transaction,
          );
        }
      }

      // 3 — Update referral row
      await ReferralRow.db.updateRow(
        session,
        referral.copyWith(
          status: 'REWARDED',
          qualifyingOrderId: order.id,
          qualifyingOrderAmount: order.finalAmount,
          rewardPointsIssued: pointsIssued,
          inviteeCouponIssued: settings.inviteeCouponEnabled,
          rewardIssuedAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      // 4 — Audit log
      await _auditLog.write(
        session,
        actorFirebaseUid: 'referral_system',
        action: 'REFERRAL_REWARD_PROCESSED',
        entityType: 'referral',
        entityId: referral.id.toString(),
        metadata: {
          'referrerUserId': referral.referrerUserId.toString(),
          'inviteeUserId': referral.inviteeUserId?.toString() ?? '',
          'orderId': order.id.toString(),
          'orderAmount': (order.finalAmount ?? 0).toString(),
          'pointsIssued': pointsIssued.toString(),
          'couponCode':
              settings.inviteeCouponEnabled ? couponCode : 'disabled',
        },
      );
    });

    // ── Push notification (best-effort, after transaction) ─────────────────
    if (pointsIssued > 0) {
      try {
        final referrer = await AppUserRow.db.findById(
          session,
          referral.referrerUserId,
        );
        if (referrer?.firebaseUid != null) {
          await NotificationService.sendToTopic(
            topic: 'user-${referrer!.firebaseUid}',
            title: 'Referral Reward Earned!',
            body: 'You earned $pointsIssued FreshPoints for referring ${referral.inviteePhone}!',
            data: {'type': 'referral_reward', 'points': pointsIssued.toString()},
          );
        }
      } catch (_) {}
    }
  }

  // ── Settings CRUD ─────────────────────────────────────────────────────────

  Future<ReferralSettings?> getSettings(Session session) async {
    final row = await ReferralSettingsRow.db.findFirstRow(session);
    return row != null ? _mapSettings(row) : null;
  }

  Future<ReferralSettings> getOrCreateSettings(Session session) async {
    final row = await getOrCreateSettingsRow(session);
    return _mapSettings(row);
  }

  Future<ReferralSettingsRow> getOrCreateSettingsRow(Session session) async {
    final existing = await ReferralSettingsRow.db.findFirstRow(session);
    if (existing != null) return existing;

    final now = DateTime.now().toUtc();
    return ReferralSettingsRow.db.insertRow(
      session,
      ReferralSettingsRow(
        isEnabled: true,
        inviteeCouponEnabled: true,
        inviteeCouponAmount: 50.0,
        inviteeCouponCodeTemplate: 'WELCOME{CODE}',
        referrerPointsEnabled: true,
        referrerRewardPoints: 50,
        minimumQualifyingAmount: 0.0,
        rewardTriggerStatus: 'DELIVERED',
        maxRewardedPerMonth: 20,
        enableFraudProtection: true,
        enableReferralExpiry: false,
        referralExpiryDays: 90,
        shareMessageTemplate:
            'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!',
        updatedAt: now,
      ),
    );
  }

  Future<ReferralSettings> updateSettings(
    Session session,
    ReferralSettings settings, {
    required String adminFirebaseUid,
  }) async {
    final now = DateTime.now().toUtc();
    final admin = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(adminFirebaseUid),
    );

    final row = await ReferralSettingsRow.db.findFirstRow(session);
    final updated = await ReferralSettingsRow.db.updateRow(
      session,
      (row ?? ReferralSettingsRow()).copyWith(
        isEnabled: settings.isEnabled,
        inviteeCouponEnabled: settings.inviteeCouponEnabled,
        inviteeCouponAmount: settings.inviteeCouponAmount,
        inviteeCouponCodeTemplate: settings.inviteeCouponCodeTemplate,
        referrerPointsEnabled: settings.referrerPointsEnabled,
        referrerRewardPoints: settings.referrerRewardPoints,
        minimumQualifyingAmount: settings.minimumQualifyingAmount,
        rewardTriggerStatus: settings.rewardTriggerStatus,
        maxRewardedPerMonth: settings.maxRewardedPerMonth,
        enableFraudProtection: settings.enableFraudProtection,
        enableReferralExpiry: settings.enableReferralExpiry,
        referralExpiryDays: settings.referralExpiryDays,
        shareMessageTemplate: settings.shareMessageTemplate,
        lastUpdatedBy: admin?.id,
        updatedAt: now,
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: adminFirebaseUid,
      action: 'UPDATE_REFERRAL_SETTINGS',
      entityType: 'referral_settings',
      metadata: {
        'isEnabled': settings.isEnabled.toString(),
        'inviteeCouponAmount': settings.inviteeCouponAmount.toString(),
        'referrerRewardPoints': settings.referrerRewardPoints.toString(),
        'rewardTriggerStatus': settings.rewardTriggerStatus,
      },
    );

    return _mapSettings(updated);
  }

  // ── Admin ─────────────────────────────────────────────────────────────────

  Future<ReferralAdminStats> getReferralAnalytics(Session session) async {
    final all = await ReferralRow.db.find(session);

    final total = all.length;
    final rewarded = all.where((r) => r.status == 'REWARDED').length;
    final rejected = all.where((r) => r.status == 'REJECTED').length;
    final expired = all.where((r) => r.status == 'EXPIRED').length;
    final pending =
        all.where((r) => r.status != 'REWARDED' && r.status != 'REJECTED' && r.status != 'EXPIRED').length;
    final qualified = all.where((r) => r.status == 'REWARDED' || r.status == 'QUALIFIED').length;
    final totalPoints = all.fold<int>(0, (s, r) => s + r.rewardPointsIssued);
    final totalCoupons = all.where((r) => r.inviteeCouponIssued).length;

    final funnelQualified =
        all.where((r) => r.qualifyingOrderId != null || r.status == 'REWARDED').length;

    // Top referrers
    final counts = <UuidValue, int>{};
    final points = <UuidValue, int>{};
    final lastAct = <UuidValue, DateTime?>{};
    for (final ref in all) {
      counts.update(ref.referrerUserId, (v) => v + 1, ifAbsent: () => 1);
      points.update(ref.referrerUserId, (v) => v + ref.rewardPointsIssued, ifAbsent: () => ref.rewardPointsIssued);
      final prev = lastAct[ref.referrerUserId];
      if (prev == null || ref.updatedAt.isAfter(prev)) {
        lastAct[ref.referrerUserId] = ref.updatedAt;
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top = <TopReferrerEntry>[];
    for (final e in sorted.take(10)) {
      final user = await AppUserRow.db.findById(session, e.key);
      if (user != null) {
        final refs = all.where((r) => r.referrerUserId == e.key).toList();
        final rew = refs.where((r) => r.status == 'REWARDED').length;
        top.add(TopReferrerEntry(
          userId: user.id.toString(),
          name: user.name ?? 'Unknown',
          phone: user.phoneNumber,
          referralCount: e.value,
          rewardPointsIssued: points[e.key] ?? 0,
          qualificationRate: e.value > 0 ? rew / e.value : 0,
          lastActivity: lastAct[e.key],
        ));
      }
    }

    return ReferralAdminStats(
      totalReferrals: total,
      qualifiedReferrals: qualified,
      rewardedReferrals: rewarded,
      pendingReferrals: pending,
      rejectedReferrals: rejected,
      expiredReferrals: expired,
      totalPointsIssued: totalPoints,
      totalCouponsIssued: totalCoupons,
      funnelShared: total,
      funnelSignedUp: total,
      funnelQualified: funnelQualified,
      funnelRewarded: rewarded,
      topReferrers: top,
    );
  }

  Future<Map<String, dynamic>> listReferrals(
    Session session, {
    int limit = 20,
    String? pageToken,
    String? statusFilter,
  }) async {
    final cursor = decodeCursor(pageToken);
    final offset = cursor?['offset'] as int? ?? 0;

    final rows = await ReferralRow.db.find(
      session,
      where: (statusFilter != null && statusFilter.isNotEmpty)
          ? (t) => t.status.equals(statusFilter)
          : null,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: clampPageLimit(limit, defaultLimit: 20, maxLimit: 50),
      offset: offset,
    );

    final items = <Map<String, dynamic>>[];
    for (final row in rows) {
      final referrer = await AppUserRow.db.findById(session, row.referrerUserId);
      String? inviteeName;
      if (row.inviteeUserId != null) {
        final inv = await AppUserRow.db.findById(session, row.inviteeUserId!);
        inviteeName = inv?.name;
      }

      items.add({
        'id': row.id.toString(),
        'referrerUserId': row.referrerUserId.toString(),
        'referrerName': referrer?.name ?? 'Unknown',
        'referrerPhone': referrer?.phoneNumber ?? '',
        'inviteeUserId': row.inviteeUserId?.toString(),
        'inviteeName': inviteeName,
        'inviteePhone': row.inviteePhone,
        'status': row.status,
        'qualifyingOrderAmount': row.qualifyingOrderAmount,
        'rewardPointsIssued': row.rewardPointsIssued,
        'inviteeCouponIssued': row.inviteeCouponIssued,
        'fraudNotes': row.fraudNotes,
        'createdAt': row.createdAt.toIso8601String(),
        'updatedAt': row.updatedAt.toIso8601String(),
      });
    }

    final nextToken = rows.length >= limit
        ? encodeCursor({'offset': offset + rows.length})
        : null;

    return {'referrals': items, 'nextPageToken': nextToken};
  }

  Future<void> approveReward(
    Session session,
    String referralId,
    String adminFirebaseUid,
  ) async {
    final id = UuidValue.fromString(referralId);
    final referral = await ReferralRow.db.findById(session, id);
    if (referral == null) throw Exception('Referral not found');

    if (referral.status != 'QUALIFIED' && referral.status != 'REJECTED') {
      throw Exception('Referral is not in a reviewable state');
    }

    final order = referral.qualifyingOrderId != null
        ? await CustomerOrderRow.db.findById(session, referral.qualifyingOrderId!)
        : null;
    if (order == null) throw Exception('Qualifying order not found');

    await _processReward(session, referral, order, null);
  }

  Future<void> rejectReward(
    Session session,
    String referralId,
    String reason,
    String adminFirebaseUid,
  ) async {
    final id = UuidValue.fromString(referralId);
    final referral = await ReferralRow.db.findById(session, id);
    if (referral == null) throw Exception('Referral not found');

    final now = DateTime.now().toUtc();
    await ReferralRow.db.updateRow(
      session,
      referral.copyWith(
        status: 'REJECTED',
        fraudNotes: reason,
        updatedAt: now,
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: adminFirebaseUid,
      action: 'REFERRAL_REWARD_REJECTED',
      entityType: 'referral',
      entityId: referral.id.toString(),
      metadata: {
        'reason': reason,
        'referrerUserId': referral.referrerUserId.toString(),
        'inviteeUserId': referral.inviteeUserId?.toString() ?? '',
      },
    );
  }

  // ── Mappers ───────────────────────────────────────────────────────────────

  ReferralSettings _mapSettings(ReferralSettingsRow row) {
    return ReferralSettings(
      isEnabled: row.isEnabled,
      inviteeCouponEnabled: row.inviteeCouponEnabled,
      inviteeCouponAmount: row.inviteeCouponAmount,
      inviteeCouponCodeTemplate: row.inviteeCouponCodeTemplate,
      referrerPointsEnabled: row.referrerPointsEnabled,
      referrerRewardPoints: row.referrerRewardPoints,
      minimumQualifyingAmount: row.minimumQualifyingAmount,
      rewardTriggerStatus: row.rewardTriggerStatus,
      maxRewardedPerMonth: row.maxRewardedPerMonth,
      enableFraudProtection: row.enableFraudProtection,
      enableReferralExpiry: row.enableReferralExpiry,
      referralExpiryDays: row.referralExpiryDays,
      shareMessageTemplate: row.shareMessageTemplate,
      updatedAt: row.updatedAt,
    );
  }
}
