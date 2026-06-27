import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_admin_service.dart';
import '../services/postgres/postgres_auto_refund_service.dart';
import '../services/postgres/postgres_payment_service.dart';
import '../services/postgres/postgres_support.dart';

class AdminEndpoint extends Endpoint {
  final PostgresAdminService _adminService = PostgresAdminService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAutoRefundService _autoRefund = PostgresAutoRefundService();
  final PostgresPaymentService _payments = PostgresPaymentService();

  Future<bool> isAdminSetupCompleted(Session session) {
    return _adminService.isAdminSetupCompleted(session);
  }

  Future<String> resolveAdminLoginEmail(
    Session session,
    String usernameOrEmail,
  ) {
    return _adminService.resolveAdminLoginEmail(session, usernameOrEmail);
  }

  Future<protocol.AdminAuthResult> firebaseLogin(
    Session session,
    String idToken,
  ) {
    return _adminService.firebaseLogin(session, idToken);
  }

  Future<protocol.AdminAuthResult> completeFirebaseSetup(
    Session session,
    String idToken,
    String username,
  ) {
    return _adminService.completeFirebaseSetup(session, idToken, username);
  }

  Future<String> updateAdminUsername(
    Session session,
    String firebaseUid,
    String idToken,
    String newUsername,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.updateAdminUsername(
      session,
      firebaseUid,
      newUsername,
    );
  }

  Future<List<protocol.AppUser>> getAllUsers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAllUsers(session);
  }

  Future<protocol.AdminDashboardStats> getDashboardStats(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getDashboardStats(session);
  }

  Future<protocol.AdminAnalytics> getAnalytics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAnalytics(session);
  }

  Future<protocol.AdminDashboardHydrated> getDashboardHydrated(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final results = await Future.wait([
      _adminService.getDashboardStats(session),
      _adminService.getAnalytics(session),
      _adminService.getSmgmAnalytics(session),
    ]);
    return protocol.AdminDashboardHydrated(
      stats: results[0] as protocol.AdminDashboardStats,
      analytics: results[1] as protocol.AdminAnalytics,
      smgmAnalytics: results[2] as protocol.SmgmAnalytics,
    );
  }

  Future<List<protocol.AdminAuditLogEntry>> getAuditLogs(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 50,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAuditLogs(session, limit: limit);
  }

  Future<List<protocol.ActiveUserStatistics>> getActiveUsersWithStats(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 100,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getActiveUsersWithStats(session, limit: limit);
  }

  /// Get auto-refund job status for duplicate payment tracking.
  /// Returns a JSON-serialized list of auto-refund jobs for the given order.
  Future<String> getAutoRefundJobStatus(
    Session session,
    String firebaseUid,
    String idToken,
    String orderNumber,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final jobs = await _autoRefund.listJobsByOrder(session, orderNumber);
    return jsonEncode(jobs);
  }

  /// Retry an auto-refund job for a given order.
  /// Resets the latest job back to PENDING with attemptCount=0.
  Future<String> retryAutoRefund(
    Session session,
    String firebaseUid,
    String idToken,
    String orderNumber,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final jobs = await _autoRefund.listJobsByOrder(session, orderNumber);
      if (jobs.isEmpty) {
        return jsonEncode({
          'success': false,
          'error': 'No auto-refund jobs found',
        });
      }
      // Find the latest job
      final latest = jobs.last;
      final jobId = latest['id'] as String?;
      if (jobId == null) {
        return jsonEncode({'success': false, 'error': 'Invalid job data'});
      }
      final parsedId = tryParseUuid(jobId);
      if (parsedId == null) {
        return jsonEncode({'success': false, 'error': 'Invalid job ID'});
      }
      final jobRow = await protocol.AutoRefundJobRow.db.findById(
        session,
        parsedId,
      );
      if (jobRow == null) {
        return jsonEncode({'success': false, 'error': 'Job not found'});
      }
      const allowedStates = ['FAILED', 'MANUAL_REVIEW'];
      if (!allowedStates.contains(jobRow.jobStatus)) {
        return jsonEncode({
          'success': false,
          'error':
              'Job is in \'${jobRow.jobStatus}\' state and cannot be retried. '
              'Allowed states: FAILED, MANUAL_REVIEW.',
        });
      }
      await _autoRefund.updateJobStatus(
        session,
        jobRow,
        status: 'PENDING',
        error: null,
      );
      return jsonEncode({
        'success': true,
        'message': 'Auto-refund retry initiated',
      });
    } catch (e) {
      return jsonEncode({'success': false, 'error': e.toString()});
    }
  }

  /// Mark an auto-refund job as reviewed (moves from MANUAL_REVIEW back to PENDING).
  Future<String> markAutoRefundReviewed(
    Session session,
    String firebaseUid,
    String idToken,
    String orderNumber,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final jobs = await _autoRefund.listJobsByOrder(session, orderNumber);
      final manualReview = jobs
          .where((j) => j['jobStatus'] == 'MANUAL_REVIEW')
          .toList();
      if (manualReview.isEmpty) {
        return jsonEncode({
          'success': false,
          'error': 'No MANUAL_REVIEW jobs found',
        });
      }
      final latest = manualReview.last;
      final jobId = latest['id'] as String?;
      if (jobId == null) {
        return jsonEncode({'success': false, 'error': 'Invalid job data'});
      }
      final parsedId = tryParseUuid(jobId);
      if (parsedId == null) {
        return jsonEncode({'success': false, 'error': 'Invalid job ID'});
      }
      final jobRow = await protocol.AutoRefundJobRow.db.findById(
        session,
        parsedId,
      );
      if (jobRow == null) {
        return jsonEncode({'success': false, 'error': 'Job not found'});
      }
      await _autoRefund.updateJobStatus(
        session,
        jobRow,
        status: 'COMPLETED',
        error: 'Reviewed by admin',
        processedAt: DateTime.now().toUtc(),
      );
      return jsonEncode({
        'success': true,
        'message': 'Auto-refund marked as reviewed',
      });
    } catch (e) {
      return jsonEncode({'success': false, 'error': e.toString()});
    }
  }

  /// Get payment health metrics for the admin dashboard.
  /// Returns JSON with counts for pending payments, expired sessions,
  /// auto-refund jobs, duplicate payments, and manual reviews.
  Future<String> getPaymentHealthMetrics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final now = DateTime.now().toUtc();
      final todayStart = DateTime(now.year, now.month, now.day);

      // Pending payments count
      final pendingPayments = await protocol.CustomerOrderRow.db.find(
        session,
        where: (t) => t.paymentStatus.equals('pending'),
      );

      // Auto-refund counts
      final pendingJobs = await protocol.AutoRefundJobRow.db.find(
        session,
        where: (t) => t.jobStatus.equals('PENDING'),
      );
      final failedJobs = await protocol.AutoRefundJobRow.db.find(
        session,
        where: (t) => t.jobStatus.equals('FAILED'),
      );
      final manualReviewJobs = await protocol.AutoRefundJobRow.db.find(
        session,
        where: (t) => t.jobStatus.equals('MANUAL_REVIEW'),
      );

      // Duplicate payments detected today
      final duplicatesToday = await protocol.AutoRefundJobRow.db.find(
        session,
        where: (t) => t.createdAt >= todayStart,
      );

      // Orphan payments — paid transactions with no matching paid order
      final orphanResult = await session.db.unsafeQuery(
        'SELECT COUNT(*) AS cnt FROM "payment_transaction" pt '
        'LEFT JOIN "customer_order" co ON co.id = pt."orderId" '
        'WHERE pt."paymentStatus" = \'paid\' '
        'AND (co.id IS NULL OR co."paymentStatus" != \'paid\')',
      );
      final orphanCount =
          (orphanResult.first.toColumnMap()['cnt'] as int?) ?? 0;

      // Refund failures in last 24 hours
      final refundFailResult = await session.db.unsafeQuery(
        'SELECT COUNT(*) AS cnt FROM "refund_record" '
        'WHERE "refundStatus" = \'failed\' '
        'AND "createdAt" >= @yesterday',
        parameters: QueryParameters.named({
          'yesterday': now
              .subtract(const Duration(hours: 24))
              .toIso8601String(),
        }),
      );
      final recentRefundFailuresCount =
          (refundFailResult.first.toColumnMap()['cnt'] as int?) ?? 0;

      // Backlog — total incomplete jobs
      final backlogJobs = await protocol.AutoRefundJobRow.db.find(
        session,
        where: (t) =>
            t.jobStatus.equals('PENDING') |
            t.jobStatus.equals('FAILED') |
            t.jobStatus.equals('PROCESSING'),
      );

      return jsonEncode({
        'pendingPaymentCount': pendingPayments.length,
        'expiredSessionCount': pendingPayments
            .where(
              (o) =>
                  o.paymentLinkExpiresAt != null &&
                  o.paymentLinkExpiresAt!.isBefore(now),
            )
            .length,
        'autoRefundPendingCount': pendingJobs.length,
        'autoRefundFailedCount': failedJobs.length,
        'autoRefundBacklogCount': backlogJobs.length,
        'autoRefundMaxPerCycle': 25,
        'autoRefundRetryLimit': 5,
        'duplicatePaymentCount': duplicatesToday.length,
        'manualReviewCount': manualReviewJobs.length,
        'orphanPaymentCount': orphanCount,
        'refundFailures24h': recentRefundFailuresCount,
      });
    } catch (e) {
      return jsonEncode({'error': e.toString()});
    }
  }

  /// Manually reconcile a payment link order by checking Razorpay's Payment Links API.
  /// If the link shows as paid, processes the payment and updates the order status.
  Future<String> adminReconcilePaymentLink(
    Session session,
    String firebaseUid,
    String idToken,
    String orderNumber,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final result = await _payments.reconcilePaymentLinkOrders(
        session,
        limit: 1,
        singleOrderNumber: orderNumber,
      );
      final recovered = result['recovered'] ?? 0;
      return jsonEncode({
        'success': true,
        'recovered': recovered,
        'message': recovered > 0
            ? 'Payment recovered successfully'
            : 'No payment link found or already processed',
      });
    } catch (e) {
      return jsonEncode({'success': false, 'error': e.toString()});
    }
  }
}
