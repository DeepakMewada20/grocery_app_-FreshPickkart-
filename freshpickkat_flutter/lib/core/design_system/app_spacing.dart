import 'package:flutter/material.dart';
import 'screen_scale.dart';

class AppSpacing {
  AppSpacing._();

  static double get xxs => ScreenScale.w(4);
  static double get xs => ScreenScale.w(6);
  static double get sm => ScreenScale.w(8);
  static double get md => ScreenScale.w(12);
  static double get lg => ScreenScale.w(16);
  static double get xl => ScreenScale.w(20);
  static double get xxl => ScreenScale.w(24);
  static double get xxxl => ScreenScale.w(32);

  static EdgeInsets all(double value) => EdgeInsets.all(ScreenScale.w(value));

  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: ScreenScale.w(horizontal),
      vertical: ScreenScale.h(vertical),
    );
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: ScreenScale.w(left),
      top: ScreenScale.h(top),
      right: ScreenScale.w(right),
      bottom: ScreenScale.h(bottom),
    );
  }

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(value));

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: ScreenScale.h(value));

  static SizedBox width(double value) =>
      SizedBox(width: ScreenScale.w(value));
  static SizedBox height(double value) =>
      SizedBox(height: ScreenScale.h(value));

  static EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: ScreenScale.w(16),
        vertical: ScreenScale.h(12),
      );

  static EdgeInsets get cardPadding => EdgeInsets.all(ScreenScale.w(12));

  static EdgeInsets get listSpacing =>
      EdgeInsets.symmetric(vertical: ScreenScale.h(8));

  static EdgeInsets get sectionSpacing =>
      EdgeInsets.symmetric(vertical: ScreenScale.h(16));

  static EdgeInsets get gridGap => EdgeInsets.all(ScreenScale.w(12));

  static EdgeInsets get itemGap => EdgeInsets.all(ScreenScale.w(8));

  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(24), vertical: ScreenScale.h(14));

  static EdgeInsets get inputPadding =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(16), vertical: ScreenScale.h(12));

  static EdgeInsets get badgePadding =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(6), vertical: ScreenScale.h(2));

  static EdgeInsets get chipPadding =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(10), vertical: ScreenScale.h(4));

  static EdgeInsets get sectionPadding =>
      EdgeInsets.symmetric(horizontal: ScreenScale.w(16), vertical: ScreenScale.h(20));

  static SizedBox get sectionSpacer => SizedBox(height: ScreenScale.h(16));
  static SizedBox get itemSpacer => SizedBox(height: ScreenScale.h(8));
  static SizedBox get smallSpacer => SizedBox(height: ScreenScale.h(4));
  static SizedBox get largeSpacer => SizedBox(height: ScreenScale.h(24));
  static SizedBox get horizontalItemSpacer => SizedBox(width: ScreenScale.w(8));
  static SizedBox get horizontalSmallSpacer => SizedBox(width: ScreenScale.w(4));

  static EdgeInsets responsivePagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1000
        ? ScreenScale.w(28)
        : width >= 600
            ? ScreenScale.w(22)
            : ScreenScale.w(16);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: ScreenScale.h(12));
  }
}
