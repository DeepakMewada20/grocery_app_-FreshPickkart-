
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart' deferred as productDetailScreen;
import 'package:freshpickkat_flutter/screens/banner_offer_host_screen.dart' deferred as bannerOfferHostScreen;
import 'package:freshpickkat_flutter/screens/category_item_screen.dart' deferred as categoryItemScreen;
import 'package:freshpickkat_flutter/screens/coupons_screen.dart' deferred as couponsScreen;
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
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
        await _navigateToCategory(banner.categoryId);
        break;
      case 'offer':
        await _navigateToOffers(banner.offerId);
        break;
      case 'combo':
        await _navigateToComboOffers(banner.comboId);
        break;
      case 'coupon':
        await _navigateToCoupons(banner.couponCode);
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

    await navigateDeferred(
      loadLibrary: productDetailScreen.loadLibrary,
      pageBuilder: () => productDetailScreen.ProductDetailScreen(product: product),
    );
  }

  // ──────────────────────────────────────────────
  // Category → CategoryItemsScreen
  // ──────────────────────────────────────────────
  static Future<void> _navigateToCategory(String? categoryId) async {
    if (categoryId == null || categoryId.trim().isEmpty) {
      _showSnackbar('Category not found');
      return;
    }

    await navigateDeferred(
      loadLibrary: categoryItemScreen.loadLibrary,
      pageBuilder: () => categoryItemScreen.CategoryItemsScreen(
        categoryName: categoryId.trim(),
        subCategoryGroupName: 'All',
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Offer/Combo → shared parent screen
  // ──────────────────────────────────────────────
  static Future<void> _navigateToOffers(String? offerId) async {
    await navigateDeferred(
      loadLibrary: bannerOfferHostScreen.loadLibrary,
      pageBuilder: () => bannerOfferHostScreen.BannerOfferHostScreen(
        bannerType: 'offer',
        offerId: offerId,
      ),
    );
  }

  static Future<void> _navigateToComboOffers(String? comboId) async {
    await navigateDeferred(
      loadLibrary: bannerOfferHostScreen.loadLibrary,
      pageBuilder: () => bannerOfferHostScreen.BannerOfferHostScreen(
        bannerType: 'combo',
        comboId: comboId,
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Coupon → CouponsScreen
  // ──────────────────────────────────────────────
  static Future<void> _navigateToCoupons(String? couponCode) async {
    await navigateDeferred(
      loadLibrary: couponsScreen.loadLibrary,
      pageBuilder: () => couponsScreen.CouponsScreen(autoApplyCouponCode: couponCode),
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
    AppSnackbar.show(
      'Banner',
      message,
    );
  }
}
