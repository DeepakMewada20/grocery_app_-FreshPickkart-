import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppResponsive {
  static const Size designSize = Size(390, 844);
  static const double maxTextScale = 1.30;
  static const double maxReadableWidth = 720;
  static const double maxCheckoutWidth = 680;
  static const double maxDetailWidth = 920;
  static const double webFrameWidth = 780;

  static double layoutWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  static bool isSmallPhone(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width < 360 || size.height < 640;
  }

  static bool isWideWeb(BuildContext context) {
    return kIsWeb && MediaQuery.sizeOf(context).width >= 600;
  }

  static TextScaler clampedTextScaler(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final factor = scaler.scale(1).clamp(1.0, maxTextScale).toDouble();
    return TextScaler.linear(factor);
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
    final width = availableWidth ?? MediaQuery.sizeOf(context).width;
    if (kIsWeb && width >= 600) return width * ratio;
    final landscapeMax = isLandscape(context) ? math.min(max, 150) : max;
    final tabletMax = isTablet(context)
        ? math.max(landscapeMax, 170)
        : landscapeMax;
    return (width * ratio).clamp(min.h, tabletMax.h).toDouble();
  }

  static int productGridColumnsForWidth(
    double width, {
    bool dense = false,
  }) {
    if (kIsWeb && width >= 700) return dense ? 4 : 3;
    if (width < 520) return 2;
    if (width < 760) return dense ? 4 : 3;
    if (width < 1040) return dense ? 5 : 4;
    return dense ? 6 : 5;
  }

  static double productCardAspectRatioForWidth(
    double width,
    int columns, {
    double spacing = 12,
  }) {
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
      childAspectRatio: productCardAspectRatioForWidth(
        width,
        columns,
        spacing: spacing.w,
      ),
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
    return BoxConstraints(
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
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
}

class AppSpacing {
  static double get xxs => 4.w;
  static double get xs => 6.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    );
  }
}
