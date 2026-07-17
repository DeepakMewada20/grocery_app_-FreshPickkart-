import 'package:flutter/material.dart';
import '../responsive/adaptive_value.dart';
import 'screen_scale.dart';

class AppSizes {
  AppSizes._();

  static double get buttonHeight =>
      ScreenScale.h(48);

  static double get searchBarHeight => ScreenScale.h(44);

  static double get productImageSize => ScreenScale.r(140);

  static double get categoryImageSize => ScreenScale.r(72);

  static double get offerCardHeight => ScreenScale.h(120);

  static double get bannerMinHeight => ScreenScale.h(112);

  static double get bannerMaxHeight => ScreenScale.h(190);

  static double get productCardMinHeight => ScreenScale.h(240);

  static double get bottomNavHeight => ScreenScale.h(64);

  static double get appBarHeight => ScreenScale.h(56);

  static double get fabSize => ScreenScale.r(56);

  static double get bottomSheetHandleHeight => ScreenScale.h(32);

  static double get sectionHeaderHeight => ScreenScale.h(44);

  static double get badgeSize => ScreenScale.r(20);

  static double get dividerThickness => ScreenScale.h(1);

  static double get chipHeight => ScreenScale.h(32);

  static double get inputHeight => ScreenScale.h(48);

  static double get sliderHeight => ScreenScale.h(40);

  static double get tabBarHeight => ScreenScale.h(48);

  static EdgeInsets get dialogPadding => EdgeInsets.symmetric(
        horizontal: ScreenScale.w(24),
        vertical: ScreenScale.h(20),
      );

  static double dialogWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return ScreenScale.w(600);
    if (width >= 600) return ScreenScale.w(520);
    return ScreenScale.w(400);
  }

  static const double dialogMaxWidth = 600;

  static double drawerWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return ScreenScale.w(360);
    if (width >= 600) return ScreenScale.w(320);
    return ScreenScale.w(280);
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
