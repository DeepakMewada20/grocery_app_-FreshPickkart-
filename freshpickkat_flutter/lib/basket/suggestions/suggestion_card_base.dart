import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class SuggestionCardBase extends StatefulWidget {
  final client.BasketSuggestion suggestion;
  final int index;
  final Widget child;
  final double? width;
  final VoidCallback? onTap;

  const SuggestionCardBase({
    super.key,
    required this.suggestion,
    required this.index,
    required this.child,
    this.width,
    this.onTap,
  });

  @override
  State<SuggestionCardBase> createState() => _SuggestionCardBaseState();
}

class _SuggestionCardBaseState extends State<SuggestionCardBase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final suggestionTheme = Theme.of(context).extension<AppSuggestionTheme>()!;

    final accent = suggestionTheme.ctaBackground;
    final cardBg = suggestionTheme.cardBackground;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width:
                widget.width ??
                (MediaQuery.sizeOf(context).width * 0.82)
                    .clamp(
                      280.0,
                      AppResponsive.isTablet(context) ? 360.0 : 340.0,
                    )
                    .toDouble(),
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Thin premium left accent line
                      Container(
                        width: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              accent.withValues(alpha: 0.9),
                              accent.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: widget.child),
                    ],
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
