import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen/combo_offers_screen.dart';
import 'package:freshpickkat_flutter/basket/suggestions/combined_detail_bottomsheet.dart';
import 'package:get/get.dart';

class SuggestionNavigationHelper {
  static void handleTap(client.BasketSuggestion suggestion) {
    if (suggestion.type == 'combined') {
      _openCombinedBottomSheet(suggestion);
      return;
    }

    final type = suggestion.type;
    final actions = suggestion.actions ?? [];
    final firstAction = actions.isNotEmpty ? actions.first : null;

    if (firstAction?.type == 'add_to_cart') {
      _addToCart(suggestion, firstAction);
      return;
    }

    switch (type) {
      case 'reorder':
        _addToCart(suggestion, firstAction);
        break;
      case 'category':
        _navigateToCategory(
          firstAction?.payload?['categoryId'] ?? firstAction?.payload?['categoryName'],
        );
        break;
      case 'combo':
        final comboId = suggestion.comboId ?? firstAction?.comboId;
        if (comboId != null) {
           Get.to(() => ComboOffersScreen(highlightComboId: comboId));
        }
        break;
      case 'coupon':
        final code = firstAction?.couponCode;
        if (code != null) {
          Get.to(() => CouponsScreen(autoApplyCouponCode: code));
        }
        break;
      case 'product':
      case 'variant':
      case 'bogo':
        final productId = suggestion.productId ?? firstAction?.productId;
        final variantId = suggestion.variantId ?? firstAction?.variantId;
        _navToProduct(productId, variantId);
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

  static void _navToProduct(String? productId, String? variantId) {
    if (productId == null) return;

    final product = ProductProviderController.instance.allProducts.firstWhereOrNull(
      (p) => p.productId == productId,
    );

    if (product != null) {
      Get.to(() => ProductDetailScreen(
            product: product,
            initialVariantId: variantId,
          ));
    }
  }

  static void _addToCart(
    client.BasketSuggestion suggestion,
    client.BasketSuggestionAction? action,
  ) {
    final productId =
        suggestion.productId ?? action?.productId ?? action?.payload?['productId'];
    if (productId == null || productId.trim().isEmpty) {
      return;
    }

    final product = ProductProviderController.instance.allProducts.firstWhereOrNull(
      (p) => p.productId == productId,
    );
    if (product == null) {
      _navToProduct(productId, action?.variantId ?? action?.payload?['variantId']);
      return;
    }

    CartController.instance.addItem(
      product,
      variantId: action?.variantId ?? action?.payload?['variantId'],
    );
  }

  static void _navigateToCategory(String? categoryId) {
    if (categoryId == null || categoryId.trim().isEmpty) return;
    Get.to(
      () => CategoryItemsScreen(
        categoryName: categoryId.trim(),
        subCategoryGroupName: 'All',
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
