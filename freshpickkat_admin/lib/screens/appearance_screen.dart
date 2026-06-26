import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/theme/admin_theme_controller.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminThemeController>();

    return Scaffold(
      appBar: AdminAppBar(title: const Text('Appearance')),
      body: AdminResponsive.constrainContent(
        context: context,
        child: ListView(
          padding: AdminResponsive.pagePadding(context),
          children: [
            _buildSectionHeader(context, 'Theme Mode'),
            SizedBox(height: 8.h),
            Card(
              child: Padding(
                padding: AdminResponsive.cardPadding(context),
                child: Obx(() {
                  final currentMode = controller.themeMode.value;
                  return Column(
                    children: [
                      _ThemeOptionTile(
                        title: 'Light',
                        subtitle: 'Bright interface for daytime use',
                        icon: Icons.light_mode_rounded,
                        selected: currentMode == ThemeMode.light,
                        onTap: () => controller.setThemeMode(ThemeMode.light),
                      ),
                      SizedBox(height: 10.h),
                      _ThemeOptionTile(
                        title: 'Dark',
                        subtitle: 'Reduced glare for low-light work',
                        icon: Icons.dark_mode_rounded,
                        selected: currentMode == ThemeMode.dark,
                        onTap: () => controller.setThemeMode(ThemeMode.dark),
                      ),
                      SizedBox(height: 10.h),
                      _ThemeOptionTile(
                        title: 'System default',
                        subtitle: 'Follow the device setting',
                        icon: Icons.phone_android_rounded,
                        selected: currentMode == ThemeMode.system,
                        onTap: () => controller.setThemeMode(ThemeMode.system),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15.sp.clamp(13.0, 17.0),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
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
        padding: EdgeInsets.all(14.r),
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
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp.clamp(10.0, 13.0),
                    ),
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
