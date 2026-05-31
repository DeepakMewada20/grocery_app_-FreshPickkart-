import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class CouponsScreen extends StatefulWidget {
  /// If set, this coupon will be visually highlighted on screen open.
  final String? autoApplyCouponCode;

  const CouponsScreen({super.key, this.autoApplyCouponCode});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final client = ServerpodClient().client;
  final networkController = NetworkController.instance;
  List<CouponDisplay> _coupons = [];
  bool _initialLoad = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllCoupons();

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('coupons')) {
          _fetchAllCoupons();
        }
      }
    });
  }

  bool _isHighlighted(CouponDisplay coupon) {
    final code = widget.autoApplyCouponCode;
    if (code == null || code.isEmpty) return false;
    return coupon.code.trim().toLowerCase() == code.trim().toLowerCase();
  }

  Future<void> _fetchAllCoupons() async {
    setState(() {
      _error = null;
    });
    try {
      // Use a large order amount so all active coupons appear with their real isApplicable status
      final coupons = await client.coupon.fetchApplicableCoupons(999999);
      if (mounted) {
        setState(() {
          _coupons = coupons;
          _initialLoad = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load coupons. Pull to refresh.';
          _initialLoad = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text(
          'Available Coupons',
          style: AppTextStyles.screenTitle(context),
        ),
        centerTitle: true,
        actions: [
          if (!_initialLoad && _error == null)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_coupons.length}',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAllCoupons,
        color: AppTheme.primaryGreen,
        child: _initialLoad
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height * 0.55,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.r,
                            color: cs.onSurface.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _error!,
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _coupons.isEmpty
            ? ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height * 0.55,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(28.r),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 56.r,
                              color: cs.onSurface.withValues(alpha: 0.25),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'No Coupons Available',
                            style: GoogleFonts.poppins(
                              color: cs.onSurface,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Check back soon for exciting offers!',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.5),
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.pageHorizontalPadding(context),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: AppResponsive.constrainContent(
                            context: context,
                            child: _CouponListCard(
                              coupon: _coupons[index],
                              isDark: isDark,
                              isHighlighted: _isHighlighted(_coupons[index]),
                            ),
                          ),
                        ),
                        childCount: _coupons.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 32.h)),
                ],
              ),
      ),
    );
  }
}

class _CouponListCard extends StatelessWidget {
  final CouponDisplay coupon;
  final bool isDark;
  final bool isHighlighted;

  const _CouponListCard({
    required this.coupon,
    required this.isDark,
    this.isHighlighted = false,
  });

  Color get _accentColor => AppTheme.primaryGreen;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: coupon.code));
    AppSnackbar.show('Copied!', '"${coupon.code}" copied!');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _copyCode,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: isHighlighted
              ? _accentColor.withValues(alpha: 0.06)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isHighlighted ? _accentColor : cs.outlineVariant,
            width: isHighlighted ? 2 : 1,
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // ─── Top ───
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 50.r,
                    height: 50.r,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accentColor,
                          _accentColor.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Builder(
                      builder: (context) {
                        final cs = Theme.of(context).colorScheme;
                        return Icon(
                          coupon.isDeliveryDiscount
                              ? Icons.local_shipping_rounded
                              : Icons.discount_rounded,
                          color: cs.onPrimary,
                          size: 24.r,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Code + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          coupon.code,
                          style: GoogleFonts.poppins(
                            color: cs.onSurface,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          minFontSize: 12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          coupon.description,
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: 12.5.sp,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Category badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: AutoSizeText(
                      coupon.isDeliveryDiscount ? 'Delivery' : 'Price',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 8,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Dashed divider with notch circles ───
            Row(
              children: [
                Transform.translate(
                  offset: const Offset(-1, 0),
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _accentColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final count = (constraints.maxWidth / 10).floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          count,
                          (_) => Container(
                            width: 4.w,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: cs.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Transform.translate(
                  offset: const Offset(1, 0),
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _accentColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ─── Bottom ───
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final details = Wrap(
                    spacing: 14.w,
                    runSpacing: 8.h,
                    children: [
                      _detail(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Min. Order',
                        value: '₹${coupon.minOrderAmount.formatPrice}',
                        cs: cs,
                      ),
                      if (coupon.discountValue != null)
                        _detail(
                          icon: coupon.type == 'PERCENTAGE_DISCOUNT'
                              ? Icons.percent
                              : Icons.currency_rupee,
                          label: 'Discount',
                          value: coupon.type == 'PERCENTAGE_DISCOUNT'
                              ? '${coupon.discountValue!.formatPrice}% OFF'
                              : '₹${coupon.discountValue!.formatPrice} OFF',
                          cs: cs,
                        ),
                      if (coupon.maxDiscount != null)
                        _detail(
                          icon: Icons.trending_down_rounded,
                          label: 'Upto',
                          value: '₹${coupon.maxDiscount!.formatPrice}',
                          cs: cs,
                        ),
                    ],
                  );
                  final copyButton = _CopyCouponButton(
                    accentColor: _accentColor,
                    onTap: _copyCode,
                  );
                  if (constraints.maxWidth < 330) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        details,
                        SizedBox(height: 12.h),
                        copyButton,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: details),
                      SizedBox(width: 12.w),
                      copyButton,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme cs,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.r, color: cs.onSurface.withValues(alpha: 0.4)),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.4),
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            AutoSizeText(
              value,
              style: GoogleFonts.poppins(
                color: cs.onSurface,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 9,
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}

class _CopyCouponButton extends StatelessWidget {
  const _CopyCouponButton({
    required this.accentColor,
    required this.onTap,
  });

  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor,
            accentColor.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy_rounded,
                  color: cs.onPrimary,
                  size: 15.r,
                ),
                SizedBox(width: 6.w),
                AutoSizeText(
                  'Copy Code',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
