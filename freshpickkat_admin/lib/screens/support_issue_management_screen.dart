import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_support_issue_controller.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class SupportIssueManagementScreen extends StatefulWidget {
  const SupportIssueManagementScreen({super.key});

  @override
  State<SupportIssueManagementScreen> createState() =>
      _SupportIssueManagementScreenState();
}

class _SupportIssueManagementScreenState
    extends State<SupportIssueManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _statuses = ['Pending', 'In Review', 'Resolved', 'Closed'];

  late final TabController _tabController;
  late final AdminSupportIssueController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<AdminSupportIssueController>(
          tag: 'support_issue_management',
        )
        ? Get.find<AdminSupportIssueController>(tag: 'support_issue_management')
        : Get.put(
            AdminSupportIssueController(),
            tag: 'support_issue_management',
          );
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.load(status: _statuses[_tabController.index]);
      }
    });
    _controller.load(status: _statuses.first);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Support Issues'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.6),
          tabs: _statuses.map((s) => Tab(text: s)).toList(),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = _controller.error.value;
        if (error != null) {
          return AdminStateView.error(
            message: error,
            onRetry: () => _controller.load(status: _controller.statusFilter),
          );
        }
        if (_controller.issues.isEmpty) {
          return AdminStateView.empty(
            title: 'No issues',
            message:
                'No ${(_controller.statusFilter ?? 'pending').toLowerCase()} support issues.',
          );
        }
        return RefreshIndicator(
          onRefresh: () => _controller.load(status: _controller.statusFilter),
          child: ListView.separated(
            padding: AdminResponsive.pagePadding(context).copyWith(
              bottom: AdminResponsive.bottomInset(context),
            ),
            itemCount:
                _controller.issues.length + (_controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              if (index >= _controller.issues.length) {
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
              final issue = _controller.issues[index];
              return _SupportIssueCard(
                issue: issue,
                onTap: () async {
                  await Get.to(
                    () => _SupportIssueDetailScreen(
                      issue: issue,
                      controller: _controller,
                    ),
                  );
                  if (mounted) {
                    _controller.load(status: _controller.statusFilter);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _SupportIssueCard extends StatelessWidget {
  const _SupportIssueCard({required this.issue, required this.onTap});

  final SupportIssue issue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final issueColor = _issueTypeColor(issue.issueType, cs);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: issueColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _issueTypeIcon(issue.issueType),
                  color: issueColor,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        _Chip(issue.issueType, issueColor),
                        _Chip(
                          'v${issue.appVersion}',
                          cs.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatDate(issue.createdAt),
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '#${issue.issueId.length >= 8 ? issue.issueId.substring(0, 8) : issue.issueId}',
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 11.sp,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _issueTypeColor(String type, ColorScheme cs) {
  switch (type) {
    case 'App Crash':
      return cs.error;
    case 'Payment Issue':
      return Colors.deepOrange;
    case 'Login Problem':
      return Colors.indigo;
    case 'UI Bug':
      return Colors.teal;
    case 'Performance Problem':
      return Colors.amber.shade700;
    case 'Notifications Problem':
      return Colors.blue;
    default:
      return cs.onSurface;
  }
}

IconData _issueTypeIcon(String type) {
  switch (type) {
    case 'App Crash':
      return Icons.bug_report;
    case 'Payment Issue':
      return Icons.payment;
    case 'Login Problem':
      return Icons.login;
    case 'UI Bug':
      return Icons.design_services;
    case 'Performance Problem':
      return Icons.speed;
    case 'Notifications Problem':
      return Icons.notifications_off;
    default:
      return Icons.help_outline;
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  final utc = DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  final local = utc.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year;
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}

class _SupportIssueDetailScreen extends StatefulWidget {
  const _SupportIssueDetailScreen({
    required this.issue,
    required this.controller,
  });

  final SupportIssue issue;
  final AdminSupportIssueController controller;

  @override
  State<_SupportIssueDetailScreen> createState() =>
      _SupportIssueDetailScreenState();
}

class _SupportIssueDetailScreenState extends State<_SupportIssueDetailScreen> {
  late SupportIssue _issue;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _issue = widget.issue;
  }

  Future<void> _updateStatus(String status) async {
    setState(() => _busy = true);
    try {
      final updated = await widget.controller.updateStatus(_issue, status);
      if (mounted) setState(() => _issue = updated);
      if (mounted) {
        AdminSnackbarService.show(context, 'Status updated to $status');
      }
    } catch (error) {
      if (mounted) {
        AdminSnackbarService.show(context, error.toString());
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  List<({String label, String status, bool primary})> _availableActions() {
    switch (_issue.status) {
      case 'Pending':
        return [
          (label: 'Mark In Review', status: 'In Review', primary: true),
        ];
      case 'In Review':
        return [
          (label: 'Mark Resolved', status: 'Resolved', primary: true),
          (label: 'Mark Closed', status: 'Closed', primary: false),
        ];
      case 'Resolved':
      case 'Closed':
        return [
          (_issue.status == 'Resolved'
              ? (label: 'Mark Closed', status: 'Closed', primary: false)
              : (label: 'Reopen', status: 'Pending', primary: true)),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final actions = _availableActions();

    return Scaffold(
      appBar: AdminAppBar(
        title: Text('#${_shortId(_issue.issueId)}'),
      ),
      body: ListView(
        padding: AdminResponsive.pagePadding(context).copyWith(
          bottom: AdminResponsive.bottomInset(context),
        ),
        children: [
          AdminResponsive.constrainContent(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoPanel(
                  children: [
                    _InfoRow('Issue ID', _issue.issueId),
                    _InfoRow('Type', _issue.issueType),
                    _InfoRow('Status', _issue.status),
                    _InfoRow('User ID', _issue.userId),
                    _InfoRow('Created', _formatDate(_issue.createdAt)),
                    _InfoRow('Updated', _formatDate(_issue.updatedAt)),
                  ],
                ),
                SizedBox(height: 12.h),
                _InfoPanel(
                  title: _issue.title,
                  children: [
                    Text(
                      _issue.description,
                      style: TextStyle(fontSize: 14.sp, height: 1.5),
                    ),
                  ],
                ),
                if (_issue.screenshotUrl?.isNotEmpty == true) ...[
                  SizedBox(height: 12.h),
                  _InfoPanel(
                    title: 'Screenshot',
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _issue.screenshotUrl!,
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Container(
                            height: 100.h,
                            color: cs.surfaceContainerHighest,
                            child: const Center(child: Text('No image')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 12.h),
                _InfoPanel(
                  title: 'Device Info',
                  children: [
                    if (_issue.deviceInfo.isNotEmpty)
                      _parseAndDisplayDeviceInfo(_issue.deviceInfo),
                    if (_issue.appVersion.isNotEmpty)
                      _InfoRow('App Version', 'v${_issue.appVersion}'),
                    if (_issue.buildNumber.isNotEmpty)
                      _InfoRow('Build', _issue.buildNumber),
                  ],
                ),
                if (actions.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _InfoPanel(
                    title: 'Actions',
                    children: [
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: actions.map((a) {
                          final btn = a.primary
                              ? ElevatedButton(
                                  onPressed:
                                      _busy ? null : () => _updateStatus(a.status),
                                  child: Text(a.label),
                                )
                              : OutlinedButton(
                                  onPressed:
                                      _busy ? null : () => _updateStatus(a.status),
                                  child: Text(a.label),
                                );
                          return btn;
                        }).toList(),
                      ),
                      if (_busy) ...[
                        SizedBox(height: 12.h),
                        LinearProgressIndicator(color: cs.primary),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _parseAndDisplayDeviceInfo(String info) {
    try {
      final map = <String, String>{};
      for (final line in info.split('\n')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          map[parts[0].trim()] = parts.sublist(1).join(':').trim();
        }
      }
      if (map.isEmpty) {
        return Text(info, style: TextStyle(fontSize: 13.sp));
      }
      return Column(
        children: map.entries.map((e) {
          return _InfoRow(e.key, e.value);
        }).toList(),
      );
    } catch (_) {
      return Text(info, style: TextStyle(fontSize: 13.sp));
    }
  }
}

String _shortId(String id) {
  return id.length >= 8 ? id.substring(0, 8) : id;
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AdminTextStyles.sectionTitle(context),
            ),
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
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 13.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
