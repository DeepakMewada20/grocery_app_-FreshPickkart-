import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/widgets.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'variant_draft.dart';
import 'variant_editor.dart';
import 'bogo_selector_widget.dart';
import 'subcategory_selector.dart';

enum ProductFormMode { add, edit }

class ProductFormResult {
  final Product product;
  final List<BogoProductSelection>? bogoSelections;
  final List<VariantDraft>? extraVariants;

  ProductFormResult({
    required this.product,
    this.bogoSelections,
    this.extraVariants,
  });
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  final List<Category> categories;
  final List<List<String>> Function(String category)
  groupedSubcategoryOptionsFor;

  const ProductFormDialog({
    super.key,
    this.product,
    required this.categories,
    required this.groupedSubcategoryOptionsFor,
  });

  static Future<ProductFormResult?> show({
    required BuildContext context,
    Product? product,
    required List<Category> categories,
    required List<List<String>> Function(String category)
    groupedSubcategoryOptionsFor,
  }) {
    return showModalBottomSheet<ProductFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ProductFormDialog(
        product: product,
        categories: categories,
        groupedSubcategoryOptionsFor: groupedSubcategoryOptionsFor,
      ),
    );
  }

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl;
  late final TextEditingController imageCtrl;
  late final TextEditingController quantityValueCtrl;
  late final TextEditingController countryOfOriginCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController mrpCtrl;
  late final TextEditingController discountCtrl;

  late List<VariantDraft> extraVariants;
  late String discountType;
  late String baseUnit;
  final bogoFreeProductIds = <String>{};
  final selectedBogoProducts = <String, Product>{};
  final bogoFreeProductQuantities = <String, String>{};
  late bool isAvailable;
  bool isUploadingImage = false;
  String? imageError;

  String? selectedCategory;
  final selectedSubcategories = <String>{};
  String? subcategoryError;

  bool get isEditMode => widget.product != null;
  Product? get product => widget.product;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: product?.productName ?? '');
    imageCtrl = TextEditingController(text: product?.imageUrl ?? '');
    quantityValueCtrl = TextEditingController(
      text:
          (product?.baseQuantity ??
                  _parseQuantityValue(product?.quantity ?? ''))
              .toString(),
    );
    countryOfOriginCtrl = TextEditingController(
      text: product?.countryOfOrigin ?? '',
    );
    priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    mrpCtrl = TextEditingController(text: product?.realPrice.toString() ?? '');
    discountCtrl = TextEditingController(
      text: (product?.discountValue ?? product?.discount ?? 0).toString(),
    );

    extraVariants = (product?.variants ?? const <ProductVariant>[])
        .skip(1)
        .map(VariantDraft.fromVariant)
        .toList();

    discountType = product?.discountType ?? 'percentage';
    baseUnit = product?.baseUnit ?? _parseQuantityUnit(product?.quantity ?? '');
    isAvailable = product?.isAvailable ?? true;

    selectedCategory = product?.category;
    if (product?.subcategory != null) {
      selectedSubcategories.addAll(product!.subcategory);
    }

    if (isEditMode && discountType == 'bogo') {
      _fetchBogoOffer();
    }
  }

  Future<void> _fetchBogoOffer() async {
    if (product?.productId == null) return;
    try {
      final offer = await ServerpodAdminClient().client.bogo.getOfferForProduct(
        product!.productId!,
      );
      if (offer != null) {
        bogoFreeProductIds.addAll(offer.freeProductIds);
        for (final freeProduct in offer.freeProducts ?? const []) {
          if (freeProduct.productId.trim().isEmpty) continue;
          bogoFreeProductQuantities[freeProduct.productId] =
              freeProduct.quantity?.trim() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching BOGO offer: $e');
    }

    if (bogoFreeProductIds.isNotEmpty) {
      final resolvedProducts = await _resolveSelectedBogoProducts(
        selectedIds: bogoFreeProductIds,
        preferredCategory: product?.category,
      );
      selectedBogoProducts.addAll(resolvedProducts);
      for (final entry in selectedBogoProducts.entries) {
        bogoFreeProductQuantities[entry.key] = _normalizeBogoFreeQuantity(
          bogoFreeProductQuantities[entry.key],
          fallback: entry.value.quantity,
        );
      }
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    imageCtrl.dispose();
    quantityValueCtrl.dispose();
    countryOfOriginCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
    discountCtrl.dispose();
    for (final variant in extraVariants) {
      variant.dispose();
    }
    super.dispose();
  }

  String? _numberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v) == null) return 'Invalid number';
    return null;
  }

  String? _validateVariantDrafts() {
    for (final draft in extraVariants) {
      if (_numberValidator(draft.priceCtrl.text) != null ||
          _numberValidator(draft.mrpCtrl.text) != null) {
        return 'Each variant price and MRP must be valid numbers';
      }
    }
    return null;
  }

  Future<String?> _pickAndUploadProductImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (picked == null) return null;

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
      builder: (context) => SafeArea(
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
      ),
    );
  }

  Future<Map<String, Product>> _resolveSelectedBogoProducts({
    required Set<String> selectedIds,
    String? preferredCategory,
  }) async {
    final resolved = <String, Product>{};
    for (final p in AdminProductController.instance.products) {
      final id = p.productId;
      if (id != null && selectedIds.contains(id)) {
        resolved[id] = p;
      }
    }

    if ((preferredCategory == null || preferredCategory.trim().isEmpty) ||
        resolved.length == selectedIds.length) {
      return resolved;
    }

    final categoryProducts = await _fetchAllProductsForCategory(
      preferredCategory.trim(),
    );
    for (final p in categoryProducts) {
      final id = p.productId;
      if (id != null && selectedIds.contains(id)) {
        resolved[id] = p;
      }
    }

    return resolved;
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

  void _syncBogoSelectionState({
    required List<BogoProductSelection> selections,
    required Set<String> selectedIds,
    required Map<String, Product> resolvedProducts,
    required Map<String, String> freeProductQuantities,
  }) {
    final nextProducts = <String, Product>{};
    for (final selection in selections) {
      final p = selection.product;
      final productId = p.productId;
      if (productId == null || productId.trim().isEmpty) continue;
      nextProducts[productId] = p;
      freeProductQuantities[productId] = _normalizeBogoFreeQuantity(
        selection.freeQuantity,
        fallback: p.quantity,
      );
    }

    resolvedProducts
      ..clear()
      ..addAll(nextProducts);
    selectedIds
      ..clear()
      ..addAll(nextProducts.keys);
    freeProductQuantities.removeWhere(
      (productId, _) => !nextProducts.containsKey(productId),
    );
  }

  String _normalizeBogoFreeQuantity(String? value, {required String fallback}) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) return normalized;
    final normalizedFallback = fallback.trim();
    return normalizedFallback.isEmpty ? '1 item' : normalizedFallback;
  }

  Widget _buildDiscountPreview({
    required double price,
    required double mrp,
    required String? discountType,
  }) {
    if (price <= 0 || mrp <= 0 || price >= mrp) {
      return const SizedBox.shrink();
    }

    final discount = mrp - price;
    final discountPercent = (discount / mrp * 100);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, size: 14, color: Colors.green.shade700),
          const SizedBox(width: 6),
          Text(
            discountType == 'flat'
                ? '₹${discount.toStringAsFixed(0)} off'
                : '${discountPercent.toStringAsFixed(0)}% off (₹${discount.toStringAsFixed(0)})',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _parseQuantityValue(String text) {
    final match = RegExp(r'^([0-9]+(\.[0-9]+)?)').firstMatch(text.trim());
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 1;
    }
    return 1;
  }

  String _parseQuantityUnit(String text) {
    final lower = text.toLowerCase().trim();
    if (lower.contains('kg')) return 'kg';
    if (lower.contains('litre') || lower.contains('l ')) return 'litre';
    if (lower.contains('ml')) return 'ml';
    if (lower.contains('pc') ||
        lower.contains('piece') ||
        lower.contains('pcs')) {
      return 'pc';
    }
    if (lower.contains('pack')) return 'pack';
    return 'gm';
  }

  List<ProductVariant> _buildVariants() {
    final variants = <ProductVariant>[
      ProductVariant(
        variantId: 'default',
        quantityValue: _parseQuantityValue(
          '${quantityValueCtrl.text.trim()} $baseUnit',
        ),
        quantityUnit: baseUnit,
        price: double.parse(priceCtrl.text.trim()),
        realPrice: double.parse(mrpCtrl.text.trim()),
        isAvailable: isAvailable,
        sortOrder: 0,
      ),
      ...extraVariants.asMap().entries.map(
        (entry) => ProductVariant(
          variantId: entry.value.variantId.trim().isEmpty
              ? 'variant_${entry.key + 1}'
              : entry.value.variantId.trim(),
          quantityValue: double.parse(
            entry.value.quantityValueCtrl.text.trim(),
          ),
          quantityUnit: entry.value.quantityUnit,
          price: double.parse(entry.value.priceCtrl.text.trim()),
          realPrice: double.parse(entry.value.mrpCtrl.text.trim()),
          isAvailable: entry.value.isAvailable,
          sortOrder: entry.key + 1,
        ),
      ),
    ];
    return variants;
  }

  void _recalculateMrpFromQuantity({
    required TextEditingController quantityCtrl,
    required String newUnit,
    required TextEditingController mrpCtrlRef,
    required double originalMrp,
    required double originalQuantity,
    required String originalUnit,
  }) {
    const unitConversions = {
      'gm': 1.0,
      'kg': 1000.0,
      'litre': 1000.0,
      'ml': 1.0,
      'pc': 1.0,
      'pack': 1.0,
    };

    final newQty = double.tryParse(quantityCtrl.text.trim()) ?? 0;
    if (newQty <= 0 || originalMrp <= 0) return;

    final originalInBase =
        originalQuantity * (unitConversions[originalUnit] ?? 1.0);
    final newInBase = newQty * (unitConversions[newUnit] ?? 1.0);

    if (originalInBase <= 0) return;

    final ratio = newInBase / originalInBase;
    final newMrpValue = originalMrp * ratio;
    mrpCtrlRef.text = newMrpValue.toStringAsFixed(0);
  }

  Product _buildProduct() {
    final variants = _buildVariants();

    final baseQuantity = double.parse(quantityValueCtrl.text.trim());
    final price = double.parse(priceCtrl.text.trim());
    final mrp = double.parse(mrpCtrl.text.trim());
    final discount = double.parse(discountCtrl.text.trim());

    if (isEditMode) {
      return product!.copyWith(
        productName: nameCtrl.text.trim(),
        category: selectedCategory!.trim(),
        imageUrl: imageCtrl.text.trim(),
        price: price,
        realPrice: mrp,
        discount: discountType == 'percentage' ? discount : 0,
        discountType: discountType,
        discountValue: discount,
        isAvailable: isAvailable,
        subcategory: selectedSubcategories.toList(),
        quantity: '${quantityValueCtrl.text.trim()} $baseUnit',
        baseUnit: baseUnit,
        baseQuantity: baseQuantity,
        countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
            ? null
            : countryOfOriginCtrl.text.trim(),
        bogoFreeProductIds: bogoFreeProductIds.toList(),
        variants: variants,
      );
    } else {
      return Product(
        productName: nameCtrl.text.trim(),
        category: selectedCategory!.trim(),
        imageUrl: imageCtrl.text.trim(),
        price: price,
        realPrice: mrp,
        discount: discountType == 'percentage' ? discount : 0,
        discountType: discountType,
        discountValue: discount,
        isAvailable: isAvailable,
        subcategory: selectedSubcategories.toList(),
        quantity: '${quantityValueCtrl.text.trim()} $baseUnit',
        baseUnit: baseUnit,
        baseQuantity: baseQuantity,
        countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
            ? null
            : countryOfOriginCtrl.text.trim(),
        bogoFreeProductIds: bogoFreeProductIds.toList(),
        variants: variants,
        addedAt: DateTime.now(),
        mostSearch: 0,
        mostPurchases: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  isEditMode ? 'Edit Product' : 'Add Product',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
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
                    _buildBasicInfoSection(),
                    const SizedBox(height: 12),
                    _buildImageSection(),
                    const SizedBox(height: 12),
                    _buildQuantitySection(),
                    const SizedBox(height: 12),
                    _buildPricingSection(),
                    const SizedBox(height: 12),
                    _buildVariantsSection(),
                    const SizedBox(height: 12),
                    AvailabilitySwitch(
                      value: isAvailable,
                      onChanged: (value) => setState(() => isAvailable = value),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return SectionCard(
      icon: Icons.info_outline,
      title: 'Basic Info',
      child: Column(
        children: [
          ModernTextField(
            controller: nameCtrl,
            labelText: 'Product name',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          ModernDropdown<String>(
            value: selectedCategory,
            labelText: 'Category',
            items: widget.categories
                .map(
                  (c) => DropdownMenuItem(
                    value: c.categoryName,
                    child: Text(c.categoryName),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
                selectedSubcategories.clear();
                subcategoryError = null;
              });
            },
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: 12),
            SubcategorySelector(
              options: widget.groupedSubcategoryOptionsFor(selectedCategory!),
              selected: selectedSubcategories,
              errorText: subcategoryError,
              onToggleBunch: (bunch, checked) {
                setState(() {
                  if (checked) {
                    selectedSubcategories.addAll(bunch);
                  } else {
                    selectedSubcategories.removeAll(bunch);
                  }
                  subcategoryError = null;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return SectionCard(
      icon: Icons.image_outlined,
      title: 'Product Image',
      child: Column(
        children: [
          if (imageCtrl.text.trim().isNotEmpty) ...[
            Stack(
              alignment: Alignment.topRight,
              children: [
                ImagePreview(imageUrl: imageCtrl.text.trim()),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => setState(() => imageCtrl.clear()),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          ModernTextField(
            controller: imageCtrl,
            labelText: 'Image URL',
            hintText: 'Paste image link here',
            onChanged: (_) => setState(() {}),
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
              setState(() => isUploadingImage = true);
              try {
                final source = await _pickImageSource();
                if (source == null) return;
                final url = await _pickAndUploadProductImage(source);
                if (url != null && mounted) {
                  setState(() => imageCtrl.text = url);
                }
              } catch (e) {
                setState(() => imageError = e.toString());
              } finally {
                if (mounted) setState(() => isUploadingImage = false);
              }
            },
          ),
          if (imageError != null) ...[
            const SizedBox(height: 8),
            ErrorMessage(message: imageError!),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    return SectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'Quantity',
      child: Column(
        children: [
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: quantityValueCtrl,
                labelText: 'Quantity',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                onChanged: (_) {
                  _recalculateMrpFromQuantity(
                    quantityCtrl: quantityValueCtrl,
                    newUnit: baseUnit,
                    mrpCtrlRef: mrpCtrl,
                    originalMrp: product?.realPrice ?? 0,
                    originalQuantity:
                        product?.baseQuantity ??
                        _parseQuantityValue(product?.quantity ?? ''),
                    originalUnit:
                        product?.baseUnit ??
                        _parseQuantityUnit(product?.quantity ?? ''),
                  );
                  setState(() {});
                },
              ),
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<String>(
                  initialValue: baseUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'gm', child: Text('gm')),
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'litre', child: Text('litre')),
                    DropdownMenuItem(value: 'ml', child: Text('ml')),
                    DropdownMenuItem(value: 'pc', child: Text('pc')),
                    DropdownMenuItem(value: 'pack', child: Text('pack')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        baseUnit = value;
                        _recalculateMrpFromQuantity(
                          quantityCtrl: quantityValueCtrl,
                          newUnit: baseUnit,
                          mrpCtrlRef: mrpCtrl,
                          originalMrp: product?.realPrice ?? 0,
                          originalQuantity:
                              product?.baseQuantity ??
                              _parseQuantityValue(product?.quantity ?? ''),
                          originalUnit:
                              product?.baseUnit ??
                              _parseQuantityUnit(product?.quantity ?? ''),
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ModernTextField(
            controller: countryOfOriginCtrl,
            labelText: 'Country of Origin (Optional)',
            hintText: 'e.g., India',
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return SectionCard(
      icon: Icons.local_offer_outlined,
      title: 'Pricing',
      child: Column(
        children: [
          ModernTextField(
            controller: priceCtrl,
            labelText: 'Selling Price',
            prefixText: '₹ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _numberValidator,
          ),
          const SizedBox(height: 12),
          ModernTextField(
            controller: mrpCtrl,
            labelText: 'MRP',
            prefixText: '₹ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) {
              final mrp = double.tryParse(v) ?? 0;
              final p = double.tryParse(priceCtrl.text) ?? 0;
              if (mrp > 0 && p > 0 && mrp > p) {
                final discount = mrp - p;
                if (discountType == 'flat') {
                  discountCtrl.text = discount.toStringAsFixed(0);
                } else if (discountType == 'percentage') {
                  final percent = (discount / mrp * 100);
                  discountCtrl.text = percent.toStringAsFixed(0);
                }
              }
              setState(() {});
            },
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
                  DropdownMenuItem(value: 'flat', child: Text('Flat (₹)')),
                  DropdownMenuItem(value: 'bogo', child: Text('🎁 BOGO')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      discountType = value;
                      if (discountType == 'bogo') {
                        discountCtrl.text = '0';
                        mrpCtrl.text = priceCtrl.text;
                      }
                    });
                  }
                },
              ),
              if (discountType != 'bogo')
                ModernTextField(
                  controller: discountCtrl,
                  labelText: 'Discount',
                  prefixText: discountType == 'flat' ? '₹ ' : null,
                  suffixText: discountType == 'percentage' ? '%' : null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (v) {
                    final d = double.tryParse(v) ?? 0;
                    final p = double.tryParse(priceCtrl.text) ?? 0;
                    if (discountType == 'percentage' && d < 100) {
                      mrpCtrl.text = (p / (1 - (d / 100))).toStringAsFixed(0);
                    } else {
                      mrpCtrl.text = (p + d).toStringAsFixed(0);
                    }
                    setState(() {});
                  },
                  validator: _numberValidator,
                ),
            ],
          ),
          Builder(
            builder: (context) {
              final price = double.tryParse(priceCtrl.text) ?? 0;
              final mrp = double.tryParse(mrpCtrl.text) ?? 0;
              return _buildDiscountPreview(
                price: price,
                mrp: mrp,
                discountType: discountType,
              );
            },
          ),
          if (discountType == 'bogo') ...[
            const SizedBox(height: 12),
            BogoSelectorWidget(
              selectedProducts: selectedBogoProducts.values.toList(),
              unresolvedIds: bogoFreeProductIds.difference(
                selectedBogoProducts.keys.toSet(),
              ),
              canBrowse:
                  selectedCategory != null &&
                  selectedCategory!.trim().isNotEmpty,
              onBrowsePressed: () async {
                if (selectedCategory == null ||
                    selectedCategory!.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select product category first'),
                    ),
                  );
                  return;
                }

                final result = await Navigator.of(context)
                    .push<List<BogoProductSelection>>(
                      MaterialPageRoute(
                        builder: (_) => BogoProductPickerScreen(
                          initialCategory: selectedCategory!,
                          initiallySelectedProducts: selectedBogoProducts.values
                              .map(
                                (p) => BogoProductSelection(
                                  product: p,
                                  freeQuantity:
                                      bogoFreeProductQuantities[p.productId!] ??
                                      p.quantity,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );

                if (result == null) return;
                setState(() {
                  _syncBogoSelectionState(
                    selections: result,
                    selectedIds: bogoFreeProductIds,
                    resolvedProducts: selectedBogoProducts,
                    freeProductQuantities: bogoFreeProductQuantities,
                  );
                });
              },
              onRemove: (productId) {
                setState(() {
                  bogoFreeProductIds.remove(productId);
                  selectedBogoProducts.remove(productId);
                  bogoFreeProductQuantities.remove(productId);
                });
              },
              freeProductQuantities: bogoFreeProductQuantities,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantsSection() {
    return SectionCard(
      icon: Icons.view_list_outlined,
      title: 'Additional Variants',
      child: VariantListEditor(
        variants: extraVariants,
        onAddVariant: () {
          setState(() {
            extraVariants.add(
              VariantDraft(
                baseRealPrice: product?.realPrice ?? 0,
                baseQuantity:
                    product?.baseQuantity ??
                    _parseQuantityValue(product?.quantity ?? ''),
                baseUnit:
                    product?.baseUnit ??
                    _parseQuantityUnit(product?.quantity ?? ''),
              ),
            );
          });
        },
        onRemoveVariant: (draft) {
          setState(() {
            extraVariants.remove(draft);
          });
          draft.dispose();
        },
        onChanged: () => setState(() {}),
        baseRealPrice: product?.realPrice ?? 0,
        baseQuantity:
            product?.baseQuantity ??
            _parseQuantityValue(product?.quantity ?? ''),
        baseUnit:
            product?.baseUnit ?? _parseQuantityUnit(product?.quantity ?? ''),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
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
            onPressed: _handleSave,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditMode ? 'Update Product' : 'Save Product'),
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    if (!formKey.currentState!.validate()) return;

    if (selectedSubcategories.isEmpty) {
      setState(
        () => subcategoryError = 'Please select at least one subcategory',
      );
      return;
    }

    if (discountType == 'bogo' && bogoFreeProductIds.isEmpty) {
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

    final variantError = _validateVariantDrafts();
    if (variantError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(variantError)));
      return;
    }

    if (selectedCategory != null) {
      final product = _buildProduct();
      final bogoSelections = bogoFreeProductIds.map((productId) {
        final p = selectedBogoProducts[productId]!;
        return BogoProductSelection(
          product: p,
          freeQuantity: bogoFreeProductQuantities[productId] ?? p.quantity,
        );
      }).toList();

      Navigator.pop(
        context,
        ProductFormResult(
          product: product,
          bogoSelections:
              discountType == 'bogo' && bogoFreeProductIds.isNotEmpty
              ? bogoSelections
              : null,
          extraVariants: extraVariants,
        ),
      );
    }
  }
}
