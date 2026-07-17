import 'package:flutter/material.dart';

import '../core/responsive/responsive.dart' as new_system;
@Deprecated('Use Responsive from core/responsive/responsive.dart instead')
class AppResponsive {
  static const Size designSize = new_system.Responsive.designSize;
  static const double maxTextScale = new_system.Responsive.maxTextScale;
  static const double maxReadableWidth = new_system.Responsive.maxReadableWidth;
  static const double maxCheckoutWidth = new_system.Responsive.maxCheckoutWidth;
  static const double maxDetailWidth = new_system.Responsive.maxDetailWidth;
  static const double webFrameWidth = new_system.Responsive.webFrameWidth;

  static double layoutWidth(BuildContext context) =>
      new_system.Responsive.width(context);

  static bool isLandscape(BuildContext context) =>
      new_system.Responsive.isLandscape(context);

  static bool isTablet(BuildContext context) =>
      new_system.Responsive.isTablet(context);

  static bool isSmallPhone(BuildContext context) =>
      new_system.Responsive.isSmallPhone(context);

  static bool isWideWeb(BuildContext context) =>
      new_system.Responsive.isWideWeb(context);

  static TextScaler clampedTextScaler(BuildContext context) =>
      new_system.Responsive.clampedTextScaler(context);

  static double pageHorizontalPadding(BuildContext context) =>
      new_system.Responsive.pageHorizontalPadding(context);

  static EdgeInsets pagePadding(BuildContext context) =>
      new_system.Responsive.pagePadding(context);

  static double railWidth(BuildContext context) =>
      new_system.Responsive.railWidth(context);

  static double bannerHeight(
    BuildContext context, {
    double ratio = 0.42,
    double min = 112,
    double max = 190,
    double? availableWidth,
  }) =>
      new_system.Responsive.bannerHeight(context,
          ratio: ratio, min: min, max: max, availableWidth: availableWidth);

  static int productGridColumnsForWidth(double width, {bool dense = false}) =>
      new_system.Responsive.productGridColumnsForWidth(width, dense: dense);

  static double productCardAspectRatioForWidth(
    double width,
    int columns, {
    double spacing = 12,
  }) =>
      new_system.Responsive.productCardAspectRatioForWidth(
        width,
        columns,
        spacing: spacing,
      );

  static SliverGridDelegateWithFixedCrossAxisCount productGridDelegate(
    BuildContext context,
    double width, {
    bool dense = false,
    double spacing = 12,
  }) =>
      new_system.Responsive.productGridDelegate(context, width,
          dense: dense, spacing: spacing);

  static int categoryGridColumnsForWidth(double width) =>
      new_system.Responsive.categoryGridColumnsForWidth(width);

  static SliverGridDelegateWithFixedCrossAxisCount categoryGridDelegate(
    BuildContext context,
    double width, {
    double spacing = 12,
  }) =>
      new_system.Responsive.categoryGridDelegate(context, width,
          spacing: spacing);

  static double horizontalCardWidth(BuildContext context) =>
      new_system.Responsive.horizontalCardWidth(context);

  static double horizontalProductListHeight(BuildContext context) =>
      new_system.Responsive.horizontalProductListHeight(context);

  static BoxConstraints sheetConstraints(BuildContext context) =>
      new_system.Responsive.sheetConstraints(context);

  static Widget constrainContent({
    required BuildContext context,
    required Widget child,
    double maxWidth = maxReadableWidth,
  }) =>
      new_system.Responsive.constrainContent(
        context: context,
        child: child,
        maxWidth: maxWidth,
      );
}

