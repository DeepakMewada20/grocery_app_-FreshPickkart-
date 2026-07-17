import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/basket/reward_celebration_service.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';

/// A self-contained overlay banner that slides down from the top of the screen
/// whenever a [RewardEvent] is emitted by [RewardCelebrationService].
///
/// Features:
/// • Slides in from above (350ms, easeOutBack)
/// • Stays visible for 2.5 seconds
/// • Slides out (300ms, easeIn)
/// • Events queue — if a second reward fires while the first is showing,
///   it is displayed after the current one dismisses.
/// • Fully non-blocking — pointer events pass through the banner.
class RewardBannerOverlay extends StatefulWidget {
  final Widget child;

  const RewardBannerOverlay({super.key, required this.child});

  @override
  State<RewardBannerOverlay> createState() => _RewardBannerOverlayState();
}

class _RewardBannerOverlayState extends State<RewardBannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  RewardEvent? _currentEvent;
  final Queue<RewardEvent> _queue = Queue();
  bool _isShowing = false;
  Timer? _dismissTimer;
  StreamSubscription<RewardEvent>? _sub;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _slideAnim =
        Tween<Offset>(
          begin: const Offset(0, -1.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeIn,
          ),
        );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _sub = RewardCelebrationService.instance.rewardEvents.listen(_onEvent);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _dismissTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onEvent(RewardEvent event) {
    if (_isShowing) {
      _queue.add(event);
      return;
    }
    _showEvent(event);
  }

  void _showEvent(RewardEvent event) {
    if (!mounted) return;
    setState(() {
      _currentEvent = event;
      _isShowing = true;
    });
    _animController.forward(from: 0);
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(milliseconds: 2500), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _animController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _isShowing = false;
        _currentEvent = null;
      });
      if (_queue.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (_queue.isNotEmpty && mounted) {
            _showEvent(_queue.removeFirst());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Banner layer — rendered on top, pointer events pass through when hidden
        if (_currentEvent != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_isShowing,
              child: SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: _RewardBanner(
                    event: _currentEvent!,
                    onDismiss: _dismiss,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal banner card
// ─────────────────────────────────────────────────────────────────────────────
class _RewardBanner extends StatelessWidget {
  final RewardEvent event;
  final VoidCallback onDismiss;

  const _RewardBanner({required this.event, required this.onDismiss});

  IconData get _icon {
    switch (event.type) {
      case RewardType.freeDelivery:
        return Icons.local_shipping_rounded;
      case RewardType.couponApplied:
        return Icons.local_offer_rounded;
      case RewardType.betterCoupon:
        return Icons.trending_up_rounded;
      case RewardType.cashback:
        return Icons.account_balance_wallet_rounded;
      case RewardType.loyaltyPoints:
        return Icons.stars_rounded;
      case RewardType.membership:
        return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF1B4332),
                        const Color(0xFF2D6A4F),
                      ]
                    : [
                        const Color(0xFF1B6B3A),
                        AppTheme.primaryGreen,
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: AppSpacing.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Animated icon container
                  _AnimatedIconBadge(icon: _icon),
                  SizedBox(width: 14.w),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          event.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Dismiss button
                  GestureDetector(
                    onTap: onDismiss,
                    child: Padding(
                      padding: AppSpacing.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: AppIcons.button,
                      ),
                    ),
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

// Bouncing icon badge inside the banner
class _AnimatedIconBadge extends StatefulWidget {
  final IconData icon;
  const _AnimatedIconBadge({required this.icon});

  @override
  State<_AnimatedIconBadge> createState() => _AnimatedIconBadgeState();
}

class _AnimatedIconBadgeState extends State<_AnimatedIconBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.25), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: 22.r,
        ),
      ),
    );
  }
}
