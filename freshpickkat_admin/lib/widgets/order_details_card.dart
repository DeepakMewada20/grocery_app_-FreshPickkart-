import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/utils/order_item_grouping.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = complaint.orderItems;
    final grouped = groupAdminComplaintItems(items);
    final orderDate = _formatDate(complaint.orderedAt);
    final deliveryDate = _formatDate(complaint.deliveredAt);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Details', style: AdminTextStyles.sectionTitle(context)),
          SizedBox(height: 10.h),
          _InfoRow('Order Number', '#${complaint.orderNumber}'),
          if (orderDate != null) _InfoRow('Ordered At', orderDate),
          if (deliveryDate != null) _InfoRow('Delivered At', deliveryDate),
          if (items.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 6.h),
            Text(
              'Items (${_itemCount(items)})',
              style: AdminTextStyles.cardTitle(context),
            ),
            SizedBox(height: 6.h),
            ..._buildGroupedItems(context, grouped),
          ],
          if (items.isNotEmpty) ...[
            const Divider(),
            SizedBox(height: 6.h),
            ..._buildBillRows(context, cs),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildGroupedItems(
    BuildContext context,
    AdminGroupedComplaintSections grouped,
  ) {
    return [
      if (grouped.bogoGroups.isNotEmpty) ...[
        _SectionTitle('BOGO Offers'),
        ...grouped.bogoGroups.map(
          (group) =>
              _ComplaintItemRow(item: group.item, freeItems: group.freeItems),
        ),
      ],
      if (grouped.comboGroups.isNotEmpty) ...[
        _SectionTitle('Combo Offers'),
        ...grouped.comboGroups.map(
          (group) => _ComplaintComboGroup(group: group),
        ),
      ],
      if (grouped.individualItems.isNotEmpty) ...[
        _SectionTitle('Individual Items'),
        ...grouped.individualItems.map((item) => _ComplaintItemRow(item: item)),
      ],
    ];
  }

  List<Widget> _buildBillRows(BuildContext context, ColorScheme cs) {
    final mrpTotal = (complaint.mrpTotal ?? 0) > 0
        ? complaint.mrpTotal!
        : complaint.totalAmount ?? _calcSubtotal(complaint.orderItems);
    final productDiscount = complaint.productDiscountAmount ?? 0;
    final comboDiscount = complaint.comboDiscountAmount ?? 0;
    final bogoDiscount = complaint.bogoDiscountAmount ?? 0;
    final couponDiscount = complaint.discountAmount ?? 0;
    final deliveryFee = complaint.deliveryFee ?? 0;
    final deliveryDiscount = complaint.deliveryDiscountAmount ?? 0;
    final freeDeliveryApplied = complaint.freeDeliveryApplied ?? false;

    return [
      _buildSummaryRow('MRP Total', mrpTotal, cs),
      if (productDiscount > 0)
        _buildSummaryRow(
          'Product Discount',
          -productDiscount,
          cs,
          color: AdminAppTheme.getSuccessColor(context),
        ),
      if (comboDiscount > 0)
        _buildSummaryRow(
          'Combo Savings',
          -comboDiscount,
          cs,
          color: AdminAppTheme.getSuccessColor(context),
        ),
      _buildSummaryRow(
          'BOGO Savings',
          -bogoDiscount,
          cs,
          color: AdminAppTheme.getSuccessColor(context),
        ),
      _buildSummaryRow(
        'Items Total',
        complaint.totalAmount ?? _calcSubtotal(complaint.orderItems),
        cs,
      ),
      if (couponDiscount > 0)
        _buildSummaryRow(
          complaint.couponApplied?.isNotEmpty == true
              ? 'Coupon (${complaint.couponApplied})'
              : 'Coupon',
          -couponDiscount,
          cs,
          color: AdminAppTheme.getSuccessColor(context),
        ),
      _buildSummaryRow('Delivery Fee', deliveryFee, cs),
      if (freeDeliveryApplied && deliveryDiscount > 0)
        _buildSummaryRow(
          'Delivery Fee Waived',
          -deliveryDiscount,
          cs,
          color: AdminAppTheme.getSuccessColor(context),
        ),
      const Divider(height: 12),
      _buildSummaryRow(
        'To Pay',
        complaint.finalAmount ?? 0,
        cs,
        bold: true,
        fontSize: 16.sp,
      ),
    ];
  }

  String? _formatDate(DateTime? dt) {
    if (dt == null) return null;
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  static int _itemCount(List<ComplaintProductItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double _calcSubtotal(List<ComplaintProductItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    ColorScheme cs, {
    bool bold = false,
    Color? color,
    double? fontSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                fontSize:
                    fontSize?.clamp(12.0, 16.0) ?? 13.sp.clamp(11.0, 15.0),
                color: color ?? cs.onSurface,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            amount >= 0
                ? '₹${amount.toStringAsFixed(2)}'
                : '-₹${(-amount).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: fontSize?.clamp(12.0, 16.0) ?? 13.sp.clamp(11.0, 15.0),
              color: color ?? cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 4.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp.clamp(11.0, 14.0),
        ),
      ),
    );
  }
}

class _ComplaintComboGroup extends StatelessWidget {
  const _ComplaintComboGroup({required this.group});

  final AdminGroupedComplaintCombo group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${group.name} x${group.bundleQuantity}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          ...group.items.map((item) => _ComplaintItemLine(item: item)),
        ],
      ),
    );
  }
}

class _ComplaintItemRow extends StatelessWidget {
  const _ComplaintItemRow({required this.item, this.freeItems = const []});

  final ComplaintProductItem item;
  final List<ComplaintProductItem> freeItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          _ComplaintItemLine(item: item),
          ...freeItems.map(
            (freeItem) => Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: Row(
                children: [
                  SizedBox(width: 50.r),
                  Expanded(
                    child: Text(
                      'FREE: ${freeItem.productName} x${freeItem.quantity}',
                      style: TextStyle(
                        color: AdminAppTheme.getSuccessColor(context),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp.clamp(10.0, 13.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintItemLine extends StatelessWidget {
  const _ComplaintItemLine({required this.item});

  final ComplaintProductItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            item.productImage,
            width: 40.r,
            height: 40.r,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Icon(Icons.image_not_supported_outlined, size: 40.r),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (item.variantLabel?.isNotEmpty == true)
                Text(
                  item.variantLabel!,
                  style: AdminTextStyles.caption(context),
                ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Text('x${item.quantity}', style: AdminTextStyles.caption(context)),
        SizedBox(width: 12.w),
        Text(
          '₹${item.unitPrice.toStringAsFixed(2)}',
          style: AdminTextStyles.caption(context),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 80.w,
          child: Text(
'₹${item.totalPrice.toStringAsFixed(2)}',
    textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 130.w,
            child: Text(label, style: AdminTextStyles.caption(context)),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
