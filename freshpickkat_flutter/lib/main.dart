import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/screens/address_screen.dart';
import 'package:freshpickkat_flutter/screens/checkout_screen.dart';
import 'package:freshpickkat_flutter/screens/combo_offers_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';
import 'package:freshpickkat_flutter/utils/app_route_observer.dart';
import 'package:freshpickkat_flutter/widgets/bogo_cart_suggestion_banner.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional in some environments.
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(BannerController(), permanent: true);
  Get.put(OrderRecoveryService(), permanent: true);
  NotificationController.instance.init();
  OrderRecoveryService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return Obx(
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
          return Stack(
            children: [
              child,
              const BogoCartSuggestionBanner(),
            ],
          );
        },
        routes: {
          '/address': (context) => const AddressScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/home': (context) => const MainScreen(),
          '/login': (context) => const PhoneAuthScreen(),
          '/phone-auth': (context) => const PhoneAuthScreen(),
          '/offers': (context) => const OffersScreen(),
          '/combo-offers': (context) => const ComboOffersScreen(),
          '/coupons': (context) => const CouponsScreen(),
        },
      ),
    );
  }
}
