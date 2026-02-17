import 'package:freshpickkat_client/freshpickkat_client.dart';
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
