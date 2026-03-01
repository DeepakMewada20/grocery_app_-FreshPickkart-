import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/appearance_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/screens/edit_profile_screen.dart';
import 'package:freshpickkat_flutter/screens/orders_screen.dart';
import 'package:get/get.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      UserController.instance.refreshUserDataFromServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;
    final userController = UserController.instance;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(userController, cs),
              _buildMembershipBanner(),
              _buildQuickActions(cs),
              const SizedBox(height: 16),
              _buildSectionHeader('My Activity', cs),
              _buildMenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'My Orders',
                onTap: () => Get.to(() => const OrdersScreen()),
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.local_offer_outlined,
                title: 'My Coupons',
                onTap: () => Get.to(() => const CouponsScreen()),
                cs: cs,
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Your Delivery Address', cs),
              _buildAddressSection(userController, cs),
              const SizedBox(height: 16),
              _buildAppearanceSection(cs),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
                onTap: () {},
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.headset_mic_outlined,
                title: 'Help & Support',
                onTap: () {},
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {},
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'FAQ',
                onTap: () {},
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                onTap: () => Get.to(() => const EditProfileScreen()),
                cs: cs,
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: cs.surfaceContainerHighest,
                      title: Text(
                        'Logout',
                        style: TextStyle(color: cs.onSurface),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            authController.signOut();
                            Get.offAllNamed('/home');
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                cs: cs,
              ),
              const SizedBox(height: 40),
              _buildFooter(cs),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserController userController, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Obx(() {
            final imageUrl = userController.profileImageUrl.value;
            return CircleAvatar(
              radius: 35,
              backgroundColor: cs.surfaceContainerHighest,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 40, color: cs.onSurface)
                  : null,
            );
          }),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    userController.userName.value.isEmpty
                        ? 'Guest User'
                        : userController.userName.value,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'email address',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                Obx(
                  () => Text(
                    userController.userPhone.value,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.to(() => const EditProfileScreen()),
            icon: const Icon(
              Icons.edit,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B8A4C), Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FreshPickKart Membership',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Free Trial Available',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              icon: Icons.receipt_long,
              label: 'My Orders',
              onTap: () => Get.to(() => const OrdersScreen()),
              cs: cs,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              icon: Icons.local_offer_outlined,
              label: 'Coupons',
              onTap: () => Get.to(() => const CouponsScreen()),
              cs: cs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cs.onSurface, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.6),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddressSection(UserController userController, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.location_on, color: cs.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              final addr = userController.shippingAddress.value;
              if (addr == null) {
                return Text(
                  'No address set',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addr.street,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${addr.city}, ${addr.state} ${addr.zipCode}',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/address'),
            icon: const Icon(
              Icons.edit,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(ColorScheme cs) {
    final themeController = ThemeController.instance;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.brightness_4, color: cs.onSurface),
          ),
          const SizedBox(width: 12),
          Text(
            'Appearance',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Obx(() {
            String label;
            switch (themeController.themeMode) {
              case ThemeMode.light:
                label = 'LIGHT';
                break;
              case ThemeMode.dark:
                label = 'DARK';
                break;
              default:
                label = 'SYSTEM DEFAULT';
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: TextStyle(color: cs.onSurface, fontSize: 10),
              ),
            );
          }),
          IconButton(
            onPressed: () => Get.to(() => const AppearanceScreen()),
            icon: const Icon(
              Icons.edit,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cs.onSurface, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: cs.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ColorScheme cs) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'lib/assets/images/logo.png',
            height: 40,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'App Version 8.0.2.0',
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.2),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
