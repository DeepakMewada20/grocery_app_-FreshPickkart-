import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class CatalogCouponsTab extends StatelessWidget {
  const CatalogCouponsTab({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onCreateCoupon,
    required this.onEditCoupon,
  });

  final AdminCouponController controller;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreateCoupon;
  final ValueChanged<Coupon> onEditCoupon;

  String _couponTypeLabel(Coupon coupon) {
    if (coupon.type != null && coupon.type!.trim().isNotEmpty) {
      return coupon.type!;
    }
    if ((coupon.productIds ?? const <String>[]).isNotEmpty) {
      return 'PRODUCT_BASED';
    }
    if ((coupon.loyaltyRequiredOrders ?? 0) > 0) {
      return 'LOYALTY';
    }
    if ((coupon.discountType ?? '').toLowerCase() == 'percentage') {
      return 'PERCENTAGE_DISCOUNT';
    }
    return 'FLAT_DISCOUNT';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupons = controller.coupons;
      final visibleCoupons = filterCatalogCoupons(coupons, searchQuery);
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;
      final liveCoupons = coupons.where(isCatalogCouponLive).length;
      final inactiveCoupons = coupons
          .where((coupon) => !coupon.isActive)
          .length;

      if (isLoading && coupons.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && coupons.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      return RefreshIndicator(
        onRefresh: controller.loadCoupons,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            const Text(
              'Coupons',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Coupon codes, coupon types, and active campaign summary',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CatalogStatCard(
                  title: 'All Coupons',
                  value: '${coupons.length}',
                  icon: Icons.sell_outlined,
                  color: const Color(0xFF315C73),
                  breakdown: [
                    CatalogStatBreakdown(
                      label: 'Live',
                      value: '$liveCoupons',
                      color: Colors.green.shade700,
                    ),
                    CatalogStatBreakdown(
                      label: 'Inactive',
                      value: '$inactiveCoupons',
                      color: Colors.redAccent.shade200,
                    ),
                  ],
                ),
                CatalogStatCard(
                  title: 'Visible',
                  value: '${visibleCoupons.length}',
                  icon: Icons.visibility_outlined,
                  color: const Color(0xFF7C4D12),
                  breakdown: [
                    CatalogStatBreakdown(
                      label: 'Search Match',
                      value: '${visibleCoupons.length}',
                      color: Colors.blueGrey.shade700,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search coupon code or description',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onCreateCoupon,
                  icon: const Icon(Icons.add),
                  label: const Text('Create'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Coupon List',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${visibleCoupons.length} items',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (visibleCoupons.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No matching coupons'),
                ),
              )
            else
              ...visibleCoupons.map((coupon) {
                final statusColor = catalogCouponStatusColor(coupon);
                final valueLabel = catalogCouponValueLabel(coupon);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coupon.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    coupon.description,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Switch(
                              value: coupon.isActive,
                              onChanged: (value) => controller.setCouponActive(
                                coupon.code,
                                value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            CatalogInlineBadge(
                              label: catalogCouponStatusLabel(coupon),
                              color: statusColor,
                            ),
                            CatalogInlineBadge(
                              label: _couponTypeLabel(coupon),
                              color: const Color(0xFF4E5D6C),
                            ),
                            CatalogInlineBadge(
                              label: valueLabel,
                              color: const Color(0xFF8B5E34),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Wrap(
                            spacing: 14,
                            runSpacing: 8,
                            children: [
                              Text(
                                'Min order ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
                              ),
                              Text('Used ${coupon.usedCount}'),
                              if (coupon.maxDiscount != null)
                                Text(
                                  'Max ₹${coupon.maxDiscount!.toStringAsFixed(0)}',
                                ),
                              if (coupon.usageLimit != null)
                                Text('Limit ${coupon.usageLimit}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Duration: ${catalogDateLabel(coupon.startDate)} to ${catalogDateLabel(coupon.endDate)}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onEditCoupon(coupon),
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Edit',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}

Future<void> showAddCouponDialog({
  required BuildContext context,
  required AdminCouponController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return _CouponFormBottomSheet(
        onSave: (coupon) async {
          await controller.uploadCoupon(coupon);
        },
        onSaveSuccess: () {
          _showCatalogCouponSnackBar(sheetContext, 'Coupon created');
        },
        onSaveError: (error) {
          _showCatalogCouponSnackBar(
            sheetContext,
            'Failed to create coupon: $error',
          );
        },
      );
    },
  );
}

class _CouponFormBottomSheet extends StatefulWidget {
  final Coupon? initialCoupon;
  final Future<void> Function(Coupon coupon) onSave;
  final VoidCallback onSaveSuccess;
  final void Function(Object error) onSaveError;

  const _CouponFormBottomSheet({
    this.initialCoupon,
    required this.onSave,
    required this.onSaveSuccess,
    required this.onSaveError,
  });

  @override
  State<_CouponFormBottomSheet> createState() => _CouponFormBottomSheetState();
}

class _CouponFormBottomSheetState extends State<_CouponFormBottomSheet> {
  static const List<String> _couponTypes = [
    'FIRST_ORDER',
    'PERCENTAGE_DISCOUNT',
    'FLAT_DISCOUNT',
    'LIMITED_TIME',
    'LOYALTY',
    'PRODUCT_BASED',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _discountValueCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _maxDiscountCtrl;
  late final TextEditingController _usageLimitCtrl;
  late final TextEditingController _productIdsCtrl;
  late final TextEditingController _loyaltyOrdersCtrl;

  late String _couponType;
  late bool _isActive;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final coupon = widget.initialCoupon;
    _codeCtrl = TextEditingController(text: coupon?.code ?? '');
    _descCtrl = TextEditingController(text: coupon?.description ?? '');
    _discountValueCtrl = TextEditingController(
      text: coupon?.discountValue?.toString() ?? '',
    );
    _minOrderCtrl = TextEditingController(
      text: coupon?.minOrderAmount.toString() ?? '0',
    );
    _maxDiscountCtrl = TextEditingController(
      text: coupon?.maxDiscount?.toString() ?? '',
    );
    _usageLimitCtrl = TextEditingController(
      text: coupon?.usageLimit?.toString() ?? '',
    );
    _productIdsCtrl = TextEditingController(
      text: (coupon?.productIds ?? const <String>[]).join(', '),
    );
    _loyaltyOrdersCtrl = TextEditingController(
      text: coupon?.loyaltyRequiredOrders?.toString() ?? '',
    );
    _couponType = _deriveCouponType(coupon);
    _isActive = coupon?.isActive ?? true;
    _startDate = coupon?.startDate ?? DateTime.now();
    _endDate =
        coupon?.expiryDate ??
        coupon?.endDate ??
        DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _discountValueCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _usageLimitCtrl.dispose();
    _productIdsCtrl.dispose();
    _loyaltyOrdersCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final maxDiscount = _maxDiscountCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_maxDiscountCtrl.text.trim());
    final usageLimit = _usageLimitCtrl.text.trim().isEmpty
        ? null
        : int.tryParse(_usageLimitCtrl.text.trim());

    final coupon = Coupon(
      id: widget.initialCoupon?.id ?? _codeCtrl.text.trim(),
      code: _codeCtrl.text.trim().toUpperCase(),
      description: _descCtrl.text.trim(),
      type: _couponType,
      discountType: _resolvedDiscountType(_couponType),
      discountValue: double.parse(_discountValueCtrl.text.trim()),
      minOrderAmount: double.parse(_minOrderCtrl.text.trim()),
      maxDiscount: maxDiscount,
      maxDiscountAmount: maxDiscount,
      productIds: _couponType == 'PRODUCT_BASED'
          ? _parseProductIds(_productIdsCtrl.text)
          : null,
      loyaltyRequiredOrders: _couponType == 'LOYALTY'
          ? int.tryParse(_loyaltyOrdersCtrl.text.trim())
          : null,
      startDate: _startDate,
      endDate: _endDate,
      expiryDate: _endDate,
      usageLimit: usageLimit,
      usedCount: widget.initialCoupon?.usedCount ?? 0,
      isActive: _isActive,
      couponCategory: 'All',
    );

    try {
      await widget.onSave(coupon);
      if (!mounted) return;
      widget.onSaveSuccess();
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      widget.onSaveError(error);
      setState(() => _isSaving = false);
    }
  }

  Widget _buildSheetHeader() {
    final isEditing = widget.initialCoupon != null;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Coupon' : 'Create Coupon',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Setup discount codes and delivery rules for users.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required String label,
    required DateTime value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: _isSaving ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF315C73).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Color(0xFF315C73),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      catalogDateLabel(value),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialCoupon != null;
    final canEditCode = !isEditing;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSheetHeader(),
              const Divider(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 700;
                  final codeField = TextFormField(
                    controller: _codeCtrl,
                    enabled: canEditCode,
                    decoration: const InputDecoration(
                      labelText: 'Coupon Code',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'e.g. SAVE50',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null,
                  );
                  final typeField = DropdownButtonFormField<String>(
                    initialValue: _couponType,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Coupon Type',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _couponTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _couponType = value;
                      });
                    },
                  );

                  if (isNarrow) {
                    return Column(
                      children: [
                        codeField,
                        const SizedBox(height: 12),
                        typeField,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: codeField),
                      const SizedBox(width: 12),
                      Expanded(child: typeField),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Coupon Description',
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Apply this coupon to get discount',
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountValueCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: _couponType == 'PERCENTAGE_DISCOUNT'
                      ? 'Discount Percentage'
                      : 'Discount Value',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixText: _couponType == 'PERCENTAGE_DISCOUNT' ? '%' : null,
                ),
                validator: _catalogNumberValidator,
              ),
              const SizedBox(height: 16),
              if (_couponType == 'LOYALTY') ...[
                TextFormField(
                  controller: _loyaltyOrdersCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Required Completed Orders',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (_couponType != 'LOYALTY') return null;
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return int.tryParse(value.trim()) == null
                        ? 'Invalid number'
                        : null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_couponType == 'PRODUCT_BASED') ...[
                TextFormField(
                  controller: _productIdsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product IDs',
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Comma separated product ids',
                  ),
                  validator: (value) {
                    if (_couponType != 'PRODUCT_BASED') return null;
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minOrderCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Min Order',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixText: '₹',
                      ),
                      validator: _catalogNumberValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _maxDiscountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Max Discount',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixText: '₹',
                        hintText: 'Optional',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _usageLimitCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Usage Limit',
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Optional',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      value: _isActive,
                      dense: true,
                      selected: _isActive,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      title: Text(
                        _isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDateCard(
                    label: 'Start Date',
                    value: _startDate,
                    onTap: () => _pickDate(true),
                  ),
                  const SizedBox(width: 12),
                  _buildDateCard(
                    label: 'End Date',
                    value: _endDate,
                    onTap: () => _pickDate(false),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF315C73),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEditing ? 'Update Coupon' : 'Create Coupon',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _deriveCouponType(Coupon? coupon) {
    if (coupon?.type != null && coupon!.type!.trim().isNotEmpty) {
      return coupon.type!;
    }
    if ((coupon?.productIds ?? const <String>[]).isNotEmpty) {
      return 'PRODUCT_BASED';
    }
    if ((coupon?.loyaltyRequiredOrders ?? 0) > 0) {
      return 'LOYALTY';
    }
    if ((coupon?.discountType ?? '').toLowerCase() == 'percentage') {
      return 'PERCENTAGE_DISCOUNT';
    }
    return 'FLAT_DISCOUNT';
  }

  String _resolvedDiscountType(String couponType) {
    if (couponType == 'PERCENTAGE_DISCOUNT') return 'percentage';
    return 'flat';
  }

  List<String> _parseProductIds(String raw) {
    return raw
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }
}

Future<void> showEditCouponDialog({
  required BuildContext context,
  required AdminCouponController controller,
  required Coupon coupon,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return _CouponFormBottomSheet(
        initialCoupon: coupon,
        onSave: (updated) async {
          final ok = await controller.updateCoupon(updated);
          if (!ok) {
            throw Exception('Update failed');
          }
        },
        onSaveSuccess: () {
          _showCatalogCouponSnackBar(sheetContext, 'Coupon updated');
        },
        onSaveError: (error) {
          _showCatalogCouponSnackBar(sheetContext, 'Failed: $error');
        },
      );
    },
  );
}

String? _catalogNumberValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return double.tryParse(value.trim()) == null ? 'Invalid number' : null;
}

void _showCatalogCouponSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
