import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class SubcategorySelector extends StatefulWidget {
  /// All available subcategory options for the selected category.
  final List<SubcategoryOptionData> options;

  /// Currently selected subcategory names.
  final Set<String> selected;

  /// Validation error text shown below the selector.
  final String? errorText;

  /// Called when a chip is tapped — passes the name and new checked state.
  final void Function(String name, bool checked) onToggle;

  const SubcategorySelector({
    super.key,
    required this.options,
    required this.selected,
    required this.errorText,
    required this.onToggle,
  });

  @override
  State<SubcategorySelector> createState() => _SubcategorySelectorState();
}

class _SubcategorySelectorState extends State<SubcategorySelector> {
  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
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

    // Split options into two rows: even indices → row 0, odd → row 1
    final row0 = <SubcategoryOptionData>[];
    final row1 = <SubcategoryOptionData>[];
    for (var i = 0; i < widget.options.length; i++) {
      if (i.isEven) {
        row0.add(widget.options[i]);
      } else {
        row1.add(widget.options[i]);
      }
    }

    final double chipSize = (90.r).clamp(76.0, 104.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subcategories', style: AdminTextStyles.cardTitle(context)),
        SizedBox(height: 10.h),

        // 2-Row Horizontal Scrollable Area
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 0
              Row(
                children: row0.asMap().entries.map((entry) {
                  final i = entry.key;
                  final option = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i < row0.length - 1 ? 8.w : 0,
                    ),
                    child: _SubcategoryChip(
                      option: option,
                      isSelected: widget.selected.contains(option.name),
                      size: chipSize,
                      onTap: () => widget.onToggle(
                        option.name,
                        !widget.selected.contains(option.name),
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (row1.isNotEmpty) ...[
                SizedBox(height: 8.h),
                // Row 1
                Row(
                  children: row1.asMap().entries.map((entry) {
                    final i = entry.key;
                    final option = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: i < row1.length - 1 ? 8.w : 0,
                      ),
                      child: _SubcategoryChip(
                        option: option,
                        isSelected: widget.selected.contains(option.name),
                        size: chipSize,
                        onTap: () => widget.onToggle(
                          option.name,
                          !widget.selected.contains(option.name),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        if (widget.errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            widget.errorText!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AdminTextStyles.caption(context).copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({
    required this.option,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  final SubcategoryOptionData option;
  final bool isSelected;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor =
        isSelected ? cs.primary : Colors.grey.shade300;
    final bgColor =
        isSelected ? cs.primary.withValues(alpha: 0.08) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image area
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox.square(
                dimension: size * 0.65,
                child: option.imageUrl.isNotEmpty
                    ? Image.network(
                        option.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _PlaceholderIcon(
                          size: size * 0.65,
                          color: cs.onSurfaceVariant,
                        ),
                      )
                    : _PlaceholderIcon(
                        size: size * 0.65,
                        color: cs.onSurfaceVariant,
                      ),
              ),
            ),
            SizedBox(height: 2.h),
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                option.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (10.sp).clamp(8.0, 11.5),
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? cs.primary : cs.onSurface,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade100,
      child: Icon(
        Icons.image_outlined,
        size: size * 0.55,
        color: color.withValues(alpha: 0.5),
      ),
    );
  }
}
