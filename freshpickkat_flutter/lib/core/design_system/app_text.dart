import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen_scale.dart';

class AppText {
  AppText._();

  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(28),
      fontWeight: FontWeight.w700,
      height: 1.15,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(24),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(22),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(20),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(18),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(16),
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(14),
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(13),
      fontWeight: FontWeight.w600,
      height: 1.15,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(16),
      height: 1.35,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(14),
      height: 1.35,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
      fontSize: ScreenScale.sp(12),
      height: 1.25,
    );
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      fontSize: ScreenScale.sp(11),
      height: 1.2,
    );
  }

  static TextStyle button(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: ScreenScale.sp(13),
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle label(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      fontSize: ScreenScale.sp(10),
      height: 1.15,
    );
  }

  static TextStyle productTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: ScreenScale.sp(12).clamp(11.0, 14.0),
      fontWeight: FontWeight.w600,
      height: 1.15,
    );
  }

  static TextStyle productQuantity(BuildContext context) {
    return GoogleFonts.inter(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      fontSize: ScreenScale.sp(10).clamp(9.0, 12.0),
      height: 1.15,
    );
  }

  static TextStyle productPrice(BuildContext context) {
    return GoogleFonts.inter(
      color: const Color(0xFF4CAF50),
      fontSize: ScreenScale.sp(14).clamp(12.0, 16.0),
      fontWeight: FontWeight.w800,
      height: 1.1,
    );
  }

  static TextStyle productMrp(BuildContext context) {
    return GoogleFonts.inter(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
      fontSize: ScreenScale.sp(10).clamp(9.0, 12.0),
      decoration: TextDecoration.lineThrough,
      decorationColor:
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
    );
  }

  static TextStyle screenTitle(BuildContext context) {
    return headlineMedium(context);
  }

  static TextStyle sectionTitle(BuildContext context) {
    return headlineSmall(context);
  }

  static TextStyle receiptLabel(BuildContext context, {bool total = false}) {
    return bodyMedium(context).copyWith(
      fontWeight: total ? FontWeight.w700 : FontWeight.w400,
    );
  }

  static TextStyle receiptValue(
    BuildContext context, {
    bool total = false,
    Color? color,
  }) {
    return bodyLarge(context).copyWith(
      fontWeight: FontWeight.w800,
      color: color,
    );
  }
}
