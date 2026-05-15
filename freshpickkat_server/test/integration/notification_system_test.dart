import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
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
