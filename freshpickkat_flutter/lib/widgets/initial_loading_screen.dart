import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:get/get.dart';

class NetworkErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    super.key,
    this.message = 'No internet connection',
    required this.onRetry,
  });

  @override
  State<NetworkErrorWidget> createState() => _NetworkErrorWidgetState();
}

class _NetworkErrorWidgetState extends State<NetworkErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _performRetry() async {
    if (_isRetrying) return;
    setState(() {
      _isRetrying = true;
    });

    final networkController = NetworkController.instance;
    final connected = await networkController.checkConnection();

    if (connected) {
      widget.onRetry();
    } else {
      setState(() {
        _isRetrying = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 50,
                      color: Colors.red.shade400,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'No Internet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            if (_isRetrying)
              const CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              )
            else
              ElevatedButton.icon(
                onPressed: _performRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Obx(() {
              if (networkController.isConnected.value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _performRetry();
                });
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

class NetworkStatusBanner extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isBottom;

  const NetworkStatusBanner({
    super.key,
    this.onRetry,
    this.isBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Obx(() {
      if (networkController.isConnected.value) {
        return const SizedBox.shrink();
      }

      if (isBottom) {
        return _buildBottomBanner(context, networkController);
      }
      return _buildTopBanner(networkController);
    });
  }

  Widget _buildBottomBanner(
    BuildContext context,
    NetworkController controller,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No Internet',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Check your connection',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (onRetry != null) {
                      onRetry!();
                    } else {
                      final connected = await controller.checkConnection();
                      if (connected && context.mounted) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner(NetworkController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.red.shade600,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Some features may not work',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                if (onRetry != null) {
                  onRetry!();
                } else {
                  await controller.checkConnection();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionQualityIndicator extends StatelessWidget {
  const ConnectionQualityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Obx(() {
      if (!networkController.isConnected.value ||
          networkController.connectionQuality.value ==
              ConnectionQuality.unknown) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getQualityColor(
            networkController.connectionQuality.value,
          ).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(3, (index) {
              final isActive =
                  index <
                  _getBarsCount(networkController.connectionQuality.value);
              return Container(
                width: 4,
                height: 6 + (index * 3).toDouble(),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? _getQualityColor(
                          networkController.connectionQuality.value,
                        )
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
            const SizedBox(width: 6),
            Text(
              networkController.connectionQualityLabel,
              style: TextStyle(
                fontSize: 10,
                color: _getQualityColor(
                  networkController.connectionQuality.value,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  int _getBarsCount(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return 3;
      case ConnectionQuality.good:
        return 2;
      case ConnectionQuality.poor:
        return 1;
      case ConnectionQuality.unknown:
        return 0;
    }
  }

  Color _getQualityColor(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return Colors.green;
      case ConnectionQuality.good:
        return Colors.orange;
      case ConnectionQuality.poor:
        return Colors.red;
      case ConnectionQuality.unknown:
        return Colors.grey;
    }
  }
}

class GroceryLoadingAnimation extends StatefulWidget {
  const GroceryLoadingAnimation({super.key});

  @override
  State<GroceryLoadingAnimation> createState() =>
      _GroceryLoadingAnimationState();
}

class _GroceryLoadingAnimationState extends State<GroceryLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildShimmerItem(),
              const SizedBox(height: 16),
              _buildShimmerItem(),
              const SizedBox(height: 16),
              _buildShimmerItem(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
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
