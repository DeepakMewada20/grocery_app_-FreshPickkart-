import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
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
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRuleDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Rule'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search rules...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.networkController.hasError.value) {
                return NetworkErrorWidget(
                  onRetry: () => _controller.networkController.retryLastRequest(),
                );
              }

              if (_controller.isLoading.value && _controller.freeDeliveryRules.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final rules = _controller.freeDeliveryRules
                  .where((r) => r.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (rules.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No free delivery rules found',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return _FreeDeliveryCard(
                    rule: rule,
                    onToggle: (isActive) => _controller.toggleFreeDeliveryRule(
                      rule.ruleId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditRuleDialog(rule),
                    onDelete: () => _showDeleteConfirmation(rule),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => _FreeDeliveryDialog(
        onSave: (rule) async {
          await _controller.createFreeDeliveryRule(rule);
        },
      ),
    );
  }

  void _showEditRuleDialog(FreeDeliveryRule rule) {
    showDialog(
      context: context,
      builder: (context) => _FreeDeliveryDialog(
        rule: rule,
        onSave: (updated) async {
          await _controller.updateFreeDeliveryRule(updated);
        },
      ),
    );
  }

  void _showDeleteConfirmation(FreeDeliveryRule rule) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete Rule'),
            content: Text('Are you sure you want to delete "${rule.name}"?'),
            actions: [
              TextButton(
                onPressed: isDeleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        setDialogState(() => isDeleting = true);
                        await _controller.deleteFreeDeliveryRule(
                          rule.ruleId ?? '',
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Rule deleted')),
                        );
                      },
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FreeDeliveryCard extends StatelessWidget {
  final FreeDeliveryRule rule;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FreeDeliveryCard({
    required this.rule,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = rule.startDate.isBefore(now) && rule.endDate.isAfter(now);

    String ruleDescription = '';
    switch (rule.ruleType) {
      case 'min_order_amount':
        ruleDescription =
            'Orders above ₹${rule.minOrderAmount?.toStringAsFixed(0) ?? 0}';
        break;
      case 'min_items':
        ruleDescription = '${rule.minItemsCount ?? 0}+ items';
        break;
      case 'coupon':
        ruleDescription = 'With coupon: ${rule.couponCode ?? ''}';
        break;
      case 'user_specific':
        ruleDescription = 'User specific';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rule.isActive ? Colors.teal[100] : Colors.grey[300],
          child: Icon(
            Icons.local_shipping,
            color: rule.isActive ? Colors.teal : Colors.grey,
          ),
        ),
        title: Text(
          rule.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ruleDescription),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '₹${rule.deliveryFeeWaived.toStringAsFixed(0)} waived',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
                if (isValid) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(Icons.toggle_on),
                  SizedBox(width: 8),
                  Text('Toggle Active'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'toggle':
                onToggle(!rule.isActive);
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
        onTap: onEdit,
      ),
    );
  }
}

class _FreeDeliveryDialog extends StatefulWidget {
  final FreeDeliveryRule? rule;
  final Function(FreeDeliveryRule) onSave;

  const _FreeDeliveryDialog({this.rule, required this.onSave});

  @override
  State<_FreeDeliveryDialog> createState() => _FreeDeliveryDialogState();
}

class _FreeDeliveryDialogState extends State<_FreeDeliveryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _minItemsController = TextEditingController();
  final _couponCodeController = TextEditingController();
  final _deliveryFeeWaivedController = TextEditingController(text: '40');

  String _ruleType = 'min_order_amount';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  bool _isSubmitting = false;

  bool get isEditing => widget.rule != null;

  @override
  void initState() {
    super.initState();
    if (widget.rule != null) {
      _nameController.text = widget.rule!.name;
      _descriptionController.text = widget.rule!.description ?? '';
      _ruleType = widget.rule!.ruleType;
      _startDate = widget.rule!.startDate;
      _endDate = widget.rule!.endDate;
      _deliveryFeeWaivedController.text = widget.rule!.deliveryFeeWaived
          .toString();
      if (widget.rule!.minOrderAmount != null) {
        _minOrderController.text = widget.rule!.minOrderAmount.toString();
      }
      if (widget.rule!.minItemsCount != null) {
        _minItemsController.text = widget.rule!.minItemsCount.toString();
      }
      if (widget.rule!.couponCode != null) {
        _couponCodeController.text = widget.rule!.couponCode!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _minOrderController.dispose();
    _minItemsController.dispose();
    _couponCodeController.dispose();
    _deliveryFeeWaivedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generatedRuleName = _buildRuleName();
    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Free Delivery Rule' : 'Add Free Delivery Rule',
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rule Name',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        generatedRuleName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _ruleType,
                  decoration: const InputDecoration(labelText: 'Rule Type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'min_order_amount',
                      child: Text('Min Order Amount'),
                    ),
                    DropdownMenuItem(
                      value: 'min_items',
                      child: Text('Min Items Count'),
                    ),
                    DropdownMenuItem(
                      value: 'coupon',
                      child: Text('With Coupon Code'),
                    ),
                    DropdownMenuItem(
                      value: 'user_specific',
                      child: Text('User Specific'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _ruleType = v ?? 'min_order_amount'),
                ),
                const SizedBox(height: 16),
                if (_ruleType == 'min_order_amount')
                  TextFormField(
                    controller: _minOrderController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Min Order Amount (₹)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.trim().isEmpty == true) return 'Required';
                      if (double.tryParse(v!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                if (_ruleType == 'min_items')
                  TextFormField(
                    controller: _minItemsController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Min Items Count',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.trim().isEmpty == true) return 'Required';
                      if (int.tryParse(v!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                if (_ruleType == 'coupon')
                  TextFormField(
                    controller: _couponCodeController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Coupon Code'),
                    validator: (v) =>
                        v?.trim().isEmpty == true ? 'Required' : null,
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deliveryFeeWaivedController,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Fee Waived (₹)',
                    hintText:
                        'Enter amount to waive (e.g., 40 for full waiver)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v?.trim().isEmpty == true) return 'Required';
                    if (double.tryParse(v!) == null) return 'Invalid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(true),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('Start: ${_formatDate(_startDate)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(false),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('End: ${_formatDate(_endDate)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _save,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _buildRuleName() {
    switch (_ruleType) {
      case 'min_order_amount':
        final amount = double.tryParse(_minOrderController.text.trim());
        if (amount != null && amount > 0) {
          return 'Free Delivery on \u20b9${amount.toInt()}+';
        }
        return 'Free Delivery on Minimum Order';
      case 'min_items':
        final count = int.tryParse(_minItemsController.text.trim());
        if (count != null && count > 0) {
          return 'Free Delivery on $count+ Items';
        }
        return 'Free Delivery on Minimum Items';
      case 'coupon':
        final coupon = _couponCodeController.text.trim();
        if (coupon.isNotEmpty) {
          return 'Free Delivery with $coupon';
        }
        return 'Free Delivery with Coupon';
      case 'user_specific':
        return 'Free Delivery for Selected Users';
      default:
        return 'Free Delivery Rule';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    double? minOrderAmount;
    int? minItemsCount;
    String? couponCode;

    switch (_ruleType) {
      case 'min_order_amount':
        minOrderAmount = double.parse(_minOrderController.text);
        break;
      case 'min_items':
        minItemsCount = int.parse(_minItemsController.text);
        break;
      case 'coupon':
        couponCode = _couponCodeController.text.trim();
        break;
    }

    final rule = FreeDeliveryRule(
      ruleId: widget.rule?.ruleId,
      name: _buildRuleName(),
      description: widget.rule?.description,
      ruleType: _ruleType,
      minOrderAmount: minOrderAmount,
      minItemsCount: minItemsCount,
      couponCode: couponCode,
      isActive: widget.rule?.isActive ?? true,
      startDate: _startDate,
      endDate: _endDate,
      deliveryFeeWaived: double.parse(_deliveryFeeWaivedController.text),
      createdAt: widget.rule?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(rule);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
