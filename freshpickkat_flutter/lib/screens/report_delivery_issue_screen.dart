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
  static const _issueTypes = {
    'Late Delivery': Icons.schedule,
    'Rider Not Reachable': Icons.phone_disabled,
    'Wrong Address Attempt': Icons.location_off,
    'Order Not Received': Icons.inbox,
    'Damaged During Delivery': Icons.warning_rounded,
    'Other': Icons.help_outline,
  };

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _issueType = 'Late Delivery';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          'Report Delivery Issue',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _submitted != null
            ? _SuccessState(complaint: _submitted!)
            : active != null
            ? _BlockedState(complaint: active)
            : SingleChildScrollView(
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
                        _IntroCard(cs: cs),
                        SizedBox(height: 18.h),
                        _FormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel('Issue Type'),
                              SizedBox(height: 8.h),
                              _IssueTypeDropdown(
                                initialValue: _issueType,
                                items: _issueTypes,
                                onChanged: (value) => setState(
                                  () => _issueType = value ?? _issueType,
                                ),
                              ),
                              SizedBox(height: 18.h),
                              _FieldLabel('Description'),
                              SizedBox(height: 8.h),
                              _DeliveryTextField(
                                controller: _descriptionController,
                                hintText:
                                    'Please describe what happened in detail...',
                                minLines: 5,
                                maxLines: 8,
                                textInputAction: TextInputAction.newline,
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    disabledBackgroundColor: cs.primary
                                        .withValues(alpha: 0.45),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSubmitting
                                      ? SizedBox(
                                          width: 22.r,
                                          height: 22.r,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Text(
                                          'Submit Complaint',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

// Intro Card - Info about the complaint process
class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.info_outline_rounded,
            color: cs.primary,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report an Issue',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Please provide detailed information about what went wrong with your delivery.',
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

// Form Card - Container for form fields
class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

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
      child: child,
    );
  }
}

// Field Label - Styled label for form fields
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

// Issue Type Dropdown - Custom styled dropdown with icons
class _IssueTypeDropdown extends StatelessWidget {
  const _IssueTypeDropdown({
    required this.initialValue,
    required this.items,
    required this.onChanged,
  });

  final String initialValue;
  final Map<String, IconData> items;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButton<String>(
        value: initialValue,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(
                      entry.value,
                      size: 18.r,
                      color: cs.primary,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      entry.key,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// Delivery Text Field - Custom styled text field
class _DeliveryTextField extends StatefulWidget {
  const _DeliveryTextField({
    required this.controller,
    this.hintText,
    this.minLines,
    this.maxLines,
    this.textInputAction,
    required this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final String? Function(String?) validator;

  @override
  State<_DeliveryTextField> createState() => _DeliveryTextFieldState();
}

class _DeliveryTextFieldState extends State<_DeliveryTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.5),
          fontSize: 13.sp,
        ),
        filled: true,
        fillColor: cs.surface,
        contentPadding: EdgeInsets.all(12.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),
    );
  }
}

// Success State - Displayed after successful submission
class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: AppResponsive.constrainContent(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 40.r,
                    color: cs.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Complaint Submitted',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'We\'ve received your complaint and will investigate shortly.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Complaint ID: ${complaint.complaintId}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Get.off(
                      () => ComplaintDetailScreen(complaint: complaint),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'View Complaint Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: TextButton(
                    onPressed: () => Get.back(result: complaint),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Blocked State - Displayed when complaint already exists
class _BlockedState extends StatelessWidget {
  const _BlockedState({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: AppResponsive.constrainContent(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: cs.secondary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 40.r,
                    color: cs.secondary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Complaint Already Active',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: cs.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: cs.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        complaint.status.toString().replaceAll(
                          'ComplaintStatus.',
                          '',
                        ),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: cs.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You already have an active complaint for this order. Please view the details or wait for a response.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Get.off(
                      () => ComplaintDetailScreen(complaint: complaint),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'View Complaint Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
