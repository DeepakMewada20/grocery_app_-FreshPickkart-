import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_payment_monitoring_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
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
  final _scrollController = ScrollController();
  Map<String, dynamic>? _healthMetrics;
  bool _healthLoading = false;

  @override
  void initState() {
    super.initState();
    _controller =
        Get.isRegistered<AdminPaymentMonitoringController>(
          tag: 'payment_monitoring',
        )
        ? Get.find<AdminPaymentMonitoringController>(tag: 'payment_monitoring')
        : Get.put(
            AdminPaymentMonitoringController(),
            tag: 'payment_monitoring',
          );
    _controller.load();
    _scrollController.addListener(_onScroll);
    _loadHealthMetrics();
  }

  Future<void> _loadHealthMetrics() async {
    setState(() => _healthLoading = true);
    try {
      final json = await _controller.getPaymentHealthMetrics();
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      if (mounted) setState(() => _healthMetrics = decoded);
    } catch (_) {
      // Silently fail - health metrics are non-critical
    } finally {
      if (mounted) setState(() => _healthLoading = false);
    }
  }

  static const _orderStatuses = [
    '',
    'pending',
    'confirmed',
    'delivered',
    'cancelled',
  ];
  static const _paymentStatuses = [
    '',
    'pending',
    'verifying',
    'paid',
    'failed',
    'cancelled',
    'refunded',
  ];

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
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: const Text('Payment Monitoring')),
      body: Column(
        children: [
          if (_healthMetrics != null) _buildHealthBanner(context),
          _buildSearchBar(context),
          _buildFilterChips(context),
          _buildCodFilterChips(context),
          _buildCollectionModeChips(context),
          Expanded(child: _buildOrderList(context)),
        ],
      ),
    );
  }

  Widget _buildHealthBanner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pending = (_healthMetrics!['pendingPaymentCount'] as int?) ?? 0;
    final expired = (_healthMetrics!['expiredSessionCount'] as int?) ?? 0;
    final autoRefundPending =
        (_healthMetrics!['autoRefundPendingCount'] as int?) ?? 0;
    final autoRefundFailed =
        (_healthMetrics!['autoRefundFailedCount'] as int?) ?? 0;
    final duplicatesToday =
        (_healthMetrics!['duplicatePaymentCount'] as int?) ?? 0;
    final manualReview = (_healthMetrics!['manualReviewCount'] as int?) ?? 0;
    final needsAttention = expired + autoRefundFailed + manualReview;

    return Container(
      width: double.infinity,
      margin: AdminResponsive.pagePadding(context).copyWith(bottom: 0),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: needsAttention > 0
            ? cs.error.withValues(alpha: 0.08)
            : cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                needsAttention > 0
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                size: 18.r,
                color: needsAttention > 0 ? cs.error : cs.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                'Payment Health',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
              const Spacer(),
              if (_healthLoading)
                SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              InkWell(
                onTap: _loadHealthMetrics,
                child: Icon(Icons.refresh, size: 18.r),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 4.h,
            children: [
              _metricChip('Pending', pending, Colors.orange),
              _metricChip('Expired', expired, cs.error),
              _metricChip('Duplicates (today)', duplicatesToday, Colors.purple),
              _metricChip('Manual Review', manualReview, Colors.red),
              _metricChip(
                'Auto-Refund Pending',
                autoRefundPending,
                Colors.orange,
              ),
              _metricChip('Auto-Refund Failed', autoRefundFailed, cs.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: AdminResponsive.pagePadding(context).copyWith(bottom: 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by order, payment ID, phone or email...',
          prefixIcon: const Icon(Icons.search_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onChanged: _controller.onSearchChanged,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Padding(
      padding: AdminResponsive.pagePadding(context).copyWith(top: 8, bottom: 4),
      child: Obx(
        () => SingleChildScrollView(
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
        ),
      ),
    );
  }

  Widget _buildCodFilterChips(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All', '', _controller.codFilter, _controller.setCodFilter),
              _buildFilterChip('COD Pending', 'cod_pending', _controller.codFilter, _controller.setCodFilter),
              _buildFilterChip('COD Paid', 'cod_paid', _controller.codFilter, _controller.setCodFilter),
              _buildFilterChip('Online Paid', 'online_paid', _controller.codFilter, _controller.setCodFilter),
              _buildFilterChip('Link Pending', 'link_pending', _controller.codFilter, _controller.setCodFilter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionModeChips(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Collection: All', '', _controller.collectionModeFilter, _controller.setCollectionModeFilter),
              _buildFilterChip('Cash', 'cash', _controller.collectionModeFilter, _controller.setCollectionModeFilter),
              _buildFilterChip('UPI QR', 'upi_qr', _controller.collectionModeFilter, _controller.setCollectionModeFilter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, RxString currentFilter, void Function(String) onChanged) {
    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12.sp)),
        selected: currentFilter.value == value,
        onSelected: (_) => onChanged(value),
      ),
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
                    item.isEmpty
                        ? 'All'
                        : item[0].toUpperCase() + item.substring(1),
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
        return AdminStateView.error(message: error, onRetry: _controller.load);
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
            return _OrderCard(
              order: order,
              onTap: () => _openOrderDetail(context, order),
              onRazorpayDetails: () => _showRazorpayDetailSheet(context, order),
            );
          },
        ),
      );
    });
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

  Future<void> _openOrderDetail(BuildContext context, Order order) async {
    await Get.to(
      () => _PaymentOrderDetailScreen(order: order, controller: _controller),
    );
  }

  Future<void> _showRazorpayDetailSheet(
    BuildContext context,
    Order order,
  ) async {
    final razorpayPaymentId = order.razorpayPaymentId;
    if (razorpayPaymentId == null || razorpayPaymentId.isEmpty) {
      if (context.mounted) {
        AdminSnackbarService.show(context, 'No Razorpay payment ID available');
      }
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return _RazorpayDetailSheetContent(
          razorpayPaymentId: razorpayPaymentId,
          controller: _controller,
        );
      },
    );
  }
}

class _RazorpayDetailSheetContent extends StatefulWidget {
  const _RazorpayDetailSheetContent({
    required this.razorpayPaymentId,
    required this.controller,
  });

  final String razorpayPaymentId;
  final AdminPaymentMonitoringController controller;

  @override
  State<_RazorpayDetailSheetContent> createState() =>
      _RazorpayDetailSheetContentState();
}

class _RazorpayDetailSheetContentState
    extends State<_RazorpayDetailSheetContent> {
  RazorpayPaymentStatus? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await widget.controller.getLivePaymentStatus(
        widget.razorpayPaymentId,
      );
      if (mounted) setState(() => _data = data);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                      'Razorpay Payment Details',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _load,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Divider(height: 1, color: cs.outlineVariant),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            _error!,
                            style: TextStyle(color: cs.error),
                          ),
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        padding: EdgeInsets.all(16.w),
                        children: [
                          _rpField('Payment ID', _data!.id ?? '-'),
                          _rpField(
                            'Amount',
                            _data!.amount != null
                                ? _fmtAmount(_data!.amount)
                                : '-',
                          ),
                          _rpField('Currency', _data!.currency ?? '-'),
                          _rpField('Status', _data!.status ?? '-'),
                          _rpField('Order ID', _data!.orderId ?? '-'),
                          _rpField('Email', _data!.email ?? '-'),
                          _rpField('Contact', _data!.contact ?? '-'),
                          _rpField('Method', _data!.method ?? '-'),
                          _rpField('Description', _data!.description ?? '-'),
                          if (_data!.fee != null)
                            _rpField('Fee', _fmtAmount(_data!.fee)),
                          if (_data!.tax != null)
                            _rpField('Tax', _fmtAmount(_data!.tax)),
                          if (_data!.errorCode != null)
                            _rpField('Error Code', _data!.errorCode.toString()),
                          if (_data!.errorDescription != null)
                            _rpField(
                              'Error Description',
                              _data!.errorDescription.toString(),
                            ),
                          if (_data!.bank != null)
                            _rpField('Bank', _data!.bank.toString()),
                          if (_data!.cardId != null)
                            _rpField('Card ID', _data!.cardId.toString()),
                          if (_data!.wallet != null)
                            _rpField('Wallet', _data!.wallet.toString()),
                          if (_data!.vpa != null)
                            _rpField('VPA', _data!.vpa.toString()),
                          if (_data!.acquirerData != null)
                            _rpField(
                              'Acquirer Data',
                              _data!.acquirerData.toString(),
                            ),
                          if (_data!.createdAt != null)
                            _rpField(
                              'Created At',
                              _formatTimestamp(_data!.createdAt),
                            ),
                          if (_data!.notes != null)
                            _rpField('Notes', _data!.notes.toString()),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _rpField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
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

  String _formatTimestamp(int? ts) {
    if (ts != null) {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        ts * 1000,
        isUtc: true,
      ).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    }
    return ts.toString();
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.onRazorpayDetails,
  });

  final Order order;
  final VoidCallback onTap;
  final VoidCallback onRazorpayDetails;

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
                  'INR ${order.finalAmount.toStringAsFixed(2)}',
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
                  '${order.items.length} items',
                  style: AdminTextStyles.caption(context),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _statusChip(context, order.status, cs.primary),
                SizedBox(width: 6.w),
                _statusChip(context, order.paymentStatus, paymentStatusColor),
                const Spacer(),
                Text(
                  _formatDateTime(order.orderedAt),
                  style: AdminTextStyles.caption(context),
                ),
              ],
            ),
            if (order.razorpayPaymentId != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.payment, size: 14.r, color: cs.primary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      order.razorpayPaymentId!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: onRazorpayDetails,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14.r,
                            color: cs.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

class _PaymentOrderDetailScreenState extends State<_PaymentOrderDetailScreen> {
  PaymentOrderDetailHydrated? _hydrated;
  bool _loading = true;
  bool _reconciling = false;
  bool _reconcilingPaymentLink = false;
  List<Map<String, dynamic>>? _autoRefundJobs;
  bool _autoRefundLoading = false;
  String? _autoRefundError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await widget.controller.getPaymentOrderDetailHydrated(
        widget.order.orderId,
      );
      if (mounted) setState(() => _hydrated = data);
    } catch (e) {
      debugPrint('PaymentOrderDetailHydrated error: $e');
    }
    if (mounted) {
      setState(() => _loading = false);
      _loadAutoRefundJobs();
    }
  }

  Future<void> _loadAutoRefundJobs() async {
    setState(() {
      _autoRefundLoading = true;
      _autoRefundError = null;
    });
    try {
      final json = await widget.controller.getAutoRefundJobStatus(
        widget.order.orderId,
      );
      final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
      if (mounted) {
        setState(() {
          _autoRefundJobs = decoded.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      if (mounted) setState(() => _autoRefundError = e.toString());
    } finally {
      if (mounted) setState(() => _autoRefundLoading = false);
    }
  }

  Future<void> _reconcile() async {
    setState(() => _reconciling = true);
    try {
      final result = await widget.controller.reconcileAll();
      if (mounted) {
        AdminSnackbarService.show(context, result.message ?? 'Reconciliation complete');
        _load();
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Reconciliation failed: $e');
      }
    } finally {
      if (mounted) setState(() => _reconciling = false);
    }
  }

  Future<void> _reconcilePaymentLink() async {
    setState(() => _reconcilingPaymentLink = true);
    try {
      final json = await widget.controller.reconcilePaymentLink(
        widget.order.orderId,
      );
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      if (mounted) {
        AdminSnackbarService.show(context, decoded['message']?.toString() ?? 'Done');
        _load();
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Payment link reconcile failed: $e');
      }
    } finally {
      if (mounted) setState(() => _reconcilingPaymentLink = false);
    }
  }

  Future<void> _retryAutoRefund() async {
    try {
      final result = await widget.controller.retryAutoRefund(
        widget.order.orderId,
      );
      final decoded = jsonDecode(result) as Map<String, dynamic>;
      if (mounted) {
        AdminSnackbarService.show(context, decoded['message'] as String? ?? 'Retry initiated');
        _loadAutoRefundJobs();
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Retry failed: $e');
      }
    }
  }

  Future<void> _markAutoRefundReviewed() async {
    try {
      final result = await widget.controller.markAutoRefundReviewed(
        widget.order.orderId,
      );
      final decoded = jsonDecode(result) as Map<String, dynamic>;
      if (mounted) {
        AdminSnackbarService.show(context, decoded['message'] as String? ?? 'Marked as reviewed');
        _loadAutoRefundJobs();
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Mark reviewed failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: Text('Order #${widget.order.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AdminResponsive.pagePadding(
                context,
              ).copyWith(bottom: AdminResponsive.bottomInset(context)),
              children: [
                AdminResponsive.constrainContent(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrderInfoPanel(order: widget.order),
                      SizedBox(height: 12.h),
                      _PaymentTransactionPanel(
                        paymentTransaction: _hydrated?.paymentTransaction,
                        order: widget.order,
                      ),
                      SizedBox(height: 12.h),
                      _RazorpayLiveStatusPanel(
                        liveStatus: _hydrated?.razorpayLiveStatus,
                        loading: false,
                        onRefresh: _load,
                      ),
                      SizedBox(height: 12.h),
                      _StatusComparisonPanel(
                        order: widget.order,
                        paymentTransaction: _hydrated?.paymentTransaction,
                        razorpayLiveData: _hydrated?.razorpayLiveStatus,
                      ),
                      SizedBox(height: 12.h),
                      _RefundInfoPanel(
                        refundRecords: _hydrated?.refundRecords,
                        razorpayRefundData: _hydrated?.razorpayRefundData,
                        loading: false,
                        onRefresh: _load,
                      ),
                      SizedBox(height: 12.h),
                      _OrderTimelinePanel(order: widget.order),
                      SizedBox(height: 12.h),
                      _AutoRefundPanel(
                        jobs: _autoRefundJobs,
                        loading: _autoRefundLoading,
                        error: _autoRefundError,
                        onRetry: _retryAutoRefund,
                        onMarkReviewed: _markAutoRefundReviewed,
                        onRefresh: _loadAutoRefundJobs,
                      ),
                      SizedBox(height: 12.h),
                      _QuickActionsPanel(
                        order: widget.order,
                        onReconcile: _reconcile,
                        reconciling: _reconciling,
                        onReconcilePaymentLink: _reconcilePaymentLink,
                        reconcilingPaymentLink: _reconcilingPaymentLink,
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
        _InfoRow('Items', '${order.items.length}'),
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

  final PaymentTransaction? paymentTransaction;
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
        _InfoRow('Gateway Order ID', paymentTransaction!.gatewayOrderId ?? '-'),
        _InfoRow(
          'Gateway Payment ID',
          paymentTransaction!.gatewayPaymentId ?? '-',
        ),
        _InfoRow('Amount', paymentTransaction!.amount?.toString() ?? '-'),
        _InfoRow('Status', paymentTransaction!.paymentStatus ?? '-'),
        _InfoRow('Gateway Status', paymentTransaction!.gatewayStatus ?? '-'),
        _InfoRow('Failure Reason', paymentTransaction!.failureReason ?? 'None'),
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

  final RazorpayPaymentStatus? liveStatus;
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
              IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
            ],
          )
        else if (liveStatus!.error != null) ...[
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AdminAppTheme.getErrorColor(
                context,
              ).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AdminAppTheme.getErrorColor(context),
                      size: 16.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Failed to fetch live status',
                      style: TextStyle(
                        color: AdminAppTheme.getErrorColor(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _InfoRow('Error', liveStatus!.error.toString()),
                if (liveStatus!.statusCode != null)
                  _InfoRow('Status Code', liveStatus!.statusCode.toString()),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tap to retry',
                  style: AdminTextStyles.caption(context),
                ),
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
            ],
          ),
        ] else ...[
          _InfoRow('Payment ID', liveStatus!.id ?? '-'),
          _InfoRow('Status', liveStatus!.status ?? '-'),
          if (liveStatus!.amount != null)
            _InfoRow('Amount', _fmtAmount(liveStatus!.amount)),
          if (liveStatus!.orderId != null)
            _InfoRow('Order ID', liveStatus!.orderId.toString()),
          if (liveStatus!.method != null)
            _InfoRow('Method', liveStatus!.method.toString()),
          if (liveStatus!.captured != null)
            _InfoRow('Captured', liveStatus!.captured.toString()),
          if (liveStatus!.refundStatus != null)
            _InfoRow('Refund Status', liveStatus!.refundStatus.toString()),
          if (liveStatus!.amountRefunded != null &&
              liveStatus!.amountRefunded! > 0)
            _InfoRow('Amount Refunded', _fmtAmount(liveStatus!.amountRefunded)),
          if (liveStatus!.fee != null)
            _InfoRow('Razorpay Fee', _fmtAmount(liveStatus!.fee)),
          if (liveStatus!.tax != null)
            _InfoRow('GST', _fmtAmount(liveStatus!.tax)),
          if (liveStatus!.bank != null && liveStatus!.bank!.isNotEmpty)
            _InfoRow('Bank', liveStatus!.bank.toString()),
          if (liveStatus!.wallet != null && liveStatus!.wallet!.isNotEmpty)
            _InfoRow('Wallet', liveStatus!.wallet.toString()),
          if (liveStatus!.vpa != null && liveStatus!.vpa!.isNotEmpty)
            _InfoRow('UPI VPA', liveStatus!.vpa.toString()),
          if (liveStatus!.email != null && liveStatus!.email!.isNotEmpty)
            _InfoRow('Email', liveStatus!.email.toString()),
          if (liveStatus!.contact != null && liveStatus!.contact!.isNotEmpty)
            _InfoRow('Contact', liveStatus!.contact.toString()),
          if (liveStatus!.createdAt != null)
            _InfoRow('Created At', _formatRazorpayTs(liveStatus!.createdAt)),
          _InfoRow('Description', liveStatus!.description ?? '-'),
          if (liveStatus!.errorCode != null)
            _InfoRow('Error Code', liveStatus!.errorCode.toString()),
          if (liveStatus!.errorDescription != null)
            _InfoRow(
              'Error Description',
              liveStatus!.errorDescription.toString(),
            ),
        ],
      ],
    );
  }
}

String _formatRazorpayTs(int? ts) {
  if (ts != null) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      ts * 1000,
      isUtc: true,
    ).toLocal();
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
  return '-';
}

class _StatusComparisonPanel extends StatelessWidget {
  const _StatusComparisonPanel({
    required this.order,
    required this.paymentTransaction,
    required this.razorpayLiveData,
  });

  final Order order;
  final PaymentTransaction? paymentTransaction;
  final RazorpayPaymentStatus? razorpayLiveData;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final dbPaymentStatus = paymentTransaction?.paymentStatus ?? '-';
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
    required this.refundRecords,
    required this.razorpayRefundData,
    required this.loading,
    required this.onRefresh,
  });

  final List<RefundRecord>? refundRecords;
  final RazorpayRefundData? razorpayRefundData;
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
        else if (refundRecords == null || refundRecords!.isEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  'No refunds found',
                  style: AdminTextStyles.caption(context),
                ),
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
            ],
          )
        else ...[
          _InfoRow('Refund Count', '${refundRecords!.length}'),
          if (razorpayRefundData != null) ...[
            const Text(
              'Razorpay Refund Data:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4.h),
            SelectableText(
              razorpayRefundData.toString(),
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
    required this.onReconcilePaymentLink,
    required this.reconcilingPaymentLink,
  });

  final Order order;
  final VoidCallback onReconcile;
  final bool reconciling;
  final VoidCallback onReconcilePaymentLink;
  final bool reconcilingPaymentLink;

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
            ElevatedButton.icon(
              onPressed: reconcilingPaymentLink ? null : onReconcilePaymentLink,
              icon: reconcilingPaymentLink
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.link),
              label: const Text('Check Payment Link Status'),
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
                final url = uri.toString();
                AdminSnackbarService.show(context, 'URL copied: $url');
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

class _AutoRefundPanel extends StatelessWidget {
  const _AutoRefundPanel({
    required this.jobs,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onMarkReviewed,
    required this.onRefresh,
  });

  final List<Map<String, dynamic>>? jobs;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onMarkReviewed;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _InfoPanel(
      title: 'Auto-Refund (Duplicate Payment)',
      children: [
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          )
        else if (error != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: cs.error, size: 16.r),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'Failed to load: $error',
                      style: TextStyle(color: cs.error, fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              OutlinedButton(onPressed: onRefresh, child: const Text('Retry')),
            ],
          )
        else if (jobs == null || jobs!.isEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  'No auto-refund jobs found for this order',
                  style: AdminTextStyles.caption(context),
                ),
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
            ],
          )
        else ...[
          for (final job in jobs!) ...[
            _AutoRefundJobCard(
              job: job,
              onRetry: onRetry,
              onMarkReviewed: onMarkReviewed,
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ],
    );
  }
}

class _AutoRefundJobCard extends StatelessWidget {
  const _AutoRefundJobCard({
    required this.job,
    required this.onRetry,
    required this.onMarkReviewed,
  });

  final Map<String, dynamic> job;
  final VoidCallback onRetry;
  final VoidCallback onMarkReviewed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = job['jobStatus'] as String? ?? 'UNKNOWN';
    final amount = job['amount'] as num?;
    final lastError = job['lastError'] as String?;
    final attemptCount = job['attemptCount'] as int?;

    Color statusColor;
    switch (status) {
      case 'PENDING':
        statusColor = Colors.orange;
      case 'COMPLETED':
        statusColor = cs.primary;
      case 'FAILED':
        statusColor = cs.error;
      case 'MANUAL_REVIEW':
        statusColor = Colors.red;
      default:
        statusColor = cs.onSurface;
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              const Spacer(),
              if (attemptCount != null)
                Text(
                  'Attempt $attemptCount',
                  style: AdminTextStyles.caption(context),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          if (amount != null)
            _InfoRow('Gateway Amount', 'INR ${amount.toStringAsFixed(2)}'),
          if (lastError != null && lastError.isNotEmpty)
            _InfoRow('Last Error', lastError),
          SizedBox(height: 8.h),
          if (status == 'FAILED')
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.replay, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.error.withValues(alpha: 0.1),
                foregroundColor: cs.error,
              ),
            ),
          if (status == 'MANUAL_REVIEW')
            ElevatedButton.icon(
              onPressed: onMarkReviewed,
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: const Text('Mark Reviewed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary.withValues(alpha: 0.1),
                foregroundColor: cs.primary,
              ),
            ),
        ],
      ),
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

String _fmtAmount(dynamic value) {
  if (value == null) return '-';
  final amount = value is num ? value : (num.tryParse(value.toString()) ?? 0);
  return 'INR ${(amount / 100).toStringAsFixed(2)}';
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
            child: SelectableText(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
