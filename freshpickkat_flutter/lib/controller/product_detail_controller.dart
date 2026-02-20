import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final Rx<Product> product;

  ProductDetailController(Product initialProduct)
    : product = initialProduct.obs;

  void updateProduct(Product newProduct) {
    product.value = newProduct;
  }
}
