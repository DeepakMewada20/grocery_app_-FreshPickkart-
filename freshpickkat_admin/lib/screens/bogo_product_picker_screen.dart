import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/screens/product_dialogs/products_list_content.dart';
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
  int _minimumTriggerQuantity = 1;
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
        _minimumTriggerQuantity =
            offer.minTriggerQuantity == null || offer.minTriggerQuantity! <= 0
            ? 1
            : offer.minTriggerQuantity!;

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
        forceRefresh: true,
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
    required int minimumTriggerQuantity,
    required ProductVariant? triggerVariant,
    required int freeProductCount,
  }) {
    final buyLabel = triggerVariant == null
        ? 'Buy $minimumTriggerQuantity'
        : 'Buy $minimumTriggerQuantity of ${_variantLabel(triggerVariant)}';
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
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 18,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDate(value),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trigger?.productName ??
                          'Select the product customers must buy',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: trigger == null
                            ? Colors.grey.shade700
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
            const SizedBox(height: 14),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 64,
                    height: 64,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trigger.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trigger.quantity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${trigger.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                const SizedBox(width: 12),
                SizedBox(
                  width: 140,
                  child: TextFormField(
                    initialValue: '$_minimumTriggerQuantity',
                    enabled: !_isSubmitting,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Qty',
                      hintText: '1',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _minimumTriggerQuantity =
                            int.tryParse(value.trim()) == null ||
                                int.parse(value.trim()) <= 0
                            ? 1
                            : int.parse(value.trim());
                      });
                    },
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
      minTriggerQuantity: _minimumTriggerQuantity,
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
        minimumTriggerQuantity: _minimumTriggerQuantity,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _save,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
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
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTriggerSection(context),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDateCard(
                                        label: 'Start Date',
                                        value: _startDate,
                                        onTap: () => _selectDate(true),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDateCard(
                                        label: 'End Date',
                                        value: _endDate,
                                        onTap: () => _selectDate(false),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _SelectedProductsSummary(
                                  selectedProducts: _buildSelections(),
                                  onRemove: (id) {
                                    setState(() {
                                      _selectedProductsById.remove(id);
                                      _selectedFreeQuantitiesById.remove(id);
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _PinnedControlsHeaderDelegate(
                            minExtentValue: 104,
                            maxExtentValue: 104,
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  6,
                                  16,
                                  6,
                                ),
                                searchToCategorySpacing: 8,
                                categoryHeight: 32,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              _selectedCategory == null
                                  ? 'Select a category to load free products'
                                  : 'Free products in $_selectedCategory (${filteredProducts.length})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        children: const [
          SizedBox(height: 120),
          Center(
            child: Text('Select a category first to browse free products.'),
          ),
        ],
      );
    }

    if (_isLoading && !_isRefreshingProducts) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load products.\n$_errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _loadProductsForCategory(_selectedCategory!),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (filteredProducts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No products found for this category/search.')),
        ],
      );
    }

    if (isNarrow) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredProducts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 214,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
        forceRefresh: true,
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
        final headerContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNarrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategoryDropdown(categories),
                  const SizedBox(height: 12),
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
                  const SizedBox(width: 12),
                  FilledButton.tonalIcon(
                    onPressed: _selectedCategory == null
                        ? null
                        : () => _loadProductsForCategory(_selectedCategory!),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            const SizedBox(height: 12),
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
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _SelectedProductsSummary(
              selectedProducts: _buildSelections(),
              onRemove: (id) {
                setState(() {
                  _selectedProductsById.remove(id);
                  _selectedFreeQuantitiesById.remove(id);
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory == null
                  ? 'Select a category to load products'
                  : 'Products in $_selectedCategory (${filteredProducts.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select BOGO Free Products'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header,
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildContent(
                          filteredProducts,
                          isNarrow,
                          bottomPadding: isKeyboardOpen ? 24 : 0,
                        ),
                      ),
                    ],
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
      return const Center(
        child: Text('Select category first to browse products.'),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load products.\n$_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _loadProductsForCategory(_selectedCategory!),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products found for this category/search.'),
      );
    }

    if (isNarrow) {
      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        padding: EdgeInsets.only(bottom: bottomPadding),
        itemCount: filteredProducts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 214,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 64,
                    height: 64,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.quantity,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
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
              const SizedBox(height: 12),
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
                    borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'No free products selected yet.',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Products (${selectedProducts.length})',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final product = selectedProducts[index];
              final productId = product.product.productId;

              return Container(
                width: 250,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 56,
                        height: 56,
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
                    const SizedBox(width: 10),
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pack: ${product.product.quantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Free: ${product.freeQuantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close),
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
