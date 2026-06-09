import 'dart:io';
import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'src/services/firebase_service.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/services/background_task_service.dart';
import 'src/services/analytics/product_analytics_cron_job.dart';
import 'src/services/payment_reconciliation_cron_job.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
import 'src/web/routes/razorpay_webhook_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.

  // Initialize Firebase Admin SDK in background with retry
  unawaited(_initializeFirebaseWithRetry());

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Razorpay webhook (POST)
  pod.webServer.addRoute(RazorpayWebhookRoute(), '/payment/webhook');
  pod.webServer.addRoute(RazorpayWebhookRoute(), '/webhook/razorpay');

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  await pod.start();
  BackgroundTaskService.configure(pod);
  unawaited(BackgroundTaskService.instance.run());
  ProductAnalyticsCronJob(pod).start();
  PaymentReconciliationCronJob(pod).start();
}

Future<void> _initializeFirebaseWithRetry() async {
  while (true) {
    try {
      await FirebaseService.getServiceAccountCredentials();
      stdout.writeln('Firebase Admin SDK initialized successfully.');
      break;
    } catch (e) {
      stderr.writeln('WARNING: Failed to initialize Firebase Admin SDK: $e');
      stderr.writeln('Retrying in 10 seconds...');
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
