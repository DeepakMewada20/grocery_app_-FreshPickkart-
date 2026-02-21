import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/basket_loading_animation.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    super.key,
    this.message = 'No internet connection',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialLoadingScreen extends StatelessWidget {
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;

  const InitialLoadingScreen({
    super.key,
    this.hasError = false,
    this.errorMessage = '',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return CustomScrollView(
        slivers: [
          const FreshPickKartSliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: NetworkErrorWidget(
              message: errorMessage.isNotEmpty
                  ? 'Unable to load products'
                  : 'No internet connection',
              onRetry: onRetry,
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        const FreshPickKartSliverAppBar(),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: GroceryLoadingAnimation(),
        ),
      ],
    );
  }
}
