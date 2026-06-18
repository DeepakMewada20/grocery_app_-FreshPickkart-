import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class OfferWidget extends StatefulWidget {
  const OfferWidget({super.key});

  @override
  State<OfferWidget> createState() => OfferWidgetState();
}

class OfferWidgetState extends State<OfferWidget> {
  final _client = ServerpodClient().client;
  DeliveryPricingResult? _offer;
  bool _isLoading = true;

  static DeliveryPricingResult? _cachedHydratedOffer;

  static void cacheHydratedOffer(DeliveryPricingResult? offer) {
    _cachedHydratedOffer = offer;
  }

  @override
  void initState() {
    super.initState();
    if (_cachedHydratedOffer != null) {
      _offer = _cachedHydratedOffer;
      _isLoading = false;
    } else {
      _fetchOffer();
    }
  }

  Future<void> fetchOffer() => _fetchOffer();

  Future<void> _fetchOffer() async {
    final user = AuthController.instance.appUser;
    if (user == null || user.firebaseUid.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final result = await _client.freeDelivery.getUserDeliveryOffer(
        user.firebaseUid,
      );
      if (mounted) {
        setState(() {
          _offer = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _offer == null || _offer!.appliedRuleType == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final offer = _offer!;
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: const BoxDecoration(color: Color(0xFF0C5A2A)),
        child: Row(
          children: [
            Icon(
              offer.isFree ? Icons.card_giftcard : Icons.local_shipping,
              color: Colors.white,
              size: 24.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.message ?? 'Delivery offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (offer.appliedRuleName != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            offer.appliedRuleName!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
