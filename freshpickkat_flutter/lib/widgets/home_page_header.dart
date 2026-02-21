import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';

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
      setState(() {
        _scrollOffset = widget.scrollController!.offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const expandedHeight = 130.0;
    const collapsedHeight = kToolbarHeight;
    final progress = (_scrollOffset / (expandedHeight - collapsedHeight)).clamp(
      0.0,
      1.0,
    );

    final backgroundColor = Color.lerp(
      const Color(0xFF1B8A4C),
      const Color(0xFF1A1A1A),
      progress,
    )!;

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
                          children: const [
                            Text(
                              'Order by Midnight',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
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
