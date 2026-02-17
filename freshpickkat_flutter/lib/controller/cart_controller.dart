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
    ever(cartItems, (_) => _syncWithServer());
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

  double get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get totalSavings => cartItems.fold(
    0,
    (sum, item) =>
        sum + ((item.product.realPrice - item.product.price) * item.quantity),
  );

  double get deliveryFee => subtotal > 500 ? 0.0 : 40.0;

  double get totalAmount => subtotal + deliveryFee;

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
