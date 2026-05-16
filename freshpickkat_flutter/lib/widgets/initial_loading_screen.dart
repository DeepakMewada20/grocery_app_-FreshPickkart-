import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/basket_loading_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  const NetworkStatusBanner({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = NetworkController.instance;

    return Obx(() {
      final showBanner = networkController.showBanner.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
            ).animate(animation),
            child: child,
          );
        },
        child: showBanner
            ? Material(
                key: const ValueKey('network_banner_active'),
                type: MaterialType.transparency,
                child: _buildTopBanner(networkController),
              )
            : const SizedBox(
                key: ValueKey('network_banner_hidden'),
                width: double.infinity,
                height: 0,
              ),
      );
    });
  }

  Widget _buildTopBanner(NetworkController controller) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Some features may not work offline',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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

class HomeScreenLoadingSkeleton extends StatefulWidget {
  const HomeScreenLoadingSkeleton({super.key});

  @override
  State<HomeScreenLoadingSkeleton> createState() =>
      _HomeScreenLoadingSkeletonState();
}

class _HomeScreenLoadingSkeletonState extends State<HomeScreenLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFDEE8D9);
    final highlightColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF0F5EE);
    final cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFEFF5EC);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(
                height: MediaQuery.of(context).size.width / 1.2,
                width: double.infinity,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 12),
              _buildHorizontalProductList(
                cardColor: cardColor,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 12),
              _buildHorizontalProductList(
                cardColor: cardColor,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 12),
              _buildProductGrid(
                cardColor: cardColor,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 12),
              _buildProductGrid(
                cardColor: cardColor,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox({
    required double height,
    required double width,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Container(color: baseColor),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      height: 24,
      width: 150,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Container(color: baseColor),
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList({
    required Color cardColor,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: EdgeInsets.only(right: index < 4 ? 12 : 0),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment(_animation.value - 1, 0),
                            end: Alignment(_animation.value + 1, 0),
                            colors: [baseColor, highlightColor, baseColor],
                            stops: const [0.0, 0.5, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Container(color: baseColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment(_animation.value - 1, 0),
                                end: Alignment(_animation.value + 1, 0),
                                colors: [baseColor, highlightColor, baseColor],
                                stops: const [0.0, 0.5, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcIn,
                            child: Container(color: baseColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: 40,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment(_animation.value - 1, 0),
                                end: Alignment(_animation.value + 1, 0),
                                colors: [baseColor, highlightColor, baseColor],
                                stops: const [0.0, 0.5, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcIn,
                            child: Container(color: baseColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid({
    required Color cardColor,
    required Color baseColor,
    required Color highlightColor,
  }) {
    Widget shimmerBox({
      double? height,
      double? width,
      BorderRadius? borderRadius,
    }) {
      final radius = borderRadius ?? BorderRadius.circular(4.r);
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: baseColor, borderRadius: radius),
        child: ClipRRect(
          borderRadius: radius,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(_animation.value - 1, 0),
                end: Alignment(_animation.value + 1, 0),
                colors: [baseColor, highlightColor, baseColor],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Container(color: baseColor),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: AppResponsive.productGridDelegate(
            context,
            constraints.maxWidth,
            dense: true,
            spacing: 8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: shimmerBox(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(6.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(height: 8.h, width: 50.w),
                          SizedBox(height: 4.h),
                          shimmerBox(height: 6.h, width: 30.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class InitialLoadingScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final bool useHomeScreenSkeleton;

  const InitialLoadingScreen({
    super.key,
    required this.onRetry,
    this.useHomeScreenSkeleton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useHomeScreenSkeleton) {
      return const SliverToBoxAdapter(
        child: HomeScreenLoadingSkeleton(),
      );
    }

    return const SliverFillRemaining(
      hasScrollBody: false,
      child: GroceryLoadingAnimation(),
    );
  }
}

// Note: _HomeScreenWithSkeleton was removed as it's no longer needed in the sliver architecture.
