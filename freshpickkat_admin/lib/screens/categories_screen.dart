import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/network_error_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final AdminCategoryController _controller = AdminCategoryController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _controller.loadCategories,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.networkController.retryLastRequest(),
          );
        }

        final categories = _controller.categories;
        final subCategories = _controller.subCategories;
        final isLoading = _controller.isLoading.value;
        final error = _controller.error.value;

        if (isLoading && categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && categories.isEmpty) {
          return Center(child: Text('Error: $error'));
        }

        return RefreshIndicator(
          onRefresh: _controller.loadCategories,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                    child: ListTile(
                      title: Text(category.categoryName),
                      subtitle: Text(
                        'Mapped subcategories: ${category.subCategory.length}',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Subcategories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (subCategories.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No subcategories yet'),
                  ),
                )
              else
                ...subCategories.map(
                  (sub) => Card(
                    child: ListTile(
                      title: Text(sub.subCategoriesName.join(', ')),
                      subtitle: Text('Category: ${sub.categoryId}'),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addCategory',
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: _openAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Category'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'addSubCategory',
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            onPressed: _openAddSubcategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Subcategory'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddCategoryDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    bool isSubmitting = false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Category'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Category name',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => isSubmitting = true);
                          final messenger = ScaffoldMessenger.of(this.context);
                          try {
                            await _controller.uploadCategory(
                              Category(
                                categoryName: nameCtrl.text.trim(),
                                categoryImageUrl: imageCtrl.text.trim(),
                                subCategory: {},
                              ),
                            );
                            if (!mounted || !context.mounted) return;
                            Navigator.pop(context, true);
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Category added')),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Failed to add category: $e'),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setDialogState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;
  }

  Future<void> _openAddSubcategoryDialog() async {
    if (_controller.categories.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Create category first')));
      return;
    }

    final formKey = GlobalKey<FormState>();
    String selectedCategory = _controller.categories.first.categoryName;
    final nameCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    bool isSubmitting = false;

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
                      items: _controller.categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.categoryName,
                              child: Text(c.categoryName),
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
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => isSubmitting = true);
                          final messenger = ScaffoldMessenger.of(this.context);
                          try {
                            await _controller.uploadSubCategory(
                              SubCategory(
                                categoryId: selectedCategory,
                                subCategoriesName: [nameCtrl.text.trim()],
                                subCategoriesUrl: imageCtrl.text.trim(),
                              ),
                            );
                            if (!mounted || !context.mounted) return;
                            Navigator.pop(context, true);
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Subcategory added'),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Failed to add subcategory: $e'),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setDialogState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;
  }
}
