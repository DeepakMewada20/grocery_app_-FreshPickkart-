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
import 'package:play_install_referrer/play_install_referrer.dart'
    if (dart.library.html) 'package:freshpickkat_flutter/services/deep_link_referrer_stub.dart';

class DeepLinkService extends GetxService {
  static DeepLinkService get instance => Get.find<DeepLinkService>();

  static const _installReferrerCheckedKey = 'install_referrer_checked_v1';
  static const _pendingReferralCodeKey = 'pending_referral_code';
  static const _duplicateWindow = Duration(seconds: 2);

  final _appLinks = AppLinks();
  final _storage = GetStorage();
  StreamSubscription<Uri>? _subscription;
  String? _lastHandledKey;
  DateTime? _lastHandledAt;

  final isResolving = false.obs;

  Future<DeepLinkService> init() async {
    // Stream for subsequent deep links (app already running / resume)
    _subscription = _appLinks.uriLinkStream.listen(
      handleUri,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error('DeepLink', 'Stream: $error');
      },
    );

    // Initial URI (cold start) — wait for first frame so navigator is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final initialUri = await _appLinks.getInitialLink();
        if (initialUri != null) {
          final target = RouteManager.fromUri(initialUri);
          if (target != null) {
            await _navigateColdStart(target);
          }
        }
      } catch (error) {
        AppLogger.error('DeepLink', 'Initial URI: $error');
      }
      _restoreInstallReferrerDeepLink();
    });

    return this;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Stores a pending referral code from invite deep links.
  /// Call [consumePendingReferralCode] to retrieve and clear it.
  void storePendingReferralCode(String code) {
    _storage.write(_pendingReferralCodeKey, code.trim().toUpperCase());
  }

  /// Returns the pending referral code and clears it from storage.
  String? consumePendingReferralCode() {
    final code = _storage.read<String>(_pendingReferralCodeKey);
    if (code != null) {
      _storage.remove(_pendingReferralCodeKey);
    }
    return code;
  }

  Future<void> handleUri(
    Uri uri, {
    RouteNavigationMode mode = RouteNavigationMode.to,
  }) async {
    final target = RouteManager.fromUri(uri);
    if (target == null) {
      AppLogger.info('DeepLink', 'Ignoring unsupported deep link: $uri');
      return;
    }
    await openTarget(target, mode: mode);
  }

  /// Cold-start deep link: replace splash with home, then push the target
  /// on top. This way back from the target returns to home (not splash).
  /// For invite links the target is already home, so only step 1 runs.
  Future<void> _navigateColdStart(DeepLinkTarget target) async {
    await _waitForNextFrame();
    await RouteManager.navigate(
      const DeepLinkTarget(type: DeepLinkType.invite, value: '', uri: null),
      mode: RouteNavigationMode.off,
    );
    if (target.type != DeepLinkType.invite) {
      await RouteManager.navigate(target, mode: RouteNavigationMode.to);
    }
  }

  Future<void> openTarget(
    DeepLinkTarget target, {
    RouteNavigationMode mode = RouteNavigationMode.to,
  }) async {
    if (_isDuplicate(target)) return;
    _remember(target);

    if (target.type == DeepLinkType.invite) {
      storePendingReferralCode(target.value);
    }

    await _waitForNextFrame();
    await RouteManager.navigate(target, mode: mode);
  }

  /// Waits for the next frame to ensure navigation doesn't occur
  /// during Flutter's initial warm-up frame or app resume.
  Future<void> _waitForNextFrame() async {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    await completer.future;
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
      AppLogger.info(
        'DeepLink',
        'Restored deferred deep link from Play referrer: $uri',
      );
      final target = RouteManager.fromUri(uri);
      if (target != null) {
        await _navigateColdStart(target);
      }
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
}
