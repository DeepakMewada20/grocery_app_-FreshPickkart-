import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/notification_outbox_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Notification system', (sessionBuilder, endpoints) {
    test('registers tokens and persists preferences', () async {
      final firebaseUid = await _seedUser(sessionBuilder);

      final registered = await endpoints.notification.registerFcmToken(
        sessionBuilder,
        firebaseUid,
        'fcm-token-1',
        'device-1',
        'android',
      );
      expect(registered, isTrue);

      final session = sessionBuilder.build();
      try {
        final token = await protocol.UserFcmTokenRow.db.findFirstRow(
          session,
          where: (t) => t.firebaseUid.equals(firebaseUid),
        );
        expect(token?.fcmToken, equals('fcm-token-1'));
        expect(token?.deviceId, equals('device-1'));
      } finally {
        await session.close();
      }

      final defaults = await endpoints.notification.getPreferences(
        sessionBuilder,
        firebaseUid,
      );
      expect(defaults.trackOrderNotifications, isTrue);
      expect(defaults.couponNotifications, isTrue);

      final updated = await endpoints.notification.updatePreferences(
        sessionBuilder,
        firebaseUid,
        defaults.copyWith(couponNotifications: false),
      );
      expect(updated.couponNotifications, isFalse);

      final refetched = await endpoints.notification.getPreferences(
        sessionBuilder,
        firebaseUid,
      );
      expect(refetched.couponNotifications, isFalse);
    });

    test('unregisters only the logged out device token', () async {
      final firebaseUid = await _seedUser(sessionBuilder);

      await endpoints.notification.registerFcmToken(
        sessionBuilder,
        firebaseUid,
        'fcm-token-1',
        'device-1',
        'android',
      );
      await endpoints.notification.registerFcmToken(
        sessionBuilder,
        firebaseUid,
        'fcm-token-2',
        'device-2',
        'android',
      );

      final unregistered = await endpoints.notification.unregisterFcmToken(
        sessionBuilder,
        firebaseUid,
        'device-1',
        token: 'fcm-token-1',
      );
      expect(unregistered, isTrue);

      final session = sessionBuilder.build();
      try {
        final rows = await protocol.UserFcmTokenRow.db.find(
          session,
          where: (t) => t.firebaseUid.equals(firebaseUid),
        );
        final byDevice = {for (final row in rows) row.deviceId: row};
        expect(byDevice['device-1']?.isActive, isFalse);
        expect(byDevice['device-2']?.isActive, isTrue);
      } finally {
        await session.close();
      }
    });

    test('re-registering a logged out device reactivates it', () async {
      final firebaseUid = await _seedUser(sessionBuilder);

      await endpoints.notification.registerFcmToken(
        sessionBuilder,
        firebaseUid,
        'old-token',
        'device-1',
        'android',
      );
      await endpoints.notification.unregisterFcmToken(
        sessionBuilder,
        firebaseUid,
        'device-1',
        token: 'old-token',
      );
      await endpoints.notification.registerFcmToken(
        sessionBuilder,
        firebaseUid,
        'new-token',
        'device-1',
        'android',
      );

      final session = sessionBuilder.build();
      try {
        final row = await protocol.UserFcmTokenRow.db.findFirstRow(
          session,
          where: (t) =>
              t.firebaseUid.equals(firebaseUid) & t.deviceId.equals('device-1'),
        );
        expect(row?.isActive, isTrue);
        expect(row?.fcmToken, equals('new-token'));
      } finally {
        await session.close();
      }
    });

    test('lists, marks, and deletes notification history', () async {
      final firebaseUid = await _seedUser(sessionBuilder);
      final campaignId = await _seedCampaign(sessionBuilder);

      final page = await endpoints.notification.listNotifications(
        sessionBuilder,
        firebaseUid,
        limit: 20,
      );
      expect(page.items, hasLength(1));
      expect(page.items.single.campaignId, equals(campaignId));
      expect(page.items.single.isRead, isFalse);
      expect(page.unreadCount, equals(1));

      expect(
        await endpoints.notification.markNotificationRead(
          sessionBuilder,
          firebaseUid,
          campaignId,
        ),
        isTrue,
      );
      final readPage = await endpoints.notification.listNotifications(
        sessionBuilder,
        firebaseUid,
        limit: 20,
      );
      expect(readPage.items.single.isRead, isTrue);
      expect(readPage.unreadCount, equals(0));

      expect(
        await endpoints.notification.deleteNotification(
          sessionBuilder,
          firebaseUid,
          campaignId,
        ),
        isTrue,
      );
      final deletedPage = await endpoints.notification.listNotifications(
        sessionBuilder,
        firebaseUid,
        limit: 20,
      );
      expect(deletedPage.items, isEmpty);
    });

    test('broadcast create queues outbox without sending inline', () async {
      final session = sessionBuilder.build();
      try {
        final campaign = await NotificationOutboxService.instance.saveBroadcast(
          session: session,
          request: protocol.BroadcastRequest(
            title: 'Service update',
            body: 'Delivery slots are open.',
            announcementType: 'service_update',
            targetAudience: 'all_users',
            priority: 'normal',
          ),
          creatorAdminFirebaseUid: 'admin-test',
          asDraft: false,
        );

        expect(campaign.status, equals('queued'));
        final outbox = await protocol.NotificationOutboxRow.db.findFirstRow(
          session,
          where: (t) => t.campaignId.equals(campaign.id!),
        );
        expect(outbox, isNotNull);
        expect(outbox!.processedAt, isNull);
        expect(outbox.status, equals('queued'));
      } finally {
        await session.close();
      }
    });

    test('scheduled broadcast is queued for future attempt', () async {
      final session = sessionBuilder.build();
      try {
        final scheduledAt = DateTime.now().toUtc().add(
          const Duration(hours: 2),
        );
        final campaign = await NotificationOutboxService.instance.saveBroadcast(
          session: session,
          request: protocol.BroadcastRequest(
            title: 'Scheduled update',
            body: 'This should wait.',
            announcementType: 'general',
            targetAudience: 'all_users',
            priority: 'normal',
            scheduledAt: scheduledAt,
          ),
          creatorAdminFirebaseUid: 'admin-test',
          asDraft: false,
        );

        expect(campaign.status, equals('scheduled'));
        final outbox = await protocol.NotificationOutboxRow.db.findFirstRow(
          session,
          where: (t) => t.campaignId.equals(campaign.id!),
        );
        expect(outbox?.nextAttemptAt, equals(scheduledAt));
        expect(outbox?.processedAt, isNull);
      } finally {
        await session.close();
      }
    });

    test('targeted campaign appears in notification center', () async {
      final firebaseUid = await _seedUser(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.findFirstRow(
          session,
          where: (t) => t.firebaseUid.equals(firebaseUid),
        );
        final campaign = await protocol.NotificationCampaignRow.db.insertRow(
          session,
          protocol.NotificationCampaignRow(
            title: 'Private offer',
            body: 'A targeted message.',
            type: 'promotion',
            topic: 'broadcast-targeted',
            targetAudience: 'specific_users',
            status: 'sent',
            priority: 'normal',
            createdAt: DateTime.now().toUtc(),
          ),
        );
        await protocol.NotificationUserStateRow.db.insertRow(
          session,
          protocol.NotificationUserStateRow(
            campaignId: campaign.id!,
            userId: user!.id!,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      } finally {
        await session.close();
      }

      final page = await endpoints.notification.listNotifications(
        sessionBuilder,
        firebaseUid,
        limit: 20,
      );
      expect(page.items.map((item) => item.title), contains('Private offer'));
    });
  });
}

Future<String> _seedUser(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final user = await protocol.AppUserRow.db.insertRow(
      session,
      protocol.AppUserRow(
        firebaseUid: 'notification-user-$suffix',
        phoneNumber: '9999999999',
        role: 'customer',
        status: 'active',
      ),
    );
    return user.firebaseUid!;
  } finally {
    await session.close();
  }
}

Future<String> _seedCampaign(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final campaign = await protocol.NotificationCampaignRow.db.insertRow(
      session,
      protocol.NotificationCampaignRow(
        title: 'Fresh coupon',
        body: 'Use SAVE10 today.',
        type: 'coupon',
        topic: 'coupons',
        targetAudience: 'all',
        entityType: 'coupon',
        entityId: 'SAVE10',
        dataJson: '{"couponCode":"SAVE10"}',
        createdAt: DateTime.now().toUtc(),
      ),
    );
    return campaign.id!.toString();
  } finally {
    await session.close();
  }
}
