import 'package:flutter/material.dart';
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
        const Text(
          'Primary pack uses the main quantity and pricing fields above. Add more packs here.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        if (variants.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text('No additional variants added yet.'),
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

  void _recalculateMrp() {
    final newQty =
        double.tryParse(widget.draft.quantityValueCtrl.text.trim()) ?? 0;
    if (newQty <= 0 || widget.draft.baseRealPrice <= 0) return;

    final originalInBase =
        widget.draft.baseQuantity *
        (_unitConversions[widget.draft.baseUnit] ?? 1.0);
    final newInBase = newQty * (_unitConversions[_unit] ?? 1.0);

    if (originalInBase <= 0) return;

    final ratio = newInBase / originalInBase;
    final newMrp = widget.draft.baseRealPrice * ratio;
    widget.draft.mrpCtrl.text = newMrp.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.draft.priceCtrl.text) ?? 0;
    final mrp = double.tryParse(widget.draft.mrpCtrl.text) ?? 0;
    final hasDiscount = price > 0 && mrp > 0 && price < mrp;
    final discount = mrp - price;
    final discountPercent = hasDiscount ? (discount / mrp * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Variant',
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                  _recalculateMrp();
                  widget.onChanged();
                },
              ),
              SizedBox(
                width: 100,
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
                      _recalculateMrp();
                      widget.onChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ModernTextField(
            controller: widget.draft.quantityDescriptionCtrl,
            labelText: 'Quantity Description (Optional)',
            hintText: 'e.g., 10-12 pieces',
            onChanged: (_) => widget.onChanged(),
          ),
          const SizedBox(height: 12),
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
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${discountPercent.toStringAsFixed(0)}% off (₹${discount.toStringAsFixed(0)})',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
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
