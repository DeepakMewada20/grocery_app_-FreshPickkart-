import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

class ShareService extends GetxService {
  static ShareService get instance => Get.find<ShareService>();

  String productShareText(Product product) {
    final productId = product.productId?.trim();
    final link = productId == null || productId.isEmpty
        ? Uri.https(RouteManager.primaryHost).toString()
        : RouteManager.productUri(productId).toString();

    final discount = product.realPrice - product.price;
    final discountText = discount > 0
        ? '\nYou save: ₹${discount.formatPrice}'
        : '';

    return '${product.productName}\n\n'
        'MRP: ₹${product.realPrice.formatPrice}\n'
        'Price: ₹${product.price.formatPrice}$discountText\n\n'
        'Buy now on FreshPickKat:\n\n'
        '$link';
  }

  Future<XFile?> _downloadImage(Product product) async {
    try {
      final imageUrl = product.imageUrl.trim();
      if (imageUrl.isEmpty) return null;
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;
      final dir = Directory.systemTemp;
      final ext = imageUrl.split('.').last.split('?').first;
      final file = File(
        '${dir.path}/${product.productId ?? 'product'}.${ext.isEmpty ? 'jpg' : ext}',
      );
      await file.writeAsBytes(response.bodyBytes);
      return XFile(file.path);
    } catch (_) {
      return null;
    }
  }

  Future<void> shareProduct(Product product, {BuildContext? context}) async {
    final text = productShareText(product);

    if (kIsWeb) {
      await Share.share(
        text,
        subject: 'FreshPickKat: ${product.productName}',
      );
      return;
    }

    final box = context?.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    final imageFile = await _downloadImage(product);
    if (imageFile != null) {
      await Share.shareXFiles(
        [imageFile],
        text: text,
        subject: 'FreshPickKat: ${product.productName}',
        sharePositionOrigin: sharePositionOrigin,
      );
    } else {
      await Share.share(
        text,
        subject: 'FreshPickKat: ${product.productName}',
        sharePositionOrigin: sharePositionOrigin,
      );
    }
  }
}
