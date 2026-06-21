import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_fresh_points_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('FreshPoints integration', (sessionBuilder, endpoints) {
    late PostgresFreshPointsService fpService;

    setUp(() {
      fpService = PostgresFreshPointsService();
    });

    test('redeemPoints deducts balance and creates transaction', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999901',
            name: 'FP Test User',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 500,
            totalEarned: 500,
          ),
        );

        await fpService.redeemPoints(
          session,
          user.id!,
          100,
          referenceType: 'order',
          description: 'Test redeem 100 points',
        );

        final updated = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updated!.currentFreshPoints, equals(400));
        expect(updated.totalEarned, equals(500));
        expect(updated.totalRedeemed, equals(100));

        final txns = await protocol.FreshPointsTransactionRow.db.find(
          session,
          where: (t) => t.userId.equals(user.id!),
          orderBy: (t) => t.createdAt,
        );
        expect(txns.length, equals(1));
        expect(txns.first.transactionType, equals('REDEEM_ORDER'));
        expect(txns.first.points, equals(100));
        expect(txns.first.balanceBefore, equals(500));
        expect(txns.first.balanceAfter, equals(400));
      } finally {
        await session.close();
      }
    });

    test('redeemPoints fails when balance is insufficient', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999902',
            name: 'FP Low Balance',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 10,
            totalEarned: 10,
          ),
        );

        expect(
          () => fpService.redeemPoints(
            session,
            user.id!,
            100,
            referenceType: 'order',
            description: 'Should fail',
          ),
          throwsA(isA<Exception>()),
        );
      } finally {
        await session.close();
      }
    });

    test('restorePoints adds balance after refund', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999903',
            name: 'FP Refund Test',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 200,
            totalEarned: 500,
            totalRedeemed: 300,
          ),
        );

        await fpService.restorePoints(
          session,
          user.id!,
          150,
          referenceType: 'refund',
          description: 'Restored 150 points on refund',
        );

        final updated = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updated!.currentFreshPoints, equals(350));

        final txns = await protocol.FreshPointsTransactionRow.db.find(
          session,
          where: (t) => t.userId.equals(user.id!),
          orderBy: (t) => t.createdAt,
        );
        expect(txns.length, equals(1));
        expect(txns.first.transactionType, equals('REFUND_RESTORE'));
        expect(txns.first.points, equals(150));
        expect(txns.first.balanceBefore, equals(200));
        expect(txns.first.balanceAfter, equals(350));
      } finally {
        await session.close();
      }
    });

    test('adminAdjust adds points correctly', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999904',
            name: 'FP Admin Adjust',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 100,
            totalEarned: 100,
          ),
        );

        await fpService.adminAdjust(
          session,
          user.id!,
          50,
          'ADMIN_ADD',
          'Admin added 50 points',
          adminFirebaseUid: 'admin-test-uid',
        );

        final updated = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updated!.currentFreshPoints, equals(150));
        expect(updated.totalEarned, equals(150));
      } finally {
        await session.close();
      }
    });

    test('adminAdjust deducts points correctly', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999905',
            name: 'FP Admin Deduct',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 200,
            totalEarned: 200,
            totalRedeemed: 0,
          ),
        );

        await fpService.adminAdjust(
          session,
          user.id!,
          75,
          'ADMIN_DEDUCT',
          'Admin deducted 75 points',
          adminFirebaseUid: 'admin-test-uid',
        );

        final updated = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updated!.currentFreshPoints, equals(125));
        expect(updated.totalEarned, equals(200));
      } finally {
        await session.close();
      }
    });

    test('getFullBalance returns correct balance and transactions', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999906',
            name: 'FP Balance Test',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 300,
            totalEarned: 500,
            totalRedeemed: 200,
          ),
        );

        await protocol.FreshPointsTransactionRow.db.insertRow(
          session,
          protocol.FreshPointsTransactionRow(
            userId: user.id!,
            transactionType: 'EARNED',
            points: 500,
            balanceBefore: 0,
            balanceAfter: 500,
            createdAt: now,
          ),
        );

        await protocol.FreshPointsTransactionRow.db.insertRow(
          session,
          protocol.FreshPointsTransactionRow(
            userId: user.id!,
            transactionType: 'REDEEM_ORDER',
            points: 200,
            balanceBefore: 500,
            balanceAfter: 300,
            createdAt: now.add(const Duration(seconds: 1)),
          ),
        );

        final balance = await fpService.getFullBalance(session, user.id!);
        expect(balance.balance, equals(300));
        expect(balance.totalEarned, equals(500));
        expect(balance.totalRedeemed, equals(200));
        expect(balance.transactions.length, equals(2));
      } finally {
        await session.close();
      }
    });

    test('getMaxRedeemable respects settings and balance', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();

        await protocol.FreshPointsSettingsRow.db.insertRow(
          session,
          protocol.FreshPointsSettingsRow(
            isEnabled: true,
            redemptionPercentageLimit: 25,
            allowRedemptionOnCOD: true,
            minimumOrderForRedemption: 50.0,
            enablePointExpiry: false,
            pointExpiryDays: 365,
            enableAdminAdjustments: true,
            updatedAt: now,
          ),
        );

        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999907',
            name: 'FP MaxRedeem',
            role: 'customer',
            status: 'active',
            currentFreshPoints: 1000,
            totalEarned: 1000,
          ),
        );

        final max1 = await fpService.getMaxRedeemable(
          session, user.id!, 200.0,
        );
        expect(max1, equals(50));

        final max2 = await fpService.getMaxRedeemable(
          session, user.id!, 30.0,
        );
        expect(max2, equals(0));
      } finally {
        await session.close();
      }
    });

    test('getOrCreateSettings returns default settings', () async {
      final session = sessionBuilder.build();
      try {
        final settings = await fpService.getOrCreateSettings(session);
        expect(settings.isEnabled, isTrue);
        expect(settings.redemptionPercentageLimit, greaterThan(0));
      } finally {
        await session.close();
      }
    });
  });
}
