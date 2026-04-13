import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final AdminCouponController _controller = AdminCouponController.instance;
  static const List<String> _couponTypes = [
    'FIRST_ORDER',
    'PERCENTAGE_DISCOUNT',
    'FLAT_DISCOUNT',
    'LIMITED_TIME',
    'LOYALTY',
    'PRODUCT_BASED',
  ];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Coupons'),
        actions: [
          IconButton(
            onPressed: _controller.loadCoupons,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.networkController.retryLastRequest(),
          );
        }

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
                                    'Type: ${_couponTypeLabel(coupon)} | Min ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
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
                                IconButton(
                                  onPressed: () => _confirmDeleteCoupon(coupon),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                  ),
                                  tooltip: 'Delete',
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: _openAddCouponDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Coupon'),
      ),
    );
  }

  Future<void> _openAddCouponDialog() async {
    final coupon = await _showCouponDialog();
    if (coupon == null) return;

    try {
      await _controller.uploadCoupon(coupon);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('Coupon created')));
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to create coupon: $e')),
      );
    }
  }

  Future<void> _openEditCouponDialog(Coupon coupon) async {
    final updated = await _showCouponDialog(initialCoupon: coupon);
    if (updated == null) return;

    try {
      final ok = await _controller.updateCoupon(updated);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      if (!ok) {
        messenger.showSnackBar(const SnackBar(content: Text('Update failed')));
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Coupon updated')));
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _confirmDeleteCoupon(Coupon coupon) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete ${coupon.code}?'),
          content: const Text(
            'This will permanently remove the coupon from Firestore.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      final ok = await _controller.deleteCoupon(coupon.code);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(ok ? 'Coupon deleted' : 'Delete failed')),
      );
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to delete coupon: $e')),
      );
    }
  }

  Future<Coupon?> _showCouponDialog({Coupon? initialCoupon}) async {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: initialCoupon?.code ?? '');
    final descCtrl = TextEditingController(
      text: initialCoupon?.description ?? '',
    );
    final discountValueCtrl = TextEditingController(
      text: initialCoupon?.discountValue?.toString() ?? '',
    );
    final minOrderCtrl = TextEditingController(
      text: (initialCoupon?.minOrderAmount ?? 0).toString(),
    );
    final maxDiscountCtrl = TextEditingController(
      text:
          (initialCoupon?.maxDiscountAmount ?? initialCoupon?.maxDiscount)
              ?.toString() ??
          '',
    );
    final usageLimitCtrl = TextEditingController(
      text: initialCoupon?.usageLimit?.toString() ?? '',
    );
    final productIdsCtrl = TextEditingController(
      text: (initialCoupon?.productIds ?? const <String>[]).join(', '),
    );
    final loyaltyOrdersCtrl = TextEditingController(
      text: initialCoupon?.loyaltyRequiredOrders?.toString() ?? '',
    );

    String couponType = _couponTypeLabel(initialCoupon);
    bool isActive = initialCoupon?.isActive ?? true;
    DateTime startDate = initialCoupon?.startDate ?? DateTime.now();
    DateTime endDate =
        initialCoupon?.expiryDate ??
        initialCoupon?.endDate ??
        DateTime.now().add(const Duration(days: 30));
    bool isSubmitting = false;

    return showDialog<Coupon>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                initialCoupon == null
                    ? 'Create Coupon'
                    : 'Edit ${initialCoupon.code}',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: codeCtrl,
                        enabled: initialCoupon == null,
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
                        initialValue: couponType,
                        decoration: const InputDecoration(
                          labelText: 'Coupon type',
                        ),
                        items: _couponTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            couponType = value;
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
                        validator: _numberValidator,
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
                      if (couponType == 'LOYALTY') ...[
                        TextFormField(
                          controller: loyaltyOrdersCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Required completed orders',
                          ),
                          validator: (value) {
                            if (couponType != 'LOYALTY') return null;
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return int.tryParse(value.trim()) == null
                                ? 'Invalid number'
                                : null;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (couponType == 'PRODUCT_BASED') ...[
                        TextFormField(
                          controller: productIdsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Product IDs (comma separated)',
                          ),
                          validator: (value) {
                            if (couponType != 'PRODUCT_BASED') return null;
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
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
                          'Expiry: ${endDate.toLocal()}'.split(' ').first,
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
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        value: isActive,
                        title: const Text('Active'),
                        onChanged: (value) {
                          setDialogState(() => isActive = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          final coupon = Coupon(
                            id: initialCoupon?.id ?? codeCtrl.text.trim(),
                            code: codeCtrl.text.trim().toUpperCase(),
                            description: descCtrl.text.trim(),
                            type: couponType,
                            discountValue: double.parse(
                              discountValueCtrl.text.trim(),
                            ),
                            minOrderAmount: double.parse(
                              minOrderCtrl.text.trim(),
                            ),
                            maxDiscount: maxDiscountCtrl.text.trim().isEmpty
                                ? null
                                : double.tryParse(maxDiscountCtrl.text.trim()),
                            maxDiscountAmount:
                                maxDiscountCtrl.text.trim().isEmpty
                                ? null
                                : double.tryParse(maxDiscountCtrl.text.trim()),
                            productIds: couponType == 'PRODUCT_BASED'
                                ? _parseProductIds(productIdsCtrl.text)
                                : null,
                            loyaltyRequiredOrders: couponType == 'LOYALTY'
                                ? int.tryParse(loyaltyOrdersCtrl.text.trim())
                                : null,
                            startDate: startDate,
                            endDate: endDate,
                            expiryDate: endDate,
                            usageLimit: usageLimitCtrl.text.trim().isEmpty
                                ? null
                                : int.tryParse(usageLimitCtrl.text.trim()),
                            usedCount: initialCoupon?.usedCount ?? 0,
                            isActive: isActive,
                            couponCategory: 'All',
                          );
                          setDialogState(() => isSubmitting = true);
                          if (!context.mounted) return;
                          Navigator.pop(context, coupon);
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(initialCoupon == null ? 'Create' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return double.tryParse(value.trim()) == null ? 'Invalid number' : null;
  }

  String _couponTypeLabel(Coupon? coupon) {
    if (coupon == null) return 'FLAT_DISCOUNT';
    if (coupon.type != null && coupon.type!.trim().isNotEmpty) {
      return coupon.type!;
    }
    if ((coupon.productIds ?? const <String>[]).isNotEmpty) {
      return 'PRODUCT_BASED';
    }
    if ((coupon.loyaltyRequiredOrders ?? 0) > 0) {
      return 'LOYALTY';
    }
    return 'FLAT_DISCOUNT';
  }

  List<String> _parseProductIds(String raw) {
    return raw
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }
}
