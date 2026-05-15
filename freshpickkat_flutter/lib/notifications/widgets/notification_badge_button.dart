import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/notifications/controllers/notification_controller.dart';
import 'package:freshpickkat_flutter/notifications/screens/notification_history_screen.dart';
import 'package:get/get.dart';

class NotificationBadgeButton extends StatelessWidget {
  const NotificationBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;
    return Obx(
      () => IconButton(
        tooltip: 'Notifications',
        icon: Badge(
          isLabelVisible: controller.unreadCount.value > 0,
          label: Text('${controller.unreadCount.value}'),
          child: const Icon(Icons.notifications_outlined),
        ),
        onPressed: () => Get.to(() => const NotificationHistoryScreen()),
      ),
    );
  }
}
