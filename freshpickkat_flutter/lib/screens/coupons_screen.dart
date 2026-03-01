import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final client = ServerpodClient().client;
  List<CouponDisplay> _coupons = [];
  bool _initialLoad = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllCoupons();
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
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (!_initialLoad && _error == null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_coupons.length}',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 13,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: cs.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(0.5),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 56,
                              color: cs.onSurface.withOpacity(0.25),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Coupons Available',
                            style: GoogleFonts.poppins(
                              color: cs.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back soon for exciting offers!',
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(0.5),
                              fontSize: 14,
                            ),
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
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CouponListCard(
                            coupon: _coupons[index],
                            isDark: isDark,
                          ),
                        ),
                        childCount: _coupons.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
      ),
    );
  }
}

class CouponListCard extends StatelessWidget {
  final CouponDisplay coupon;
  final bool isDark;

  const CouponListCard({
    super.key,
    required this.coupon,
    required this.isDark,
  });

  Color get _accentColor => AppTheme.primaryGreen;

  void _copyCode(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Clipboard.setData(ClipboardData(text: coupon.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: cs.onPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              '"${coupon.code}" copied!',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: cs.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _copyCode(context),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cs.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // ─── Top ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accentColor, _accentColor.withOpacity(0.65)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Builder(
                      builder: (context) {
                        final cs = Theme.of(context).colorScheme;
                        return Icon(
                          coupon.isDeliveryDiscount
                              ? Icons.local_shipping_rounded
                              : Icons.discount_rounded,
                          color: cs.onPrimary,
                          size: 24,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Code + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.code,
                          style: GoogleFonts.poppins(
                            color: cs.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          coupon.description,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.55),
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      coupon.isDeliveryDiscount ? 'Delivery' : 'Price',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _accentColor.withOpacity(0.3),
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
                            width: 4,
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
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _accentColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ─── Bottom ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      children: [
                        _detail(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Min. Order',
                          value: '₹${coupon.minOrderAmount.toStringAsFixed(0)}',
                          cs: cs,
                        ),
                        if (coupon.discountValue != null)
                          _detail(
                            icon: coupon.discountType == 'percentage'
                                ? Icons.percent
                                : Icons.currency_rupee,
                            label: 'Discount',
                            value: coupon.discountType == 'percentage'
                                ? '${coupon.discountValue!.toStringAsFixed(0)}% OFF'
                                : '₹${coupon.discountValue!.toStringAsFixed(0)} OFF',
                            cs: cs,
                          ),
                        if (coupon.maxDiscount != null)
                          _detail(
                            icon: Icons.trending_down_rounded,
                            label: 'Upto',
                            value: '₹${coupon.maxDiscount!.toStringAsFixed(0)}',
                            cs: cs,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Copy button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accentColor,
                          _accentColor.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _copyCode(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 9,
                          ),
                          child: Builder(
                            builder: (context) {
                              final cs = Theme.of(context).colorScheme;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.copy_rounded,
                                    color: cs.onPrimary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Copy Code',
                                    style: TextStyle(
                                      color: cs.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
        Icon(icon, size: 12, color: cs.onSurface.withOpacity(0.4)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.4),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: cs.onSurface,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
