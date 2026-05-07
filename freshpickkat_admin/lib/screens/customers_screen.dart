import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: Text('Customers')),
      body: Center(
        child: SingleChildScrollView(
          padding: AdminResponsive.pagePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                size: 72.sp.clamp(54.0, 80.0),
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16.h),
              Text(
                'No Customers Yet',
                textAlign: TextAlign.center,
                style: AdminTextStyles.sectionTitle(
                  context,
                ).copyWith(color: Colors.grey.shade600),
              ),
              SizedBox(height: 8.h),
              Text(
                'Customers will appear here',
                textAlign: TextAlign.center,
                style: AdminTextStyles.body(
                  context,
                ).copyWith(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
