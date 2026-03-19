import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:image_cropper/image_cropper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AdminProductController _productController =
      AdminProductController.instance;
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;

  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    print('DEBUG: _loadData pulling refresh...');
    await _categoryController.loadCategories();
    await _productController.loadInitial();
    print('DEBUG: _loadData refresh complete.');
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    // Increased threshold for more sensitive triggering
    if (position.pixels >= position.maxScrollExtent - 300) {
      if (_productController.hasMore.value &&
          !_productController.isLoadingMore.value) {
        print('DEBUG: _handleScroll triggering loadMore...');
        _productController.loadMore();
      }
    }
  }

  Future<void> _openAddProductDialog() async {
    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    final quantityCtrl = TextEditingController(text: '1kg');
    final priceCtrl = TextEditingController();
    final mrpCtrl = TextEditingController();
    final discountCtrl = TextEditingController(text: '0');
    var isAvailable = true;
    var isUploadingImage = false;
    String? imageError;

    String? selectedCategory;
    final selectedSubcategories = <String>{};
    String? subcategoryError;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Product name',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              initialValue: selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                              items: _categoryController.categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.categoryName,
                                      child: Text(c.categoryName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedCategory = value;
                                  selectedSubcategories.clear();
                                  subcategoryError = null;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            if (selectedCategory != null)
                              _SubcategorySelector(
                                options: _categoryController
                                    .groupedSubcategoryOptionsFor(
                                      selectedCategory!,
                                    ),
                                selected: selectedSubcategories,
                                errorText: subcategoryError,
                                onToggleBunch: (bunch, checked) {
                                  setDialogState(() {
                                    if (checked) {
                                      selectedSubcategories.addAll(bunch);
                                    } else {
                                      selectedSubcategories.removeAll(bunch);
                                    }
                                    subcategoryError = null;
                                  });
                                },
                              ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: imageCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Product image',
                                hintText: 'Upload from gallery',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: isUploadingImage
                                    ? null
                                    : () async {
                                        setDialogState(
                                          () => isUploadingImage = true,
                                        );
                                        try {
                                          final source =
                                              await _pickImageSource();
                                          if (source == null) return;
                                          final url =
                                              await _pickAndUploadProductImage(
                                                source,
                                              );
                                          if (url != null && context.mounted) {
                                            setDialogState(() {
                                              imageCtrl.text = url;
                                            });
                                          }
                                        } catch (e) {
                                          setDialogState(() {
                                            imageError = e.toString();
                                          });
                                        } finally {
                                          if (context.mounted) {
                                            setDialogState(
                                              () => isUploadingImage = false,
                                            );
                                          }
                                        }
                                      },
                                icon: isUploadingImage
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.upload),
                                label: Text(
                                  isUploadingImage
                                      ? 'Uploading...'
                                      : 'Upload Image',
                                ),
                              ),
                            ),
                            if (imageError != null) ...[
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  imageError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            if (imageCtrl.text.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageCtrl.text.trim(),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Container(
                                    height: 200,
                                    alignment: Alignment.center,
                                    color: Colors.grey.shade200,
                                    child: const Text(
                                      'Image preview unavailable',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: quantityCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: priceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Selling price',
                              ),
                              onChanged: (v) {
                                final p = double.tryParse(v) ?? 0;
                                final d =
                                    double.tryParse(discountCtrl.text) ?? 0;
                                if (d < 100) {
                                  final mrp = p / (1 - (d / 100));
                                  mrpCtrl.text = mrp.toStringAsFixed(0);
                                }
                              },
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: discountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Discount %',
                              ),
                              onChanged: (v) {
                                final d = double.tryParse(v) ?? 0;
                                final p = double.tryParse(priceCtrl.text) ?? 0;
                                if (d < 100) {
                                  final mrp = p / (1 - (d / 100));
                                  mrpCtrl.text = mrp.toStringAsFixed(0);
                                }
                              },
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: mrpCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'MRP',
                              ),
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Available'),
                              value: isAvailable,
                              onChanged: (value) {
                                setDialogState(() {
                                  isAvailable = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              if (selectedSubcategories.isEmpty) {
                                setDialogState(() {
                                  subcategoryError =
                                      'Please select at least one subcategory';
                                });
                                return;
                              }
                              if (selectedCategory != null) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved != true) return;

    final product = Product(
      productName: nameCtrl.text.trim(),
      category: selectedCategory!.trim(),
      imageUrl: imageCtrl.text.trim(),
      price: double.parse(priceCtrl.text.trim()),
      realPrice: double.parse(mrpCtrl.text.trim()),
      discount: double.parse(discountCtrl.text.trim()),
      isAvailable: isAvailable,
      addedAt: DateTime.now(),
      subcategory: selectedSubcategories.toList(),
      quantity: quantityCtrl.text.trim(),
      mostSearch: 0,
      mostPurchases: 0,
    );

    try {
      await _productController.addProduct(product);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added')));
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    }
  }

  Future<void> _openEditProductDialog(Product product) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: product.productName);
    final imageCtrl = TextEditingController(text: product.imageUrl);
    final quantityCtrl = TextEditingController(text: product.quantity);
    final priceCtrl = TextEditingController(text: product.price.toString());
    final mrpCtrl = TextEditingController(text: product.realPrice.toString());
    final discountCtrl = TextEditingController(
      text: product.discount.toString(),
    );
    var isAvailable = product.isAvailable;
    var isUploadingImage = false;
    String? imageError;

    String? selectedCategory = product.category;
    final selectedSubcategories = <String>{...product.subcategory};
    String? subcategoryError;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Product name',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              initialValue: selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                              items: _categoryController.categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.categoryName,
                                      child: Text(c.categoryName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedCategory = value;
                                  selectedSubcategories.clear();
                                  subcategoryError = null;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            if (selectedCategory != null)
                              _SubcategorySelector(
                                options: _categoryController
                                    .groupedSubcategoryOptionsFor(
                                      selectedCategory!,
                                    ),
                                selected: selectedSubcategories,
                                errorText: subcategoryError,
                                onToggleBunch: (bunch, checked) {
                                  setDialogState(() {
                                    if (checked) {
                                      selectedSubcategories.addAll(bunch);
                                    } else {
                                      selectedSubcategories.removeAll(bunch);
                                    }
                                    subcategoryError = null;
                                  });
                                },
                              ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: imageCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Product image',
                                hintText: 'Upload from gallery',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: isUploadingImage
                                    ? null
                                    : () async {
                                        setDialogState(
                                          () => isUploadingImage = true,
                                        );
                                        try {
                                          final source =
                                              await _pickImageSource();
                                          if (source == null) return;
                                          final url =
                                              await _pickAndUploadProductImage(
                                                source,
                                              );
                                          if (url != null && context.mounted) {
                                            setDialogState(() {
                                              imageCtrl.text = url;
                                            });
                                          }
                                        } catch (e) {
                                          setDialogState(() {
                                            imageError = e.toString();
                                          });
                                        } finally {
                                          if (context.mounted) {
                                            setDialogState(
                                              () => isUploadingImage = false,
                                            );
                                          }
                                        }
                                      },
                                icon: isUploadingImage
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.upload),
                                label: Text(
                                  isUploadingImage
                                      ? 'Uploading...'
                                      : 'Upload Image',
                                ),
                              ),
                            ),
                            if (imageError != null) ...[
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  imageError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            if (imageCtrl.text.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageCtrl.text.trim(),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Container(
                                    height: 200,
                                    alignment: Alignment.center,
                                    color: Colors.grey.shade200,
                                    child: const Text(
                                      'Image preview unavailable',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: quantityCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: priceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Selling price',
                              ),
                              onChanged: (v) {
                                final p = double.tryParse(v) ?? 0;
                                final d =
                                    double.tryParse(discountCtrl.text) ?? 0;
                                if (d < 100) {
                                  final mrp = p / (1 - (d / 100));
                                  mrpCtrl.text = mrp.toStringAsFixed(0);
                                }
                              },
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: discountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Discount %',
                              ),
                              onChanged: (v) {
                                final d = double.tryParse(v) ?? 0;
                                final p = double.tryParse(priceCtrl.text) ?? 0;
                                if (d < 100) {
                                  final mrp = p / (1 - (d / 100));
                                  mrpCtrl.text = mrp.toStringAsFixed(0);
                                }
                              },
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: mrpCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'MRP',
                              ),
                              validator: _numberValidator,
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Available'),
                              value: isAvailable,
                              onChanged: (value) {
                                setDialogState(() {
                                  isAvailable = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              if (selectedSubcategories.isEmpty) {
                                setDialogState(() {
                                  subcategoryError =
                                      'Please select at least one subcategory';
                                });
                                return;
                              }
                              if (selectedCategory != null) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved != true) return;

    final updated = product.copyWith(
      productName: nameCtrl.text.trim(),
      category: selectedCategory!.trim(),
      imageUrl: imageCtrl.text.trim(),
      price: double.parse(priceCtrl.text.trim()),
      realPrice: double.parse(mrpCtrl.text.trim()),
      discount: double.parse(discountCtrl.text.trim()),
      isAvailable: isAvailable,
      subcategory: selectedSubcategories.toList(),
      quantity: quantityCtrl.text.trim(),
    );

    try {
      await _productController.updateProduct(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product updated')));
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update product: $e')));
    }
  }

  Future<void> _deleteProduct(Product product) async {
    if (product.productId == null || product.productId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid product id')));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _productController.deleteProduct(product.productId!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product deleted')));
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return double.tryParse(value.trim()) == null ? 'Invalid number' : null;
  }

  Future<String?> _pickAndUploadProductImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (picked == null) return null;

    // Image Cropping
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );

    if (croppedFile == null) return null;

    final uid = AdminSessionService.requireUid();
    final file = File(croppedFile.path);
    final now = DateTime.now().millisecondsSinceEpoch;
    final name = picked.name.replaceAll(' ', '_');
    final ref = FirebaseStorage.instance
        .ref()
        .child('products')
        .child(uid)
        .child('${now}_$name');

    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<ImageSource?> _pickImageSource() async {
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

  List<Product> _visibleProducts() {
    final query = _searchQuery.toLowerCase().trim();
    return _productController.products.where((p) {
      final categoryMatch =
          _productController.categoryFilter == 'All' ||
          p.category == _productController.categoryFilter;
      if (!categoryMatch) return false;
      if (query.isEmpty) return true;
      return p.productName.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          p.quantity.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Obx(
                () => Text(
                  _productController.totalCount.value > 0
                      ? 'Products (${_productController.totalCount.value})'
                      : 'Products',
                ),
              ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        final products = _productController.products;
        final isLoading = _productController.isLoading.value;
        final error = _productController.error.value;
        final hasMore = _productController.hasMore.value;
        final isLoadingMore = _productController.isLoadingMore.value;

        final categoryItems = <DropdownMenuItem<String>>[
          const DropdownMenuItem<String>(value: 'All', child: Text('All')),
          ..._categoryController.categories.map<DropdownMenuItem<String>>(
            (c) => DropdownMenuItem<String>(
              value: c.categoryName,
              child: Text(c.categoryName),
            ),
          ),
        ];

        if (isLoading && products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && products.isEmpty) {
          return Center(child: Text('Error: $error'));
        }

        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: DropdownButtonFormField<String>(
                initialValue: _productController.categoryFilter,
                decoration: const InputDecoration(
                  labelText: 'Filter by category',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: categoryItems,
                onChanged: (value) {
                  if (value == null) return;
                  _productController.loadInitial(category: value);
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: (() {
                  final visible = _visibleProducts();
                  if (visible.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        const Center(child: Text('No matching products')),
                        if (hasMore) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _productController.loadMore(),
                              child: isLoadingMore
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Load More from Server'),
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        visible.length +
                        (hasMore || isLoadingMore || error != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= visible.length) {
                        if (error != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                Text(
                                  'Error: $error',
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () =>
                                      _productController.loadMore(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = visible[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () => _openEditProductDialog(product),
                          isThreeLine: true,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product.imageUrl),
                            onBackgroundImageError: (_, _) {},
                          ),
                          title: Text(product.productName),
                          subtitle: Text(
                            '${product.category} • ${product.quantity}\n'
                            '₹${product.price.toStringAsFixed(0)} | '
                            '${product.isAvailable ? 'Available' : 'Out of stock'}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openEditProductDialog(product);
                              } else if (value == 'delete') {
                                _deleteProduct(product);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                })(),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _openAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}

class _SubcategorySelector extends StatelessWidget {
  const _SubcategorySelector({
    required this.options,
    required this.selected,
    required this.errorText,
    required this.onToggleBunch,
  });

  final List<List<String>> options;
  final Set<String> selected;
  final String? errorText;
  final void Function(List<String> bunch, bool checked) onToggleBunch;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'No subcategories found for selected category',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Subcategories',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((bunch) {
            final isBunchSelected = bunch.every(
              (item) => selected.contains(item),
            );

            return FilterChip(
              label: Text(bunch.join(', ')), // Show all as one unit
              selected: isBunchSelected,
              onSelected: (checked) => onToggleBunch(bunch, checked),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
