import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class FreshPickKartHeader extends StatelessWidget {
  final double scrollOffset;
  final double expandedHeight;
  final double collapsedHeight;

  const FreshPickKartHeader({
    super.key,
    required this.scrollOffset,
    this.expandedHeight = 170,
    this.collapsedHeight = kToolbarHeight + 60,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppTheme.primaryGreen;

    // Animation range: from 0 to (expandedHeight - kToolbarHeight)
    final animationRange = expandedHeight - kToolbarHeight;
    final progress = (scrollOffset / animationRange).clamp(0.0, 1.0);

    final backgroundColor =
        Color.lerp(
          primaryColor,
          isDark ? const Color(0xFF1A1A1A) : Colors.white,
          progress,
        ) ??
        (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    // Calculate dynamic height
    // Prevent stretching by clamping scrollOffset to >= 0
    final currentHeight =
        (expandedHeight - scrollOffset.clamp(0.0, animationRange));

    return Container(
      width: double.infinity,
      height: currentHeight.clamp(collapsedHeight, expandedHeight),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: progress > 0.9
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: AppRadius.medium,
                  offset: Offset(0, ScreenScale.h(2)),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Logo and Tagline Row (Fades out earlier to avoid overlap)
          Positioned(
            top: MediaQuery.of(context).padding.top + ScreenScale.h(10),
            left: ScreenScale.w(12),
            right: ScreenScale.w(12),
            child: Opacity(
              opacity: (1.0 - progress * 2.0).clamp(0.0, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "lib/assets/images/name_logo.png",
                    height: AppResponsive.isLandscape(context) ? ScreenScale.h(40) : ScreenScale.h(50),
                    fit: BoxFit.contain,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Order by Midnight',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : (progress < 0.5
                                      ? Colors.white
                                      : Colors.black),
                            fontSize: ScreenScale.sp(14),
                          ),
                        ),
                        Text(
                          'Delivery by 7 AM',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenScale.sp(14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar (Always at the bottom)
          Positioned(
            bottom: ScreenScale.h(12),
            left: ScreenScale.w(12),
            right: ScreenScale.w(10),
            child: const SearchBarWidget(),
          ),
        ],
      ),
    );
  }
}

class FreshPickKartSliverAppBar extends StatefulWidget {
  final ScrollController? scrollController;

  const FreshPickKartSliverAppBar({
    super.key,
    this.scrollController,
  });

  @override
  State<FreshPickKartSliverAppBar> createState() =>
      _FreshPickKartSliverAppBarState();
}

class _FreshPickKartSliverAppBarState extends State<FreshPickKartSliverAppBar> {
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController != null &&
        widget.scrollController!.hasClients) {
      if (mounted) {
        setState(() {
          _scrollOffset = widget.scrollController!.offset;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppTheme.primaryGreen;

    final expandedHeight = ScreenScale.h(130);
    const collapsedHeight = kToolbarHeight;
    final progress = (_scrollOffset / (expandedHeight - collapsedHeight)).clamp(
      0.0,
      1.0,
    );

    final backgroundColor =
        Color.lerp(
          primaryColor,
          isDark ? const Color(0xFF1A1A1A) : Colors.white,
          progress,
        ) ??
        (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: expandedHeight,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(ScreenScale.h(5)),
        child: Padding(
          padding: AppSpacing.only(left: 12, top: 2, right: 10, bottom: 12),
          child: SearchBarWidget(),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: backgroundColor,
            child: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: AppSpacing.only(left: 12, right: 12),
                  child: Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/images/name_logo.png",
                          height: ScreenScale.h(60),
                          fit: BoxFit.contain,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Order by Midnight',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: ScreenScale.sp(15),
                              ),
                            ),
                            Text(
                              'Delivery by 7 AM',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenScale.sp(15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
