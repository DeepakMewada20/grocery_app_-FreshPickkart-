import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_notification_preference_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  late final AdminNotificationPreferenceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AdminNotificationPreferenceController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: Text('Notification Preferences')),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.preferences.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = _controller.error.value;
        if (error != null && _controller.preferences.isEmpty) {
          return AdminStateView.error(
            message: error,
            onRetry: _controller.load,
          );
        }
        final grouped = _controller.grouped();
        if (grouped.isEmpty) {
          return AdminStateView.empty(
            title: 'No preferences found',
            message: 'Admin notification settings will appear here.',
            onRefresh: _controller.load,
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.load,
          child: ListView(
            padding: AdminResponsive.pagePadding(
              context,
            ).copyWith(bottom: AdminResponsive.bottomInset(context)),
            children: [
              AdminResponsive.constrainContent(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Alerts',
                      style: AdminTextStyles.screenTitle(context),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose which operational alerts this admin receives.',
                      style: AdminTextStyles.caption(context),
                    ),
                    const SizedBox(height: 18),
                    for (final entry in grouped.entries) ...[
                      _PreferenceGroup(
                        title: entry.key,
                        items: entry.value,
                        onChanged: _updatePreference,
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _updatePreference(
    AdminNotificationPreference preference, {
    bool? pushEnabled,
    bool? soundEnabled,
  }) async {
    try {
      await _controller.updatePreference(
        preference: preference,
        pushEnabled: pushEnabled,
        soundEnabled: soundEnabled,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.cleanError(e))));
    }
  }
}

class _PreferenceGroup extends StatelessWidget {
  const _PreferenceGroup({
    required this.title,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final List<AdminNotificationPreference> items;
  final Future<void> Function(
    AdminNotificationPreference preference, {
    bool? pushEnabled,
    bool? soundEnabled,
  })
  onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AdminTextStyles.sectionTitle(context)),
            const SizedBox(height: 8),
            for (final item in items)
              _PreferenceTile(preference: item, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({required this.preference, required this.onChanged});

  final AdminNotificationPreference preference;
  final Future<void> Function(
    AdminNotificationPreference preference, {
    bool? pushEnabled,
    bool? soundEnabled,
  })
  onChanged;

  @override
  Widget build(BuildContext context) {
    final locked = preference.critical == true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            locked ? Icons.lock_outline : Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              preference.title.toString(),
              style: AdminTextStyles.body(context),
            ),
          ),
          _SwitchLabel(
            label: 'Push',
            value: locked ? true : preference.pushEnabled == true,
            locked: locked,
            onChanged: (value) => onChanged(preference, pushEnabled: value),
          ),
          const SizedBox(width: 8),
          _SwitchLabel(
            label: 'Sound',
            value: locked ? true : preference.soundEnabled == true,
            locked: locked,
            onChanged: (value) => onChanged(preference, soundEnabled: value),
          ),
        ],
      ),
    );
  }
}

class _SwitchLabel extends StatelessWidget {
  const _SwitchLabel({
    required this.label,
    required this.value,
    required this.locked,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool locked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AdminTextStyles.caption(context)),
        Switch(value: value, onChanged: locked ? null : onChanged),
      ],
    );
  }
}
