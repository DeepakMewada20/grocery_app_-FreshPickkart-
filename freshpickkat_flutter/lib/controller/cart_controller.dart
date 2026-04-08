import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' hide CartItem;
import 'package:freshpickkat_client/freshpickkat_client.dart'
    as protocol
    show CartItem;
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class CartItem {
  final Product product;
  final String? variantId;
  int quantity;
  String? bogoFreeProductId; // Selected free item ID
  final String? comboId;
  final String? comboName;
  final String? comboDiscountType;
  final double? comboDiscountValue;
  final int? comboItemQuantity;

  CartItem({
    required this.product,
    this.variantId,
    this.quantity = 1,
    this.bogoFreeProductId,
    this.comboId,
    this.comboName,
    this.comboDiscountType,
    this.comboDiscountValue,
    this.comboItemQuantity,
  });

  bool get isComboItem =>
      comboId != null &&
      comboDiscountType != null &&
      comboDiscountValue != null &&
      comboItemQuantity != null &&
      comboItemQuantity! > 0;
}

class ComboCartGroup {
  final String comboId;
  final String name;
  final String discountType;
  final double discountValue;
  final List<CartItem> items;

  const ComboCartGroup({
    required this.comboId,
    required this.name,
    required this.discountType,
    required this.discountValue,
    required this.items,
  });

  int get bundleQuantity {
    if (items.isEmpty) return 0;
    final counts =
        items
            .map((item) => item.quantity ~/ (item.comboItemQuantity ?? 1))
            .where((count) => count > 0)
            .toList()
          ..sort();
    return counts.isEmpty ? 0 : counts.first;
  }

  double get originalUnitTotal => items.fold(
    0,
    (sum, item) => sum + (item.product.price * (item.comboItemQuantity ?? 1)),
  );

  double get discountedUnitTotal => applyComboDiscount(
    originalTotal: originalUnitTotal,
    discountType: discountType,
    discountValue: discountValue,
  );

  double get originalTotal => originalUnitTotal * bundleQuantity;
  double get discountedTotal => discountedUnitTotal * bundleQuantity;
  double get savings =>
      (originalTotal - discountedTotal).clamp(0, double.infinity);
}

class BogoCartSuggestion {
  final BogoOffer offer;
  final Product triggerProduct;
  final String? triggerVariantId;
  final Product freeProduct;

  const BogoCartSuggestion({
    required this.offer,
    required this.triggerProduct,
    this.triggerVariantId,
    required this.freeProduct,
  });
}

class CartController extends GetxController {
  static CartController get instance => Get.find<CartController>();

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final Rxn<BogoCartSuggestion> bogoSuggestion = Rxn<BogoCartSuggestion>();
  final client = ServerpodClient().client;
  Timer? _cartValidationDebounce;
  bool _isInitialLoading = false;

  @override
  void onInit() {
    super.onInit();
    // Listen to cart changes and sync with server
    ever(cartItems, (_) {
      _refreshBogoSuggestion();
      _handleCartChanged();
    });
    ever(BogoController.instance.activeOffers, (_) => _refreshBogoSuggestion());
    ever(
      BogoController.instance.activeOffers,
      (_) => _scheduleCartValidation(),
    );
    ever(
      ComboOfferController.instance.activeComboOffers,
      (_) => _scheduleCartValidation(),
    );
    ever(
      ProductProviderController.instance.allProducts,
      (_) {
        _refreshBogoSuggestion();
        _scheduleCartValidation();
      },
    );
  }

  @override
  void onClose() {
    _cartValidationDebounce?.cancel();
    super.onClose();
  }

  Future<void> _handleCartChanged() async {
    if (_isInitialLoading) return;
    await _syncWithServer();
    await fetchAvailableCoupons();
    await _revalidateAppliedCoupon();
  }

  Future<void> _syncWithServer() async {
    final authController = AuthController.instance;
    if (authController.isLoggedIn && authController.currentUser != null) {
      try {
        final protocolCart = cartItems
            .map(
              (item) => protocol.CartItem(
                productId: item.product.productId!,
                variantId: item.variantId,
                quantity: item.quantity,
                bogoFreeProductId: item.bogoFreeProductId,
                comboId: item.comboId,
                comboName: item.comboName,
                comboDiscountType: item.comboDiscountType,
                comboDiscountValue: item.comboDiscountValue,
                comboItemQuantity: item.comboItemQuantity,
              ),
            )
            .toList();

        await client.user.updateCart(
          authController.currentUser!.uid,
          protocolCart,
        );
      } catch (e) {
        debugPrint('Error syncing cart to server: $e');
      }
    }
  }

  Future<void> fetchCartFromServer() async {
    final authController = AuthController.instance;
    final cachedUser = authController.appUser;
    if (authController.isLoggedIn && cachedUser != null) {
      try {
        if (cachedUser.cart != null) {
          _isInitialLoading = true;
          await _revalidateStoredCart(cachedUser.cart!);
          _isInitialLoading = false;
        }
      } catch (e) {
        _isInitialLoading = false;
        debugPrint('Error fetching cart from server: $e');
      }
    }
  }

  Future<void> refreshCartCurrentData() async {
    final stored = cartItems
        .map(
          (item) => protocol.CartItem(
            productId: item.product.productId ?? '',
            variantId: item.variantId,
            quantity: item.quantity,
            bogoFreeProductId: item.bogoFreeProductId,
            comboId: item.comboId,
            comboName: item.comboName,
            comboDiscountType: item.comboDiscountType,
            comboDiscountValue: item.comboDiscountValue,
            comboItemQuantity: item.comboItemQuantity,
          ),
        )
        .toList();

    await _revalidateStoredCart(stored);
  }

  void _scheduleCartValidation() {
    if (cartItems.isEmpty) return;
    _cartValidationDebounce?.cancel();
    _cartValidationDebounce = Timer(const Duration(milliseconds: 350), () {
      refreshCartCurrentData();
    });
  }

  Future<void> _revalidateStoredCart(List<protocol.CartItem> storedCart) async {
    final productIds = storedCart
        .map((item) => item.productId)
        .toSet()
        .toList();
    final currentProducts = await client.product.getProductsByIds(productIds);
    final productMap = {
      for (final product in currentProducts)
        if (product.productId != null) product.productId!: product,
    };

    final activeBogoOffers = BogoController.instance.activeOffers.isNotEmpty
        ? BogoController.instance.activeOffers.toList()
        : await client.bogo.getActiveOffers();
    final activeComboOffers =
        ComboOfferController.instance.activeComboOffers.isNotEmpty
        ? ComboOfferController.instance.activeComboOffers.toList()
        : await client.comboOffer.getActiveComboOffers();

    final normalized = <CartItem>[];
    final comboItems = storedCart
        .where(
          (item) => item.comboId != null && item.comboId!.trim().isNotEmpty,
        )
        .toList();
    final regularItems = storedCart
        .where((item) => item.comboId == null || item.comboId!.trim().isEmpty)
        .toList();

    final comboGroups = <String, List<protocol.CartItem>>{};
    for (final item in comboItems) {
      comboGroups
          .putIfAbsent(item.comboId!, () => <protocol.CartItem>[])
          .add(item);
    }

    for (final item in regularItems) {
      final baseProduct = productMap[item.productId];
      if (baseProduct == null) continue;

      final variant = _resolveExistingVariant(
        baseProduct,
        variantId: item.variantId,
      );
      if (variant == null || !variant.isAvailable) continue;

      final selectedProduct = applyVariantToProduct(
        baseProduct,
        variantId: variant.variantId,
      );

      String? validatedFreeProductId = item.bogoFreeProductId;
      if (validatedFreeProductId != null) {
        final bogoOffer = activeBogoOffers.firstWhereOrNull(
          (offer) =>
              offer.triggerProductId == item.productId &&
              (offer.triggerVariantId == null ||
                  offer.triggerVariantId!.trim().isEmpty ||
                  offer.triggerVariantId == variant.variantId),
        );

        if (bogoOffer == null ||
            !bogoOffer.freeProductIds.contains(validatedFreeProductId) ||
            !productMap.containsKey(validatedFreeProductId)) {
          validatedFreeProductId = null;
        }
      }

      normalized.add(
        CartItem(
          product: selectedProduct,
          variantId: variant.variantId,
          quantity: item.quantity,
          bogoFreeProductId: validatedFreeProductId,
        ),
      );
    }

    for (final entry in comboGroups.entries) {
      final activeCombo = activeComboOffers.firstWhereOrNull(
        (offer) => (offer.comboId ?? offer.name) == entry.key,
      );
      if (activeCombo == null) continue;

      final bundleCount = _inferStoredBundleCount(entry.value);
      if (bundleCount <= 0) continue;

      final resolved = resolveComboProducts(activeCombo, currentProducts);
      if (resolved.length != activeCombo.comboProducts.length) continue;
      if (resolved.any((item) => !item.selectedVariant.isAvailable)) continue;

      for (final item in resolved) {
        normalized.add(
          CartItem(
            product: item.selectedProduct,
            variantId: item.selectedVariant.variantId,
            quantity: item.bundleQuantity * bundleCount,
            comboId: activeCombo.comboId ?? activeCombo.name,
            comboName: activeCombo.name,
            comboDiscountType: activeCombo.discountType,
            comboDiscountValue: activeCombo.discountValue,
            comboItemQuantity: item.bundleQuantity,
          ),
        );
      }
    }

    cartItems.assignAll(normalized);
  }

  int _inferStoredBundleCount(List<protocol.CartItem> items) {
    if (items.isEmpty) return 0;
    final counts =
        items
            .map((item) {
              final perBundle = item.comboItemQuantity ?? 1;
              if (perBundle <= 0) return 0;
              return item.quantity ~/ perBundle;
            })
            .where((count) => count > 0)
            .toList()
          ..sort();
    return counts.isEmpty ? 0 : counts.first;
  }

  ProductVariant? _resolveExistingVariant(
    Product product, {
    required String? variantId,
  }) {
    final variants = sortedProductVariants(product);
    if (variantId == null || variantId.trim().isEmpty) {
      return variants.isEmpty ? null : variants.first;
    }
    return variants.firstWhereOrNull(
      (variant) => variant.variantId == variantId,
    );
  }

  // Rx derived properties
  List<CartItem> get regularCartItems =>
      cartItems.where((item) => !item.isComboItem).toList();

  List<ComboCartGroup> get comboGroups {
    final grouped = <String, List<CartItem>>{};
    for (final item in cartItems.where((entry) => entry.isComboItem)) {
      grouped.putIfAbsent(item.comboId!, () => <CartItem>[]).add(item);
    }

    return grouped.entries.map((entry) {
      final first = entry.value.first;
      return ComboCartGroup(
        comboId: entry.key,
        name: first.comboName ?? 'Combo Offer',
        discountType: first.comboDiscountType ?? 'flat',
        discountValue: first.comboDiscountValue ?? 0,
        items: entry.value,
      );
    }).toList();
  }

  int get itemCount => regularCartItems.length + comboGroups.length;

  // Coupon state
  final Rxn<CouponDisplay> appliedCoupon = Rxn<CouponDisplay>();
  final Rxn<CouponValidationResult> couponValidation =
      Rxn<CouponValidationResult>();
  final RxList<CouponDisplay> availableCoupons = <CouponDisplay>[].obs;
  final RxBool isLoadingCoupons = false.obs;
  final RxString couponError = ''.obs;

  double get subtotal {
    final regularTotal = regularCartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final comboTotal = comboGroups.fold<double>(
      0,
      (sum, group) => sum + group.discountedTotal,
    );
    return regularTotal + comboTotal;
  }

  double get totalSavings {
    final regularSavings = regularCartItems.fold<double>(
      0,
      (sum, item) =>
          sum + ((item.product.realPrice - item.product.price) * item.quantity),
    );
    final comboSavings = comboGroups.fold<double>(
      0,
      (sum, group) => sum + group.savings,
    );
    return regularSavings + comboSavings;
  }

  double get deliveryFee {
    if (appliedCoupon.value?.isDeliveryDiscount == true &&
        couponValidation.value != null &&
        couponValidation.value!.isValid) {
      return (40.0 - couponValidation.value!.discountAmount).clamp(0, 40);
    }
    return 40.0;
  }

  double get couponDiscount {
    if (couponValidation.value != null &&
        couponValidation.value!.isValid &&
        !couponValidation.value!.isDeliveryDiscount) {
      return couponValidation.value!.discountAmount;
    }
    return 0;
  }

  double get totalAmount {
    final delivery = deliveryFee;
    final priceAfterDiscount = subtotal - couponDiscount;
    return (priceAfterDiscount + delivery).clamp(0, double.infinity);
  }

  Future<void> fetchAvailableCoupons() async {
    if (cartItems.isEmpty) {
      availableCoupons.clear();
      removeCoupon();
      return;
    }

    isLoadingCoupons.value = true;
    couponError.value = '';

    try {
      final response = await client.coupon.fetchApplicableCoupons(subtotal);
      availableCoupons.assignAll(response);
    } catch (e) {
      couponError.value = 'Failed to load coupons';
      debugPrint('Error fetching coupons: $e');
    } finally {
      isLoadingCoupons.value = false;
    }
  }

  Future<void> _revalidateAppliedCoupon() async {
    final coupon = appliedCoupon.value;
    if (coupon == null) return;

    try {
      final result = await client.coupon.validateCoupon(coupon.code, subtotal);
      couponValidation.value = result;

      if (!result.isValid) {
        removeCoupon();
        couponError.value = result.errorMessage ?? 'Coupon removed';
      }
    } catch (e) {
      removeCoupon();
      couponError.value = 'Coupon removed';
    }
  }

  Future<bool> applyCoupon(String couponCode) async {
    if (cartItems.isEmpty) return false;

    couponError.value = '';

    try {
      final response = await client.coupon.validateCoupon(couponCode, subtotal);
      final result = response;

      couponValidation.value = result;

      if (result.isValid) {
        final matchedCoupon = availableCoupons.firstWhereOrNull(
          (c) => c.code.toUpperCase() == couponCode.toUpperCase(),
        );
        appliedCoupon.value = matchedCoupon;
        return true;
      } else {
        couponError.value = result.errorMessage ?? 'Invalid coupon';
        appliedCoupon.value = null;
        return false;
      }
    } catch (e) {
      couponError.value = 'Error applying coupon';
      debugPrint('Error applying coupon: $e');
      return false;
    }
  }

  void removeCoupon() {
    appliedCoupon.value = null;
    couponValidation.value = null;
    couponError.value = '';
  }

  void addItem(
    Product product, {
    String? variantId,
    bool triggerBogoSuggestion = true,
    int quantityDelta = 1,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
  }) {
    if (quantityDelta <= 0) return;

    final selectedProduct = applyVariantToProduct(
      product,
      variantId: variantId,
    );
    final selectedVariantId = resolveProductVariant(
      product,
      variantId: variantId,
    ).variantId;
    int index = cartItems.indexWhere(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == selectedVariantId &&
          item.comboId == comboId,
    );
    if (index != -1) {
      cartItems[index].quantity += quantityDelta;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          product: selectedProduct,
          variantId: selectedVariantId,
          quantity: quantityDelta,
          comboId: comboId,
          comboName: comboName,
          comboDiscountType: comboDiscountType,
          comboDiscountValue: comboDiscountValue,
          comboItemQuantity: comboItemQuantity,
        ),
      );
    }

    if (triggerBogoSuggestion && comboId == null) {
      _maybeSuggestBogoForFreeProduct(selectedProduct);
    }
  }

  void removeItem(
    Product product, {
    String? variantId,
    int quantityDelta = 1,
    String? comboId,
  }) {
    if (quantityDelta <= 0) return;

    final selectedVariantId = resolveProductVariant(
      product,
      variantId: variantId,
    ).variantId;
    int index = cartItems.indexWhere(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == selectedVariantId &&
          item.comboId == comboId,
    );
    if (index != -1) {
      if (cartItems[index].quantity > quantityDelta) {
        cartItems[index].quantity -= quantityDelta;
        cartItems.refresh();
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  void updateQuantity(
    Product product,
    int quantity, {
    String? variantId,
    String? comboId,
    String? comboName,
    String? comboDiscountType,
    double? comboDiscountValue,
    int? comboItemQuantity,
  }) {
    final selectedProduct = applyVariantToProduct(
      product,
      variantId: variantId,
    );
    final selectedVariantId = resolveProductVariant(
      product,
      variantId: variantId,
    ).variantId;
    int index = cartItems.indexWhere(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == selectedVariantId &&
          item.comboId == comboId,
    );
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = quantity;
        cartItems.refresh();
      }
    } else if (quantity > 0) {
      cartItems.add(
        CartItem(
          product: selectedProduct,
          variantId: selectedVariantId,
          quantity: quantity,
          comboId: comboId,
          comboName: comboName,
          comboDiscountType: comboDiscountType,
          comboDiscountValue: comboDiscountValue,
          comboItemQuantity: comboItemQuantity,
        ),
      );
    }
  }

  int getProductQuantity(
    String? productId, {
    String? variantId,
    String? comboId,
  }) {
    if (productId == null) return 0;
    int index = cartItems.indexWhere(
      (item) =>
          item.product.productId == productId &&
          (item.variantId ?? 'default') == (variantId ?? 'default') &&
          item.comboId == comboId,
    );
    return index != -1 ? cartItems[index].quantity : 0;
  }

  void addComboOffer(ComboOffer combo) {
    final resolvedItems = resolveComboProducts(
      combo,
      ProductProviderController.instance.allProducts,
    );

    for (final item in resolvedItems) {
      addItem(
        item.baseProduct,
        variantId: item.selectedVariant.variantId,
        triggerBogoSuggestion: false,
        quantityDelta: item.bundleQuantity,
        comboId: combo.comboId ?? combo.name,
        comboName: combo.name,
        comboDiscountType: combo.discountType,
        comboDiscountValue: combo.discountValue,
        comboItemQuantity: item.bundleQuantity,
      );
    }
  }

  void incrementComboGroup(String comboId) {
    final group = comboGroups.firstWhereOrNull(
      (entry) => entry.comboId == comboId,
    );
    if (group == null) return;

    for (final item in group.items) {
      addItem(
        item.product,
        variantId: item.variantId,
        triggerBogoSuggestion: false,
        quantityDelta: item.comboItemQuantity ?? 1,
        comboId: item.comboId,
        comboName: item.comboName,
        comboDiscountType: item.comboDiscountType,
        comboDiscountValue: item.comboDiscountValue,
        comboItemQuantity: item.comboItemQuantity,
      );
    }
  }

  void decrementComboGroup(String comboId) {
    final group = comboGroups.firstWhereOrNull(
      (entry) => entry.comboId == comboId,
    );
    if (group == null) return;

    for (final item in group.items) {
      removeItem(
        item.product,
        variantId: item.variantId,
        quantityDelta: item.comboItemQuantity ?? 1,
        comboId: item.comboId,
      );
    }
  }

  void removeComboGroup(String comboId) {
    cartItems.removeWhere((item) => item.comboId == comboId);
  }

  void clearCart() {
    cartItems.clear();
    bogoSuggestion.value = null;
  }

  void setBogoSelection(
    String triggerProductId,
    String? freeProductId, {
    String? triggerVariantId,
  }) {
    int index = cartItems.indexWhere(
      (item) =>
          item.product.productId == triggerProductId &&
          (item.variantId ?? 'default') == (triggerVariantId ?? 'default') &&
          item.comboId == null,
    );
    if (index != -1) {
      cartItems[index].bogoFreeProductId = freeProductId;
      cartItems.refresh();
      _syncWithServer(); // Explicit sync for selection
    }
  }

  void applyCurrentBogoSuggestion() {
    final suggestion = bogoSuggestion.value;
    if (suggestion == null) return;

    final triggerId = suggestion.triggerProduct.productId;
    final freeId = suggestion.freeProduct.productId;
    if (triggerId == null || freeId == null) {
      bogoSuggestion.value = null;
      return;
    }

    final triggerItem = cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == triggerId &&
          (item.variantId ?? 'default') ==
              (suggestion.triggerVariantId ?? 'default') &&
          item.comboId == null,
    );
    if (triggerItem == null) {
      addItem(
        suggestion.triggerProduct,
        variantId: suggestion.triggerVariantId,
        triggerBogoSuggestion: false,
      );
    }

    setBogoSelection(
      triggerId,
      freeId,
      triggerVariantId: suggestion.triggerVariantId,
    );
    removeItem(suggestion.freeProduct);
    bogoSuggestion.value = null;
  }

  void _maybeSuggestBogoForFreeProduct(Product addedProduct) {
    final suggestion = _buildSuggestionForFreeProduct(addedProduct);
    if (suggestion != null) {
      bogoSuggestion.value = suggestion;
      return;
    }

    _refreshBogoSuggestion();
  }

  void _refreshBogoSuggestion() {
    final current = bogoSuggestion.value;
    if (current != null && _isSuggestionStillValid(current)) {
      final refreshedTrigger =
          _findProductById(current.triggerProduct.productId) ??
          current.triggerProduct;
      final refreshedFree =
          _findProductById(current.freeProduct.productId) ??
          current.freeProduct;
      bogoSuggestion.value = BogoCartSuggestion(
        offer: current.offer,
        triggerProduct: refreshedTrigger,
        triggerVariantId: current.triggerVariantId,
        freeProduct: refreshedFree,
      );
      return;
    }

    bogoSuggestion.value = null;
    for (final item in regularCartItems) {
      final suggestion = _buildSuggestionForFreeProduct(item.product);
      if (suggestion != null) {
        bogoSuggestion.value = suggestion;
        break;
      }
    }
  }

  bool _isSuggestionStillValid(BogoCartSuggestion suggestion) {
    final freeId = suggestion.freeProduct.productId;
    final triggerId = suggestion.triggerProduct.productId;
    if (freeId == null || triggerId == null) return false;

    final freeItem = cartItems.firstWhereOrNull(
      (item) => item.product.productId == freeId && item.comboId == null,
    );
    if (freeItem == null || freeItem.quantity <= 0) return false;

    final triggerItem = cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == triggerId &&
          (item.variantId ?? 'default') ==
              (suggestion.triggerVariantId ?? 'default') &&
          item.comboId == null,
    );
    if (triggerItem?.bogoFreeProductId == freeId) return false;
    if (triggerItem?.bogoFreeProductId != null &&
        triggerItem!.bogoFreeProductId != freeId) {
      return false;
    }

    return suggestion.offer.isActive &&
        suggestion.offer.freeProductIds.contains(freeId);
  }

  BogoCartSuggestion? _buildSuggestionForFreeProduct(Product freeProduct) {
    final freeProductId = freeProduct.productId;
    if (freeProductId == null) return null;

    final offer = BogoController.instance.activeOffers.firstWhereOrNull(
      (candidate) =>
          candidate.isActive &&
          candidate.freeProductIds.contains(freeProductId),
    );
    if (offer == null) return null;

    final triggerProduct = _findProductById(offer.triggerProductId);
    if (triggerProduct == null) return null;

    final triggerItem = cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == offer.triggerProductId &&
          item.bogoFreeProductId == null &&
          item.comboId == null,
    );
    if (triggerItem == null) return null;
    if (triggerItem.bogoFreeProductId == freeProductId) return null;
    if (triggerItem.bogoFreeProductId != null &&
        triggerItem.bogoFreeProductId != freeProductId) {
      return null;
    }

    return BogoCartSuggestion(
      offer: offer,
      triggerProduct: applyVariantToProduct(
        triggerProduct,
        variantId: triggerItem.variantId,
      ),
      triggerVariantId: triggerItem.variantId,
      freeProduct: freeProduct,
    );
  }

  Product? _findProductById(String? productId, {String? variantId}) {
    if (productId == null) return null;

    final cartProduct = cartItems
        .firstWhereOrNull(
          (item) =>
              item.product.productId == productId &&
              (variantId == null || item.variantId == variantId),
        )
        ?.product;
    if (cartProduct != null) return cartProduct;

    final baseProduct = ProductProviderController.instance.allProducts
        .firstWhereOrNull(
          (product) => product.productId == productId,
        );
    if (baseProduct == null) return null;
    return applyVariantToProduct(baseProduct, variantId: variantId);
  }
}
