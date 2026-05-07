import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTextStyles {
  static TextStyle screenTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 22.sp.clamp(18.0, 26.0),
      fontWeight: FontWeight.w800,
      height: 1.15,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 17.sp.clamp(15.0, 20.0),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 14.sp.clamp(12.0, 16.0),
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle statValue(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 22.sp.clamp(18.0, 26.0),
      fontWeight: FontWeight.w800,
      height: 1.05,
    );
  }

  static TextStyle body(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 14.sp.clamp(12.0, 16.0),
      height: 1.35,
    );
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
      fontSize: 12.sp.clamp(10.0, 13.0),
      height: 1.25,
    );
  }

  static TextStyle button(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 13.sp.clamp(11.0, 15.0),
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
  }
}
