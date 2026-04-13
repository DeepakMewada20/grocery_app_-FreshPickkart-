import 'package:flutter/material.dart';

class AdminThemeTokens {
  static const Color primary = Color(0xFF1E8B57);
  static const Color secondary = Color(0xFF167D73);
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color darkBackground = Color(0xFF0D1210);
  static const Color darkSurface = Color(0xFF151B18);
}

class AdminAppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background =
        isDark ? AdminThemeTokens.darkBackground : AdminThemeTokens.lightBackground;
    final surface =
        isDark ? AdminThemeTokens.darkSurface : AdminThemeTokens.lightSurface;
    final scheme = ColorScheme.fromSeed(
      seedColor: AdminThemeTokens.primary,
      brightness: brightness,
    ).copyWith(
      primary: AdminThemeTokens.primary,
      secondary: AdminThemeTokens.secondary,
      surface: surface,
      surfaceContainerHighest:
          isDark ? const Color(0xFF1C2420) : const Color(0xFFE8F2EB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: AdminThemeTokens.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: AdminThemeTokens.primary.withValues(alpha: 0.14),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: isDark ? Colors.white : AdminThemeTokens.primary,
        unselectedLabelColor:
            isDark
                ? Colors.white70
                : AdminThemeTokens.primary.withValues(alpha: 0.72),
        indicatorColor: isDark ? Colors.white : AdminThemeTokens.primary,
        dividerColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AdminThemeTokens.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AdminThemeTokens.primary, width: 1.4),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.45),
        thickness: 1,
      ),
    );
  }
}
