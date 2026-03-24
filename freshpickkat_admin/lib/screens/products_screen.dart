import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';

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
    final countryOfOriginCtrl = TextEditingController(text: 'India');
    final priceCtrl = TextEditingController();
    final mrpCtrl = TextEditingController();
    final discountCtrl = TextEditingController(text: '0');
    var discountType = 'percentage'; // Default type
    final bogoFreeProductIds = <String>{}; // Selected free products
    final selectedBogoProducts = <String, Product>{};
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
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, false),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SectionCard(
                              icon: Icons.info_outline,
                              title: 'Basic Info',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: nameCtrl,
                                    labelText: 'Product name',
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernDropdown<String>(
                                    value: selectedCategory,
                                    labelText: 'Category',
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
                                  if (selectedCategory != null) ...[
                                    const SizedBox(height: 12),
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
                                            selectedSubcategories.removeAll(
                                              bunch,
                                            );
                                          }
                                          subcategoryError = null;
                                        });
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.image_outlined,
                              title: 'Product Image',
                              child: Column(
                                children: [
                                  if (imageCtrl.text.trim().isNotEmpty) ...[
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ImagePreview(
                                          imageUrl: imageCtrl.text.trim(),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
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
                                    onChanged: (v) => setDialogState(() {}),
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
                                    onPressed: () async {
                                      setDialogState(
                                        () => isUploadingImage = true,
                                      );
                                      try {
                                        final source = await _pickImageSource();
                                        if (source == null) return;
                                        final url =
                                            await _pickAndUploadProductImage(
                                              source,
                                            );
                                        if (url != null && context.mounted) {
                                          setDialogState(
                                            () => imageCtrl.text = url,
                                          );
                                        }
                                      } catch (e) {
                                        setDialogState(
                                          () => imageError = e.toString(),
                                        );
                                      } finally {
                                        if (context.mounted) {
                                          setDialogState(
                                            () => isUploadingImage = false,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  if (imageError != null) ...[
                                    const SizedBox(height: 8),
                                    ErrorMessage(message: imageError!),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.inventory_2_outlined,
                              title: 'Quantity',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: quantityCtrl,
                                    labelText: 'e.g., 1kg, 500ml',
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernTextField(
                                    controller: countryOfOriginCtrl,
                                    labelText: 'Country of Origin (Optional)',
                                    hintText: 'e.g., India',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.local_offer_outlined,
                              title: 'Pricing',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: priceCtrl,
                                    labelText: 'Selling Price',
                                    prefixText: '₹ ',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    onChanged: (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      final d =
                                          double.tryParse(discountCtrl.text) ??
                                          0;
                                      if (discountType == 'percentage' &&
                                          d < 100) {
                                        mrpCtrl.text = (p / (1 - (d / 100)))
                                            .toStringAsFixed(0);
                                      } else {
                                        mrpCtrl.text = (p + d).toStringAsFixed(
                                          0,
                                        );
                                      }
                                    },
                                    validator: _numberValidator,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernTextField(
                                    controller: mrpCtrl,
                                    labelText: 'MRP',
                                    prefixText: '₹ ',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: _numberValidator,
                                  ),
                                  const SizedBox(height: 12),
                                  CompactFieldRow(
                                    children: [
                                      ModernDropdown<String>(
                                        value: discountType,
                                        labelText: 'Type',
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'percentage',
                                            child: Text('Percentage (%)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'flat',
                                            child: Text('Flat (₹)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'bogo',
                                            child: Text('🎁 BOGO'),
                                          ),
                                        ],

                                        onChanged: (value) {
                                          if (value != null) {
                                            setDialogState(() {
                                              discountType = value;
                                              if (discountType == 'bogo') {
                                                discountCtrl.text = '0';
                                                mrpCtrl.text = priceCtrl.text;
                                              } else {
                                                final d =
                                                    double.tryParse(
                                                      discountCtrl.text,
                                                    ) ??
                                                    0;
                                                final p =
                                                    double.tryParse(
                                                      priceCtrl.text,
                                                    ) ??
                                                    0;
                                                if (discountType ==
                                                        'percentage' &&
                                                    d < 100) {
                                                  mrpCtrl.text =
                                                      (p / (1 - (d / 100)))
                                                          .toStringAsFixed(0);
                                                } else {
                                                  mrpCtrl.text = (p + d)
                                                      .toStringAsFixed(0);
                                                }
                                              }
                                            });
                                          }
                                        },
                                      ),
                                      if (discountType != 'bogo')
                                        ModernTextField(
                                          controller: discountCtrl,
                                          labelText: 'Discount',
                                          prefixText: discountType == 'flat'
                                              ? '₹ '
                                              : null,
                                          suffixText:
                                              discountType == 'percentage'
                                              ? '%'
                                              : null,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          onChanged: (v) {
                                            final d = double.tryParse(v) ?? 0;
                                            final p =
                                                double.tryParse(
                                                  priceCtrl.text,
                                                ) ??
                                                0;
                                            if (discountType == 'percentage' &&
                                                d < 100) {
                                              mrpCtrl.text =
                                                  (p / (1 - (d / 100)))
                                                      .toStringAsFixed(0);
                                            } else {
                                              mrpCtrl.text = (p + d)
                                                  .toStringAsFixed(0);
                                            }
                                          },
                                          validator: _numberValidator,
                                        ),
                                    ],
                                  ),
                                  if (discountType == 'bogo') ...[
                                    const SizedBox(height: 12),
                                    _BogoSelectorWidget(
                                      selectedProducts: selectedBogoProducts
                                          .values
                                          .toList(),
                                      unresolvedIds: bogoFreeProductIds
                                          .difference(
                                            selectedBogoProducts.keys.toSet(),
                                          ),
                                      canBrowse:
                                          selectedCategory != null &&
                                          selectedCategory!.trim().isNotEmpty,
                                      onBrowsePressed: () async {
                                        if (selectedCategory == null ||
                                            selectedCategory!.trim().isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please select product category first',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final result =
                                            await Navigator.of(
                                              context,
                                            ).push<List<Product>>(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    BogoProductPickerScreen(
                                                      initialCategory:
                                                          selectedCategory,
                                                      initiallySelectedProducts:
                                                          selectedBogoProducts
                                                              .values
                                                              .toList(),
                                                    ),
                                              ),
                                            );

                                        if (result == null) return;
                                        setDialogState(() {
                                          selectedBogoProducts
                                            ..clear()
                                            ..addEntries(
                                              result
                                                  .where(
                                                    (product) =>
                                                        product.productId !=
                                                        null,
                                                  )
                                                  .map(
                                                    (product) => MapEntry(
                                                      product.productId!,
                                                      product,
                                                    ),
                                                  ),
                                            );
                                          bogoFreeProductIds
                                            ..clear()
                                            ..addAll(selectedBogoProducts.keys);
                                        });
                                      },
                                      onRemove: (productId) {
                                        setDialogState(() {
                                          bogoFreeProductIds.remove(productId);
                                          selectedBogoProducts.remove(
                                            productId,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            AvailabilitySwitch(
                              value: isAvailable,
                              onChanged: (value) =>
                                  setDialogState(() => isAvailable = value),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              if (selectedSubcategories.isEmpty) {
                                setDialogState(
                                  () => subcategoryError =
                                      'Please select at least one subcategory',
                                );
                                return;
                              }
                              if (discountType == 'bogo' &&
                                  bogoFreeProductIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select at least one free product for BOGO offer',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (selectedCategory != null) {
                                Navigator.pop(context, true);
                              }
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Save Product'),
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
      discount: discountType == 'percentage'
          ? double.parse(discountCtrl.text.trim())
          : 0,
      discountType: discountType,
      discountValue: double.parse(discountCtrl.text.trim()),
      isAvailable: isAvailable,
      addedAt: DateTime.now(),
      subcategory: selectedSubcategories.toList(),
      quantity: quantityCtrl.text.trim(),
      countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
          ? null
          : countryOfOriginCtrl.text.trim(),
      mostSearch: 0,
      mostPurchases: 0,
      bogoFreeProductIds: bogoFreeProductIds.toList(),
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
    final countryOfOriginCtrl = TextEditingController(
      text: product.countryOfOrigin ?? '',
    );
    final priceCtrl = TextEditingController(text: product.price.toString());
    final mrpCtrl = TextEditingController(text: product.realPrice.toString());
    final discountCtrl = TextEditingController(
      text: (product.discountValue ?? product.discount).toString(),
    );
    var discountType = product.discountType ?? 'percentage';
    final bogoFreeProductIds = <String>{};
    final selectedBogoProducts = <String, Product>{};
    var isAvailable = product.isAvailable;

    // Fetch BOGO offer
    if (discountType == 'bogo') {
      try {
        final offer = await ServerpodAdminClient().client.bogo
            .getOfferForProduct(product.productId!);
        if (offer != null) {
          bogoFreeProductIds.addAll(offer.freeProductIds);
        }
      } catch (e) {
        debugPrint('Error fetching BOGO offer: $e');
      }

      if (bogoFreeProductIds.isNotEmpty) {
        final resolvedProducts = await _resolveSelectedBogoProducts(
          selectedIds: bogoFreeProductIds,
          preferredCategory: product.category,
        );
        selectedBogoProducts.addAll(resolvedProducts);
      }
    }

    var isUploadingImage = false;

    String? imageError;

    String? selectedCategory = product.category;
    final selectedSubcategories = <String>{...product.subcategory};
    String? subcategoryError;

    if (!mounted) return;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Product',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, false),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SectionCard(
                              icon: Icons.info_outline,
                              title: 'Basic Info',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: nameCtrl,
                                    labelText: 'Product name',
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernDropdown<String>(
                                    value: selectedCategory,
                                    labelText: 'Category',
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
                                  if (selectedCategory != null) ...[
                                    const SizedBox(height: 12),
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
                                            selectedSubcategories.removeAll(
                                              bunch,
                                            );
                                          }
                                          subcategoryError = null;
                                        });
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.image_outlined,
                              title: 'Product Image',
                              child: Column(
                                children: [
                                  if (imageCtrl.text.trim().isNotEmpty) ...[
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ImagePreview(
                                          imageUrl: imageCtrl.text.trim(),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
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
                                    onChanged: (v) => setDialogState(() {}),
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
                                    onPressed: () async {
                                      setDialogState(
                                        () => isUploadingImage = true,
                                      );
                                      try {
                                        final source = await _pickImageSource();
                                        if (source == null) return;
                                        final url =
                                            await _pickAndUploadProductImage(
                                              source,
                                            );
                                        if (url != null && context.mounted) {
                                          setDialogState(
                                            () => imageCtrl.text = url,
                                          );
                                        }
                                      } catch (e) {
                                        setDialogState(
                                          () => imageError = e.toString(),
                                        );
                                      } finally {
                                        if (context.mounted) {
                                          setDialogState(
                                            () => isUploadingImage = false,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  if (imageError != null) ...[
                                    const SizedBox(height: 8),
                                    ErrorMessage(message: imageError!),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.inventory_2_outlined,
                              title: 'Quantity',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: quantityCtrl,
                                    labelText: 'e.g., 1kg, 500ml',
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernTextField(
                                    controller: countryOfOriginCtrl,
                                    labelText: 'Country of Origin (Optional)',
                                    hintText: 'e.g., India',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionCard(
                              icon: Icons.local_offer_outlined,
                              title: 'Pricing',
                              child: Column(
                                children: [
                                  ModernTextField(
                                    controller: priceCtrl,
                                    labelText: 'Selling Price',
                                    prefixText: '₹ ',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    onChanged: (v) {
                                      final p = double.tryParse(v) ?? 0;
                                      final d =
                                          double.tryParse(discountCtrl.text) ??
                                          0;
                                      if (discountType == 'percentage' &&
                                          d < 100) {
                                        mrpCtrl.text = (p / (1 - (d / 100)))
                                            .toStringAsFixed(0);
                                      } else {
                                        mrpCtrl.text = (p + d).toStringAsFixed(
                                          0,
                                        );
                                      }
                                    },
                                    validator: _numberValidator,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernTextField(
                                    controller: mrpCtrl,
                                    labelText: 'MRP',
                                    prefixText: '₹ ',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: _numberValidator,
                                  ),
                                  const SizedBox(height: 12),
                                  CompactFieldRow(
                                    children: [
                                      ModernDropdown<String>(
                                        value: discountType,
                                        labelText: 'Type',
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'percentage',
                                            child: Text('Percentage (%)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'flat',
                                            child: Text('Flat (₹)'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'bogo',
                                            child: Text('🎁 BOGO'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setDialogState(() {
                                              discountType = value;
                                              if (discountType == 'bogo') {
                                                discountCtrl.text = '0';
                                                mrpCtrl.text = priceCtrl.text;
                                              } else {
                                                final d =
                                                    double.tryParse(
                                                      discountCtrl.text,
                                                    ) ??
                                                    0;
                                                final p =
                                                    double.tryParse(
                                                      priceCtrl.text,
                                                    ) ??
                                                    0;
                                                if (discountType ==
                                                        'percentage' &&
                                                    d < 100) {
                                                  mrpCtrl.text =
                                                      (p / (1 - (d / 100)))
                                                          .toStringAsFixed(0);
                                                } else {
                                                  mrpCtrl.text = (p + d)
                                                      .toStringAsFixed(0);
                                                }
                                              }
                                            });
                                          }
                                        },
                                      ),
                                      if (discountType != 'bogo')
                                        ModernTextField(
                                          controller: discountCtrl,
                                          labelText: 'Discount',
                                          prefixText: discountType == 'flat'
                                              ? '₹ '
                                              : null,
                                          suffixText:
                                              discountType == 'percentage'
                                              ? '%'
                                              : null,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          onChanged: (v) {
                                            final d = double.tryParse(v) ?? 0;
                                            final p =
                                                double.tryParse(
                                                  priceCtrl.text,
                                                ) ??
                                                0;
                                            if (discountType == 'percentage' &&
                                                d < 100) {
                                              mrpCtrl.text =
                                                  (p / (1 - (d / 100)))
                                                      .toStringAsFixed(0);
                                            } else {
                                              mrpCtrl.text = (p + d)
                                                  .toStringAsFixed(0);
                                            }
                                          },
                                          validator: _numberValidator,
                                        ),
                                    ],
                                  ),
                                  if (discountType == 'bogo') ...[
                                    const SizedBox(height: 12),
                                    _BogoSelectorWidget(
                                      selectedProducts: selectedBogoProducts
                                          .values
                                          .toList(),
                                      unresolvedIds: bogoFreeProductIds
                                          .difference(
                                            selectedBogoProducts.keys.toSet(),
                                          ),
                                      canBrowse:
                                          selectedCategory != null &&
                                          selectedCategory!.trim().isNotEmpty,
                                      onBrowsePressed: () async {
                                        if (selectedCategory == null ||
                                            selectedCategory!.trim().isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please select product category first',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final result =
                                            await Navigator.of(
                                              context,
                                            ).push<List<Product>>(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    BogoProductPickerScreen(
                                                      initialCategory:
                                                          selectedCategory,
                                                      initiallySelectedProducts:
                                                          selectedBogoProducts
                                                              .values
                                                              .toList(),
                                                    ),
                                              ),
                                            );

                                        if (result == null) return;
                                        setDialogState(() {
                                          selectedBogoProducts
                                            ..clear()
                                            ..addEntries(
                                              result
                                                  .where(
                                                    (product) =>
                                                        product.productId !=
                                                        null,
                                                  )
                                                  .map(
                                                    (product) => MapEntry(
                                                      product.productId!,
                                                      product,
                                                    ),
                                                  ),
                                            );
                                          bogoFreeProductIds
                                            ..clear()
                                            ..addAll(selectedBogoProducts.keys);
                                        });
                                      },
                                      onRemove: (productId) {
                                        setDialogState(() {
                                          bogoFreeProductIds.remove(productId);
                                          selectedBogoProducts.remove(
                                            productId,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            AvailabilitySwitch(
                              value: isAvailable,
                              onChanged: (value) =>
                                  setDialogState(() => isAvailable = value),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              if (selectedSubcategories.isEmpty) {
                                setDialogState(
                                  () => subcategoryError =
                                      'Please select at least one subcategory',
                                );
                                return;
                              }
                              if (discountType == 'bogo' &&
                                  bogoFreeProductIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select at least one free product for BOGO offer',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (selectedCategory != null) {
                                Navigator.pop(context, true);
                              }
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Update Product'),
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
      discount: discountType == 'percentage'
          ? double.parse(discountCtrl.text.trim())
          : 0,
      discountType: discountType,
      discountValue: double.parse(discountCtrl.text.trim()),
      isAvailable: isAvailable,
      subcategory: selectedSubcategories.toList(),
      quantity: quantityCtrl.text.trim(),
      countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
          ? null
          : countryOfOriginCtrl.text.trim(),
      bogoFreeProductIds: bogoFreeProductIds.toList(),
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

  Future<List<Product>> _fetchAllProductsForCategory(String category) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: true,
    );

    final products = <Product>[];
    String? pageToken;

    do {
      final page = await ServerpodAdminClient().client.product.getProductsPage(
        firebaseUid: uid,
        idToken: idToken,
        category: category,
        sortBy: 'name',
        limit: 100,
        pageToken: pageToken,
      );
      products.addAll(page.products);
      pageToken = page.nextPageToken;
    } while (pageToken != null);

    return products;
  }

  Future<Map<String, Product>> _resolveSelectedBogoProducts({
    required Set<String> selectedIds,
    String? preferredCategory,
  }) async {
    final resolved = <String, Product>{};

    for (final product in _productController.products) {
      final id = product.productId;
      if (id != null && selectedIds.contains(id)) {
        resolved[id] = product;
      }
    }

    if ((preferredCategory == null || preferredCategory.trim().isEmpty) ||
        resolved.length == selectedIds.length) {
      return resolved;
    }

    final categoryProducts = await _fetchAllProductsForCategory(
      preferredCategory.trim(),
    );
    for (final product in categoryProducts) {
      final id = product.productId;
      if (id != null && selectedIds.contains(id)) {
        resolved[id] = product;
      }
    }

    return resolved;
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
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DropdownButtonFormField<String>(
                initialValue: _productController.categoryFilter,
                decoration: InputDecoration(
                  labelText: 'Filter by category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
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

class _BogoSelectorWidget extends StatelessWidget {
  final List<Product> selectedProducts;
  final Set<String> unresolvedIds;
  final bool canBrowse;
  final Future<void> Function() onBrowsePressed;
  final ValueChanged<String> onRemove;

  const _BogoSelectorWidget({
    required this.selectedProducts,
    required this.unresolvedIds,
    required this.canBrowse,
    required this.onBrowsePressed,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Free Products (Pick one or more)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: canBrowse ? onBrowsePressed : null,
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: Text(
                selectedProducts.isEmpty ? 'Browse Products' : 'Edit',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!canBrowse)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Text('Select the main product category first.'),
          )
        else if (selectedProducts.isEmpty && unresolvedIds.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text('No free products selected yet.'),
          )
        else
          Column(
            children: [
              ...selectedProducts.map((product) {
                final productId = product.productId;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 52,
                          height: 52,
                          color: Colors.grey.shade100,
                          child: product.imageUrl.isEmpty
                              ? const Icon(Icons.image_outlined)
                              : Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image_outlined,
                                    );
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product.category} • ${product.quantity}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: productId == null
                            ? null
                            : () => onRemove(productId),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                );
              }),
              if (unresolvedIds.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unresolvedIds
                      .map(
                        (id) => Chip(
                          label: Text('Unresolved: $id'),
                          onDeleted: () => onRemove(id),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
      ],
    );
  }
}
