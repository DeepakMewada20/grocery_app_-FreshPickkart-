import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AdminAppBarStyle { primary, surface, transparent }

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.style = AdminAppBarStyle.primary,
    this.toolbarHeight,
    this.centerTitle = false,
  });

  final Widget title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final AdminAppBarStyle style;
  final double? toolbarHeight;
  final bool centerTitle;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight((toolbarHeight ?? kToolbarHeight) + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color backgroundColor;
    final Color foregroundColor;

    switch (style) {
      case AdminAppBarStyle.surface:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        break;
      case AdminAppBarStyle.transparent:
        backgroundColor = theme.scaffoldBackgroundColor;
        foregroundColor = colorScheme.onSurface;
        break;
      case AdminAppBarStyle.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
    }

    return AppBar(
      title: title,
      actions: actions,
      bottom: bottom,
      leading: leading,
      toolbarHeight: toolbarHeight ?? 58.h.clamp(54.0, 66.0),
      titleSpacing: 12.w,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: IconThemeData(color: foregroundColor),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
