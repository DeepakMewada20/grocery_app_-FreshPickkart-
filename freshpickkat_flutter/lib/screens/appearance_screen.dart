import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Appearance',
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: AppResponsive.pagePadding(context).copyWith(
          bottom: ScreenScale.h(24) + MediaQuery.paddingOf(context).bottom,
        ),
        child: AppResponsive.constrainContent(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Theme Mode Section ──────────────────────────────────────────
              Text(
                'Theme Mode',
                style: TextStyle(
                  fontSize: ScreenScale.sp(16),
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: ScreenScale.h(12)),
              Obx(
                () => Row(
                  children: [
                    _ThemeModeChip(
                      icon: Icons.brightness_auto_outlined,
                      label: 'System',
                      selected: themeController.themeMode == ThemeMode.system,
                      onTap: () =>
                          themeController.setThemeMode(ThemeMode.system),
                    ),
                    SizedBox(width: ScreenScale.w(10)),
                    _ThemeModeChip(
                      icon: Icons.light_mode_outlined,
                      label: 'Light',
                      selected: themeController.themeMode == ThemeMode.light,
                      onTap: () =>
                          themeController.setThemeMode(ThemeMode.light),
                    ),
                    SizedBox(width: ScreenScale.w(10)),
                    _ThemeModeChip(
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark',
                      selected: themeController.themeMode == ThemeMode.dark,
                      onTap: () => themeController.setThemeMode(ThemeMode.dark),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ScreenScale.h(32)),

              // ── Light Theme Presets Section ─────────────────────────────────
              Row(
                children: [
                  Text(
                    'Light Theme Color',
                    style: TextStyle(
                      fontSize: ScreenScale.sp(16),
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(6)),
                  Flexible(
                    child: Text(
                      '(Light mode only)',
                      style: TextStyle(
                        fontSize: ScreenScale.sp(12),
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenScale.h(14)),
              Obx(
                () => Column(
                  children: [
                    _PresetCard(
                      preset: LightThemePreset.sageGreen,
                      emoji: '🌿',
                      name: 'Sage Green',
                      subtitle: 'Fresh & natural',
                      scaffold: const Color(0xFFF7F9F4),
                      card: const Color(0xFFEFF5EC),
                      text: const Color(0xFF1C2B1E),
                      selected:
                          themeController.lightPreset ==
                          LightThemePreset.sageGreen,
                      onTap: () => themeController.setLightPreset(
                        LightThemePreset.sageGreen,
                      ),
                    ),
                    SizedBox(height: ScreenScale.h(10)),
                    _PresetCard(
                      preset: LightThemePreset.warmCream,
                      emoji: '🍞',
                      name: 'Warm Cream',
                      subtitle: 'Cozy & inviting',
                      scaffold: const Color(0xFFFBF7F0),
                      card: const Color(0xFFF5EDE0),
                      text: const Color(0xFF2C1E0F),
                      selected:
                          themeController.lightPreset ==
                          LightThemePreset.warmCream,
                      onTap: () => themeController.setLightPreset(
                        LightThemePreset.warmCream,
                      ),
                    ),
                    SizedBox(height: ScreenScale.h(10)),
                    _PresetCard(
                      preset: LightThemePreset.skyBlue,
                      emoji: '🩵',
                      name: 'Sky Blue',
                      subtitle: 'Cool & refreshing',
                      scaffold: const Color(0xFFF0F6FC),
                      card: const Color(0xFFE3F0FA),
                      text: const Color(0xFF0D2137),
                      selected:
                          themeController.lightPreset ==
                          LightThemePreset.skyBlue,
                      onTap: () => themeController.setLightPreset(
                        LightThemePreset.skyBlue,
                      ),
                    ),
                    SizedBox(height: ScreenScale.h(10)),
                    _PresetCard(
                      preset: LightThemePreset.roseBlush,
                      emoji: '🌸',
                      name: 'Rose Blush',
                      subtitle: 'Soft & delicate',
                      scaffold: const Color(0xFFFDF5F7),
                      card: const Color(0xFFF8E8EE),
                      text: const Color(0xFF2E0F1A),
                      selected:
                          themeController.lightPreset ==
                          LightThemePreset.roseBlush,
                      onTap: () => themeController.setLightPreset(
                        LightThemePreset.roseBlush,
                      ),
                    ),
                    SizedBox(height: ScreenScale.h(10)),
                    _PresetCard(
                      preset: LightThemePreset.lavender,
                      emoji: '💜',
                      name: 'Lavender',
                      subtitle: 'Calm & elegant',
                      scaffold: const Color(0xFFF6F3FC),
                      card: const Color(0xFFEDE8F8),
                      text: const Color(0xFF1A1030),
                      selected:
                          themeController.lightPreset ==
                          LightThemePreset.lavender,
                      onTap: () => themeController.setLightPreset(
                        LightThemePreset.lavender,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenScale.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme Mode Chip (System / Light / Dark)
// ─────────────────────────────────────────────────────────────────────────────
class _ThemeModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeModeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppSpacing.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primaryGreen
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: selected ? AppTheme.primaryGreen : cs.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.white
                    : cs.onSurface.withValues(alpha: 0.6),
                size: ScreenScale.r(22),
              ),
              SizedBox(height: ScreenScale.h(4)),
              AutoSizeText(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : cs.onSurface,
                  fontSize: ScreenScale.sp(11),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                minFontSize: 8,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Preset Card with Color Preview
// ─────────────────────────────────────────────────────────────────────────────
class _PresetCard extends StatelessWidget {
  final LightThemePreset preset;
  final String emoji;
  final String name;
  final String subtitle;
  final Color scaffold;
  final Color card;
  final Color text;
  final bool selected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.emoji,
    required this.name,
    required this.subtitle,
    required this.scaffold,
    required this.card,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: AppSpacing.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : cs.outlineVariant,
            width: selected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Mini preview ─────────────────────────────────────────────────
            Container(
              width: ScreenScale.w(72).clamp(58.0, 82.0).toDouble(),
              height: ScreenScale.h(52).clamp(42.0, 58.0).toDouble(),
              decoration: BoxDecoration(
                color: scaffold,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simulated card strip
                  Container(
                    margin: AppSpacing.symmetric(horizontal: 6),
                    height: ScreenScale.h(10),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                  ),
                  SizedBox(height: ScreenScale.h(4)),
                  Container(
                    margin: AppSpacing.symmetric(horizontal: 10),
                    height: ScreenScale.h(7),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                  ),
                  SizedBox(height: ScreenScale.h(6)),
                  // Simulated green button
                  Container(
                    margin: AppSpacing.symmetric(horizontal: 14),
                    height: ScreenScale.h(7),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenScale.w(16)),
            // ── Info ─────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '$emoji  $name',
                    style: TextStyle(
                      fontSize: ScreenScale.sp(15),
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                    minFontSize: 11,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenScale.h(3)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ScreenScale.sp(12),
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenScale.h(8)),
                  // Swatches
                  Row(
                    children: [
                      _Swatch(color: scaffold),
                      SizedBox(width: ScreenScale.w(5)),
                      _Swatch(color: card),
                      SizedBox(width: ScreenScale.w(5)),
                      _Swatch(color: text),
                      SizedBox(width: ScreenScale.w(5)),
                      _Swatch(color: AppTheme.primaryGreen),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenScale.w(8)),
            // ── Checkmark ────────────────────────────────────────────────────
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: AppIcons.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  const _Swatch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenScale.r(16),
      height: ScreenScale.r(16),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
    );
  }
}
