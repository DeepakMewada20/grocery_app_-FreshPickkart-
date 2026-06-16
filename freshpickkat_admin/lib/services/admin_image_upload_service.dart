import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class AdminImageUploadService {
  AdminImageUploadService._();

  static Future<ImageSource?> pickImageSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Use Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<String?> pickCropAndUploadImage({
    required ImageSource source,
    required String folder,
    String toolbarTitle = 'Crop Image',
    CropAspectRatio? aspectRatio,
  }) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (picked == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: aspectRatio ?? const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: toolbarTitle,
          toolbarColor: AdminThemeTokens.primary,
          toolbarWidgetColor: AdminThemeTokens.white,
          initAspectRatio: aspectRatio != null
              ? CropAspectRatioPreset.original
              : CropAspectRatioPreset.square,
          lockAspectRatio: aspectRatio != null,
        ),
        IOSUiSettings(
          title: toolbarTitle,
          aspectRatioLockEnabled: aspectRatio != null,
        ),
      ],
    );

    if (croppedFile == null) return null;

    final uid = AdminSessionService.requireUid();
    final now = DateTime.now().millisecondsSinceEpoch;
    final name = picked.name.replaceAll(' ', '_');
    final ref = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(uid)
        .child('${now}_$name');

    if (kIsWeb) {
      final bytes = await croppedFile.readAsBytes();
      await ref.putData(bytes);
    } else {
      final file = File(croppedFile.path);
      await ref.putFile(file);
    }

    return ref.getDownloadURL();
  }

  static Future<void> deleteImage(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
