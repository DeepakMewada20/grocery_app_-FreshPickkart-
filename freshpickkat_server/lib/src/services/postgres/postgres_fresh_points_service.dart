import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_audit_log_service.dart';
import 'postgres_support.dart';

class PostgresFreshPointsService {
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();

  // ── Settings ───────────────────────────────────────────────────────────────

  Future<FreshPointsSettings?> getSettings(Session session) async {
    final row = await FreshPointsSettingsRow.db.findFirstRow(session);
    if (row == null) return null;
    return _mapSettings(row);
  }

  Future<FreshPointsSettings> getOrCreateSettings(Session session) async {
    final existing = await FreshPointsSettingsRow.db.findFirstRow(session);
    if (existing != null) return _mapSettings(existing);

    final now = DateTime.now().toUtc();
    final inserted = await FreshPointsSettingsRow.db.insertRow(
      session,
      FreshPointsSettingsRow(
        isEnabled: true,
        redemptionPercentageLimit: 50.0,
        allowRedemptionOnCOD: true,
        minimumOrderForRedemption: 0,
        enablePointExpiry: false,
        pointExpiryDays: 90,
        enableAdminAdjustments: true,
        updatedAt: now,
      ),
    );
    return _mapSettings(inserted);
  }

  Future<FreshPointsSettings> updateSettings(
    Session session,
    FreshPointsSettings settings, {
    required String adminFirebaseUid,
  }) async {
    final now = DateTime.now().toUtc();
    final admin = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(adminFirebaseUid),
    );

    final row = await FreshPointsSettingsRow.db.findFirstRow(session);
    final updated = await FreshPointsSettingsRow.db.updateRow(
      session,
      (row ?? FreshPointsSettingsRow()).copyWith(
        isEnabled: settings.isEnabled,
        redemptionPercentageLimit: settings.redemptionPercentageLimit,
        allowRedemptionOnCOD: settings.allowRedemptionOnCOD,
        minimumOrderForRedemption: settings.minimumOrderForRedemption,
        enablePointExpiry: settings.enablePointExpiry,
        pointExpiryDays: settings.pointExpiryDays,
        enableAdminAdjustments: settings.enableAdminAdjustments,
        lastUpdatedBy: admin?.id,
        updatedAt: now,
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: adminFirebaseUid,
      action: 'UPDATE_FRESH_POINTS_SETTINGS',
      entityType: 'fresh_points_settings',
      metadata: {
        'isEnabled': settings.isEnabled.toString(),
        'redemptionPercentageLimit': settings.redemptionPercentageLimit.toString(),
        'allowRedemptionOnCOD': settings.allowRedemptionOnCOD.toString(),
        'minimumOrderForRedemption': settings.minimumOrderForRedemption.toString(),
        'enablePointExpiry': settings.enablePointExpiry.toString(),
        'pointExpiryDays': settings.pointExpiryDays.toString(),
      },
    );

    return _mapSettings(updated);
  }

  // ── Balance ────────────────────────────────────────────────────────────────

  Future<int> getBalance(Session session, UuidValue userId) async {
    final user = await AppUserRow.db.findById(session, userId);
    return user?.currentFreshPoints ?? 0;
  }

  Future<FreshPointsBalance> getFullBalance(
    Session session,
    UuidValue userId,
  ) async {
    final user = await AppUserRow.db.findById(session, userId);
    final transactions = await FreshPointsTransactionRow.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 20,
    );

    return FreshPointsBalance(
      balance: user?.currentFreshPoints ?? 0,
      totalEarned: user?.totalEarned ?? 0,
      totalRedeemed: user?.totalRedeemed ?? 0,
      transactions: transactions.map(_mapTransaction).toList(),
    );
  }

  // ── Transactions (paginated) ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getTransactions(
    Session session,
    UuidValue userId, {
    int limit = 20,
    String? pageToken,
  }) async {
    final cursor = decodeCursor(pageToken);
    final offset = cursor?['offset'] as int? ?? 0;

    final rows = await FreshPointsTransactionRow.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: clampPageLimit(limit, defaultLimit: 20, maxLimit: 50),
      offset: offset,
    );

    final nextToken = rows.length >= limit
        ? encodeCursor({'offset': offset + rows.length})
        : null;

    return {
      'transactions': rows.map(_mapTransaction).toList(),
      'nextPageToken': nextToken,
    };
  }

  // ── Redeem (atomic balance decrement) ─────────────────────────────────────

  Future<void> redeemPoints(
    Session session,
    UuidValue userId,
    int points, {
    required String referenceType,
    UuidValue? referenceId,
    String? description,
    Transaction? transaction,
  }) async {
    if (points <= 0) return;

    final user = await AppUserRow.db.findById(
      session,
      userId,
      transaction: transaction,
    );
    if (user == null) {
      throw Exception('User not found');
    }
    if (user.currentFreshPoints < points) {
      throw Exception('Insufficient FreshPoints balance');
    }

    final newBalance = user.currentFreshPoints - points;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        currentFreshPoints: newBalance,
        totalRedeemed: user.totalRedeemed + points,
      ),
      transaction: transaction,
    );

    await FreshPointsTransactionRow.db.insertRow(
      session,
      FreshPointsTransactionRow(
        userId: userId,
        transactionType: 'REDEEM_ORDER',
        points: points,
        balanceBefore: user.currentFreshPoints,
        balanceAfter: newBalance,
        referenceType: referenceType,
        referenceId: referenceId,
        description: description,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  // ── Restore (on refund) ───────────────────────────────────────────────────

  Future<void> restorePoints(
    Session session,
    UuidValue userId,
    int points, {
    required String referenceType,
    UuidValue? referenceId,
    String? description,
    Transaction? transaction,
  }) async {
    if (points <= 0) return;

    final user = await AppUserRow.db.findById(
      session,
      userId,
      transaction: transaction,
    );
    if (user == null) {
      throw Exception('User not found');
    }

    final newBalance = user.currentFreshPoints + points;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        currentFreshPoints: newBalance,
      ),
      transaction: transaction,
    );

    await FreshPointsTransactionRow.db.insertRow(
      session,
      FreshPointsTransactionRow(
        userId: userId,
        transactionType: 'REFUND_RESTORE',
        points: points,
        balanceBefore: user.currentFreshPoints,
        balanceAfter: newBalance,
        referenceType: referenceType,
        referenceId: referenceId,
        description: description,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  // ── Admin Adjust ──────────────────────────────────────────────────────────

  Future<void> adminAdjust(
    Session session,
    UuidValue userId,
    int points,
    String transactionType,
    String description, {
    required String adminFirebaseUid,
  }) async {
    if (points <= 0) {
      throw Exception('Points must be positive');
    }

    final user = await AppUserRow.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    if (transactionType == 'ADMIN_DEDUCT' && user.currentFreshPoints < points) {
      throw Exception('Insufficient FreshPoints balance');
    }

    int newBalance;
    if (transactionType == 'ADMIN_ADD') {
      newBalance = user.currentFreshPoints + points;
      await AppUserRow.db.updateRow(
        session,
        user.copyWith(
          currentFreshPoints: newBalance,
          totalEarned: user.totalEarned + points,
        ),
      );
    } else if (transactionType == 'ADMIN_DEDUCT') {
      newBalance = user.currentFreshPoints - points;
      await AppUserRow.db.updateRow(
        session,
        user.copyWith(
          currentFreshPoints: newBalance,
        ),
      );
    } else {
      throw Exception('Invalid transaction type for admin adjust');
    }

    await FreshPointsTransactionRow.db.insertRow(
      session,
      FreshPointsTransactionRow(
        userId: userId,
        transactionType: transactionType,
        points: points,
        balanceBefore: user.currentFreshPoints,
        balanceAfter: newBalance,
        referenceType: 'admin',
        description: description,
        createdBy: adminFirebaseUid,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    await _auditLog.write(
      session,
      actorFirebaseUid: adminFirebaseUid,
      action: transactionType == 'ADMIN_ADD'
          ? 'FRESH_POINTS_ADD'
          : 'FRESH_POINTS_DEDUCT',
      entityType: 'app_user',
      entityId: userId.toString(),
      metadata: {
        'points': points.toString(),
        'description': description,
        'transactionType': transactionType,
      },
    );
  }

  // ── Max Redeemable ────────────────────────────────────────────────────────

  Future<int> getMaxRedeemable(
    Session session,
    UuidValue userId,
    double payableAmountAfterCoupon,
  ) async {
    final settings = await getOrCreateSettings(session);
    if (!settings.isEnabled) return 0;

    if (payableAmountAfterCoupon < settings.minimumOrderForRedemption) {
      return 0;
    }

    final user = await AppUserRow.db.findById(session, userId);
    if (user == null) return 0;

    return calculateMaxRedeemable(
      balance: user.currentFreshPoints,
      payableAfterCoupon: payableAmountAfterCoupon,
      redemptionLimitPercent: settings.redemptionPercentageLimit,
    );
  }

  /// Pure calculation — testable without DB.
  @visibleForTesting
  static int calculateMaxRedeemable({
    required int balance,
    required double payableAfterCoupon,
    required double redemptionLimitPercent,
  }) {
    final maxByLimit =
        (payableAfterCoupon * redemptionLimitPercent / 100).floor();
    final capped = maxByLimit < balance ? maxByLimit : balance;
    return capped < 0 ? 0 : capped;
  }

  // ── Mappers ───────────────────────────────────────────────────────────────

  FreshPointsSettings _mapSettings(FreshPointsSettingsRow row) {
    return FreshPointsSettings(
      isEnabled: row.isEnabled,
      redemptionPercentageLimit: row.redemptionPercentageLimit,
      allowRedemptionOnCOD: row.allowRedemptionOnCOD,
      minimumOrderForRedemption: row.minimumOrderForRedemption,
      enablePointExpiry: row.enablePointExpiry,
      pointExpiryDays: row.pointExpiryDays,
      enableAdminAdjustments: row.enableAdminAdjustments,
      updatedAt: row.updatedAt,
    );
  }

  FreshPointsTransaction _mapTransaction(FreshPointsTransactionRow row) {
    return FreshPointsTransaction(
      id: row.id.toString(),
      userId: row.userId.toString(),
      transactionType: row.transactionType,
      points: row.points,
      balanceBefore: row.balanceBefore,
      balanceAfter: row.balanceAfter,
      referenceType: row.referenceType,
      referenceId: row.referenceId?.toString(),
      description: row.description,
      createdBy: row.createdBy,
      createdAt: row.createdAt,
    );
  }
}
