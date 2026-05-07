import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminResponsive {
  static const Size designSize = Size(390, 844);
  static const double maxTextScale = 1.25;
  static const double maxContentWidth = 1180;
  static const double maxFormWidth = 820;
  static const double maxDialogWidth = 720;

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isSmallPhone(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width < 360 || size.height < 640;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  static bool isDesktopLike(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1000;
  }

  static TextScaler clampedTextScaler(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final factor = scaler.scale(1).clamp(1.0, maxTextScale).toDouble();
    return TextScaler.linear(factor);
  }

  static double pageHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 28.w;
    if (width >= 700) return 22.w;
    return 14.w;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: pageHorizontalPadding(context),
      vertical: isSmallPhone(context) ? 10.h : 14.h,
    );
  }

  static EdgeInsets cardPadding(BuildContext context) {
    if (isSmallPhone(context)) return EdgeInsets.all(12.r);
    if (isTablet(context)) return EdgeInsets.all(18.r);
    return EdgeInsets.all(14.r);
  }

  static double bottomInset(BuildContext context) {
    return math.max(MediaQuery.viewPaddingOf(context).bottom, 12.h);
  }

  static int gridColumns(
    double width, {
    int minColumns = 1,
    double minTileWidth = 210,
    int maxColumns = 4,
  }) {
    final columns = (width / minTileWidth).floor().clamp(
      minColumns,
      maxColumns,
    );
    return columns;
  }

  static int statColumnsForWidth(double width) {
    if (width < 520) return 2;
    if (width < 860) return 3;
    return 4;
  }

  static int productListColumnsForWidth(double width) {
    if (width < 680) return 1;
    if (width < 1080) return 2;
    return 3;
  }

  static double mapBottomCardMaxHeight(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    if (isLandscape(context)) return height * 0.52;
    return height * 0.40;
  }

  static BoxConstraints dialogConstraints(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BoxConstraints(
      maxWidth: math.min(maxDialogWidth, size.width - 24.w),
      maxHeight: size.height * (isLandscape(context) ? 0.92 : 0.88),
    );
  }

  static BoxConstraints bottomSheetConstraints(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BoxConstraints(
      maxWidth: isTablet(context) ? maxDialogWidth : size.width,
      maxHeight: size.height * (isLandscape(context) ? 0.94 : 0.9),
    );
  }

  static Widget constrainContent({
    required BuildContext context,
    required Widget child,
    double maxWidth = maxContentWidth,
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

class AdminSpacing {
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;

  static EdgeInsets all(double value) => EdgeInsets.all(value.r);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);
  }
}
