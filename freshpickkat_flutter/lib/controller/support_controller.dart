import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/model/support_issue_type.dart';
import 'package:freshpickkat_flutter/services/support_issue_service.dart';
import 'package:freshpickkat_flutter/services/support_screenshot_upload_service.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SupportController extends GetxController {
  static SupportController get instance => Get.find<SupportController>();

  final issueTypes = SupportIssueType.values;
  final selectedIssueType = SupportIssueType.loginProblem.obs;
  final selectedScreenshot = Rxn<XFile>();
  final submittedIssue = Rxn<SupportIssue>();
  final isPickingScreenshot = false.obs;
  final isSubmitting = false.obs;

  final _issueService = SupportIssueService.instance;
  final _screenshotService = SupportScreenshotUploadService.instance;

  void setIssueType(String? value) {
    if (value == null || value.trim().isEmpty) return;
    selectedIssueType.value = value;
  }

  Future<void> pickScreenshot() async {
    if (isPickingScreenshot.value) return;
    isPickingScreenshot.value = true;
    try {
      final image = await _screenshotService.pickGalleryImage();
      if (image != null) {
        selectedScreenshot.value = image;
      }
    } finally {
      isPickingScreenshot.value = false;
    }
  }

  void removeScreenshot() {
    selectedScreenshot.value = null;
  }

  Future<SupportIssue> submitIssue({
    required String title,
    required String description,
  }) async {
    if (isSubmitting.value) {
      throw Exception(ErrorMessages.submissionInProgress);
    }

    final user = AuthController.instance.currentUser;
    if (user == null) {
      throw Exception(ErrorMessages.loginRequired);
    }

    isSubmitting.value = true;
    try {
      String? screenshotUrl;
      final image = selectedScreenshot.value;
      if (image != null) {
        screenshotUrl = await _screenshotService.uploadScreenshot(
          firebaseUid: user.uid,
          image: image,
        );
      }

      final issue = await _issueService.submitIssue(
        issueType: selectedIssueType.value,
        title: title,
        description: description,
        screenshotUrl: screenshotUrl,
      );
      submittedIssue.value = issue;
      return issue;
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedIssueType.value = SupportIssueType.loginProblem;
    selectedScreenshot.value = null;
    submittedIssue.value = null;
  }
}
