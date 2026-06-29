import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart'
    deferred as category_item_screen;
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as product_detail_screen;
import 'package:freshpickkat_flutter/screens/coupons_screen.dart'
    deferred as coupons_screen;
import 'package:freshpickkat_flutter/screens/offers_screen/combo_offers_screen.dart'
    deferred as combo_offers_screen;
import 'package:freshpickkat_flutter/basket/suggestions/combined_detail_bottomsheet.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:get/get.dart';

class SuggestionNavigationHelper {
  static Future<void> handleTap(client.BasketSuggestion suggestion) async {
    if (suggestion.type == 'combined') {
      _openCombinedBottomSheet(suggestion);
      return;
    }

    final type = suggestion.type;
    final actions = suggestion.actions ?? [];
    final firstAction = actions.isNotEmpty ? actions.first : null;

    if (firstAction?.type == 'add_to_cart') {
      await _addToCart(suggestion, firstAction);
      return;
    }

    switch (type) {
      case 'reorder':
        await _addToCart(suggestion, firstAction);
        break;
      case 'category':
        await _navigateToCategory(
          firstAction?.payload?['categoryId'] ??
              firstAction?.payload?['categoryName'],
        );
        break;
      case 'combo':
        final comboId = suggestion.comboId ?? firstAction?.comboId;
        if (comboId != null) {
          await navigateDeferred(
            loadLibrary: combo_offers_screen.loadLibrary,
            pageBuilder: () => combo_offers_screen.ComboOffersScreen(
              highlightComboId: comboId,
            ),
          );
        }
        break;
      case 'coupon':
        final code = firstAction?.couponCode;
        if (code != null) {
          await navigateDeferred(
            loadLibrary: coupons_screen.loadLibrary,
            pageBuilder: () =>
                coupons_screen.CouponsScreen(autoApplyCouponCode: code),
          );
        }
        break;
      case 'smgm_reward':
      case 'product':
      case 'variant':
      case 'bogo':
        final productId = suggestion.productId ?? firstAction?.productId;
        final variantId = suggestion.variantId ?? firstAction?.variantId;
        await _navToProduct(productId, variantId);
        break;
      case 'delivery':
        // Stay on basket as per rules
        break;
      default:
        break;
    }
  }

  static void _openCombinedBottomSheet(client.BasketSuggestion s) {
    Get.bottomSheet(
      CombinedDetailBottomSheet(suggestion: s),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Future<void> _navToProduct(
    String? productId,
    String? variantId,
  ) async {
    if (productId == null) return;

    final product = ProductProviderController.instance.allProducts
        .firstWhereOrNull(
          (p) => p.productId == productId,
        );

    if (product != null) {
      await navigateDeferred(
        loadLibrary: product_detail_screen.loadLibrary,
        pageBuilder: () => product_detail_screen.ProductDetailScreen(
          product: product,
          initialVariantId: variantId,
        ),
      );
    }
  }

  static Future<void> _addToCart(
    client.BasketSuggestion suggestion,
    client.BasketSuggestionAction? action,
  ) async {
    final productId =
        suggestion.productId ??
        action?.productId ??
        action?.payload?['productId'];
    if (productId == null || productId.trim().isEmpty) {
      return;
    }

    final product = ProductProviderController.instance.allProducts
        .firstWhereOrNull(
          (p) => p.productId == productId,
        );
    if (product == null) {
      await _navToProduct(
        productId,
        action?.variantId ?? action?.payload?['variantId'],
      );
      return;
    }

    CartController.instance.addItem(
      product,
      variantId: action?.variantId ?? action?.payload?['variantId'],
    );
  }

  static Future<void> _navigateToCategory(String? categoryId) async {
    if (categoryId == null || categoryId.trim().isEmpty) return;
    await navigateDeferred(
      loadLibrary: category_item_screen.loadLibrary,
      pageBuilder: () => category_item_screen.CategoryItemsScreen(
        categoryName: categoryId.trim(),
        subCategoryGroupName: 'All',
      ),
    );
  }
}
