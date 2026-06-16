import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/screens/checkout_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen/combo_offers_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/tab_navigation_controller.dart';
import 'package:freshpickkat_flutter/basket/reward_celebration_service.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/services/data_initialization_service.dart';
import 'package:freshpickkat_flutter/services/order_realtime_service.dart';
import 'package:freshpickkat_flutter/tracking/controllers/order_tracking_controller.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen/offers_screen.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';
import 'package:freshpickkat_flutter/screens/deep_link_loading_screen.dart';
import 'package:freshpickkat_flutter/screens/deep_link_not_found_screen.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/services/deep_link_service.dart';
import 'package:freshpickkat_flutter/services/share_service.dart';
import 'package:freshpickkat_flutter/utils/app_route_observer.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await GetStorage.init();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional in some environments.
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    freshpickkatFirebaseMessagingBackgroundHandler,
  );

  Get.put(ThemeController(), permanent: true);
  Get.put(DataInitializationService(), permanent: true);
  Get.put(TabNavigationController(), permanent: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => BannerController(), fenix: true);
  Get.lazyPut(() => ProductProviderController(), fenix: true);
  Get.lazyPut(() => CategoryProviderController(), fenix: true);
  Get.lazyPut(() => BogoController(), fenix: true);
  Get.lazyPut(() => ComboOfferController(), fenix: true);
  Get.put(RewardCelebrationService(), permanent: true);
  Get.lazyPut(() => CartController(), fenix: true);
  Get.lazyPut(() => SearchProviderController(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  Get.put(OrderRealtimeService(), permanent: true);
  Get.lazyPut(() => OrderRecoveryService(), fenix: true);
  Get.lazyPut(() => OrderTrackingController(), fenix: true);
  Get.put(ShareService(), permanent: true);
  await Get.putAsync(() => DeepLinkService().init(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return ScreenUtilInit(
      designSize: AppResponsive.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => Obx(
        () => GetMaterialApp(
          title: 'FreshPickKart',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(themeController.lightPreset),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeController.themeMode,
          home: const ModernSplashScreen(),
          navigatorObservers: [appRouteObserver],
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            final mq = MediaQuery.of(context);
            final width = mq.size.width;

            Widget content = MediaQuery(
              data: mq.copyWith(
                textScaler: AppResponsive.clampedTextScaler(context),
              ),
              child: Stack(
                children: [
                  child,
                  const NetworkStatusBanner(),
                ],
              ),
            );

            if (width <= 430) return content;

            return Container(
              color: const Color(0xFFEDEDED),
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 430,
                child: MediaQuery(
                  data: mq.copyWith(
                    size: Size(430, mq.size.height),
                  ),
                  child: content,
                ),
              ),
            );
          },
          getPages: [
            GetPage(name: '/checkout', page: () => const CheckoutScreen()),
            GetPage(name: RouteManager.home, page: () => const MainScreen()),
            GetPage(name: '/login', page: () => const PhoneAuthScreen()),
            GetPage(name: '/phone-auth', page: () => const PhoneAuthScreen()),
            GetPage(name: '/offers', page: () => const OffersScreen()),
            GetPage(
              name: '/combo-offers',
              page: () => const ComboOffersScreen(),
            ),
            GetPage(name: '/coupons', page: () => const CouponsScreen()),
            GetPage(
              name: RouteManager.productPattern,
              page: () => const DeepLinkLoadingScreen(
                type: DeepLinkType.product,
              ),
            ),
            GetPage(
              name: RouteManager.categoryPattern,
              page: () => const DeepLinkLoadingScreen(
                type: DeepLinkType.category,
              ),
            ),
            GetPage(
              name: RouteManager.offerPattern,
              page: () => const DeepLinkLoadingScreen(
                type: DeepLinkType.offer,
              ),
            ),
            GetPage(
              name: RouteManager.productNotFound,
              page: () => DeepLinkNotFoundScreen.product(productId: ''),
            ),
            GetPage(
              name: RouteManager.deepLinkNotFound,
              page: () => const DeepLinkNotFoundScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
