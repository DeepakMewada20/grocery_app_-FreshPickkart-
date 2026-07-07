import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';

import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offer_helpers.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CatalogCouponsTab extends StatefulWidget {
  const CatalogCouponsTab({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onEditCoupon,
    required this.onDeleteCoupon,
  });

  final AdminCouponController controller;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Coupon> onEditCoupon;
  final ValueChanged<Coupon> onDeleteCoupon;

  @override
  State<CatalogCouponsTab> createState() => _CatalogCouponsTabState();
}

class _CatalogCouponsTabState extends State<CatalogCouponsTab> {
  String _statusFilter = 'all';
  String _categoryFilter = 'all';

  String _categoryLabel(Coupon coupon) {
    final cat = coupon.couponCategory.trim();
    if (cat.isNotEmpty) return cat;
    if ((coupon.productIds ?? const <String>[]).isNotEmpty) return 'Product Based';
    return 'General';
  }

  Widget _buildFilterPill({
    required BuildContext context,
    required String label,
    required String count,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = AdminAppTheme.isDark(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: selected ? (isDark ? 0.22 : 0.14) : (isDark ? 0.1 : 0.06)),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected
                  ? color
                  : color.withValues(alpha: isDark ? 0.28 : 0.2),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15.r,
                  color: selected ? color : color.withValues(alpha: 0.85)),
              SizedBox(width: 5.w),
              Text(label,
                  style: TextStyle(
                    fontSize: 12.sp.clamp(11.0, 13.0),
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? color
                        : AdminAppTheme.getTextPrimaryColor(context),
                  )),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: isDark ? 0.28 : 0.18)
                      : AdminAppTheme.getTextSecondaryColor(context)
                          .withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(count,
                    style: TextStyle(
                      fontSize: 11.sp.clamp(10.0, 12.0),
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? color
                          : AdminAppTheme.getTextPrimaryColor(context),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupons = widget.controller.coupons;
      final visibleCoupons = filterCatalogCoupons(
        coupons,
        widget.searchQuery,
        statusFilter: _statusFilter,
        categoryFilter: _categoryFilter,
      );
      final isLoading = widget.controller.isLoading.value;
      final error = widget.controller.error.value;
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
          onRetry: widget.controller.loadCoupons,
        );
      }

      if (coupons.isEmpty) {
        return AdminStateView.empty(
          title: 'No coupons yet',
          message: 'Tap Add Coupon to create your first discount code.',
          onRefresh: widget.controller.loadCoupons,
        );
      }

      return RefreshIndicator(
        onRefresh: widget.controller.loadCoupons,
        child: AdminResponsive.constrainContent(
          context: context,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AdminResponsive.pagePadding(context).copyWith(
              top: 12.h,
              bottom: AdminResponsive.bottomInset(context) + 78.h,
            ),
            children: [
              // Merged filter: status + category in one row
              SizedBox(
                height: 44.h.clamp(40.0, 48.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  separatorBuilder: (_, _) => SizedBox(width: 6.w),
                  itemBuilder: (context, index) {
                    if (index < 3) {
                      final items = [
                        ('all', 'All', '${coupons.length}', Icons.sell_outlined, AdminThemeTokens.toneBlue),
                        ('live', 'Live', '$liveCoupons', Icons.local_offer_rounded, AdminAppTheme.getSuccessColor(context)),
                        ('inactive', 'Inactive', '$inactiveCoupons', Icons.pause_circle_outline, AdminThemeTokens.toneNeutral),
                      ];
                      final (value, label, count, icon, color) = items[index];
                      return _buildFilterPill(
                        context: context,
                        label: label,
                        count: count,
                        icon: icon,
                        color: color,
                        selected: _statusFilter == value,
                        onTap: () => setState(() {
                          _statusFilter = value;
                          _categoryFilter = 'all';
                        }),
                      );
                    }
                    final categoryItems = [
                      ('General', 'General', '${coupons.where((c) => c.couponCategory == 'General').length}', Icons.local_offer_outlined, AdminThemeTokens.toneBlue),
                      ('Loyalty', 'Loyalty', '${coupons.where((c) => c.couponCategory == 'Loyalty').length}', Icons.star_outline, Colors.deepPurple),
                      ('Product Based', 'Product', '${coupons.where((c) => c.couponCategory == 'Product Based').length}', Icons.inventory_2_outlined, Colors.teal),
                      ('Seasonal', 'Seasonal', '${coupons.where((c) => c.couponCategory == 'Seasonal').length}', Icons.event_outlined, Colors.orange),
                    ];
                    final ci = categoryItems[index - 3];
                    return _buildFilterPill(
                      context: context,
                      label: ci.$2,
                      count: ci.$3,
                      icon: ci.$4,
                      color: ci.$5,
                      selected: _categoryFilter == ci.$1,
                      onTap: () => setState(() {
                        _categoryFilter = ci.$1;
                        _statusFilter = 'all';
                      }),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search coupon code or description',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AdminAppTheme.getBorderColor(context),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AdminAppTheme.getBorderColor(context),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AdminAppTheme.getSuccessColor(context),
                    ),
                  ),
                  filled: true,
                  fillColor: AdminAppTheme.getInputSurfaceColor(context),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: widget.onSearchChanged,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Coupons',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                  ),
                  Text(
                    '${visibleCoupons.length} items',
                    style: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              if (visibleCoupons.isEmpty)
                Card(
                  child: Padding(
                    padding: AdminResponsive.cardPadding(context),
                    child: Text(
                      widget.searchQuery.trim().isNotEmpty ||
                              _statusFilter != 'all'
                          ? 'No coupons matched the selected filters'
                          : 'No coupons to show',
                      style: AdminTextStyles.body(context),
                    ),
                  ),
                )
              else
                ...visibleCoupons.map(
                  (coupon) => _CatalogCouponCard(
                    coupon: coupon,
                    couponTypeLabel: _categoryLabel(coupon),
                    statusColor: catalogCouponStatusColor(context, coupon),
                    statusLabel: catalogCouponStatusLabel(coupon),
                    valueLabel: catalogCouponValueLabel(coupon),
                    onToggle: (value) =>
                        widget.controller.setCouponActive(coupon.code, value),
                    onEdit: () => widget.onEditCoupon(coupon),
                    onDelete: () => widget.onDeleteCoupon(coupon),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _CatalogCouponCard extends StatelessWidget {
  const _CatalogCouponCard({
    required this.coupon,
    required this.couponTypeLabel,
    required this.statusColor,
    required this.statusLabel,
    required this.valueLabel,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Coupon coupon;
  final String couponTypeLabel;
  final Color statusColor;
  final String statusLabel;
  final String valueLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _usageLabel => '${coupon.usedCount} used';

  String get _discountTypeLabel {
    if (coupon.type == 'PERCENTAGE_DISCOUNT') return 'Percentage';
    return 'Flat';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdminAppTheme.isDark(context);
    final cs = Theme.of(context).colorScheme;
    final accentAlpha = isDark ? 0.22 : 0.12;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 1 : 2,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: statusColor.withValues(alpha: isDark ? 0.35 : 0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onEdit,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 76.w.clamp(68.0, 84.0),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: accentAlpha),
                  border: Border(
                    right: BorderSide(
                      color: statusColor.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 20.r,
                      color: statusColor,
                    ),
                    SizedBox(height: 6.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        valueLabel,
                        style: TextStyle(
                          fontSize: 18.sp.clamp(15.0, 20.0),
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                          height: 1.05,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'OFF',
                      style: TextStyle(
                        fontSize: 10.sp.clamp(9.0, 11.0),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: statusColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 6.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40.h.clamp(36.0, 44.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                coupon.code,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.sp.clamp(13.0, 16.0),
                                  letterSpacing: 0.6,
                                  height: 1.2,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            Switch(
                              value: coupon.isActive,
                              onChanged: onToggle,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              iconSize: 22,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              splashRadius: 20,
                              tooltip: 'More',
                              icon: Icon(
                                Icons.more_vert,
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ),
                              ),
                              onSelected: (value) {
                                if (value == 'delete') onDelete();
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: AdminAppTheme.getErrorColor(
                                          context,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: AdminAppTheme.getErrorColor(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          CatalogInlineBadge(
                            label: statusLabel,
                            color: statusColor,
                          ),
                          CatalogInlineBadge(
                            label: _shortCouponTypeLabel(couponTypeLabel),
                            color: AdminThemeTokens.toneSlate,
                          ),
                          CatalogInlineBadge(
                            label: _discountTypeLabel,
                            color: AdminThemeTokens.toneBlue,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AdminThemeTokens.darkSurfaceVariant
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _CouponStatCell(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Min order',
                                value:
                                    '₹${coupon.minOrderAmount.toStringAsFixed(2)}',
                              ),
                            ),
                            _CouponStatDivider(isDark: isDark),
                            Expanded(
                              child: _CouponStatCell(
                                icon: Icons.people_outline,
                                label: 'Usage',
                                value: _usageLabel,
                              ),
                            ),
                            if (coupon.maxDiscount != null) ...[
                              _CouponStatDivider(isDark: isDark),
                              Expanded(
                                child: _CouponStatCell(
                                  icon: Icons.savings_outlined,
                                  label: 'Max off',
                                  value:
                                      '₹${coupon.maxDiscount!.toStringAsFixed(2)}',
                                ),
                              ),
                            ],
                          ],
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
    );
  }

  static String _shortCouponTypeLabel(String type) {
    switch (type) {
      case 'General':
        return 'General';
      case 'Loyalty':
        return 'Loyalty';
      case 'Product Based':
        return 'Product';
      case 'Seasonal':
        return 'Seasonal';
      default:
        return type;
    }
  }
}

class _CouponStatCell extends StatelessWidget {
  const _CouponStatCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12.r,
              color: AdminAppTheme.getTextSecondaryColor(context),
            ),
            SizedBox(width: 3.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.sp.clamp(8.0, 10.0),
                  fontWeight: FontWeight.w600,
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp.clamp(10.0, 12.0),
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _CouponStatDivider extends StatelessWidget {
  const _CouponStatDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: AdminAppTheme.getBorderColor(
        context,
      ).withValues(alpha: isDark ? 0.5 : 0.7),
    );
  }
}

// Bottom sheet dialogs below (unchanged from previous implementation)

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
      return       _CouponFormBottomSheet(
        onSave: (coupon, draft) async {
          await controller.uploadCoupon(coupon, notificationDraft: draft);
        },
        onSaveSuccess: () {
          AdminSnackbarService.show(sheetContext, 'Coupon created');
        },
        onSaveError: (error) {
          AdminSnackbarService.show(
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
  static const List<String> _categories = [
    'General',
    'Loyalty',
    'Product Based',
    'Seasonal',
  ];

  static const List<String> _discountTypes = [
    'Flat',
    'Percentage',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _discountValueCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _maxDiscountCtrl;
  late final TextEditingController _maxUsagePerUserCtrl;

  late final TextEditingController _productIdsCtrl;
  late final TextEditingController _notificationTitleCtrl;
  late final TextEditingController _notificationBodyCtrl;
  late final TextEditingController _notificationImageCtrl;

  late String _selectedCategory;
  late String _selectedDiscountType;
  late bool _isActive;
  bool _hasExpiry = false;
  DateTime? _startDate;
  DateTime? _endDate;
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
    _maxUsagePerUserCtrl = TextEditingController(
      text: coupon?.maxUsagePerUser?.toString() ?? '',
    );

    _productIdsCtrl = TextEditingController(
      text: (coupon?.productIds ?? const <String>[]).join(', '),
    );
    _notificationTitleCtrl = TextEditingController();
    _notificationBodyCtrl = TextEditingController(
      text: coupon == null
          ? 'Open FreshPickKart and save on your next order.'
          : '',
    );
    _notificationImageCtrl = TextEditingController();
    _selectedCategory = _deriveCategory(coupon);
    _selectedDiscountType = _deriveDiscountType(coupon);
    _isActive = coupon?.isActive ?? true;
    _sendNotification = coupon == null;
    if (coupon != null && coupon.startDate != null && (coupon.endDate != null || coupon.expiryDate != null)) {
      _hasExpiry = true;
      _startDate = coupon.startDate;
      _endDate = coupon.expiryDate ?? coupon.endDate;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _discountValueCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _maxUsagePerUserCtrl.dispose();

    _productIdsCtrl.dispose();
    _notificationTitleCtrl.dispose();
    _notificationBodyCtrl.dispose();
    _notificationImageCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final isPercentage = _selectedDiscountType == 'Percentage';
    final couponType =
        isPercentage ? 'PERCENTAGE_DISCOUNT' : 'FLAT_DISCOUNT';
    final maxDiscount = isPercentage && _maxDiscountCtrl.text.trim().isNotEmpty
        ? double.tryParse(_maxDiscountCtrl.text.trim())
        : null;

    final coupon = Coupon(
      id: widget.initialCoupon?.id ?? _codeCtrl.text.trim(),
      code: _codeCtrl.text.trim().toUpperCase(),
      description: _descCtrl.text.trim(),
      type: couponType,
      discountValue: double.parse(_discountValueCtrl.text.trim()),
      minOrderAmount: double.parse(_minOrderCtrl.text.trim()),
      maxDiscount: maxDiscount,
      maxDiscountAmount: maxDiscount,
      productIds: _selectedCategory == 'Product Based'
          ? _parseProductIds(_productIdsCtrl.text)
          : null,
      loyaltyRequiredOrders: null,
      startDate: _hasExpiry ? _startDate : null,
      endDate: _hasExpiry ? _endDate : null,
      expiryDate: _hasExpiry ? _endDate : null,
      maxUsagePerUser: _maxUsagePerUserCtrl.text.trim().isEmpty
          ? null
          : int.tryParse(_maxUsagePerUserCtrl.text.trim()),
      usedCount: widget.initialCoupon?.usedCount ?? 0,
      isActive: _isActive,
      couponCategory: _selectedCategory,
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
                style: TextStyle(
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
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
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isSaving ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AdminThemeTokens.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AdminAppTheme.getBorderColor(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AdminThemeTokens.toneBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18.sp.clamp(16.0, 20.0),
                color: AdminThemeTokens.toneBlue,
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
                      color: AdminAppTheme.getTextSecondaryColor(context),
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
    final isPercentage = _selectedDiscountType == 'Percentage';

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
              // 1. Coupon Code
              TextFormField(
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
                    (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              // 2. Description
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
              // 3. Coupon Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Coupon Category',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedCategory = value);
                },
              ),
              SizedBox(height: 16.h),
              // 4. Discount Type
              DropdownButtonFormField<String>(
                initialValue: _selectedDiscountType,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Discount Type',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: _discountTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedDiscountType = value);
                },
              ),
              SizedBox(height: 16.h),
              // 5. Discount Value
              TextFormField(
                controller: _discountValueCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: isPercentage
                      ? 'Discount Percentage'
                      : 'Discount Value',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixText: isPercentage ? '%' : null,
                ),
                validator: _catalogNumberValidator,
              ),
              const SizedBox(height: 16),
              // 6. Min Order + Max Discount (side by side)
              _CouponAdaptiveRow(
                children: [
                  TextFormField(
                    controller: _minOrderCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Min Order Amount',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixText: '₹',
                    ),
                    validator: _catalogNumberValidator,
                  ),
                  if (isPercentage)
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
                        hintText: 'Required',
                      ),
                      validator: isPercentage ? _catalogNumberValidator : null,
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              // 7. Max Uses Per User
              TextFormField(
                controller: _maxUsagePerUserCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Uses Per User',
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Leave empty for unlimited',
                ),
              ),
              SizedBox(height: 16.h),
              // 8. Active toggle
              SwitchListTile(
                contentPadding: EdgeInsets.only(left: 8.w),
                value: _isActive,
                dense: true,
                selected: _isActive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: AdminAppTheme.getBorderColor(context),
                  ),
                ),
                title: Text(
                  _isActive ? 'Active' : 'Inactive',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onChanged: (value) {
                  setState(() => _isActive = value);
                },
              ),
              SizedBox(height: 8.h),
              // 9. Expiry dates
              SwitchListTile(
                contentPadding: EdgeInsets.only(left: 8.w),
                title: const Text('Set Expiry Dates'),
                subtitle: Text(
                  _hasExpiry && _startDate != null && _endDate != null
                      ? 'Coupon runs from ${catalogDateLabel(_startDate!)} to ${catalogDateLabel(_endDate!)}'
                      : 'Coupon never expires until manually deactivated',
                  style: const TextStyle(fontSize: 12),
                ),
                value: _hasExpiry,
                onChanged: _isSaving
                    ? null
                    : (v) {
                        setState(() {
                          _hasExpiry = v;
                          if (v) {
                            _startDate ??= DateTime.now();
                            _endDate ??= DateTime.now().add(const Duration(days: 30));
                          }
                        });
                      },
              ),
              if (_hasExpiry) ...[
                SizedBox(height: 6.h),
                _CouponAdaptiveRow(
                  children: [
                    _buildDateCard(
                      label: 'Valid From',
                      value: _startDate,
                      onTap: () => _pickDate(true),
                    ),
                    _buildDateCard(
                      label: 'Valid Until',
                      value: _endDate,
                      onTap: () => _pickDate(false),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 16.h),
              // 10. Product Selection (only for Product Based category)
              if (_selectedCategory == 'Product Based') ...[
                TextFormField(
                  controller: _productIdsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product IDs',
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Comma separated product ids',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'At least one product is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
              ],
              // Notification section (create only)
              if (!isEditing) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.only(left: 8.w),
                  value: _sendNotification,
                  dense: true,
                  title: const Text(
                    'Send Notification',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) {
                    setState(() => _sendNotification = value);
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
              // Cancel / Save buttons
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
                      backgroundColor: AdminThemeTokens.toneBlue,
                    ),
                    child: _isSaving
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AdminThemeTokens.white,
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
      initialDate: isStartDate
          ? (_startDate ?? _endDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate!.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _deriveCategory(Coupon? coupon) {
    if (coupon?.couponCategory != null &&
        coupon!.couponCategory.trim().isNotEmpty &&
        _categories.contains(coupon.couponCategory)) {
      return coupon.couponCategory;
    }
    if ((coupon?.productIds ?? const <String>[]).isNotEmpty) {
      return 'Product Based';
    }
    return 'General';
  }

  String _deriveDiscountType(Coupon? coupon) {
    if (coupon?.type == 'PERCENTAGE_DISCOUNT') {
      return 'Percentage';
    }
    return 'Flat';
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
          AdminSnackbarService.show(sheetContext, 'Coupon updated');
        },
        onSaveError: (error) {
          AdminSnackbarService.show(sheetContext, 'Failed: $error');
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
  try {
    final result = await controller.deleteCoupon(coupon.code);
    if (!context.mounted) return;
    if (result == null) {
      AdminSnackbarService.showUndo(
        context,
        'Coupon permanently deleted',
        onUndo: () {},
      );
    } else if (result == true) {
      AdminSnackbarService.showUndo(
        context,
        'Coupon deactivated',
        onUndo: () {
          controller.setCouponActive(coupon.code, true);
        },
      );
    }
  } catch (error) {
    if (!context.mounted) return;
    AdminSnackbarService.show(context, 'Failed to delete coupon: $error');
  }
}

String? _catalogNumberValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return double.tryParse(value.trim()) == null ? 'Invalid number' : null;
}


