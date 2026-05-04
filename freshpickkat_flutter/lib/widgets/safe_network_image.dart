import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = (url ?? '').trim();

    if (effectiveUrl.isEmpty || !effectiveUrl.startsWith('http')) {
      return _buildFallback(context);
    }

    return Image.network(
      effectiveUrl,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildFallback(context),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
    );
  }

  Widget _buildFallback(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: (width != null && width! > 0) ? width! * 0.5 : 24,
          color: isDark ? Colors.white24 : Colors.grey[400],
        ),
      ),
    );
  }
}
