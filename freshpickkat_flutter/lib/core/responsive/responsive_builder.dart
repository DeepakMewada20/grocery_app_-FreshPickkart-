import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) phone;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;
  final Widget Function(BuildContext context)? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (Breakpoints.isLargeDesktop(width) && largeDesktop != null) {
      return largeDesktop!(context);
    }
    if (Breakpoints.isDesktop(width) && desktop != null) {
      return desktop!(context);
    }
    if (Breakpoints.isTablet(width) && tablet != null) {
      return tablet!(context);
    }
    return phone(context);
  }
}
