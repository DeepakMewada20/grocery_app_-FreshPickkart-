import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/delivery_issue_controller.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
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
                            child: DropdownButtonFormField<String>(
                              initialValue: _controller.selectedIssueType.value,
                              isExpanded: true,
                              items: DeliveryIssueController.issueTypes.map(
                                (type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ),
                              ).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _controller.selectIssueType(value);
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: _inputDecoration(
                                context,
                                hintText: 'Select issue type',
                              ),
                              dropdownColor:
                                  Theme.of(context).colorScheme.surfaceContainerHighest,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select an issue type.';
                                }
                                return null;
                              },
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
                                      Wrap(
                                        spacing: 10.w,
                                        runSpacing: 8.h,
                                        children: [
                                          _buildFieldChip(
                                            context,
                                            label: 'Change address',
                                            isSelected: _controller.isAddressChange,
                                            onTap: () {
                                              _controller.selectField(
                                                DeliveryIssueController.addressChangeField,
                                              );
                                              setState(() {});
                                            },
                                          ),
                                          _buildFieldChip(
                                            context,
                                            label: 'Delivery note',
                                            isSelected: !_controller.isAddressChange,
                                            onTap: () {
                                              _controller.selectField(
                                                DeliveryIssueController.deliveryNoteField,
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 14.h),
                                      SizedBox(
                                        height: 110.h,
                                        child: _controller.isAddressChange
                                            ? _AddressPreviewCard(
                                                address:
                                                    _controller.selectedAddress.value ??
                                                    widget.currentAddress,
                                                onEdit: _controller.pickAddress,
                                              )
                                            : TextFormField(
                                                controller: _noteController,
                                                expands: true,
                                                maxLines: null,
                                                textInputAction: TextInputAction.newline,
                                                decoration: _inputDecoration(
                                                  context,
                                                  hintText: 'Add a note for the rider or the delivery team',
                                                ),
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
                              decoration: _inputDecoration(
                                context,
                                hintText: 'Please describe the delivery issue in detail...',
                              ),
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                final isLocationIssue =
                                    _controller.isDeliveryLocationIssue;
                                if (!isLocationIssue && text.length < 20) {
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

  Widget _buildFieldChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.onSurface.withValues(alpha: 0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.onSurface.withValues(alpha: 0.5) : cs.outlineVariant,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: cs.onSurface,
          ),
        ),
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
        AppSnackbar.show(
          'Updated',
          _controller.isAddressChange
              ? ErrorMessages.deliveryAddressUpdated
              : ErrorMessages.deliveryNoteSaved,
        );
        Get.back(result: true);
      }
    } catch (error) {
      AppLogger.error('ReportDeliveryIssue', error);
      AppSnackbar.error(
        'Unable to submit',
        ErrorMessages.somethingWentWrong,
      );
    }
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String hintText,
  IconData? prefixIcon,
}) {
  final cs = Theme.of(context).colorScheme;

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: cs.onSurface.withValues(alpha: 0.38),
      fontSize: 14.sp,
    ),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(
            prefixIcon,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
    filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: cs.primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
    ),
  );
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
    final cs = Theme.of(context).colorScheme;
    final addressText = [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).join(', ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current address',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Text(
                  addressText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, height: 1.35),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              side: BorderSide(color: cs.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'Change',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
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
