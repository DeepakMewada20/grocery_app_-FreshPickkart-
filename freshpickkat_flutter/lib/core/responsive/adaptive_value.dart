import 'package:flutter/material.dart';
import 'breakpoints.dart';

class AdaptiveValue<T> {
  final T phone;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const AdaptiveValue({
    required this.phone,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  T resolve(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return resolveForWidth(size);
  }

  T resolveForWidth(double width) {
    if (Breakpoints.isLargeDesktop(width) && largeDesktop != null) return largeDesktop as T;
    if (Breakpoints.isDesktop(width) && desktop != null) return desktop as T;
    if (Breakpoints.isTablet(width) && tablet != null) return tablet as T;
    return phone;
  }

  T compact() {
    return largeDesktop ?? desktop ?? tablet ?? phone;
  }
}
