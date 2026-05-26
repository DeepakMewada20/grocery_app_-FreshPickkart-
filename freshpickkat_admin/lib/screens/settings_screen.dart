import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshpickkat_admin/screens/audit_logs_screen.dart';
import 'package:freshpickkat_admin/screens/notification_preferences_screen.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_appearance_section.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Logout',
              style: TextStyle(color: AdminAppTheme.getErrorColor(context)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoggingOut = true);
    try {
      await AdminAuthService().signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } finally {
      if (context.mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final adminLabel = currentUser?.email ?? 'admin@freshpickkart.com';
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AdminAppBar(title: Text('Settings')),
      body: AdminResponsive.constrainContent(
        context: context,
        child: ListView(
          padding: AdminResponsive.pagePadding(context),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r.clamp(42.0, 56.0),
                    backgroundColor: cs.primary.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.person,
                      size: 50.sp.clamp(40.0, 54.0),
                      color: AdminThemeTokens.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('Admin', style: AdminTextStyles.screenTitle(context)),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: cs.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      'Role: ADMIN_SELLER',
                      style: TextStyle(
                        fontSize: 12.sp.clamp(10.0, 13.0),
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    adminLabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp.clamp(14.0, 18.0),
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            const AdminAppearanceSection(),
            SizedBox(height: 16.h),
            _buildSettingsItem(context, Icons.person_outline, 'Profile', () {}),
            _buildSettingsItem(
              context,
              Icons.notifications_outlined,
              'Notification Preferences',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationPreferencesScreen(),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              Icons.lock_outline,
              'Change Password',
              () {},
            ),
            _buildSettingsItem(
              context,
              Icons.help_outline,
              'Help & Support',
              () {},
            ),
            _buildSettingsItem(context, Icons.history, 'Audit Logs', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AuditLogsScreen()),
              );
            }),
            const Divider(),
            _buildSettingsItem(
              context,
              Icons.logout,
              'Logout',
              () => _handleLogout(context),
              isDestructive: true,
              isLoading: _isLoggingOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? AdminAppTheme.getErrorColor(context)
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AdminAppTheme.getErrorColor(context) : null,
        ),
      ),
      trailing: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(
                  isDestructive
                      ? AdminAppTheme.getErrorColor(context)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : Icon(Icons.chevron_right),
      onTap: isLoading ? null : onTap,
      enabled: !isLoading,
    );
  }
}
