import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_picker_button.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_preview.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/modern_text_field.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class CatalogCategoriesTab extends StatelessWidget {
  const CatalogCategoriesTab({
    super.key,
    required this.controller,
    required this.onAddCategory,
    required this.onAddSubcategory,
  });

  final AdminCategoryController controller;
  final VoidCallback onAddCategory;
  final VoidCallback onAddSubcategory;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      final subCategories = controller.subCategories;
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;

      if (isLoading && categories.isEmpty && subCategories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && categories.isEmpty && subCategories.isEmpty) {
        return AdminStateView.error(
          message: error,
          onRetry: controller.loadCategories,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadCategories,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 12) / 2;
                return Row(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: CatalogStatCard(
                        title: 'Categories',
                        value: '${categories.length}',
                        icon: Icons.category,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: cardWidth,
                      child: CatalogStatCard(
                        title: 'Subcategories',
                        value: '${subCategories.length}',
                        icon: Icons.account_tree_outlined,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (categories.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No categories yet'),
                ),
              )
            else
              ...categories.map(
                (category) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(category.categoryImageUrl),
                      onBackgroundImageError: (_, _) {},
                    ),
                    title: Text(category.categoryName),
                    subtitle: Text(
                      '${category.subCategory.length} mapped subcategories',
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Subcategories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (subCategories.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No subcategories yet'),
                ),
              )
            else
              ...subCategories.map(
                (subCategory) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.account_tree_outlined),
                    ),
                    title: Text(subCategory.subCategoriesName.join(', ')),
                    subtitle: Text('Category: ${subCategory.categoryId}'),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ── Helpers for Bottom Sheets ────────────────────────────────────────────────

Future<void> showAddCategoryDialog({
  required BuildContext context,
  required AdminCategoryController controller,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  String? imageError;
  var isUploadingImage = false;

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Add New Category',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ModernTextField(
                      controller: nameCtrl,
                      labelText: 'Category Name',
                      hintText: 'Enter category name',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    if (imageCtrl.text.trim().isNotEmpty) ...[
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ImagePreview(imageUrl: imageCtrl.text.trim()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => setSheetState(() => imageCtrl.clear()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ModernTextField(
                      controller: imageCtrl,
                      labelText: 'Image URL',
                      hintText: 'Paste link or upload below',
                      onChanged: (_) => setSheetState(() => imageError = null),
                    ),
                    const SizedBox(height: 16),
                    ImagePickerButton(
                      isUploading: isUploadingImage,
                      label: 'Upload Image',
                      onPressed: () async {
                        setSheetState(() {
                          isUploadingImage = true;
                          imageError = null;
                        });
                        try {
                          final source = await AdminImageUploadService.pickImageSource(context);
                          if (source == null) return;
                          final url = await AdminImageUploadService.pickCropAndUploadImage(
                            source: source,
                            folder: 'categories',
                            toolbarTitle: 'Crop Image',
                            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Lock to 1:1
                          );
                          if (url != null && context.mounted) {
                            setSheetState(() => imageCtrl.text = url);
                          }
                        } catch (e) {
                          setSheetState(() => imageError = e.toString());
                        } finally {
                          if (context.mounted) setSheetState(() => isUploadingImage = false);
                        }
                      },
                    ),
                    if (imageError != null) ...[
                      const SizedBox(height: 8),
                      Text(imageError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (imageCtrl.text.trim().isEmpty) {
                            setSheetState(() => imageError = 'Please upload or provide an image');
                            return;
                          }
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save Category', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  if (saved != true) return;

  try {
    await controller.uploadCategory(
      Category(
        categoryName: nameCtrl.text.trim(),
        categoryImageUrl: imageCtrl.text.trim(),
        subCategory: {},
      ),
    );
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Category added successfully');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Failed to add: $error');
  }
}

Future<void> showAddSubcategoryDialog({
  required BuildContext context,
  required AdminCategoryController controller,
}) async {
  if (controller.categories.isEmpty) {
    _showCatalogSnackBar(context, 'Create category first');
    return;
  }

  final formKey = GlobalKey<FormState>();
  String selectedCategory = controller.categories.first.categoryName;
  final nameCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  String? imageError;
  var isUploadingImage = false;

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Add New Subcategory',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Parent Category',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.categories
                          .map((c) => DropdownMenuItem(value: c.categoryName, child: Text(c.categoryName)))
                          .toList(),
                      onChanged: (val) => setSheetState(() => selectedCategory = val!),
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: nameCtrl,
                      labelText: 'Subcategory Name',
                      hintText: 'Enter subcategory name',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    if (imageCtrl.text.trim().isNotEmpty) ...[
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ImagePreview(imageUrl: imageCtrl.text.trim()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => setSheetState(() => imageCtrl.clear()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ModernTextField(
                      controller: imageCtrl,
                      labelText: 'Image URL (Optional)',
                      hintText: 'Paste link or upload below',
                    ),
                    const SizedBox(height: 16),
                    ImagePickerButton(
                      isUploading: isUploadingImage,
                      label: 'Upload Image',
                      onPressed: () async {
                        setSheetState(() {
                          isUploadingImage = true;
                          imageError = null;
                        });
                        try {
                          final source = await AdminImageUploadService.pickImageSource(context);
                          if (source == null) return;
                          final url = await AdminImageUploadService.pickCropAndUploadImage(
                            source: source,
                            folder: 'subcategories',
                            toolbarTitle: 'Crop Image',
                            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Lock to 1:1
                          );
                          if (url != null && context.mounted) {
                            setSheetState(() => imageCtrl.text = url);
                          }
                        } catch (e) {
                          setSheetState(() => imageError = e.toString());
                        } finally {
                          if (context.mounted) setSheetState(() => isUploadingImage = false);
                        }
                      },
                    ),
                    if (imageError != null) ...[
                      const SizedBox(height: 8),
                      Text(imageError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save Subcategory', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  if (saved != true) return;

  try {
    await controller.uploadSubCategory(
      SubCategory(
        categoryId: selectedCategory,
        subCategoriesName: [nameCtrl.text.trim()],
        subCategoriesUrl: imageCtrl.text.trim(),
      ),
    );
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Subcategory added successfully');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Failed to add: $error');
  }
}

void _showCatalogSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}
