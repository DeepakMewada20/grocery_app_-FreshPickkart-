import 'package:flutter/material.dart';

import '../core/design_system/app_text.dart' as new_system;

@Deprecated('Use AppText from core/design_system/app_text.dart instead')
class AppTextStyles {
  static TextStyle screenTitle(BuildContext context) {
    return new_system.AppText.screenTitle(context);
  }

  static TextStyle sectionTitle(BuildContext context) {
    return new_system.AppText.sectionTitle(context);
  }

  static TextStyle productTitle(BuildContext context) {
    return new_system.AppText.productTitle(context);
  }

  static TextStyle productQuantity(BuildContext context) {
    return new_system.AppText.productQuantity(context);
  }

  static TextStyle productPrice(BuildContext context) {
    return new_system.AppText.productPrice(context);
  }

  static TextStyle productMrp(BuildContext context) {
    return new_system.AppText.productMrp(context);
  }

  static TextStyle body(BuildContext context) {
    return new_system.AppText.bodyMedium(context);
  }

  static TextStyle caption(BuildContext context) {
    return new_system.AppText.caption(context);
  }

  static TextStyle button(BuildContext context) {
    return new_system.AppText.button(context);
  }

  static TextStyle receiptLabel(BuildContext context, {bool total = false}) {
    return new_system.AppText.bodyMedium(context).copyWith(
      fontWeight: total ? FontWeight.w700 : FontWeight.w400,
    );
  }

  static TextStyle receiptValue(
    BuildContext context, {
    bool total = false,
    Color? color,
  }) {
    return new_system.AppText.bodyLarge(context).copyWith(
      fontWeight: FontWeight.w800,
      color: color,
    );
  }
}
