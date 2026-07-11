import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_models.dart';
import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_storage.dart';

class ProcessRecoveryService extends GetxService with WidgetsBindingObserver {
  static final _storage = ProcessRecoveryStorage();
  static Map<String, dynamic>? recoveredArgs;

  static ProcessRecoveryService get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('[Recovery] Service initialized');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveCurrentRoute();
    }
  }

  static String? getSavedRoute() {
    try {
      final saved = _storage.load();
      if (saved == null) {
        debugPrint('[Recovery] No saved state');
        return null;
      }

      if (saved.isExpired) {
        debugPrint('[Recovery] Expired: ${saved.route}');
        _storage.clear();
        return null;
      }

      if (!saved.isValid) {
        debugPrint('[Recovery] Invalid route: ${saved.route}');
        _storage.clear();
        return null;
      }

      if (saved.argumentsJson != null) {
        try {
          final decoded = jsonDecode(saved.argumentsJson!);
          if (decoded is Map) {
            recoveredArgs = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {
          recoveredArgs = null;
        }
      }

      final route = saved.canRestoreExact() ? saved.route : '/home';
      _storage.clear();
      debugPrint('[Recovery] Restore route: $route');
      return route;
    } catch (e) {
      debugPrint('[Recovery] Restore failed: $e');
      _storage.clear();
      return null;
    }
  }

  static void _saveCurrentRoute() {
    try {
      final route = Get.currentRoute;
      if (route.isEmpty || route == '/splash' || route == '/login' || route == '/phone-auth') {
        return;
      }

      String? argsJson;
      try {
        final args = Get.arguments;
        if (args is Map) {
          final safe = <String, dynamic>{};
          args.forEach((k, v) {
            if (v is String || v is num || v is bool || v is List || v is Map) {
              safe[k.toString()] = v;
            }
          });
          if (safe.isNotEmpty) argsJson = jsonEncode(safe);
        } else if (args is List || args is String || args is num || args is bool) {
          argsJson = jsonEncode(args);
        }
      } catch (_) {
        argsJson = null;
      }

      _storage.save(SavedRouteState(
        route: route,
        argumentsJson: argsJson,
        timestamp: DateTime.now(),
      ));
      debugPrint('[Recovery] Saved route: $route');
    } catch (e) {
      debugPrint('[Recovery] Save failed: $e');
    }
  }
}
