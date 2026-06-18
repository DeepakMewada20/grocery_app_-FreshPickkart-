import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

// ─────────────────────────────────────────────
// REWARD TYPE ENUM — extend for future rewards
// ─────────────────────────────────────────────
enum RewardType {
  freeDelivery,
  couponApplied,
  betterCoupon,
  cashback, // future
  loyaltyPoints, // future
  membership, // future
}

// ─────────────────────────────────────────────
// REWARD EVENT — emitted when a reward unlocks
// ─────────────────────────────────────────────
class RewardEvent {
  final RewardType type;
  final String title;
  final String subtitle;
  final double savedAmount;

  const RewardEvent({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.savedAmount,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// REWARD CELEBRATION SERVICE
//
// Singleton GetxService that:
//   • Tracks the previous reward state (delivery fee, coupon code, discount)
//   • Detects LOCKED → UNLOCKED transitions
//   • Emits a RewardEvent via broadcast stream (UI listens to this)
//   • Fires haptic feedback on each emission
//
// STATE TRACKING RULES
//   • Celebrations only fire after snapshotCurrentState() is called once
//     (called by BasketScreen after initial data load — prevents startup noise)
//   • Each reward type has a "celebrated" flag that prevents repeat fires
//   • Flags are reset only when the reward becomes unavailable again
// ─────────────────────────────────────────────────────────────────────────────
class RewardCelebrationService extends GetxService {
  static RewardCelebrationService get instance =>
      Get.find<RewardCelebrationService>();

  // Whether the service is ready to fire celebrations.
  // Set to true only after initial cart load completes.
  bool _isReady = false;

  // ── Previous state snapshot ────────────────────────────────────────────────
  double _prevDeliveryFee = double.infinity;
  String? _prevCouponCode;
  double _prevCouponDiscount = 0;

  // ── "Already celebrated" guards ────────────────────────────────────────────
  bool _freeDeliveryCelebrated = false;
  bool _couponCelebrated = false;
  bool _betterCouponCelebrated = false;

  // ── Event stream ───────────────────────────────────────────────────────────
  final StreamController<RewardEvent> _eventController =
      StreamController<RewardEvent>.broadcast();

  Stream<RewardEvent> get rewardEvents => _eventController.stream;

  @override
  void onClose() {
    _eventController.close();
    super.onClose();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once after the initial cart data load completes.
  /// Snapshots the current state so subsequent changes can be detected.
  /// Safe to call multiple times — only acts on the very first call.
  void snapshotCurrentState({
    required double deliveryFee,
    required String? couponCode,
    required double couponDiscount,
  }) {
    if (_isReady) return; // Already initialized — ignore re-opens
    _prevDeliveryFee = deliveryFee;
    _prevCouponCode = couponCode;
    _prevCouponDiscount = couponDiscount;
    _isReady = true;
  }

  /// Main reward detection. Call after any pricing or coupon update.
  /// Safe to call frequently — no-ops when not ready or no transitions found.
  void checkAndTriggerRewards({
    required double currentDeliveryFee,
    required double originalDeliveryFee,
    required String? currentCouponCode,
    required double currentCouponDiscount,
  }) {
    if (!_isReady) return;

    final isCouponPresent =
        currentCouponCode != null && currentCouponCode.isNotEmpty;
    final hadCoupon = _prevCouponCode != null && _prevCouponCode!.isNotEmpty;

    // ── 1. FREE DELIVERY UNLOCK ────────────────────────────────────────────
    final wasDeliveryPaid = _prevDeliveryFee > 0.01;
    final isNowFree = currentDeliveryFee <= 0.01 && originalDeliveryFee > 0.01;
    if (wasDeliveryPaid && isNowFree && !_freeDeliveryCelebrated) {
      final savings = originalDeliveryFee > 0 ? originalDeliveryFee : 0.0;
      _emit(
        RewardEvent(
          type: RewardType.freeDelivery,
          title: '🎉 Free Delivery Unlocked!',
          subtitle: savings > 0
              ? 'You saved ₹${savings.formatPrice} on delivery'
              : 'Free delivery applied to your order',
          savedAmount: savings,
        ),
      );
      _freeDeliveryCelebrated = true;
    }
    // Reset if delivery becomes paid again
    if (currentDeliveryFee > 0.01) _freeDeliveryCelebrated = false;

    // ── 2. COUPON APPLIED (None → Some) ───────────────────────────────────
    final wasCouponAbsent = !hadCoupon;
    if (wasCouponAbsent &&
        isCouponPresent &&
        currentCouponDiscount > 0 &&
        !_couponCelebrated) {
      _emit(
        RewardEvent(
          type: RewardType.couponApplied,
          title: '🎉 Best Offer Applied!',
          subtitle:
              '₹${currentCouponDiscount.formatPrice} discount added automatically',
          savedAmount: currentCouponDiscount,
        ),
      );
      _couponCelebrated = true;
      _betterCouponCelebrated = true; // Suppress "better" on the same event
    }

    // ── 3. BETTER COUPON (Discount increased significantly) ───────────────
    final discountIncreased = currentCouponDiscount > _prevCouponDiscount + 0.5;
    if (hadCoupon &&
        isCouponPresent &&
        discountIncreased &&
        !_betterCouponCelebrated) {
      final additional = currentCouponDiscount - _prevCouponDiscount;
      _emit(
        RewardEvent(
          type: RewardType.betterCoupon,
          title: '🎉 Bigger Savings Unlocked!',
          subtitle: 'Additional ₹${additional.formatPrice} saved automatically',
          savedAmount: additional,
        ),
      );
      _betterCouponCelebrated = true;
    }

    // ── Reset flags when rewards become unavailable ────────────────────────
    if (!isCouponPresent) {
      _couponCelebrated = false;
      _betterCouponCelebrated = false;
    } else if (currentCouponDiscount < _prevCouponDiscount - 0.5) {
      _betterCouponCelebrated = false;
    }

    // ── Snapshot for next call ─────────────────────────────────────────────
    _prevDeliveryFee = currentDeliveryFee;
    _prevCouponCode = currentCouponCode;
    _prevCouponDiscount = currentCouponDiscount;
  }

  // ── Private ────────────────────────────────────────────────────────────────

  void _emit(RewardEvent event) {
    HapticFeedback.lightImpact();
    _eventController.add(event);
  }
}
