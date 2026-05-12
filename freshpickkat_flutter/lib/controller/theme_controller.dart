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
  final _themeMode = ThemeMode.dark.obs;
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
    final themeModeIndex = _storage.read<int>('themeMode') ?? ThemeMode.dark.index;
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
// Offer Theme Extension
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class AppOfferTheme extends ThemeExtension<AppOfferTheme> {
  final Color badge;
  final Color onBadge;
  final Color badgeSoft;
  final Color badgeBorder;

  const AppOfferTheme({
    required this.badge,
    required this.onBadge,
    required this.badgeSoft,
    required this.badgeBorder,
  });

  factory AppOfferTheme.fallback(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const AppOfferTheme(
        badge: Color(0xFFE6A23C),
        onBadge: Color(0xFF1A1206),
        badgeSoft: Color(0xFF3B2A12),
        badgeBorder: Color(0x80E6A23C),
      );
    }

    return const AppOfferTheme(
      badge: Color(0xFFE6A23C),
      onBadge: Colors.white,
      badgeSoft: Color(0xFFFFF3DF),
      badgeBorder: Color(0x80E6A23C),
    );
  }

  @override
  AppOfferTheme copyWith({
    Color? badge,
    Color? onBadge,
    Color? badgeSoft,
    Color? badgeBorder,
  }) {
    return AppOfferTheme(
      badge: badge ?? this.badge,
      onBadge: onBadge ?? this.onBadge,
      badgeSoft: badgeSoft ?? this.badgeSoft,
      badgeBorder: badgeBorder ?? this.badgeBorder,
    );
  }

  @override
  AppOfferTheme lerp(ThemeExtension<AppOfferTheme>? other, double t) {
    if (other is! AppOfferTheme) return this;
    return AppOfferTheme(
      badge: Color.lerp(badge, other.badge, t) ?? badge,
      onBadge: Color.lerp(onBadge, other.onBadge, t) ?? onBadge,
      badgeSoft: Color.lerp(badgeSoft, other.badgeSoft, t) ?? badgeSoft,
      badgeBorder: Color.lerp(badgeBorder, other.badgeBorder, t) ?? badgeBorder,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Suggestion Card Theme Extension
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class AppSuggestionTheme extends ThemeExtension<AppSuggestionTheme> {
  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;
  final Color progressTrack;
  final Color deliveryIconBg;
  final Color deliveryIconColor;
  final Color couponIconBg;
  final Color couponIconColor;
  final Color bogoIconBg;
  final Color bogoIconColor;
  final Color comboIconBg;
  final Color comboIconColor;
  final Color variantIconBg;
  final Color variantIconColor;
  final Color savingBadgeBg;
  final Color savingBadgeText;
  final Color chipBackground;
  final Color chipText;
  final Color ctaBackground;
  final Color ctaText;
  final Color iconColor;

  const AppSuggestionTheme({
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.progressTrack,
    required this.deliveryIconBg,
    required this.deliveryIconColor,
    required this.couponIconBg,
    required this.couponIconColor,
    required this.bogoIconBg,
    required this.bogoIconColor,
    required this.comboIconBg,
    required this.comboIconColor,
    required this.variantIconBg,
    required this.variantIconColor,
    required this.savingBadgeBg,
    required this.savingBadgeText,
    required this.chipBackground,
    required this.chipText,
    required this.ctaBackground,
    required this.ctaText,
    required this.iconColor,
  });

  factory AppSuggestionTheme.light() {
    return const AppSuggestionTheme(
      cardBackground: Color(0xFFFFFFFF),
      cardBorder: Color(0xFFE0E0E0),
      cardShadow: Color(0x0A000000),
      progressTrack: Color(0xFFE8E8E8),
      deliveryIconBg: Color(0xFFE8F5E9),
      deliveryIconColor: Color(0xFF4CAF50),
      couponIconBg: Color(0xFFFFF8E1),
      couponIconColor: Color(0xFFFFB300),
      bogoIconBg: Color(0xFFFCE4EC),
      bogoIconColor: Color(0xFFE91E63),
      comboIconBg: Color(0xFFE8F5E9),
      comboIconColor: Color(0xFF1B8A4C),
      variantIconBg: Color(0xFFE3F2FD),
      variantIconColor: Color(0xFF2196F3),
      savingBadgeBg: Color(0xFF1B8A4C),
      savingBadgeText: Color(0xFFFFFFFF),
      chipBackground: Color(0x1F1B8A4C), // Semi-transparent primary
      chipText: Color(0xFF1B8A4C),
      ctaBackground: Color(0xFF1B8A4C),
      ctaText: Color(0xFFFFFFFF),
      iconColor: Color(0xFF1B8A4C),
    );
  }

  factory AppSuggestionTheme.dark() {
    return const AppSuggestionTheme(
      cardBackground: Color(0xFF1E1E1E),
      cardBorder: Color(0xFF2E2E2E),
      cardShadow: Color(0x40000000),
      progressTrack: Color(0xFF2E2E2E),
      deliveryIconBg: Color(0xFF1B3D1C),
      deliveryIconColor: Color(0xFF66BB6A),
      couponIconBg: Color(0xFF3D3100),
      couponIconColor: Color(0xFFFFCA28),
      bogoIconBg: Color(0xFF3D1F2C),
      bogoIconColor: Color(0xFFF06292),
      comboIconBg: Color(0xFF1B3D1C),
      comboIconColor: Color(0xFF66BB6A),
      variantIconBg: Color(0xFF1A2740),
      variantIconColor: Color(0xFF64B5F6),
      savingBadgeBg: Color(0xFF2ECC71),
      savingBadgeText: Color(0xFF000000),
      chipBackground: Color(0x332ECC71),
      chipText: Color(0xFF2ECC71),
      ctaBackground: Color(0xFF2ECC71),
      ctaText: Color(0xFF000000),
      iconColor: Color(0xFF2ECC71),
    );
  }

  @override
  AppSuggestionTheme copyWith({
    Color? cardBackground,
    Color? cardBorder,
    Color? cardShadow,
    Color? progressTrack,
    Color? deliveryIconBg,
    Color? deliveryIconColor,
    Color? couponIconBg,
    Color? couponIconColor,
    Color? bogoIconBg,
    Color? bogoIconColor,
    Color? comboIconBg,
    Color? comboIconColor,
    Color? variantIconBg,
    Color? variantIconColor,
    Color? savingBadgeBg,
    Color? savingBadgeText,
    Color? chipBackground,
    Color? chipText,
    Color? ctaBackground,
    Color? ctaText,
    Color? iconColor,
  }) {
    return AppSuggestionTheme(
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      progressTrack: progressTrack ?? this.progressTrack,
      deliveryIconBg: deliveryIconBg ?? this.deliveryIconBg,
      deliveryIconColor: deliveryIconColor ?? this.deliveryIconColor,
      couponIconBg: couponIconBg ?? this.couponIconBg,
      couponIconColor: couponIconColor ?? this.couponIconColor,
      bogoIconBg: bogoIconBg ?? this.bogoIconBg,
      bogoIconColor: bogoIconColor ?? this.bogoIconColor,
      comboIconBg: comboIconBg ?? this.comboIconBg,
      comboIconColor: comboIconColor ?? this.comboIconColor,
      variantIconBg: variantIconBg ?? this.variantIconBg,
      variantIconColor: variantIconColor ?? this.variantIconColor,
      savingBadgeBg: savingBadgeBg ?? this.savingBadgeBg,
      savingBadgeText: savingBadgeText ?? this.savingBadgeText,
      chipBackground: chipBackground ?? this.chipBackground,
      chipText: chipText ?? this.chipText,
      ctaBackground: ctaBackground ?? this.ctaBackground,
      ctaText: ctaText ?? this.ctaText,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  AppSuggestionTheme lerp(ThemeExtension<AppSuggestionTheme>? other, double t) {
    if (other is! AppSuggestionTheme) return this;
    return AppSuggestionTheme(
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t) ?? cardShadow,
      progressTrack:
          Color.lerp(progressTrack, other.progressTrack, t) ?? progressTrack,
      deliveryIconBg:
          Color.lerp(deliveryIconBg, other.deliveryIconBg, t) ?? deliveryIconBg,
      deliveryIconColor:
          Color.lerp(deliveryIconColor, other.deliveryIconColor, t) ??
          deliveryIconColor,
      couponIconBg:
          Color.lerp(couponIconBg, other.couponIconBg, t) ?? couponIconBg,
      couponIconColor:
          Color.lerp(couponIconColor, other.couponIconColor, t) ??
          couponIconColor,
      bogoIconBg: Color.lerp(bogoIconBg, other.bogoIconBg, t) ?? bogoIconBg,
      bogoIconColor:
          Color.lerp(bogoIconColor, other.bogoIconColor, t) ?? bogoIconColor,
      comboIconBg: Color.lerp(comboIconBg, other.comboIconBg, t) ?? comboIconBg,
      comboIconColor:
          Color.lerp(comboIconColor, other.comboIconColor, t) ?? comboIconColor,
      variantIconBg:
          Color.lerp(variantIconBg, other.variantIconBg, t) ?? variantIconBg,
      variantIconColor:
          Color.lerp(variantIconColor, other.variantIconColor, t) ??
          variantIconColor,
      savingBadgeBg:
          Color.lerp(savingBadgeBg, other.savingBadgeBg, t) ?? savingBadgeBg,
      savingBadgeText:
          Color.lerp(savingBadgeText, other.savingBadgeText, t) ??
          savingBadgeText,
      chipBackground:
          Color.lerp(chipBackground, other.chipBackground, t) ?? chipBackground,
      chipText: Color.lerp(chipText, other.chipText, t) ?? chipText,
      ctaBackground:
          Color.lerp(ctaBackground, other.ctaBackground, t) ?? ctaBackground,
      ctaText: Color.lerp(ctaText, other.ctaText, t) ?? ctaText,
      iconColor: Color.lerp(iconColor, other.iconColor, t) ?? iconColor,
    );
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
    const offerTheme = AppOfferTheme(
      badge: Color(0xFFE6A23C),
      onBadge: Colors.white,
      badgeSoft: Color(0xFFFFF3DF),
      badgeBorder: Color(0x80E6A23C),
    );
    final suggestionTheme = AppSuggestionTheme.light();
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
      extensions: <ThemeExtension<dynamic>>[
        offerTheme,
        suggestionTheme,
      ],
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData darkTheme() {
    const offerTheme = AppOfferTheme(
      badge: Color(0xFFE6A23C),
      onBadge: Color(0xFF1A1206),
      badgeSoft: Color(0xFF3B2A12),
      badgeBorder: Color(0x80E6A23C),
    );
    final suggestionTheme = AppSuggestionTheme.dark();
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
      extensions: <ThemeExtension<dynamic>>[
        offerTheme,
        suggestionTheme,
      ],
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
