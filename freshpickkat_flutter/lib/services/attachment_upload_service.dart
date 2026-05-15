import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentUploadService {
  AttachmentUploadService._();

  static final AttachmentUploadService instance = AttachmentUploadService._();

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickGalleryImage() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
  }

  Future<XFile?> pickCameraImage() {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 82,
      maxWidth: 1600,
    );
  }

  Future<List<XFile>> pickGalleryImages({int limit = 3}) async {
    final images = await _picker.pickMultiImage(
      imageQuality: 82,
      maxWidth: 1600,
      limit: limit,
    );
    return images.take(limit).toList(growable: false);
  }

  Future<String> uploadImage({
    required String firebaseUid,
    required XFile image,
    required String folder,
    required String purpose,
  }) async {
    final bytes = await image.readAsBytes();
    final safeName = image.name.trim().isEmpty
        ? 'attachment.jpg'
        : image.name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
    final ref = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(firebaseUid)
        .child('${timestamp}_$safeName');

    final metadata = SettableMetadata(
      contentType: _contentTypeFor(safeName),
      customMetadata: {
        'uploadedBy': firebaseUid,
        'purpose': purpose,
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
