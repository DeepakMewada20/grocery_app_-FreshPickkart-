import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_payment_monitoring_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class PaymentMonitoringScreen extends StatefulWidget {
  const PaymentMonitoringScreen({super.key});

  @override
  State<PaymentMonitoringScreen> createState() =>
      _PaymentMonitoringScreenState();
}

class _PaymentMonitoringScreenState extends State<PaymentMonitoringScreen> {
  late final AdminPaymentMonitoringController _controller;
  final _searchController = TextEditingController();

  static const _orderStatuses = ['', 'pending', 'confirmed', 'delivered', 'cancelled'];
  static const _paymentStatuses = [
    '',
    'pending',
    'verifying',
    'paid',
    'failed',
    'cancelled',
    'refunded',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<AdminPaymentMonitoringController>(
      tag: 'payment_monitoring',
    )
        ? Get.find<AdminPaymentMonitoringController>(tag: 'payment_monitoring')
        : Get.put(
            AdminPaymentMonitoringController(),
            tag: 'payment_monitoring',
          );
    _controller.load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: const Text('Payment Monitoring')),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          Expanded(child: _buildOrderList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: AdminResponsive.pagePadding(context).copyWith(bottom: 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by order number...',
          prefixIcon: const Icon(Icons.search_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        onChanged: _controller.onSearchChanged,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Padding(
      padding: AdminResponsive.pagePadding(context).copyWith(top: 8, bottom: 4),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterDropdown(
              context,
              label: _controller.statusFilter.value.isEmpty
                  ? 'Order Status'
                  : _controller.statusFilter.value,
              value: _controller.statusFilter.value,
              items: _orderStatuses,
              onChanged: _controller.setStatusFilter,
            ),
            SizedBox(width: 8.w),
            _filterDropdown(
              context,
              label: _controller.paymentStatusFilter.value.isEmpty
                  ? 'Payment Status'
                  : _controller.paymentStatusFilter.value,
              value: _controller.paymentStatusFilter.value,
              items: _paymentStatuses,
              onChanged: _controller.setPaymentStatusFilter,
            ),
          ],
        ),
      )),
    );
  }

  Widget _filterDropdown(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          hint: Text(label, style: AdminTextStyles.caption(context)),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.isEmpty ? 'All' : item[0].toUpperCase() + item.substring(1),
                    style: AdminTextStyles.body(context),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final error = _controller.error.value;
      if (error != null) {
        return AdminStateView.error(
          message: error,
          onRetry: _controller.load,
        );
      }
      if (_controller.orders.isEmpty) {
        return AdminStateView.empty(
          title: 'No orders found',
          message: 'Try adjusting your search or filters.',
          onRefresh: _controller.load,
        );
      }
      return RefreshIndicator(
        onRefresh: _controller.load,
        child: ListView.separated(
          padding: AdminResponsive.pagePadding(context),
          itemCount:
              _controller.orders.length + (_controller.hasMore.value ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            if (index >= _controller.orders.length) {
              return Center(
                child: OutlinedButton(
                  onPressed: _controller.isLoadingMore.value
                      ? null
                      : _controller.loadMore,
                  child: Text(
                    _controller.isLoadingMore.value
                        ? 'Loading...'
                        : 'Load more',
                  ),
                ),
              );
            }
            final order = _controller.orders[index];
            return _OrderCard(
              order: order,
              onTap: () => _openOrderDetail(context, order),
            );
          },
        ),
      );
    });
  }

  Future<void> _openOrderDetail(BuildContext context, Order order) async {
    await Get.to(
      () => _PaymentOrderDetailScreen(
        order: order,
        controller: _controller,
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final paymentStatusColor = _paymentStatusColor(order.paymentStatus, cs);
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
                  'INR ${order.finalAmount.toStringAsFixed(0)}',
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
            SizedBox(height: 8.h),
            Row(
              children: [
                _statusChip(context, order.status, cs.primary),
                SizedBox(width: 6.w),
                _statusChip(
                  context,
                  order.paymentStatus,
                  paymentStatusColor,
                ),
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
        style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _paymentStatusColor(String status, ColorScheme cs) {
    switch (status) {
      case 'paid':
        return cs.primary;
      case 'pending':
        return Colors.orange;
      case 'verifying':
        return Colors.blue;
      case 'failed':
      case 'cancelled':
        return cs.error;
      case 'refunded':
        return Colors.purple;
      default:
        return cs.onSurface;
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _PaymentOrderDetailScreen extends StatefulWidget {
  const _PaymentOrderDetailScreen({
    required this.order,
    required this.controller,
  });

  final Order order;
  final AdminPaymentMonitoringController controller;

  @override
  State<_PaymentOrderDetailScreen> createState() =>
      _PaymentOrderDetailScreenState();
}

class _PaymentOrderDetailScreenState
    extends State<_PaymentOrderDetailScreen> {
  Map<String, dynamic>? _paymentDetail;
  Map<String, dynamic>? _refundDetail;
  PaymentActionResult? _liveStatus;
  bool _loadingDetail = true;
  bool _loadingRefund = false;
  bool _loadingLiveStatus = false;
  bool _reconciling = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentDetail();
  }

  Future<void> _loadPaymentDetail() async {
    setState(() => _loadingDetail = true);
    try {
      final detail = await widget.controller.getPaymentDetail(
        widget.order.orderId,
      );
      if (mounted) setState(() => _paymentDetail = detail);
    } catch (_) {}
    if (mounted) setState(() => _loadingDetail = false);
  }

  Future<void> _loadLiveStatus() async {
    final razorpayPaymentId = _paymentDetail?['paymentTransaction']
        ?['gatewayPaymentId'] as String?;
    if (razorpayPaymentId == null || razorpayPaymentId.isEmpty) return;
    setState(() => _loadingLiveStatus = true);
    try {
      final status = await widget.controller.getLivePaymentStatus(
        razorpayPaymentId,
      );
      if (mounted) setState(() => _liveStatus = status);
    } catch (_) {}
    if (mounted) setState(() => _loadingLiveStatus = false);
  }

  Future<void> _loadRefundDetail() async {
    setState(() => _loadingRefund = true);
    try {
      final detail = await widget.controller.getRefundDetail(
        widget.order.orderId,
      );
      if (mounted) setState(() => _refundDetail = detail);
    } catch (_) {}
    if (mounted) setState(() => _loadingRefund = false);
  }

  Future<void> _reconcile() async {
    setState(() => _reconciling = true);
    try {
      final result = await widget.controller.reconcileAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Reconciliation complete'),
          ),
        );
        _loadPaymentDetail();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reconciliation failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _reconciling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: Text('Order #${widget.order.orderId}'),
        actions: [
          TextButton.icon(
            onPressed: _reconciling ? null : _reconcile,
            icon: _reconciling
                ? SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: const Text('Reconcile'),
          ),
        ],
      ),
      body: _loadingDetail
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AdminResponsive.pagePadding(context).copyWith(
                bottom: 28.h,
              ),
              children: [
                AdminResponsive.constrainContent(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrderInfoPanel(order: widget.order),
                      SizedBox(height: 12.h),
                      _PaymentTransactionPanel(
                        paymentTransaction: _paymentDetail?['paymentTransaction']
                            as Map<String, dynamic>?,
                        order: widget.order,
                      ),
                      SizedBox(height: 12.h),
                      _RazorpayLiveStatusPanel(
                        liveStatus: _liveStatus,
                        loading: _loadingLiveStatus,
                        onRefresh: _loadLiveStatus,
                      ),
                      SizedBox(height: 12.h),
                      _StatusComparisonPanel(
                        order: widget.order,
                        paymentTransaction: _paymentDetail?[
                                'paymentTransaction']
                            as Map<String, dynamic>?,
                        razorpayLiveData: _liveStatus,
                      ),
                      SizedBox(height: 12.h),
                      _RefundInfoPanel(
                        refundDetail: _refundDetail,
                        loading: _loadingRefund,
                        onRefresh: _loadRefundDetail,
                      ),
                      SizedBox(height: 12.h),
                      _OrderTimelinePanel(order: widget.order),
                      SizedBox(height: 12.h),
                      _QuickActionsPanel(
                        order: widget.order,
                        onReconcile: _reconcile,
                        reconciling: _reconciling,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _OrderInfoPanel extends StatelessWidget {
  const _OrderInfoPanel({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Order Information',
      children: [
        _InfoRow('Order ID', order.orderId),
        _InfoRow('Customer', order.userName ?? order.userPhone),
        _InfoRow('Phone', order.userPhone),
        _InfoRow('Amount', 'INR ${order.finalAmount.toStringAsFixed(2)}'),
        _InfoRow('Items', '${order.itemCount}'),
        _InfoRow('Status', order.status),
        _InfoRow('Payment Status', order.paymentStatus),
        _InfoRow('Refund Status', order.refundStatus),
        if (order.razorpayOrderId != null)
          _InfoRow('Razorpay Order ID', order.razorpayOrderId!),
        if (order.razorpayPaymentId != null)
          _InfoRow('Razorpay Payment ID', order.razorpayPaymentId!),
      ],
    );
  }
}

class _PaymentTransactionPanel extends StatelessWidget {
  const _PaymentTransactionPanel({
    required this.paymentTransaction,
    required this.order,
  });

  final Map<String, dynamic>? paymentTransaction;
  final Order order;

  @override
  Widget build(BuildContext context) {
    if (paymentTransaction == null) {
      return _InfoPanel(
        title: 'Payment Transaction',
        children: [
          Text(
            'No payment transaction record found',
            style: AdminTextStyles.caption(context),
          ),
        ],
      );
    }
    return _InfoPanel(
      title: 'Payment Transaction (DB)',
      children: [
        _InfoRow(
          'Gateway Order ID',
          paymentTransaction!['gatewayOrderId']?.toString() ?? '-',
        ),
        _InfoRow(
          'Gateway Payment ID',
          paymentTransaction!['gatewayPaymentId']?.toString() ?? '-',
        ),
        _InfoRow(
          'Amount',
          paymentTransaction!['amount']?.toString() ?? '-',
        ),
        _InfoRow(
          'Status',
          paymentTransaction!['paymentStatus']?.toString() ?? '-',
        ),
        _InfoRow(
          'Gateway Status',
          paymentTransaction!['gatewayStatus']?.toString() ?? '-',
        ),
        _InfoRow(
          'Failure Reason',
          paymentTransaction!['failureReason']?.toString() ?? 'None',
        ),
      ],
    );
  }
}

class _RazorpayLiveStatusPanel extends StatelessWidget {
  const _RazorpayLiveStatusPanel({
    required this.liveStatus,
    required this.loading,
    required this.onRefresh,
  });

  final PaymentActionResult? liveStatus;
  final bool loading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Razorpay Live Status',
      children: [
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          )
        else if (liveStatus == null)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tap to fetch live status from Razorpay',
                  style: AdminTextStyles.caption(context),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh,
              ),
            ],
          )
        else ...[
          _InfoRow('Payment ID', liveStatus!.paymentId ?? '-'),
          _InfoRow('Status', liveStatus!.status ?? '-'),
          if (liveStatus!.amount != null)
            _InfoRow(
              'Amount',
              'INR ${(liveStatus!.amount! / 100).toStringAsFixed(2)}',
            ),
          _InfoRow('Message', liveStatus!.message ?? '-'),
        ],
      ],
    );
  }
}

class _StatusComparisonPanel extends StatelessWidget {
  const _StatusComparisonPanel({
    required this.order,
    required this.paymentTransaction,
    required this.razorpayLiveData,
  });

  final Order order;
  final Map<String, dynamic>? paymentTransaction;
  final PaymentActionResult? razorpayLiveData;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final dbPaymentStatus = paymentTransaction?['paymentStatus']?.toString() ?? '-';
    final orderPaymentStatus = order.paymentStatus;
    final razorpayStatus = razorpayLiveData?.status ?? '-';

    final dbOk = _isSuccessStatus(dbPaymentStatus);
    final orderOk = _isSuccessStatus(orderPaymentStatus);
    final razorpayOk = _isSuccessStatus(razorpayStatus);

    final mismatch =
        (dbOk != orderOk) || (razorpayOk != dbOk && razorpayStatus != '-');

    return _InfoPanel(
      title: 'Status Comparison',
      children: [
        if (!mismatch)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: cs.primary, size: 18.r),
                SizedBox(width: 6.w),
                Text(
                  'All statuses consistent',
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: cs.error, size: 18.r),
                SizedBox(width: 6.w),
                Text(
                  'Status mismatch detected',
                  style: TextStyle(
                    color: cs.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        _InfoRow('Order Payment Status', orderPaymentStatus),
        _InfoRow('Transaction Status', dbPaymentStatus),
        _InfoRow('Razorpay Status', razorpayStatus),
      ],
    );
  }

  bool _isSuccessStatus(String status) {
    return status == 'paid' || status == 'captured';
  }
}

class _RefundInfoPanel extends StatelessWidget {
  const _RefundInfoPanel({
    required this.refundDetail,
    required this.loading,
    required this.onRefresh,
  });

  final Map<String, dynamic>? refundDetail;
  final bool loading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Refund Information',
      children: [
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          )
        else if (refundDetail == null || refundDetail!.isEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tap to check refunds',
                  style: AdminTextStyles.caption(context),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh,
              ),
            ],
          )
        else ...[
          _InfoRow('Refund Count', '${refundDetail!['refunds']?.length ?? 0}'),
          if (refundDetail!['razorpayRefundData'] != null) ...[
            const Text(
              'Razorpay Refund Data:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4.h),
            Text(
              refundDetail!['razorpayRefundData'].toString(),
              style: AdminTextStyles.caption(context),
            ),
          ],
        ],
      ],
    );
  }
}

class _OrderTimelinePanel extends StatelessWidget {
  const _OrderTimelinePanel({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final events = <_TimelineEvent>[
      _TimelineEvent('Ordered', order.orderedAt),
      if (order.confirmedAt != null)
        _TimelineEvent('Confirmed', order.confirmedAt!),
      if (order.outForDeliveryAt != null)
        _TimelineEvent('Out for Delivery', order.outForDeliveryAt!),
      if (order.deliveredAt != null)
        _TimelineEvent('Delivered', order.deliveredAt!),
      if (order.cancelledAt != null)
        _TimelineEvent('Cancelled', order.cancelledAt!),
    ];

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return _InfoPanel(
      title: 'Order Timeline',
      children: [
        for (final event in events)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8.r),
                SizedBox(width: 10.w),
                Text(
                  '${event.label}: ${_formatDt(event.dateTime)}',
                  style: AdminTextStyles.body(context),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDt(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}

class _TimelineEvent {
  final String label;
  final DateTime dateTime;
  const _TimelineEvent(this.label, this.dateTime);
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({
    required this.order,
    required this.onReconcile,
    required this.reconciling,
  });

  final Order order;
  final VoidCallback onReconcile;
  final bool reconciling;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Admin Actions',
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ElevatedButton.icon(
              onPressed: reconciling ? null : onReconcile,
              icon: reconciling
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: const Text('Reconcile All Pending'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                final uri = Uri(
                  scheme: 'https',
                  host: 'dashboard.razorpay.com',
                  pathSegments: [
                    'app',
                    'payments',
                    order.razorpayPaymentId ?? order.razorpayOrderId ?? '',
                  ],
                );
                // Copy the URL to clipboard
                final url = uri.toString();
                final snack = SnackBar(
                  content: Text('URL copied: $url'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
              icon: const Icon(Icons.open_in_new_outlined),
              label: const Text('Open Razorpay'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({this.title, required this.children});

  final String? title;
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
          if (title != null) ...[
            Text(title!, style: AdminTextStyles.sectionTitle(context)),
            SizedBox(height: 10.h),
          ],
          ...children,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(label, style: AdminTextStyles.caption(context)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
