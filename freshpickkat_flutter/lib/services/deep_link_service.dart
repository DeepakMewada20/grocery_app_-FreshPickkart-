import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

class DeepLinkService extends GetxService {
  static DeepLinkService get instance => Get.find<DeepLinkService>();

  static const _installReferrerCheckedKey = 'install_referrer_checked_v1';
  static const _duplicateWindow = Duration(seconds: 2);

  final _appLinks = AppLinks();
  final _storage = GetStorage();
  StreamSubscription<Uri>? _subscription;
  String? _lastHandledKey;
  DateTime? _lastHandledAt;

  final isResolving = false.obs;

  Future<DeepLinkService> init() async {
    _subscription = _appLinks.uriLinkStream.listen(
      handleUri,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error('DeepLink', 'Stream: $error');
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreInstallReferrerDeepLink();
    });

    return this;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> handleUri(Uri uri) async {
    final target = RouteManager.fromUri(uri);
    if (target == null) {
      AppLogger.info('DeepLink', 'Ignoring unsupported deep link: $uri');
      return;
    }
    await openTarget(target);
  }

  Future<void> openTarget(
    DeepLinkTarget target, {
    RouteNavigationMode mode = RouteNavigationMode.to,
  }) async {
    if (_isDuplicate(target)) return;
    _remember(target);
    await _waitForNavigator();
    await RouteManager.navigate(target, mode: mode);
  }

  Future<Product?> resolveProduct(String productId) async {
    final trimmed = productId.trim();
    if (trimmed.isEmpty) return null;

    try {
      return ProductProviderController.instance.resolveActiveProductById(
        trimmed,
      );
    } catch (error) {
      AppLogger.error('DeepLink', 'Product $trimmed: $error');
      return null;
    }
  }

  Future<String?> resolveCategoryName(String categoryId) async {
    final trimmed = categoryId.trim();
    if (trimmed.isEmpty) return null;

    try {
      final categoryController = CategoryProviderController.instance;
      await categoryController.fetchCategoriesIfEmpty();
      final normalized = trimmed.toLowerCase();
      final category = categoryController.categories.firstWhereOrNull(
        (item) => item.categoryName.trim().toLowerCase() == normalized,
      );
      return category?.categoryName;
    } catch (error) {
      AppLogger.error('DeepLink', 'Category $trimmed: $error');
      return null;
    }
  }

  Future<void> _restoreInstallReferrerDeepLink() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (_storage.read<bool>(_installReferrerCheckedKey) == true) return;

    _storage.write(_installReferrerCheckedKey, true);

    try {
      final details = await PlayInstallReferrer.installReferrer;
      final uri = _deepLinkFromReferrer(details.installReferrer);
      if (uri == null) return;
      AppLogger.info('DeepLink', 'Restored deferred deep link from Play referrer: $uri');
      await handleUri(uri);
    } catch (error) {
      AppLogger.error('DeepLink', 'Install referrer unavailable: $error');
    }
  }

  Uri? _deepLinkFromReferrer(String? referrer) {
    final raw = referrer?.trim();
    if (raw == null || raw.isEmpty) return null;

    final params = Uri.splitQueryString(raw);
    final encoded = params['deep_link'] ?? params['link'] ?? params['url'];
    if (encoded == null || encoded.trim().isEmpty) return null;

    var decoded = encoded;
    for (var i = 0; i < 2; i++) {
      final next = Uri.decodeComponent(decoded);
      if (next == decoded) break;
      decoded = next;
    }

    return Uri.tryParse(decoded);
  }

  bool _isDuplicate(DeepLinkTarget target) {
    final handledAt = _lastHandledAt;
    if (_lastHandledKey != target.key || handledAt == null) return false;
    return DateTime.now().difference(handledAt) < _duplicateWindow;
  }

  void _remember(DeepLinkTarget target) {
    _lastHandledKey = target.key;
    _lastHandledAt = DateTime.now();
  }

  Future<void> _waitForNavigator() async {
    for (var i = 0; i < 20; i++) {
      if (Get.key.currentState != null) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }
}
