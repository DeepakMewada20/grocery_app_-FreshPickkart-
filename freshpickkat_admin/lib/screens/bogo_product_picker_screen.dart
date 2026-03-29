import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
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

  const BogoOfferEditorScreen({
    super.key,
    this.offer,
    required this.onSave,
  });

  static Future<bool?> show({
    required BuildContext context,
    BogoOffer? offer,
    required Future<bool> Function(BogoOffer offer) onSave,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BogoOfferEditorScreen(
          offer: offer,
          onSave: onSave,
        ),
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
  bool _isBootstrapping = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _selectedCategory;
  Product? _selectedTriggerProduct;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
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
              .firstWhere(
                (_) => true,
                orElse: () => null,
              );
          _selectedFreeQuantitiesById[freeProductId] = _normalizeFreeQuantity(
            configured?.quantity,
            fallback: product.quantity,
          );
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
        setState(() => _isLoading = false);
      }
    }
  }

  void _selectTriggerProduct(Product? product) {
    if (product == null) return;
    setState(() {
      _selectedTriggerProduct = product;
      if (product.category.trim().isNotEmpty && _selectedCategory != product.category) {
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
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantity(
          _selectedFreeQuantitiesById[id],
          fallback: product.quantity,
        );
      }
    });
  }

  void _updateFreeQuantity(Product product, String quantity) {
    final id = product.productId;
    if (id == null) return;
    setState(() {
      _selectedFreeQuantitiesById[id] = quantity;
    });
  }

  String _normalizeFreeQuantity(String? value, {required String fallback}) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) return normalized;

    final normalizedFallback = fallback.trim();
    return normalizedFallback.isEmpty ? '1 item' : normalizedFallback;
  }

  List<BogoProductSelection> _buildSelections() {
    return _selectedProductsById.entries.map((entry) {
      final product = entry.value;
      return BogoProductSelection(
        product: product,
        freeQuantity: _normalizeFreeQuantity(
          _selectedFreeQuantitiesById[entry.key],
          fallback: product.quantity,
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
        const SnackBar(content: Text('Please select at least one free product')),
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
    final offer = BogoOffer(
      offerId: widget.offer?.offerId,
      triggerProductId: _selectedTriggerProduct!.productId!,
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
      offerTitle: 'Buy 1 Get 1 Free',
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
    final categories = _categoryController.categories
        .map((category) => category.categoryName)
        .toList()
      ..sort();
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
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              final selected = await ProductSelectionDialog.show(
                                context: context,
                                title: 'Select Trigger Product',
                                initialCategory: _selectedCategory,
                              );
                              if (selected != null) {
                                _selectTriggerProduct(selected);
                              }
                            },
                      icon: const Icon(Icons.search),
                      label: Text(
                        _selectedTriggerProduct == null
                            ? 'Select Trigger Product'
                            : 'Change Trigger Product',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: _selectedTriggerProduct == null
                          ? const Text(
                              'No trigger product selected yet.',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          : Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade100,
                                    child: _selectedTriggerProduct!.imageUrl.isEmpty
                                        ? const Icon(Icons.image_outlined)
                                        : Image.network(
                                            _selectedTriggerProduct!.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                const Icon(
                                                  Icons.broken_image_outlined,
                                                ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _selectedTriggerProduct!.productName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_selectedTriggerProduct!.category} • ${_selectedTriggerProduct!.quantity}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : () => _selectDate(true),
                            icon: const Icon(Icons.calendar_today),
                            label: Text('Start: ${_formatDate(_startDate)}'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : () => _selectDate(false),
                            icon: const Icon(Icons.calendar_today),
                            label: Text('End: ${_formatDate(_endDate)}'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: const Text(
                        'Offer title is fixed as "Buy 1 Get 1 Free". Select the trigger product and then choose which free products should be available for this offer.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 680;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isNarrow)
                                Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      initialValue: categories.contains(
                                        _selectedCategory,
                                      )
                                          ? _selectedCategory
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Free Product Category',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: categories
                                          .map(
                                            (category) => DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(
                                                category,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          _loadProductsForCategory(value);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    FilledButton.tonalIcon(
                                      onPressed: _selectedCategory == null || _isSubmitting
                                          ? null
                                          : () => _loadProductsForCategory(
                                                _selectedCategory!,
                                              ),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Refresh'),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        initialValue: categories.contains(
                                          _selectedCategory,
                                        )
                                            ? _selectedCategory
                                            : null,
                                        decoration: const InputDecoration(
                                          labelText: 'Free Product Category',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: categories
                                            .map(
                                              (category) =>
                                                  DropdownMenuItem<String>(
                                                    value: category,
                                                    child: Text(
                                                      category,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            _loadProductsForCategory(value);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    FilledButton.tonalIcon(
                                      onPressed: _selectedCategory == null || _isSubmitting
                                          ? null
                                          : () => _loadProductsForCategory(
                                                _selectedCategory!,
                                              ),
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
                                  hintText: 'Search free products...',
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
                                    ? 'Select a category to load free products'
                                    : 'Free products in $_selectedCategory (${filteredProducts.length})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _buildContent(
                                  filteredProducts,
                                  isNarrow,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildContent(List<Product> filteredProducts, bool isNarrow) {
    if (_selectedCategory == null || _selectedCategory!.trim().isEmpty) {
      return const Center(
        child: Text('Select a category first to browse free products.'),
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
                : _normalizeFreeQuantity(
                    _selectedFreeQuantitiesById[product.productId],
                    fallback: product.quantity,
                  ),
            onFreeQuantityChanged: (value) =>
                _updateFreeQuantity(product, value),
          );
        },
      );
    }

    return GridView.builder(
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
              : _normalizeFreeQuantity(
                  _selectedFreeQuantitiesById[product.productId],
                  fallback: product.quantity,
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
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantity(
          selection.freeQuantity,
          fallback: product.quantity,
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
        _selectedFreeQuantitiesById[id] = _normalizeFreeQuantity(
          _selectedFreeQuantitiesById[id],
          fallback: product.quantity,
        );
      }
    });
  }

  void _updateFreeQuantity(Product product, String quantity) {
    final id = product.productId;
    if (id == null) return;

    setState(() {
      _selectedFreeQuantitiesById[id] = quantity;
    });
  }

  String _normalizeFreeQuantity(String? value, {required String fallback}) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) return normalized;

    final normalizedFallback = fallback.trim();
    return normalizedFallback.isEmpty ? '1 item' : normalizedFallback;
  }

  List<BogoProductSelection> _buildSelections() {
    return _selectedProductsById.entries.map((entry) {
      final product = entry.value;
      return BogoProductSelection(
        product: product,
        freeQuantity: _normalizeFreeQuantity(
          _selectedFreeQuantitiesById[entry.key],
          fallback: product.quantity,
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
                : _normalizeFreeQuantity(
                    _selectedFreeQuantitiesById[product.productId],
                    fallback: product.quantity,
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
              : _normalizeFreeQuantity(
                  _selectedFreeQuantitiesById[product.productId],
                  fallback: product.quantity,
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
                onChanged: onFreeQuantityChanged,
                decoration: InputDecoration(
                  labelText: 'Free quantity',
                  hintText: 'e.g. 500gm',
                  helperText: 'Pack: ${product.quantity}',
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
