import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as protocol;
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  static CartController get instance =>
      Get.put(CartController(), permanent: true);

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final client = ServerpodClient().client;

  @override
  void onInit() {
    super.onInit();
    // Listen to cart changes and sync with server
    ever(cartItems, (_) {
      _syncWithServer();
      fetchAvailableCoupons();
    });
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
                CartItem(product: product, quantity: item.quantity),
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

  void addItem(Product product) {
    int index = cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
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
  }
}
