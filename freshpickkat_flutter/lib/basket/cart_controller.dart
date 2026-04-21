import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' hide CartItem;
import 'package:freshpickkat_client/freshpickkat_client.dart'
    as protocol
    show CartItem;
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/services/appcache/user_cache_service.dart';
import 'package:freshpickkat_flutter/utils/suggestion_navigation_helper.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
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

  double get mrpUnitTotal => items.fold(
    0,
    (sum, item) =>
        sum + (item.product.realPrice * (item.comboItemQuantity ?? 1)),
  );

  double get discountedUnitTotal => applyComboDiscount(
    originalTotal: originalUnitTotal,
    discountType: discountType,
    discountValue: discountValue,
  );

  double get mrpTotal => mrpUnitTotal * bundleQuantity;
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
  final Rxn<BasketSuggestion> bestBasketSuggestion = Rxn<BasketSuggestion>();
  final RxList<BasketSuggestion> basketSuggestions = <BasketSuggestion>[].obs;
  final RxList<BasketSuggestion> oldBasketSuggestions =
      <BasketSuggestion>[].obs;
  final Rxn<CartPricingResult> cartPricing = Rxn<CartPricingResult>();
  final client = ServerpodClient().client;
  Timer? _cartValidationDebounce;
  Timer? _cartRefreshDebounce;
  final RxBool isPricingStale = false.obs;
  final RxBool isBasketSuggestionsLoading = false.obs;
  final RxDouble estimatedDeliveryFee = 0.0.obs;
  final Rxn<DeliveryPricingResult> localDeliveryPricing =
      Rxn<DeliveryPricingResult>();
  bool _isInitialLoading = false;
  String _lastSuggestedCartSnapshot = '';
  String _lastPricingSnapshot = '';
  String? _pricingInFlightSnapshot;
  Future<void>? _pricingInFlight;
  DeliveryConfig? _cachedDeliveryConfig;
  Future<void>? _deliveryConfigInFlight;
  bool _isInitialized = false;
  bool _isInitialSyncComplete = false;
  Future<void>? _syncLock; // Serial queue for server updates

  void markInitialized() {
    _isInitialized = true;
    _scheduleCartRefresh(); // Trigger first sync after initialization
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to cart changes and sync with server
    ever(cartItems, (_) {
      _refreshBogoSuggestion();
      _updateDeliveryFeeEstimate();
      _scheduleCartRefresh();
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
    _cartRefreshDebounce?.cancel();
    super.onClose();
  }

  void _scheduleCartRefresh() {
    if (_isInitialLoading || !_isInitialized) return;
    isPricingStale.value = true;
    unawaited(fetchCartPricing());
    _cartRefreshDebounce?.cancel();
    _cartRefreshDebounce = Timer(const Duration(milliseconds: 250), () {
      _cartRefreshDebounce = null;
      unawaited(_runCartMetaRefresh());
    });
  }

  Future<void> _runCartMetaRefresh() async {
    if (_isInitialLoading) return;
    try {
      await Future.wait([
        _syncWithServer(),
        _ensureDeliveryConfigLoaded(),
        fetchAvailableCoupons(),
        _revalidateAppliedCoupon(),
        fetchCartPricing(),
        fetchBasketSuggestions(),
      ]);
    } finally {}
  }

  void _updateDeliveryFeeEstimate() {
    final currentSubtotal = subtotal;
    final config = _cachedDeliveryConfig;
    double fee = 40.0;
    double threshold = 300;
    String? message;
    if (config != null) {
      threshold = config.freeDeliveryThreshold ?? threshold;
      if (config.freeDeliveryThreshold != null &&
          currentSubtotal >= config.freeDeliveryThreshold!) {
        fee = 0.0;
        message = 'Free delivery unlocked';
      } else {
        final matchingSlab = config.slabs.firstWhereOrNull(
          (slab) =>
              currentSubtotal >= slab.minOrderAmount &&
              currentSubtotal <= slab.maxOrderAmount,
        );
        fee = matchingSlab?.fee ?? config.baseDeliveryFee;
        final remaining = (threshold - currentSubtotal).clamp(
          0,
          double.infinity,
        );
        message = 'Add ₹${remaining.toStringAsFixed(0)} more for free delivery';
      }
    } else if (currentSubtotal >= 300) {
      fee = 0.0;
      message = 'Free delivery unlocked';
    } else if (currentSubtotal >= 200) {
      fee = 20.0;
      message =
          'Add ₹${(300 - currentSubtotal).clamp(0, double.infinity).toStringAsFixed(0)} more for free delivery';
    } else {
      message =
          'Add ₹${(threshold - currentSubtotal).clamp(0, double.infinity).toStringAsFixed(0)} more for free delivery';
    }
    estimatedDeliveryFee.value = fee;
    localDeliveryPricing.value = DeliveryPricingResult(
      deliveryFee: fee,
      isFree: fee <= 0,
      message: message,
      remainingAmount: (threshold - currentSubtotal).clamp(0, double.infinity),
      progressPercent: threshold <= 0
          ? 0
          : ((currentSubtotal / threshold) * 100).clamp(0, 100).toDouble(),
      appliedRuleType: config != null
          ? 'cached_delivery_config'
          : 'local_estimate',
      appliedRuleName: config != null
          ? 'Cached delivery estimate'
          : 'Local delivery estimate',
      freeDeliveryThreshold: threshold,
      baseDeliveryFee: config?.baseDeliveryFee ?? 40,
    );
  }

  Future<void> _ensureDeliveryConfigLoaded() async {
    if (_cachedDeliveryConfig != null) {
      return;
    }
    if (_deliveryConfigInFlight != null) {
      await _deliveryConfigInFlight;
      return;
    }

    final request = () async {
      try {
        _cachedDeliveryConfig = await client.freeDelivery.getDeliveryConfig();
      } catch (e) {
        debugPrint('Error fetching delivery config: $e');
      }
    }();

    _deliveryConfigInFlight = request;
    try {
      await request;
    } finally {
      _deliveryConfigInFlight = null;
      _updateDeliveryFeeEstimate();
    }
  }

  Future<void> _syncWithServer() async {
    if (!_isInitialized || !_isInitialSyncComplete) return;
    final authController = AuthController.instance;
    if (authController.isLoggedIn && authController.currentUser != null) {
      // Use a serial queue (syncLock) to prevent race conditions
      final completer = Completer<void>();
      final previousLock = _syncLock;
      _syncLock = completer.future;
      await previousLock;

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
      } finally {
        completer.complete();
      }
    }
  }

  Future<void> fetchCartFromCache() async {
    final cachedUser = UserCacheService.instance.loadUser();
    if (cachedUser != null && cachedUser.cart != null) {
      try {
        _isInitialLoading = true;
        // We populate with "Slim" CartItems (minimal product info) just for the UI count
        // until the full revalidation happens.
        final items = cachedUser.cart!
            .map(
              (item) => CartItem(
                product: Product(
                  productId: item.productId,
                  productName: '...',
                  category: '',
                  imageUrl: '',
                  price: 0,
                  realPrice: 0,
                  discount: 0,
                  isAvailable: true,
                  addedAt: DateTime.now(),
                  subcategory: [],
                  quantity: '0',
                  mostSearch: 0,
                  mostPurchases: 0,
                ),
                variantId: item.variantId,
                quantity: item.quantity,
                comboId: item.comboId,
                comboName: item.comboName,
                comboDiscountType: item.comboDiscountType,
                comboDiscountValue: item.comboDiscountValue,
                comboItemQuantity: item.comboItemQuantity,
              ),
            )
            .toList();
        cartItems.assignAll(items);
        _isInitialLoading = false;
        // If not logged in, cache is our only source of truth for now
        if (!AuthController.instance.isLoggedIn) {
          _isInitialSyncComplete = true;
        }
      } catch (e) {
        _isInitialLoading = false;
        debugPrint('Error loading cart count from cache: $e');
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
        // If server fails, allow local changes to sync anyway to prevent further data loss
        _isInitialSyncComplete = true;
      }
    }
  }

  Future<void> refreshCartCurrentData() async {
    final localItems = List<CartItem>.from(cartItems);
    final stored = localItems
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

    final fallbackItems = {
      for (final item in localItems) _cartItemKeyFromUi(item): item,
    };

    try {
      await _revalidateStoredCart(
        stored,
        fallbackItems: fallbackItems,
      );
    } catch (e) {
      debugPrint('Error refreshing cart current data: $e');
      if (cartItems.isEmpty && localItems.isNotEmpty) {
        cartItems.assignAll(localItems);
      }
    }
    try {
      await fetchCartPricing();
    } catch (e) {
      debugPrint('Error refreshing cart pricing: $e');
    }
  }

  Future<void> fetchCartPricing() async {
    if (cartItems.isEmpty) {
      cartPricing.value = null;
      isPricingStale.value = false;
      _lastPricingSnapshot = '';
      _pricingInFlightSnapshot = null;
      _pricingInFlight = null;
      localDeliveryPricing.value = null;
      _updateDeliveryFeeEstimate();
      return;
    }

    final snapshot = [
      _buildMeaningfulCartSnapshot(),
      appliedCoupon.value?.code.trim().toUpperCase() ?? '',
      AuthController.instance.currentUser?.uid ?? 'guest',
    ].join('::');
    if (_pricingInFlightSnapshot == snapshot && _pricingInFlight != null) {
      await _pricingInFlight;
      return;
    }
    if (_lastPricingSnapshot == snapshot && cartPricing.value != null) {
      return;
    }

    final request = () async {
      try {
        final result = await client.pricing.calculateCartPricing(
          _buildCartItemInputs(),
          userId: AuthController.instance.currentUser?.uid,
          appliedCouponCode: appliedCoupon.value?.code,
          autoApplyCoupons: false,
        );
        if (_buildPricingSnapshot() == snapshot) {
          cartPricing.value = result;
          _lastPricingSnapshot = snapshot;
          isPricingStale.value = false;
          // Also update estimate logic if we got config back (if ever exposed)
          _updateDeliveryFeeEstimate();
        }
      } catch (e) {
        debugPrint('Error fetching cart pricing: $e');
      }
    }();

    _pricingInFlightSnapshot = snapshot;
    _pricingInFlight = request;
    try {
      await request;
    } finally {
      if (_pricingInFlightSnapshot == snapshot) {
        _pricingInFlightSnapshot = null;
        _pricingInFlight = null;
      }
    }
  }

  String _buildPricingSnapshot() {
    return [
      _buildMeaningfulCartSnapshot(),
      appliedCoupon.value?.code.trim().toUpperCase() ?? '',
      AuthController.instance.currentUser?.uid ?? 'guest',
    ].join('::');
  }

  Future<void> fetchBasketSuggestions({String? mode}) async {
    final effectiveMode = mode ?? (cartItems.isEmpty ? 'empty' : 'cart');
    final snapshot = effectiveMode == 'empty'
        ? 'empty::${AuthController.instance.currentUser?.uid ?? 'guest'}'
        : '$effectiveMode::${_buildMeaningfulCartSnapshot()}';

    if (effectiveMode == 'cart' && snapshot.endsWith('::')) {
      bestBasketSuggestion.value = null;
      basketSuggestions.clear();
      oldBasketSuggestions.clear();
      isBasketSuggestionsLoading.value = false;
      _lastSuggestedCartSnapshot = '';
      return;
    }
    if (snapshot == _lastSuggestedCartSnapshot) return;

    // 🕵️ Detect mode switch (Empty -> Cart or vice versa)
    final lastMode = _lastSuggestedCartSnapshot.split('::').first;
    if (lastMode.isNotEmpty && lastMode != effectiveMode) {
      bestBasketSuggestion.value = null;
      basketSuggestions.clear();
      oldBasketSuggestions.clear();
    }

    if (basketSuggestions.isNotEmpty) {
      oldBasketSuggestions.assignAll(basketSuggestions);
    }
    isBasketSuggestionsLoading.value = true;
    try {
      final response = await client.pricing.basketSuggestions(
        effectiveMode == 'empty'
            ? const <CartItemInput>[]
            : _buildCartItemInputs(),
        cartTotal: effectiveMode == 'empty' ? 0 : subtotal,
        mode: effectiveMode,
        userId: AuthController.instance.currentUser?.uid,
        appliedCouponCode: appliedCoupon.value?.code,
      );
      final currentSnapshot = effectiveMode == 'empty'
          ? 'empty::${AuthController.instance.currentUser?.uid ?? 'guest'}'
          : '$effectiveMode::${_buildMeaningfulCartSnapshot()}';
      if (currentSnapshot != snapshot) {
        oldBasketSuggestions.clear();
        isBasketSuggestionsLoading.value = false;
        return;
      }
      bestBasketSuggestion.value =
          response.bestSuggestion ??
          (response.suggestions.isNotEmpty ? response.suggestions.first : null);
      basketSuggestions.assignAll(
        response.otherSuggestions ??
            (response.suggestions.length > 1
                ? response.suggestions.skip(1).toList(growable: false)
                : const <BasketSuggestion>[]),
      );
      _lastSuggestedCartSnapshot = snapshot;

      // Pre-fetch combo products for the UI to show multiple images
      _prefetchComboProductsFromSuggestions(response.suggestions);
    } catch (e) {
      debugPrint('Error fetching basket suggestions: $e');
    } finally {
      isBasketSuggestionsLoading.value = false;
    }
  }

  void _prefetchComboProductsFromSuggestions(
    List<BasketSuggestion> suggestions,
  ) {
    final comboIds = suggestions
        .where((s) => s.comboId != null && s.comboId!.isNotEmpty)
        .map((s) => s.comboId!)
        .toSet();

    if (comboIds.isEmpty) return;

    // Ensure combos are loaded first
    ComboOfferController.instance.fetchActiveComboOffersIfEmpty().then((_) {
      final productIds = <String>{};
      for (final id in comboIds) {
        final combo = ComboOfferController.instance.activeComboOffers
            .firstWhereOrNull((c) => c.comboId == id);
        if (combo != null) {
          productIds.addAll(combo.comboProducts.map((p) => p.productId));
        }
      }
      if (productIds.isNotEmpty) {
        ProductProviderController.instance.fetchProductsByIds(
          productIds.toList(),
        );
      }
    });
  }

  String _buildMeaningfulCartSnapshot() {
    final normalizedItems =
        cartItems
            .map(
              (item) => [
                item.product.productId ?? '',
                item.variantId ?? '',
                item.comboId ?? '',
                item.quantity.toString(),
              ].join(':'),
            )
            .where((entry) => !entry.startsWith(':'))
            .toList()
          ..sort();
    return normalizedItems.join('|');
  }

  void _scheduleCartValidation() {
    if (cartItems.isEmpty) return;
    _cartValidationDebounce?.cancel();
    _cartValidationDebounce = Timer(const Duration(milliseconds: 350), () {
      refreshCartCurrentData();
    });
  }

  Future<void> _revalidateStoredCart(
    List<protocol.CartItem> storedCart, {
    Map<String, CartItem>? fallbackItems,
  }) async {
    if (storedCart.isEmpty) {
      cartItems.clear();
      _lastSuggestedCartSnapshot = '';
      return;
    }

    final productIds = storedCart
        .map((item) => item.productId.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final productsFuture = productIds.isEmpty
        ? Future.value(const <Product>[])
        : client.product.getProductsByIds(productIds);
    final bogoFuture = BogoController.instance.activeOffers.isNotEmpty
        ? Future.value(BogoController.instance.activeOffers.toList())
        : client.bogo.getActiveOffers();
    final comboFuture =
        ComboOfferController.instance.activeComboOffers.isNotEmpty
        ? Future.value(ComboOfferController.instance.activeComboOffers.toList())
        : client.comboOffer.getActiveComboOffers();

    final responses = await Future.wait([
      productsFuture,
      bogoFuture,
      comboFuture,
    ]);
    final currentProducts = responses[0] as List<Product>;
    final productMap = {
      for (final product in currentProducts)
        if (product.productId != null) product.productId!: product,
    };
    final activeBogoOffers = responses[1] as List<BogoOffer>;
    final activeComboOffers = responses[2] as List<ComboOffer>;

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
      final fallbackItem = fallbackItems?[_cartItemKeyFromProtocol(item)];
      final baseProduct = productMap[item.productId];
      if (baseProduct == null) {
        if (fallbackItem != null) normalized.add(fallbackItem);
        continue;
      }

      final variant = _resolveExistingVariant(
        baseProduct,
        variantId: item.variantId,
      );
      if (variant == null || !variant.isAvailable) {
        if (fallbackItem != null) normalized.add(fallbackItem);
        continue;
      }

      final selectedProduct = applyVariantToProduct(
        baseProduct,
        variantId: variant.variantId,
      );

      String? validatedFreeProductId = item.bogoFreeProductId;
      if (validatedFreeProductId != null) {
        final bogoOffer = activeBogoOffers.firstWhereOrNull(
          (offer) =>
              offer.triggerProductId == item.productId &&
              isBogoTriggerVariantEligible(
                baseProduct,
                offer: offer,
                selectedVariantId: variant.variantId,
              ),
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
      if (activeCombo == null) {
        final fallbackComboItems = storedCart
            .where((item) => item.comboId == entry.key)
            .map((item) => fallbackItems?[_cartItemKeyFromProtocol(item)])
            .whereType<CartItem>()
            .toList();
        normalized.addAll(fallbackComboItems);
        continue;
      }

      final bundleCount = _inferStoredBundleCount(entry.value);
      if (bundleCount <= 0) {
        final fallbackComboItems = storedCart
            .where((item) => item.comboId == entry.key)
            .map((item) => fallbackItems?[_cartItemKeyFromProtocol(item)])
            .whereType<CartItem>()
            .toList();
        normalized.addAll(fallbackComboItems);
        continue;
      }

      final resolved = resolveComboProducts(activeCombo, currentProducts);
      if (resolved.length != activeCombo.comboProducts.length) {
        final fallbackComboItems = storedCart
            .where((item) => item.comboId == entry.key)
            .map((item) => fallbackItems?[_cartItemKeyFromProtocol(item)])
            .whereType<CartItem>()
            .toList();
        normalized.addAll(fallbackComboItems);
        continue;
      }
      if (resolved.any((item) => !item.selectedVariant.isAvailable)) {
        final fallbackComboItems = storedCart
            .where((item) => item.comboId == entry.key)
            .map((item) => fallbackItems?[_cartItemKeyFromProtocol(item)])
            .whereType<CartItem>()
            .toList();
        normalized.addAll(fallbackComboItems);
        continue;
      }

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

    // MERGE LOGIC: Combine incoming server items with existing local items
    final merged = List<CartItem>.from(cartItems);

    for (final incoming in normalized) {
      final key = _cartItemKeyFromUi(incoming);
      final existingIndex = merged.indexWhere(
        (it) => _cartItemKeyFromUi(it) == key,
      );

      if (existingIndex != -1) {
        // If it exists in both, REPLACE with the server-side version (to get real prices)
        // while maintaining the quantity preference (server usually wins on sync)
        final existing = merged[existingIndex];

        // If local quantity was higher, keep it (optional, but server is safer for startup sync)
        final finalQuantity = incoming.quantity > existing.quantity
            ? incoming.quantity
            : existing.quantity;

        merged[existingIndex] = CartItem(
          product: incoming.product,
          variantId: incoming.variantId,
          quantity: finalQuantity,
          bogoFreeProductId: incoming.bogoFreeProductId,
          comboId: incoming.comboId,
          comboName: incoming.comboName,
          comboDiscountType: incoming.comboDiscountType,
          comboDiscountValue: incoming.comboDiscountValue,
          comboItemQuantity: incoming.comboItemQuantity,
        );
      } else {
        // If it's new from server, add it
        merged.add(incoming);
      }
    }

    cartItems.assignAll(merged);
    _isInitialSyncComplete = true; // Unlock server sync after first merge

    // Explicitly refresh calculations once real products are in
    _updateDeliveryFeeEstimate();
    unawaited(fetchCartPricing());
  }

  String _cartItemKeyFromUi(CartItem item) {
    return [
      item.product.productId ?? '',
      item.variantId ?? '',
      item.comboId ?? '',
    ].join(':');
  }

  String _cartItemKeyFromProtocol(protocol.CartItem item) {
    return [
      item.productId,
      item.variantId ?? '',
      item.comboId ?? '',
    ].join(':');
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
  final Rxn<BestCouponResult> bestCoupon = Rxn<BestCouponResult>();
  final RxBool isLoadingCoupons = false.obs;
  final RxBool isApplyingCoupon = false.obs;
  final RxnString applyingCouponCode = RxnString();
  final RxString couponError = ''.obs;
  String? _couponCacheKey;
  bool _hasCouponCacheForCurrentCart = false;

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

  double get mrpTotal {
    return cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.realPrice * item.quantity),
    );
  }

  double get productDiscountTotal {
    return cartItems.fold<double>(
      0,
      (sum, item) {
        final savings = item.product.realPrice - item.product.price;
        if (savings <= 0) return sum;
        return sum + (savings * item.quantity);
      },
    );
  }

  double get comboDiscountTotal {
    return comboGroups.fold<double>(0, (sum, group) => sum + group.savings);
  }

  double get bogoDiscountTotal {
    return cartPricing.value?.bogoDiscount ?? 0;
  }

  double get totalSavings {
    return productDiscountTotal + comboDiscountTotal + bogoDiscountTotal;
  }

  double get deliveryFee {
    if (isPricingStale.value) return estimatedDeliveryFee.value;
    return cartPricing.value?.deliveryPricing?.deliveryFee ??
        cartPricing.value?.deliveryFee ??
        estimatedDeliveryFee.value;
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
    if (isPricingStale.value) {
      return ((subtotal - couponDiscount) + deliveryFee).clamp(
        0,
        double.infinity,
      );
    }
    return cartPricing.value?.totalAmount ??
        ((subtotal - couponDiscount) + deliveryFee).clamp(0, double.infinity);
  }

  Future<void> fetchAvailableCoupons({bool force = false}) async {
    if (cartItems.isEmpty) {
      availableCoupons.clear();
      bestCoupon.value = null;
      _couponCacheKey = null;
      _hasCouponCacheForCurrentCart = false;
      removeCoupon();
      return;
    }

    final currentCacheKey = _buildCouponCacheKey();
    if (!force &&
        _hasCouponCacheForCurrentCart &&
        _couponCacheKey == currentCacheKey) {
      return;
    }

    isLoadingCoupons.value = true;
    couponError.value = '';

    try {
      final cartItemInputs = _buildCartItemInputs();
      final userId = _couponUserId;
      final response = await client.coupon.getAvailableCoupons(
        userId,
        subtotal,
        cartItemInputs,
      );
      availableCoupons.assignAll(response);
      final bestDisplay =
          response.firstWhereOrNull((coupon) => coupon.isBest) ??
          response.firstWhereOrNull(
            (coupon) => coupon.isApplicable && (coupon.discountAmount ?? 0) > 0,
          );
      bestCoupon.value = bestDisplay == null
          ? null
          : BestCouponResult(
              bestCouponCode: bestDisplay.code,
              discountAmount: bestDisplay.discountAmount ?? 0,
            );
      _syncAutoAppliedBestCoupon();
      _couponCacheKey = currentCacheKey;
      _hasCouponCacheForCurrentCart = true;
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
      final result = await client.coupon.applyCoupon(
        _couponUserId,
        coupon.code,
        subtotal,
        _buildCartItemInputs(),
      );
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

    final normalizedCode = couponCode.trim().toUpperCase();
    couponError.value = '';
    isApplyingCoupon.value = true;
    applyingCouponCode.value = normalizedCode;

    try {
      final response = await client.coupon.applyCoupon(
        _couponUserId,
        normalizedCode,
        subtotal,
        _buildCartItemInputs(),
      );
      final result = response;

      couponValidation.value = result;

      if (result.isValid) {
        final matchedCoupon = availableCoupons.firstWhereOrNull(
          (c) => c.code.toUpperCase() == normalizedCode,
        );
        appliedCoupon.value = matchedCoupon;
        await fetchCartPricing();
        return true;
      } else {
        couponError.value = result.errorMessage ?? 'Invalid coupon';
        appliedCoupon.value = null;
        await fetchCartPricing();
        return false;
      }
    } catch (e) {
      couponError.value = 'Error applying coupon';
      debugPrint('Error applying coupon: $e');
      return false;
    } finally {
      isApplyingCoupon.value = false;
      applyingCouponCode.value = null;
    }
  }

  void removeCoupon() {
    appliedCoupon.value = null;
    couponValidation.value = null;
    couponError.value = '';
    fetchCartPricing();
  }

  void _syncAutoAppliedBestCoupon() {
    final bestCode = bestCoupon.value?.bestCouponCode?.trim();
    if (bestCode == null || bestCode.isEmpty) return;

    final matchedCoupon = availableCoupons.firstWhereOrNull(
      (coupon) => coupon.code.toUpperCase() == bestCode.toUpperCase(),
    );
    if (matchedCoupon == null || !matchedCoupon.isApplicable) return;

    final currentAppliedCode = appliedCoupon.value?.code.trim().toUpperCase();
    if (currentAppliedCode != null &&
        currentAppliedCode.isNotEmpty &&
        currentAppliedCode != bestCode.toUpperCase()) {
      return;
    }

    appliedCoupon.value = matchedCoupon;
    couponValidation.value = CouponValidationResult(
      isValid: true,
      couponCode: matchedCoupon.code,
      couponId: matchedCoupon.id,
      couponType: matchedCoupon.type,
      errorMessage: null,
      discountAmount: matchedCoupon.discountAmount ?? 0,
      isDeliveryDiscount: false,
    );
  }

  String get _couponUserId {
    final authController = AuthController.instance;
    return authController.currentUser?.uid ?? '';
  }

  bool get hasCouponDataForCurrentCart {
    if (cartItems.isEmpty) return false;
    return _hasCouponCacheForCurrentCart &&
        _couponCacheKey == _buildCouponCacheKey();
  }

  Future<void> ensureAvailableCouponsLoaded() {
    return fetchAvailableCoupons();
  }

  String _buildCouponCacheKey() {
    final normalizedItems =
        _buildCartItemInputs()
            .map(
              (item) =>
                  '${item.productId}:${item.variantId ?? ''}:${item.quantity}',
            )
            .toList()
          ..sort();
    return [
      _couponUserId,
      subtotal.toStringAsFixed(2),
      normalizedItems.join('|'),
    ].join('::');
  }

  List<CartItemInput> _buildCartItemInputs() {
    return cartItems
        .map(
          (item) => CartItemInput(
            productId: item.product.productId ?? '',
            variantId: item.variantId,
            quantity: item.quantity,
            comboId: item.comboId,
            bogoFreeProductId: item.bogoFreeProductId,
          ),
        )
        .where((item) => item.productId.isNotEmpty && item.quantity > 0)
        .toList();
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
    _scheduleCartRefresh();
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
      _scheduleCartRefresh();
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
      _scheduleCartRefresh();
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
      _scheduleCartRefresh();
    }
  }

  bool switchRegularItemVariant(
    String productId, {
    String? fromVariantId,
    required String toVariantId,
  }) {
    final baseProduct =
        ProductProviderController.instance.allProducts.firstWhereOrNull(
          (product) => product.productId == productId,
        ) ??
        _findProductById(productId);
    if (baseProduct == null) return false;

    final resolvedToVariantId = resolveProductVariant(
      baseProduct,
      variantId: toVariantId,
    ).variantId;
    final normalizedFromVariantId = fromVariantId ?? 'default';
    if (normalizedFromVariantId == resolvedToVariantId) {
      return true;
    }

    final fromIndex = cartItems.indexWhere(
      (item) =>
          item.product.productId == productId &&
          (item.variantId ?? 'default') == normalizedFromVariantId &&
          item.comboId == null,
    );
    final effectiveFromIndex = fromIndex != -1
        ? fromIndex
        : cartItems.indexWhere(
            (item) =>
                item.product.productId == productId && item.comboId == null,
          );
    if (effectiveFromIndex == -1) return false;

    final currentItem = cartItems[effectiveFromIndex];
    final targetIndex = cartItems.indexWhere(
      (item) =>
          item.product.productId == productId &&
          (item.variantId ?? 'default') == resolvedToVariantId &&
          item.comboId == null,
    );

    if (targetIndex != -1) {
      cartItems[targetIndex].quantity += currentItem.quantity;
      cartItems.removeAt(effectiveFromIndex);
      cartItems.refresh();
      _scheduleCartRefresh();
      return true;
    }

    final updatedItem = CartItem(
      product: applyVariantToProduct(
        baseProduct,
        variantId: resolvedToVariantId,
      ),
      variantId: resolvedToVariantId,
      quantity: currentItem.quantity,
      bogoFreeProductId: null,
    );
    cartItems[effectiveFromIndex] = updatedItem;
    cartItems.refresh();
    _scheduleCartRefresh();
    return true;
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
    _scheduleCartRefresh();
  }

  void clearCart() {
    cartItems.clear();
    bogoSuggestion.value = null;
    bestBasketSuggestion.value = null;
    basketSuggestions.clear();
    cartPricing.value = null;
    _lastSuggestedCartSnapshot = '';
    _scheduleCartRefresh();
  }

  void setBogoSelection(
    String triggerProductId,
    String? freeProductId, {
    String? triggerVariantId,
  }) {
    final triggerProduct =
        ProductProviderController.instance.allProducts.firstWhereOrNull(
          (product) => product.productId == triggerProductId,
        ) ??
        _findProductById(triggerProductId);
    final offer = BogoController.instance.getOfferForProduct(triggerProductId);
    if (triggerProduct != null &&
        offer != null &&
        !isBogoTriggerVariantEligible(
          triggerProduct,
          offer: offer,
          selectedVariantId: triggerVariantId,
        )) {
      return;
    }

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
    if (!isBogoTriggerVariantEligible(
      suggestion.triggerProduct,
      offer: suggestion.offer,
      selectedVariantId: suggestion.triggerVariantId,
    )) {
      return false;
    }

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
          item.comboId == null &&
          isBogoTriggerVariantEligible(
            triggerProduct,
            offer: offer,
            selectedVariantId: item.variantId,
          ),
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

  Future<void> _applyBogoAction(BasketSuggestionAction action) async {
    final triggerProductId = action.productId;
    if (triggerProductId == null || triggerProductId.trim().isEmpty) return;

    await BogoController.instance.fetchActiveOffersIfEmpty();

    final baseProduct =
        ProductProviderController.instance.allProducts.firstWhereOrNull(
          (product) => product.productId == triggerProductId,
        ) ??
        _findProductById(triggerProductId);
    if (baseProduct == null) return;

    final currentVariantId = action.payload?['currentVariantId'];
    final resolvedVariantId = resolveProductVariant(
      baseProduct,
      variantId: action.variantId,
    ).variantId;

    if (currentVariantId != null &&
        currentVariantId.trim().isNotEmpty &&
        currentVariantId != resolvedVariantId) {
      switchRegularItemVariant(
        triggerProductId,
        fromVariantId: currentVariantId,
        toVariantId: resolvedVariantId,
      );
    }

    var triggerItem = cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == triggerProductId &&
          (item.variantId ?? 'default') == resolvedVariantId &&
          item.comboId == null,
    );
    if (triggerItem == null) {
      addItem(
        baseProduct,
        variantId: resolvedVariantId,
        triggerBogoSuggestion: false,
      );
      triggerItem = cartItems.firstWhereOrNull(
        (item) =>
            item.product.productId == triggerProductId &&
            (item.variantId ?? 'default') == resolvedVariantId &&
            item.comboId == null,
      );
    }

    final offer = BogoController.instance.activeOffers.firstWhereOrNull(
      (candidate) =>
          candidate.isActive &&
          candidate.triggerProductId == triggerProductId,
    );
    if (offer == null || offer.freeProductIds.isEmpty) return;
    final isEligible = isBogoTriggerVariantEligible(
      baseProduct,
      offer: offer,
      selectedVariantId: resolvedVariantId,
    );

    final selectedFreeProductId = triggerItem?.bogoFreeProductId;
    if (selectedFreeProductId != null &&
        isEligible &&
        offer.freeProductIds.contains(selectedFreeProductId)) {
      return;
    }

    if (isEligible && offer.freeProductIds.length == 1) {
      setBogoSelection(
        triggerProductId,
        offer.freeProductIds.first,
        triggerVariantId: resolvedVariantId,
      );
      return;
    }

    await Get.bottomSheet(
      BogoSelectionBottomSheet(
        triggerProductId: triggerProductId,
        triggerVariantId: resolvedVariantId,
        freeProductIds: offer.freeProductIds,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> applyBasketSuggestion(BasketSuggestion suggestion) async {
    final actions = suggestion.type == 'combined'
        ? (suggestion.actions ?? []).take(3).toList(growable: false)
        : (suggestion.actions ?? []);
    if (actions.isEmpty) return;

    for (final action in actions) {
      switch (action.type) {
        case 'product':
        case 'add_to_cart':
          final product = _findProductById(
            action.productId,
            variantId: action.variantId,
          );
          if (product != null) {
            addItem(
              product,
              variantId: action.variantId,
              triggerBogoSuggestion: false,
            );
          }
          break;

        case 'bogo':
          await _applyBogoAction(action);
          break;

        case 'combo':
          await ComboOfferController.instance.fetchActiveComboOffersIfEmpty();
          final comboId = action.comboId ?? action.payload?['comboId'];
          final combo = ComboOfferController.instance.activeComboOffers
              .firstWhereOrNull(
                (offer) => (offer.comboId ?? offer.name) == comboId,
              );
          if (combo != null) {
            addComboOffer(combo);
          }
          break;

        case 'variant':
          final currentProduct = _findProductById(action.productId);
          final baseProduct = ProductProviderController.instance.allProducts
              .firstWhereOrNull(
                (product) => product.productId == action.productId,
              );
          if (currentProduct != null && baseProduct != null) {
            removeItem(
              currentProduct,
              variantId: inferProductVariantId(currentProduct),
            );
            addItem(
              baseProduct,
              variantId: action.variantId,
              triggerBogoSuggestion: false,
            );
          }
          break;

        case 'coupon':
        case 'apply_coupon':
          if (action.couponCode != null) {
            // Small delay to let previous cart updates settle if multiple actions
            if (actions.length > 1) {
              await Future.delayed(const Duration(milliseconds: 300));
            }
            await applyCoupon(action.couponCode!);
          }
          break;

        case 'delivery':
          break;

        case 'navigate':
          SuggestionNavigationHelper.handleTap(suggestion);
          // For pure navigation actions, we might NOT want to remove the suggestion
          // immediately so the user can go back to it.
          // However, to keep it consistent with the user's request (it was being removed),
          // we continue the loop.
          break;

        default:
          break;
      }
    }

    // Remove the applied suggestion from the list
    basketSuggestions.remove(suggestion);
  }
}
