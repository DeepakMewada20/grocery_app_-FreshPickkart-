import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:freshpickkat_admin/controller/admin_dashboard_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AdminAuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndStartLoading();
  }

  Future<void> _checkAuthAndStartLoading() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final hasAccess = await _authService.verifyCurrentSession();
      if (!mounted) return;

      if (hasAccess) {
        AdminDashboardController.instance.loadDashboard();
        AdminProductController.instance.loadInitial();
        AdminCategoryController.instance.loadCategories();
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access denied: Admin/Seller account required'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: AdminResponsive.pagePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 80.r.clamp(58.0, 88.0).toDouble(),
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'FreshPickKart',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.screenTitle(context).copyWith(
                  color: Colors.white,
                  fontSize: 30.sp.clamp(24.0, 34.0).toDouble(),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Admin Panel',
                textAlign: TextAlign.center,
                style: AdminTextStyles.sectionTitle(
                  context,
                ).copyWith(color: Colors.white70),
              ),
              SizedBox(height: 40.h),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
