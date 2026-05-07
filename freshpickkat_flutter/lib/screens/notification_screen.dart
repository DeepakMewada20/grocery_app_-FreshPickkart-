import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
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
          return SingleChildScrollView(
            padding: AppResponsive.pagePadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.sizeOf(context).height -
                    kToolbarHeight -
                    MediaQuery.paddingOf(context).vertical -
                    48.h,
              ),
              child: Center(
                child: Text(
                  'No notifications yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          );
        }

        final offerTheme =
            Theme.of(context).extension<AppOfferTheme>() ??
            AppOfferTheme.fallback(Theme.of(context).brightness);

        return ListView.separated(
          padding: AppResponsive.pagePadding(context).copyWith(
            bottom: 24.h + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: notifications.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final hasProduct = notification.product != null;

            return AppResponsive.constrainContent(
              context: context,
              child: Material(
                color: offerTheme.badgeSoft,
                borderRadius: BorderRadius.circular(18.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18.r),
                  onTap: hasProduct ? () => _openProduct(notification) : null,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46.r,
                          height: 46.r,
                          decoration: BoxDecoration(
                            color: offerTheme.badge,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: offerTheme.onBadge,
                            size: 22.r,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  AutoSizeText(
                                    _formatTimestamp(notification.createdAt),
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.62),
                                        ),
                                    minFontSize: 9,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                notification.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (hasProduct) ...[
                                SizedBox(height: 10.h),
                                Text(
                                  'Tap to open product',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
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
              ),
            );
          },
        );
      }),
    );
  }
}
