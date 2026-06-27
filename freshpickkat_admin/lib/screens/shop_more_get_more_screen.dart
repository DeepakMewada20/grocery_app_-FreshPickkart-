import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_shop_more_get_more_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/shared_dialogs.dart';

class ShopMoreGetMoreScreen extends StatefulWidget {
  const ShopMoreGetMoreScreen({super.key});

  @override
  State<ShopMoreGetMoreScreen> createState() => _ShopMoreGetMoreScreenState();
}

class _ShopMoreGetMoreScreenState extends State<ShopMoreGetMoreScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminShopMoreGetMoreController _controller =
      AdminShopMoreGetMoreController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_productController.products.isEmpty) {
        _productController.loadInitial();
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _searchQuery.isNotEmpty) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Shop More, Get More'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadOffers(force: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Offer'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search offers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.networkController.hasError.value) {
                return NetworkErrorWidget(
                  onRetry: () =>
                      _controller.networkController.retryLastRequest(),
                );
              }

              if (_controller.isLoading.value &&
                  _controller.offers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final offers = _controller.offers
                  .where((o) => o.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 64,
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Shop More, Get More offers found',
                        style: TextStyle(
                          color: AdminAppTheme.getTextSecondaryColor(context),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: AdminResponsive.bottomInset(context),
                ),
                itemCount:
                    offers.length + (_controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= offers.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final offer = offers[index];
                  return _ShopMoreGetMoreCard(
                    offer: offer,
                    onToggle: (isActive) => _controller.setOfferActive(
                      offer.offerId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditDialog(offer),
                    onDelete: () => _showDeleteConfirmation(offer),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AdminResponsive.pageHorizontalPadding(context),
          0,
          AdminResponsive.pageHorizontalPadding(context),
          MediaQuery.viewInsetsOf(context).bottom + 12.h,
        ),
        child: _ShopMoreGetMoreDialog(
          onSave: (offer) async {
            return _controller.upsertOffer(offer);
          },
        ),
      ),
    );
  }

  void _showEditDialog(ShopMoreGetMoreOffer offer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AdminResponsive.pageHorizontalPadding(context),
          0,
          AdminResponsive.pageHorizontalPadding(context),
          MediaQuery.viewInsetsOf(context).bottom + 12.h,
        ),
        child: _ShopMoreGetMoreDialog(
          offer: offer,
          onSave: (updated) async {
            return _controller.upsertOffer(updated);
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(ShopMoreGetMoreOffer offer) async {
    try {
      final result = await _controller.deleteOffer(offer.offerId ?? '');
      if (!mounted) return;
      if (result == null) {
        showUndoSnackBar(
          context,
          message: 'Shop More, Get More offer permanently deleted',
          onUndo: () {},
        );
      } else if (result == true) {
        showUndoSnackBar(
          context,
          message: 'Shop More, Get More offer deactivated',
          onUndo: () {
            _controller.setOfferActive(offer.offerId ?? '', true);
          },
        );
      }
    } catch (_) {}
  }
}

class _ShopMoreGetMoreCard extends StatelessWidget {
  final ShopMoreGetMoreOffer offer;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ShopMoreGetMoreCard({
    required this.offer,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: offer.isActive
                        ? AdminAppTheme.getSuccessColor(context)
                        : AdminAppTheme.getMutedIconColor(context),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.name,
                        style: AdminTextStyles.cardTitle(context).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Min: ₹${offer.minimumOrderAmount.toStringAsFixed(0)}',
                        style: AdminTextStyles.caption(context).copyWith(
                          color: AdminAppTheme.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: offer.isActive,
                  onChanged: onToggle,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _InfoChip(
                  label: 'Qty: ${offer.freeQuantity}',
                  icon: Icons.redeem,
                ),
                SizedBox(width: 8.w),
                _InfoChip(
                  label: 'Priority: ${offer.priority}',
                  icon: Icons.low_priority,
                ),
                SizedBox(width: 8.w),
                _InfoChip(
                  label: '${offer.startDate.day}/${offer.startDate.month}',
                  icon: Icons.date_range,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AdminAppTheme.getSubtleSurfaceColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: AdminAppTheme.getMutedIconColor(context)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AdminAppTheme.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopMoreGetMoreDialog extends StatefulWidget {
  final ShopMoreGetMoreOffer? offer;
  final Future<bool> Function(ShopMoreGetMoreOffer offer) onSave;

  const _ShopMoreGetMoreDialog({this.offer, required this.onSave});

  @override
  State<_ShopMoreGetMoreDialog> createState() => _ShopMoreGetMoreDialogState();
}

class _ShopMoreGetMoreDialogState extends State<_ShopMoreGetMoreDialog> {
  final _nameController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _freeQtyController = TextEditingController();
  final _priorityController = TextEditingController();
  final _productController = AdminProductController.instance;

  bool _isSubmitting = false;
  Product? _selectedProduct;
  String? _selectedVariantId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  String? _selectedCategory;

  bool get isEditing => widget.offer != null;

  List<ProductVariant> _productVariants(Product product) {
    final variants = product.variants ?? <ProductVariant>[];
    if (variants.isNotEmpty) return variants;
    return [
      ProductVariant(
        variantId: 'default',
        quantityValue: 1,
        quantityUnit: 'pc',
        price: product.price,
        realPrice: product.realPrice,
        isAvailable: product.isAvailable,
        sortOrder: 0,
      ),
    ];
  }

  String _variantLabel(ProductVariant variant) {
    final qty = variant.quantityValue == variant.quantityValue.truncateToDouble()
        ? variant.quantityValue.toInt().toString()
        : variant.quantityValue.toString();
    final desc = variant.quantityDescription?.trim();
    return desc != null && desc.isNotEmpty
        ? '$qty ${variant.quantityUnit} ($desc)'
        : '$qty ${variant.quantityUnit}';
  }

  @override
  void initState() {
    super.initState();
    final offer = widget.offer;
    if (offer != null) {
      _nameController.text = offer.name;
      _minAmountController.text = offer.minimumOrderAmount.toStringAsFixed(0);
      _freeQtyController.text = offer.freeQuantity.toString();
      _priorityController.text = offer.priority.toString();
      _startDate = offer.startDate;
      _endDate = offer.endDate;

      _selectedProduct = _firstWhereOrNull(
        _productController.products,
        (Product p) => p.productId == offer.freeProductId,
      );
      if (_selectedProduct != null && offer.freeVariantId != null) {
        _selectedVariantId = offer.freeVariantId;
      }
    } else {
      _freeQtyController.text = '1';
      _priorityController.text = '0';
    }
  }

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minAmountController.dispose();
    _freeQtyController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _selectProduct() async {
    final selected = await ProductSelectionDialog.showBottomSheet(
      context: context,
      title: 'Select Reward Product',
      initialCategory: _selectedCategory,
    );
    if (selected != null) {
      setState(() {
        _selectedProduct = selected;
        _selectedVariantId = _defaultVariantId(selected);
        if (selected.category.trim().isNotEmpty) {
          _selectedCategory = selected.category;
        }
      });
    }
  }

  String? _defaultVariantId(Product product) {
    final variants = _productVariants(product);
    if (variants.isEmpty) return null;
    return variants.first.variantId;
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

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter an offer name');
      return;
    }
    if (_selectedProduct == null || _selectedProduct!.productId == null) {
      _showError('Please select a reward product');
      return;
    }
    final minAmount = double.tryParse(_minAmountController.text.trim());
    if (minAmount == null || minAmount < 0) {
      _showError('Please enter a valid minimum order amount');
      return;
    }
    if (_endDate.isBefore(_startDate)) {
      _showError('End date must be after start date');
      return;
    }

    final offer = ShopMoreGetMoreOffer(
      offerId: widget.offer?.offerId,
      name: _nameController.text.trim(),
      minimumOrderAmount: minAmount,
      freeProductId: _selectedProduct!.productId!,
      freeVariantId: _selectedVariantId,
      freeQuantity: int.tryParse(_freeQtyController.text.trim()) ?? 1,
      priority: int.tryParse(_priorityController.text.trim()) ?? 0,
      startDate: _startDate,
      endDate: _endDate,
      isActive: widget.offer?.isActive ?? true,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      final saved = await widget.onSave(offer);
      if (!mounted) return;
      if (saved) {
        Navigator.pop(context, true);
      } else {
        _showError(isEditing
            ? 'Error updating offer'
            : 'Error creating offer');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEditing ? 'Edit Offer' : 'New Offer',
            style: AdminTextStyles.sectionTitle(context).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Offer Name',
              border: OutlineInputBorder(),
            ),
            enabled: !_isSubmitting,
          ),
          SizedBox(height: 14.h),
          TextField(
            controller: _minAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minimum Order Amount (₹)',
              border: OutlineInputBorder(),
              helperText: 'Cart value must reach this amount',
            ),
            enabled: !_isSubmitting,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _freeQtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Free Quantity',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isSubmitting,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _priorityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    helperText: 'Higher = shown first',
                  ),
                  enabled: !_isSubmitting,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          InkWell(
            onTap: _isSubmitting ? null : _selectProduct,
            borderRadius: BorderRadius.circular(14.r),
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AdminThemeTokens.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AdminAppTheme.getBorderColor(context)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: AdminAppTheme.getSuccessColor(context)
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.redeem,
                      size: 18.r,
                      color: AdminAppTheme.getSuccessColor(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Reward Product',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AdminTextStyles.caption(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: AdminAppTheme.getTextSecondaryColor(context),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _selectedProduct?.productName ??
                              'Select the free product',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AdminTextStyles.cardTitle(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: _selectedProduct == null
                                ? AdminAppTheme.getTextSecondaryColor(context)
                                : AdminAppTheme.getTextPrimaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.chevron_right,
                    color: AdminAppTheme.getTextSecondaryColor(context),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedProduct != null && _productVariants(_selectedProduct!).length > 1) ...[
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedVariantId,
              decoration: const InputDecoration(
                labelText: 'Variant (optional)',
                border: OutlineInputBorder(),
              ),
              items: _productVariants(_selectedProduct!)
                  .map((v) => DropdownMenuItem(
                        value: v.variantId,
                        child: Text(_variantLabel(v)),
                      ))
                  .toList(),
              onChanged: _isSubmitting
                  ? null
                  : (v) => setState(() => _selectedVariantId = v),
            ),
          ],
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _DateCard(
                  label: 'Start Date',
                  value: _startDate,
                  onTap: () => _selectDate(true),
                  enabled: !_isSubmitting,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _DateCard(
                  label: 'End Date',
                  value: _endDate,
                  onTap: () => _selectDate(false),
                  enabled: !_isSubmitting,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _save,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Update Offer' : 'Create Offer'),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  final bool enabled;

  const _DateCard({
    required this.label,
    required this.value,
    required this.onTap,
    required this.enabled,
  });

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AdminThemeTokens.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AdminAppTheme.getBorderColor(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AdminAppTheme.getSuccessColor(context)
                    .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18.r,
                color: AdminAppTheme.getSuccessColor(context),
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
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _formatDate(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.cardTitle(context).copyWith(
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
}
