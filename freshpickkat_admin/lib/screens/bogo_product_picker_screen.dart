import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class BogoProductSelection {
  final Product product;
  final String freeQuantity;

  const BogoProductSelection({
    required this.product,
    required this.freeQuantity,
  });
}

class BogoProductPickerScreen extends StatefulWidget {
  final String? initialCategory;
  final List<BogoProductSelection> initiallySelectedProducts;

  const BogoProductPickerScreen({
    super.key,
    required this.initiallySelectedProducts,
    this.initialCategory,
  });

  @override
  State<BogoProductPickerScreen> createState() =>
      _BogoProductPickerScreenState();
}

class BogoOfferEditorScreen extends StatefulWidget {
  final BogoOffer? offer;
  final Future<bool> Function(BogoOffer offer) onSave;

  const BogoOfferEditorScreen({super.key, this.offer, required this.onSave});

  static Future<bool?> show({
    required BuildContext context,
    BogoOffer? offer,
    required Future<bool> Function(BogoOffer offer) onSave,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            BogoOfferEditorScreen(offer: offer, onSave: onSave),
      ),
    );
  }

  @override
  State<BogoOfferEditorScreen> createState() => _BogoOfferEditorScreenState();
}

class _BogoOfferEditorScreenState extends State<BogoOfferEditorScreen> {
  final _searchCtrl = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _selectedProductsById = <String, Product>{};
  final _selectedFreeQuantitiesById = <String, String>{};
  final _productController = AdminProductController.instance;
  final _categoryController = AdminCategoryController.instance;

  List<Product> _categoryProducts = [];
  bool _isLoading = false;
  bool _isRefreshingProducts = false;
  bool _isBootstrapping = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _selectedCategory;
  Product? _selectedTriggerProduct;
  String? _selectedTriggerVariantId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusManager.instance.primaryFocus?.unfocus();
    });
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      if (_categoryController.categories.isEmpty) {
        await _categoryController.loadCategories();
      }
      if (_productController.products.isEmpty) {
        await _productController.loadInitial();
      }

      final offer = widget.offer;
      if (offer != null) {
        _startDate = offer.startDate;
        _endDate = offer.endDate;
        _selectedTriggerVariantId = offer.triggerVariantId;

        _selectedTriggerProduct = _productController.products.firstWhere(
          (p) => p.productId == offer.triggerProductId,
          orElse: () => Product(
            productId: offer.triggerProductId,
            productName: 'Unknown Product',
            category: '',
            imageUrl: '',
            price: 0,
            realPrice: 0,
            discount: 0,
            isAvailable: true,
            addedAt: offer.createdAt,
            subcategory: const [],
            quantity: '',
            mostSearch: 0,
            mostPurchases: 0,
          ),
        );

        final freeProducts = offer.freeProducts ?? const <BogoFreeProduct>[];
        for (final freeProductId in offer.freeProductIds) {
          final product = _productController.products.firstWhere(
            (p) => p.productId == freeProductId,
            orElse: () => Product(
              productId: freeProductId,
              productName: 'Unknown Product',
              category: '',
              imageUrl: '',
              price: 0,
              realPrice: 0,
              discount: 0,
              isAvailable: true,
              addedAt: offer.createdAt,
              subcategory: const [],
              quantity: '',
              mostSearch: 0,
              mostPurchases: 0,
            ),
          );
          _selectedProductsById[freeProductId] = product;
          final configured = freeProducts
              .where((item) => item.productId == freeProductId)
              .cast<BogoFreeProduct?>()
              .firstWhere((_) => true, orElse: () => null);
          _selectedFreeQuantitiesById[freeProductId] =
              _normalizeFreeQuantityCount(configured?.quantity);
        }

        _selectedCategory =
            _selectedTriggerProduct?.category.trim().isNotEmpty == true
            ? _selectedTriggerProduct!.category
            : null;
      }

      if (_selectedCategory != null && _selectedCategory!.trim().isNotEmpty) {
        await _loadProductsForCategory(_selectedCategory!);
      }
    } finally {
      if (mounted) {
        setState(() => _isBootstrapping = false);
      }
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProductsForCategory(
    String category, {
    bool showLoader = true,
  }) async {
    setState(() {
      _isLoading = showLoader;
      _isRefreshingProducts = !showLoader;
      _errorMessage = null;
      _selectedCategory = category;
    });

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final products = <Product>[];
      String? pageToken;

      do {
        final page = await ServerpodAdminClient().client.product
            .getProductsPage(
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

      if (!mounted) return;
      setState(() {
        _categoryProducts = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshingProducts = false;
        });
      }
    }
  }

  void _selectTriggerProduct(Product? product) {
    if (product == null) return;
    setState(() {
      _selectedTriggerProduct = product;
      _selectedTriggerVariantId = _defaultTriggerVariantId(product);
      if (product.category.trim().isNotEmpty &&
          _selectedCategory != product.category) {
        _selectedCategory = product.category;
      }
      final triggerId = product.productId;
      if (triggerId != null) {
        _selectedProductsById.remove(triggerId);
        _selectedFreeQuantitiesById.remove(triggerId);
      }
    });
    if (product.category.trim().isNotEmpty) {
      _loadProductsForCategory(product.category);
    }
  }

  List<ProductVariant> _triggerVariants(Product? product) {
    if (product == null) return const <ProductVariant>[];
    final variants = product.variants ?? const <ProductVariant>[];
    if (variants.isNotEmpty) return variants;
    return <ProductVariant>[
      ProductVariant(
        variantId: 'default',
        quantityValue: product.baseQuantity ?? 1,
        quantityUnit: product.baseUnit ?? 'pc',
        quantityDescription: product.quantityDescription,
        price: product.price,
        realPrice: product.realPrice,
        isAvailable: product.isAvailable,
        sortOrder: 0,
      ),
    ];
  }

  String? _defaultTriggerVariantId(Product product) {
    final variants = _triggerVariants(product);
    if (variants.isEmpty) return null;
    final existing = _selectedTriggerVariantId;
    final match = variants.any((variant) => variant.variantId == existing);
    return match ? existing : variants.first.variantId;
  }

  ProductVariant? _selectedTriggerVariant() {
    final trigger = _selectedTriggerProduct;
    if (trigger == null) return null;
    final variants = _triggerVariants(trigger);
    if (variants.isEmpty) return null;
    return variants.firstWhere(
      (variant) => variant.variantId == _selectedTriggerVariantId,
      orElse: () => variants.first,
    );
  }

  String _variantLabel(ProductVariant variant) {
    final quantity =
        variant.quantityValue == variant.quantityValue.truncateToDouble()
        ? variant.quantityValue.toInt().toString()
        : variant.quantityValue.toString();
    return '$quantity ${variant.quantityUnit}';
  }

  String _basePackLabel(Product product) {
    final baseQuantity = product.baseQuantity;
    final baseUnit = product.baseUnit;
    if (baseQuantity != null &&
        baseQuantity > 0 &&
        baseUnit != null &&
        baseUnit.trim().isNotEmpty) {
      final formattedQuantity = baseQuantity == baseQuantity.truncateToDouble()
          ? baseQuantity.toInt().toString()
          : baseQuantity.toString();
      return '$formattedQuantity ${baseUnit.trim()}';
    }

    final fallback = product.quantity.trim();
    return fallback.isEmpty ? '1 item' : fallback;
  }

  int _parseFreeQuantityCount(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) return 1;

    final multiplierMatch = RegExp(r'^(\d+)\s*x\b').firstMatch(normalized);
    if (multiplierMatch != null) {
      return int.tryParse(multiplierMatch.group(1)!) ?? 1;
    }

    final directNumber = int.tryParse(normalized);
    if (directNumber != null && directNumber > 0) {
      return directNumber;
    }

    return 1;
  }

  String _buildOfferTitle({
    required ProductVariant? triggerVariant,
    required int freeProductCount,
  }) {
    final buyLabel = triggerVariant == null
        ? 'Buy 1'
        : 'Buy 1 of ${_variantLabel(triggerVariant)}';
    return '$buyLabel, Get $freeProductCount Free';
  }

  void _toggleSelection(Product product) {
    final id = product.productId;
    if (id == null) return;
    if (_selectedTriggerProduct?.productId == id) return;

    setState(() {
      if (_selectedProductsById.containsKey(id)) {
        _selectedProductsById.remove(id);
        _selectedFreeQuantitiesById.remove(id);
      } else {
        _selectedProductsById[id] = product;
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantityCount(
          _selectedFreeQuantitiesById[id],
        );
      }
    });
  }

  void _updateFreeQuantity(Product product, String quantity) {
    final id = product.productId;
    if (id == null) return;
    setState(() {
      _selectedFreeQuantitiesById[id] = _normalizeFreeQuantityCount(quantity);
    });
  }

  String _normalizeFreeQuantityCount(String? value) {
    return _parseFreeQuantityCount(value).toString();
  }

  String _buildFreeQuantityLabel(Product product, String? countValue) {
    final count = _parseFreeQuantityCount(countValue);
    final packLabel = _basePackLabel(product);
    if (count <= 1) return packLabel;
    return '$count x $packLabel';
  }

  List<BogoProductSelection> _buildSelections() {
    return _selectedProductsById.entries.map((entry) {
      final product = entry.value;
      return BogoProductSelection(
        product: product,
        freeQuantity: _buildFreeQuantityLabel(
          product,
          _selectedFreeQuantitiesById[entry.key],
        ),
      );
    }).toList();
  }

  Future<void> _selectDate(bool isStart) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (selected == null) return;
    setState(() {
      if (isStart) {
        _startDate = selected;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      } else {
        _endDate = selected;
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDateCard({
    required String label,
    required DateTime value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isSubmitting ? null : onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18.r,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _formatDate(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.cardTitle(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerSection(BuildContext context) {
    final trigger = _selectedTriggerProduct;

    return Container(
      width: double.infinity,
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trigger Product',
                      style: AdminTextStyles.caption(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trigger?.productName ??
                          'Select the product customers must buy',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.cardTitle(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: trigger == null
                            ? Colors.grey.shade700
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              FilledButton.tonalIcon(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        final selected =
                            await ProductSelectionDialog.showBottomSheet(
                              context: context,
                              title: 'Select Trigger Product',
                              initialCategory: _selectedCategory,
                            );
                        if (selected != null) {
                          _selectTriggerProduct(selected);
                        }
                      },
                icon: Icon(trigger == null ? Icons.add : Icons.edit_outlined),
                label: Text(trigger == null ? 'Select' : 'Change'),
              ),
            ],
          ),
          if (trigger != null) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    width: 64.r,
                    height: 64.r,
                    color: Colors.grey.shade100,
                    child: trigger.imageUrl.isEmpty
                        ? const Icon(Icons.image_outlined)
                        : Image.network(
                            trigger.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trigger.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTextStyles.caption(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        trigger.quantity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTextStyles.body(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '₹${trigger.price.toStringAsFixed(0)}',
                        style: AdminTextStyles.body(
                          context,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _defaultTriggerVariantId(trigger),
                    decoration: const InputDecoration(
                      labelText: 'Trigger Pack',
                      border: OutlineInputBorder(),
                    ),
                    items: _triggerVariants(trigger)
                        .map(
                          (variant) => DropdownMenuItem(
                            value: variant.variantId,
                            child: Text(_variantLabel(variant)),
                          ),
                        )
                        .toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedTriggerVariantId = value;
                            });
                          },
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 140.w.clamp(112.0, 150.0).toDouble(),
                  child: TextFormField(
                    initialValue: '1',
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Min Qty',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_selectedTriggerProduct == null ||
        _selectedTriggerProduct?.productId?.trim().isEmpty != false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trigger product')),
      );
      return;
    }

    if (_selectedProductsById.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one free product'),
        ),
      );
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    final selections = _buildSelections();
    final selectedVariant = _selectedTriggerVariant();
    final offer = BogoOffer(
      offerId: widget.offer?.offerId,
      triggerProductId: _selectedTriggerProduct!.productId!,
      triggerVariantId: _selectedTriggerVariantId,
      minTriggerQuantity: 1,
      triggerBaseQuantity: selectedVariant?.quantityValue,
      triggerBaseUnit: selectedVariant?.quantityUnit,
      freeProductIds: selections
          .map((selection) => selection.product.productId!)
          .toList(),
      freeProducts: selections
          .map(
            (selection) => BogoFreeProduct(
              productId: selection.product.productId!,
              quantity: selection.freeQuantity,
            ),
          )
          .toList(),
      offerTitle: _buildOfferTitle(
        triggerVariant: selectedVariant,
        freeProductCount: selections.length,
      ),
      isActive: widget.offer?.isActive ?? true,
      startDate: _startDate,
      endDate: _endDate,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      final saved = await widget.onSave(offer);
      if (!mounted) return;
      if (saved) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Error updating BOGO offer'
                  : 'Error creating BOGO offer',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryOptions = <ProductFilterOption>[
      ..._categoryController.categories
          .map(
            (category) => ProductFilterOption(
              value: category.categoryName,
              label: category.categoryName,
            ),
          )
          .toList()
        ..sort((a, b) => a.label.compareTo(b.label)),
    ];
    final query = _searchCtrl.text.toLowerCase().trim();
    final filteredProducts = _categoryProducts.where((product) {
      if (_selectedTriggerProduct?.productId == product.productId) return false;
      if (query.isEmpty) return true;
      return product.productName.toLowerCase().contains(query) ||
          product.quantity.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit BOGO Offer' : 'Add BOGO Offer'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _save,
              icon: _isSubmitting
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(isEditing ? 'Update' : 'Create'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isBootstrapping
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 680;
                  final pagePadding = AdminResponsive.pagePadding(context);
                  final controlsHeight = (isNarrow ? 116.h : 104.h)
                      .clamp(98.0, 136.0)
                      .toDouble();
                  return AdminResponsive.constrainContent(
                    context: context,
                    maxWidth: AdminResponsive.maxFormWidth,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverPadding(
                            padding: pagePadding.copyWith(bottom: 0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTriggerSection(context),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDateCard(
                                          label: 'Start Date',
                                          value: _startDate,
                                          onTap: () => _selectDate(true),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: _buildDateCard(
                                          label: 'End Date',
                                          value: _endDate,
                                          onTap: () => _selectDate(false),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  _SelectedProductsSummary(
                                    selectedProducts: _buildSelections(),
                                    onRemove: (id) {
                                      setState(() {
                                        _selectedProductsById.remove(id);
                                        _selectedFreeQuantitiesById.remove(id);
                                      });
                                    },
                                  ),
                                  SizedBox(height: 12.h),
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _PinnedControlsHeaderDelegate(
                              minExtentValue: controlsHeight,
                              maxExtentValue: controlsHeight,
                              child: Container(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                child: ProductSearchAndCategoryControls(
                                  searchHintText: 'Search free products...',
                                  onSearchChanged: (value) {
                                    _searchCtrl.text = value;
                                    setState(() {});
                                  },
                                  categoryOptions: categoryOptions,
                                  selectedCategory: _selectedCategory ?? '',
                                  onCategorySelected: (value) {
                                    _searchFocusNode.unfocus();
                                    _loadProductsForCategory(value);
                                  },
                                  padding: EdgeInsets.fromLTRB(
                                    pagePadding.horizontal / 2,
                                    6.h,
                                    pagePadding.horizontal / 2,
                                    6.h,
                                  ),
                                  searchToCategorySpacing: 8.h,
                                  categoryHeight: 32.h
                                      .clamp(30.0, 36.0)
                                      .toDouble(),
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              pagePadding.horizontal / 2,
                              8.h,
                              pagePadding.horizontal / 2,
                              12.h,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                _selectedCategory == null
                                    ? 'Select a category to load free products'
                                    : 'Free products in $_selectedCategory (${filteredProducts.length})',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AdminTextStyles.sectionTitle(context),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Padding(
                        padding: pagePadding.copyWith(top: 0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            final category = _selectedCategory;
                            if (category == null || category.trim().isEmpty) {
                              return;
                            }
                            await _loadProductsForCategory(
                              category,
                              showLoader: false,
                            );
                          },
                          child: _buildContent(filteredProducts, isNarrow),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildContent(List<Product> filteredProducts, bool isNarrow) {
    if (_selectedCategory == null || _selectedCategory!.trim().isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 96.h),
          Center(
            child: Text(
              'Select a category first to browse free products.',
              textAlign: TextAlign.center,
              style: AdminTextStyles.body(context),
            ),
          ),
        ],
      );
    }

    if (_isLoading && !_isRefreshingProducts) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 96.h),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 96.h),
          SizedBox(
            height: 260.h.clamp(220.0, 300.0).toDouble(),
            child: AdminStateView.error(
              message: _errorMessage,
              onRetry: () => _loadProductsForCategory(_selectedCategory!),
            ),
          ),
        ],
      );
    }

    if (filteredProducts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 96.h),
          SizedBox(
            height: 260.h.clamp(220.0, 300.0).toDouble(),
            child: AdminStateView.empty(
              title: 'No products found',
              message: 'Try a different category or search term.',
              icon: Icons.search_off_outlined,
            ),
          ),
        ],
      );
    }

    if (isNarrow) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredProducts.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return _ProductSelectionTile(
            product: product,
            isSelected:
                product.productId != null &&
                _selectedProductsById.containsKey(product.productId),
            onTap: () => _toggleSelection(product),
            freeQuantity: product.productId == null
                ? product.quantity
                : _normalizeFreeQuantityCount(
                    _selectedFreeQuantitiesById[product.productId],
                  ),
            onFreeQuantityChanged: (value) =>
                _updateFreeQuantity(product, value),
          );
        },
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280.w.clamp(240.0, 320.0).toDouble(),
        mainAxisExtent: 226.h.clamp(204.0, 252.0).toDouble(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _ProductSelectionTile(
          product: product,
          isSelected:
              product.productId != null &&
              _selectedProductsById.containsKey(product.productId),
          onTap: () => _toggleSelection(product),
          freeQuantity: product.productId == null
              ? product.quantity
              : _normalizeFreeQuantityCount(
                  _selectedFreeQuantitiesById[product.productId],
                ),
          onFreeQuantityChanged: (value) => _updateFreeQuantity(product, value),
        );
      },
    );
  }
}

class _BogoProductPickerScreenState extends State<BogoProductPickerScreen> {
  final _client = ServerpodAdminClient().client;
  final _searchCtrl = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _selectedProductsById = <String, Product>{};
  final _selectedFreeQuantitiesById = <String, String>{};

  List<Product> _categoryProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    for (final selection in widget.initiallySelectedProducts) {
      final product = selection.product;
      final id = product.productId;
      if (id != null) {
        _selectedProductsById[id] = product;
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantityCount(
          selection.freeQuantity,
        );
      }
    }
    _selectedCategory = widget.initialCategory;
    if (_selectedCategory != null && _selectedCategory!.trim().isNotEmpty) {
      _loadProductsForCategory(_selectedCategory!);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProductsForCategory(String category) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCategory = category;
    });

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final products = <Product>[];
      String? pageToken;

      do {
        final page = await _client.product.getProductsPage(
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

      if (!mounted) return;
      setState(() {
        _categoryProducts = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSelection(Product product) {
    final id = product.productId;
    if (id == null) return;

    setState(() {
      if (_selectedProductsById.containsKey(id)) {
        _selectedProductsById.remove(id);
        _selectedFreeQuantitiesById.remove(id);
      } else {
        _selectedProductsById[id] = product;
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantityCount(
          _selectedFreeQuantitiesById[id],
        );
      }
    });
  }

  void _updateFreeQuantity(Product product, String quantity) {
    final id = product.productId;
    if (id == null) return;

    setState(() {
      _selectedFreeQuantitiesById[id] = _normalizeFreeQuantityCount(quantity);
    });
  }

  String _normalizeFreeQuantityCount(String? value) {
    return _parseFreeQuantityCount(value).toString();
  }

  String _basePackLabel(Product product) {
    final baseQuantity = product.baseQuantity;
    final baseUnit = product.baseUnit;
    if (baseQuantity != null &&
        baseQuantity > 0 &&
        baseUnit != null &&
        baseUnit.trim().isNotEmpty) {
      final formattedQuantity = baseQuantity == baseQuantity.truncateToDouble()
          ? baseQuantity.toInt().toString()
          : baseQuantity.toString();
      return '$formattedQuantity ${baseUnit.trim()}';
    }

    final fallback = product.quantity.trim();
    return fallback.isEmpty ? '1 item' : fallback;
  }

  int _parseFreeQuantityCount(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) return 1;

    final multiplierMatch = RegExp(r'^(\d+)\s*x\b').firstMatch(normalized);
    if (multiplierMatch != null) {
      return int.tryParse(multiplierMatch.group(1)!) ?? 1;
    }

    final directNumber = int.tryParse(normalized);
    if (directNumber != null && directNumber > 0) {
      return directNumber;
    }

    return 1;
  }

  String _buildFreeQuantityLabel(Product product, String? countValue) {
    final count = _parseFreeQuantityCount(countValue);
    final packLabel = _basePackLabel(product);
    if (count <= 1) return packLabel;
    return '$count x $packLabel';
  }

  List<BogoProductSelection> _buildSelections() {
    return _selectedProductsById.entries.map((entry) {
      final product = entry.value;
      return BogoProductSelection(
        product: product,
        freeQuantity: _buildFreeQuantityLabel(
          product,
          _selectedFreeQuantitiesById[entry.key],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        AdminCategoryController.instance.categories
            .map((category) => category.categoryName)
            .toList()
          ..sort();
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardInset > 0;

    final query = _searchCtrl.text.toLowerCase().trim();
    final filteredProducts = _categoryProducts.where((product) {
      if (query.isEmpty) return true;
      return product.productName.toLowerCase().contains(query) ||
          product.quantity.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 680;
        final spacing = AdminSpacing.md;
        final headerContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNarrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategoryDropdown(categories),
                  SizedBox(height: spacing),
                  FilledButton.tonalIcon(
                    onPressed: _selectedCategory == null
                        ? null
                        : () => _loadProductsForCategory(_selectedCategory!),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: _buildCategoryDropdown(categories)),
                  SizedBox(width: spacing),
                  FilledButton.tonalIcon(
                    onPressed: _selectedCategory == null
                        ? null
                        : () => _loadProductsForCategory(_selectedCategory!),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            SizedBox(height: spacing),
            TextField(
              controller: _searchCtrl,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search within selected category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AdminSpacing.lg),
            _SelectedProductsSummary(
              selectedProducts: _buildSelections(),
              onRemove: (id) {
                setState(() {
                  _selectedProductsById.remove(id);
                  _selectedFreeQuantitiesById.remove(id);
                });
              },
            ),
            SizedBox(height: AdminSpacing.lg),
            Text(
              _selectedCategory == null
                  ? 'Select a category to load products'
                  : 'Products in $_selectedCategory (${filteredProducts.length})',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AdminTextStyles.sectionTitle(context),
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select BOGO Free Products'),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context, _buildSelections());
                  },
                  icon: const Icon(Icons.check),
                  label: Text('Use (${_selectedProductsById.length})'),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, bodyConstraints) {
                final header = ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isKeyboardOpen
                        ? bodyConstraints.maxHeight * 0.42
                        : bodyConstraints.maxHeight,
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,
                    child: headerContent,
                  ),
                );

                return AdminResponsive.constrainContent(
                  context: context,
                  maxWidth: AdminResponsive.maxFormWidth,
                  child: Padding(
                    padding: AdminResponsive.pagePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header,
                        SizedBox(height: spacing),
                        Expanded(
                          child: _buildContent(
                            filteredProducts,
                            isNarrow,
                            bottomPadding: isKeyboardOpen
                                ? 24.h
                                : AdminResponsive.bottomInset(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(List<String> categories) {
    return DropdownButtonFormField<String>(
      initialValue: categories.contains(_selectedCategory)
          ? _selectedCategory
          : null,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        _loadProductsForCategory(value);
      },
    );
  }

  Widget _buildContent(
    List<Product> filteredProducts,
    bool isNarrow, {
    double bottomPadding = 0,
  }) {
    if (_selectedCategory == null || _selectedCategory!.trim().isEmpty) {
      return Center(
        child: Text(
          'Select category first to browse products.',
          textAlign: TextAlign.center,
          style: AdminTextStyles.body(context),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return AdminStateView.error(
        message: _errorMessage,
        onRetry: () => _loadProductsForCategory(_selectedCategory!),
      );
    }

    if (filteredProducts.isEmpty) {
      return Center(
        child: Text(
          'No products found for this category/search.',
          textAlign: TextAlign.center,
          style: AdminTextStyles.body(context),
        ),
      );
    }

    if (isNarrow) {
      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        padding: EdgeInsets.only(bottom: bottomPadding),
        itemCount: filteredProducts.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return _ProductSelectionTile(
            product: product,
            isSelected:
                product.productId != null &&
                _selectedProductsById.containsKey(product.productId),
            onTap: () => _toggleSelection(product),
            freeQuantity: product.productId == null
                ? product.quantity
                : _normalizeFreeQuantityCount(
                    _selectedFreeQuantitiesById[product.productId],
                  ),
            onFreeQuantityChanged: (value) =>
                _updateFreeQuantity(product, value),
          );
        },
      );
    }

    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      padding: EdgeInsets.only(bottom: bottomPadding),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280.w.clamp(240.0, 320.0).toDouble(),
        mainAxisExtent: 226.h.clamp(204.0, 252.0).toDouble(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _ProductSelectionTile(
          product: product,
          isSelected:
              product.productId != null &&
              _selectedProductsById.containsKey(product.productId),
          onTap: () => _toggleSelection(product),
          freeQuantity: product.productId == null
              ? product.quantity
              : _normalizeFreeQuantityCount(
                  _selectedFreeQuantitiesById[product.productId],
                ),
          onFreeQuantityChanged: (value) => _updateFreeQuantity(product, value),
        );
      },
    );
  }
}

class _ProductSelectionTile extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;
  final String freeQuantity;
  final ValueChanged<String> onFreeQuantityChanged;

  const _ProductSelectionTile({
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.freeQuantity,
    required this.onFreeQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.green.shade50 : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 64.r,
                    height: 64.r,
                    color: Colors.grey.shade100,
                    child: product.imageUrl.isEmpty
                        ? const Icon(Icons.image_not_supported_outlined)
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image_outlined);
                            },
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTextStyles.cardTitle(context),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        product.quantity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: AdminTextStyles.body(context).copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(value: isSelected, onChanged: (_) => onTap()),
              ],
            ),
            if (isSelected) ...[
              SizedBox(height: 12.h),
              TextFormField(
                key: ValueKey(
                  'picker_free_quantity_${product.productId ?? ''}',
                ),
                initialValue: freeQuantity,
                autofocus: false,
                onChanged: onFreeQuantityChanged,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Free Qty Count',
                  hintText: '1',
                  helperText:
                      'Base pack: ${product.baseQuantity != null && product.baseUnit != null ? '${product.baseQuantity == product.baseQuantity!.truncateToDouble() ? product.baseQuantity!.toInt() : product.baseQuantity} ${product.baseUnit}' : product.quantity}',
                  prefixIcon: const Icon(Icons.scale_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PinnedControlsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedControlsHeaderDelegate({
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.child,
  });

  final double minExtentValue;
  final double maxExtentValue;
  final Widget child;

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: SizedBox.expand(
        child: Align(alignment: Alignment.topCenter, child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedControlsHeaderDelegate oldDelegate) {
    return minExtentValue != oldDelegate.minExtentValue ||
        maxExtentValue != oldDelegate.maxExtentValue ||
        child != oldDelegate.child;
  }
}

class _SelectedProductsSummary extends StatelessWidget {
  final List<BogoProductSelection> selectedProducts;
  final ValueChanged<String> onRemove;

  const _SelectedProductsSummary({
    required this.selectedProducts,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedProducts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          'No free products selected yet.',
          style: AdminTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Products (${selectedProducts.length})',
          style: AdminTextStyles.cardTitle(context),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 128.h.clamp(116.0, 146.0).toDouble(),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedProducts.length,
            separatorBuilder: (_, _) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final product = selectedProducts[index];
              final productId = product.product.productId;

              return Container(
                width: 250.w.clamp(220.0, 280.0).toDouble(),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: 56.r,
                        height: 56.r,
                        color: Colors.grey.shade100,
                        child: product.product.imageUrl.isEmpty
                            ? const Icon(Icons.image_outlined)
                            : Image.network(
                                product.product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image_outlined,
                                  );
                                },
                              ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AdminTextStyles.cardTitle(context),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Pack: ${product.product.quantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Free: ${product.freeQuantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AdminTextStyles.caption(context).copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: productId == null
                          ? null
                          : () => onRemove(productId),
                      constraints: BoxConstraints(
                        minWidth: 36.r,
                        minHeight: 36.r,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.close, size: 20.r),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
