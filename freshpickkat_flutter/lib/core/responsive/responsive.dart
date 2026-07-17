import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  Responsive._();

  static const Size designSize = Size(390, 844);
  static const double maxTextScale = 1.30;
  static const double maxReadableWidth = 720;
  static const double maxCheckoutWidth = 680;
  static const double maxDetailWidth = 920;
  static const double webFrameWidth = 780;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.orientationOf(context);

  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.devicePixelRatioOf(context);

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;

  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 599;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 900;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  static bool isSmallPhone(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width < 360 || size.height < 640;
  }

  static bool isWideWeb(BuildContext context) =>
      kIsWeb && MediaQuery.sizeOf(context).width >= 600;

  static double safeWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final padding = MediaQuery.paddingOf(context);
    return w - padding.left - padding.right;
  }

  static double safeHeight(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final padding = MediaQuery.paddingOf(context);
    return h - padding.top - padding.bottom;
  }

  static TextScaler clampedTextScaler(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final factor = scaler.scale(1).clamp(1.0, maxTextScale).toDouble();
    return TextScaler.linear(factor);
  }

  static double scale(BuildContext context) {
    return MediaQuery.sizeOf(context).width / designSize.width;
  }

  static double fontScale(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    return scaler.scale(1).clamp(1.0, maxTextScale).toDouble();
  }

  static double pageHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1000) return 28.w;
    if (width >= 600) return 22.w;
    return 16.w;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: pageHorizontalPadding(context),
      vertical: 12.h,
    );
  }

  static double railWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (kIsWeb && width >= 700) return 150.0;
    if (width < 360) return 76.w;
    if (width >= 900) return 112.w;
    if (isLandscape(context)) return 92.w;
    return 88.w;
  }

  static double bannerHeight(
    BuildContext context, {
    double ratio = 0.42,
    double min = 112,
    double max = 190,
    double? availableWidth,
  }) {
    final w = availableWidth ?? MediaQuery.sizeOf(context).width;
    if (kIsWeb && w >= 600) return w * ratio;
    final landscapeMax = isLandscape(context) ? math.min(max, 150) : max;
    final tabletMax = isTablet(context) ? math.max(landscapeMax, 170) : landscapeMax;
    return (w * ratio).clamp(min.h, tabletMax.h).toDouble();
  }

  static int gridColumns(BuildContext context, {bool dense = false}) {
    final width = MediaQuery.sizeOf(context).width;
    return productGridColumnsForWidth(width, dense: dense);
  }

  static int productGridColumnsForWidth(double width, {bool dense = false}) {
    if (kIsWeb && width >= 700) return dense ? 4 : 3;
    if (width < 520) return 2;
    if (width < 760) return dense ? 4 : 3;
    if (width < 1040) return dense ? 5 : 4;
    return dense ? 6 : 5;
  }

  static double productCardAspectRatioForWidth(double width, int columns,
      {double spacing = 12}) {
    final tileWidth = (width - spacing * (columns - 1)) / columns;
    if (kIsWeb && width >= 700) return 0.58;
    if (tileWidth < 145) return 0.46;
    if (tileWidth < 170) return 0.50;
    if (tileWidth < 205) return 0.56;
    if (tileWidth < 250) return 0.62;
    return 0.68;
  }

  static SliverGridDelegateWithFixedCrossAxisCount productGridDelegate(
    BuildContext context,
    double width, {
    bool dense = false,
    double spacing = 12,
  }) {
    final columns = productGridColumnsForWidth(width, dense: dense);
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing.w,
      mainAxisSpacing: spacing.h,
      childAspectRatio:
          productCardAspectRatioForWidth(width, columns, spacing: spacing.w),
    );
  }

  static int categoryGridColumnsForWidth(double width) {
    if (kIsWeb && width >= 560) return 3;
    if (width < 300) return 2;
    if (width < 560) return 3;
    if (width < 820) return 4;
    if (width < 1100) return 5;
    return 6;
  }

  static SliverGridDelegateWithFixedCrossAxisCount categoryGridDelegate(
    BuildContext context,
    double width, {
    double spacing = 12,
  }) {
    final columns = categoryGridColumnsForWidth(width);
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing.w,
      mainAxisSpacing: spacing.h,
      childAspectRatio: kIsWeb && width >= 560
          ? 0.92
          : isLandscape(context)
              ? 0.86
              : 0.78,
    );
  }

  static double horizontalCardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (kIsWeb && width >= 700) return 232.0;
    if (width >= 900) return 210.w;
    if (width >= 600) return 184.w;
    return 156.w;
  }

  static double horizontalProductListHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = horizontalCardWidth(context);
    if (kIsWeb && width >= 700) return 380.0;
    return (cardWidth / 0.52).clamp(250.h, 340.h).toDouble();
  }

  static BoxConstraints sheetConstraints(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxHeight = size.height * (isLandscape(context) ? 0.92 : 0.88);
    final maxWidth = isTablet(context) ? 720.0 : size.width;
    return BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth);
  }

  static Widget constrainContent({
    required BuildContext context,
    required Widget child,
    double maxWidth = maxReadableWidth,
  }) {
    if (!isTablet(context)) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }

  static double topSafeArea(BuildContext context) =>
      MediaQuery.paddingOf(context).top;

  static double bottomSafeArea(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  static bool isKeyboardVisible(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom > 0;
}
