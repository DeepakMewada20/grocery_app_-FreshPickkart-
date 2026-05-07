import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

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
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'No subcategories found for selected category',
          style: AdminTextStyles.body(
            context,
          ).copyWith(color: Colors.redAccent),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Subcategories',
            style: AdminTextStyles.cardTitle(context),
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((bunch) {
            final isBunchSelected = bunch.every(
              (item) => selected.contains(item),
            );

            return FilterChip(
              label: Text(
                bunch.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: isBunchSelected,
              onSelected: (checked) => onToggleBunch(bunch, checked),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AdminTextStyles.caption(context).copyWith(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
