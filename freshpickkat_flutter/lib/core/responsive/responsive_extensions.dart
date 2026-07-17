import 'package:flutter/material.dart';
import '../design_system/app_spacing.dart';
import '../responsive/responsive.dart';
import 'breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isPhone => screenWidth <= Breakpoints.phoneMax;
  bool get isTablet =>
      screenWidth >= Breakpoints.tabletMin &&
      screenWidth <= Breakpoints.tabletMax;
  bool get isDesktop => screenWidth >= Breakpoints.desktopMin;
  bool get isLargeDesktop => screenWidth >= Breakpoints.largeDesktopMin;

  Orientation get orientation => MediaQuery.orientationOf(this);
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  double get safeWidth => Responsive.safeWidth(this);
  double get safeHeight => Responsive.safeHeight(this);

  double get topSafeArea => MediaQuery.paddingOf(this).top;
  double get bottomSafeArea => MediaQuery.paddingOf(this).bottom;

  DeviceSize get breakpoint => Breakpoints.fromContext(this);

  int get gridColumns => Responsive.gridColumns(this);

  double get scale => Responsive.scale(this);
  double get fontScale => Responsive.fontScale(this);

  EdgeInsets get pagePadding => AppSpacing.responsivePagePadding(this);
  double get pageHorizontalPadding => Responsive.pageHorizontalPadding(this);
}
