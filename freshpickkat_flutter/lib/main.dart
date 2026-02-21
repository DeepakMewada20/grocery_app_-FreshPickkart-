import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/address_screen.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(ThemeController(), permanent: true);
  Get.put(UserController(), permanent: true);

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
        routes: {
          '/address': (context) => const AddressScreen(),
          '/home': (context) => const MainScreen(),
          '/login': (context) => const PhoneAuthScreen(),
          '/phone-auth': (context) => const PhoneAuthScreen(),
        },
      ),
    );
  }
}
