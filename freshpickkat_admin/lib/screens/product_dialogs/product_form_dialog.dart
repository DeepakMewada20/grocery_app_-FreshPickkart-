import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/widgets.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:freshpickkat_admin/controller/admin_category_controller.dart'
    show SubcategoryOptionData;

import 'variant_draft.dart';
import 'variant_editor.dart';
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
  final Future<void> Function(ProductFormResult result) onSubmit;
  final List<SubcategoryOptionData> Function(String category)
  groupedSubcategoryOptionsFor;

  const ProductFormDialog({
    super.key,
    this.product,
    required this.categories,
    required this.onSubmit,
    required this.groupedSubcategoryOptionsFor,
  });

  static Future<bool?> show({
    required BuildContext context,
    Product? product,
    required List<Category> categories,
    required Future<void> Function(ProductFormResult result) onSubmit,
    required List<SubcategoryOptionData> Function(String category)
    groupedSubcategoryOptionsFor,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProductFormDialog(
          product: product,
          categories: categories,
          onSubmit: onSubmit,
          groupedSubcategoryOptionsFor: groupedSubcategoryOptionsFor,
        ),
      ),
    );
  }

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl;
  late final TextEditingController shortDescriptionCtrl;
  late final TextEditingController descriptionCtrl;
  late final TextEditingController imageCtrl;
  late final TextEditingController quantityValueCtrl;
  late final TextEditingController quantityDescriptionCtrl;
  late final TextEditingController countryOfOriginCtrl;
  late final TextEditingController stockCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController mrpCtrl;

  late List<VariantDraft> extraVariants;
  // Preserves the original variantId of the first variant so that when the
  // product is saved, the server generates the same SKU as stored in the DB.
  // Hardcoding 'default' here causes a SKU mismatch for products whose first
  // variant was originally saved with a different variantId, which triggers a
  // spurious DELETE attempt and a PostgreSQL 25P02 transaction-abort error.
  String _originalFirstVariantId = 'default';
  late String discountType;
  late String baseUnit;
  late String stockUnit;
  final bogoFreeProductIds = <String>{};
  final selectedBogoProducts = <String, Product>{};
  final bogoFreeProductQuantities = <String, String>{};
  late bool isAvailable;
  bool isUploadingImage = false;
  bool _isSubmitting = false;
  String? imageError;
  bool _didRequestOfferData = false;
  final List<String> _uploadedUrlsInSession = [];
  bool _isSaved = false;

  String? selectedCategory;
  final selectedSubcategories = <String>{};
  String? subcategoryError;
  String? categoryError;

  List<BogoOffer> _bogoOffers = [];
  List<ComboOffer> _comboOffers = [];
  List<CategoryOffer> _categoryOffers = [];
  bool _isOfferDataLoading = false;

  bool get isEditMode => widget.product != null;
  Product? get product => widget.product;
  double get _currentBaseQuantity =>
      double.tryParse(quantityValueCtrl.text.trim()) ?? 0;
  double get _currentBaseMrp => double.tryParse(mrpCtrl.text.trim()) ?? 0;
  double get _currentBasePrice => double.tryParse(priceCtrl.text.trim()) ?? 0;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: product?.productName ?? '');
    shortDescriptionCtrl = TextEditingController(
      text: product?.shortDescription ?? '',
    );
    descriptionCtrl = TextEditingController(text: product?.description ?? '');
    imageCtrl = TextEditingController(text: product?.imageUrl ?? '');
    quantityValueCtrl = TextEditingController(
      text:
          (product?.baseQuantity ??
                  _parseQuantityValue(product?.quantity ?? ''))
              .toString(),
    );
    quantityDescriptionCtrl = TextEditingController(
      text: product?.quantityDescription ?? '',
    );
    countryOfOriginCtrl = TextEditingController(
      text: product?.countryOfOrigin ?? 'India',
    );
    stockCtrl = TextEditingController(
      text: product?.stock != null
          ? (product!.stock == product!.stock!.toInt()
                ? product!.stock!.toInt().toString()
                : product!.stock!.toString())
          : '',
    );
    priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    mrpCtrl = TextEditingController(text: product?.realPrice.toString() ?? '');
    extraVariants = (product?.variants ?? const <ProductVariant>[])
        .skip(1)
        .map(VariantDraft.fromVariant)
        .toList();

    // Preserve the original variantId from the DB so the server produces the
    // same SKU on update. Falls back to 'default' for new products.
    final firstVariantId = product?.variants?.firstOrNull?.variantId.trim();
    _originalFirstVariantId =
        (firstVariantId != null && firstVariantId.isNotEmpty)
            ? firstVariantId
            : 'default';

    discountType = product?.discountType == 'flat' ? 'flat' : 'percentage';
    baseUnit = product?.baseUnit ?? _parseQuantityUnit(product?.quantity ?? '');
    stockUnit = product?.stockUnit ?? baseUnit;
    isAvailable = product?.isAvailable ?? true;

    selectedCategory = product?.category;
    if (product != null) {
      selectedSubcategories.addAll(product!.subcategory);
    }

    if (isEditMode && product?.discountType == 'bogo') {
      _fetchBogoOffer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureOfferDataLoaded();
    });

    quantityValueCtrl.addListener(_syncVariantBasePricing);
    mrpCtrl.addListener(_syncVariantBasePricing);
    priceCtrl.addListener(_syncVariantBasePricing);
    _syncVariantBasePricing();
  }

  Future<void> _fetchBogoOffer() async {
    if (product?.productId == null) return;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final offer = await ServerpodAdminClient().client.bogo.getOfferForProduct(
        product!.productId!,
        uid,
        idToken,
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
    quantityValueCtrl.removeListener(_syncVariantBasePricing);
    mrpCtrl.removeListener(_syncVariantBasePricing);
    nameCtrl.dispose();
    shortDescriptionCtrl.dispose();
    descriptionCtrl.dispose();
    imageCtrl.dispose();
    quantityValueCtrl.dispose();
    quantityDescriptionCtrl.dispose();
    countryOfOriginCtrl.dispose();
    stockCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
    for (final variant in extraVariants) {
      variant.dispose();
    }
    if (!_isSaved) {
      _cleanupImages(keepCurrent: false);
    }
    super.dispose();
  }

  Future<void> _cleanupImages({required bool keepCurrent}) async {
    final currentImageUrl = imageCtrl.text.trim();
    for (final url in _uploadedUrlsInSession) {
      if (keepCurrent && url == currentImageUrl) continue;
      await AdminImageUploadService.deleteImage(url);
    }
    _uploadedUrlsInSession.clear();
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
          toolbarColor: AdminThemeTokens.primary,
          toolbarWidgetColor: AdminThemeTokens.white,
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
    final url = await ref.getDownloadURL();
    _uploadedUrlsInSession.add(url);
    return url;
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
              leading: Icon(Icons.photo_library_outlined),
              title: Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.photo_camera_outlined),
              title: Text('Use Camera'),
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

  Future<void> _ensureOfferDataLoaded() async {
    if (!isEditMode) return;
    if (_didRequestOfferData) return;
    _didRequestOfferData = true;

    _isOfferDataLoading = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final data = await ServerpodAdminClient()
          .client
          .productForm
          .getProductFormReferenceData(uid, idToken);
      _bogoOffers = data.bogoOffers;
      _comboOffers = data.comboOffers;
      _categoryOffers = data.categoryOffers;
    } catch (_) {
    } finally {
      _isOfferDataLoading = false;
      if (mounted) setState(() {});
    }
  }

  Future<List<Product>> _fetchAllProductsForCategory(String category) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
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

  // Preserved for the upcoming dedicated BOGO editing flow.
  // ignore: unused_element
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
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AdminAppTheme.getSuccessContainerColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminAppTheme.getSuccessColor(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer,
            size: 14.sp.clamp(12.0, 16.0),
            color: AdminAppTheme.getSuccessColor(context),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              discountType == 'flat'
                  ? '₹${discount.toStringAsFixed(0)} off'
                  : '${discountPercent.toStringAsFixed(0)}% off (₹${discount.toStringAsFixed(0)})',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AdminAppTheme.getSuccessColor(context),
                fontSize: 12.sp.clamp(10.0, 13.0),
                fontWeight: FontWeight.w600,
              ),
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

  String _buildQuantityLabel() {
    return '${quantityValueCtrl.text.trim()} $baseUnit';
  }

  List<ProductVariant> _buildVariants() {
    final variants = <ProductVariant>[
      ProductVariant(
        // Use the original variantId so the server computes the same SKU as
        // stored in the DB. Avoids a spurious DELETE that breaks the transaction.
        variantId: _originalFirstVariantId,
        quantityValue: _parseQuantityValue(
          '${quantityValueCtrl.text.trim()} $baseUnit',
        ),
        quantityUnit: baseUnit,
        quantityDescription: quantityDescriptionCtrl.text.trim().isEmpty
            ? null
            : quantityDescriptionCtrl.text.trim(),
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
          quantityDescription:
              entry.value.quantityDescriptionCtrl.text.trim().isEmpty
              ? null
              : entry.value.quantityDescriptionCtrl.text.trim(),
          price: double.parse(entry.value.priceCtrl.text.trim()),
          realPrice: double.parse(entry.value.mrpCtrl.text.trim()),
          isAvailable: entry.value.isAvailable,
          sortOrder: entry.key + 1,
        ),
      ),
    ];
    return variants;
  }

  void _syncVariantBasePricing() {
    final baseQuantity = _currentBaseQuantity;
    final baseMrp = _currentBaseMrp;
    final basePrice = _currentBasePrice;

    for (final draft in extraVariants) {
      draft.baseQuantity = baseQuantity;
      draft.baseUnit = baseUnit;
      draft.baseRealPrice = baseMrp;
      draft.basePrice = basePrice;
      _recalculatePricesForDraft(draft);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _recalculatePricesForDraft(VariantDraft draft) {
    _recalculatePricesFromQuantity(
      quantityCtrl: draft.quantityValueCtrl,
      newUnit: draft.quantityUnit,
      priceCtrlRef: draft.priceCtrl,
      mrpCtrlRef: draft.mrpCtrl,
      originalMrp: draft.baseRealPrice,
      originalPrice: draft.basePrice,
      originalQuantity: draft.baseQuantity,
      originalUnit: draft.baseUnit,
    );
  }

  void _recalculatePricesFromQuantity({
    required TextEditingController quantityCtrl,
    required String newUnit,
    required TextEditingController priceCtrlRef,
    required TextEditingController mrpCtrlRef,
    required double originalMrp,
    required double originalPrice,
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
    if (newQty <= 0 || (originalMrp <= 0 && originalPrice <= 0)) return;

    final originalInBase =
        originalQuantity * (unitConversions[originalUnit] ?? 1.0);
    final newInBase = newQty * (unitConversions[newUnit] ?? 1.0);

    if (originalInBase <= 0) return;

    final ratio = newInBase / originalInBase;

    if (originalMrp > 0) {
      final newMrpValue = originalMrp * ratio;
      mrpCtrlRef.text = newMrpValue.toStringAsFixed(2);
    }

    if (originalPrice > 0) {
      final newPriceValue = originalPrice * ratio;
      priceCtrlRef.text = newPriceValue.toStringAsFixed(2);
    }
  }

  Product _buildProduct() {
    final variants = _buildVariants();

    final baseQuantity = double.parse(quantityValueCtrl.text.trim());
    final price = double.parse(priceCtrl.text.trim());
    final mrp = double.parse(mrpCtrl.text.trim());
    final discount = _calculatedDiscountValue(price: price, mrp: mrp);

    if (isEditMode) {
      return product!.copyWith(
        productName: nameCtrl.text.trim(),
        shortDescription: shortDescriptionCtrl.text.trim().isEmpty
            ? null
            : shortDescriptionCtrl.text.trim(),
        description: descriptionCtrl.text.trim().isEmpty
            ? null
            : descriptionCtrl.text.trim(),
        category: selectedCategory!.trim(),
        imageUrl: imageCtrl.text.trim(),
        price: price,
        realPrice: mrp,
        discount: discountType == 'percentage' ? discount : 0,
        discountType: discountType,
        discountValue: discount,
        isAvailable: isAvailable,
        subcategory: selectedSubcategories.toList(),
        quantity: _buildQuantityLabel(),
        baseUnit: baseUnit,
        baseQuantity: baseQuantity,
        quantityDescription: quantityDescriptionCtrl.text.trim().isEmpty
            ? null
            : quantityDescriptionCtrl.text.trim(),
        countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
            ? null
            : countryOfOriginCtrl.text.trim(),
        stock: stockCtrl.text.trim().isEmpty
            ? null
            : double.tryParse(stockCtrl.text.trim()),
        stockUnit: stockCtrl.text.trim().isEmpty ? null : stockUnit,
        bogoFreeProductIds:
            product?.bogoFreeProductIds?.toList() ??
            bogoFreeProductIds.toList(),
        variants: variants,
      );
    } else {
      return Product(
        productName: nameCtrl.text.trim(),
        shortDescription: shortDescriptionCtrl.text.trim().isEmpty
            ? null
            : shortDescriptionCtrl.text.trim(),
        description: descriptionCtrl.text.trim().isEmpty
            ? null
            : descriptionCtrl.text.trim(),
        category: selectedCategory!.trim(),
        imageUrl: imageCtrl.text.trim(),
        price: price,
        realPrice: mrp,
        discount: discountType == 'percentage' ? discount : 0,
        discountType: discountType,
        discountValue: discount,
        isAvailable: isAvailable,
        subcategory: selectedSubcategories.toList(),
        quantity: _buildQuantityLabel(),
        baseUnit: baseUnit,
        baseQuantity: baseQuantity,
        quantityDescription: quantityDescriptionCtrl.text.trim().isEmpty
            ? null
            : quantityDescriptionCtrl.text.trim(),
        countryOfOrigin: countryOfOriginCtrl.text.trim().isEmpty
            ? null
            : countryOfOriginCtrl.text.trim(),
        stock: stockCtrl.text.trim().isEmpty
            ? null
            : double.tryParse(stockCtrl.text.trim()),
        stockUnit: stockCtrl.text.trim().isEmpty ? null : stockUnit,
        bogoFreeProductIds: selectedBogoProducts.keys.toList(),
        variants: variants,
        addedAt: DateTime.now(),
        mostSearch: 0,
        mostPurchases: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Product' : 'Add Product')),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        AdminResponsive.pageHorizontalPadding(context),
                        16.h,
                        AdminResponsive.pageHorizontalPadding(context),
                        MediaQuery.viewInsetsOf(context).bottom + 20.h,
                      ),
                      child: AdminResponsive.constrainContent(
                        context: context,
                        maxWidth: AdminResponsive.maxFormWidth,
                        child: Column(
                          children: [
                            _buildBasicInfoSection(),
                            SizedBox(height: 12.h),
                            _buildImageSection(),
                            SizedBox(height: 12.h),
                            _buildQuantitySection(),
                            SizedBox(height: 12.h),
                            _buildPricingSection(),
                            SizedBox(height: 12.h),
                            _buildVariantsSection(),
                            SizedBox(height: 12.h),
                            _buildOffersSection(),
                            SizedBox(height: 12.h),
                            AvailabilitySwitch(
                              value: isAvailable,
                              onChanged: (value) =>
                                  setState(() => isAvailable = value),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 8,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AdminResponsive.pageHorizontalPadding(context),
                          10.h,
                          AdminResponsive.pageHorizontalPadding(context),
                          12.h,
                        ),
                        child: AdminResponsive.constrainContent(
                          context: context,
                          maxWidth: AdminResponsive.maxFormWidth,
                          child: _buildActionButtons(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
          ModernTextField(
            controller: shortDescriptionCtrl,
            labelText: 'Short Description (Optional)',
            hintText: 'e.g., Fresh organic apples from Kashmir',
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          ModernTextField(
            controller: descriptionCtrl,
            labelText: 'Full Description (Optional)',
            hintText: 'Detailed information about the product...',
            maxLines: 4,
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
                categoryError = null;
              });
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: 12),
            SubcategorySelector(
              options: widget.groupedSubcategoryOptionsFor(selectedCategory!),
              selected: selectedSubcategories,
              errorText: subcategoryError,
              onToggle: (names, checked) {
                setState(() {
                  if (checked) {
                    selectedSubcategories.addAll(names);
                  } else {
                    for (final name in names) {
                      selectedSubcategories.remove(name);
                    }
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
                SizedBox(
                  width: 120.r.clamp(96.0, 132.0),
                  height: 120.r.clamp(96.0, 132.0),
                  child: ImagePreview(imageUrl: imageCtrl.text.trim()),
                ),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: AdminAppTheme.getErrorColor(context),
                  ),
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
          Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AdminAppTheme.getNeutralColor(context),
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
                  setState(() {
                    imageCtrl.text = url;
                    imageError = null;
                  });
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
                  _recalculatePricesFromQuantity(
                    quantityCtrl: quantityValueCtrl,
                    newUnit: baseUnit,
                    priceCtrlRef: priceCtrl,
                    mrpCtrlRef: mrpCtrl,
                    originalMrp: product?.realPrice ?? 0,
                    originalPrice: product?.price ?? 0,
                    originalQuantity:
                        product?.baseQuantity ??
                        _parseQuantityValue(product?.quantity ?? ''),
                    originalUnit:
                        product?.baseUnit ??
                        _parseQuantityUnit(product?.quantity ?? ''),
                  );
                  _syncVariantBasePricing();
                  setState(() {});
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: baseUnit,
                isExpanded: true,
                decoration: InputDecoration(
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
                      _recalculatePricesFromQuantity(
                        quantityCtrl: quantityValueCtrl,
                        newUnit: baseUnit,
                        priceCtrlRef: priceCtrl,
                        mrpCtrlRef: mrpCtrl,
                        originalMrp: product?.realPrice ?? 0,
                        originalPrice: product?.price ?? 0,
                        originalQuantity:
                            product?.baseQuantity ??
                            _parseQuantityValue(product?.quantity ?? ''),
                        originalUnit:
                            product?.baseUnit ??
                            _parseQuantityUnit(product?.quantity ?? ''),
                      );
                      _syncVariantBasePricing();
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: quantityDescriptionCtrl,
                labelText: 'Quantity Description (Optional)',
                hintText: 'e.g., 10-12 pieces',
              ),
              ModernTextField(
                controller: countryOfOriginCtrl,
                labelText: 'Country of Origin (Optional)',
                hintText: 'e.g., India',
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: stockCtrl,
                labelText: 'Stock (Optional)',
                hintText: 'e.g., 50',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: stockUnit,
                isExpanded: true,
                decoration: InputDecoration(
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
                      stockUnit = value;
                    });
                  }
                },
              ),
            ],
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
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: priceCtrl,
                labelText: 'Selling Price',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _numberValidator,
                onChanged: (_) => setState(() {}),
              ),
              ModernTextField(
                controller: mrpCtrl,
                labelText: 'MRP',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) {
                  _syncVariantBasePricing();
                  setState(() {});
                },
                validator: _numberValidator,
              ),
            ],
          ),
          SizedBox(height: 12.h),
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
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      discountType = value;
                    });
                  }
                },
              ),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Discount',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _discountValueLabel(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
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
        ],
      ),
    );
  }

  double _calculatedDiscountValue({
    required double price,
    required double mrp,
  }) {
    if (price <= 0 || mrp <= 0 || mrp <= price) return 0;
    final flatDiscount = mrp - price;
    if (discountType == 'percentage') {
      return (flatDiscount / mrp) * 100;
    }
    return flatDiscount;
  }

  String _discountValueLabel() {
    final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
    final mrp = double.tryParse(mrpCtrl.text.trim()) ?? 0;
    final discount = _calculatedDiscountValue(price: price, mrp: mrp);
    if (discount <= 0) {
      return discountType == 'percentage' ? '0%' : '₹0';
    }
    if (discountType == 'percentage') {
      return '${discount.toStringAsFixed(0)}%';
    }
    return '₹${discount.toStringAsFixed(0)}';
  }

  Widget _buildOffersSection() {
    return SectionCard(
      icon: Icons.local_activity_outlined,
      title: 'Related Offers',
      child: () {
        final summaries = _relatedOfferSummaries();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminAppTheme.getNeutralContainerColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AdminAppTheme.getBorderColor(context),
                ),
              ),
              child: Text(
                summaries.isEmpty
                    ? 'No related offers found for this product yet.'
                    : 'This product is currently linked to ${summaries.length} offer${summaries.length == 1 ? '' : 's'}.',
                style: TextStyle(
                  color: AdminAppTheme.getBlueGreyColor(context),
                ),
              ),
            ),
            if (_isOfferDataLoading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(minHeight: 3),
            ],
            if (summaries.isEmpty) ...[
              const SizedBox(height: 12),
              Text(
                isEditMode
                    ? 'Direct product pricing will appear here along with category, combo, and BOGO mappings.'
                    : 'Save the product first to see direct product, combo, and BOGO mappings. Category offers update from the selected category.',
                style: TextStyle(
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              ...summaries.map(_buildOfferSummaryCard),
            ],
          ],
        );
      }(),
    );
  }

  List<_ProductOfferSummary> _relatedOfferSummaries() {
    final summaries = <_ProductOfferSummary>[];
    final now = DateTime.now();
    final productId = product?.productId;
    final categoryName = selectedCategory?.trim();

    final discountValue = _calculatedDiscountValue(
      price: double.tryParse(priceCtrl.text.trim()) ?? 0,
      mrp: double.tryParse(mrpCtrl.text.trim()) ?? 0,
    );
    if (discountValue > 0) {
      final valueLabel = discountType == 'percentage'
          ? '${discountValue.toStringAsFixed(0)}% OFF'
          : 'FLAT ₹${discountValue.toStringAsFixed(0)} OFF';
      summaries.add(
        _ProductOfferSummary(
          title: 'Direct Product Discount',
          subtitle: 'Configured on this product form',
          badge: valueLabel,
          tone: AdminAppTheme.getSuccessColor(context),
        ),
      );
    }

    if (categoryName != null && categoryName.isNotEmpty) {
      final categoryOffers = _categoryOffers.where((
        offer,
      ) {
        if (!_isOfferLive(
          offer.startDate,
          offer.endDate,
          offer.isActive,
          now,
        )) {
          return false;
        }
        final matchesCategory =
            offer.categoryName == categoryName ||
            offer.categoryId == categoryName;
        if (!matchesCategory) return false;
        if (productId != null &&
            (offer.excludeProductIds ?? const <String>[]).contains(productId)) {
          return false;
        }
        final productIds = offer.productIds ?? const <String>[];
        if (productIds.isNotEmpty && productId != null) {
          return productIds.contains(productId);
        }
        return productIds.isEmpty;
      });

      for (final offer in categoryOffers) {
        summaries.add(
          _ProductOfferSummary(
            title: offer.name,
            subtitle: 'Category offer • ${offer.categoryName ?? categoryName}',
            badge: _discountBadge(offer.discountType, offer.discountValue),
            tone: AdminAppTheme.getWarningColor(context),
          ),
        );
      }
    }

    if (productId != null) {
      final comboOffers = _comboOffers.where((offer) {
        if (!_isOfferLive(
          offer.startDate,
          offer.endDate,
          offer.isActive,
          now,
        )) {
          return false;
        }
        return offer.comboProducts.any((item) => item.productId == productId);
      });

      for (final offer in comboOffers) {
        summaries.add(
          _ProductOfferSummary(
            title: offer.name,
            subtitle:
                'Combo offer • part of ${offer.comboProducts.length} products',
            badge: _discountBadge(offer.discountType, offer.discountValue),
            tone: AdminAppTheme.getDeepPurpleColor(context),
          ),
        );
      }

      final bogoOffer = _bogoOffers
          .cast<BogoOffer?>()
          .firstWhere(
            (offer) => offer?.triggerProductId == productId,
            orElse: () => null,
          );
      if (bogoOffer != null &&
          _isOfferLive(
            bogoOffer.startDate,
            bogoOffer.endDate,
            bogoOffer.isActive,
            now,
          )) {
        final freeCount = bogoOffer.freeProductIds.length;
        summaries.add(
          _ProductOfferSummary(
            title: bogoOffer.offerTitle,
            subtitle:
                'BOGO offer • $freeCount free product option${freeCount == 1 ? '' : 's'}',
            badge: 'BOGO',
            tone: AdminAppTheme.getTealColor(context),
          ),
        );
      }
    }

    return summaries;
  }

  bool _isOfferLive(
    DateTime startDate,
    DateTime endDate,
    bool isActive,
    DateTime now,
  ) {
    return isActive && !startDate.isAfter(now) && !endDate.isBefore(now);
  }

  String _discountBadge(String discountType, double discountValue) {
    if (discountType == 'percentage') {
      return '${discountValue.toStringAsFixed(0)}% OFF';
    }
    return 'FLAT ₹${discountValue.toStringAsFixed(0)} OFF';
  }

  Widget _buildOfferSummaryCard(_ProductOfferSummary offer) {
    final tone = offer.tone;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tone.withAlpha(46)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: tone,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              offer.badge,
              style: const TextStyle(
                color: AdminThemeTokens.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.subtitle,
                  style: TextStyle(
                    color: AdminAppTheme.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
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
                baseRealPrice: _currentBaseMrp,
                basePrice: _currentBasePrice,
                baseQuantity: _currentBaseQuantity,
                baseUnit: baseUnit,
              ),
            );
            _syncVariantBasePricing();
          });
        },
        onRemoveVariant: (draft) {
          setState(() {
            extraVariants.remove(draft);
          });
          draft.dispose();
        },
        onChanged: () => setState(() {}),
        baseRealPrice: _currentBaseMrp,
        baseQuantity: _currentBaseQuantity,
        baseUnit: baseUnit,
      ),
    );
  }

  Widget _buildActionButtons() {
    final cancelButton = OutlinedButton(
      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('Cancel', overflow: TextOverflow.ellipsis),
    );
    final saveButton = FilledButton(
      onPressed: _isSubmitting ? null : _handleSave,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isSubmitting
          ? SizedBox(
              width: 20.r,
              height: 20.r,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              isEditMode ? 'Update Product' : 'Save Product',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              saveButton,
              SizedBox(height: 8.h),
              cancelButton,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: cancelButton),
            SizedBox(width: 12.w),
            Expanded(flex: 2, child: saveButton),
          ],
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSubcategories.isEmpty) {
      setState(
        () => subcategoryError = 'Please select at least one subcategory',
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
      final bogoSelections = bogoFreeProductIds
          .map((productId) {
            final p = selectedBogoProducts[productId];
            if (p == null) return null;
            return BogoProductSelection(
              product: p,
              variant: null, // Default to null for this legacy entry point
            );
          })
          .whereType<BogoProductSelection>()
          .toList();

      final result = ProductFormResult(
        product: product,
        bogoSelections: discountType == 'bogo' && bogoFreeProductIds.isNotEmpty
            ? bogoSelections
            : null,
        extraVariants: extraVariants,
      );

      setState(() => _isSubmitting = true);
      try {
        await widget.onSubmit(result);
        if (!mounted) return;
        _isSaved = true;
        await _cleanupImages(keepCurrent: true);
        if (!mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save product: $e')));
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }
}

class _ProductOfferSummary {
  final String title;
  final String subtitle;
  final String badge;
  final Color tone;

  const _ProductOfferSummary({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.tone,
  });
}
