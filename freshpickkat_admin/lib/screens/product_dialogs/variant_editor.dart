import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/products_screen_widgets/widgets.dart';
import 'variant_draft.dart';

class VariantListEditor extends StatelessWidget {
  final List<VariantDraft> variants;
  final VoidCallback onAddVariant;
  final ValueChanged<VariantDraft> onRemoveVariant;
  final VoidCallback onChanged;
  final double baseRealPrice;
  final double baseQuantity;
  final String baseUnit;

  const VariantListEditor({
    super.key,
    required this.variants,
    required this.onAddVariant,
    required this.onRemoveVariant,
    required this.onChanged,
    required this.baseRealPrice,
    required this.baseQuantity,
    required this.baseUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary pack uses the main quantity and pricing fields above. Add more packs here.',
          style: AdminTextStyles.caption(context),
        ),
        SizedBox(height: 12.h),
        if (variants.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AdminAppTheme.getInputSurfaceColor(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AdminAppTheme.getBorderColor(context)),
            ),
            child: Text(
              'No additional variants added yet.',
              style: AdminTextStyles.body(context),
            ),
          )
        else
          Column(
            children: variants.map((draft) {
              return VariantItemEditor(
                key: ValueKey(draft.variantId),
                draft: draft,
                onRemove: () => onRemoveVariant(draft),
                onChanged: onChanged,
              );
            }).toList(),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: onAddVariant,
            icon: const Icon(Icons.add),
            label: const Text('Add Variant'),
          ),
        ),
      ],
    );
  }
}

class VariantItemEditor extends StatefulWidget {
  final VariantDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const VariantItemEditor({
    super.key,
    required this.draft,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<VariantItemEditor> createState() => _VariantItemEditorState();
}

class _VariantItemEditorState extends State<VariantItemEditor> {
  late String _unit;

  static const List<String> _units = ['gm', 'kg', 'litre', 'ml', 'pc', 'pack'];

  static const Map<String, double> _unitConversions = {
    'gm': 1.0,
    'kg': 1000.0,
    'litre': 1000.0,
    'ml': 1.0,
    'pc': 1.0,
    'pack': 1.0,
  };

  @override
  void initState() {
    super.initState();
    _unit = widget.draft.quantityUnit;
  }

  void _recalculatePrices() {
    final newQty =
        double.tryParse(widget.draft.quantityValueCtrl.text.trim()) ?? 0;
    if (newQty <= 0 ||
        (widget.draft.baseRealPrice <= 0 && widget.draft.basePrice <= 0)) {
      return;
    }

    final originalInBase =
        widget.draft.baseQuantity *
        (_unitConversions[widget.draft.baseUnit] ?? 1.0);
    final newInBase = newQty * (_unitConversions[_unit] ?? 1.0);

    if (originalInBase <= 0) return;

    final ratio = newInBase / originalInBase;

    if (widget.draft.baseRealPrice > 0) {
      final newMrp = widget.draft.baseRealPrice * ratio;
      widget.draft.mrpCtrl.text = newMrp.toStringAsFixed(0);
    }

    if (widget.draft.basePrice > 0) {
      final newPrice = widget.draft.basePrice * ratio;
      widget.draft.priceCtrl.text = newPrice.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.draft.priceCtrl.text) ?? 0;
    final mrp = double.tryParse(widget.draft.mrpCtrl.text) ?? 0;
    final hasDiscount = price > 0 && mrp > 0 && price < mrp;
    final discount = mrp - price;
    final discountPercent = hasDiscount ? (discount / mrp * 100) : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: AdminThemeTokens.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AdminAppTheme.getBorderColor(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Variant',
                  style: AdminTextStyles.cardTitle(context),
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: widget.draft.quantityValueCtrl,
                labelText: 'Quantity',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) {
                  _recalculatePrices();
                  widget.onChanged();
                },
              ),
              SizedBox(
                width: 104.w.clamp(92.0, 118.0).toDouble(),
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _unit = value);
                      widget.draft.quantityUnit = value;
                      _recalculatePrices();
                      widget.onChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ModernTextField(
            controller: widget.draft.quantityDescriptionCtrl,
            labelText: 'Quantity Description (Optional)',
            hintText: 'e.g., 10-12 pieces',
            onChanged: (_) => widget.onChanged(),
          ),
          SizedBox(height: 12.h),
          CompactFieldRow(
            children: [
              ModernTextField(
                controller: widget.draft.priceCtrl,
                labelText: 'Selling Price',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => widget.onChanged(),
              ),
              ModernTextField(
                controller: widget.draft.mrpCtrl,
                labelText: 'MRP',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => widget.onChanged(),
              ),
            ],
          ),
          if (hasDiscount) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AdminAppTheme.getSuccessContainerColor(context),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AdminAppTheme.getSuccessColor(context),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    size: 14.r,
                    color: AdminAppTheme.getSuccessColor(context),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      '${discountPercent.toStringAsFixed(0)}% off (₹${discount.toStringAsFixed(0)})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.caption(context).copyWith(
                        color: AdminAppTheme.getSuccessColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12.h),
          SwitchListTile(
            value: widget.draft.isAvailable,
            onChanged: (value) {
              widget.draft.isAvailable = value;
              widget.onChanged();
            },
            title: const Text('Available'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
