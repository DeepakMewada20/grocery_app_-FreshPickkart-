import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_coupon_controller.dart';
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

      if (isLoading && coupons.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && coupons.isEmpty) {
        return Center(child: Text('Error: $error'));
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    CatalogStatCard(
                      title: 'Total Coupons',
                      value: '${coupons.length}',
                      icon: Icons.discount,
                      color: Colors.green,
                    ),
                    CatalogStatCard(
                      title: 'Live Coupons',
                      value: '$liveCoupons',
                      icon: Icons.flash_on_outlined,
                      color: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search coupon',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: onSearchChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: onCreateCoupon,
                      icon: const Icon(Icons.add),
                      label: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.loadCoupons,
              child: visibleCoupons.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('No matching coupons')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: visibleCoupons.length,
                      itemBuilder: (context, index) {
                        final coupon = visibleCoupons[index];
                        final statusColor = catalogCouponStatusColor(coupon);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              coupon.code,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              catalogCouponStatusLabel(coupon),
                                              style: TextStyle(
                                                color: statusColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(coupon.description),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Category: ${coupon.couponCategory} • Type: ${coupon.discountType ?? 'delivery'}',
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Min order: ₹${coupon.minOrderAmount.toStringAsFixed(0)} • Used: ${coupon.usedCount}',
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Duration: ${catalogDateLabel(coupon.startDate)} to ${catalogDateLabel(coupon.endDate)}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Switch(
                                      value: coupon.isActive,
                                      onChanged: (value) => controller
                                          .setCouponActive(coupon.code, value),
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
                      },
                    ),
            ),
          ),
        ],
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
