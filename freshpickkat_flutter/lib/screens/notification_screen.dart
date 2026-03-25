import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  void _openProduct(AppNotificationItem notification) {
    final product = notification.product;
    if (product == null) return;

    Get.to(
      () => ProductDetailScreen(
        product: product,
      ),
    );
  }

  String _formatTimestamp(DateTime value) {
    final now = DateTime.now();
    final difference = now.difference(value);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} min ago';
    if (difference.inDays < 1) return '${difference.inHours} hr ago';
    return '${difference.inDays} day ago';
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = NotificationController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(() {
        final notifications = notificationController.notifications;
        if (notifications.isEmpty) {
          return Center(
            child: Text(
              'No notifications yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final offerTheme =
            Theme.of(context).extension<AppOfferTheme>() ??
            AppOfferTheme.fallback(Theme.of(context).brightness);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final hasProduct = notification.product != null;

            return Material(
              color: offerTheme.badgeSoft,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: hasProduct ? () => _openProduct(notification) : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: offerTheme.badge,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: offerTheme.onBadge,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(
                                  _formatTimestamp(notification.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.62),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (hasProduct) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Tap to open product',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
