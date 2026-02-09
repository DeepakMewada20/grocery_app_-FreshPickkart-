import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/non_use_files/maincloude.dart';
import 'package:freshpickkat_flutter/non_use_files/product_list_test_screen.dart';
import 'package:freshpickkat_flutter/screens/address_screen.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';
import 'package:freshpickkat_flutter/services/product_service.dart';

import 'package:get/get.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ModernSplashScreen(),
      routes: {
        '/address': (context) => const AddressScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
