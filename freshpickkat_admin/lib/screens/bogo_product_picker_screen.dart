import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class BogoProductSelection {
  final Product product;
  final ProductVariant? variant;
  final int freeQuantity;

  const BogoProductSelection({
    required this.product,
    this.variant,
    this.freeQuantity = 1,
  });

  String get displayLabel {
    if (variant == null) return product.quantity;
    final quantity =
        variant!.quantityValue == variant!.quantityValue.truncateToDouble()
        ? variant!.quantityValue.toInt().toString()
        : variant!.quantityValue.toString();
    final unit = variant!.quantityUnit;
    final desc = variant!.quantityDescription?.trim();
    return desc != null && desc.isNotEmpty
        ? '$quantity $unit ($desc)'
        : '$quantity $unit';
  }
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
  final _selectedProductsById = <String, Product>{};
  final _selectedVariantsById = <String, ProductVariant?>{};
  final _freeQuantitiesById = <String, int>{};
  final _productController = AdminProductController.instance;
  final _categoryController = AdminCategoryController.instance;

  bool _isBootstrapping = true;
  bool _isSubmitting = false;
  String? _selectedCategory;
  Product? _selectedTriggerProduct;
  String? _selectedTriggerVariantId;
  int _requiredTriggerQuantity = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  bool get isEditing => widget.offer != null;

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

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
        _selectedTriggerVariantId = offer.triggerVariantId;
        _requiredTriggerQuantity = (offer.minTriggerQuantity ?? 1) <= 0
            ? 1
            : offer.minTriggerQuantity ?? 1;

        _selectedTriggerProduct =
            _firstWhereOrNull(
              _productController.products,
              (Product p) => p.productId == offer.triggerProductId,
            ) ??
            Product(
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
            );

        final freeProducts = offer.freeProducts ?? const <BogoFreeProduct>[];
        for (final freeProductId in offer.freeProductIds) {
          final product =
              _firstWhereOrNull(
                _productController.products,
                (Product p) => p.productId == freeProductId,
              ) ??
              Product(
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
              );
          _selectedProductsById[freeProductId] = product;

          final configured = _firstWhereOrNull(
            freeProducts,
            (BogoFreeProduct item) => item.productId == freeProductId,
          );

          if (configured?.variantId != null) {
            _selectedVariantsById[freeProductId] = _firstWhereOrNull(
              product.variants ?? const <ProductVariant>[],
              (ProductVariant v) => v.variantId == configured!.variantId,
            );
          } else {
            _selectedVariantsById[freeProductId] = null;
          }
          _freeQuantitiesById[freeProductId] =
              (configured?.freeQuantity ?? 1) <= 0
              ? 1
              : configured?.freeQuantity ?? 1;
        }

        _selectedCategory =
            _selectedTriggerProduct?.category.trim().isNotEmpty == true
            ? _selectedTriggerProduct!.category
            : null;
      }
    } finally {
      if (mounted) {
        setState(() => _isBootstrapping = false);
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
        _selectedVariantsById.remove(triggerId);
      }
    });
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

  String _buildOfferTitle({
    required ProductVariant? triggerVariant,
    required List<BogoProductSelection> selections,
  }) {
    final buyLabel = triggerVariant == null
        ? 'Buy $_requiredTriggerQuantity'
        : 'Buy $_requiredTriggerQuantity x ${_variantLabel(triggerVariant)}';
    final totalFreeQuantity = selections.fold<int>(
      0,
      (sum, selection) =>
          sum + (selection.freeQuantity <= 0 ? 1 : selection.freeQuantity),
    );
    if (selections.length == 1 && selections.first.variant != null) {
      return '$buyLabel, Get ${selections.first.freeQuantity} x ${_variantLabel(selections.first.variant!)} FREE';
    }
    return '$buyLabel, Get $totalFreeQuantity FREE';
  }

  Future<void> _selectFreeProducts() async {
    final results = await ProductSelectionDialog.showMultiSelectBottomSheet(
      context: context,
      title: 'Select Free Products',
      initialCategory: _selectedCategory,
      initialSelections: _selectedProductsById.entries.map((e) {
        return ProductSelectionResult(
          product: e.value,
          variant: _selectedVariantsById[e.key],
        );
      }).toList(),
    );

    if (results != null) {
      setState(() {
        _selectedProductsById.clear();
        _selectedVariantsById.clear();
        for (final r in results) {
          final id = r.productId;
          if (id.isNotEmpty && id != _selectedTriggerProduct?.productId) {
            _selectedProductsById[id] = r.product;
            _selectedVariantsById[id] = r.variant;
            _freeQuantitiesById.putIfAbsent(id, () => 1);
          }
        }
      });
    }
  }

  List<BogoProductSelection> _buildSelections() {
    return _selectedProductsById.entries.map((entry) {
      final product = entry.value;
      final variant = _selectedVariantsById[entry.key];
      return BogoProductSelection(
        product: product,
        variant: variant,
        freeQuantity: _freeQuantitiesById[entry.key] ?? 1,
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
            DropdownButtonFormField<String>(
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
            SizedBox(height: 12.h),
            TextFormField(
              key: ValueKey('required_qty_${trigger.productId}'),
              initialValue: _requiredTriggerQuantity.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Required Quantity',
                border: OutlineInputBorder(),
                helperText: 'Example: Buy 2 eligible packs',
              ),
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      final parsed = int.tryParse(value.trim()) ?? 1;
                      _requiredTriggerQuantity = parsed <= 0 ? 1 : parsed;
                    },
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
      minTriggerQuantity: _requiredTriggerQuantity <= 0
          ? 1
          : _requiredTriggerQuantity,
      triggerBaseQuantity: selectedVariant?.quantityValue,
      triggerBaseUnit: selectedVariant?.quantityUnit,
      freeProductIds: selections
          .map((selection) => selection.product.productId!)
          .toList(),
      freeProducts: selections
          .map(
            (selection) => BogoFreeProduct(
              productId: selection.product.productId!,
              variantId: selection.variant?.variantId,
              freeQuantity: selection.freeQuantity <= 0
                  ? 1
                  : selection.freeQuantity,
            ),
          )
          .toList(),
      offerTitle: _buildOfferTitle(
        triggerVariant: selectedVariant,
        selections: selections,
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
            : AdminResponsive.constrainContent(
                context: context,
                maxWidth: AdminResponsive.maxFormWidth,
                child: ListView(
                  padding: AdminResponsive.pagePadding(context),
                  children: [
                    _buildTriggerSection(context),
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 20.h),
                    _SelectedProductsSummary(
                      selectedProducts: _buildSelections(),
                      onRemove: (id) {
                        setState(() {
                          _selectedProductsById.remove(id);
                          _selectedVariantsById.remove(id);
                          _freeQuantitiesById.remove(id);
                        });
                      },
                      onQuantityChanged: (id, quantity) {
                        setState(() {
                          _freeQuantitiesById[id] = quantity <= 0
                              ? 1
                              : quantity;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: FilledButton.tonalIcon(
                        onPressed: _isSubmitting ? null : _selectFreeProducts,
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                        label: const Text('Add Free Products'),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SelectedProductsSummary extends StatelessWidget {
  final List<BogoProductSelection> selectedProducts;
  final ValueChanged<String> onRemove;
  final void Function(String productId, int quantity) onQuantityChanged;

  const _SelectedProductsSummary({
    required this.selectedProducts,
    required this.onRemove,
    required this.onQuantityChanged,
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
          height: 174.h.clamp(156.0, 196.0).toDouble(),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedProducts.length,
            separatorBuilder: (_, _) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final selection = selectedProducts[index];
              final productId = selection.product.productId;

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
                        child: selection.product.imageUrl.isEmpty
                            ? const Icon(Icons.image_outlined)
                            : Image.network(
                                selection.product.imageUrl,
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
                            selection.product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AdminTextStyles.cardTitle(context),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Pack: ${selection.displayLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AdminTextStyles.caption(context).copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: 132.w.clamp(118.0, 150.0).toDouble(),
                            child: TextFormField(
                              key: ValueKey(
                                'free_qty_${selection.product.productId}',
                              ),
                              initialValue: selection.freeQuantity.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Free Qty',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: productId == null
                                  ? null
                                  : (value) {
                                      final parsed =
                                          int.tryParse(value.trim()) ?? 1;
                                      onQuantityChanged(
                                        productId,
                                        parsed <= 0 ? 1 : parsed,
                                      );
                                    },
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
