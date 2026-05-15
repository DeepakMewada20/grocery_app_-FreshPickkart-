import 'package:freshpickkat_flutter/services/attachment_upload_service.dart';
import 'package:image_picker/image_picker.dart';

class SupportScreenshotUploadService {
  SupportScreenshotUploadService._();

  static final SupportScreenshotUploadService instance =
      SupportScreenshotUploadService._();

  Future<XFile?> pickGalleryImage() {
    return AttachmentUploadService.instance.pickGalleryImage();
  }

  Future<String> uploadScreenshot({
    required String firebaseUid,
    required XFile image,
  }) async {
    return AttachmentUploadService.instance.uploadImage(
      firebaseUid: firebaseUid,
      image: image,
      folder: 'support_issues',
      purpose: 'support_issue_screenshot',
    );
  }
}
