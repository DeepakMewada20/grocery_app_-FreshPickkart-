import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 72.r),
                  SizedBox(height: 12.h),
                  Text('Wallet', style: AppTextStyles.screenTitle(context)),
                  SizedBox(height: 8.h),
                  Text('Placeholder', style: AppTextStyles.caption(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
