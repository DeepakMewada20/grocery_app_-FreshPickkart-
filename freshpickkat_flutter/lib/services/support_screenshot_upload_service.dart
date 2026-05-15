import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SupportScreenshotUploadService {
  SupportScreenshotUploadService._();

  static final SupportScreenshotUploadService instance =
      SupportScreenshotUploadService._();

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickGalleryImage() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
  }

  Future<String> uploadScreenshot({
    required String firebaseUid,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final safeName = image.name.trim().isEmpty
        ? 'screenshot.jpg'
        : image.name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final ref = FirebaseStorage.instance
        .ref()
        .child('support_issues')
        .child(firebaseUid)
        .child('${timestamp}_$safeName');

    final metadata = SettableMetadata(
      contentType: _contentTypeFor(safeName),
      customMetadata: {
        'uploadedBy': firebaseUid,
        'purpose': 'support_issue_screenshot',
      },
    );

    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  String _contentTypeFor(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
