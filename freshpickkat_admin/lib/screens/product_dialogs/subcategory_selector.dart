import 'package:flutter/material.dart';

class SubcategorySelector extends StatelessWidget {
  final List<List<String>> options;
  final Set<String> selected;
  final String? errorText;
  final void Function(List<String> bunch, bool checked) onToggleBunch;

  const SubcategorySelector({
    super.key,
    required this.options,
    required this.selected,
    required this.errorText,
    required this.onToggleBunch,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'No subcategories found for selected category',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Subcategories',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((bunch) {
            final isBunchSelected = bunch.every(
              (item) => selected.contains(item),
            );

            return FilterChip(
              label: Text(bunch.join(', ')),
              selected: isBunchSelected,
              onSelected: (checked) => onToggleBunch(bunch, checked),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
