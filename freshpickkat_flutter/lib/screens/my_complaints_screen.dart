import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart'
    deferred as complaint_detail_screen;
import 'package:freshpickkat_flutter/screens/orders_screen.dart'
    deferred as orders_screen;
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final _complaints = <Complaint>[];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  String? _nextPageToken;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool append = false}) async {
    if (append) {
      final token = _nextPageToken;
      if (token == null || _isLoadingMore) return;
      setState(() => _isLoadingMore = true);
      try {
        final page = await ProductComplaintService.instance.listMyComplaints(
          pageToken: token,
        );
        setState(() {
          _complaints.addAll(page.complaints);
          _nextPageToken = page.nextPageToken;
        });
      } catch (error) {
        AppLogger.error('MyComplaints', error);
        setState(() => _error = ErrorMessages.loadComplaintsFailed);
      } finally {
        if (mounted) setState(() => _isLoadingMore = false);
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final page = await ProductComplaintService.instance.listMyComplaints();
      setState(() {
        _complaints
          ..clear()
          ..addAll(page.complaints);
        _nextPageToken = page.nextPageToken;
      });
    } catch (error) {
      AppLogger.error('MyComplaints', error);
      setState(() => _error = ErrorMessages.loadComplaintsFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Complaints')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: _complaints.isEmpty
                  ? ListView(
                      padding: AppResponsive.pagePadding(context),
                      children: [
                        const SizedBox(height: 220),
                        const Center(child: Text('No complaints yet')),
                        _buildHowToComplainSection(cs),
                      ],
                    )
                  : ListView(
                      padding: AppResponsive.pagePadding(context).copyWith(
                        bottom: 24.h + MediaQuery.paddingOf(context).bottom,
                      ),
                      children: [
                        ..._buildComplaintItems(cs),
                        if (_nextPageToken != null)
                          AppResponsive.constrainContent(
                            context: context,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Center(
                                child: OutlinedButton(
                                  onPressed: _isLoadingMore
                                      ? null
                                      : () => _load(append: true),
                                  child: Text(
                                    _isLoadingMore
                                        ? 'Loading more...'
                                        : 'Load more',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_complaints.isNotEmpty)
                          _buildHowToComplainSection(cs),
                      ],
                    ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    final utc = DateTime.utc(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
    final local = utc.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }

  List<Widget> _buildComplaintItems(ColorScheme cs) {
    return List.generate(_complaints.length, (index) {
      final complaint = _complaints[index];
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: AppResponsive.constrainContent(
          context: context,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () async {
              await navigateDeferred(
                loadLibrary: complaint_detail_screen.loadLibrary,
                pageBuilder: () => complaint_detail_screen.ComplaintDetailScreen(
                  complaint: complaint,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      complaint.imageUrls.isNotEmpty
                          ? complaint.imageUrls.first
                          : (complaint.productImage ?? ''),
                      width: 56.r,
                      height: 56.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (complaint.productName ?? complaint.title),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${complaint.issueType} • ${_formatDate(complaint.createdAt)}',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.62),
                            fontSize: 12.sp,
                          ),
                        ),
                        if (complaint.status == 'Resolved' &&
                            complaint.resolutionType != null) ...[
                          SizedBox(height: 4.h),
                          _ResolutionBadge(label: complaint.resolutionType!),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StatusBadge(status: complaint.status),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHowToComplainSection(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Column(
        children: [
          Icon(Icons.help_outline, size: 24.sp, color: cs.primary),
          SizedBox(height: 8.h),
          Text(
            'How to Report an Issue',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            'You can report a product or delivery issue from your order details page. '
            'Go to My Orders, tap on a delivered order, and select "Report Product Issue".',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Go to My Orders'),
            onPressed: () async {
              await navigateDeferred(
                loadLibrary: orders_screen.loadLibrary,
                pageBuilder: () => orders_screen.OrdersScreen(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Resolved' => Colors.green,
      'Rejected' => Colors.redAccent,
      'Under Review' => Colors.blue,
      _ => Colors.orange,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _ResolutionBadge extends StatelessWidget {
  const _ResolutionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: cs.primary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
