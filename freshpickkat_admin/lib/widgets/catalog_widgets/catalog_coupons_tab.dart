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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupons = controller.coupons;
      final visibleCoupons = filterCatalogCoupons(coupons, searchQuery);
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;
      final liveCoupons = coupons.where(isCatalogCouponLive).length;
      final inactiveCoupons = coupons.where((coupon) => !coupon.isActive).length;
      final deliveryCoupons = coupons
          .where((coupon) => coupon.couponCategory == 'delivery')
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coupon codes, delivery coupons, and active campaign summary',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
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
                  title: 'Delivery',
                  value: '$deliveryCoupons',
                  icon: Icons.local_shipping_outlined,
                  color: const Color(0xFF7C4D12),
                  breakdown: [
                    CatalogStatBreakdown(
                      label: 'Visible',
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
                              onChanged: (value) =>
                                  controller.setCouponActive(coupon.code, value),
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
                              label: coupon.couponCategory == 'delivery'
                                  ? 'Delivery'
                                  : (coupon.discountType ?? 'flat')
                                        .toUpperCase(),
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
}) async {
  final formKey = GlobalKey<FormState>();
  final codeCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final discountValueCtrl = TextEditingController();
  final minOrderCtrl = TextEditingController(text: '0');
  final maxDiscountCtrl = TextEditingController();
  final usageLimitCtrl = TextEditingController();

  String couponCategory = 'All';
  String? discountType = 'flat';
  bool isActive = true;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Create Coupon'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: codeCtrl,
                      decoration: const InputDecoration(labelText: 'Code'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: couponCategory,
                      decoration: const InputDecoration(
                        labelText: 'Coupon category',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'delivery',
                          child: Text('Delivery'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() {
                          couponCategory = value;
                          if (couponCategory == 'delivery') {
                            discountType = null;
                          } else {
                            discountType ??= 'flat';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    if (couponCategory != 'delivery') ...[
                      DropdownButtonFormField<String>(
                        initialValue: discountType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(value: 'flat', child: Text('Flat')),
                          DropdownMenuItem(
                            value: 'percentage',
                            child: Text('Percentage'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            discountType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: discountValueCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Discount value',
                        ),
                        validator: _catalogNumberValidator,
                      ),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(
                      controller: minOrderCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Minimum order amount',
                      ),
                      validator: _catalogNumberValidator,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: maxDiscountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Max discount (optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: usageLimitCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Usage limit (optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Start: ${catalogDateLabel(startDate)}'),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            startDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('End: ${catalogDateLabel(endDate)}'),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: startDate,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            endDate = picked;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: isActive,
                      title: const Text('Active'),
                      onChanged: (value) {
                        setDialogState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    },
  );

  if (saved != true) return;

  final maxDiscount = maxDiscountCtrl.text.trim().isEmpty
      ? null
      : double.tryParse(maxDiscountCtrl.text.trim());
  final usageLimit = usageLimitCtrl.text.trim().isEmpty
      ? null
      : int.tryParse(usageLimitCtrl.text.trim());

  final coupon = Coupon(
    code: codeCtrl.text.trim().toUpperCase(),
    description: descCtrl.text.trim(),
    discountType: couponCategory == 'delivery' ? null : discountType,
    discountValue: couponCategory == 'delivery'
        ? null
        : double.parse(discountValueCtrl.text.trim()),
    minOrderAmount: double.parse(minOrderCtrl.text.trim()),
    maxDiscount: maxDiscount,
    startDate: startDate,
    endDate: endDate,
    usageLimit: usageLimit,
    usedCount: 0,
    isActive: isActive,
    couponCategory: couponCategory,
  );

  try {
    await controller.uploadCoupon(coupon);
    if (!context.mounted) return;
    _showCatalogCouponSnackBar(context, 'Coupon created');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogCouponSnackBar(context, 'Failed to create coupon: $error');
  }
}

Future<void> showEditCouponDialog({
  required BuildContext context,
  required AdminCouponController controller,
  required Coupon coupon,
}) async {
  final formKey = GlobalKey<FormState>();
  final descCtrl = TextEditingController(text: coupon.description);
  final minOrderCtrl = TextEditingController(
    text: coupon.minOrderAmount.toString(),
  );
  final discountValueCtrl = TextEditingController(
    text: coupon.discountValue?.toString() ?? '',
  );
  final maxDiscountCtrl = TextEditingController(
    text: coupon.maxDiscount?.toString() ?? '',
  );
  DateTime startDate = coupon.startDate;
  DateTime endDate = coupon.endDate;
  bool isActive = coupon.isActive;
  String? discountType = coupon.discountType;
  String couponCategory = coupon.couponCategory;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Edit ${coupon.code}'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: minOrderCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Minimum order amount',
                      ),
                      validator: _catalogNumberValidator,
                    ),
                    const SizedBox(height: 10),
                    if (couponCategory != 'delivery') ...[
                      DropdownButtonFormField<String>(
                        initialValue: discountType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(value: 'flat', child: Text('Flat')),
                          DropdownMenuItem(
                            value: 'percentage',
                            child: Text('Percentage'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            discountType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: discountValueCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Discount value',
                        ),
                        validator: _catalogNumberValidator,
                      ),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(
                      controller: maxDiscountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Max discount (optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Start: ${catalogDateLabel(startDate)}'),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setDialogState(() => startDate = picked);
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('End: ${catalogDateLabel(endDate)}'),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: startDate,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setDialogState(() => endDate = picked);
                        }
                      },
                    ),
                    SwitchListTile(
                      value: isActive,
                      onChanged: (value) =>
                          setDialogState(() => isActive = value),
                      title: const Text('Active'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    },
  );

  if (saved != true) return;

  final updated = coupon.copyWith(
    description: descCtrl.text.trim(),
    minOrderAmount: double.parse(minOrderCtrl.text.trim()),
    discountType: couponCategory == 'delivery' ? null : discountType,
    discountValue: couponCategory == 'delivery'
        ? null
        : double.parse(discountValueCtrl.text.trim()),
    maxDiscount: maxDiscountCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(maxDiscountCtrl.text.trim()),
    startDate: startDate,
    endDate: endDate,
    isActive: isActive,
  );

  try {
    final updatedOk = await controller.updateCoupon(updated);
    if (!context.mounted) return;
    if (!updatedOk) {
      _showCatalogCouponSnackBar(context, 'Update failed');
      return;
    }
    _showCatalogCouponSnackBar(context, 'Coupon updated');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogCouponSnackBar(context, 'Failed: $error');
  }
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
