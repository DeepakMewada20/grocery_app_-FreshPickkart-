import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_flutter/screens/modern_splash_screen.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
var client = Client('http://$localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

late SessionManager sessionManager;

void main() async {
  // Need to call this seeing as we are awaiting Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // Make sure you have added google-services.json / GoogleService-Info.plist
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization failed: \$e");
  }

  // The session manager keeps track of the signed-in user.
  sessionManager = SessionManager(
    caller: client.modules.serverpod_auth_core as dynamic,
  );
  await sessionManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // Define routes here if needed, allowing Navigator.pushNamed('/home')
        '/home': (context) => const ScrumDidilyUmptiousPlaceholder(),
      },
    );
  }
}

// Placeholder for Home checks
class ScrumDidilyUmptiousPlaceholder extends StatelessWidget {
  const ScrumDidilyUmptiousPlaceholder({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Home Screen Placeholder")));
}
