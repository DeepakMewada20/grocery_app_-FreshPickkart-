import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showShopMoreGetMoreDialog({
  required BuildContext context,
  ShopMoreGetMoreOffer? offer,
  required Future<bool> Function(ShopMoreGetMoreOffer offer) onSave,
}) {
  return showModalBottomSheet<bool>(
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
      child: ShopMoreGetMoreDialog(
        offer: offer,
        onSave: onSave,
      ),
    ),
  );
}

class ShopMoreGetMoreDialog extends StatefulWidget {
  final ShopMoreGetMoreOffer? offer;
  final Future<bool> Function(ShopMoreGetMoreOffer offer) onSave;

  const ShopMoreGetMoreDialog({super.key, this.offer, required this.onSave});

  @override
  State<ShopMoreGetMoreDialog> createState() => _ShopMoreGetMoreDialogState();
}

class _ShopMoreGetMoreDialogState extends State<ShopMoreGetMoreDialog> {
  final _minAmountController = TextEditingController();
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

  String _buildOfferName() {
    final minAmount = double.tryParse(_minAmountController.text.trim());
    final minLabel = minAmount != null && minAmount > 0
        ? '₹${minAmount.toStringAsFixed(0)}+'
        : '';
    if (_selectedProduct == null) {
      return minLabel.isNotEmpty ? 'Shop $minLabel, Get ...' : 'Shop More, Get More';
    }
    final name = _selectedProduct!.productName.trim();
    final qty = _selectedProduct!.quantity.trim();
    final qtyLabel = qty.isNotEmpty ? ' $qty' : '';
    final minPart = minLabel.isNotEmpty ? 'Shop $minLabel, ' : '';
    return '${minPart}Get $name$qtyLabel FREE';
  }

  @override
  void initState() {
    super.initState();
    final offer = widget.offer;
    if (offer != null) {
      _minAmountController.text = offer.minimumOrderAmount.toStringAsFixed(0);
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
      _priorityController.text = '0';
    }
    _minAmountController.addListener(_onFieldChanged);
    _priorityController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  @override
  void dispose() {
    _minAmountController.dispose();
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
      name: _buildOfferName(),
      minimumOrderAmount: minAmount,
      freeProductId: _selectedProduct!.productId!,
      freeVariantId: _selectedVariantId,
      freeQuantity: 1,
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
        _showError(isEditing ? 'Error updating offer' : 'Error creating offer');
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AdminAppTheme.getSuccessContainerColor(context),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AdminAppTheme.getSuccessColor(context).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Name',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AdminAppTheme.getSuccessColor(context),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _buildOfferName(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getSubtleSurfaceColor(context),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AdminAppTheme.getBorderColor(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Free Quantity',
                        style: AdminTextStyles.caption(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: AdminAppTheme.getTextSecondaryColor(context),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '1',
                        style: AdminTextStyles.cardTitle(context).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
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
          if (_selectedProduct != null &&
              _productVariants(_selectedProduct!).length > 1) ...[
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
