import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
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
            onPressed: () => _controller.loadCoupons(force: true),
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
          return AdminStateView.error(
            message: error,
            onRetry: () => _controller.loadCoupons(force: true),
          );
        }

        if (coupons.isEmpty) {
          return AdminStateView.empty(
            title: 'No coupons yet',
            message: 'Create a coupon to start offering discounts.',
            onRefresh: () => _controller.loadCoupons(force: true),
          );
        }

        final query = _searchQuery.toLowerCase().trim();
        final filteredCoupons = query.isEmpty
            ? coupons.toList()
            : coupons
                  .where(
                    (coupon) =>
                        coupon.code.toLowerCase().contains(query) ||
                        coupon.description.toLowerCase().contains(query) ||
                        _couponTypeLabel(coupon).toLowerCase().contains(query),
                  )
                  .toList();

        return LayoutBuilder(
          builder: (context, _) {
            final pagePadding = AdminResponsive.pagePadding(context);
            return AdminResponsive.constrainContent(
              context: context,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      pagePadding.horizontal / 2,
                      10.h,
                      pagePadding.horizontal / 2,
                      6.h,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search coupon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
                      onRefresh: () => _controller.loadCoupons(force: true),
                      child: filteredCoupons.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: pagePadding.copyWith(
                                bottom:
                                    AdminResponsive.bottomInset(context) + 88.h,
                              ),
                              children: [
                                SizedBox(height: 72.h),
                                AdminStateView.empty(
                                  title: 'No matching coupons',
                                  message:
                                      'Try a different coupon code, type, or description.',
                                  icon: Icons.search_off_outlined,
                                  onRefresh: () => _controller.loadCoupons(force: true),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: pagePadding.copyWith(
                                bottom:
                                    AdminResponsive.bottomInset(context) + 88.h,
                              ),
                              itemCount: filteredCoupons.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final coupon = filteredCoupons[index];
                                return _CouponCard(
                                  coupon: coupon,
                                  couponTypeLabel: _couponTypeLabel(coupon),
                                  onToggle: (value) => _controller
                                      .setCouponActive(coupon.code, value),
                                  onEdit: () => _openEditCouponDialog(coupon),
                                  onDelete: () => _confirmDeleteCoupon(coupon),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AdminResponsive.bottomInset(context)),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          onPressed: _openAddCouponDialog,
          icon: const Icon(Icons.add),
          label: Text(
            'Create Coupon',
            overflow: TextOverflow.ellipsis,
            style: AdminTextStyles.button(context),
          ),
        ),
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
          title: Text(
            'Delete ${coupon.code}?',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          content: ConstrainedBox(
            constraints: AdminResponsive.dialogConstraints(dialogContext),
            child: const SingleChildScrollView(
              child: Text(
                'This will permanently remove the coupon from the server data store.',
              ),
            ),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
              content: ConstrainedBox(
                constraints: AdminResponsive.dialogConstraints(context),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: codeCtrl,
                          enabled: initialCoupon == null,
                          decoration: const InputDecoration(labelText: 'Code'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          minLines: 1,
                          maxLines: 3,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: couponType,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Coupon type',
                          ),
                          items: _couponTypes
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            minLines: 1,
                            maxLines: 3,
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
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
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

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.couponTypeLabel,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Coupon coupon;
  final String couponTypeLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 460;
            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.code,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AdminTextStyles.cardTitle(context),
                ),
                SizedBox(height: 6.h),
                Text(
                  coupon.description,
                  maxLines: isCompact ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: AdminTextStyles.body(context),
                ),
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _CouponMetaChip(label: couponTypeLabel),
                    _CouponMetaChip(
                      label: 'Min ₹${coupon.minOrderAmount.toStringAsFixed(0)}',
                    ),
                    _CouponMetaChip(label: 'Used ${coupon.usedCount}'),
                  ],
                ),
              ],
            );
            final actions = _CouponCardActions(
              coupon: coupon,
              onToggle: onToggle,
              onEdit: onEdit,
              onDelete: onDelete,
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details,
                  SizedBox(height: 10.h),
                  actions,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                SizedBox(width: 12.w),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CouponCardActions extends StatelessWidget {
  const _CouponCardActions({
    required this.coupon,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Coupon coupon;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        Text(
          coupon.isActive ? 'Active' : 'Off',
          style: AdminTextStyles.caption(context).copyWith(
            color: coupon.isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        Transform.scale(
          scale: AdminResponsive.isSmallPhone(context) ? 0.86 : 0.94,
          child: Switch(value: coupon.isActive, onChanged: onToggle),
        ),
        IconButton(
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, size: 18.r),
          tooltip: 'Edit',
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, size: 18.r),
          tooltip: 'Delete',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _CouponMetaChip extends StatelessWidget {
  const _CouponMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AdminTextStyles.caption(context),
      ),
    );
  }
}
