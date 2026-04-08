import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';

class FreshPickKartHeader extends StatelessWidget {
  final double scrollOffset;
  final double expandedHeight;
  final double collapsedHeight;

  const FreshPickKartHeader({
    super.key,
    required this.scrollOffset,
    this.expandedHeight = 170.0,
    this.collapsedHeight = kToolbarHeight + 60,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppTheme.primaryGreen;

    // Animation range: from 0 to (expandedHeight - kToolbarHeight)
    final animationRange = expandedHeight - kToolbarHeight;
    final progress = (scrollOffset / animationRange).clamp(0.0, 1.0);

    final backgroundColor = Color.lerp(
      primaryColor,
      isDark ? const Color(0xFF1A1A1A) : Colors.white,
      progress,
    ) ?? (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    // Calculate dynamic height
    // Prevent stretching by clamping scrollOffset to >= 0
    final currentHeight = (expandedHeight - scrollOffset.clamp(0.0, animationRange));

    return Container(
      width: double.infinity,
      height: currentHeight.clamp(collapsedHeight, expandedHeight),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: progress > 0.9 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ] : null,
      ),
      child: Stack(
        children: [
          // Logo and Tagline Row (Fades out earlier to avoid overlap)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            right: 12,
            child: Opacity(
              opacity: (1.0 - progress * 2.0).clamp(0.0, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "lib/assets/images/name_logo.png",
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Order by Midnight',
                        style: TextStyle(
                          color: isDark ? Colors.white : (progress < 0.5 ? Colors.white : Colors.black),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Delivery by 7 AM',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Search Bar (Always at the bottom)
          Positioned(
            bottom: 12,
            left: 12,
            right: 10,
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

    const expandedHeight = 130.0;
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
        preferredSize: const Size.fromHeight(5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 10, 12),
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
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/images/name_logo.png",
                          height: 60,
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
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              'Delivery by 7 AM',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
