import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Light Theme Presets
// ─────────────────────────────────────────────────────────────────────────────
enum LightThemePreset {
  sageGreen, // 🌿 green tinted — current
  warmCream, // 🍞 warm beige/cream
  skyBlue, // 🩵 cool sky blue
  roseBlush, // 🌸 soft pink/rose
  lavender, // 💜 purple lavender
}

// ─────────────────────────────────────────────────────────────────────────────
// ThemeController
// ─────────────────────────────────────────────────────────────────────────────
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final _storage = GetStorage();
  final _themeMode = ThemeMode.system.obs;
  final _lightPreset = LightThemePreset.sageGreen.obs;

  ThemeMode get themeMode => _themeMode.value;
  LightThemePreset get lightPreset => _lightPreset.value;

  bool get isDark {
    if (_themeMode.value == ThemeMode.dark) return true;
    if (_themeMode.value == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final themeModeIndex = _storage.read<int>('themeMode') ?? 0;
    _themeMode.value = ThemeMode.values[themeModeIndex];

    final presetIndex = _storage.read<int>('lightPreset') ?? 0;
    _lightPreset.value = LightThemePreset.values[presetIndex];
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storage.write('themeMode', mode.index);
    Get.changeThemeMode(mode);
    _applyCurrentTheme();
  }

  void setLightPreset(LightThemePreset preset) {
    _lightPreset.value = preset;
    _storage.write('lightPreset', preset.index);
    _applyCurrentTheme();
  }

  void _applyCurrentTheme() {
    final dark = isDark;
    Get.changeTheme(
      dark ? AppTheme.darkTheme() : AppTheme.lightTheme(_lightPreset.value),
    );
  }

  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppTheme
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  static const Color primaryGreen = Color(0xFF1B8A4C);
  static const Color accentGreen = Color(0xFF2ECC71);

  // ── Dark Mode (single palette) ─────────────────────────────────────────────
  static const Color darkScaffold = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF242424);

  // ── Light Theme Preset Palettes ────────────────────────────────────────────

  /// 🌿 Sage Green — warm green tints (grocery-fresh feeling)
  static const _sageGreen = _LightPalette(
    name: 'Sage Green',
    emoji: '🌿',
    scaffold: Color(0xFFF7F9F4),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFEFF5EC),
    cardHigh: Color(0xFFE4EFE0),
    text: Color(0xFF1C2B1E),
    textSub: Color(0xFF4E6655),
    divider: Color(0xFFD5E5CE),
    accent: Color(0xFF1B8A4C),
  );

  /// 🍞 Warm Cream — soft beige & warm earth tones
  static const _warmCream = _LightPalette(
    name: 'Warm Cream',
    emoji: '🍞',
    scaffold: Color(0xFFFBF7F0),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFF5EDE0),
    cardHigh: Color(0xFFEDE3D5),
    text: Color(0xFF2C1E0F),
    textSub: Color(0xFF7A5C3A),
    divider: Color(0xFFDFCFB5),
    accent: Color(0xFF1B8A4C),
  );

  /// 🩵 Sky Blue — clean and refreshing cool blues
  static const _skyBlue = _LightPalette(
    name: 'Sky Blue',
    emoji: '🩵',
    scaffold: Color(0xFFF0F6FC),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFE3F0FA),
    cardHigh: Color(0xFFD3E7F5),
    text: Color(0xFF0D2137),
    textSub: Color(0xFF3A6080),
    divider: Color(0xFFBDD6EA),
    accent: Color(0xFF1B8A4C),
  );

  /// 🌸 Rose Blush — soft pink and blush tones
  static const _roseBlush = _LightPalette(
    name: 'Rose Blush',
    emoji: '🌸',
    scaffold: Color(0xFFFDF5F7),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFF8E8EE),
    cardHigh: Color(0xFFF0D9E2),
    text: Color(0xFF2E0F1A),
    textSub: Color(0xFF7A3A50),
    divider: Color(0xFFE8C4D0),
    accent: Color(0xFF1B8A4C),
  );

  /// 💜 Lavender — soft purple and violet tones
  static const _lavender = _LightPalette(
    name: 'Lavender',
    emoji: '💜',
    scaffold: Color(0xFFF6F3FC),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFEDE8F8),
    cardHigh: Color(0xFFE3DCF4),
    text: Color(0xFF1A1030),
    textSub: Color(0xFF5A4A80),
    divider: Color(0xFFD4C8EE),
    accent: Color(0xFF1B8A4C),
  );

  static _LightPalette _getPreset(LightThemePreset preset) {
    switch (preset) {
      case LightThemePreset.sageGreen:
        return _sageGreen;
      case LightThemePreset.warmCream:
        return _warmCream;
      case LightThemePreset.skyBlue:
        return _skyBlue;
      case LightThemePreset.roseBlush:
        return _roseBlush;
      case LightThemePreset.lavender:
        return _lavender;
    }
  }

  /// Shimmer base color for each light preset
  static Color shimmerBase(LightThemePreset preset) => _getPreset(preset).card;

  static Color shimmerHighlight(LightThemePreset preset) =>
      _getPreset(preset).scaffold;

  // ── Light Theme Builder ─────────────────────────────────────────────────────
  static ThemeData lightTheme([
    LightThemePreset preset = LightThemePreset.sageGreen,
  ]) {
    final p = _getPreset(preset);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryGreen,
        onPrimary: Colors.white,
        secondary: accentGreen,
        onSecondary: Colors.white,
        error: const Color(0xFFD32F2F),
        onError: Colors.white,
        surface: p.surface,
        onSurface: p.text,
        surfaceContainerHighest: p.card,
        surfaceContainerHigh: p.cardHigh,
        outline: p.text,
        outlineVariant: p.divider,
        inverseSurface: p.text,
        onInverseSurface: p.surface,
        tertiary: primaryGreen,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: p.scaffold,
      appBarTheme: AppBarTheme(
        backgroundColor: p.scaffold,
        foregroundColor: p.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: p.text),
        titleTextStyle: TextStyle(
          color: p.text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: p.divider,
      iconTheme: IconThemeData(color: p.text),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: p.text),
        bodyMedium: TextStyle(color: p.text),
        bodySmall: TextStyle(color: p.textSub),
        titleMedium: TextStyle(color: p.text, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: p.text, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.surface,
        selectedItemColor: primaryGreen,
        unselectedItemColor: p.textSub,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.card,
        selectedColor: primaryGreen,
        labelStyle: TextStyle(color: p.text, fontSize: 12),
        side: BorderSide(color: p.divider),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryGreen,
        onPrimary: Colors.white,
        secondary: accentGreen,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: darkSurface,
        onSurface: Colors.white,
        surfaceContainerHighest: darkSurface,
        surfaceContainerHigh: darkCard,
        outline: Colors.white,
        outlineVariant: Color(0x1AFFFFFF),
        inverseSurface: Colors.white,
        onInverseSurface: darkScaffold,
      ),
      scaffoldBackgroundColor: darkScaffold,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkScaffold,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: const Color(0x1AFFFFFF),
      iconTheme: const IconThemeData(color: Colors.white),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF141414),
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.white54,
        elevation: 0,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  // ── Static palette constants for direct use─────────────────────────────────
  static const Color lightDivider = Color(
    0xFFD5E5CE,
  ); // used by category_item_card
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal palette data class
// ─────────────────────────────────────────────────────────────────────────────
class _LightPalette {
  final String name;
  final String emoji;
  final Color scaffold;
  final Color surface;
  final Color card;
  final Color cardHigh;
  final Color text;
  final Color textSub;
  final Color divider;
  final Color accent;

  const _LightPalette({
    required this.name,
    required this.emoji,
    required this.scaffold,
    required this.surface,
    required this.card,
    required this.cardHigh,
    required this.text,
    required this.textSub,
    required this.divider,
    required this.accent,
  });
}
