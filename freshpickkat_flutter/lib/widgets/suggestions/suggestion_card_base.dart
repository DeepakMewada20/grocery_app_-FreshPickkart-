import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/theme_controller.dart';

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
    final s = widget.suggestion;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBest = s.isBest ?? false;
    final suggestionTheme = Theme.of(context).extension<AppSuggestionTheme>()!;
    final goldAccent = const Color(0xFFE6A23C);

    final accent = isBest ? goldAccent : suggestionTheme.ctaBackground;
    final cardBg = suggestionTheme.cardBackground;
    final cardBorder = isBest ? accent.withValues(alpha: 0.6) : cardBg;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.width ?? MediaQuery.of(context).size.width * 0.82,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder, width: isBest ? 1.5 : 1),
              boxShadow: [
                BoxShadow(
                  color: isBest
                      ? goldAccent.withValues(alpha: 0.22)
                      : Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: isBest ? 20 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Container(width: 5, color: accent),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
