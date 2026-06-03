import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ShareService extends GetxService {
  static ShareService get instance => Get.find<ShareService>();

  String productShareText(Product product) {
    final productId = product.productId?.trim();
    final link = productId == null || productId.isEmpty
        ? Uri.https(RouteManager.primaryHost).toString()
        : RouteManager.productUri(productId).toString();

    return '🥭 ${product.productName}\n\n'
        '₹${product.price.formatPrice}\n\n'
        'Buy now on FreshPickKat:\n\n'
        '$link';
  }

  Future<void> shareProduct(Product product, {BuildContext? context}) async {
    final box = context?.findRenderObject() as RenderBox?;
    await Share.share(
      productShareText(product),
      subject: 'FreshPickKat: ${product.productName}',
      sharePositionOrigin: box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
