import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle screenTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle productTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 12.sp.clamp(11.0, 14.0),
      fontWeight: FontWeight.w600,
      height: 1.15,
    );
  }

  static TextStyle productQuantity(BuildContext context) {
    return GoogleFonts.inter(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      fontSize: 10.sp.clamp(9.0, 12.0),
      height: 1.15,
    );
  }

  static TextStyle productPrice(BuildContext context) {
    return GoogleFonts.inter(
      color: const Color(0xFF4CAF50),
      fontSize: 14.sp.clamp(12.0, 16.0),
      fontWeight: FontWeight.w800,
      height: 1.1,
    );
  }

  static TextStyle productMrp(BuildContext context) {
    return GoogleFonts.inter(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
      fontSize: 10.sp.clamp(9.0, 12.0),
      decoration: TextDecoration.lineThrough,
      decorationColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.35),
    );
  }

  static TextStyle body(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 14.sp,
      height: 1.35,
    );
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
      fontSize: 12.sp,
      height: 1.25,
    );
  }

  static TextStyle button(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 13.sp.clamp(11.0, 15.0),
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle receiptLabel(BuildContext context, {bool total = false}) {
    return TextStyle(
      color: total
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
      fontSize: total ? 16.sp : 14.sp,
      fontWeight: total ? FontWeight.w700 : FontWeight.w400,
      height: 1.25,
    );
  }

  static TextStyle receiptValue(
    BuildContext context, {
    bool total = false,
    Color? color,
  }) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: total ? 17.sp : 14.sp,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );
  }
}
