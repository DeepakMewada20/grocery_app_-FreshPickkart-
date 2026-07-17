import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/support_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final SupportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SupportController());
    _controller.resetForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
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
          'Report App Issue',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: ScreenScale.sp(18),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          final issue = _controller.submittedIssue.value;
          if (issue != null) {
            return _SuccessState(
              status: issue.status,
              ticketId: issue.issueId,
              onDone: () => Get.back(),
              onReportAnother: () {
                _titleController.clear();
                _descriptionController.clear();
                _controller.resetForm();
              },
            );
          }

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              ScreenScale.w(16),
              ScreenScale.h(8),
              ScreenScale.w(16),
              ScreenScale.h(28) + MediaQuery.paddingOf(context).bottom,
            ),
            child: AppResponsive.constrainContent(
              context: context,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IntroCard(cs: cs),
                    SizedBox(height: ScreenScale.h(18)),
                    _FormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Issue Type'),
                          SizedBox(height: ScreenScale.h(8)),
                          _IssueTypeDropdown(controller: _controller),
                          SizedBox(height: ScreenScale.h(18)),
                          _FieldLabel('Title'),
                          SizedBox(height: ScreenScale.h(8)),
                          _SupportTextField(
                            controller: _titleController,
                            hintText: 'Short summary of the issue',
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.length < 3) {
                                return 'Title must be at least 3 characters.';
                              }
                              if (text.length > 120) {
                                return 'Title must be 120 characters or less.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: ScreenScale.h(18)),
                          _FieldLabel('Description'),
                          SizedBox(height: ScreenScale.h(8)),
                          _SupportTextField(
                            controller: _descriptionController,
                            hintText:
                                'Tell us what happened and what you expected.',
                            minLines: 5,
                            maxLines: 8,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.length < 10) {
                                return 'Description must be at least 10 characters.';
                              }
                              if (text.length > 2000) {
                                return 'Description must be 2000 characters or less.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: ScreenScale.h(18)),
                          _FieldLabel('Attach Screenshot (optional)'),
                          SizedBox(height: ScreenScale.h(8)),
                          _ScreenshotPicker(controller: _controller),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenScale.h(18)),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: ScreenScale.h(52),
                        child: ElevatedButton(
                          onPressed: _controller.isSubmitting.value
                              ? null
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            disabledBackgroundColor: cs.primary.withValues(
                              alpha: 0.45,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                            ),
                            elevation: 0,
                          ),
                          child: _controller.isSubmitting.value
                              ? SizedBox(
                                  width: ScreenScale.r(22),
                                  height: ScreenScale.r(22),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Submit Issue',
                                  style: TextStyle(
                                    fontSize: ScreenScale.sp(15),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
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
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      await _controller.submitIssue(
        title: _titleController.text,
        description: _descriptionController.text,
      );
    } catch (error) {
      AppLogger.error('ReportIssue', error);
      AppSnackbar.error(
        'Unable to submit',
        ErrorMessages.somethingWentWrong,
      );
    }
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ScreenScale.r(22)),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: ScreenScale.r(48),
            height: ScreenScale.r(48),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            ),
            child: Icon(
              Icons.bug_report_outlined,
              color: cs.primary,
              size: ScreenScale.r(26),
            ),
          ),
          SizedBox(width: ScreenScale.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send a support ticket',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: ScreenScale.sp(17),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: ScreenScale.h(4)),
                Text(
                  'We auto-attach app and device details to help debug faster.',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.62),
                    fontSize: ScreenScale.sp(13),
                    height: 1.35,
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

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: AppSpacing.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ScreenScale.r(22)),
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
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface,
        fontSize: ScreenScale.sp(13),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IssueTypeDropdown extends StatelessWidget {
  const _IssueTypeDropdown({required this.controller});

  final SupportController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: controller.selectedIssueType.value,
        items: controller.issueTypes
            .map(
              (type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ),
            )
            .toList(),
        onChanged: controller.setIssueType,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: _inputDecoration(
          context,
          hintText: 'Select issue type',
          prefixIcon: Icons.category_outlined,
        ),
        dropdownColor: cs.surfaceContainerHighest,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please select an issue type.';
          }
          return null;
        },
      ),
    );
  }
}

class _SupportTextField extends StatelessWidget {
  const _SupportTextField({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final int minLines;
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      validator: validator,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: ScreenScale.sp(14),
      ),
      decoration: _inputDecoration(
        context,
        hintText: hintText,
      ),
    );
  }
}

class _ScreenshotPicker extends StatelessWidget {
  const _ScreenshotPicker({required this.controller});

  final SupportController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final screenshot = controller.selectedScreenshot.value;
      final isPicking = controller.isPickingScreenshot.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: screenshot == null
            ? InkWell(
                onTap: isPicking ? null : controller.pickScreenshot,
                borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                child: Padding(
                  padding: AppSpacing.all(14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: cs.primary,
                        size: AppIcons.large,
                      ),
                      SizedBox(width: ScreenScale.w(12)),
                      Expanded(
                        child: Text(
                          isPicking
                              ? 'Opening gallery...'
                              : 'Choose screenshot from gallery',
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: ScreenScale.sp(14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: AppSpacing.all(14),
                child: Row(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: cs.primary,
                      size: AppIcons.large,
                    ),
                    SizedBox(width: ScreenScale.w(12)),
                    Expanded(
                      child: Text(
                        screenshot.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: ScreenScale.sp(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.removeScreenshot,
                      icon: Icon(
                        Icons.close_rounded,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({
    required this.status,
    required this.ticketId,
    required this.onDone,
    required this.onReportAnother,
  });

  final String status;
  final String ticketId;
  final VoidCallback onDone;
  final VoidCallback onReportAnother;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.all(24),
        child: AppResponsive.constrainContent(
          context: context,
          child: Container(
            width: double.infinity,
            padding: AppSpacing.all(22),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(ScreenScale.r(24)),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ScreenScale.r(64),
                  height: ScreenScale.r(64),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: cs.primary,
                    size: ScreenScale.r(38),
                  ),
                ),
                SizedBox(height: ScreenScale.h(18)),
                Text(
                  'Issue Submitted Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: ScreenScale.sp(20),
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: ScreenScale.h(8)),
                Text(
                  'Ticket Status: $status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: ScreenScale.sp(15),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (ticketId.isNotEmpty) ...[
                  SizedBox(height: ScreenScale.h(8)),
                  Text(
                    'Ticket ID: $ticketId',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.52),
                      fontSize: ScreenScale.sp(12),
                    ),
                  ),
                ],
                SizedBox(height: ScreenScale.h(22)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: AppSpacing.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
                TextButton(
                  onPressed: onReportAnother,
                  child: const Text('Report another issue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      fontSize: ScreenScale.sp(14),
    ),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(
            prefixIcon,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
    filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    contentPadding: AppSpacing.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      borderSide: BorderSide(color: cs.primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
    ),
  );
}
