import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:get/get.dart';

class BogoCartSuggestionBanner extends StatefulWidget {
  const BogoCartSuggestionBanner({super.key});

  @override
  State<BogoCartSuggestionBanner> createState() =>
      _BogoCartSuggestionBannerState();
}

class _BogoCartSuggestionBannerState extends State<BogoCartSuggestionBanner> {
  final _cartController = CartController.instance;
  final _bogoController = BogoController.instance;
  final _notificationController = NotificationController.instance;

  late final Worker _suggestionWorker;
  String? _lastShownId;

  @override
  void initState() {
    super.initState();
    _suggestionWorker = ever<BogoCartSuggestion?>(
      _cartController.bogoSuggestion,
      _handleSuggestionChanged,
    );
  }

  @override
  void dispose() {
    _suggestionWorker.dispose();
    super.dispose();
  }

  void _handleSuggestionChanged(BogoCartSuggestion? suggestion) {
    if (suggestion == null) {
      _lastShownId = null;
      return;
    }

    final triggerId = suggestion.triggerProduct.productId ?? 'unknown-trigger';
    final freeId = suggestion.freeProduct.productId ?? 'unknown-free';
    final notificationId = 'bogo:$triggerId:$freeId';
    if (_lastShownId == notificationId) return;
    _lastShownId = notificationId;

    final freeQuantityLabel = _bogoController.freeProductQuantityLabel(
      suggestion.offer.triggerProductId,
      suggestion.freeProduct.productId ?? '',
      fallback: suggestion.freeProduct.quantity,
    );
    final message =
        'Buy ${suggestion.triggerProduct.productName} to get ${suggestion.freeProduct.productName} ($freeQuantityLabel) free';

    _notificationController.saveNotification(
      AppNotificationItem(
        id: notificationId,
        title: 'BOGO Alert',
        message: message,
        createdAt: DateTime.now(),
        product: suggestion.triggerProduct,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentContext = Get.context ?? context;
      final messenger = ScaffoldMessenger.maybeOf(currentContext);
      if (messenger == null) return;

      messenger
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
