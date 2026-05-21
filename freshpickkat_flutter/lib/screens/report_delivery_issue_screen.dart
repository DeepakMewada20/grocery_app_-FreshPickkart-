import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

class ReportDeliveryIssueScreen extends StatefulWidget {
  const ReportDeliveryIssueScreen({
    super.key,
    required this.orderNumber,
    this.activeComplaint,
  });

  final String orderNumber;
  final Complaint? activeComplaint;

  @override
  State<ReportDeliveryIssueScreen> createState() =>
      _ReportDeliveryIssueScreenState();
}

class _ReportDeliveryIssueScreenState extends State<ReportDeliveryIssueScreen> {
  static const _issueTypes = [
    'Late Delivery',
    'Rider Not Reachable',
    'Wrong Address Attempt',
    'Order Not Received',
    'Damaged During Delivery',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _issueType = _issueTypes.first;
  bool _isSubmitting = false;
  Complaint? _submitted;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final active = widget.activeComplaint;
    return Scaffold(
      appBar: AppBar(title: const Text('Report Delivery Issue')),
      body: SafeArea(
        top: false,
        child: _submitted != null
            ? _SuccessState(complaint: _submitted!)
            : active != null
            ? _BlockedState(complaint: active)
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  12.h,
                  16.w,
                  28.h + MediaQuery.paddingOf(context).bottom,
                ),
                child: AppResponsive.constrainContent(
                  context: context,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _issueType,
                            items: _issueTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(
                              () => _issueType = value ?? _issueType,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Issue Type',
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            controller: _descriptionController,
                            minLines: 5,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.length < 20) {
                                return 'Description must be at least 20 characters.';
                              }
                              if (text.length > 2000) {
                                return 'Description must be 2000 characters or less.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 18.h),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submit,
                              child: _isSubmitting
                                  ? SizedBox(
                                      width: 22.r,
                                      height: 22.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                      ),
                                    )
                                  : const Text('Submit Complaint'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      final complaint = await ProductComplaintService.instance
          .createDeliveryComplaint(
            orderNumber: widget.orderNumber,
            issueType: _issueType,
            title: _issueType,
            description: _descriptionController.text,
          );
      if (mounted) setState(() => _submitted = complaint);
    } catch (error) {
      Get.snackbar(
        'Unable to submit',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _BlockedState extends StatelessWidget {
  const _BlockedState({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: AppResponsive.constrainContent(
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline_rounded, size: 48),
              SizedBox(height: 12.h),
              const Text(
                'Complaint already active',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 8.h),
              Text('Status: ${complaint.status}'),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () =>
                    Get.off(() => ComplaintDetailScreen(complaint: complaint)),
                child: const Text('View Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 56),
            SizedBox(height: 12.h),
            const Text(
              'Complaint submitted',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () =>
                  Get.off(() => ComplaintDetailScreen(complaint: complaint)),
              child: const Text('View Complaint'),
            ),
            TextButton(
              onPressed: () => Get.back(result: complaint),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
