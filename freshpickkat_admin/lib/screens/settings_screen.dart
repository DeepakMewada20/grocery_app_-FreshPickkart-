import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshpickkat_admin/screens/audit_logs_screen.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_appearance_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final adminLabel = currentUser?.email ?? 'admin@freshpickkart.com';
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AdminAppBar(title: Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: cs.primary.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Admin',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    'Role: ADMIN_SELLER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  adminLabel,
                  style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const AdminAppearanceSection(),
          const SizedBox(height: 16),
          _buildSettingsItem(context, Icons.person_outline, 'Profile', () {}),
          _buildSettingsItem(
            context,
            Icons.notifications_outlined,
            'Notifications',
            () {},
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AuditLogsScreen()));
          }),
          const Divider(),
          _buildSettingsItem(context, Icons.logout, 'Logout', () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            }
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
