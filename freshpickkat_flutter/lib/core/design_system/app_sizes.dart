import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../responsive/adaptive_value.dart';

class AppSizes {
  AppSizes._();

  static double get buttonHeight =>
      48.h;

  static double get searchBarHeight => 44.h;

  static double get productImageSize => 140.r;

  static double get categoryImageSize => 72.r;

  static double get offerCardHeight => 120.h;

  static double get bannerMinHeight => 112.h;

  static double get bannerMaxHeight => 190.h;

  static double get productCardMinHeight => 240.h;

  static double get bottomNavHeight => 64.h;

  static double get appBarHeight => 56.h;

  static double get fabSize => 56.r;

  static double get bottomSheetHandleHeight => 32.h;

  static double get sectionHeaderHeight => 44.h;

  static double get badgeSize => 20.r;

  static double get dividerThickness => 1.h;

  static double get chipHeight => 32.h;

  static double get inputHeight => 48.h;

  static double get sliderHeight => 40.h;

  static double get tabBarHeight => 48.h;

  static EdgeInsets get dialogPadding => EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 20.h,
      );

  static double dialogWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 600.w;
    if (width >= 600) return 520.w;
    return 400.w;
  }

  static const double dialogMaxWidth = 600;

  static double drawerWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 360.w;
    if (width >= 600) return 320.w;
    return 280.w;
  }

  static double get sheetMaxWidth => 720;

  static double get productCardAspectRatio => 0.52;

  static final AdaptiveValue<double> adaptiveButtonHeight = AdaptiveValue<double>(
    phone: 48,
    tablet: 54,
    desktop: 60,
    largeDesktop: 60,
  );

  static final AdaptiveValue<double> adaptiveBannerHeight = AdaptiveValue<double>(
    phone: 150,
    tablet: 170,
    desktop: 190,
    largeDesktop: 200,
  );

  static final AdaptiveValue<double> adaptiveProductImageSize =
      AdaptiveValue<double>(
    phone: 140,
    tablet: 160,
    desktop: 180,
    largeDesktop: 200,
  );

  static final AdaptiveValue<double> adaptiveCategoryImageSize =
      AdaptiveValue<double>(
    phone: 72,
    tablet: 80,
    desktop: 88,
    largeDesktop: 96,
  );

  static final AdaptiveValue<double> adaptiveOfferCardHeight =
      AdaptiveValue<double>(
    phone: 120,
    tablet: 140,
    desktop: 160,
    largeDesktop: 180,
  );
}
