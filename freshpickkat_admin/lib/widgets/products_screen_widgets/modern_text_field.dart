import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';

class ModernTextField extends StatelessWidget {
  const ModernTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixText,
    this.suffixText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final String? suffixText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        suffixText: suffixText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20.sp) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AdminAppTheme.getInputSurfaceColor(context),
        contentPadding: EdgeInsets.fromLTRB(
          12.w,
          16.h.clamp(12.0, 20.0),
          12.w,
          12.h.clamp(10.0, 16.0),
        ),
      ),
    );
  }
}
