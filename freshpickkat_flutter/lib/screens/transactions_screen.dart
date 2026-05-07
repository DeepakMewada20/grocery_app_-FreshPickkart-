import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: AppResponsive.pagePadding(context),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.sizeOf(context).height -
                kToolbarHeight -
                MediaQuery.paddingOf(context).vertical -
                48.h,
          ),
          child: Center(
            child: AppResponsive.constrainContent(
              context: context,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: AppTheme.primaryGreen,
                      size: 64.r,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'No Transactions Yet',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your payment history will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
