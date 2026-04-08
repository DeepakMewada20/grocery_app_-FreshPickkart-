import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:get/get.dart';

class NetworkErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showAutoRetry;

  const NetworkErrorWidget({
    super.key,
    this.message = 'No internet connection',
    required this.onRetry,
    this.showAutoRetry = true,
  });

  @override
  State<NetworkErrorWidget> createState() => _NetworkErrorWidgetState();
}

class _NetworkErrorWidgetState extends State<NetworkErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _autoRetryTimer;
  int _countdownSeconds = 10;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.showAutoRetry) {
      _startAutoRetryTimer();
    }
  }

  void _startAutoRetryTimer() {
    _countdownSeconds = 10;
    _autoRetryTimer?.cancel();
    _autoRetryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdownSeconds--;
      });
      if (_countdownSeconds <= 0) {
        timer.cancel();
        _performRetry();
      }
    });
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
    } else if (widget.showAutoRetry) {
      setState(() {
        _isRetrying = false;
      });
      _startAutoRetryTimer();
    } else {
      setState(() {
        _isRetrying = false;
      });
    }
  }

  @override
  void dispose() {
    _autoRetryTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getConnectionIcon(
                        networkController.connectionType.value,
                      ),
                      size: 60,
                      color: Colors.red.shade400,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _getTitle(networkController.connectionType.value),
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
            const SizedBox(height: 16),
            Obx(() => _buildConnectionTypeIndicator(networkController)),
            const SizedBox(height: 32),
            if (_isRetrying)
              const CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              )
            else ...[
              ElevatedButton.icon(
                onPressed: () {
                  _autoRetryTimer?.cancel();
                  _performRetry();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
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
              if (widget.showAutoRetry && _countdownSeconds > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Auto-retry in $_countdownSeconds seconds',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
            _buildQuickFixes(networkController.connectionType.value),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionTypeIndicator(NetworkController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getConnectionIcon(controller.connectionType.value),
            size: 18,
            color: _getConnectionColor(controller.connectionType.value),
          ),
          const SizedBox(width: 8),
          Text(
            controller.connectionTypeLabel,
            style: TextStyle(
              fontSize: 13,
              color: _getConnectionColor(controller.connectionType.value),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFixes(ConnectionType type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._getTips(type),
        ],
      ),
    );
  }

  List<Widget> _getTips(ConnectionType type) {
    List<String> tips;
    switch (type) {
      case ConnectionType.wifi:
        tips = [
          'Restart your WiFi router',
          'Move closer to the router',
          'Check if WiFi password is correct',
        ];
        break;
      case ConnectionType.mobile:
        tips = [
          'Enable/disable Airplane mode',
          'Restart your phone',
          'Check if mobile data is enabled',
        ];
        break;
      case ConnectionType.none:
      default:
        tips = [
          'Check WiFi/Mobile data is ON',
          'Restart your router',
          'Contact your service provider',
        ];
    }

    return tips
        .map(
          (tip) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  IconData _getConnectionIcon(ConnectionType type) {
    switch (type) {
      case ConnectionType.wifi:
        return Icons.wifi_off_rounded;
      case ConnectionType.mobile:
        return Icons.signal_cellular_off;
      case ConnectionType.ethernet:
        return Icons.cable;
      case ConnectionType.none:
        return Icons.cloud_off_rounded;
    }
  }

  String _getTitle(ConnectionType type) {
    switch (type) {
      case ConnectionType.wifi:
        return 'WiFi Disconnected';
      case ConnectionType.mobile:
        return 'Mobile Data Off';
      case ConnectionType.ethernet:
        return 'Ethernet Disconnected';
      case ConnectionType.none:
      default:
        return 'No Internet Connection';
    }
  }

  Color _getConnectionColor(ConnectionType type) {
    switch (type) {
      case ConnectionType.wifi:
        return Colors.orange.shade700;
      case ConnectionType.mobile:
        return Colors.blue.shade700;
      case ConnectionType.ethernet:
        return Colors.purple.shade700;
      case ConnectionType.none:
      default:
        return Colors.red.shade700;
    }
  }
}

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Obx(() {
      if (networkController.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.red.shade600,
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Check your network settings',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await networkController.checkConnection();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
  final bool showAutoRetry;

  const InitialLoadingScreen({
    super.key,
    this.hasError = false,
    this.errorMessage = '',
    required this.onRetry,
    this.showAutoRetry = true,
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
              showAutoRetry: showAutoRetry,
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
