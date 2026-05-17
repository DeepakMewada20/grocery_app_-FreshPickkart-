import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_broadcast_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class BroadcastsScreen extends StatefulWidget {
  const BroadcastsScreen({super.key});

  @override
  State<BroadcastsScreen> createState() => _BroadcastsScreenState();
}

class _BroadcastsScreenState extends State<BroadcastsScreen> {
  late final AdminBroadcastController _controller;
  late final AdminCouponController _couponController;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AdminBroadcastController());
    _couponController = Get.isRegistered<AdminCouponController>()
        ? AdminCouponController.instance
        : Get.put(AdminCouponController());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const AdminAppBar(
          title: Text('Broadcasts'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Create Announcement'),
              Tab(text: 'Notification History'),
              Tab(text: 'Scheduled Notifications'),
              Tab(text: 'Drafts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CreateBroadcastTab(
              controller: _controller,
              couponController: _couponController,
            ),
            _BroadcastListTab(
              controller: _controller,
              items: _controller.history,
              emptyTitle: 'No sent notifications',
              onRefresh: _controller.loadHistory,
              searchCtrl: _searchCtrl,
            ),
            _BroadcastListTab(
              controller: _controller,
              items: _controller.scheduled,
              emptyTitle: 'No scheduled notifications',
              onRefresh: _controller.loadScheduled,
              searchCtrl: _searchCtrl,
            ),
            _BroadcastListTab(
              controller: _controller,
              items: _controller.drafts,
              emptyTitle: 'No drafts',
              onRefresh: _controller.loadDrafts,
              searchCtrl: _searchCtrl,
              draftActions: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateBroadcastTab extends StatefulWidget {
  const _CreateBroadcastTab({
    required this.controller,
    required this.couponController,
  });

  final AdminBroadcastController controller;
  final AdminCouponController couponController;

  @override
  State<_CreateBroadcastTab> createState() => _CreateBroadcastTabState();
}

class _CreateBroadcastTabState extends State<_CreateBroadcastTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _specificUsersCtrl = TextEditingController();
  String? _imageUrl;
  String _announcementType = 'general';
  String _targetAudience = 'all_users';
  String _priority = 'normal';
  String _urgency = 'low';
  String _orderBucket = '1_3';
  String? _couponCode;
  DateTime? _scheduledAt;
  bool _isUploading = false;

  static const _types = {
    'promotion': 'Promotion',
    'delivery_update': 'Delivery Update',
    'service_update': 'Service Update',
    'system_alert': 'System Alert',
    'offer_coupon': 'Offer/Coupon',
    'festival_greeting': 'Festival Greeting',
    'order_related': 'Order Related',
    'general': 'General',
  };

  static const _audiences = {
    'all_users': 'All Users',
    'specific_users': 'Specific Users',
    'users_by_city': 'Users by city',
    'premium_users': 'Premium users',
    'active_users': 'Active users',
    'inactive_users': 'Inactive users',
    'users_by_order_history': 'Users by order history',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    _specificUsersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: widget.controller.refreshAll,
        child: ListView(
          padding: AdminResponsive.pagePadding(context),
          children: [
            AdminResponsive.constrainContent(
              context: context,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Announcement',
                      style: AdminTextStyles.screenTitle(context),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bodyCtrl,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    _ImagePickerRow(
                      imageUrl: _imageUrl,
                      isUploading: _isUploading,
                      onPick: _pickImage,
                      onClear: () => setState(() => _imageUrl = null),
                    ),
                    const SizedBox(height: 12),
                    _Dropdown(
                      label: 'Announcement Type',
                      value: _announcementType,
                      values: _types,
                      onChanged: (value) =>
                          setState(() => _announcementType = value),
                    ),
                    const SizedBox(height: 12),
                    _Dropdown(
                      label: 'Target Audience',
                      value: _targetAudience,
                      values: _audiences,
                      onChanged: (value) =>
                          setState(() => _targetAudience = value),
                    ),
                    const SizedBox(height: 12),
                    _Dropdown(
                      label: 'Priority',
                      value: _priority,
                      values: const {
                        'normal': 'Normal',
                        'low': 'Low',
                        'high': 'High',
                        'urgent': 'Urgent',
                      },
                      onChanged: (value) => setState(() => _priority = value),
                    ),
                    const SizedBox(height: 12),
                    _conditionalFields(),
                    const SizedBox(height: 12),
                    _ScheduleRow(
                      scheduledAt: _scheduledAt,
                      onPick: _pickSchedule,
                      onClear: () => setState(() => _scheduledAt = null),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: widget.controller.isSaving.value
                              ? null
                              : () => _submit(sendNow: true),
                          icon: const Icon(Icons.send_outlined),
                          label: Text(
                            _scheduledAt == null ? 'Queue Send' : 'Schedule',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: widget.controller.isSaving.value
                              ? null
                              : () => _submit(sendNow: false),
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save Draft'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conditionalFields() {
    if (_announcementType == 'offer_coupon') {
      return Obx(() {
        final coupons = widget.couponController.coupons;
        if (widget.couponController.isLoading.value && coupons.isEmpty) {
          return const LinearProgressIndicator();
        }
        return DropdownButtonFormField<String>(
          initialValue: _couponCode,
          decoration: const InputDecoration(
            labelText: 'Coupon',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final coupon in coupons)
              DropdownMenuItem(
                value: coupon.code,
                child: Text('${coupon.code} - ${coupon.description}'),
              ),
          ],
          onChanged: (value) => setState(() => _couponCode = value),
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        );
      });
    }
    if (_announcementType == 'festival_greeting') {
      return _Dropdown(
        label: 'Festival Template',
        value: _bodyCtrl.text.trim().isEmpty ? 'diwali' : 'custom',
        values: const {
          'diwali': 'Diwali Greeting',
          'pongal': 'Pongal Greeting',
          'eid': 'Eid Greeting',
          'custom': 'Custom',
        },
        onChanged: (value) {
          setState(() {
            if (value != 'custom') {
              _titleCtrl.text =
                  '${value[0].toUpperCase()}${value.substring(1)} Wishes';
              _bodyCtrl.text =
                  'Fresh greetings and special picks are waiting for you.';
            }
          });
        },
      );
    }
    if (_announcementType == 'delivery_update') {
      return Column(
        children: [
          TextFormField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _areaCtrl,
            decoration: const InputDecoration(
              labelText: 'Affected Area',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    }
    if (_announcementType == 'system_alert') {
      return _Dropdown(
        label: 'Urgency',
        value: _urgency,
        values: const {'low': 'Low', 'high': 'High', 'urgent': 'Urgent'},
        onChanged: (value) => setState(() => _urgency = value),
      );
    }
    if (_targetAudience == 'users_by_city') {
      return TextFormField(
        controller: _cityCtrl,
        decoration: const InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(),
        ),
        validator: _required,
      );
    }
    if (_targetAudience == 'users_by_order_history') {
      return _Dropdown(
        label: 'Order History',
        value: _orderBucket,
        values: const {
          'no_orders': 'No orders',
          '1_3': '1-3 delivered orders',
          '4_9': '4-9 delivered orders',
          '10_plus': '10+ delivered orders',
        },
        onChanged: (value) => setState(() => _orderBucket = value),
      );
    }
    if (_targetAudience == 'specific_users') {
      return TextFormField(
        controller: _specificUsersCtrl,
        decoration: const InputDecoration(
          labelText: 'User IDs or Firebase UIDs',
          hintText: 'Comma-separated values',
          border: OutlineInputBorder(),
        ),
        validator: _required,
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _pickImage() async {
    final source = await AdminImageUploadService.pickImageSource(context);
    if (source == null) return;
    setState(() => _isUploading = true);
    try {
      final url = await AdminImageUploadService.pickCropAndUploadImage(
        source: source,
        folder: 'broadcasts',
        toolbarTitle: 'Crop Broadcast Banner',
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      );
      if (url != null) setState(() => _imageUrl = url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.controller.cleanError(e))));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _scheduledAt ?? DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime.now()),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit({required bool sendNow}) async {
    if (!_formKey.currentState!.validate()) return;
    final request = BroadcastRequest(
      title: _titleCtrl.text.trim(),
      body: _bodyCtrl.text.trim(),
      imageUrl: _imageUrl,
      announcementType: _announcementType,
      targetAudience: _targetAudience,
      priority: _priority,
      scheduledAt: _scheduledAt,
      couponCode: _couponCode,
      city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
      affectedArea: _areaCtrl.text.trim().isEmpty
          ? null
          : _areaCtrl.text.trim(),
      urgency: _announcementType == 'system_alert' ? _urgency : null,
      entityType: _announcementType,
      data: {
        if (_targetAudience == 'users_by_order_history')
          'orderBucket': _orderBucket,
        if (_targetAudience == 'specific_users')
          'firebaseUids': _specificUsersCtrl.text.trim(),
      },
    );
    try {
      if (sendNow) {
        await widget.controller.create(request);
      } else {
        await widget.controller.saveDraft(request);
      }
      await widget.controller.refreshAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sendNow ? 'Broadcast queued' : 'Draft saved')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _imageUrl = null;
        _scheduledAt = null;
        _couponCode = null;
        _announcementType = 'general';
        _targetAudience = 'all_users';
        _priority = 'normal';
      });
      _titleCtrl.clear();
      _bodyCtrl.clear();
      _cityCtrl.clear();
      _areaCtrl.clear();
      _specificUsersCtrl.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.controller.cleanError(e))));
    }
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }
}

class _BroadcastListTab extends StatelessWidget {
  const _BroadcastListTab({
    required this.controller,
    required this.items,
    required this.emptyTitle,
    required this.onRefresh,
    required this.searchCtrl,
    this.draftActions = false,
  });

  final AdminBroadcastController controller;
  final RxList<BroadcastSummary> items;
  final String emptyTitle;
  final Future<void> Function() onRefresh;
  final TextEditingController searchCtrl;
  final bool draftActions;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final error = controller.error.value;
      if (error != null && items.isEmpty) {
        return AdminStateView.error(message: error, onRetry: onRefresh);
      }
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: AdminResponsive.pagePadding(context),
          children: [
            AdminResponsive.constrainContent(
              context: context,
              child: Column(
                children: [
                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: 'Apply filters',
                        onPressed: () {
                          controller.searchQuery = searchCtrl.text;
                          onRefresh();
                        },
                        icon: const Icon(Icons.filter_list),
                      ),
                      labelText: 'Search broadcasts',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      controller.searchQuery = value;
                      onRefresh();
                    },
                  ),
                  const SizedBox(height: 14),
                  if (items.isEmpty)
                    SizedBox(
                      height: 320,
                      child: AdminStateView.empty(
                        title: emptyTitle,
                        message: 'Broadcasts will appear here after activity.',
                        onRefresh: onRefresh,
                      ),
                    )
                  else
                    for (final item in items)
                      _BroadcastCard(
                        item: item,
                        draftActions: draftActions,
                        onSend: () => _confirmSend(context, item),
                        onDelete: () => _confirmDelete(context, item),
                      ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _confirmSend(BuildContext context, BroadcastSummary item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send draft?'),
        content: Text(item.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await controller.sendDraft(item.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Draft queued')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.cleanError(e))));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BroadcastSummary item,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete draft?'),
        content: Text(item.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await controller.deleteDraft(item.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Draft deleted')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.cleanError(e))));
    }
  }
}

class _BroadcastCard extends StatelessWidget {
  const _BroadcastCard({
    required this.item,
    required this.draftActions,
    required this.onSend,
    required this.onDelete,
  });

  final BroadcastSummary item;
  final bool draftActions;
  final VoidCallback onSend;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: AdminTextStyles.cardTitle(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusChip(status: item.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AdminTextStyles.body(context),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(item.announcementType)),
                Chip(label: Text(item.targetAudience)),
                Chip(label: Text(item.priority)),
                if (item.scheduledAt != null)
                  Chip(
                    label: Text('Scheduled ${_dateLabel(item.scheduledAt!)}'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Recipients ${item.recipientCount} | Success ${item.successCount} | Failed ${item.failureCount}',
              style: AdminTextStyles.caption(context),
            ),
            if (item.lastError != null && item.lastError!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.lastError!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.caption(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (draftActions) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onSend,
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Send'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final Map<String, String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final entry in values.entries)
          DropdownMenuItem(value: entry.key, child: Text(entry.value)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  const _ImagePickerRow({
    required this.imageUrl,
    required this.isUploading,
    required this.onPick,
    required this.onClear,
  });

  final String? imageUrl;
  final bool isUploading;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isUploading ? null : onPick,
            icon: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image_outlined),
            label: Text(imageUrl == null ? 'Add banner' : 'Change banner'),
          ),
        ),
        if (imageUrl != null) ...[
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Remove banner',
            onPressed: onClear,
            icon: const Icon(Icons.close),
          ),
        ],
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.scheduledAt,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? scheduledAt;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.schedule_outlined),
            label: Text(
              scheduledAt == null
                  ? 'Schedule date/time'
                  : _dateLabel(scheduledAt!),
            ),
          ),
        ),
        if (scheduledAt != null) ...[
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Clear schedule',
            onPressed: onClear,
            icon: const Icon(Icons.close),
          ),
        ],
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(status), visualDensity: VisualDensity.compact);
  }
}

String _dateLabel(DateTime value) {
  final local = value.toLocal().toString();
  return local.length > 16 ? local.substring(0, 16) : local;
}
