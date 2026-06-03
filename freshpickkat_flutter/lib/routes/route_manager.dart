import 'package:get/get.dart';

enum DeepLinkType { product, category, offer }

class DeepLinkTarget {
  const DeepLinkTarget({
    required this.type,
    required this.value,
    required this.uri,
  });

  final DeepLinkType type;
  final String value;
  final Uri? uri;

  String get key => '${type.name}:${value.trim().toLowerCase()}';
}

enum RouteNavigationMode { to, off, offAll }

class RouteManager {
  const RouteManager._();

  static const primaryHost = 'freshpickkat.com';
  static const supportedHosts = <String>{
    primaryHost,
    'www.$primaryHost',
  };

  static const home = '/home';
  static const productPattern = '/product/:productId';
  static const categoryPattern = '/category/:categoryId';
  static const offerPattern = '/offer/:offerCode';
  static const productNotFound = '/product-not-found';
  static const deepLinkNotFound = '/deep-link-not-found';

  static Uri productUri(String productId) {
    return Uri.https(primaryHost, '/product/${Uri.encodeComponent(productId)}');
  }

  static Uri categoryUri(String categoryId) {
    return Uri.https(
      primaryHost,
      '/category/${Uri.encodeComponent(categoryId)}',
    );
  }

  static Uri offerUri(String offerCode) {
    return Uri.https(primaryHost, '/offer/${Uri.encodeComponent(offerCode)}');
  }

  static String productPath(String productId) {
    return '/product/${Uri.encodeComponent(productId)}';
  }

  static String categoryPath(String categoryId) {
    return '/category/${Uri.encodeComponent(categoryId)}';
  }

  static String offerPath(String offerCode) {
    return '/offer/${Uri.encodeComponent(offerCode)}';
  }

  static String pathForTarget(DeepLinkTarget target) {
    return switch (target.type) {
      DeepLinkType.product => productPath(target.value),
      DeepLinkType.category => categoryPath(target.value),
      DeepLinkType.offer => offerPath(target.value),
    };
  }

  static DeepLinkTarget? fromUri(Uri uri) {
    if (uri.scheme.toLowerCase() != 'https') return null;
    final host = uri.host.toLowerCase();
    if (!supportedHosts.contains(host)) return null;

    final segments = uri.pathSegments
        .where((segment) => segment.trim().isNotEmpty)
        .map(Uri.decodeComponent)
        .toList(growable: false);
    if (segments.length < 2) return null;

    final value = segments[1].trim();
    if (value.isEmpty) return null;

    return switch (segments.first.toLowerCase()) {
      'product' => DeepLinkTarget(
        type: DeepLinkType.product,
        value: value,
        uri: uri,
      ),
      'category' => DeepLinkTarget(
        type: DeepLinkType.category,
        value: value,
        uri: uri,
      ),
      'offer' => DeepLinkTarget(
        type: DeepLinkType.offer,
        value: value,
        uri: uri,
      ),
      _ => null,
    };
  }

  static DeepLinkTarget? fromGetXRoute(DeepLinkType type) {
    final arguments = Get.arguments;
    if (arguments is DeepLinkTarget && arguments.type == type) {
      return arguments;
    }

    final value = switch (type) {
      DeepLinkType.product => Get.parameters['productId'],
      DeepLinkType.category => Get.parameters['categoryId'],
      DeepLinkType.offer => Get.parameters['offerCode'],
    };

    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    return DeepLinkTarget(type: type, value: trimmed, uri: null);
  }

  static Future<T?> navigate<T>(
    DeepLinkTarget target, {
    RouteNavigationMode mode = RouteNavigationMode.to,
  }) async {
    final path = pathForTarget(target);
    final navigation = switch (mode) {
      RouteNavigationMode.to => Get.toNamed<T>(path, arguments: target),
      RouteNavigationMode.off => Get.offNamed<T>(path, arguments: target),
      RouteNavigationMode.offAll => Get.offAllNamed<T>(path, arguments: target),
    };
    return navigation == null ? null : await navigation;
  }
}
