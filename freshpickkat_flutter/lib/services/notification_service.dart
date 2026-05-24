import '../controller/notification_controller.dart';

class NotificationService {
  static Future<void> init() => NotificationController.instance.init();

  static Future<void> openPendingTrackingLaunchIfAny() =>
      NotificationController.instance.openPendingTrackingLaunchIfAny();
}
