import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/screens/appearance_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/screens/edit_profile_screen.dart';
import 'package:freshpickkat_flutter/screens/help_support_screen.dart';
import 'package:freshpickkat_flutter/screens/legal_webview_screen.dart';
import 'package:freshpickkat_flutter/screens/location_picker_screen.dart';
import 'package:freshpickkat_flutter/screens/orders_screen.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final networkController = NetworkController.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      UserController.instance.refreshUserDataFromServer();
    });

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('more')) {
          UserController.instance.refreshUserDataFromServer();
        }
      }
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
          padding: EdgeInsets.only(
            bottom: 24.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: AppResponsive.constrainContent(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(userController, cs),
                _buildQuickActions(cs),
                SizedBox(height: 16.h),
                _buildSectionHeader('Your Delivery Address', cs),
                _buildAddressSection(userController, cs),
                SizedBox(height: 16.h),
                _buildAppearanceSection(cs),
                SizedBox(height: 16.h),
                _buildMenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  onTap: () {},
                  cs: cs,
                ),
                _buildMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help & Support',
                  onTap: () => Get.to(() => const HelpSupportScreen()),
                  cs: cs,
                ),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _openLegalPage(
                    title: 'Privacy Policy',
                    fileName: 'privacy-policy.html',
                  ),
                  cs: cs,
                ),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => _openLegalPage(
                    title: 'Terms & Conditions',
                    fileName: 'terms-and-conditions.html',
                  ),
                  cs: cs,
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  onTap: () => _openLegalPage(
                    title: 'FAQ',
                    fileName: 'frequently-asked-questions.html',
                  ),
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
                SizedBox(height: 40.h),
                _buildFooter(cs),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLegalPage({
    required String title,
    required String fileName,
  }) {
    Get.to(
      () => LegalWebViewScreen(
        title: title,
        url: LegalWebViewScreen.docsUrl(fileName),
      ),
    );
  }

  Widget _buildProfileHeader(UserController userController, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          Obx(() {
            final imageUrl = userController.profileImageUrl.value;
            return CircleAvatar(
              radius: 35.r,
              backgroundColor: cs.surfaceContainerHighest,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 40.r, color: cs.onSurface)
                  : null,
            );
          }),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => AutoSizeText(
                    userController.userName.value.isEmpty
                        ? 'Guest User'
                        : userController.userName.value,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'email address',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 14.sp,
                  ),
                ),
                Obx(
                  () => AutoSizeText(
                    userController.userPhone.value,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    minFontSize: 11,
                    overflow: TextOverflow.ellipsis,
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

  Widget _buildQuickActions(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          SizedBox(width: 12.w),
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
        height: 100.h.clamp(86.0, 116.0),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: cs.onSurface, size: 28.r),
            ),
            SizedBox(height: 8.h),
            AutoSizeText(
              label,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
              maxLines: 1,
              minFontSize: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.6),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddressSection(UserController userController, ColorScheme cs) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.location_on, color: cs.onSurface),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(() {
                  final addr = userController.shippingAddress.value;
                  if (addr == null) {
                    return Text(
                      'No address set',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.4),
                        fontSize: 13.sp,
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
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }),
              ),
              IconButton(
                onPressed: () => Get.to(
                  () => LocationPickerScreen(
                    isCheckoutMode: false,
                    initialAddress: userController.shippingAddress.value,
                    addressLabel: 'Home',
                  ),
                ),
                icon: const Icon(
                  Icons.edit,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(ColorScheme cs) {
    final themeController = ThemeController.instance;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.brightness_4, color: cs.onSurface),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Appearance',
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
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
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoSizeText(
                label,
                style: TextStyle(color: cs.onSurface, fontSize: 10.sp),
                minFontSize: 8,
                maxLines: 1,
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: cs.onSurface, size: 22.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
            height: 40.h,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          SizedBox(height: 8.h),
          Text(
            'App Version 8.0.2.0',
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.2),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
