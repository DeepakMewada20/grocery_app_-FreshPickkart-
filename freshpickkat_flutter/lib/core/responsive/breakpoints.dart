import 'package:flutter/material.dart';

enum DeviceSize { phone, tablet, desktop, largeDesktop }

class Breakpoints {
  Breakpoints._();

  static const double phoneMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 899;
  static const double desktopMin = 900;
  static const double desktopMax = 1199;
  static const double largeDesktopMin = 1200;

  static bool isPhone(double width) => width <= phoneMax;
  static bool isTablet(double width) => width >= tabletMin && width <= tabletMax;
  static bool isDesktop(double width) => width >= desktopMin && width <= desktopMax;
  static bool isLargeDesktop(double width) => width >= largeDesktopMin;

  static DeviceSize current(double width) {
    if (isPhone(width)) return DeviceSize.phone;
    if (isTablet(width)) return DeviceSize.tablet;
    if (isDesktop(width)) return DeviceSize.desktop;
    return DeviceSize.largeDesktop;
  }

  static DeviceSize fromContext(BuildContext context) {
    return current(MediaQuery.sizeOf(context).width);
  }
}
