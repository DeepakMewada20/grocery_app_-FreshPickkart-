import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CatalogCouponsTab extends StatelessWidget {
  const CatalogCouponsTab({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onCreateCoupon,
    required this.onEditCoupon,
    required this.onDeleteCoupon,
  });

  final AdminCouponController controller;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreateCoupon;
  final ValueChanged<Coupon> onEditCoupon;
  final ValueChanged<Coupon> onDeleteCoupon;

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
        return AdminStateView.error(
          message: error,
          onRetry: controller.loadCoupons,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadCoupons,
        child: AdminResponsive.constrainContent(
          context: context,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AdminResponsive.pagePadding(
              context,
            ).copyWith(bottom: AdminResponsive.bottomInset(context) + 78.h),
            children: [
              Text('Coupons', style: AdminTextStyles.screenTitle(context)),
              SizedBox(height: 6.h),
              Text(
                'Coupon codes, coupon types, and active campaign summary',
                style: AdminTextStyles.body(
                  context,
                ).copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 16.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 360 ? 1 : 2;
                  final spacing = 12.w;
                  final width =
                      (constraints.maxWidth - ((columns - 1) * spacing)) /
                      columns;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: 12.h,
                    children: [
                      SizedBox(
                        width: width,
                        child: CatalogStatCard(
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
                      ),
                      SizedBox(
                        width: width,
                        child: CatalogStatCard(
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
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final search = TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search coupon code or description',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: onSearchChanged,
                  );
                  final create = FilledButton.icon(
                    onPressed: onCreateCoupon,
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                  );
                  if (constraints.maxWidth < 420) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        search,
                        SizedBox(height: 10.h),
                        create,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: search),
                      SizedBox(width: 12.w),
                      create,
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Coupon List',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                  ),
                  Text(
                    '${visibleCoupons.length} items',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
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
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Padding(
                      padding: AdminResponsive.cardPadding(context),
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
                              SizedBox(width: 12.w),
                              Switch(
                                value: coupon.isActive,
                                onChanged: (value) => controller
                                    .setCouponActive(coupon.code, value),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
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
                          SizedBox(height: 12.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.r),
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
                          SizedBox(height: 10.h),
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
                              IconButton(
                                onPressed: () => onDeleteCoupon(coupon),
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Delete',
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
    constraints: AdminResponsive.bottomSheetConstraints(context),
    builder: (sheetContext) {
      return _CouponFormBottomSheet(
        onSave: (coupon, draft) async {
          await controller.uploadCoupon(coupon, notificationDraft: draft);
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
  final Future<void> Function(Coupon coupon, NotificationDraft? draft) onSave;
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
  late final TextEditingController _notificationTitleCtrl;
  late final TextEditingController _notificationBodyCtrl;
  late final TextEditingController _notificationImageCtrl;

  late String _couponType;
  late bool _isActive;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _sendNotification;
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
    _notificationTitleCtrl = TextEditingController();
    _notificationBodyCtrl = TextEditingController(
      text: coupon == null
          ? 'Open FreshPickKart and save on your next order.'
          : '',
    );
    _notificationImageCtrl = TextEditingController();
    _couponType = _deriveCouponType(coupon);
    _isActive = coupon?.isActive ?? true;
    _sendNotification = coupon == null;
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
    _notificationTitleCtrl.dispose();
    _notificationBodyCtrl.dispose();
    _notificationImageCtrl.dispose();
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
      await widget.onSave(coupon, _buildNotificationDraft(coupon));
      if (!mounted) return;
      widget.onSaveSuccess();
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      widget.onSaveError(error);
      setState(() => _isSaving = false);
    }
  }

  NotificationDraft? _buildNotificationDraft(Coupon coupon) {
    if (!_sendNotification) return null;
    final title = _notificationTitleCtrl.text.trim().isEmpty
        ? 'New coupon: ${coupon.code}'
        : _notificationTitleCtrl.text.trim();
    final body = _notificationBodyCtrl.text.trim().isEmpty
        ? coupon.description
        : _notificationBodyCtrl.text.trim();
    return NotificationDraft(
      enabled: true,
      title: title,
      body: body,
      type: 'coupon',
      topic: 'coupons',
      imageUrl: _notificationImageCtrl.text.trim().isEmpty
          ? null
          : _notificationImageCtrl.text.trim(),
      targetAudience: 'all',
      entityType: 'coupon',
      entityId: coupon.id ?? coupon.code,
      data: {'couponCode': coupon.code},
    );
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
    return InkWell(
      onTap: _isSaving ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: const Color(0xFF315C73).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18.sp.clamp(16.0, 20.0),
                color: const Color(0xFF315C73),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp.clamp(10.0, 13.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    catalogDateLabel(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp.clamp(12.0, 15.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialCoupon != null;
    final canEditCode = !isEditing;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AdminResponsive.pageHorizontalPadding(context),
        0,
        AdminResponsive.pageHorizontalPadding(context),
        MediaQuery.viewInsetsOf(context).bottom + 16,
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
                        SizedBox(height: 12.h),
                        typeField,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: codeField),
                      SizedBox(width: 12.w),
                      Expanded(child: typeField),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
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
              SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
              ],
              _CouponAdaptiveRow(
                children: [
                  TextFormField(
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
                  TextFormField(
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
                ],
              ),
              SizedBox(height: 16.h),
              _CouponAdaptiveRow(
                children: [
                  TextFormField(
                    controller: _usageLimitCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Usage Limit',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Optional',
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.only(left: 8.w),
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
                ],
              ),
              SizedBox(height: 16.h),
              _CouponAdaptiveRow(
                children: [
                  _buildDateCard(
                    label: 'Start Date',
                    value: _startDate,
                    onTap: () => _pickDate(true),
                  ),
                  _buildDateCard(
                    label: 'End Date',
                    value: _endDate,
                    onTap: () => _pickDate(false),
                  ),
                ],
              ),
              if (!isEditing) ...[
                SizedBox(height: 16.h),
                SwitchListTile(
                  contentPadding: EdgeInsets.only(left: 8.w),
                  value: _sendNotification,
                  dense: true,
                  title: const Text(
                    'Send Notification',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _sendNotification = value;
                    });
                  },
                ),
                if (_sendNotification) ...[
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _notificationTitleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notification Title',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _notificationBodyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notification Body',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _notificationImageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Optional',
                    ),
                  ),
                ],
              ],
              SizedBox(height: 24.h),
              _CouponAdaptiveRow(
                collapseWidth: 360,
                reverseWhenCollapsed: true,
                flexes: const [1, 2],
                children: [
                  OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF315C73),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Coupon' : 'Create Coupon',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
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

class _CouponAdaptiveRow extends StatelessWidget {
  const _CouponAdaptiveRow({
    required this.children,
    this.collapseWidth = 420,
    this.reverseWhenCollapsed = false,
    this.flexes,
  });

  final List<Widget> children;
  final double collapseWidth;
  final bool reverseWhenCollapsed;
  final List<int>? flexes;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 12.w;
        final orderedChildren = reverseWhenCollapsed
            ? children.reversed.toList()
            : children;
        if (constraints.maxWidth < collapseWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < orderedChildren.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                orderedChildren[i],
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(flex: flexes?[i] ?? 1, child: children[i]),
            ],
          ],
        );
      },
    );
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
    constraints: AdminResponsive.bottomSheetConstraints(context),
    builder: (sheetContext) {
      return _CouponFormBottomSheet(
        initialCoupon: coupon,
        onSave: (updated, draft) async {
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

Future<void> showDeleteCouponDialog({
  required BuildContext context,
  required AdminCouponController controller,
  required Coupon coupon,
}) async {
  final shouldDelete = await showDialog<bool>(
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

  if (shouldDelete != true) return;

  try {
    final ok = await controller.deleteCoupon(coupon.code);
    if (!context.mounted) return;
    _showCatalogCouponSnackBar(
      context,
      ok ? 'Coupon deleted' : 'Delete failed',
    );
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogCouponSnackBar(context, 'Failed to delete coupon: $error');
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
