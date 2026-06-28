import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_category_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class OffersDashboardTab extends StatelessWidget {
  const OffersDashboardTab({
    super.key,
    required this.couponController,
    required this.bogoController,
    required this.categoryOfferController,
    required this.comboOfferController,
    required this.freeDeliveryController,
    required this.bannerController,
  });

  final AdminCouponController couponController;
  final AdminBogoController bogoController;
  final AdminCategoryOfferController categoryOfferController;
  final AdminComboOfferController comboOfferController;
  final AdminFreeDeliveryController freeDeliveryController;
  final AdminBannerController bannerController;

  bool _isLive(DateTime? startDate, DateTime? endDate, bool isActive) {
    if (!isActive) return false;
    final now = DateTime.now();
    if (startDate != null && startDate.isAfter(now)) return false;
    if (endDate != null && endDate.isBefore(now)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupons = couponController.coupons;
      final bogoOffers = bogoController.bogoOffers;
      final categoryOffers = categoryOfferController.categoryOffers;
      final comboOffers = comboOfferController.comboOffers;
      final freeDeliveryRules = freeDeliveryController.deliveryRules;
      final banners = bannerController.banners;
      final totalBogo = bogoController.totalCount.value;
      final totalCategoryOffers = categoryOfferController.totalCount.value;
      final totalComboOffers = comboOfferController.totalCount.value;
      final totalDeliveryRules = freeDeliveryController.totalCount.value;
      final totalBanners = bannerController.totalCount.value;

      final liveCoupons = coupons.where((coupon) {
        return _isLive(coupon.startDate, coupon.endDate, coupon.isActive);
      }).length;
      final liveBogo = bogoOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveCategory = categoryOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveCombo = comboOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveDelivery = freeDeliveryRules.where((rule) {
        return _isLive(rule.startDate, rule.endDate, rule.isActive);
      }).length;
      final activeBanners = banners.where((banner) => banner.active).length;

      final totalOffers = totalBogo + totalCategoryOffers + totalComboOffers;
      final liveOffers = liveBogo + liveCategory + liveCombo;

      return AdminResponsive.constrainContent(
        context: context,
        child: ListView(
          padding: AdminResponsive.pagePadding(
            context,
          ).copyWith(bottom: AdminResponsive.bottomInset(context)),
          children: [
            // ── Header ──
            Text(
              'Offers Dashboard',
              style: AdminTextStyles.screenTitle(context),
            ),
            SizedBox(height: 6.h),
            Text(
              'Overview of all offers, banners, and delivery rules',
              style: AdminTextStyles.caption(context),
            ),

            SizedBox(height: 20.h),

            // ── Quick Stats Bar ──
            _QuickStatsBar(
              liveOffers: liveOffers,
              liveCoupons: liveCoupons,
              activeBanners: activeBanners,
              liveDelivery: liveDelivery,
            ),

            SizedBox(height: 20.h),

            // ── Summary Stat Cards ──
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = AdminResponsive.statColumnsForWidth(
                  constraints.maxWidth,
                );
                final cards = [
                  _SummaryStatCard(
                    title: 'Coupons',
                    value: '${coupons.length}',
                    icon: Icons.sell_outlined,
                    color: AdminAppTheme.getInfoColor(context),
                    liveCount: liveCoupons,
                  ),
                  _SummaryStatCard(
                    title: 'Offers',
                    value: '$totalOffers',
                    icon: Icons.local_offer_outlined,
                    color: AdminAppTheme.getSuccessColor(context),
                    liveCount: liveOffers,
                  ),
                  _SummaryStatCard(
                    title: 'Delivery Rules',
                    value: '$totalDeliveryRules',
                    icon: Icons.local_shipping_outlined,
                    color: AdminAppTheme.getWarningColor(context),
                    liveCount: liveDelivery,
                  ),
                  _SummaryStatCard(
                    title: 'Banners',
                    value: '$totalBanners',
                    icon: Icons.image_outlined,
                    color: AdminAppTheme.getPinkColor(context),
                    liveCount: activeBanners,
                    liveLabel: 'Active',
                  ),
                ];

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: columns == 2 ? 1.12 : 1.42,
                  ),
                  itemBuilder: (context, index) => cards[index],
                );
              },
            ),

            SizedBox(height: 28.h),

            // ── Offer Programs Section ──
            Text(
              'Offer Programs',
              style: AdminTextStyles.sectionTitle(context),
            ),
            SizedBox(height: 4.h),
            Text(
              'BOGO, Category, and Combo offers breakdown',
              style: AdminTextStyles.caption(context),
            ),
            SizedBox(height: 14.h),

            _OfferProgramCard(
              title: 'BOGO Offers',
              subtitle: 'Buy One Get One deals',
              icon: Icons.card_giftcard,
              accentColor: AdminAppTheme.getTealColor(context),
              totalCount: totalBogo,
              liveCount: liveBogo,
            ),
            SizedBox(height: 12.h),
            _OfferProgramCard(
              title: 'Category Offers',
              subtitle: 'Discounts on entire categories',
              icon: Icons.category_outlined,
              accentColor: AdminAppTheme.getIndigoColor(context),
              totalCount: totalCategoryOffers,
              liveCount: liveCategory,
            ),
            SizedBox(height: 12.h),
            _OfferProgramCard(
              title: 'Combo Offers',
              subtitle: 'Bundle product deals',
              icon: Icons.widgets_outlined,
              accentColor: AdminAppTheme.getSuccessColor(context),
              totalCount: totalComboOffers,
              liveCount: liveCombo,
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Stats Bar
// ─────────────────────────────────────────────────────────────────────────────

class _QuickStatsBar extends StatelessWidget {
  const _QuickStatsBar({
    required this.liveOffers,
    required this.liveCoupons,
    required this.activeBanners,
    required this.liveDelivery,
  });

  final int liveOffers;
  final int liveCoupons;
  final int activeBanners;
  final int liveDelivery;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = AdminAppTheme.isDark(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? AdminThemeTokens.darkSurfaceVariant
            : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, color: cs.primary, size: 20.r),
          SizedBox(width: 10.w),
          Text(
            'Live Now',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.sp.clamp(11.0, 15.0),
              color: cs.onSurface,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickStatChip(
                    label: 'Offers',
                    count: liveOffers,
                    color: AdminAppTheme.getSuccessColor(context),
                  ),
                  SizedBox(width: 10.w),
                  _QuickStatChip(
                    label: 'Coupons',
                    count: liveCoupons,
                    color: AdminAppTheme.getInfoColor(context),
                  ),
                  SizedBox(width: 10.w),
                  _QuickStatChip(
                    label: 'Banners',
                    count: activeBanners,
                    color: AdminAppTheme.getPinkColor(context),
                  ),
                  SizedBox(width: 10.w),
                  _QuickStatChip(
                    label: 'Delivery',
                    count: liveDelivery,
                    color: AdminAppTheme.getWarningColor(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatChip extends StatelessWidget {
  const _QuickStatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: AdminAppTheme.isDark(context) ? 0.16 : 0.1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 0) ...[_PulsingDot(color: color), SizedBox(width: 5.w)],
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11.sp.clamp(10.0, 13.0),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Stat Card (matches main dashboard stat card style)
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.liveCount,
    this.liveLabel = 'Live',
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int liveCount;
  final String liveLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = AdminAppTheme.isDark(context);

    return Card(
      elevation: isDark ? 1 : 2,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Circular icon container
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.16 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20.r),
                ),
                const Spacer(),
                // Live pill
                _LiveStatusPill(
                  count: liveCount,
                  label: liveLabel,
                  color: color,
                ),
              ],
            ),
            const Spacer(),
            AutoSizeText(
              value,
              style: AdminTextStyles.statValue(context),
              maxLines: 1,
              minFontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                color: AdminAppTheme.getTextSecondaryColor(context),
                fontSize: 12.sp.clamp(10.0, 14.0),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveStatusPill extends StatelessWidget {
  const _LiveStatusPill({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = AdminAppTheme.isDark(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.16 : 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 0) ...[
            _PulsingDot(color: color, size: 6),
            SizedBox(width: 4.w),
          ],
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 10.sp.clamp(9.0, 12.0),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Offer Program Card (detailed breakdown card with accent bar)
// ─────────────────────────────────────────────────────────────────────────────

class _OfferProgramCard extends StatelessWidget {
  const _OfferProgramCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.totalCount,
    required this.liveCount,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final int totalCount;
  final int liveCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = AdminAppTheme.isDark(context);
    final fraction = totalCount == 0 ? 0.0 : (liveCount / totalCount);

    return Card(
      elevation: isDark ? 1 : 2,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Left accent bar ──
              Container(
                width: 5.w.clamp(4.0, 6.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [accentColor, accentColor.withValues(alpha: 0.4)],
                  ),
                ),
              ),

              // ── Card body ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Icon container
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(
                                alpha: isDark ? 0.16 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(icon, color: accentColor, size: 22.r),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AdminTextStyles.cardTitle(context),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  subtitle,
                                  style: AdminTextStyles.caption(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Total count badge
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$totalCount',
                                style: TextStyle(
                                  fontSize: 24.sp.clamp(20.0, 30.0),
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 11.sp.clamp(9.0, 12.0),
                                  color: AdminAppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      // ── Progress bar + live count ──
                      Row(
                        children: [
                          _LiveStatusPill(
                            count: liveCount,
                            label: 'Live',
                            color: accentColor,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: LinearProgressIndicator(
                                    value: fraction,
                                    minHeight: 6.h.clamp(4.0, 8.0),
                                    backgroundColor: accentColor.withValues(
                                      alpha: isDark ? 0.12 : 0.08,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      accentColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  totalCount == 0
                                      ? 'No offers'
                                      : '${(fraction * 100).toInt()}% live',
                                  style: TextStyle(
                                    fontSize: 10.sp.clamp(9.0, 12.0),
                                    fontWeight: FontWeight.w600,
                                    color: AdminAppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing Dot Indicator (micro-animation for "live" status)
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.45,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
