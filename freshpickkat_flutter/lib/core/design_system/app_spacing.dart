import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  static double get xxs => 4.w;
  static double get xs => 6.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;

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

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    );
  }

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value.w);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value.h);

  static SizedBox width(double value) => SizedBox(width: value.w);
  static SizedBox height(double value) => SizedBox(height: value.h);

  static EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      );

  static EdgeInsets get cardPadding => EdgeInsets.all(12.w);

  static EdgeInsets get listSpacing => EdgeInsets.symmetric(vertical: 8.h);

  static EdgeInsets get sectionSpacing => EdgeInsets.symmetric(vertical: 16.h);

  static EdgeInsets get gridGap => EdgeInsets.all(12.w);

  static EdgeInsets get itemGap => EdgeInsets.all(8.w);

  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h);

  static EdgeInsets get inputPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  static EdgeInsets get badgePadding =>
      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h);

  static EdgeInsets get chipPadding =>
      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);

  static EdgeInsets get sectionPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h);

  static SizedBox get sectionSpacer => SizedBox(height: 16.h);
  static SizedBox get itemSpacer => SizedBox(height: 8.h);
  static SizedBox get smallSpacer => SizedBox(height: 4.h);
  static SizedBox get largeSpacer => SizedBox(height: 24.h);
  static SizedBox get horizontalItemSpacer => SizedBox(width: 8.w);
  static SizedBox get horizontalSmallSpacer => SizedBox(width: 4.w);

  static EdgeInsets responsivePagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1000
        ? 28.w
        : width >= 600
            ? 22.w
            : 16.w;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 12.h);
  }
}
