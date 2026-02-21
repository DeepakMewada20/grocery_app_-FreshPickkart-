import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Theme Mode Section ──────────────────────────────────────────
            Text(
              'Theme Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  _ThemeModeChip(
                    icon: Icons.brightness_auto_outlined,
                    label: 'System',
                    selected: themeController.themeMode == ThemeMode.system,
                    onTap: () => themeController.setThemeMode(ThemeMode.system),
                  ),
                  const SizedBox(width: 10),
                  _ThemeModeChip(
                    icon: Icons.light_mode_outlined,
                    label: 'Light',
                    selected: themeController.themeMode == ThemeMode.light,
                    onTap: () => themeController.setThemeMode(ThemeMode.light),
                  ),
                  const SizedBox(width: 10),
                  _ThemeModeChip(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark',
                    selected: themeController.themeMode == ThemeMode.dark,
                    onTap: () => themeController.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Light Theme Presets Section ─────────────────────────────────
            Row(
              children: [
                Text(
                  'Light Theme Color',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(Light mode only)',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  _PresetCard(
                    preset: LightThemePreset.skyBlue,
                    emoji: '🩵',
                    name: 'Sky Blue',
                    subtitle: 'Cool & refreshing',
                    scaffold: const Color(0xFFF0F6FC),
                    card: const Color(0xFFE3F0FA),
                    text: const Color(0xFF0D2137),
                    selected:
                        themeController.lightPreset == LightThemePreset.skyBlue,
                    onTap: () => themeController.setLightPreset(
                      LightThemePreset.skyBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
            const SizedBox(height: 24),
          ],
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
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primaryGreen
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
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
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : cs.onSurface,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
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
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : cs.outlineVariant,
            width: selected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Mini preview ─────────────────────────────────────────────────
            Container(
              width: 72,
              height: 52,
              decoration: BoxDecoration(
                color: scaffold,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simulated card strip
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 10,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 7,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Simulated green button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    height: 7,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // ── Info ─────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$emoji  $name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Swatches
                  Row(
                    children: [
                      _Swatch(color: scaffold),
                      const SizedBox(width: 5),
                      _Swatch(color: card),
                      const SizedBox(width: 5),
                      _Swatch(color: text),
                      const SizedBox(width: 5),
                      _Swatch(color: AppTheme.primaryGreen),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ── Checkmark ────────────────────────────────────────────────────
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 24,
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
      width: 16,
      height: 16,
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
