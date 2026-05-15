import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get_storage/get_storage.dart';

class NotificationPreferenceService {
  NotificationPreferenceService({GetStorage? storage})
    : _storage = storage ?? GetStorage();

  static const String _cachePrefix = 'notification_preferences_';

  final GetStorage _storage;

  NotificationPreference get cachedOrDefault {
    final uid = AuthController.instance.currentUser?.uid;
    final raw = uid == null ? null : _storage.read<Map>(_cachePrefix + uid);
    if (raw == null) return defaultPreference();
    return NotificationPreference(
      trackOrderNotifications: raw['trackOrderNotifications'] != false,
      couponNotifications: raw['couponNotifications'] != false,
      offerNotifications: raw['offerNotifications'] != false,
      announcementNotifications: raw['announcementNotifications'] != false,
      importantAlerts: raw['importantAlerts'] != false,
      updatedAt: raw['updatedAt'] is String
          ? DateTime.tryParse(raw['updatedAt'] as String)
          : null,
    );
  }

  Future<NotificationPreference> fetch() async {
    final uid = AuthController.instance.currentUser?.uid;
    if (uid == null) return cachedOrDefault;
    final prefs = await ServerpodClient().client.notification.getPreferences(
      uid,
    );
    await cache(prefs);
    return prefs;
  }

  Future<NotificationPreference> update(
    NotificationPreference preferences,
  ) async {
    final uid = AuthController.instance.currentUser?.uid;
    await cache(preferences);
    if (uid == null) return preferences;
    final saved = await ServerpodClient().client.notification.updatePreferences(
      uid,
      preferences,
    );
    await cache(saved);
    return saved;
  }

  Future<void> cache(NotificationPreference preferences) async {
    final uid = AuthController.instance.currentUser?.uid;
    if (uid == null) return;
    await _storage.write(_cachePrefix + uid, {
      'trackOrderNotifications': preferences.trackOrderNotifications,
      'couponNotifications': preferences.couponNotifications,
      'offerNotifications': preferences.offerNotifications,
      'announcementNotifications': preferences.announcementNotifications,
      'importantAlerts': preferences.importantAlerts,
      'updatedAt': preferences.updatedAt?.toIso8601String(),
    });
  }

  static NotificationPreference defaultPreference() {
    return NotificationPreference(
      trackOrderNotifications: true,
      couponNotifications: true,
      offerNotifications: true,
      announcementNotifications: true,
      importantAlerts: true,
    );
  }
}
