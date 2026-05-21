import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_complaint_controller.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

class ReportProductIssueScreen extends StatefulWidget {
  const ReportProductIssueScreen({
    super.key,
    required this.orderNumber,
    required this.items,
    this.activeComplaint,
  });

  final String orderNumber;
  final List<OrderItem> items;
  final Complaint? activeComplaint;

  @override
  State<ReportProductIssueScreen> createState() =>
      _ReportProductIssueScreenState();
}

class _ReportProductIssueScreenState extends State<ReportProductIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  late final ProductComplaintController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ProductComplaintController());
    _controller.resetForm();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          'Report Product Issue',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          final submitted = _controller.submittedComplaint.value;
          if (submitted != null) {
            return _SuccessState(
              complaint: submitted,
              onView: () => Get.off(
                () => ComplaintDetailScreen(complaintId: submitted.complaintId),
              ),
              onDone: () => Get.back(result: submitted),
            );
          }

          final active = widget.activeComplaint;
          if (active != null) {
            return _BlockedState(complaint: active);
          }

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    _FormCard(
                      child: _ProductSelectionList(
                        items: widget.items,
                        controller: _controller,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _FormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Issue Type'),
                          SizedBox(height: 8.h),
                          _IssueTypeDropdown(controller: _controller),
                          SizedBox(height: 18.h),
                          _FieldLabel('Description'),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _descriptionController,
                            minLines: 5,
                            maxLines: 8,
                            textInputAction: TextInputAction.newline,
                            decoration: _inputDecoration(
                              context,
                              hintText:
                                  'Describe what is wrong with the selected products.',
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
                          _FieldLabel('Images (1-3 required)'),
                          SizedBox(height: 8.h),
                          _ImagePicker(controller: _controller),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: _controller.isSubmitting.value
                            ? null
                            : _submit,
                        child: _controller.isSubmitting.value
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
          );
        }),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      await _controller.submit(
        orderNumber: widget.orderNumber,
        description: _descriptionController.text,
      );
    } catch (error) {
      Get.snackbar(
        'Unable to submit',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _ProductSelectionList extends StatelessWidget {
  const _ProductSelectionList({required this.items, required this.controller});

  final List<OrderItem> items;
  final ProductComplaintController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reportableItems = items
        .where((item) => item.orderItemId?.isNotEmpty == true)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Affected Products'),
        SizedBox(height: 10.h),
        ...reportableItems.map(
          (item) => Obx(() {
            final id = item.orderItemId!;
            final selected = controller.selectedOrderItemIds.contains(id);
            return CheckboxListTile(
              value: selected,
              onChanged: (_) => controller.toggleOrderItem(id),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                item.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                [
                  if (item.variantLabel?.isNotEmpty == true) item.variantLabel!,
                  'Qty ${item.quantity}',
                  'INR ${item.totalPrice.toStringAsFixed(0)}',
                ].join(' • '),
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.62),
                  fontSize: 12.sp,
                ),
              ),
            );
          }),
        ),
      ],
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
          child: _FormCard(
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
                Text(
                  'Status: ${complaint.status}',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => Get.off(
                    () => ComplaintDetailScreen(complaint: complaint),
                  ),
                  child: const Text('View Complaint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({required this.controller});

  final ProductComplaintController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        controller.isPicking.value ||
                            controller.selectedImages.length >= 3
                        ? null
                        : controller.pickGalleryImages,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      controller.isPicking.value ? 'Opening...' : 'Gallery',
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        controller.isPicking.value ||
                            controller.selectedImages.length >= 3
                        ? null
                        : controller.pickCameraImage,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Camera'),
                  ),
                ),
              ],
            ),
            if (controller.selectedImages.isNotEmpty) ...[
              SizedBox(height: 10.h),
              ...controller.selectedImages.map(
                (image) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.image_outlined),
                  title: Text(
                    image.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => controller.removeImage(image),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({
    required this.complaint,
    required this.onView,
    required this.onDone,
  });

  final Complaint complaint;
  final VoidCallback onView;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: AppResponsive.constrainContent(
          context: context,
          child: _FormCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: cs.primary, size: 56.r),
                SizedBox(height: 12.h),
                Text(
                  'Complaint submitted',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Status: ${complaint.status}',
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.65)),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDone,
                        child: const Text('Done'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onView,
                        child: const Text('View'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
    );
  }
}

class _IssueTypeDropdown extends StatelessWidget {
  const _IssueTypeDropdown({required this.controller});

  final ProductComplaintController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: controller.selectedIssueType.value,
        items: controller.issueTypes
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: controller.setIssueType,
        decoration: _inputDecoration(context, hintText: 'Select issue type'),
        validator: (value) => value == null || value.isEmpty
            ? 'Please select an issue type.'
            : null,
      ),
    );
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String hintText,
}) {
  final cs = Theme.of(context).colorScheme;
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
  );
}
