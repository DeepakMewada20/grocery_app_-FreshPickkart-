import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

import '../widgets/network_error_widget.dart';

class FreeDeliveryScreen extends StatefulWidget {
  const FreeDeliveryScreen({super.key});

  @override
  State<FreeDeliveryScreen> createState() => _FreeDeliveryScreenState();
}

class _FreeDeliveryScreenState extends State<FreeDeliveryScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminFreeDeliveryController _controller =
      AdminFreeDeliveryController.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRuleDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Rule'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.loadDeliveryData(force: true),
          );
        }

        if (_controller.isLoading.value &&
            _controller.deliveryConfig.value == null &&
            _controller.deliveryRules.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadDeliveryData(force: true),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DeliveryConfigCard(
                config: _controller.deliveryConfig.value,
                onEdit: _showConfigDialog,
              ),
              const SizedBox(height: 16),
              Text(
                'Special Rules',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_controller.deliveryRules.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No special delivery rules configured'),
                  ),
                ),
              ..._controller.deliveryRules.map(
                (rule) => _DeliveryRuleCard(
                  rule: rule,
                  onToggle: (isActive) => _controller.toggleDeliveryRule(
                    rule.ruleId ?? '',
                    isActive,
                  ),
                  onEdit: () => _showRuleDialog(rule: rule),
                  onDelete: () => _deleteRule(rule),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showConfigDialog() {
    final config = _controller.deliveryConfig.value;
    if (config == null) return;
    showDialog(
      context: context,
      builder: (context) => _DeliveryConfigDialog(
        config: config,
        onSave: (updatedConfig) => _controller.saveDeliveryConfig(updatedConfig),
      ),
    );
  }

  void _showRuleDialog({DeliveryRule? rule}) {
    showDialog(
      context: context,
      builder: (context) => _DeliveryRuleDialog(
        rule: rule,
        onSave: (value) {
          if (rule == null) {
            return _controller.createDeliveryRule(value);
          }
          return _controller.updateDeliveryRule(value);
        },
      ),
    );
  }

  void _deleteRule(DeliveryRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rule'),
        content: Text('Delete "${rule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _controller.deleteDeliveryRule(rule.ruleId ?? '');
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DeliveryConfigCard extends StatelessWidget {
  const _DeliveryConfigCard({
    required this.config,
    required this.onEdit,
  });

  final DeliveryConfig? config;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: config == null
            ? const Text('Delivery config unavailable')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Base Delivery Setup',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Base fee: ₹${config!.baseDeliveryFee.toStringAsFixed(0)}'),
                  Text(
                    'Free threshold: ${config!.freeDeliveryThreshold != null ? '₹${config!.freeDeliveryThreshold!.toStringAsFixed(0)}' : 'Not set'}',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Slabs',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...config!.slabs.map(
                    (slab) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '₹${slab.minOrderAmount.toStringAsFixed(0)} - ₹${slab.maxOrderAmount.toStringAsFixed(0)}  ->  ₹${slab.fee.toStringAsFixed(0)}',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DeliveryRuleCard extends StatelessWidget {
  const _DeliveryRuleCard({
    required this.rule,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final DeliveryRule rule;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(rule.name),
        subtitle: Text(
          'Fee ₹${rule.deliveryFee.toStringAsFixed(0)} • Priority ${rule.priority} • ${rule.targetUserType ?? 'all users'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'toggle') onToggle(!rule.isActive);
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'toggle', child: Text('Toggle Active')),
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}

class _DeliveryConfigDialog extends StatefulWidget {
  const _DeliveryConfigDialog({
    required this.config,
    required this.onSave,
  });

  final DeliveryConfig config;
  final Future<bool> Function(DeliveryConfig) onSave;

  @override
  State<_DeliveryConfigDialog> createState() => _DeliveryConfigDialogState();
}

class _DeliveryConfigDialogState extends State<_DeliveryConfigDialog> {
  late final TextEditingController _baseFeeController;
  late final TextEditingController _freeThresholdController;
  late final List<_DeliverySlabDraft> _slabs;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _baseFeeController = TextEditingController(
      text: widget.config.baseDeliveryFee.toStringAsFixed(0),
    );
    _freeThresholdController = TextEditingController(
      text: widget.config.freeDeliveryThreshold?.toStringAsFixed(0) ?? '',
    );
    _slabs = widget.config.slabs
        .map(
          (slab) => _DeliverySlabDraft(
            minCtrl: TextEditingController(
              text: slab.minOrderAmount.toStringAsFixed(0),
            ),
            maxCtrl: TextEditingController(
              text: slab.maxOrderAmount.toStringAsFixed(0),
            ),
            feeCtrl: TextEditingController(text: slab.fee.toStringAsFixed(0)),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _baseFeeController.dispose();
    _freeThresholdController.dispose();
    for (final slab in _slabs) {
      slab.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delivery Configuration'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _baseFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Base delivery fee'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _freeThresholdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Free delivery threshold',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Delivery Slabs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _slabs.add(
                          _DeliverySlabDraft(
                            minCtrl: TextEditingController(),
                            maxCtrl: TextEditingController(),
                            feeCtrl: TextEditingController(),
                          ),
                        );
                      });
                    },
                    child: const Text('Add Slab'),
                  ),
                ],
              ),
              ..._slabs.map(
                (slab) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: slab.minCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Min'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: slab.maxCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Max'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: slab.feeCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Fee'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final slabs = _slabs
        .map(
          (draft) => DeliverySlab(
            minOrderAmount: double.tryParse(draft.minCtrl.text.trim()) ?? 0,
            maxOrderAmount: double.tryParse(draft.maxCtrl.text.trim()) ?? 0,
            fee: double.tryParse(draft.feeCtrl.text.trim()) ?? 0,
          ),
        )
        .toList();

    final updated = widget.config.copyWith(
      baseDeliveryFee: double.tryParse(_baseFeeController.text.trim()) ?? 0,
      freeDeliveryThreshold: double.tryParse(
        _freeThresholdController.text.trim(),
      ),
      slabs: slabs,
      updatedAt: DateTime.now(),
    );

    setState(() => _isSaving = true);
    try {
      final result = await widget.onSave(updated);
      if (result && mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _DeliveryRuleDialog extends StatefulWidget {
  const _DeliveryRuleDialog({
    required this.onSave,
    this.rule,
  });

  final DeliveryRule? rule;
  final Future<bool> Function(DeliveryRule) onSave;

  @override
  State<_DeliveryRuleDialog> createState() => _DeliveryRuleDialogState();
}

class _DeliveryRuleDialogState extends State<_DeliveryRuleDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _feeController;
  late final TextEditingController _priorityController;
  late String _ruleType;
  late String _targetUserType;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _nameController = TextEditingController(text: rule?.name ?? '');
    _descriptionController = TextEditingController(text: rule?.description ?? '');
    _feeController = TextEditingController(
      text: rule?.deliveryFee.toStringAsFixed(0) ?? '0',
    );
    _priorityController = TextEditingController(
      text: rule?.priority.toString() ?? '1',
    );
    _ruleType = rule?.ruleType ?? 'special_event';
    _targetUserType = rule?.targetUserType ?? 'all';
    _startDate = rule?.startDate ?? DateTime.now();
    _endDate = rule?.endDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _feeController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rule == null ? 'Add Delivery Rule' : 'Edit Delivery Rule'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Rule name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _ruleType,
                decoration: const InputDecoration(labelText: 'Rule type'),
                items: const [
                  DropdownMenuItem(
                    value: 'special_event',
                    child: Text('Special Event'),
                  ),
                  DropdownMenuItem(
                    value: 'user_rule',
                    child: Text('User Rule'),
                  ),
                ],
                onChanged: (value) => setState(() => _ruleType = value ?? 'special_event'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _targetUserType,
                decoration: const InputDecoration(labelText: 'Target user'),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All users')),
                  DropdownMenuItem(value: 'new_user', child: Text('New users')),
                ],
                onChanged: (value) => setState(() => _targetUserType = value ?? 'all'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Delivery fee'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priorityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        'Start: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(
                        'End: ${_endDate.day}/${_endDate.month}/${_endDate.year}',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final rule = DeliveryRule(
      ruleId: widget.rule?.ruleId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      ruleType: _ruleType,
      deliveryFee: double.tryParse(_feeController.text.trim()) ?? 0,
      priority: int.tryParse(_priorityController.text.trim()) ?? 1,
      targetUserType: _targetUserType,
      isActive: widget.rule?.isActive ?? true,
      startDate: _startDate,
      endDate: _endDate,
      createdAt: widget.rule?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSaving = true);
    try {
      final result = await widget.onSave(rule);
      if (result && mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }
}

class _DeliverySlabDraft {
  _DeliverySlabDraft({
    required this.minCtrl,
    required this.maxCtrl,
    required this.feeCtrl,
  });

  final TextEditingController minCtrl;
  final TextEditingController maxCtrl;
  final TextEditingController feeCtrl;

  void dispose() {
    minCtrl.dispose();
    maxCtrl.dispose();
    feeCtrl.dispose();
  }
}
