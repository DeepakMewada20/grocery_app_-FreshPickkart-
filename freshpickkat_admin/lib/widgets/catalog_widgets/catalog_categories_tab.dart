import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_picker_button.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_preview.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/modern_text_field.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: AdminResponsive.pagePadding(
            context,
          ).copyWith(bottom: AdminResponsive.bottomInset(context) + 88.h),
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 360 ? 1 : 2;
                final spacing = 12.w;
                final cardWidth =
                    (constraints.maxWidth - ((columns - 1) * spacing)) /
                    columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: 12.h,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: CatalogStatCard(
                        title: 'Categories',
                        value: '${categories.length}',
                        icon: Icons.category,
                        color: AdminAppTheme.getSuccessColor(context),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: CatalogStatCard(
                        title: 'Subcategories',
                        value: '${subCategories.length}',
                        icon: Icons.account_tree_outlined,
                        color: AdminAppTheme.getTealColor(context),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            Text('Categories', style: AdminTextStyles.sectionTitle(context)),
            SizedBox(height: 10.h),
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
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(category.categoryImageUrl),
                      onBackgroundImageError: (_, _) {},
                    ),
                    title: Text(
                      category.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${category.subCategory.length} mapped subcategories',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showAddCategoryDialog(
                            context: context,
                            controller: controller,
                            categoryToEdit: category,
                          );
                        } else if (value == 'delete') {
                          _confirmDelete(
                            context: context,
                            title: 'Delete Category',
                            message:
                                'Are you sure you want to delete "${category.categoryName}"?',
                            categoryName: category.categoryName,
                            onConfirm: () => controller.deleteCategory(
                              category.categoryName,
                            ),
                            onUndo: controller.setCategoryActive,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: AdminAppTheme.getErrorColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            Text('Subcategories', style: AdminTextStyles.sectionTitle(context)),
            SizedBox(height: 10.h),
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
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.account_tree_outlined),
                    ),
                    title: Text(
                      subCategory.subCategoriesName.join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Category: ${subCategory.categoryId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showAddSubcategoryDialog(
                            context: context,
                            controller: controller,
                            subcategoryToEdit: subCategory,
                          );
                        } else if (value == 'delete') {
                          _confirmDelete(
                            context: context,
                            title: 'Delete Subcategory',
                            message:
                                'Are you sure you want to delete "${subCategory.subCategoriesName.first}"?',
                            categoryName: subCategory.categoryId,
                            onConfirm: () => controller.deleteSubCategory(
                              subCategory.categoryId,
                              subCategory.subCategoriesName.first,
                            ),
                            onUndo: controller.setCategoryActive,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: AdminAppTheme.getErrorColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  void _confirmDelete({
    required BuildContext context,
    required String title,
    required String message,
    required String categoryName,
    required Future<bool> Function() onConfirm,
    required Future<bool> Function(String, bool) onUndo,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final ok = await onConfirm();
                if (!ok) return;
                const undoDuration = Duration(seconds: 4);
                messenger.clearSnackBars();
                final ctrl = messenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Deactivated',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: undoDuration,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () => onUndo(categoryName, true),
                    ),
                  ),
                );
                Future.delayed(undoDuration, () => ctrl.close());
              } catch (e) {
                messenger
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(content: Text('Delete failed: $e')),
                  );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AdminAppTheme.getErrorColor(dialogContext)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers for Bottom Sheets ────────────────────────────────────────────────

Future<void> showAddCategoryDialog({
  required BuildContext context,
  required AdminCategoryController controller,
  Category? categoryToEdit,
}) async {
  final isEdit = categoryToEdit != null;
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: categoryToEdit?.categoryName);
  final imageCtrl = TextEditingController(
    text: categoryToEdit?.categoryImageUrl,
  );
  String? imageError;
  var isUploadingImage = false;
  var isSaving = false;

  await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: AdminResponsive.bottomSheetConstraints(context),
    backgroundColor: AdminThemeTokens.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: AdminResponsive.pageHorizontalPadding(context),
              right: AdminResponsive.pageHorizontalPadding(context),
              top: 20.h,
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
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AdminAppTheme.getBorderColor(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      isEdit ? 'Edit Category' : 'Add New Category',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                    SizedBox(height: 20.h),
                    ModernTextField(
                      controller: nameCtrl,
                      labelText: 'Category Name',
                      hintText: 'Enter category name',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    if (imageCtrl.text.trim().isNotEmpty) ...[
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 120.r.clamp(96.0, 132.0),
                              height: 120.r.clamp(96.0, 132.0),
                              child: ImagePreview(
                                imageUrl: imageCtrl.text
                                    .trim()
                                    .replaceAll('"', '')
                                    .replaceAll("'", ""),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: AdminAppTheme.getErrorColor(context),
                              ),
                              onPressed: () =>
                                  setSheetState(() => imageCtrl.clear()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    ModernTextField(
                      controller: imageCtrl,
                      labelText: 'Image URL',
                      hintText: 'Paste link or upload below',
                      onChanged: (_) => setSheetState(() {
                        imageError = null;
                      }),
                    ),
                    SizedBox(height: 16.h),
                    ImagePickerButton(
                      isUploading: isUploadingImage,
                      label: 'Upload Image',
                      onPressed: () {
                        () async {
                          setSheetState(() {
                            isUploadingImage = true;
                            imageError = null;
                          });
                          try {
                            final source =
                                await AdminImageUploadService.pickImageSource(
                                  context,
                                );
                            if (source == null) return;
                            final url =
                                await AdminImageUploadService.pickCropAndUploadImage(
                                  source: source,
                                  folder: 'categories',
                                  toolbarTitle: 'Crop Image',
                                  aspectRatio: const CropAspectRatio(
                                    ratioX: 1,
                                    ratioY: 1,
                                  ),
                                );
                            if (url != null && context.mounted) {
                              setSheetState(() => imageCtrl.text = url);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setSheetState(
                                () => imageError = e.toString(),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setSheetState(() => isUploadingImage = false);
                            }
                          }
                        }();
                      },
                    ),
                    if (imageError != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        imageError!,
                        style: TextStyle(
                          color: AdminAppTheme.getErrorColor(context),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 26.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (isSaving || isUploadingImage)
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                final cleanImageUrl = imageCtrl.text
                                    .trim()
                                    .replaceAll('"', '')
                                    .replaceAll("'", "");
                                if (cleanImageUrl.isEmpty) {
                                  setSheetState(
                                    () => imageError =
                                        'Please upload or provide an image',
                                  );
                                  return;
                                }

                                setSheetState(() {
                                  isSaving = true;
                                  imageError = null;
                                });

                                try {
                                  final category = Category(
                                    categoryName: nameCtrl.text.trim(),
                                    categoryImageUrl: cleanImageUrl,
                                    subCategory:
                                        categoryToEdit?.subCategory ?? {},
                                  );

                                  if (isEdit) {
                                    await controller.updateCategory(
                                      categoryToEdit.categoryName,
                                      category,
                                    );
                                  } else {
                                    await controller.uploadCategory(category);
                                  }

                                  if (context.mounted) {
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    Navigator.pop(context);
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isEdit
                                              ? 'Category updated'
                                              : 'Category added',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  if (context.mounted) {
                                    setSheetState(() {
                                      isSaving = false;
                                      imageError = error.toString();
                                    });
                                  }
                                }
                              }
                            },
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AdminThemeTokens.white,
                              ),
                            )
                          : Text(
                              isEdit ? 'Update Category' : 'Save Category',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    nameCtrl.dispose();
    imageCtrl.dispose();
  });
}

Future<void> showAddSubcategoryDialog({
  required BuildContext context,
  required AdminCategoryController controller,
  SubCategory? subcategoryToEdit,
}) async {
  if (controller.categories.isEmpty) {
    _showCatalogSnackBar(context, 'Create category first');
    return;
  }

  final isEdit = subcategoryToEdit != null;
  final formKey = GlobalKey<FormState>();
  String selectedCategory =
      subcategoryToEdit?.categoryId ?? controller.categories.first.categoryName;
  
  final List<TextEditingController> nameControllers = [];
  if (isEdit && subcategoryToEdit.subCategoriesName.isNotEmpty) {
    for (final name in subcategoryToEdit.subCategoriesName) {
      nameControllers.add(TextEditingController(text: name));
    }
  } else {
    nameControllers.add(TextEditingController());
  }

  final imageCtrl = TextEditingController(
    text: subcategoryToEdit?.subCategoriesUrl,
  );
  String? imageError;
  var isUploadingImage = false;
  var isSaving = false;

  await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: AdminResponsive.bottomSheetConstraints(context),
    backgroundColor: AdminThemeTokens.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: AdminResponsive.pageHorizontalPadding(context),
              right: AdminResponsive.pageHorizontalPadding(context),
              top: 20.h,
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
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AdminAppTheme.getBorderColor(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      isEdit ? 'Edit Subcategory' : 'Add New Subcategory',
                      style: AdminTextStyles.sectionTitle(context),
                    ),
                    SizedBox(height: 20.h),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Parent Category',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.categoryName,
                              child: Text(
                                c.categoryName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setSheetState(() => selectedCategory = val!),
                    ),
                    SizedBox(height: 16.h),
                    ...List.generate(nameControllers.length, (index) {
                      final ctrl = nameControllers[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ModernTextField(
                                controller: ctrl,
                                labelText: 'Subcategory Name ${index + 1}',
                                hintText: 'Enter subcategory name',
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            if (nameControllers.length > 1) ...[
                              SizedBox(width: 8.w),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AdminAppTheme.getErrorColor(context),
                                ),
                                onPressed: () {
                                  setSheetState(() {
                                    ctrl.dispose();
                                    nameControllers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add More'),
                          style: TextButton.styleFrom(
                            foregroundColor: AdminAppTheme.getTealColor(context),
                          ),
                          onPressed: () {
                            setSheetState(() {
                              nameControllers.add(TextEditingController());
                            });
                          },
                        ),
                      ),
                    ),
                    if (imageCtrl.text.trim().isNotEmpty) ...[
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 120.r.clamp(96.0, 132.0),
                              height: 120.r.clamp(96.0, 132.0),
                              child: ImagePreview(
                                imageUrl: imageCtrl.text
                                    .trim()
                                    .replaceAll('"', '')
                                    .replaceAll("'", ""),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: AdminAppTheme.getErrorColor(context),
                              ),
                              onPressed: () =>
                                  setSheetState(() => imageCtrl.clear()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    ModernTextField(
                      controller: imageCtrl,
                      labelText: 'Image URL (Optional)',
                      hintText: 'Paste link or upload below',
                      onChanged: (_) => setSheetState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    ImagePickerButton(
                      isUploading: isUploadingImage,
                      label: 'Upload Image',
                      onPressed: () {
                        () async {
                          setSheetState(() {
                            isUploadingImage = true;
                            imageError = null;
                          });
                          try {
                            final source =
                                await AdminImageUploadService.pickImageSource(
                                  context,
                                );
                            if (source == null) return;
                            final url =
                                await AdminImageUploadService.pickCropAndUploadImage(
                                  source: source,
                                  folder: 'subcategories',
                                  toolbarTitle: 'Crop Image',
                                  aspectRatio: const CropAspectRatio(
                                    ratioX: 1,
                                    ratioY: 1,
                                  ),
                                );
                            if (url != null && context.mounted) {
                              setSheetState(() => imageCtrl.text = url);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setSheetState(
                                () => imageError = e.toString(),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setSheetState(() => isUploadingImage = false);
                            }
                          }
                        }();
                      },
                    ),
                    if (imageError != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        imageError!,
                        style: TextStyle(
                          color: AdminAppTheme.getErrorColor(context),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 26.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminAppTheme.getTealColor(context),
                        foregroundColor: AdminThemeTokens.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (isSaving || isUploadingImage)
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                final names = nameControllers
                                    .map((c) => c.text.trim())
                                    .where((n) => n.isNotEmpty)
                                    .toList();
                                if (names.isEmpty) {
                                  setSheetState(() => imageError = 'Please add at least one subcategory name');
                                  return;
                                }

                                setSheetState(() {
                                  isSaving = true;
                                  imageError = null;
                                });

                                try {
                                  final subCategory = SubCategory(
                                    categoryId: selectedCategory,
                                    subCategoriesName: names,
                                    subCategoriesUrl: imageCtrl.text
                                        .trim()
                                        .replaceAll('"', '')
                                        .replaceAll("'", ""),
                                  );

                                  if (isEdit) {
                                    await controller.updateSubCategory(
                                      subcategoryToEdit.categoryId,
                                      subcategoryToEdit.subCategoriesName.first,
                                      subCategory,
                                    );
                                  } else {
                                    await controller.uploadSubCategory(
                                      subCategory,
                                    );
                                  }

                                  if (context.mounted) {
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    Navigator.pop(context);
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isEdit
                                              ? 'Subcategory updated'
                                              : 'Subcategory added',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  if (context.mounted) {
                                    setSheetState(() {
                                      isSaving = false;
                                      imageError = error.toString();
                                    });
                                  }
                                }
                              }
                            },
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AdminThemeTokens.white,
                              ),
                            )
                          : Text(
                              isEdit
                                  ? 'Update Subcategory'
                                  : 'Save Subcategory',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    for (final ctrl in nameControllers) {
      ctrl.dispose();
    }
    imageCtrl.dispose();
  });
}

void _showCatalogSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
