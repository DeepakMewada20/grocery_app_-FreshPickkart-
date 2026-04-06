import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/screens/banner_offer_host_screen.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central helper that handles all banner redirect/navigation logic.
/// Call [BannerNavigationHelper.navigate] whenever a banner is tapped.
class BannerNavigationHelper {
  BannerNavigationHelper._();

  static Future<void> navigate(client.Banner banner) async {
    switch (banner.type) {
      case 'product':
        await _navigateToProduct(banner.productId);
        break;
      case 'category':
        _navigateToCategory(banner.categoryId);
        break;
      case 'offer':
        _navigateToOffers(banner.offerId);
        break;
      case 'combo':
        _navigateToComboOffers(banner.comboId);
        break;
      case 'coupon':
        _navigateToCoupons(banner.couponCode);
        break;
      case 'external_link':
        await _launchExternalUrl(banner.externalUrl);
        break;
      default:
        // Unknown type — do nothing
        break;
    }
  }

  // ──────────────────────────────────────────────
  // Product → ProductDetailScreen
  // ──────────────────────────────────────────────
  static Future<void> _navigateToProduct(String? productId) async {
    if (productId == null || productId.trim().isEmpty) {
      _showSnackbar('Product not found');
      return;
    }

    final productController = ProductProviderController.instance;
    final product = productController.allProducts.firstWhereOrNull(
      (p) => p.productId == productId.trim(),
    );

    if (product == null) {
      _showSnackbar('Product not available');
      return;
    }

    Get.to(
      () => ProductDetailScreen(product: product),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ──────────────────────────────────────────────
  // Category → CategoryItemsScreen
  // ──────────────────────────────────────────────
  static void _navigateToCategory(String? categoryId) {
    if (categoryId == null || categoryId.trim().isEmpty) {
      _showSnackbar('Category not found');
      return;
    }

    Get.to(
      () => CategoryItemsScreen(
        categoryName: categoryId.trim(),
        subCategoryGroupName: 'All',
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ──────────────────────────────────────────────
  // Offer/Combo → shared parent screen
  // ──────────────────────────────────────────────
  static void _navigateToOffers(String? offerId) {
    Get.to(
      () => BannerOfferHostScreen(
        bannerType: 'offer',
        offerId: offerId,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static void _navigateToComboOffers(String? comboId) {
    Get.to(
      () => BannerOfferHostScreen(
        bannerType: 'combo',
        comboId: comboId,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ──────────────────────────────────────────────
  // Coupon → CouponsScreen
  // ──────────────────────────────────────────────
  static void _navigateToCoupons(String? couponCode) {
    Get.to(
      () => CouponsScreen(autoApplyCouponCode: couponCode),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ──────────────────────────────────────────────
  // External Link → System Browser
  // ──────────────────────────────────────────────
  static Future<void> _launchExternalUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      _showSnackbar('Invalid URL');
      return;
    }

    final uri = Uri.tryParse(url.trim());
    if (uri == null) {
      _showSnackbar('Invalid URL format');
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackbar('Could not open link');
      }
    } catch (_) {
      _showSnackbar('Could not open link');
    }
  }

  static void _showSnackbar(String message) {
    Get.snackbar(
      'Banner',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }
}
