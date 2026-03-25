import 'package:freshpickkat_client/freshpickkat_client.dart' hide CartItem;
import 'package:freshpickkat_client/freshpickkat_client.dart'
    as protocol
    show CartItem;
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class CartItem {
  final Product product;
  int quantity;
  String? bogoFreeProductId; // Selected free item ID

  CartItem({
    required this.product,
    this.quantity = 1,
    this.bogoFreeProductId,
  });
}

class BogoCartSuggestion {
  final BogoOffer offer;
  final Product triggerProduct;
  final Product freeProduct;

  const BogoCartSuggestion({
    required this.offer,
    required this.triggerProduct,
    required this.freeProduct,
  });
}

class CartController extends GetxController {
  static CartController get instance =>
      Get.put(CartController(), permanent: true);

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final Rxn<BogoCartSuggestion> bogoSuggestion = Rxn<BogoCartSuggestion>();
  final client = ServerpodClient().client;

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
      ProductProviderController.instance.allProducts,
      (_) => _refreshBogoSuggestion(),
    );
  }

  Future<void> _handleCartChanged() async {
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
                quantity: item.quantity,
                bogoFreeProductId: item.bogoFreeProductId,
              ),
            )
            .toList();

        await client.user.updateCart(
          authController.currentUser!.uid,
          protocolCart,
        );
      } catch (e) {
        print('Error syncing cart to server: $e');
      }
    }
  }

  Future<void> fetchCartFromServer() async {
    final authController = AuthController.instance;
    if (authController.isLoggedIn && authController.currentUser != null) {
      try {
        final serverUser = await client.user.getUserByFirebaseUid(
          authController.currentUser!.uid,
        );
        if (serverUser != null && serverUser.cart != null) {
          final productController = ProductProviderController.instance;
          final List<CartItem> newCartItems = [];

          for (var item in serverUser.cart!) {
            final product = productController.allProducts.firstWhereOrNull(
              (p) => p.productId == item.productId,
            );
            if (product != null) {
              newCartItems.add(
                CartItem(
                  product: product,
                  quantity: item.quantity,
                  bogoFreeProductId: item.bogoFreeProductId,
                ),
              );
            }
          }

          // Disable syncing while loading from server to avoid loop
          cartItems.assignAll(newCartItems);
        }
      } catch (e) {
        print('Error fetching cart from server: $e');
      }
    }
  }

  // Rx derived properties
  int get itemCount => cartItems.length;

  // Coupon state
  final Rxn<CouponDisplay> appliedCoupon = Rxn<CouponDisplay>();
  final Rxn<CouponValidationResult> couponValidation =
      Rxn<CouponValidationResult>();
  final RxList<CouponDisplay> availableCoupons = <CouponDisplay>[].obs;
  final RxBool isLoadingCoupons = false.obs;
  final RxString couponError = ''.obs;

  double get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get totalSavings => cartItems.fold(
    0,
    (sum, item) =>
        sum + ((item.product.realPrice - item.product.price) * item.quantity),
  );

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
      print('Error fetching coupons: $e');
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
      print('Error applying coupon: $e');
      return false;
    }
  }

  void removeCoupon() {
    appliedCoupon.value = null;
    couponValidation.value = null;
    couponError.value = '';
  }

  void addItem(Product product, {bool triggerBogoSuggestion = true}) {
    int index = cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }

    if (triggerBogoSuggestion) {
      _maybeSuggestBogoForFreeProduct(product);
    }
  }

  void removeItem(Product product) {
    int index = cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  void updateQuantity(Product product, int quantity) {
    int index = cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = quantity;
        cartItems.refresh();
      }
    } else if (quantity > 0) {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }

  int getProductQuantity(String? productId) {
    if (productId == null) return 0;
    int index = cartItems.indexWhere(
      (item) => item.product.productId == productId,
    );
    return index != -1 ? cartItems[index].quantity : 0;
  }

  void clearCart() {
    cartItems.clear();
    bogoSuggestion.value = null;
  }

  void setBogoSelection(String triggerProductId, String? freeProductId) {
    int index = cartItems.indexWhere(
      (item) => item.product.productId == triggerProductId,
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
      (item) => item.product.productId == triggerId,
    );
    if (triggerItem == null) {
      addItem(suggestion.triggerProduct, triggerBogoSuggestion: false);
    }

    setBogoSelection(triggerId, freeId);
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
        freeProduct: refreshedFree,
      );
      return;
    }

    bogoSuggestion.value = null;
    for (final item in cartItems) {
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
      (item) => item.product.productId == freeId,
    );
    if (freeItem == null || freeItem.quantity <= 0) return false;

    final triggerItem = cartItems.firstWhereOrNull(
      (item) => item.product.productId == triggerId,
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
      (item) => item.product.productId == offer.triggerProductId,
    );
    if (triggerItem?.bogoFreeProductId == freeProductId) return null;
    if (triggerItem?.bogoFreeProductId != null &&
        triggerItem!.bogoFreeProductId != freeProductId) {
      return null;
    }

    return BogoCartSuggestion(
      offer: offer,
      triggerProduct: triggerProduct,
      freeProduct: freeProduct,
    );
  }

  Product? _findProductById(String? productId) {
    if (productId == null) return null;

    final cartProduct = cartItems
        .firstWhereOrNull((item) => item.product.productId == productId)
        ?.product;
    if (cartProduct != null) return cartProduct;

    return ProductProviderController.instance.allProducts.firstWhereOrNull(
      (product) => product.productId == productId,
    );
  }
}
