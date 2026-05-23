import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/delivery_issue_controller.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

class ReportDeliveryIssueScreen extends StatefulWidget {
  const ReportDeliveryIssueScreen({
    super.key,
    required this.orderNumber,
    required this.orderStatus,
    required this.currentAddress,
    this.activeComplaint,
  });

  final String orderNumber;
  final String orderStatus;
  final Address currentAddress;
  final Complaint? activeComplaint;

  @override
  State<ReportDeliveryIssueScreen> createState() =>
      _ReportDeliveryIssueScreenState();
}

class _ReportDeliveryIssueScreenState extends State<ReportDeliveryIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  late final DeliveryIssueController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      DeliveryIssueController(
        orderNumber: widget.orderNumber,
        orderStatus: widget.orderStatus,
        currentAddress: widget.currentAddress,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _noteController.dispose();
    if (Get.isRegistered<DeliveryIssueController>()) {
      Get.delete<DeliveryIssueController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final active = widget.activeComplaint;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        title: const Text('Delivery Issue'),
      ),
      body: active != null
          ? _BlockedState(complaint: active)
          : SafeArea(
              top: false,
              child: Obx(() {
                final submitting = _controller.isSubmitting.value;
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    8.h,
                    16.w,
                    28.h + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: AppResponsive.constrainContent(
                    context: context,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IntroCard(
                            orderStatus: widget.orderStatus,
                            isOutForDelivery: _controller.isOutForDelivery,
                          ),
                          SizedBox(height: 16.h),
                          _SectionCard(
                            title: 'Issue type',
                            child: Column(
                              children: [
                                ...DeliveryIssueController.issueTypes.map(
                                  (issue) => Obx(() {
                                    return RadioListTile<String>(
                                      value: issue,
                                      groupValue:
                                          _controller.selectedIssueType.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _controller.selectIssueType(value);
                                          setState(() {});
                                        }
                                      },
                                      title: Text(issue),
                                      contentPadding: EdgeInsets.zero,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if (_controller.isDeliveryLocationIssue)
                            Column(
                              children: [
                                _SectionCard(
                                  title: 'Delivery location request',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SegmentedButton<String>(
                                        segments: const [
                                          ButtonSegment(
                                            value:
                                                DeliveryIssueController.addressChangeField,
                                            label: Text('Change address'),
                                          ),
                                          ButtonSegment(
                                            value:
                                                DeliveryIssueController.deliveryNoteField,
                                            label: Text('Delivery note'),
                                          ),
                                        ],
                                        selected: {
                                          _controller.selectedField.value,
                                        },
                                        onSelectionChanged: (values) {
                                          if (values.isEmpty) return;
                                          _controller.selectField(values.first);
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(height: 14.h),
                                      if (_controller.isAddressChange)
                                        _AddressPreviewCard(
                                          address:
                                              _controller.selectedAddress.value ??
                                              widget.currentAddress,
                                          onEdit: _controller.pickAddress,
                                        )
                                      else
                                        TextFormField(
                                          controller: _noteController,
                                          minLines: 3,
                                          maxLines: 5,
                                          decoration: const InputDecoration(
                                            labelText: 'Delivery note',
                                            hintText:
                                                'Add a note for the rider or the delivery team',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          _SectionCard(
                            title: 'Description',
                            child: TextFormField(
                              controller: _descriptionController,
                              minLines: 5,
                              maxLines: 8,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                labelText: 'Tell us what happened',
                                hintText:
                                    'Please describe the delivery issue in detail...',
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
                          ),
                          SizedBox(height: 18.h),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: submitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: submitting
                                  ? SizedBox(
                                      width: 22.r,
                                      height: 22.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _controller.isDeliveryLocationIssue &&
                                              !_controller.isOutForDelivery
                                          ? (_controller.isAddressChange
                                                ? 'Update Address'
                                                : 'Save Note')
                                          : (_controller.isDeliveryLocationIssue
                                                ? 'Request Approval'
                                                : 'Submit Complaint'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      final result = await _controller.submit(
        _descriptionController.text,
        _noteController.text,
      );
      if (!mounted) return;
      if (result is Complaint) {
        Get.back(result: result);
      } else if (result == true) {
        Get.snackbar(
          'Updated',
          _controller.isAddressChange
              ? 'Delivery address updated successfully'
              : 'Delivery note saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(result: true);
      }
    } catch (error) {
      Get.snackbar(
        'Unable to submit',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.orderStatus,
    required this.isOutForDelivery,
  });

  final String orderStatus;
  final bool isOutForDelivery;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: cs.primary, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOutForDelivery
                      ? 'Request approval for delivery changes'
                      : 'Update the delivery details directly',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isOutForDelivery
                      ? 'The order is out for delivery. Address changes and delivery notes will go to admin for approval.'
                      : 'The order is $orderStatus. Address changes and delivery notes are saved directly to the order.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

class _AddressPreviewCard extends StatelessWidget {
  const _AddressPreviewCard({required this.address, required this.onEdit});

  final Address address;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current address',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6.h),
          Text(
            [
              address.street,
              address.city,
              address.state,
              address.zipCode,
              address.country,
            ].where((part) => part.trim().isNotEmpty).join(', '),
            style: TextStyle(fontSize: 13.sp, height: 1.35),
          ),
          SizedBox(height: 10.h),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_location_alt_outlined),
            label: const Text('Change address'),
          ),
        ],
      ),
    );
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
          child: _SectionCard(
            title: 'Active complaint already exists',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline_rounded, size: 48),
                SizedBox(height: 12.h),
                Text(
                  'Status: ${complaint.status}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You already have an active complaint for this order. Please view the complaint details or wait for a response.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14.h),
                OutlinedButton(
                  onPressed: () => Get.to(
                    () => ComplaintDetailScreen(complaint: complaint),
                  ),
                  child: const Text('View complaint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
