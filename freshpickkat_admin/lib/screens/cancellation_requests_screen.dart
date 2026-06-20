import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_cancellation_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class CancellationRequestsScreen extends StatefulWidget {
  const CancellationRequestsScreen({super.key});

  @override
  State<CancellationRequestsScreen> createState() =>
      _CancellationRequestsScreenState();
}

class _CancellationRequestsScreenState
    extends State<CancellationRequestsScreen> {
  late final AdminCancellationController _controller;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller =
        Get.isRegistered<AdminCancellationController>(tag: 'cancellation')
        ? Get.find<AdminCancellationController>(tag: 'cancellation')
        : Get.put(AdminCancellationController(), tag: 'cancellation');
    _controller.loadRequests();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_controller.isLoadingMore.value &&
        _controller.hasMore.value) {
      _controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: const Text('Cancellation Requests')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = _controller.error.value;
        if (error != null) {
          return AdminStateView.error(
            message: error,
            onRetry: _controller.loadRequests,
          );
        }
        if (_controller.orders.isEmpty) {
          return AdminStateView.empty(
            title: 'No cancellation requests',
            message: 'There are no pending cancellation requests.',
            onRefresh: _controller.loadRequests,
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.loadRequests,
          child: ListView.separated(
            controller: _scrollController,
            padding: AdminResponsive.pagePadding(
              context,
            ).copyWith(bottom: AdminResponsive.bottomInset(context)),
            itemCount:
                _controller.orders.length + (_controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              if (index >= _controller.orders.length) {
                return _buildLoadingIndicator();
              }
              final order = _controller.orders[index];
              return _CancellationOrderCard(
                order: order,
                onTap: () => _openDetailSheet(context, order),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(
      () => _controller.isLoadingMore.value
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            )
          : SizedBox(height: 16.h),
    );
  }

  void _openDetailSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return _CancellationDetailSheet(order: order, controller: _controller);
      },
    );
  }
}

class _CancellationDetailSheet extends StatefulWidget {
  const _CancellationDetailSheet({
    required this.order,
    required this.controller,
  });

  final Order order;
  final AdminCancellationController controller;

  @override
  State<_CancellationDetailSheet> createState() =>
      _CancellationDetailSheetState();
}

class _CancellationDetailSheetState extends State<_CancellationDetailSheet> {
  final _adminNoteController = TextEditingController();
  bool _approving = false;
  bool _rejecting = false;
  RefundRecord? _refund;

  @override
  void initState() {
    super.initState();
    if (widget.order.status == 'cancellation_approved') _loadRefund();
  }

  Future<void> _loadRefund() async {
    try {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      final r = await ServerpodAdminClient().client.refund.adminGetRefundStatus(
        widget.order.orderId,
        uid,
        token,
      );
      if (mounted) setState(() => _refund = r);
    } catch (_) {}
  }

  @override
  void dispose() {
    _adminNoteController.dispose();
    super.dispose();
  }

  Map<String, String> _parseCancellationReason() {
    final raw = widget.order.cancellationReason;
    if (raw == null || raw.isEmpty) return {'reason': '', 'originalStatus': ''};
    try {
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'reason': parsed['reason']?.toString() ?? '',
        'originalStatus': parsed['originalStatus']?.toString() ?? '',
      };
    } catch (_) {
      return {'reason': raw, 'originalStatus': ''};
    }
  }

  double _calculateRefund() {
    final reasonData = _parseCancellationReason();
    final originalStatus = reasonData['originalStatus'] ?? '';
    if (originalStatus == 'out_for_delivery') {
      return widget.order.finalAmount - widget.order.deliveryFee;
    }
    return widget.order.finalAmount;
  }

  Future<void> _handleApprove() async {
    final calculatedRefund = _calculateRefund();
    final overrideController = TextEditingController(
      text: calculatedRefund.toStringAsFixed(2),
    );
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Approve Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Calculated refund: \u20B9${calculatedRefund.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: overrideController,
                decoration: InputDecoration(
                  labelText: 'Refund Amount (override)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
    if (result != true) return;

    setState(() => _approving = true);
    try {
      final overrideAmount = double.tryParse(overrideController.text);
      final note = _adminNoteController.text;
      final actionResult = await widget.controller.approve(
        widget.order.orderId,
        adminNote: note,
        amountOverride: overrideAmount,
      );
      if (mounted) {
        Get.snackbar(
          'Approved',
          actionResult.message ?? 'Cancellation approved successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade800,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Navigator.pop(context);
        widget.controller.reload();
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to approve: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade800,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      if (mounted) setState(() => _approving = false);
    }
  }

  Future<void> _handleReject() async {
    final rejectNoteController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reject Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to reject this cancellation request?',
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: rejectNoteController,
                decoration: InputDecoration(
                  labelText: 'Admin Note (required)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (rejectNoteController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Note Required',
                    'Please provide a reason for rejection.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.shade800,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
    if (result != true) return;

    setState(() => _rejecting = true);
    try {
      final note = rejectNoteController.text;
      final actionResult = await widget.controller.reject(
        widget.order.orderId,
        adminNote: note,
      );
      if (mounted) {
        Get.snackbar(
          'Rejected',
          actionResult.message ?? 'Cancellation rejected.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Navigator.pop(context);
        widget.controller.reload();
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to reject: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade800,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      if (mounted) setState(() => _rejecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reasonData = _parseCancellationReason();
    final refundAmount = _calculateRefund();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      'Cancellation Details',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Divider(height: 1, color: cs.outlineVariant),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  children: [
                    _DetailPanel(
                      title: 'Order Information',
                      children: [
                        _DetailRow('Order ID', widget.order.orderId),
                        _DetailRow(
                          'Customer',
                          widget.order.userName ?? widget.order.userPhone,
                        ),
                        _DetailRow('Phone', widget.order.userPhone),
                        _DetailRow(
                          'Total',
                          '₹${widget.order.finalAmount.toStringAsFixed(2)}',
                        ),
                        _DetailRow(
                          'Delivery Fee',
                          '₹${widget.order.deliveryFee.toStringAsFixed(2)}',
                        ),
                        _DetailRow('Status', widget.order.status),
                        _DetailRow(
                          'Payment Status',
                          widget.order.paymentStatus,
                        ),
                        _DetailRow(
                          'Ordered At',
                          _formatDateTime(widget.order.orderedAt),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _DetailPanel(
                      title: 'Cancellation Reason',
                      children: [
                        if (reasonData['reason']!.isNotEmpty)
                          _DetailRow('Reason', reasonData['reason']!)
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              'No reason provided',
                              style: TextStyle(color: cs.onSurfaceVariant),
                            ),
                          ),
                        if (reasonData['originalStatus']!.isNotEmpty)
                          _DetailRow(
                            'Original Status',
                            reasonData['originalStatus']!,
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _DetailPanel(
                      title: 'Refund Calculation',
                      children: [
                        _DetailRow(
                          'Final Amount',
                          '₹${widget.order.finalAmount.toStringAsFixed(2)}',
                        ),
                        _DetailRow(
                          'Delivery Fee',
                          '₹${widget.order.deliveryFee.toStringAsFixed(2)}',
                        ),
                        _DetailRow(
                          'Refund Amount',
                          '₹${refundAmount.toStringAsFixed(2)}',
                        ),
                        if (reasonData['originalStatus'] == 'out_for_delivery')
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              'Delivery fee deducted (Stage 3)',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: cs.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              'Full refund (Stage 1/2)',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: cs.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (_refund != null) ...[
                      _DetailPanel(
                        title: 'Refund Status',
                        children: [
                          _DetailRow(
                            'Status',
                            _refundStatusLabel(_refund!.status),
                          ),
                          _DetailRow(
                            'Amount',
                            '₹${_refund!.amount.toStringAsFixed(2)}',
                          ),
                          _DetailRow('Refund ID', _refund!.refundId),
                          _DetailRow(
                            'Initiated',
                            _formatDateTime(_refund!.createdAt),
                          ),
                          _DetailRow('Expected', '5–7 Business Days'),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                    TextField(
                      controller: _adminNoteController,
                      decoration: InputDecoration(
                        labelText: 'Admin Note',
                        hintText: 'Add an internal note...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton.icon(
                              onPressed: _approving || _rejecting
                                  ? null
                                  : _handleApprove,
                              icon: _approving
                                  ? SizedBox(
                                      width: 16.r,
                                      height: 16.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check_circle_outline),
                              label: Text(
                                'Approve (₹${refundAmount.toStringAsFixed(2)})',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton.icon(
                              onPressed: _approving || _rejecting
                                  ? null
                                  : _handleReject,
                              icon: _rejecting
                                  ? SizedBox(
                                      width: 16.r,
                                      height: 16.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.cancel_outlined),
                              label: const Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  String _refundStatusLabel(String status) {
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
}

class _CancellationOrderCard extends StatelessWidget {
  const _CancellationOrderCard({required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chipColor = _cancellationStatusColor(order.status, cs);
    final reasonData = _parseReason(order.cancellationReason);

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${order.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text(
                  '₹${order.finalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14.r),
                SizedBox(width: 4.w),
                Text(
                  order.userName ?? order.userPhone,
                  style: AdminTextStyles.caption(context),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.shopping_bag_outlined, size: 14.r),
                SizedBox(width: 4.w),
                Text(
                  '${order.itemCount} items',
                  style: AdminTextStyles.caption(context),
                ),
              ],
            ),
            if (reasonData['reason']!.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                reasonData['reason']!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              children: [
                _statusChip(context, order.status, chipColor),
                const Spacer(),
                Text(
                  _formatDateTime(order.orderedAt),
                  style: AdminTextStyles.caption(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _cancellationStatusColor(String status, ColorScheme cs) {
    switch (status) {
      case 'cancellation_requested':
        return Colors.orange;
      case 'cancellation_approved':
        return Colors.green;
      case 'cancellation_rejected':
        return Colors.red;
      default:
        return cs.onSurface;
    }
  }

  Map<String, String> _parseReason(String? raw) {
    if (raw == null || raw.isEmpty) return {'reason': '', 'originalStatus': ''};
    try {
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'reason': parsed['reason']?.toString() ?? '',
        'originalStatus': parsed['originalStatus']?.toString() ?? '',
      };
    } catch (_) {
      return {'reason': raw, 'originalStatus': ''};
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          Text(title, style: AdminTextStyles.sectionTitle(context)),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: AdminTextStyles.caption(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
