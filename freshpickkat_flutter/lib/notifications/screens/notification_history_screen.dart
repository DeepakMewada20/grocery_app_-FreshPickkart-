import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/notifications/controllers/notification_controller.dart';
import 'package:get/get.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final _controller = NotificationController.instance;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.refreshHistory();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 240) {
        _controller.loadMoreHistory();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification History')),
      body: SafeArea(
        child: Obx(() {
        final items = _controller.history;
        if (_controller.isLoadingHistory.value && items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (items.isEmpty) {
          return const Center(child: Text('No notifications yet'));
        }
        final today = <NotificationHistoryItem>[];
        final earlier = <NotificationHistoryItem>[];
        final now = DateTime.now();
        for (final item in items) {
          final local = item.createdAt.toLocal();
          final sameDay =
              local.year == now.year &&
              local.month == now.month &&
              local.day == now.day;
          (sameDay ? today : earlier).add(item);
        }
        return RefreshIndicator(
          onRefresh: _controller.refreshHistory,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (today.isNotEmpty) _Group(title: 'Today', items: today),
              if (earlier.isNotEmpty) _Group(title: 'Earlier', items: earlier),
              if (_controller.isLoadingHistory.value)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      }),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.items});

  final String title;
  final List<NotificationHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final item in items) _NotificationTile(item: item),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;
    final cs = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(item.campaignId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: cs.error,
        child: Icon(Icons.delete_outline, color: cs.onError),
      ),
      onDismissed: (_) => controller.delete(item),
      child: ListTile(
        leading: Icon(
          item.isRead ? Icons.notifications_none : Icons.notifications_active,
          color: item.isRead ? cs.onSurfaceVariant : cs.primary,
        ),
        title: Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Text(
          item.body,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'read') controller.markRead(item);
            if (value == 'delete') controller.delete(item);
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'read', child: Text('Mark as read')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => controller.openNotification(item),
      ),
    );
  }
}
