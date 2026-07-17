import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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
      AppLogger.error('Coupons', e);
      if (mounted) {
        setState(() {
          _error = ErrorMessages.couponLoadFailed;
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
          style: AppText.screenTitle(context),
        ),
        centerTitle: true,
        actions: [
          if (!_initialLoad && _error == null)
            Padding(
              padding: AppSpacing.only(right: 16),
              child: Container(
                padding: AppSpacing.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                ),
                child: Text(
                  '${_coupons.length}',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: ScreenScale.sp(13),
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
                            size: ScreenScale.r(64),
                            color: cs.onSurface.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: ScreenScale.h(16)),
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
                                padding: AppSpacing.all(28),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: ScreenScale.r(56),
                              color: cs.onSurface.withValues(alpha: 0.25),
                            ),
                          ),
                          SizedBox(height: ScreenScale.h(24)),
                          Text(
                            'No Coupons Available',
                            style: GoogleFonts.poppins(
                              color: cs.onSurface,
                              fontSize: ScreenScale.sp(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenScale.h(8)),
                          Text(
                            'Check back soon for exciting offers!',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.5),
                              fontSize: ScreenScale.sp(14),
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
                  SliverToBoxAdapter(child: SizedBox(height: ScreenScale.h(16))),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.pageHorizontalPadding(context),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: AppSpacing.only(bottom: 16),
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
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: ScreenScale.h(32) + MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
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
    AppSnackbar.show('Copied!', ErrorMessages.copied(coupon.code));
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
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          border: Border.all(
            color: isHighlighted ? _accentColor : cs.outlineVariant,
            width: isHighlighted ? 2 : 1,
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: Offset(0, ScreenScale.h(4)),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // ─── Top ───
            Padding(
              padding: AppSpacing.only(left: 16, top: 16, right: 16, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: ScreenScale.r(50),
                    height: ScreenScale.r(50),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accentColor,
                          _accentColor.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    child: Builder(
                      builder: (context) {
                        final cs = Theme.of(context).colorScheme;
                        return Icon(
                          coupon.isDeliveryDiscount
                              ? Icons.local_shipping_rounded
                              : Icons.discount_rounded,
                          color: cs.onPrimary,
                          size: AppIcons.large,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(14)),
                  // Code + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          coupon.code,
                          style: GoogleFonts.poppins(
                            color: cs.onSurface,
                            fontSize: ScreenScale.sp(17),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          minFontSize: 12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: ScreenScale.h(3)),
                        Text(
                          coupon.description,
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.55),
                            fontSize: ScreenScale.sp(12.5),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(8)),
                  // Category badge
                  Container(
                    padding: AppSpacing.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: AutoSizeText(
                      coupon.isDeliveryDiscount ? 'Delivery' : 'Price',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: ScreenScale.sp(10),
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
                    width: ScreenScale.r(20),
                    height: ScreenScale.r(20),
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
                            width: ScreenScale.w(4),
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
                    width: ScreenScale.r(20),
                    height: ScreenScale.r(20),
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
              padding: AppSpacing.only(left: 16, top: 12, right: 16, bottom: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final details = Wrap(
                    spacing: ScreenScale.w(14),
                    runSpacing: ScreenScale.h(8),
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
                      if (coupon.type == 'PERCENTAGE_DISCOUNT' && coupon.maxDiscount != null)
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
                        SizedBox(height: ScreenScale.h(12)),
                        copyButton,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: details),
                      SizedBox(width: ScreenScale.w(12)),
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
        Icon(icon, size: AppIcons.tiny, color: cs.onSurface.withValues(alpha: 0.4)),
        SizedBox(width: ScreenScale.w(4)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.4),
                fontSize: ScreenScale.sp(9),
                fontWeight: FontWeight.w500,
              ),
            ),
            AutoSizeText(
              value,
              style: GoogleFonts.poppins(
                color: cs.onSurface,
                fontSize: ScreenScale.sp(11.5),
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
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Padding(
            padding: AppSpacing.symmetric(horizontal: 16, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy_rounded,
                  color: cs.onPrimary,
                  size: ScreenScale.r(15),
                ),
                SizedBox(width: ScreenScale.w(6)),
                AutoSizeText(
                  'Copy Code',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenScale.sp(12),
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
