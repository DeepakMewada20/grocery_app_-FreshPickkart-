import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/screens/phone_auth_screen.dart';

import 'package:get/get.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
// var client = Client(
//   'http://$localhost:8080/',
//   authenticationKeyManager: FlutterAuthenticationKeyManager(),
// )..connectivityMonitor = FlutterConnectivityMonitor();

// late SessionManager sessionManager;

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
      home: const PhoneAuthScreen(),
    );
  }
}
