import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminThemeTokens {
  // Primary Colors
  static const Color primary = Color(0xFF1E8B57);
  static const Color secondary = Color(0xFF167D73);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentBlue = Color(0xFF2196F3);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightTextPrimary = Color(0xFF1C1C1C);
  static const Color lightTextSecondary = Color(0xFF616161);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Dark Theme Colors - Carbon Premium with Cyan Accents
  static const Color darkBackground = Color(0xFF0A0E0C);
  static const Color darkSurface = Color(0xFF121814);
  static const Color darkSurfaceVariant = Color(0xFF1D2420);
  static const Color darkSurfaceElevated = Color(0xFF262D2A);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA8A8A8);
  static const Color darkBorder = Color(0xFF353D3A);
  static const Color darkDivider = Color(0xFF2A3330);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color darkSuccess = Color(0xFF66BB6A);
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
          secondary: isDark
              ? AdminThemeTokens.accentCyan
              : AdminThemeTokens.secondary,
          surface: surface,
          onSurface: onSurface,
          surfaceContainerHighest: isDark
              ? AdminThemeTokens.darkSurfaceElevated
              : const Color(0xFFE8F2EB),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          error: isDark ? AdminThemeTokens.darkError : AdminThemeTokens.error,
          onError: Colors.white,
          outlineVariant: isDark
              ? AdminThemeTokens.darkBorder
              : const Color(0xFFCACACA),
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
        toolbarHeight: 60.h.clamp(54.0, 68.0),
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp.clamp(16.0, 21.0),
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 1 : 1.5,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark
            ? AdminThemeTokens.accentCyan.withValues(alpha: 0.15)
            : AdminThemeTokens.primary.withValues(alpha: 0.14),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: isDark
            ? AdminThemeTokens.accentCyan
            : AdminThemeTokens.primary,
        unselectedLabelColor: isDark
            ? AdminThemeTokens.darkTextSecondary
            : AdminThemeTokens.primary.withValues(alpha: 0.72),
        indicatorColor: isDark
            ? AdminThemeTokens.accentCyan
            : AdminThemeTokens.primary,
        dividerColor: isDark
            ? AdminThemeTokens.darkDivider
            : Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AdminThemeTokens.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AdminThemeTokens.darkSurfaceElevated : surface,
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
          borderSide: BorderSide(
            color: isDark
                ? AdminThemeTokens.accentCyan
                : AdminThemeTokens.primary,
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
            ? AdminThemeTokens.darkDivider
            : scheme.outlineVariant.withValues(alpha: 0.45),
        thickness: 1,
        space: 16,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32.sp.clamp(26.0, 36.0),
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28.sp.clamp(23.0, 32.0),
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24.sp.clamp(20.0, 28.0),
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 22.sp.clamp(18.0, 25.0),
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20.sp.clamp(17.0, 23.0),
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18.sp.clamp(16.0, 21.0),
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16.sp.clamp(14.0, 18.0),
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 14.sp.clamp(12.0, 16.0),
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 12.sp.clamp(10.0, 14.0),
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16.sp.clamp(14.0, 18.0),
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
          fontSize: 14.sp.clamp(12.0, 16.0),
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12.sp.clamp(10.0, 14.0),
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14.sp.clamp(12.0, 16.0),
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: textPrimary,
          fontSize: 12.sp.clamp(10.0, 14.0),
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
          fontSize: 10.sp.clamp(9.0, 12.0),
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminThemeTokens.primary,
          foregroundColor: Colors.white,
          elevation: isDark ? 0 : 2,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AdminThemeTokens.primary,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminThemeTokens.primary,
          side: BorderSide(
            color: isDark ? AdminThemeTokens.darkBorder : scheme.outlineVariant,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
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

  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.accentCyan
        : AdminThemeTokens.primary;
  }

  static Color getSurfaceElevated(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkSurfaceElevated
        : AdminThemeTokens.lightSurface;
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
