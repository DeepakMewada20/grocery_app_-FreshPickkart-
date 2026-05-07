import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
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
              child: Text(
                'Search Screen',
                style: AppTextStyles.screenTitle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
