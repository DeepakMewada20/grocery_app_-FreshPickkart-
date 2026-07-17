import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenScale {
  ScreenScale._();

  static const double designWidth = 390;
  static const double designHeight = 844;
  static const double maxScaleWidth = 480;
  static const double maxScaleHeight = 900;

  static double w(double value) {
    final sw = ScreenUtil().screenWidth;
    final effective = sw > maxScaleWidth ? maxScaleWidth.toDouble() : sw;
    return value * (effective / designWidth);
  }

  static double h(double value) {
    final sh = ScreenUtil().screenHeight;
    final effective = sh > maxScaleHeight ? maxScaleHeight.toDouble() : sh;
    return value * (effective / designHeight);
  }

  static double r(double value) {
    return w(value);
  }

  static double sp(double value) {
    return w(value);
  }
}
