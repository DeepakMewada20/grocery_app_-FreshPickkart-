import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/basket/reward_celebration_service.dart';

/// Wraps any widget with a confetti burst layer.
/// Self-contained — listens to [RewardCelebrationService.rewardEvents]
/// and plays confetti automatically when a reward unlocks.
class ConfettiBurstWidget extends StatefulWidget {
  final Widget child;

  const ConfettiBurstWidget({super.key, required this.child});

  @override
  State<ConfettiBurstWidget> createState() => _ConfettiBurstWidgetState();
}

class _ConfettiBurstWidgetState extends State<ConfettiBurstWidget> {
  late final ConfettiController _leftController;
  late final ConfettiController _rightController;
  StreamSubscription<RewardEvent>? _sub;

  @override
  void initState() {
    super.initState();
    _leftController = ConfettiController(
      duration: const Duration(milliseconds: 1200),
    );
    _rightController = ConfettiController(
      duration: const Duration(milliseconds: 1200),
    );

    _sub = RewardCelebrationService.instance.rewardEvents.listen((_) {
      _play();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  void _play() {
    if (!mounted) return;
    _leftController.play();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _rightController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Left cannon — fires toward right-down
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _leftController,
            blastDirection: math.pi / 4, // 45° down-right
            blastDirectionality: BlastDirectionality.directional,
            emissionFrequency: 0.08,
            numberOfParticles: 18,
            maxBlastForce: 35,
            minBlastForce: 18,
            gravity: 0.3,
            particleDrag: 0.05,
            colors: _confettiColors,
            strokeWidth: 0,
            strokeColor: Colors.transparent,
          ),
        ),

        // Right cannon — fires toward left-down
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _rightController,
            blastDirection: math.pi * 3 / 4, // 135° down-left
            blastDirectionality: BlastDirectionality.directional,
            emissionFrequency: 0.08,
            numberOfParticles: 18,
            maxBlastForce: 35,
            minBlastForce: 18,
            gravity: 0.3,
            particleDrag: 0.05,
            colors: _confettiColors,
            strokeWidth: 0,
            strokeColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  static const List<Color> _confettiColors = [
    Color(0xFF2ECC71), // brand green
    Color(0xFFFFD700), // gold
    Color(0xFFF39C12), // amber
    Color(0xFF3498DB), // blue
    Color(0xFFE74C3C), // red
    Color(0xFF9B59B6), // purple
    Color(0xFFFFFFFF), // white
    Color(0xFFFF6B6B), // coral
  ];
}
