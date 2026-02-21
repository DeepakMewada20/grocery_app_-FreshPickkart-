import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/screens/address_screen.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';

import 'package:get/get.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Controllers
  Get.put(UserController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FreshPickKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1B8A4C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ModernSplashScreen(),
      routes: {
        '/address': (context) => const AddressScreen(),
        '/home': (context) => const MainScreen(),
        '/login': (context) => const PhoneAuthScreen(),
        '/phone-auth': (context) => const PhoneAuthScreen(),
      },
    );
  }
}
