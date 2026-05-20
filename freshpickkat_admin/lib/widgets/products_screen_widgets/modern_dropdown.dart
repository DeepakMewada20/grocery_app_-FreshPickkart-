import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';

class ModernDropdown<T> extends StatelessWidget {
  const ModernDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? labelText;
  final String? hintText;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AdminAppTheme.getInputSurfaceColor(context),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
      ),
    );
  }
}
