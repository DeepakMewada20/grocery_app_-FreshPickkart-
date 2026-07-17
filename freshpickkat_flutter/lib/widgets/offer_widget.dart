import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';

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
        padding: AppSpacing.cardPadding,
        decoration: const BoxDecoration(color: Color(0xFF0C5A2A)),
        child: Row(
          children: [
            Icon(
              offer.isFree ? Icons.card_giftcard : Icons.local_shipping,
              color: Colors.white,
              size: AppIcons.large,
            ),
            AppSpacing.width(AppSpacing.sm),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.message ?? 'Delivery offer',
                          style: AppText.titleSmall(context).copyWith(
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (offer.appliedRuleName != null) ...[
                          AppSpacing.height(AppSpacing.xxs),
                          Text(
                            offer.appliedRuleName!,
                            style: AppText.caption(context).copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSpacing.width(AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: AppIcons.small,
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
