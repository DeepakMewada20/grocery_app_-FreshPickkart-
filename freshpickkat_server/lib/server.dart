import 'dart:io';
import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'src/services/firebase_service.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/services/background_task_service.dart';
import 'src/services/analytics/product_analytics_cron_job.dart';
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
  unawaited(_runSubCategoryMigration(pod));
}

Future<void> _runSubCategoryMigration(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    final allSubcategories = await SubCategoryRow.db.find(session);
    var migratedCount = 0;

    for (final row in allSubcategories) {
      final name = row.name;
      if (name.contains(',') || name.contains('&')) {
        final categoryId = row.categoryId;
        final imageUrl = row.imageUrl;

        final splitNames = name
            .split(RegExp(r'[,&]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        if (splitNames.length <= 1) continue;

        stdout.writeln('Migrating grouped subcategory "$name" to individual rows: $splitNames');

        await session.db.transaction((transaction) async {
          final newSubcategoryIds = <UuidValue>[];

          for (final splitName in splitNames) {
            final slug = splitName
                .toLowerCase()
                .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                .replaceAll(RegExp(r'^_+|_+$'), '');

            var individualRow = await SubCategoryRow.db.findFirstRow(
              session,
              where: (t) => t.categoryId.equals(categoryId) & t.slug.equals(slug),
              transaction: transaction,
            );

            individualRow ??= await SubCategoryRow.db.insertRow(
              session,
              SubCategoryRow(
                categoryId: categoryId,
                name: splitName,
                slug: slug,
                imageUrl: imageUrl,
                status: 'active',
                createdAt: DateTime.now().toUtc(),
                updatedAt: DateTime.now().toUtc(),
              ),
              transaction: transaction,
            );

            if (individualRow.id != null) {
              newSubcategoryIds.add(individualRow.id!);
            }
          }

          final productMappings = await ProductSubCategoryRow.db.find(
            session,
            where: (t) => t.subCategoryId.equals(row.id!),
            transaction: transaction,
          );

          for (final mapping in productMappings) {
            for (final newId in newSubcategoryIds) {
              final exists = await ProductSubCategoryRow.db.findFirstRow(
                session,
                where: (t) => t.productId.equals(mapping.productId) & t.subCategoryId.equals(newId),
                transaction: transaction,
              );

              if (exists == null) {
                await ProductSubCategoryRow.db.insertRow(
                  session,
                  ProductSubCategoryRow(
                    productId: mapping.productId,
                    subCategoryId: newId,
                  ),
                  transaction: transaction,
                );
              }
            }
            await ProductSubCategoryRow.db.deleteRow(session, mapping, transaction: transaction);
          }

          await SubCategoryRow.db.deleteRow(session, row, transaction: transaction);
          migratedCount++;
        });
      }
    }
    if (migratedCount > 0) {
      stdout.writeln('Successfully migrated $migratedCount grouped subcategories.');
    }
  } catch (e, stack) {
    stderr.writeln('ERROR in subcategory migration: $e\n$stack');
  } finally {
    await session.close();
  }
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
