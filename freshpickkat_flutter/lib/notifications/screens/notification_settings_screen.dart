import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/notifications/controllers/notification_controller.dart';
import 'package:freshpickkat_flutter/notifications/screens/notification_history_screen.dart';
import 'package:get/get.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'History',
              icon: Badge(
                isLabelVisible: controller.unreadCount.value > 0,
                label: Text('${controller.unreadCount.value}'),
                child: const Icon(Icons.notifications_outlined),
              ),
              onPressed: () => Get.to(() => const NotificationHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final prefs = controller.preferences.value;
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            _Section(
              title: 'ORDER TRACKING',
              children: [
                SwitchListTile(
                  title: const Text('Track Your Order Updates'),
                  value: prefs.trackOrderNotifications,
                  onChanged: (value) => controller.updatePreference(
                    trackOrderNotifications: value,
                  ),
                ),
              ],
            ),
            _Section(
              title: 'OFFERS & DEALS',
              children: [
                SwitchListTile(
                  title: const Text('Coupons & Discounts'),
                  value: prefs.couponNotifications,
                  onChanged: (value) => controller.updatePreference(
                    couponNotifications: value,
                  ),
                ),
                SwitchListTile(
                  title: const Text('BOGO Offers'),
                  value: prefs.offerNotifications,
                  onChanged: (value) => controller.updatePreference(
                    offerNotifications: value,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Combo Deals'),
                  value: prefs.offerNotifications,
                  onChanged: (value) => controller.updatePreference(
                    offerNotifications: value,
                  ),
                ),
              ],
            ),
            _Section(
              title: 'ANNOUNCEMENTS',
              children: [
                SwitchListTile(
                  title: const Text('Delivery Updates'),
                  value: prefs.announcementNotifications,
                  onChanged: (value) => controller.updatePreference(
                    announcementNotifications: value,
                  ),
                ),
              ],
            ),
            _Section(
              title: 'APP',
              children: [
                SwitchListTile(
                  title: const Text('Important Alerts'),
                  value: prefs.importantAlerts,
                  onChanged: (value) => controller.updatePreference(
                    importantAlerts: value,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
