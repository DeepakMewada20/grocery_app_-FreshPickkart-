import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart'
    deferred as complaint_detail_screen;
import 'package:freshpickkat_flutter/screens/orders_screen.dart'
    deferred as orders_screen;
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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
                padding: AppSpacing.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    SizedBox(height: ScreenScale.h(12)),
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
                        bottom: ScreenScale.h(24) + MediaQuery.paddingOf(context).bottom,
                      ),
                      children: [
                        ..._buildComplaintItems(cs),
                        if (_nextPageToken != null)
                          AppResponsive.constrainContent(
                            context: context,
                            child: Padding(
                              padding: AppSpacing.symmetric(vertical: 8),
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
    final utc = DateTime.utc(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
    final local = utc.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }

  List<Widget> _buildComplaintItems(ColorScheme cs) {
    return List.generate(_complaints.length, (index) {
      final complaint = _complaints[index];
      return Padding(
        padding: AppSpacing.only(bottom: 10),
        child: AppResponsive.constrainContent(
          context: context,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            onTap: () async {
              await navigateDeferred(
                loadLibrary: complaint_detail_screen.loadLibrary,
                pageBuilder: () =>
                    complaint_detail_screen.ComplaintDetailScreen(
                      complaint: complaint,
                    ),
              );
            },
            child: Container(
              padding: AppSpacing.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: Image.network(
                      complaint.imageUrls.isNotEmpty
                          ? complaint.imageUrls.first
                          : (complaint.productImage ?? ''),
                      width: ScreenScale.r(56),
                      height: ScreenScale.r(56),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(12)),
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
                        SizedBox(height: ScreenScale.h(4)),
                        Text(
                          '${complaint.issueType} • ${_formatDate(complaint.createdAt)}',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.62),
                            fontSize: ScreenScale.sp(12),
                          ),
                        ),
                        if (complaint.status == 'Resolved' &&
                            complaint.resolutionType != null) ...[
                          SizedBox(height: ScreenScale.h(4)),
                          _ResolutionBadge(label: complaint.resolutionType!),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(8)),
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
      padding: AppSpacing.only(top: 24, bottom: 12),
      child: Column(
        children: [
          Icon(Icons.help_outline, size: ScreenScale.sp(24), color: cs.primary),
          SizedBox(height: ScreenScale.h(8)),
          Text(
            'How to Report an Issue',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenScale.sp(15)),
          ),
          SizedBox(height: ScreenScale.h(6)),
          Text(
            'You can report a product or delivery issue from your order details page. '
            'Go to My Orders, tap on a delivered order, and select "Report Product Issue".',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontSize: ScreenScale.sp(13),
            ),
          ),
          SizedBox(height: ScreenScale.h(12)),
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
      'Pending Refund' => Colors.deepOrange,
      'Pending Redelivery' => Colors.blueGrey,
      _ => Colors.orange,
    };
    return Container(
      padding: AppSpacing.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: ScreenScale.sp(11),
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
      padding: AppSpacing.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: cs.primary,
          fontSize: ScreenScale.sp(10),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
