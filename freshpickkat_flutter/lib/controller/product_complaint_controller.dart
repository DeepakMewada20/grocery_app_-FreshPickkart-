import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/model/product_complaint_type.dart';
import 'package:freshpickkat_flutter/services/attachment_upload_service.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductComplaintController extends GetxController {
  final issueTypes = ProductComplaintType.values;
  final selectedIssueType = ProductComplaintType.damagedProduct.obs;
  final selectedImages = <XFile>[].obs;
  final selectedOrderItemIds = <String>[].obs;
  final isPicking = false.obs;
  final isSubmitting = false.obs;
  final submittedComplaint = Rxn<Complaint>();

  final _attachments = AttachmentUploadService.instance;
  final _complaints = ProductComplaintService.instance;

  void setIssueType(String? value) {
    if (value == null || value.trim().isEmpty) return;
    selectedIssueType.value = value;
  }

  Future<void> pickGalleryImages() async {
    if (isPicking.value || selectedImages.length >= 3) return;
    isPicking.value = true;
    try {
      final remaining = 3 - selectedImages.length;
      final images = await _attachments.pickGalleryImages(limit: remaining);
      selectedImages.addAll(images.take(remaining));
    } finally {
      isPicking.value = false;
    }
  }

  Future<void> pickCameraImage() async {
    if (isPicking.value || selectedImages.length >= 3) return;
    isPicking.value = true;
    try {
      final image = await _attachments.pickCameraImage();
      if (image != null) selectedImages.add(image);
    } finally {
      isPicking.value = false;
    }
  }

  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

  void toggleOrderItem(String orderItemId) {
    final id = orderItemId.trim();
    if (id.isEmpty) return;
    if (selectedOrderItemIds.contains(id)) {
      selectedOrderItemIds.remove(id);
    } else {
      selectedOrderItemIds.add(id);
    }
  }

  Future<Complaint> submit({
    required String orderNumber,
    List<String>? selectedOrderItemIdsOverride,
    required String description,
  }) async {
    if (isSubmitting.value) {
      throw Exception(ErrorMessages.submissionInProgress);
    }
    final selectedIds = selectedOrderItemIdsOverride ?? selectedOrderItemIds;
    if (selectedIds.isEmpty) {
      throw Exception(ErrorMessages.selectProduct);
    }
    if (selectedImages.isEmpty) {
      throw Exception(ErrorMessages.attachImage);
    }
    if (selectedImages.length > 3) {
      throw Exception(ErrorMessages.maxImages);
    }

    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);

    isSubmitting.value = true;
    try {
      final urls = <String>[];
      for (final image in selectedImages) {
        urls.add(
          await _attachments.uploadImage(
            firebaseUid: user.uid,
            image: image,
            folder: 'product_complaints',
            purpose: 'product_complaint_image',
          ),
        );
      }
      final complaint = await _complaints.createProductComplaint(
        orderNumber: orderNumber,
        selectedOrderItemIds: selectedIds.toList(growable: false),
        issueType: selectedIssueType.value,
        title: selectedIssueType.value,
        description: description,
        imageUrls: urls,
      );
      submittedComplaint.value = complaint;
      return complaint;
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedIssueType.value = ProductComplaintType.damagedProduct;
    selectedOrderItemIds.clear();
    selectedImages.clear();
    submittedComplaint.value = null;
  }
}
