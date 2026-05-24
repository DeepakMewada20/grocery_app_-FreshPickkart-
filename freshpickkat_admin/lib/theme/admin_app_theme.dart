import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F1512);
  static const Color darkSurface = Color(0xFF161D19);
  static const Color darkSurfaceVariant = Color(0xFF1D2721);
  static const Color darkSurfaceElevated = Color(0xFF1D2721);
  static const Color darkOnSurface = Color(0xFFF3F8F4);
  static const Color darkTextPrimary = Color(0xFFF3F8F4);
  static const Color darkTextSecondary = Color(0xFFAEBBB3);
  static const Color darkBorder = Color(0xFF2E3A33);
  static const Color darkDivider = Color(0xFF2E3A33);
  static const Color darkAccentGreen = Color(0xFF2FBF7A);

  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Accent and status tones used by admin summaries, badges, and maps.
  static const Color toneBlue = Color(0xFF315C73);
  static const Color toneBlueLight = Color(0xFF42A5F5);
  static const Color toneTeal = Color(0xFF2B7A78);
  static const Color toneTealDark = Color(0xFF0F766E);
  static const Color toneGreen = Color(0xFF2F6F4F);
  static const Color toneGreenSoft = Color(0xFF4F7D63);
  static const Color toneIndigo = Color(0xFF46627A);
  static const Color tonePurple = Color(0xFF6A4C93);
  static const Color tonePurpleLight = Color(0xFF7E57C2);
  static const Color tonePink = Color(0xFFC2185B);
  static const Color toneBrown = Color(0xFF7C4D12);
  static const Color toneBrownSoft = Color(0xFF8B5E34);
  static const Color toneSlate = Color(0xFF4E5D6C);
  static const Color toneSteel = Color(0xFF3A5F6F);
  static const Color toneMoss = Color(0xFF5B6B5F);
  static const Color toneNeutral = Color(0xFF66706C);
  static const Color toneOrange = Color(0xFFFFA726);
  static const Color toneDeepOrange = Color(0xFFFF7043);

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
    final primary = isDark
        ? AdminThemeTokens.darkAccentGreen
        : AdminThemeTokens.primary;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          secondary: isDark ? primary : AdminThemeTokens.secondary,
          surface: surface,
          onSurface: onSurface,
          surfaceContainer: isDark
              ? AdminThemeTokens.darkSurface
              : AdminThemeTokens.lightSurface,
          surfaceContainerHigh: isDark
              ? AdminThemeTokens.darkSurfaceVariant
              : AdminThemeTokens.lightSurface,
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
      dialogTheme: isDark
          ? DialogThemeData(
              backgroundColor: surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              titleTextStyle: TextStyle(
                color: textPrimary,
                fontSize: 20.sp.clamp(17.0, 23.0),
                fontWeight: FontWeight.w700,
              ),
              contentTextStyle: TextStyle(
                color: textPrimary,
                fontSize: 14.sp.clamp(12.0, 16.0),
              ),
            )
          : null,
      bottomSheetTheme: isDark
          ? const BottomSheetThemeData(
              backgroundColor: AdminThemeTokens.darkSurface,
              modalBackgroundColor: AdminThemeTokens.darkSurface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
            )
          : null,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark
            ? primary.withValues(alpha: 0.18)
            : AdminThemeTokens.primary.withValues(alpha: 0.14),
        iconTheme: isDark
            ? WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(color: selected ? primary : textSecondary);
              })
            : null,
        labelTextStyle: isDark
            ? WidgetStateProperty.resolveWith(
                (states) => TextStyle(
                  color: states.contains(WidgetState.selected)
                      ? primary
                      : textSecondary,
                  fontSize: 12.sp.clamp(10.0, 13.0),
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              )
            : null,
      ),
      navigationRailTheme: isDark
          ? NavigationRailThemeData(
              backgroundColor: surface,
              selectedIconTheme: IconThemeData(color: primary),
              unselectedIconTheme: IconThemeData(color: textSecondary),
              selectedLabelTextStyle: TextStyle(
                color: primary,
                fontSize: 12.sp.clamp(10.0, 13.0),
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: textSecondary,
                fontSize: 12.sp.clamp(10.0, 13.0),
                fontWeight: FontWeight.w500,
              ),
              indicatorColor: primary.withValues(alpha: 0.18),
            )
          : null,
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: isDark
            ? AdminThemeTokens.darkTextSecondary
            : AdminThemeTokens.primary.withValues(alpha: 0.72),
        indicatorColor: primary,
        dividerColor: isDark
            ? AdminThemeTokens.darkDivider
            : Colors.transparent,
      ),
      chipTheme: isDark
          ? ChipThemeData(
              backgroundColor: AdminThemeTokens.darkSurfaceElevated,
              selectedColor: primary.withValues(alpha: 0.18),
              disabledColor: AdminThemeTokens.darkSurface.withValues(
                alpha: 0.6,
              ),
              labelStyle: TextStyle(color: textPrimary),
              secondaryLabelStyle: TextStyle(color: primary),
              checkmarkColor: primary,
              side: const BorderSide(color: AdminThemeTokens.darkBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            )
          : null,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
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
            color: isDark ? primary : AdminThemeTokens.primary,
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
        prefixIconColor: isDark ? AdminThemeTokens.darkTextSecondary : null,
        suffixIconColor: isDark ? AdminThemeTokens.darkTextSecondary : null,
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
          backgroundColor: primary,
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
          foregroundColor: primary,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(
            color: isDark ? AdminThemeTokens.darkBorder : scheme.outlineVariant,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      popupMenuTheme: isDark
          ? PopupMenuThemeData(
              color: surface,
              surfaceTintColor: Colors.transparent,
              iconColor: textSecondary,
              textStyle: TextStyle(color: textPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            )
          : null,
      snackBarTheme: isDark
          ? SnackBarThemeData(
              backgroundColor: AdminThemeTokens.darkSurfaceElevated,
              contentTextStyle: const TextStyle(color: Colors.white),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            )
          : null,
      switchTheme: isDark
          ? SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return primary;
                return AdminThemeTokens.darkTextSecondary;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return primary.withValues(alpha: 0.35);
                }
                return AdminThemeTokens.darkBorder;
              }),
            )
          : null,
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

  static Color getSubtleBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkBorder
        : Colors.grey.shade200;
  }

  static Color getInputSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkSurfaceElevated
        : Colors.grey.shade50;
  }

  static Color getImagePlaceholderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkSurfaceElevated
        : Colors.grey.shade100;
  }

  static Color getErrorContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AdminThemeTokens.darkError.withValues(alpha: 0.14)
        : Colors.red.shade50;
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return isDark(context)
        ? AdminThemeTokens.darkTextPrimary
        : AdminThemeTokens.lightTextPrimary;
  }

  static Color getSurfaceColor(BuildContext context) {
    return isDark(context)
        ? AdminThemeTokens.darkSurface
        : AdminThemeTokens.lightSurface;
  }

  static Color getSubtleSurfaceColor(BuildContext context) {
    return isDark(context)
        ? AdminThemeTokens.darkSurfaceVariant
        : Colors.grey.shade100;
  }

  static Color getMutedIconColor(BuildContext context) {
    return isDark(context)
        ? AdminThemeTokens.darkTextSecondary
        : Colors.grey.shade400;
  }

  static Color getNeutralColor(BuildContext context) {
    return isDark(context)
        ? AdminThemeTokens.darkTextSecondary
        : Colors.grey.shade600;
  }

  static Color getScrimShadowColor(
    BuildContext context, {
    double alpha = 0.08,
  }) {
    return Colors.black.withValues(alpha: isDark(context) ? alpha * 2 : alpha);
  }

  static Color getStatusContainerColor(BuildContext context, Color color) {
    return color.withValues(alpha: isDark(context) ? 0.18 : 0.12);
  }

  static Color getSuccessContainerColor(BuildContext context) {
    return getSuccessColor(
      context,
    ).withValues(alpha: isDark(context) ? 0.18 : 0.12);
  }

  static Color getWarningContainerColor(BuildContext context) {
    return getWarningColor(
      context,
    ).withValues(alpha: isDark(context) ? 0.18 : 0.14);
  }

  static Color getInfoContainerColor(BuildContext context) {
    return getInfoColor(
      context,
    ).withValues(alpha: isDark(context) ? 0.18 : 0.12);
  }

  static Color getNeutralContainerColor(BuildContext context) {
    return getNeutralColor(
      context,
    ).withValues(alpha: isDark(context) ? 0.16 : 0.14);
  }

  static Color getPurpleColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFD3B8FF)
        : AdminThemeTokens.tonePurple;
  }

  static Color getDeepPurpleColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFC7B7FF)
        : AdminThemeTokens.tonePurpleLight;
  }

  static Color getTealColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF7DE3D7)
        : AdminThemeTokens.toneTeal;
  }

  static Color getIndigoColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFAEC9FF)
        : AdminThemeTokens.toneIndigo;
  }

  static Color getPinkColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFFFB1D0)
        : AdminThemeTokens.tonePink;
  }

  static Color getBlueGreyColor(BuildContext context) {
    return isDark(context) ? const Color(0xFFC3D1D8) : Colors.blueGrey.shade700;
  }

  static Color getDeepOrangeColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFFFB194)
        : AdminThemeTokens.toneDeepOrange;
  }

  static Color getToneColor(BuildContext context, Color lightColor) {
    if (!isDark(context)) return lightColor;
    if (lightColor == AdminThemeTokens.toneBlue ||
        lightColor == AdminThemeTokens.toneBlueLight) {
      return getInfoColor(context);
    }
    if (lightColor == AdminThemeTokens.toneTeal ||
        lightColor == AdminThemeTokens.toneTealDark) {
      return getTealColor(context);
    }
    if (lightColor == AdminThemeTokens.toneGreen ||
        lightColor == AdminThemeTokens.toneGreenSoft ||
        lightColor == AdminThemeTokens.success) {
      return getSuccessColor(context);
    }
    if (lightColor == AdminThemeTokens.toneOrange ||
        lightColor == AdminThemeTokens.toneBrown ||
        lightColor == AdminThemeTokens.toneBrownSoft) {
      return getWarningColor(context);
    }
    if (lightColor == AdminThemeTokens.tonePurple ||
        lightColor == AdminThemeTokens.tonePurpleLight) {
      return getPurpleColor(context);
    }
    if (lightColor == AdminThemeTokens.toneDeepOrange) {
      return getDeepOrangeColor(context);
    }
    if (lightColor == AdminThemeTokens.error) {
      return getErrorColor(context);
    }
    return lightColor;
  }

  static Color getOrderStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'placed':
      case 'pending':
        return getWarningColor(context);
      case 'packed':
        return getDeepPurpleColor(context);
      case 'confirmed':
        return getInfoColor(context);
      case 'out_for_delivery':
        return getDeepOrangeColor(context);
      case 'delivered':
        return getSuccessColor(context);
      case 'cancelled':
        return getErrorColor(context);
      default:
        return getNeutralColor(context);
    }
  }
}
