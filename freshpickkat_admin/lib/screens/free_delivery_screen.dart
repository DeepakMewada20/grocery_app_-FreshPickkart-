import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/free_delivery_form_widget.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/product_selection_dialog.dart';

class FreeDeliveryScreen extends StatefulWidget {
  const FreeDeliveryScreen({super.key});

  @override
  State<FreeDeliveryScreen> createState() => _FreeDeliveryScreenState();
}

class _FreeDeliveryScreenState extends State<FreeDeliveryScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminFreeDeliveryController _controller =
      AdminFreeDeliveryController.instance;
  final AdminProductController _productController = AdminProductController.instance;

  List<Product> get _freeDeliveryProducts =>
      _productController.products.where((p) => p.isFreeDelivery).toList();

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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          child: AdminResponsive.constrainContent(
            context: context,
            child: ListView(
              padding: AdminResponsive.pagePadding(
                context,
              ).copyWith(bottom: AdminResponsive.bottomInset(context) + 78.h),
              children: [
                _DeliveryConfigCard(
                  config: _controller.deliveryConfig.value,
                  onEdit: _showConfigDialog,
                ),
                SizedBox(height: 16.h),
                FreeDeliveryPromotionSection(
                  freeDeliveryProducts: _freeDeliveryProducts,
                  onToggleProduct: _toggleProductFreeDelivery,
                  onAddFreeDeliveryProducts: _addFreeDeliveryProducts,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Special Rules',
                  style: AdminTextStyles.sectionTitle(context),
                ),
                SizedBox(height: 8.h),
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
          ),
        );
      }),
    );
  }

  Future<void> _toggleProductFreeDelivery(Product product, bool enabled) async {
    final productId = product.productId;
    if (productId == null || productId.isEmpty) return;
    final result = await _controller.setProductFreeDelivery(productId, enabled);
    if (!mounted) return;
    final shouldRetry = await _showConflictIfNeeded(result.conflict);
    if (shouldRetry == true) {
      final retry = await _controller.setProductFreeDelivery(
        productId,
        enabled,
        confirmDisableConflictingCombo: true,
        forceDisableBogo: true,
      );
      if (!mounted) return;
      _showMutationSnack(retry);
      if (retry.success) {
        _productController.products[_productController.products.indexWhere((p) => p.productId == productId)] = product.copyWith(isFreeDelivery: enabled);
      }
      return;
    }
    _showMutationSnack(result);
    if (result.success) {
      final index = _productController.products.indexWhere((p) => p.productId == productId);
      if (index != -1) {
        _productController.products[index] = product.copyWith(isFreeDelivery: enabled);
      }
    }
  }

  Future<bool?> _showConflictIfNeeded(OfferConflictResponse? conflict) {
    if (conflict == null || !conflict.hasConflict) return Future.value(false);
    return showDialog<bool>(
      context: context,
      builder: (context) => OfferConflictDialog(conflict: conflict),
    );
  }

  void _showMutationSnack(OfferMutationResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? (result.success ? 'Updated' : 'Update failed')),
        backgroundColor: result.success ? null : AdminAppTheme.getErrorColor(context),
      ),
    );
  }

  Future<void> _addFreeDeliveryProducts() async {
    final currentFreeProducts = _productController.products
        .where((p) => p.isFreeDelivery && p.productId != null)
        .toList();
    final initialSelections = currentFreeProducts
        .map((p) => ProductSelectionResult(product: p))
        .toList();
    final results = await ProductSelectionDialog.showMultiSelectBottomSheet(
      context: context,
      title: 'Select Free Delivery Products',
      initialSelections: initialSelections,
    );
    if (results == null) return;
    final oldIds = currentFreeProducts.map((p) => p.productId!).toSet();
    final newIds = results.map((r) => r.productId).toSet();
    for (final r in results) {
      if (oldIds.contains(r.productId)) continue;
      final product = _productController.products.firstWhereOrNull(
        (p) => p.productId == r.productId,
      );
      if (product != null) {
        await _toggleProductFreeDelivery(product, true);
      }
    }
    for (final p in currentFreeProducts) {
      if (!newIds.contains(p.productId)) {
        await _toggleProductFreeDelivery(p, false);
      }
    }
  }

  void _showConfigDialog() {
    final config = _controller.deliveryConfig.value;
    if (config == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AdminThemeTokens.transparent,
      builder: (context) => _DeliveryConfigBottomSheet(
        config: config,
        onSave: (updatedConfig) =>
            _controller.saveDeliveryConfig(updatedConfig),
      ),
    );
  }

  void _showRuleDialog({DeliveryRule? rule}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AdminThemeTokens.transparent,
      builder: (context) => _DeliveryRuleBottomSheet(
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
            child: Text(
              'Delete',
              style: TextStyle(color: AdminAppTheme.getErrorColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryConfigCard extends StatelessWidget {
  const _DeliveryConfigCard({required this.config, required this.onEdit});

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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Base fee: ₹${config!.baseDeliveryFee.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Free threshold: ${config!.freeDeliveryThreshold != null ? '₹${config!.freeDeliveryThreshold!.toStringAsFixed(2)}' : 'Not set'}',
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
                        slab.maxOrderAmount >= 999999
                            ? 'Above ₹${slab.minOrderAmount.toStringAsFixed(2)}  ->  ₹${slab.fee.toStringAsFixed(2)}'
                            : '₹${slab.minOrderAmount.toStringAsFixed(2)} - ₹${slab.maxOrderAmount.toStringAsFixed(2)}  ->  ₹${slab.fee.toStringAsFixed(2)}',
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
          'Fee ₹${rule.deliveryFee.toStringAsFixed(2)} • Priority ${rule.priority} • ${rule.targetUserType == 'specific_order' ? 'specific_order (${rule.targetOrderCount})' : (rule.targetUserType ?? 'all users')}',
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

class _DeliveryConfigBottomSheet extends StatefulWidget {
  const _DeliveryConfigBottomSheet({
    required this.config,
    required this.onSave,
  });

  final DeliveryConfig config;
  final Future<bool> Function(DeliveryConfig) onSave;

  @override
  State<_DeliveryConfigBottomSheet> createState() =>
      _DeliveryConfigBottomSheetState();
}

class _DeliveryConfigBottomSheetState
    extends State<_DeliveryConfigBottomSheet> {
  late final TextEditingController _baseFeeController;
  late final TextEditingController _freeThresholdController;
  late final List<_DeliverySlabDraft> _slabs;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _baseFeeController = TextEditingController(
      text: widget.config.baseDeliveryFee.toStringAsFixed(2),
    );
    _freeThresholdController = TextEditingController(
      text: widget.config.freeDeliveryThreshold?.toStringAsFixed(2) ?? '',
    );
    _slabs = widget.config.slabs
        .map(
          (slab) => _DeliverySlabDraft(
            minCtrl: TextEditingController(
              text: slab.minOrderAmount.toStringAsFixed(2),
            ),
            maxCtrl: TextEditingController(
              text: slab.maxOrderAmount >= 999999
                  ? ''
                  : slab.maxOrderAmount.toStringAsFixed(2),
            ),
            feeCtrl: TextEditingController(text: slab.fee.toStringAsFixed(2)),
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Delivery Configuration',
                    style: AdminTextStyles.sectionTitle(context),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _baseFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Base delivery fee (₹)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _freeThresholdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Free delivery threshold (₹)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Delivery Slabs',
                          style: AdminTextStyles.cardTitle(context),
                        ),
                      ),
                      FilledButton.tonalIcon(
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
                        icon: const Icon(Icons.add),
                        label: const Text('Add Slab'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (_slabs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No delivery slabs defined. Will use base fee.',
                      ),
                    ),
                  ..._slabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final slab = entry.value;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AdminThemeTokens.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AdminAppTheme.getBorderColor(context),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Slab ${index + 1}',
                                style: AdminTextStyles.body(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AdminAppTheme.getSuccessColor(context),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    slab.dispose();
                                    _slabs.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: AdminAppTheme.getErrorColor(context),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: slab.minCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Amount',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: slab.maxCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Max (Empty=Above)',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: slab.feeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Delivery Fee',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 24.h),
                  FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AdminThemeTokens.white,
                            ),
                          )
                        : const Text('Save Configuration'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final baseFeeText = _baseFeeController.text.trim();
    final thresholdText = _freeThresholdController.text.trim();
    final baseFee = double.tryParse(baseFeeText);
    final threshold = thresholdText.isEmpty ? null : double.tryParse(thresholdText);

    if (baseFee == null || baseFee < 0) {
      _showError('Base delivery fee must be a valid non-negative number.');
      return;
    }
    if (threshold != null && threshold <= 0) {
      _showError('Free delivery threshold must be greater than 0.');
      return;
    }

    for (final slab in _slabs) {
      final minVal = double.tryParse(slab.minCtrl.text.trim());
      final maxVal = slab.maxCtrl.text.trim().isEmpty
          ? 999999.0
          : double.tryParse(slab.maxCtrl.text.trim());
      final feeVal = double.tryParse(slab.feeCtrl.text.trim());

      if (minVal == null || minVal < 0) {
        _showError('Each slab must have a valid non-negative minimum amount.');
        return;
      }
      if (maxVal == null || maxVal <= 0) {
        _showError('Each slab must have a valid maximum amount greater than 0.');
        return;
      }
      if (feeVal == null || feeVal < 0) {
        _showError('Each slab must have a valid non-negative delivery fee.');
        return;
      }
      if (minVal > maxVal && maxVal != 999999) {
        _showError('Slab minimum amount cannot exceed the maximum amount.');
        return;
      }
    }

    final slabs = _slabs
        .map(
          (draft) => DeliverySlab(
            minOrderAmount: double.tryParse(draft.minCtrl.text.trim()) ?? 0,
            maxOrderAmount: draft.maxCtrl.text.trim().isEmpty
                ? 999999
                : double.tryParse(draft.maxCtrl.text.trim()) ?? 0,
            fee: double.tryParse(draft.feeCtrl.text.trim()) ?? 0,
          ),
        )
        .toList();

    final updated = widget.config.copyWith(
      baseDeliveryFee: baseFee,
      freeDeliveryThreshold: threshold,
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

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AdminAppTheme.getErrorColor(context)),
    );
  }
}

class _DeliveryRuleBottomSheet extends StatefulWidget {
  const _DeliveryRuleBottomSheet({required this.onSave, this.rule});

  final DeliveryRule? rule;
  final Future<bool> Function(DeliveryRule) onSave;

  @override
  State<_DeliveryRuleBottomSheet> createState() =>
      _DeliveryRuleBottomSheetState();
}

class _DeliveryRuleBottomSheetState extends State<_DeliveryRuleBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _feeController;
  late final TextEditingController _priorityController;
  late final TextEditingController _targetOrderCountController;
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
    _descriptionController = TextEditingController(
      text: rule?.description ?? '',
    );
    _feeController = TextEditingController(
      text: rule?.deliveryFee.toStringAsFixed(2) ?? '0',
    );
    _priorityController = TextEditingController(
      text: rule?.priority.toString() ?? '1',
    );
    _targetOrderCountController = TextEditingController(
      text: rule?.targetOrderCount?.toString() ?? '5',
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
    _targetOrderCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.rule == null
                        ? 'Add Delivery Rule'
                        : 'Edit Delivery Rule',
                    style: AdminTextStyles.sectionTitle(context),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Rule name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    initialValue: _ruleType,
                    decoration: const InputDecoration(
                      labelText: 'Rule type',
                      border: OutlineInputBorder(),
                    ),
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
                    onChanged: (value) =>
                        setState(() => _ruleType = value ?? 'special_event'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _targetUserType,
                    decoration: const InputDecoration(
                      labelText: 'Target user',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All users')),
                      DropdownMenuItem(
                        value: 'new_user',
                        child: Text('New users'),
                      ),
                      DropdownMenuItem(
                        value: 'specific_order',
                        child: Text('Specific Order'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _targetUserType = value ?? 'all'),
                  ),
                  if (_targetUserType == 'specific_order') ...[
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _targetOrderCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Order Count (e.g., 5 for 5th order)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Delivery fee (₹)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _priorityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Priority (higher is evaluated first)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (_ruleType != 'user_rule')
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickDate(isStart: true),
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              'Start: ${_startDate.day}/${_startDate.month}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickDate(isStart: false),
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              'End: ${_endDate.day}/${_endDate.month}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24.h),
                  FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AdminThemeTokens.white,
                            ),
                          )
                        : const Text('Save Rule'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final feeText = _feeController.text.trim();
    final priorityText = _priorityController.text.trim();
    final orderCountText = _targetOrderCountController.text.trim();

    if (name.isEmpty) {
      _showError('Rule name is required.');
      return;
    }
    final fee = double.tryParse(feeText);
    if (fee == null || fee < 0) {
      _showError('Delivery fee must be a valid non-negative number.');
      return;
    }
    final priority = int.tryParse(priorityText);
    if (priority == null || priority < 1) {
      _showError('Priority must be a positive integer.');
      return;
    }
    if (_targetUserType == 'specific_order') {
      final orderCount = int.tryParse(orderCountText);
      if (orderCount == null || orderCount < 1) {
        _showError('Order count must be a positive integer.');
        return;
      }
    }
    if (_endDate.isBefore(_startDate)) {
      _showError('End date must be after start date.');
      return;
    }

    final rule = DeliveryRule(
      ruleId: widget.rule?.ruleId,
      name: name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      ruleType: _ruleType,
      deliveryFee: fee,
      priority: priority,
      targetUserType: _targetUserType,
      targetOrderCount: _targetUserType == 'specific_order'
          ? int.tryParse(orderCountText)
          : null,
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

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AdminAppTheme.getErrorColor(context)),
    );
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


