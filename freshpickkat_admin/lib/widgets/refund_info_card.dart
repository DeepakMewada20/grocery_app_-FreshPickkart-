import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class RefundInfoCard extends StatelessWidget {
  const RefundInfoCard({super.key, required this.refund, this.retryButton});

  final RefundRecord refund;
  final Widget? retryButton;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
      case 'refunded':
        return Colors.green;
      case 'pending':
      case 'initiated':
        return Colors.orange;
      case 'failed':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
      case 'refunded':
        return 'Completed';
      case 'pending':
      case 'initiated':
        return 'Initiated';
      case 'failed':
        return 'Failed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = _statusColor(refund.status);
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
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Refund Information',
                style: AdminTextStyles.sectionTitle(context),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _row('Status', _statusLabel(refund.status), statusColor, context),
          SizedBox(height: 8.h),
          _row('Amount', '₹${refund.amount.toStringAsFixed(2)}', null, context),
          SizedBox(height: 8.h),
          _row('Refund ID', refund.refundId, null, context),
          SizedBox(height: 8.h),
          _row('Initiated', _formatDate(refund.createdAt), null, context),
          SizedBox(height: 8.h),
          _row('Expected', '2–5 Business Days', null, context),
          if (retryButton != null) ...[SizedBox(height: 16.h), retryButton!],
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value,
    Color? valueColor,
    BuildContext context,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 130.w,
          child: Text(label, style: AdminTextStyles.caption(context)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? cs.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }
}
