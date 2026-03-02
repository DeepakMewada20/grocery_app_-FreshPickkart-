import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:image_picker/image_picker.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _client = ServerpodAdminClient().client;

  List<Product> _products = [];
  List<Category> _categories = [];
  List<SubCategory> _subCategories = [];
  String _searchQuery = '';
  String _categoryFilter = 'All';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await Future.wait([
        _client.product.getProducts(limit: 100, sortBy: 'name'),
        _client.category.getCategories(),
        _client.subCategory.getSubCategories(),
      ]);

      _products = result[0] as List<Product>;
      _categories = result[1] as List<Category>;
      _subCategories = result[2] as List<SubCategory>;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
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

    String? selectedCategory;
    final selectedSubcategories = <String>{};
    String? subcategoryError;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Product name',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        items: _categories
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
                          options: _subcategoryOptionsFor(selectedCategory!),
                          selected: selectedSubcategories,
                          errorText: subcategoryError,
                          onToggle: (name, checked) {
                            setDialogState(() {
                              if (checked) {
                                selectedSubcategories.add(name);
                              } else {
                                selectedSubcategories.remove(name);
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isUploadingImage
                              ? null
                              : () async {
                                  setDialogState(() => isUploadingImage = true);
                                  try {
                                    final source = await _pickImageSource();
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
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Image upload failed: $e',
                                        ),
                                      ),
                                    );
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
                            isUploadingImage ? 'Uploading...' : 'Upload Image',
                          ),
                        ),
                      ),
                      if (imageCtrl.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageCtrl.text.trim(),
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 90,
                              alignment: Alignment.center,
                              color: Colors.grey.shade200,
                              child: const Text('Image preview unavailable'),
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: mrpCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'MRP'),
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Selling price',
                        ),
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: discountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Discount %',
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
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
              ],
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
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.uploadProduct(product, uid, idToken);
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

    String? selectedCategory = product.category;
    final selectedSubcategories = <String>{...product.subcategory};
    String? subcategoryError;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Product name',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        items: _categories
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
                          options: _subcategoryOptionsFor(selectedCategory!),
                          selected: selectedSubcategories,
                          errorText: subcategoryError,
                          onToggle: (name, checked) {
                            setDialogState(() {
                              if (checked) {
                                selectedSubcategories.add(name);
                              } else {
                                selectedSubcategories.remove(name);
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isUploadingImage
                              ? null
                              : () async {
                                  setDialogState(() => isUploadingImage = true);
                                  try {
                                    final source = await _pickImageSource();
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
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Image upload failed: $e',
                                        ),
                                      ),
                                    );
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
                            isUploadingImage ? 'Uploading...' : 'Upload Image',
                          ),
                        ),
                      ),
                      if (imageCtrl.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageCtrl.text.trim(),
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 90,
                              alignment: Alignment.center,
                              color: Colors.grey.shade200,
                              child: const Text('Image preview unavailable'),
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
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: mrpCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'MRP'),
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Selling price',
                        ),
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: discountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Discount %',
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
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
              ],
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
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.updateProduct(updated, uid, idToken);
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
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.deleteProduct(product.productId!, uid, idToken);
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

    final uid = AdminSessionService.requireUid();
    final file = File(picked.path);
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

  List<String> _subcategoryOptionsFor(String categoryName) {
    final loweredCategory = categoryName.toLowerCase().trim();
    final options = <String>{};

    final matchingCategory = _categories.where(
      (c) => c.categoryName.toLowerCase().trim() == loweredCategory,
    );
    for (final category in matchingCategory) {
      options.addAll(category.subCategory.keys);
    }

    final matchingSubCategories = _subCategories.where(
      (s) => s.categoryId.toLowerCase().trim() == loweredCategory,
    );
    for (final subCategory in matchingSubCategories) {
      options.addAll(subCategory.subCategoriesName);
    }

    return options.where((e) => e.trim().isNotEmpty).toList()..sort();
  }

  List<Product> _visibleProducts() {
    final query = _searchQuery.toLowerCase().trim();
    return _products.where((p) {
      final categoryMatch =
          _categoryFilter == 'All' || p.category == _categoryFilter;
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
        title: const Text('Products'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _products.isEmpty
          ? const Center(child: Text('No products found'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search products',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: DropdownButtonFormField<String>(
                    initialValue: _categoryFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter by category',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All')),
                      ..._categories.map(
                        (c) => DropdownMenuItem(
                          value: c.categoryName,
                          child: Text(c.categoryName),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _categoryFilter = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: Builder(
                      builder: (context) {
                        final visible = _visibleProducts();
                        if (visible.isEmpty) {
                          return ListView(
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('No matching products')),
                            ],
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final product = visible[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    product.imageUrl,
                                  ),
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
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
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
                      },
                    ),
                  ),
                ),
              ],
            ),
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
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final String? errorText;
  final void Function(String name, bool checked) onToggle;

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
          children: options
              .map(
                (name) => FilterChip(
                  label: Text(name),
                  selected: selected.contains(name),
                  onSelected: (checked) => onToggle(name, checked),
                ),
              )
              .toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
