import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_complaint_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class ComplaintManagementScreen extends StatefulWidget {
  const ComplaintManagementScreen({super.key});

  @override
  State<ComplaintManagementScreen> createState() =>
      _ComplaintManagementScreenState();
}

class _ComplaintManagementScreenState extends State<ComplaintManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _statuses = ['Pending', 'Under Review', 'Resolved', 'Rejected'];

  late final TabController _tabController;
  late final AdminComplaintController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AdminComplaintController());
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
        title: Text(
          'Complaint Management',
          style: AdminTextStyles.screenTitle(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _statuses.map((status) => Tab(text: status)).toList(),
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
            onRetry: () => _controller.load(),
          );
        }
        if (_controller.complaints.isEmpty) {
          return AdminStateView.empty(
            title: 'No complaints',
            message: 'No ${_controller.statusFilter.toLowerCase()} complaints.',
            onRefresh: _controller.load,
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.load,
          child: ListView.separated(
            padding: AdminResponsive.pagePadding(context),
            itemCount: _controller.complaints.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final complaint = _controller.complaints[index];
              return _ComplaintCard(
                complaint: complaint,
                onTap: () => _showComplaintDetail(complaint),
              );
            },
          ),
        );
      }),
    );
  }

  void _showComplaintDetail(Complaint complaint) {
    final replyController = TextEditingController(
      text: complaint.adminReply ?? '',
    );
    var selectedStatus = complaint.status;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                16.h,
                16.w,
                16.h + MediaQuery.paddingOf(context).bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complaint #${complaint.complaintId.substring(0, 8)}',
                      style: AdminTextStyles.screenTitle(context),
                    ),
                    SizedBox(height: 12.h),
                    _ComplaintCard(complaint: complaint, onTap: () {}),
                    SizedBox(height: 12.h),
                    Text(
                      'Description',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                    SizedBox(height: 6.h),
                    Text(complaint.description),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: complaint.imageUrls
                          .map(
                            (url) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                url,
                                width: 96.r,
                                height: 96.r,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      items: _statuses.map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setSheetState(() => selectedStatus = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: replyController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Admin reply',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          var updated = complaint;
                          if (replyController.text.trim().isNotEmpty) {
                            updated = await _controller.reply(
                              updated,
                              replyController.text.trim(),
                            );
                          }
                          if (selectedStatus != complaint.status) {
                            updated = await _controller.updateStatus(
                              updated,
                              selectedStatus,
                            );
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(replyController.dispose);
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint, required this.onTap});

  final Complaint complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                complaint.productImage,
                width: 58.r,
                height: 58.r,
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
                    complaint.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Order #${complaint.orderNumber} • ${complaint.issueType}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.caption(context),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Chip(label: Text(complaint.status)),
          ],
        ),
      ),
    );
  }
}
