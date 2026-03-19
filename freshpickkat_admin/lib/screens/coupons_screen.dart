import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_coupon_controller.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final AdminCouponController _controller = AdminCouponController.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _controller.loadCoupons,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final coupons = _controller.coupons;
        final isLoading = _controller.isLoading.value;
        final error = _controller.error.value;

        if (isLoading && coupons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && coupons.isEmpty) {
          return Center(child: Text('Error: $error'));
        }

        if (coupons.isEmpty) {
          return const Center(child: Text('No coupons found'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search coupon',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _controller.loadCoupons,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    final q = _searchQuery.toLowerCase().trim();
                    if (q.isNotEmpty &&
                        !coupon.code.toLowerCase().contains(q) &&
                        !coupon.description.toLowerCase().contains(q)) {
                      return const SizedBox.shrink();
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coupon.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(coupon.description),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Type: ${coupon.discountType ?? 'delivery'} | Min ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Used ${coupon.usedCount}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      coupon.isActive ? 'Active' : 'Off',
                                      style: TextStyle(
                                        color: coupon.isActive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    Switch(
                                      value: coupon.isActive,
                                      onChanged: (value) => _controller
                                          .setCouponActive(coupon.code, value),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _openEditCouponDialog(coupon),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
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
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _openAddCouponDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Coupon'),
      ),
    );
  }

  Future<void> _openAddCouponDialog() async {
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: descCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                      if (couponCategory != 'delivery')
                        DropdownButtonFormField<String>(
                          initialValue: discountType,
                          decoration: const InputDecoration(labelText: 'Type'),
                          items: const [
                            DropdownMenuItem(
                              value: 'flat',
                              child: Text('Flat'),
                            ),
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
                      if (couponCategory != 'delivery')
                        const SizedBox(height: 10),
                      if (couponCategory != 'delivery')
                        TextFormField(
                          controller: discountValueCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Discount value',
                          ),
                          validator: _numberValidator,
                        ),
                      if (couponCategory != 'delivery')
                        const SizedBox(height: 10),
                      TextFormField(
                        controller: minOrderCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Minimum order amount',
                        ),
                        validator: _numberValidator,
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
                        title: Text(
                          'Start: ${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
                        ),
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
                        title: Text(
                          'End: ${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
                        ),
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
      await _controller.uploadCoupon(coupon);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Coupon created')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create coupon: $e')));
    }
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return double.tryParse(value.trim()) == null ? 'Invalid number' : null;
  }

  Future<void> _openEditCouponDialog(Coupon coupon) async {
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 10),
                      if (couponCategory != 'delivery')
                        DropdownButtonFormField<String>(
                          initialValue: discountType,
                          decoration: const InputDecoration(labelText: 'Type'),
                          items: const [
                            DropdownMenuItem(
                              value: 'flat',
                              child: Text('Flat'),
                            ),
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
                      if (couponCategory != 'delivery')
                        const SizedBox(height: 10),
                      if (couponCategory != 'delivery')
                        TextFormField(
                          controller: discountValueCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Discount value',
                          ),
                          validator: _numberValidator,
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
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Start: ${startDate.toLocal()}'.split(' ').first,
                        ),
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
                        title: Text(
                          'End: ${endDate.toLocal()}'.split(' ').first,
                        ),
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
                        onChanged: (v) => setDialogState(() => isActive = v),
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
      final ok = await _controller.updateCoupon(updated);
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Update failed')));
        return;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }
}
