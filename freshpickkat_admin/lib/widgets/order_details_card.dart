import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';


class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = complaint.orderItems;
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
          if (orderDate != null)
            _InfoRow('Ordered At', orderDate),
          if (deliveryDate != null)
            _InfoRow('Delivered At', deliveryDate),
          if (items.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 6.h),
            Text(
              'Items (${items.length})',
              style: AdminTextStyles.cardTitle(context),
            ),
            SizedBox(height: 6.h),
            ...items.map((item) => _OrderItemRow(item: item)),
          ],
          if (items.isNotEmpty) ...[
            const Divider(),
            SizedBox(height: 6.h),
            _buildSummaryRow('Subtotal', _calcSubtotal(items), cs, bold: true),
            if ((complaint.discountAmount ?? 0) > 0)
              _buildSummaryRow('Discount', -(complaint.discountAmount ?? 0), cs,
                  color: Colors.green),
            if ((complaint.deliveryFee ?? 0) > 0)
              _buildSummaryRow('Delivery Fee', complaint.deliveryFee ?? 0, cs),
            const Divider(height: 12),
            _buildSummaryRow('Total Paid', complaint.finalAmount ?? 0, cs,
                bold: true, fontSize: 16.sp),
          ],
        ],
      ),
    );
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

  double _calcSubtotal(List<ComplaintProductItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.totalPrice));
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    ColorScheme cs, {
    bool bold = false,
    Color? color,
    double? fontSize,
  }) {
    final displayAmount = '₹${amount.toStringAsFixed(0)}';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              fontSize: fontSize?.clamp(12.0, 16.0) ?? 13.sp.clamp(11.0, 15.0),
              color: color ?? cs.onSurface,
            ),
          ),
          Text(
            amount >= 0 ? displayAmount : '−₹${(-amount).toStringAsFixed(0)}',
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

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final ComplaintProductItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
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
          Text(
            'x${item.quantity}',
            style: AdminTextStyles.caption(context),
          ),
          SizedBox(width: 12.w),
          Text(
            '₹${item.unitPrice.toStringAsFixed(0)}',
            style: AdminTextStyles.caption(context),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 80.w,
            child: Text(
              '₹${item.totalPrice.toStringAsFixed(0)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
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
