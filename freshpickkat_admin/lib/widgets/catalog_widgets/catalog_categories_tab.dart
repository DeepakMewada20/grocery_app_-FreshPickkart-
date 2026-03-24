import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_picker_button.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/image_preview.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/modern_text_field.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

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
        return Center(child: Text('Error: $error'));
      }

      return RefreshIndicator(
        onRefresh: controller.loadCategories,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CatalogStatCard(
                  title: 'Categories',
                  value: '${categories.length}',
                  icon: Icons.category,
                  color: Colors.green,
                ),
                CatalogStatCard(
                  title: 'Subcategories',
                  value: '${subCategories.length}',
                  icon: Icons.account_tree_outlined,
                  color: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: onAddCategory,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                ),
                ElevatedButton.icon(
                  onPressed: onAddSubcategory,
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  label: const Text('Add Subcategory'),
                ),
              ],
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

Future<void> showAddCategoryDialog({
  required BuildContext context,
  required AdminCategoryController controller,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  String? imageError;
  var isUploadingImage = false;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Category'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Category name',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    if (imageCtrl.text.trim().isNotEmpty) ...[
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ImagePreview(imageUrl: imageCtrl.text.trim()),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setDialogState(() {
                                imageCtrl.clear();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    ModernTextField(
                      controller: imageCtrl,
                      labelText: 'Image URL',
                      hintText: 'Paste image link here',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Category image is required'
                          : null,
                      onChanged: (_) => setDialogState(() {
                        imageError = null;
                      }),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ImagePickerButton(
                      isUploading: isUploadingImage,
                      label: 'Upload Category Image',
                      onPressed: () async {
                        setDialogState(() {
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
                                toolbarTitle: 'Crop Category Image',
                              );
                          if (url != null && context.mounted) {
                            setDialogState(() {
                              imageCtrl.text = url;
                            });
                          }
                        } catch (error) {
                          setDialogState(() {
                            imageError = error.toString();
                          });
                        } finally {
                          if (context.mounted) {
                            setDialogState(() {
                              isUploadingImage = false;
                            });
                          }
                        }
                      },
                    ),
                    if (imageError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        imageError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Save'),
              ),
            ],
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
    _showCatalogSnackBar(context, 'Category added');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Failed to add category: $error');
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

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Subcategory'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: controller.categories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category.categoryName,
                            child: Text(category.categoryName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Subcategory name',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  if (imageCtrl.text.trim().isNotEmpty) ...[
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ImagePreview(imageUrl: imageCtrl.text.trim()),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            setDialogState(() {
                              imageCtrl.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  ModernTextField(
                    controller: imageCtrl,
                    labelText: 'Image URL',
                    hintText: 'Paste image link here',
                    onChanged: (_) => setDialogState(() {
                      imageError = null;
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ImagePickerButton(
                    isUploading: isUploadingImage,
                    label: 'Upload Subcategory Image',
                    onPressed: () async {
                      setDialogState(() {
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
                              toolbarTitle: 'Crop Subcategory Image',
                            );
                        if (url != null && context.mounted) {
                          setDialogState(() {
                            imageCtrl.text = url;
                          });
                        }
                      } catch (error) {
                        setDialogState(() {
                          imageError = error.toString();
                        });
                      } finally {
                        if (context.mounted) {
                          setDialogState(() {
                            isUploadingImage = false;
                          });
                        }
                      }
                    },
                  ),
                  if (imageError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      imageError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Save'),
              ),
            ],
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
    _showCatalogSnackBar(context, 'Subcategory added');
  } catch (error) {
    if (!context.mounted) return;
    _showCatalogSnackBar(context, 'Failed to add subcategory: $error');
  }
}

void _showCatalogSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
