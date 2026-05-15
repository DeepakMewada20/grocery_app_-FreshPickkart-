import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class NotificationHistoryService {
  final _client = ServerpodClient().client;

  Future<NotificationHistoryPage?> fetch({
    int limit = 30,
    String? pageToken,
  }) async {
    final uid = AuthController.instance.currentUser?.uid;
    if (uid == null) return null;
    return _client.notification.listNotifications(
      uid,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<void> markRead(String campaignId) async {
    final uid = AuthController.instance.currentUser?.uid;
    if (uid == null) return;
    await _client.notification.markNotificationRead(uid, campaignId);
  }

  Future<void> delete(String campaignId) async {
    final uid = AuthController.instance.currentUser?.uid;
    if (uid == null) return;
    await _client.notification.deleteNotification(uid, campaignId);
  }
}
