import 'package:flutter/material.dart';

class AdminThemeTokens {
  // Primary Colors
  static const Color primary = Color(0xFF1E8B57);
  static const Color secondary = Color(0xFF167D73);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightTextPrimary = Color(0xFF1C1C1C);
  static const Color lightTextSecondary = Color(0xFF616161);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Dark Theme Colors - Improved
  static const Color darkBackground = Color(0xFF0F1412);
  static const Color darkSurface = Color(0xFF1A211E);
  static const Color darkSurfaceVariant = Color(0xFF232B27);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF424242);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color error = Color(0xFFE53935);
  static const Color darkError = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFC107);
  static const Color darkWarning = Color(0xFFFFD54F);
  static const Color info = Color(0xFF2196F3);
  static const Color darkInfo = Color(0xFF64B5F6);
}

class AdminAppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? AdminThemeTokens.darkBackground
        : AdminThemeTokens.lightBackground;
    final surface = isDark
        ? AdminThemeTokens.darkSurface
        : AdminThemeTokens.lightSurface;
    final onSurface = isDark
        ? AdminThemeTokens.darkOnSurface
        : AdminThemeTokens.lightOnSurface;
    final textPrimary = isDark
        ? AdminThemeTokens.darkTextPrimary
        : AdminThemeTokens.lightTextPrimary;
    final textSecondary = isDark
        ? AdminThemeTokens.darkTextSecondary
        : AdminThemeTokens.lightTextSecondary;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AdminThemeTokens.primary,
          brightness: brightness,
        ).copyWith(
          primary: AdminThemeTokens.primary,
          secondary: AdminThemeTokens.secondary,
          surface: surface,
          onSurface: onSurface,
          surfaceContainerHighest: isDark
              ? AdminThemeTokens.darkSurfaceVariant
              : const Color(0xFFE8F2EB),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: isDark ? AdminThemeTokens.darkError : AdminThemeTokens.error,
          onError: Colors.white,
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
        unselectedLabelColor: isDark
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
        fillColor: isDark ? AdminThemeTokens.darkSurfaceVariant : surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AdminThemeTokens.darkBorder : scheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AdminThemeTokens.darkBorder : scheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AdminThemeTokens.primary,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AdminThemeTokens.darkError : AdminThemeTokens.error,
            width: 1.4,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AdminThemeTokens.darkError : AdminThemeTokens.error,
            width: 1.4,
          ),
        ),
        labelStyle: TextStyle(
          color: isDark
              ? AdminThemeTokens.darkTextPrimary
              : AdminThemeTokens.lightTextPrimary,
        ),
        hintStyle: TextStyle(
          color: isDark
              ? AdminThemeTokens.darkTextSecondary
              : AdminThemeTokens.lightTextSecondary,
        ),
        helperStyle: TextStyle(
          color: isDark
              ? AdminThemeTokens.darkTextSecondary
              : AdminThemeTokens.lightTextSecondary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark
            ? AdminThemeTokens.darkBorder
            : scheme.outlineVariant.withValues(alpha: 0.45),
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminThemeTokens.primary,
          foregroundColor: Colors.white,
          elevation: isDark ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AdminThemeTokens.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminThemeTokens.primary,
          side: BorderSide(
            color: isDark ? AdminThemeTokens.darkBorder : scheme.outlineVariant,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static Color getSuccessColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkSuccess
        : AdminThemeTokens.success;
  }

  static Color getErrorColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkError
        : AdminThemeTokens.error;
  }

  static Color getWarningColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkWarning
        : AdminThemeTokens.warning;
  }

  static Color getInfoColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkInfo
        : AdminThemeTokens.info;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkTextSecondary
        : AdminThemeTokens.lightTextSecondary;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkBorder
        : AdminThemeTokens.lightBorder;
  }
}
