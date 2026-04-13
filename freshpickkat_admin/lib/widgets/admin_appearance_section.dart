import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/theme/admin_theme_controller.dart';

class AdminAppearanceSection extends StatelessWidget {
  const AdminAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminThemeController>();
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final currentMode = controller.themeMode.value;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how the admin app should look.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              _ThemeOptionTile(
                title: 'Light',
                subtitle: 'Bright interface for daytime use',
                icon: Icons.light_mode_rounded,
                selected: currentMode == ThemeMode.light,
                onTap: () => controller.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(height: 10),
              _ThemeOptionTile(
                title: 'Dark',
                subtitle: 'Reduced glare for low-light work',
                icon: Icons.dark_mode_rounded,
                selected: currentMode == ThemeMode.dark,
                onTap: () => controller.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(height: 10),
              _ThemeOptionTile(
                title: 'System default',
                subtitle: 'Follow the device setting',
                icon: Icons.phone_android_rounded,
                selected: currentMode == ThemeMode.system,
                onTap: () => controller.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = cs.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.08) : cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? accent : cs.outlineVariant,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: accent)
            else
              Icon(Icons.circle_outlined, color: cs.outline),
          ],
        ),
      ),
    );
  }
}
