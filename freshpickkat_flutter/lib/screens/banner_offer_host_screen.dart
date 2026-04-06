import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/screens/combo_offers_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen.dart';

/// Parent entry point for banner-driven offer navigation.
/// It keeps the underlying offer/combo implementations separate.
class BannerOfferHostScreen extends StatelessWidget {
  final String bannerType;
  final String? offerId;
  final String? comboId;

  const BannerOfferHostScreen({
    super.key,
    required this.bannerType,
    this.offerId,
    this.comboId,
  });

  @override
  Widget build(BuildContext context) {
    switch (bannerType) {
      case 'combo':
        return ComboOffersScreen(highlightComboId: comboId);
      case 'offer':
      default:
        return OffersScreen(highlightOfferId: offerId);
    }
  }
}
