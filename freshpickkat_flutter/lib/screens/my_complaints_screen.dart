import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

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
                padding: EdgeInsets.all(24.r),
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
                      children: const [
                        SizedBox(height: 220),
                        Center(child: Text('No complaints yet')),
                      ],
                    )
                  : ListView.separated(
                      padding: AppResponsive.pagePadding(context).copyWith(
                        bottom: 24.h + MediaQuery.paddingOf(context).bottom,
                      ),
                      itemCount: _complaints.length +
                          (_nextPageToken != null ? 1 : 0),
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (index >= _complaints.length) {
                          return AppResponsive.constrainContent(
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
                          );
                        }
                        final complaint = _complaints[index];
                        return AppResponsive.constrainContent(
                          context: context,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            onTap: () => Get.to(
                              () => ComplaintDetailScreen(complaint: complaint),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(14.r),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (complaint.productName ??
                                              complaint.title),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                    Text(
                                      '${complaint.issueType} • ${_formatDate(complaint.createdAt)}',
                                      style: TextStyle(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.62,
                                        ),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    if (complaint.status == 'Resolved' &&
                                        complaint.resolutionType != null) ...[
                                      SizedBox(height: 4.h),
                                      _ResolutionBadge(
                                          label: complaint.resolutionType!),
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
                        );
                      },
                    ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
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
