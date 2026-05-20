import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminThemeController extends GetxController {
  static const String storageKey = 'admin_theme_mode';

  final GetStorage _storage = GetStorage();
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = _readThemeMode();
  }

  ThemeMode _readThemeMode() {
    final value = _storage.read<String>(storageKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _storage.write(storageKey, mode.name);
  }

  String get modeLabel {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
